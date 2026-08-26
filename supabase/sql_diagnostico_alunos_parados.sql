-- ============================================================
-- DIAGNOSTICO: POR QUE OS ALUNOS ESTAO "PARADOS" NUMA DISCIPLINA
-- ============================================================
-- Somente leitura. Nenhum passo altera dados.
-- Rode um PASSO por vez no SQL Editor e cole o resultado.
--
-- CONTEXTO DAS REGRAS (src/pages/Quiz.jsx e Disciplines.jsx):
--  - As disciplinas sao travadas em sequencia: so abre a proxima
--    quem tem user_progress.completed = true na anterior.
--  - Para concluir uma disciplina o aluno precisa:
--      1) completar TODAS as aulas            -> lesson_progress
--      2) fazer o quiz de TODA aula que tem quiz -> lesson_quiz_results
--      3) tirar >= 50% no quiz final          -> quiz_results
--    So no passo 3 e que user_progress.completed vira true.
--  - Um aluno "parado" pode entao ser: aluno inativo de verdade,
--    aluno barrado por uma etapa que ele nao consegue ver, ou
--    inconsistencia de dados. Os passos abaixo separam os casos.
-- ============================================================


-- ============================================================
-- PASSO 1 - SAUDE DAS DISCIPLINAS (o gargalo pode ser do conteudo)
-- ============================================================
-- Olhe a linha da disciplina 3 (coluna pos = 3).
--   aulas                  = quantas aulas a disciplina tem
--   aulas_com_quiz         = quantas dessas exigem quiz de aula
--   questoes_quiz_final    = se for 0, NAO existe quiz final
--   aula_mais_nova         = se for recente, aulas foram adicionadas
--                            depois e "desconcluiram" quem ja tinha feito
--
-- Sinais de problema:
--   * questoes_quiz_final = 0  -> ninguem consegue concluir pelo quiz;
--     a conclusao so acontece pela auto-conclusao (Quiz.jsx:72), que
--     exige que o aluno ABRA a tela do quiz pelo menos uma vez.
--   * aulas_com_quiz < aulas   -> ok, aula sem quiz e concluida direto.
--   * alguma aula com 1 ou 2 questoes -> ver PASSO 1b.

SELECT
  row_number() OVER (ORDER BY d.order_index, d.created_at)          AS pos,
  d.order_index,
  d.name                                                            AS disciplina,
  (SELECT count(*) FROM lessons l WHERE l.discipline_id = d.id)     AS aulas,
  (SELECT count(DISTINCT q.lesson_id) FROM quiz_questions q
    WHERE q.discipline_id = d.id AND q.lesson_id IS NOT NULL)       AS aulas_com_quiz,
  (SELECT count(*) FROM quiz_questions q
    WHERE q.discipline_id = d.id AND q.lesson_id IS NULL)           AS questoes_quiz_final,
  (SELECT max(l.created_at)::DATE FROM lessons l
    WHERE l.discipline_id = d.id)                                   AS aula_mais_nova,
  (SELECT count(*) FROM user_progress up
    WHERE up.discipline_id = d.id AND up.completed)                 AS alunos_concluiram
FROM disciplines d
ORDER BY d.order_index, d.created_at;


-- ============================================================
-- PASSO 1b - AULAS DA DISCIPLINA 3 (troque a posicao se precisar)
-- ============================================================
-- Mostra aula a aula quantas questoes de quiz existem e quantos
-- alunos concluiram / fizeram o quiz. Uma aula com muito menos
-- conclusoes que a anterior e o ponto exato onde a fila trava.

WITH disc AS (
  SELECT d.id, d.name,
         row_number() OVER (ORDER BY d.order_index, d.created_at) AS pos
    FROM disciplines d
),
alvo AS (SELECT id, name FROM disc WHERE pos = 3)   -- <<< POSICAO ALVO
SELECT
  l.order_index                                                     AS ordem,
  l.title                                                           AS aula,
  (SELECT count(*) FROM quiz_questions q WHERE q.lesson_id = l.id)  AS questoes_quiz,
  (SELECT count(*) FROM lesson_progress lp WHERE lp.lesson_id = l.id)      AS alunos_concluiram_aula,
  (SELECT count(*) FROM lesson_quiz_results r WHERE r.lesson_id = l.id)    AS alunos_fizeram_quiz,
  (SELECT count(*) FROM lesson_quiz_results r
    WHERE r.lesson_id = l.id AND r.passed)                          AS alunos_passaram_quiz,
  (l.video_url IS NULL OR l.video_url = '')                         AS sem_video
