-- ============================================================
-- EXPORTAR PLANILHA COMPLETA: ALUNOS E MONITORES
-- ============================================================
-- Somente leitura. Nenhuma query altera dados.
--
-- Uso: cole no SQL Editor do Supabase, rode a QUERY 1 e clique
-- em "Download CSV" no painel de resultados. O CSV abre direto
-- no Excel / Google Sheets.
--
-- A QUERY 1 traz TODO MUNDO (alunos, monitores e admins) numa
-- unica planilha, uma linha por pessoa. As queries seguintes
-- sao recortes opcionais (so alunos, so monitores, resumo).
--
-- Colunas de progresso seguem as regras da plataforma:
--   lesson_progress      -> aulas concluidas
--   lesson_quiz_results  -> quizzes de aula feitos
--   quiz_results         -> quiz final por disciplina
--   user_progress        -> disciplina concluida (completed)
-- ============================================================


-- ============================================================
-- QUERY 0 - LISTA SIMPLES: NOME + EMAIL (alunos e monitores)
-- ============================================================
-- A planilha enxuta: tres colunas, uma linha por pessoa.
-- Monitores primeiro, depois os alunos, em ordem alfabetica.
-- Admins ficam de fora (tire a linha do NOT IN para incluir).

SELECT
  CASE COALESCE(ur.role, 'user')
    WHEN 'monitor' THEN 'Monitor'
    ELSE 'Aluno'
  END                                                        AS tipo,
  COALESCE(NULLIF(u.raw_user_meta_data ->> 'full_name', ''),
           split_part(u.email, '@', 1))                      AS nome,
  lower(u.email)                                             AS email
FROM auth.users u
LEFT JOIN public.user_roles ur ON ur.user_id = u.id
WHERE u.email IS NOT NULL
  AND u.deleted_at IS NULL
  AND COALESCE(ur.role, 'user') <> 'admin'
ORDER BY
  CASE COALESCE(ur.role, 'user') WHEN 'monitor' THEN 1 ELSE 2 END,
  nome;


-- ============================================================
-- QUERY 1 - PLANILHA PRINCIPAL (alunos + monitores + admins)
-- ============================================================

WITH pessoas AS (
  SELECT
    u.id,
    COALESCE(u.raw_user_meta_data ->> 'full_name', '')  AS nome,
    lower(u.email)                                      AS email,
    COALESCE(ur.role, 'user')                           AS role,
    COALESCE(ur.access_level::TEXT, 'basico')           AS nivel_acesso,
    COALESCE(ur.full_access, FALSE)                     AS acesso_total,
    u.created_at,
    u.last_sign_in_at,
    u.email_confirmed_at,
    COALESCE((u.raw_user_meta_data ->> 'must_reset_password')::BOOLEAN, FALSE) AS deve_trocar_senha
  FROM auth.users u
  LEFT JOIN public.user_roles ur ON ur.user_id = u.id
  WHERE u.email IS NOT NULL
    AND u.deleted_at IS NULL
),
total_disc AS (
  SELECT count(*) AS n FROM public.disciplines
)
SELECT
  CASE p.role
    WHEN 'admin'   THEN 'Admin'
    WHEN 'monitor' THEN 'Monitor'
    ELSE 'Aluno'
  END                                                           AS tipo,
  p.nome,
  p.email,
  p.nivel_acesso,
  p.acesso_total,

  -- Monitor do aluno (vazio para monitores/admins).
  -- Se por acaso houver mais de um vinculo, saem separados por "; ".
  (SELECT string_agg(
            COALESCE(mu.raw_user_meta_data ->> 'full_name', mu.email), '; '
            ORDER BY COALESCE(mu.raw_user_meta_data ->> 'full_name', mu.email))
     FROM public.monitor_students ms
     JOIN auth.users mu ON mu.id = ms.monitor_id AND mu.deleted_at IS NULL
    WHERE ms.student_id = p.id)                                 AS monitor_responsavel,

  (SELECT string_agg(lower(mu.email), '; ' ORDER BY lower(mu.email))
     FROM public.monitor_students ms
     JOIN auth.users mu ON mu.id = ms.monitor_id AND mu.deleted_at IS NULL
    WHERE ms.student_id = p.id)                                 AS monitor_email,

  -- Quantos alunos este monitor tem (0 para alunos).
  (SELECT count(*)
     FROM public.monitor_students ms
     JOIN auth.users su ON su.id = ms.student_id AND su.deleted_at IS NULL
    WHERE ms.monitor_id = p.id)                                 AS alunos_sob_monitoria,

  -- Progresso
  (SELECT count(*) FROM public.lesson_progress lp
    WHERE lp.user_id = p.id)                                    AS aulas_concluidas,
  (SELECT count(*) FROM public.lesson_quiz_results r
    WHERE r.user_id = p.id)                                     AS quizzes_aula_feitos,
  (SELECT count(*) FROM public.quiz_results qr
    WHERE qr.user_id = p.id)                                    AS quizzes_finais_feitos,
  (SELECT count(*) FROM public.user_progress up
    WHERE up.user_id = p.id AND up.completed)                   AS disciplinas_concluidas,
  (SELECT n FROM total_disc)                                    AS disciplinas_existentes,

  -- Disciplina em que a pessoa esta hoje = primeira ainda nao concluida.
  -- Vem vazio quando ja concluiu todas.
  (SELECT d.name
     FROM public.disciplines d
     LEFT JOIN public.user_progress up
            ON up.discipline_id = d.id AND up.user_id = p.id
    WHERE COALESCE(up.completed, FALSE) = FALSE
    ORDER BY d.order_index, d.created_at
    LIMIT 1)                                                    AS disciplina_atual,

  -- Datas (formato AAAA-MM-DD para o Excel reconhecer)
  p.created_at::DATE                                            AS cadastrado_em,
  p.last_sign_in_at::DATE                                       AS ultimo_login,
  (p.email_confirmed_at IS NOT NULL)                            AS email_confirmado,
  p.deve_trocar_senha,
  (SELECT max(lp.completed_at)::DATE FROM public.lesson_progress lp
    WHERE lp.user_id = p.id)                                    AS ultima_aula_concluida_em,
  CASE
    WHEN p.last_sign_in_at IS NULL THEN 'Nunca acessou'
    ELSE (CURRENT_DATE - p.last_sign_in_at::DATE)::TEXT || ' dias'
  END                                                           AS dias_sem_acessar,
  p.id                                                          AS user_id
