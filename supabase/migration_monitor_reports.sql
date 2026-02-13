-- ============================================
-- MIGRATION: Relatório de Monitores (Visão Master/Admin)
-- ============================================
-- Execute este SQL no SQL Editor do Supabase
-- APÓS ter executado as migrations anteriores
-- ============================================

-- 1. Função para obter métricas detalhadas de todos os monitores (somente admin)
CREATE OR REPLACE FUNCTION get_monitor_reports()
RETURNS TABLE (
  monitor_id UUID,
  monitor_email TEXT,
  monitor_name TEXT,
  last_sign_in_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ,
  total_students BIGINT,
  total_doubts_received BIGINT,
  doubts_answered BIGINT,
  doubts_resolved BIGINT,
  doubts_pending BIGINT,
  total_replies BIGINT,
  avg_response_hours NUMERIC,
  first_reply_at TIMESTAMPTZ,
  last_reply_at TIMESTAMPTZ
) AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Acesso negado: apenas administradores podem acessar esta função';
  END IF;

  RETURN QUERY
  SELECT
    u.id AS monitor_id,
    u.email::TEXT AS monitor_email,
    COALESCE(u.raw_user_meta_data ->> 'full_name', u.email::TEXT)::TEXT AS monitor_name,
    u.last_sign_in_at,
    u.created_at,
    -- Total de alunos vinculados
    (SELECT COUNT(*) FROM monitor_students ms WHERE ms.monitor_id = u.id) AS total_students,
    -- Total de dúvidas recebidas (de alunos vinculados)
    (SELECT COUNT(*) FROM doubts d
     JOIN monitor_students ms2 ON ms2.student_id = d.user_id AND ms2.monitor_id = u.id
    ) AS total_doubts_received,
    -- Dúvidas respondidas (status = 'answered')
    (SELECT COUNT(*) FROM doubts d
     JOIN monitor_students ms3 ON ms3.student_id = d.user_id AND ms3.monitor_id = u.id
     WHERE d.status = 'answered'
    ) AS doubts_answered,
    -- Dúvidas resolvidas (status = 'resolved')
    (SELECT COUNT(*) FROM doubts d
     JOIN monitor_students ms4 ON ms4.student_id = d.user_id AND ms4.monitor_id = u.id
     WHERE d.status = 'resolved'
    ) AS doubts_resolved,
    -- Dúvidas pendentes (status = 'open')
    (SELECT COUNT(*) FROM doubts d
     JOIN monitor_students ms5 ON ms5.student_id = d.user_id AND ms5.monitor_id = u.id
     WHERE d.status = 'open'
    ) AS doubts_pending,
    -- Total de respostas enviadas pelo monitor
    (SELECT COUNT(*) FROM doubt_replies dr WHERE dr.user_id = u.id) AS total_replies,
    -- Tempo médio de resposta em horas (primeira resposta do monitor por dúvida)
    (SELECT ROUND(AVG(EXTRACT(EPOCH FROM (first_reply.replied_at - first_reply.doubt_created_at)) / 3600)::numeric, 1)
     FROM (
       SELECT DISTINCT ON (dr2.doubt_id)
         dr2.doubt_id,
         d2.created_at AS doubt_created_at,
         dr2.created_at AS replied_at
       FROM doubt_replies dr2
       JOIN doubts d2 ON d2.id = dr2.doubt_id
       JOIN monitor_students ms6 ON ms6.student_id = d2.user_id AND ms6.monitor_id = u.id
       WHERE dr2.user_id = u.id
       ORDER BY dr2.doubt_id, dr2.created_at ASC
     ) AS first_reply
    ) AS avg_response_hours,
    -- Primeira resposta do monitor
    (SELECT MIN(dr3.created_at) FROM doubt_replies dr3 WHERE dr3.user_id = u.id) AS first_reply_at,
    -- Última resposta do monitor
    (SELECT MAX(dr4.created_at) FROM doubt_replies dr4 WHERE dr4.user_id = u.id) AS last_reply_at
  FROM auth.users u
  JOIN user_roles ur ON ur.user_id = u.id AND ur.role = 'monitor'
  ORDER BY monitor_name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Função para obter estatísticas gerais dos monitores (somente admin)
CREATE OR REPLACE FUNCTION get_monitor_overview_stats()
RETURNS JSON AS $$
DECLARE
  result JSON;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Acesso negado: apenas administradores podem acessar esta função';
  END IF;

  SELECT json_build_object(
    'total_monitors', (
      SELECT COUNT(*) FROM user_roles WHERE role = 'monitor'
    ),
    'total_students_assigned', (
      SELECT COUNT(DISTINCT student_id) FROM monitor_students
    ),
    'total_doubts', (
      SELECT COUNT(*) FROM doubts
    ),
    'total_doubts_open', (
      SELECT COUNT(*) FROM doubts WHERE status = 'open'
    ),
    'total_doubts_answered', (
      SELECT COUNT(*) FROM doubts WHERE status = 'answered'
    ),
    'total_doubts_resolved', (
      SELECT COUNT(*) FROM doubts WHERE status = 'resolved'
    ),
    'total_replies', (
      SELECT COUNT(*) FROM doubt_replies dr
      JOIN user_roles ur ON ur.user_id = dr.user_id AND ur.role = 'monitor'
    ),
    'avg_response_hours', (
      SELECT COALESCE(ROUND(AVG(EXTRACT(EPOCH FROM (first_reply.replied_at - first_reply.doubt_created_at)) / 3600)::numeric, 1), 0)
      FROM (
        SELECT DISTINCT ON (dr.doubt_id)
          dr.doubt_id,
          d.created_at AS doubt_created_at,
          dr.created_at AS replied_at
        FROM doubt_replies dr
        JOIN doubts d ON d.id = dr.doubt_id
        JOIN user_roles ur ON ur.user_id = dr.user_id AND ur.role = 'monitor'
        ORDER BY dr.doubt_id, dr.created_at ASC
      ) AS first_reply
    )
  ) INTO result;

  RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Função para obter detalhes das dúvidas de um monitor específico (somente admin)
CREATE OR REPLACE FUNCTION get_monitor_doubts_detail(p_monitor_id UUID)
RETURNS TABLE (
  doubt_id UUID,
  student_name TEXT,
  student_email TEXT,
  discipline_name TEXT,
  doubt_title TEXT,
  doubt_status TEXT,
  doubt_created_at TIMESTAMPTZ,
  reply_count BIGINT,
  last_reply_at TIMESTAMPTZ
) AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Acesso negado: apenas administradores podem acessar esta função';
  END IF;

  RETURN QUERY
  SELECT
    d.id AS doubt_id,
    COALESCE(su.raw_user_meta_data ->> 'full_name', su.email::TEXT)::TEXT AS student_name,
    su.email::TEXT AS student_email,
    COALESCE(disc.name, 'Sem disciplina')::TEXT AS discipline_name,
    d.title AS doubt_title,
    d.status AS doubt_status,
    d.created_at AS doubt_created_at,
    (SELECT COUNT(*) FROM doubt_replies dr WHERE dr.doubt_id = d.id AND dr.user_id = p_monitor_id) AS reply_count,
    (SELECT MAX(dr2.created_at) FROM doubt_replies dr2 WHERE dr2.doubt_id = d.id AND dr2.user_id = p_monitor_id) AS last_reply_at
  FROM doubts d
  JOIN monitor_students ms ON ms.student_id = d.user_id AND ms.monitor_id = p_monitor_id
  JOIN auth.users su ON su.id = d.user_id
  LEFT JOIN disciplines disc ON disc.id = d.discipline_id
  ORDER BY d.created_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