FROM lessons l
JOIN alvo a ON a.id = l.discipline_id
ORDER BY l.order_index;


-- ============================================================
-- PASSO 2 - PANORAMA: ONDE CADA ALUNO ESTA PARADO
-- ============================================================
-- "disciplina atual" = a primeira disciplina (na ordem) que o aluno
-- ainda NAO concluiu. Como o acesso e sequencial, e exatamente a
-- unica que ele consegue abrir hoje.

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
  SELECT u.id
    FROM auth.users u
    LEFT JOIN public.user_roles ur ON ur.user_id = u.id
   WHERE u.email IS NOT NULL
     AND u.deleted_at IS NULL
     AND COALESCE(ur.role, 'sem_role') NOT IN ('monitor', 'admin')
     AND lower(u.email) NOT IN (SELECT email FROM excluidos)
),
disc AS (
  SELECT d.id, d.name,
         row_number() OVER (ORDER BY d.order_index, d.created_at) AS pos
    FROM disciplines d
),
atual AS (
  SELECT a.id AS user_id, min(dd.pos) AS pos_atual
    FROM alunos a
    CROSS JOIN disc dd
    LEFT JOIN user_progress up
           ON up.user_id = a.id AND up.discipline_id = dd.id AND up.completed
   WHERE up.user_id IS NULL
   GROUP BY a.id
)
SELECT
  COALESCE(dd.pos::TEXT, '-')                       AS disciplina_atual,
  COALESCE(dd.name, 'CONCLUIU TODAS')               AS disciplina,
  count(*)                                          AS alunos,
  round(100.0 * count(*) / (SELECT count(*) FROM alunos), 1) AS pct
  FROM alunos a
  LEFT JOIN atual t ON t.user_id = a.id
  LEFT JOIN disc  dd ON dd.pos = t.pos_atual
 GROUP BY dd.pos, dd.name
 ORDER BY dd.pos NULLS LAST;