FROM pessoas p
ORDER BY
  CASE p.role WHEN 'admin' THEN 1 WHEN 'monitor' THEN 2 ELSE 3 END,
  p.nome NULLS LAST,
  p.email;


-- ============================================================
-- QUERY 2 (opcional) - SOMENTE ALUNOS
-- ============================================================
-- Mesma planilha da QUERY 1 sem monitores e admins. Basta
-- acrescentar o filtro abaixo ao final da QUERY 1:
--
--   FROM pessoas p
--   WHERE p.role NOT IN ('admin', 'monitor')     <<< linha nova
--   ORDER BY ...


-- ============================================================
-- QUERY 3 (opcional) - SOMENTE MONITORES, COM CARGA DE ALUNOS
-- ============================================================

SELECT
  COALESCE(u.raw_user_meta_data ->> 'full_name', '') AS monitor,
  lower(u.email)                                     AS email,
  (SELECT count(*)
     FROM public.monitor_students ms
     JOIN auth.users su ON su.id = ms.student_id AND su.deleted_at IS NULL
    WHERE ms.monitor_id = u.id)                      AS alunos,
  u.created_at::DATE                                 AS cadastrado_em,
  u.last_sign_in_at::DATE                            AS ultimo_login
FROM auth.users u
JOIN public.user_roles ur ON ur.user_id = u.id
WHERE ur.role = 'monitor'
  AND u.deleted_at IS NULL
ORDER BY alunos DESC, monitor;


-- ============================================================
-- QUERY 4 (opcional) - CONFERENCIA DOS TOTAIS
-- ============================================================
-- Rode antes de enviar a planilha: o total daqui tem que bater
-- com a contagem de linhas do CSV da QUERY 1.

SELECT
  count(*) FILTER (WHERE COALESCE(ur.role, 'user') = 'admin')   AS admins,
  count(*) FILTER (WHERE COALESCE(ur.role, 'user') = 'monitor') AS monitores,
  count(*) FILTER (WHERE COALESCE(ur.role, 'user') = 'user')    AS alunos,
  count(*)                                                      AS total_pessoas,
  count(*) FILTER (WHERE u.last_sign_in_at IS NULL)             AS nunca_acessaram
FROM auth.users u
LEFT JOIN public.user_roles ur ON ur.user_id = u.id
WHERE u.email IS NOT NULL
  AND u.deleted_at IS NULL;
