-- ============================================================
-- ALUNOS SEM MONITOR VINCULADO
-- ============================================================
-- Somente leitura.
-- A distribuicao (sql_distribuicao_alunos_monitores.sql) foi feita
-- para 388 alunos. Quem foi cadastrado DEPOIS dela nao recebeu
-- monitor automaticamente - este script encontra essas pessoas.
-- ============================================================


-- ============================================================
-- QUERY 1 - RESUMO
-- ============================================================

WITH excluidos(email) AS (VALUES
  ('deborat@id.uff.br'),('elisabete.souza@portosrio.gov.br'),
  ('aramis.junior@portosrio.gov.br'),('fernanda.sasaoka@portosrio.gov.br'),
  ('flavio.vieira@portosrio.gov.br'),('renan.almeida@portosrio.gov.br'),
  ('francisco.diogo@portosrio.gov.br'),('fagner.dias@portosrio.gov.br'),
  ('fvergueiro@id.uff.br'),('ramalhomarcusantonio@gmail.com'),
  ('ecamilo@id.uff.br'),('ricardo.ganem@portosrio.gov.br'),
  ('mfreitas@ivig.coppe.ufrj.br'),('deboramellocamilo@gmail.com'),
  ('nextmetal@gmail.com'),('rodnramos@gmail.com'),('eduardofelipe@gmail.com'),
  ('aureliomurtacopy@gmail.com'),('nextmarte@hotmail.com'),
  ('barbedoluiz@gmail.com'),('aplicacao.treinamento@gmail.com'),
  ('barbedoluizfelipe@gmail.com'),('eliasbrito123@gmail.com')
),
alunos AS (
  SELECT u.id, u.email
    FROM auth.users u
    LEFT JOIN public.user_roles ur ON ur.user_id = u.id
   WHERE u.email IS NOT NULL
     AND u.deleted_at IS NULL
     AND COALESCE(ur.role, 'aluno') NOT IN ('monitor', 'admin')
     AND lower(u.email) NOT IN (SELECT email FROM excluidos)
)
SELECT
  (SELECT count(*) FROM alunos)                                        AS total_alunos,
  (SELECT count(*) FROM alunos a
    WHERE EXISTS (SELECT 1 FROM monitor_students ms WHERE ms.student_id = a.id)) AS com_monitor,
  (SELECT count(*) FROM alunos a
    WHERE NOT EXISTS (SELECT 1 FROM monitor_students ms WHERE ms.student_id = a.id)) AS sem_monitor,
  (SELECT count(*) FROM monitor_students)                              AS total_vinculos,
  (SELECT count(DISTINCT ms.monitor_id) FROM monitor_students ms)      AS monitores_com_alunos;


-- ============================================================
-- QUERY 2 - QUEM SAO OS ALUNOS SEM MONITOR
-- ============================================================
-- criado_em ajuda a confirmar a causa: se todos forem posteriores
-- a data da distribuicao, foram cadastrados depois dela.

WITH excluidos(email) AS (VALUES
  ('deborat@id.uff.br'),('elisabete.souza@portosrio.gov.br'),
  ('aramis.junior@portosrio.gov.br'),('fernanda.sasaoka@portosrio.gov.br'),
  ('flavio.vieira@portosrio.gov.br'),('renan.almeida@portosrio.gov.br'),
  ('francisco.diogo@portosrio.gov.br'),('fagner.dias@portosrio.gov.br'),
  ('fvergueiro@id.uff.br'),('ramalhomarcusantonio@gmail.com'),
  ('ecamilo@id.uff.br'),('ricardo.ganem@portosrio.gov.br'),
  ('mfreitas@ivig.coppe.ufrj.br'),('deboramellocamilo@gmail.com'),
  ('nextmetal@gmail.com'),('rodnramos@gmail.com'),('eduardofelipe@gmail.com'),
  ('aureliomurtacopy@gmail.com'),('nextmarte@hotmail.com'),
  ('barbedoluiz@gmail.com'),('aplicacao.treinamento@gmail.com'),
  ('barbedoluizfelipe@gmail.com'),('eliasbrito123@gmail.com')
)
SELECT
  COALESCE(u.raw_user_meta_data ->> 'full_name', '') AS nome,
  u.email,
  COALESCE(ur.role, 'sem_role')                      AS role,
  u.created_at::DATE                                 AS criado_em,
  u.last_sign_in_at::DATE                            AS ultimo_login,
  (SELECT count(*) FROM lesson_progress lp WHERE lp.user_id = u.id) AS aulas_feitas
FROM auth.users u
LEFT JOIN public.user_roles ur ON ur.user_id = u.id
WHERE u.email IS NOT NULL
  AND u.deleted_at IS NULL
  AND COALESCE(ur.role, 'aluno') NOT IN ('monitor', 'admin')
  AND lower(u.email) NOT IN (SELECT email FROM excluidos)
  AND NOT EXISTS (SELECT 1 FROM monitor_students ms WHERE ms.student_id = u.id)
ORDER BY u.created_at DESC, nome;


-- ============================================================
-- QUERY 3 - O INVERSO: MONITORES SEM NENHUM ALUNO
-- ============================================================

SELECT
  COALESCE(u.raw_user_meta_data ->> 'full_name', '') AS monitor,
  u.email,
  u.created_at::DATE                                 AS criado_em
FROM auth.users u
JOIN public.user_roles ur ON ur.user_id = u.id
WHERE ur.role = 'monitor'
  AND u.deleted_at IS NULL
  AND NOT EXISTS (SELECT 1 FROM monitor_students ms WHERE ms.monitor_id = u.id)
ORDER BY monitor;


-- ============================================================
-- QUERY 4 - VINCULOS ORFAOS (aluno ou monitor apagado)
-- ============================================================
-- Deveria vir vazio.

SELECT ms.student_id, ms.monitor_id, ms.assigned_at::DATE,
       (su.id IS NULL) AS aluno_sumiu,
       (mu.id IS NULL) AS monitor_sumiu
FROM monitor_students ms
LEFT JOIN auth.users su ON su.id = ms.student_id AND su.deleted_at IS NULL
LEFT JOIN auth.users mu ON mu.id = ms.monitor_id AND mu.deleted_at IS NULL
WHERE su.id IS NULL OR mu.id IS NULL;