-- ============================================================
-- PASSO 3 - O DIAGNOSTICO: POR QUE CADA UM ESTA PARADO NA 3
-- ============================================================
-- Uma linha por aluno parado na disciplina de posicao 3, com o
-- motivo classificado. Este e o resultado principal para colar.
--
-- LEITURA DA COLUNA motivo:
--   NUNCA ABRIU ............ zero atividade na disciplina (aluno inativo)
--   PAROU NAS AULAS ........ comecou as aulas e nao terminou
--   FALTA QUIZ DE AULA ..... viu todas as aulas mas nao fez algum quiz de aula
--   NAO FEZ O QUIZ FINAL ... liberado para o quiz final e nao fez
--   REPROVADO NO FINAL ..... fez o quiz final e tirou < 50%
--   !! BUG: APROVADO SEM CONCLUIR ... tirou >= 50% mas continua travado
--   !! BUG: SEM QUIZ FINAL CADASTRADO ... terminou tudo e nao ha quiz para fazer
--
-- Se aparecerem muitos "!! BUG" ou muitos "NUNCA ABRIU" com
-- ultimo_login recente, o problema NAO e o aluno.

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
  SELECT u.id,
         COALESCE(u.raw_user_meta_data ->> 'full_name', u.email) AS nome,
         u.email,
         u.last_sign_in_at
    FROM auth.users u
    LEFT JOIN public.user_roles ur ON ur.user_id = u.id
   WHERE u.email IS NOT NULL
     AND u.deleted_at IS NULL
     AND COALESCE(ur.role, 'sem_role') NOT IN ('monitor', 'admin')
     AND lower(u.email) NOT IN (SELECT email FROM excluidos)
),
disc AS (
  SELECT d.id, d.name,
         row_number() OVER (ORDER BY d.order_index, d.created_at) AS pos
    FROM disciplines d
),
alvo AS (SELECT id, name FROM disc WHERE pos = 3),   -- <<< POSICAO ALVO
atual AS (
  SELECT a.id AS user_id, min(dd.pos) AS pos_atual
    FROM alunos a
    CROSS JOIN disc dd
    LEFT JOIN user_progress up
           ON up.user_id = a.id AND up.discipline_id = dd.id AND up.completed
   WHERE up.user_id IS NULL
   GROUP BY a.id
),
parados AS (
  SELECT a.* FROM alunos a JOIN atual t ON t.user_id = a.id AND t.pos_atual = 3
),
cfg AS (
  SELECT
    (SELECT id FROM alvo)                                              AS disc_id,
    (SELECT count(*) FROM lessons l WHERE l.discipline_id = (SELECT id FROM alvo)) AS aulas_total,
    (SELECT count(DISTINCT q.lesson_id) FROM quiz_questions q
      WHERE q.discipline_id = (SELECT id FROM alvo) AND q.lesson_id IS NOT NULL)   AS aulas_com_quiz,
    (SELECT count(*) FROM quiz_questions q
      WHERE q.discipline_id = (SELECT id FROM alvo) AND q.lesson_id IS NULL)       AS questoes_final
),
metricas AS (
  SELECT
    p.nome, p.email, p.last_sign_in_at,
    c.aulas_total, c.aulas_com_quiz, c.questoes_final,
    -- aulas concluidas: join por lessons, nao pela coluna discipline_id,
    -- para nao esconder linhas com discipline_id errado/nulo
    (SELECT count(*) FROM lesson_progress lp
       JOIN lessons l ON l.id = lp.lesson_id
      WHERE lp.user_id = p.id AND l.discipline_id = c.disc_id)         AS aulas_feitas,
    (SELECT count(DISTINCT r.lesson_id) FROM lesson_quiz_results r
       JOIN lessons l ON l.id = r.lesson_id
      WHERE r.user_id = p.id AND l.discipline_id = c.disc_id
        AND EXISTS (SELECT 1 FROM quiz_questions q WHERE q.lesson_id = r.lesson_id)) AS quiz_aula_feitos,
    (SELECT qr.score FROM quiz_results qr
      WHERE qr.user_id = p.id AND qr.discipline_id = c.disc_id)        AS nota_final,
    GREATEST(
      COALESCE((SELECT max(lp.completed_at) FROM lesson_progress lp
                  JOIN lessons l ON l.id = lp.lesson_id
                 WHERE lp.user_id = p.id AND l.discipline_id = c.disc_id), '-infinity'::TIMESTAMPTZ),
      COALESCE((SELECT max(r.completed_at) FROM lesson_quiz_results r
                  JOIN lessons l ON l.id = r.lesson_id
                 WHERE r.user_id = p.id AND l.discipline_id = c.disc_id), '-infinity'::TIMESTAMPTZ),
      COALESCE((SELECT max(qr.completed_at) FROM quiz_results qr
                 WHERE qr.user_id = p.id AND qr.discipline_id = c.disc_id), '-infinity'::TIMESTAMPTZ)
    )                                                                  AS ultima_atividade_disc
  FROM parados p CROSS JOIN cfg c
)
SELECT
  nome,
  email,
  aulas_feitas || '/' || aulas_total          AS aulas,
  quiz_aula_feitos || '/' || aulas_com_quiz   AS quizzes_de_aula,
  COALESCE(nota_final::TEXT, '-')             AS nota_quiz_final,
  CASE
    WHEN nota_final >= 50
      THEN '!! BUG: APROVADO SEM CONCLUIR'
    WHEN nota_final IS NOT NULL
      THEN 'REPROVADO NO FINAL'
    WHEN aulas_feitas >= aulas_total AND quiz_aula_feitos >= aulas_com_quiz AND questoes_final = 0
      THEN '!! BUG: SEM QUIZ FINAL CADASTRADO'
    WHEN aulas_feitas >= aulas_total AND quiz_aula_feitos >= aulas_com_quiz
      THEN 'NAO FEZ O QUIZ FINAL'
    WHEN aulas_feitas >= aulas_total
      THEN 'FALTA QUIZ DE AULA'
    WHEN aulas_feitas > 0
      THEN 'PAROU NAS AULAS'
    ELSE 'NUNCA ABRIU'
  END                                         AS motivo,
  CASE WHEN ultima_atividade_disc = '-infinity'::TIMESTAMPTZ
       THEN NULL ELSE ultima_atividade_disc::DATE END AS ultima_atividade,
  last_sign_in_at::DATE                       AS ultimo_login,
  CASE WHEN last_sign_in_at IS NULL THEN 'NUNCA LOGOU' ELSE '' END AS obs
