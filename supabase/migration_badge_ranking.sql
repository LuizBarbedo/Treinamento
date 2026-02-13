-- ============================================
-- MIGRATION: Ranking de Badges dos Alunos
-- ============================================
-- Execute este SQL no SQL Editor do Supabase
-- APÓS ter executado as migrations anteriores
-- ============================================

-- Função para calcular o ranking de badges de todos os alunos
-- Pode ser chamada por qualquer usuário autenticado
CREATE OR REPLACE FUNCTION get_badge_ranking()
RETURNS TABLE (
  user_id UUID,
  user_name TEXT,
  badge_count BIGINT
)
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  RETURN QUERY
  WITH
  -- Total de disciplinas na plataforma
  total_disc AS (
    SELECT COUNT(*)::BIGINT AS cnt FROM disciplines
  ),
  -- Contagem de aulas por disciplina
  disc_lesson_counts AS (
    SELECT l.discipline_id, COUNT(*)::BIGINT AS total_lessons
    FROM lessons l
    GROUP BY l.discipline_id
  ),
  -- Progresso por disciplina por usuário
  user_disc_progress AS (
    SELECT lp.user_id, lp.discipline_id, COUNT(DISTINCT lp.lesson_id)::BIGINT AS completed_lessons
    FROM lesson_progress lp
    GROUP BY lp.user_id, lp.discipline_id
  ),
  -- 1. lesson_complete: 1 badge por aula concluída
  b_lesson_complete AS (
    SELECT lp.user_id, COUNT(*)::BIGINT AS cnt
    FROM lesson_progress lp
    GROUP BY lp.user_id
  ),
  -- 2. lesson_quiz_done: 1 badge por quiz de aula respondido
  b_quiz_done AS (
    SELECT lqr.user_id, COUNT(*)::BIGINT AS cnt
    FROM lesson_quiz_results lqr
    GROUP BY lqr.user_id
  ),
  -- 3. lesson_quiz_perfect: 1 badge por quiz de aula com 100%
  b_quiz_perfect AS (
    SELECT lqr.user_id, COUNT(*)::BIGINT AS cnt
    FROM lesson_quiz_results lqr
    WHERE lqr.score = 100
    GROUP BY lqr.user_id
  ),
  -- 4. all_lessons_complete: 1 badge por disciplina com todas as aulas concluídas
  b_all_lessons AS (
    SELECT udp.user_id, COUNT(*)::BIGINT AS cnt
    FROM user_disc_progress udp
    JOIN disc_lesson_counts dlc ON dlc.discipline_id = udp.discipline_id
    WHERE udp.completed_lessons >= dlc.total_lessons AND dlc.total_lessons > 0
    GROUP BY udp.user_id
  ),
  -- 5. final_quiz_complete: 1 badge por quiz geral aprovado (score >= 70)
  b_final_quiz AS (
    SELECT qr.user_id, COUNT(*)::BIGINT AS cnt
    FROM quiz_results qr
    WHERE qr.score >= 70
    GROUP BY qr.user_id
  ),
  -- 6. discipline_complete: 1 badge por disciplina com todas as aulas + quiz geral aprovado
  b_disc_complete AS (
    SELECT udp.user_id, COUNT(*)::BIGINT AS cnt
    FROM user_disc_progress udp
    JOIN disc_lesson_counts dlc ON dlc.discipline_id = udp.discipline_id
    JOIN quiz_results qr ON qr.user_id = udp.user_id AND qr.discipline_id = udp.discipline_id AND qr.score >= 70
    WHERE udp.completed_lessons >= dlc.total_lessons AND dlc.total_lessons > 0
    GROUP BY udp.user_id
  ),
  -- 7. all_disciplines_complete: 1 badge se completou TODAS as disciplinas
  b_all_disc AS (
    SELECT sub.user_id, 1::BIGINT AS cnt
    FROM (
      SELECT udp.user_id
      FROM user_disc_progress udp
      JOIN disc_lesson_counts dlc ON dlc.discipline_id = udp.discipline_id
      JOIN quiz_results qr ON qr.user_id = udp.user_id AND qr.discipline_id = udp.discipline_id AND qr.score >= 70
      WHERE udp.completed_lessons >= dlc.total_lessons AND dlc.total_lessons > 0
      GROUP BY udp.user_id
      HAVING COUNT(DISTINCT udp.discipline_id) >= (SELECT cnt FROM total_disc) AND (SELECT cnt FROM total_disc) > 0
    ) sub
  ),
  -- Unir todos os usuários que têm pelo menos 1 badge
  all_users AS (
    SELECT DISTINCT u_id AS uid FROM (
      SELECT blc.user_id AS u_id FROM b_lesson_complete blc
      UNION SELECT bqd.user_id FROM b_quiz_done bqd
      UNION SELECT bqp.user_id FROM b_quiz_perfect bqp
      UNION SELECT bal.user_id FROM b_all_lessons bal
      UNION SELECT bfq.user_id FROM b_final_quiz bfq
      UNION SELECT bdc.user_id FROM b_disc_complete bdc
      UNION SELECT bad.user_id FROM b_all_disc bad
    ) sub
  )
  SELECT
    au.uid AS user_id,
    COALESCE(u.raw_user_meta_data ->> 'full_name', split_part(u.email::TEXT, '@', 1))::TEXT AS user_name,
    (
      COALESCE(blc.cnt, 0) + COALESCE(bqd.cnt, 0) + COALESCE(bqp.cnt, 0) +
      COALESCE(bal.cnt, 0) + COALESCE(bfq.cnt, 0) + COALESCE(bdc.cnt, 0) + COALESCE(bad.cnt, 0)
    )::BIGINT AS badge_count
  FROM all_users au
  JOIN auth.users u ON u.id = au.uid
  LEFT JOIN b_lesson_complete blc ON blc.user_id = au.uid
  LEFT JOIN b_quiz_done bqd ON bqd.user_id = au.uid
  LEFT JOIN b_quiz_perfect bqp ON bqp.user_id = au.uid
  LEFT JOIN b_all_lessons bal ON bal.user_id = au.uid
  LEFT JOIN b_final_quiz bfq ON bfq.user_id = au.uid
  LEFT JOIN b_disc_complete bdc ON bdc.user_id = au.uid
  LEFT JOIN b_all_disc bad ON bad.user_id = au.uid
  -- Excluir admins e monitores
  WHERE NOT EXISTS (
    SELECT 1 FROM user_roles ur WHERE ur.user_id = au.uid AND ur.role IN ('admin', 'monitor')
  )
  ORDER BY badge_count DESC, user_name ASC
  LIMIT 50;
END;
$$;

-- Permitir que usuários autenticados chamem a função
GRANT EXECUTE ON FUNCTION get_badge_ranking() TO authenticated;