FROM metricas
ORDER BY
  CASE
    WHEN nota_final >= 50 THEN 1
    WHEN aulas_feitas >= aulas_total THEN 2
    WHEN aulas_feitas > 0 THEN 3
    ELSE 4
  END,
  nome
LIMIT 10000;


-- ============================================================
-- PASSO 4 - RESUMO DO PASSO 3 (numeros por motivo)
-- ============================================================
-- Mesma logica do PASSO 3, so que agregada. Se voce quiser colar
-- so uma coisa, cole esta e a do PASSO 2.

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
  SELECT u.id, u.last_sign_in_at
    FROM auth.users u
    LEFT JOIN public.user_roles ur ON ur.user_id = u.id
   WHERE u.email IS NOT NULL AND u.deleted_at IS NULL
     AND COALESCE(ur.role, 'sem_role') NOT IN ('monitor', 'admin')
     AND lower(u.email) NOT IN (SELECT email FROM excluidos)
),
disc AS (
  SELECT d.id, row_number() OVER (ORDER BY d.order_index, d.created_at) AS pos
    FROM disciplines d
),
alvo AS (SELECT id FROM disc WHERE pos = 3),         -- <<< POSICAO ALVO
atual AS (
  SELECT a.id AS user_id, min(dd.pos) AS pos_atual
    FROM alunos a CROSS JOIN disc dd
    LEFT JOIN user_progress up
           ON up.user_id = a.id AND up.discipline_id = dd.id AND up.completed
   WHERE up.user_id IS NULL
   GROUP BY a.id
),
cfg AS (
  SELECT (SELECT id FROM alvo) AS disc_id,
    (SELECT count(*) FROM lessons l WHERE l.discipline_id = (SELECT id FROM alvo)) AS aulas_total,
    (SELECT count(DISTINCT q.lesson_id) FROM quiz_questions q
      WHERE q.discipline_id = (SELECT id FROM alvo) AND q.lesson_id IS NOT NULL)   AS aulas_com_quiz,
    (SELECT count(*) FROM quiz_questions q
      WHERE q.discipline_id = (SELECT id FROM alvo) AND q.lesson_id IS NULL)       AS questoes_final
),
metricas AS (
  SELECT
    (SELECT count(*) FROM lesson_progress lp JOIN lessons l ON l.id = lp.lesson_id
      WHERE lp.user_id = a.id AND l.discipline_id = c.disc_id) AS aulas_feitas,
    (SELECT count(DISTINCT r.lesson_id) FROM lesson_quiz_results r
       JOIN lessons l ON l.id = r.lesson_id
      WHERE r.user_id = a.id AND l.discipline_id = c.disc_id
        AND EXISTS (SELECT 1 FROM quiz_questions q WHERE q.lesson_id = r.lesson_id)) AS quiz_aula_feitos,
    (SELECT qr.score FROM quiz_results qr
      WHERE qr.user_id = a.id AND qr.discipline_id = c.disc_id) AS nota_final,
    c.aulas_total, c.aulas_com_quiz, c.questoes_final
  FROM alunos a
  JOIN atual t ON t.user_id = a.id AND t.pos_atual = 3
  CROSS JOIN cfg c
)
SELECT
  CASE
    WHEN nota_final >= 50 THEN '!! BUG: APROVADO SEM CONCLUIR'
    WHEN nota_final IS NOT NULL THEN 'REPROVADO NO FINAL'
    WHEN aulas_feitas >= aulas_total AND quiz_aula_feitos >= aulas_com_quiz AND questoes_final = 0
      THEN '!! BUG: SEM QUIZ FINAL CADASTRADO'
    WHEN aulas_feitas >= aulas_total AND quiz_aula_feitos >= aulas_com_quiz THEN 'NAO FEZ O QUIZ FINAL'
    WHEN aulas_feitas >= aulas_total THEN 'FALTA QUIZ DE AULA'
    WHEN aulas_feitas > 0 THEN 'PAROU NAS AULAS'
    ELSE 'NUNCA ABRIU'
  END                       AS motivo,
  count(*)                  AS alunos,
  min(aulas_feitas)         AS min_aulas_feitas,
  max(aulas_feitas)         AS max_aulas_feitas,
  max(aulas_total)          AS aulas_na_disciplina
FROM metricas
GROUP BY 1
ORDER BY alunos DESC;


-- ============================================================
-- PASSO 5 - CACADORES DE INCONSISTENCIA (tudo aqui deveria vir vazio)
-- ============================================================

-- 5.1 Aprovados no quiz final (>= 50%) que NAO estao marcados como
--     concluidos. Se vier gente aqui, o backfill
--     (migration_backfill_completed_from_quiz.sql) precisa rodar de novo
--     e esses alunos estao travados sem culpa.
SELECT d.name AS disciplina, u.email, qr.score, qr.completed_at::DATE
  FROM quiz_results qr
  JOIN auth.users u   ON u.id = qr.user_id
  JOIN disciplines d  ON d.id = qr.discipline_id
  LEFT JOIN user_progress up
         ON up.user_id = qr.user_id AND up.discipline_id = qr.discipline_id
 WHERE qr.score >= 50
   AND COALESCE(up.completed, FALSE) = FALSE
 ORDER BY d.order_index, u.email;

-- 5.2 Linhas de progresso com discipline_id divergente do da aula.
--     A tela filtra por discipline_id; se ele estiver errado, o aluno
--     "perde" aulas ja feitas e trava sem motivo.
SELECT 'lesson_progress' AS tabela, count(*) AS linhas_divergentes
  FROM lesson_progress lp JOIN lessons l ON l.id = lp.lesson_id
 WHERE lp.discipline_id IS DISTINCT FROM l.discipline_id
UNION ALL
SELECT 'lesson_quiz_results', count(*)
  FROM lesson_quiz_results r JOIN lessons l ON l.id = r.lesson_id
 WHERE r.discipline_id IS DISTINCT FROM l.discipline_id;

-- 5.3 Alunos com atividade numa disciplina POSTERIOR a que esta travada.
--     Nao deveria existir: significa que a disciplina foi concluida e
--     depois "desconcluida" (ex.: aula nova adicionada) ou que o
--     travamento sequencial foi contornado.
WITH disc AS (
  SELECT d.id, d.name, row_number() OVER (ORDER BY d.order_index, d.created_at) AS pos
    FROM disciplines d
),
ativ AS (
  SELECT lp.user_id, l.discipline_id FROM lesson_progress lp JOIN lessons l ON l.id = lp.lesson_id
  UNION
  SELECT qr.user_id, qr.discipline_id FROM quiz_results qr
),
atual AS (
  SELECT u.id AS user_id, min(dd.pos) AS pos_atual
    FROM auth.users u CROSS JOIN disc dd
    LEFT JOIN user_progress up ON up.user_id = u.id AND up.discipline_id = dd.id AND up.completed
   WHERE u.deleted_at IS NULL AND up.user_id IS NULL
   GROUP BY u.id
)
SELECT u.email, t.pos_atual AS travado_na_pos, dd.pos AS tem_atividade_na_pos, dd.name
  FROM ativ a
  JOIN atual t ON t.user_id = a.user_id
  JOIN disc dd ON dd.id = a.discipline_id
  JOIN auth.users u ON u.id = a.user_id
 WHERE dd.pos > t.pos_atual
 ORDER BY t.pos_atual, u.email;

-- 5.4 Quizzes de aula onde o aluno FEZ mas nao passou (< 2/3) e nunca
--     mais voltou. Sao os "parados" mais legitimos - mas se a taxa de
--     reprovacao de uma aula for muito alta, o problema e a questao.
SELECT d.name AS disciplina, l.title AS aula,
       count(*) FILTER (WHERE r.passed)     AS passaram,
       count(*) FILTER (WHERE NOT r.passed) AS reprovaram,
       round(100.0 * count(*) FILTER (WHERE NOT r.passed) / NULLIF(count(*), 0), 1) AS pct_reprovacao
  FROM lesson_quiz_results r
  JOIN lessons l     ON l.id = r.lesson_id
  JOIN disciplines d ON d.id = l.discipline_id
 GROUP BY d.order_index, d.name, l.order_index, l.title
HAVING count(*) > 0
 ORDER BY pct_reprovacao DESC NULLS LAST, d.order_index, l.order_index
 LIMIT 50;
