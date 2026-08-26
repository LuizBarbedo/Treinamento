-- ============================================================
-- CONFIRMACAO DO "DEGRAU" NA DISCIPLINA 3
-- ============================================================
-- Hipotese a testar: as aulas 9-12 de COMUNICACAO NO AMBIENTE DE
-- TRABALHO foram cadastradas DEPOIS que ~443 alunos ja tinham
-- concluido as 8 primeiras, o que reabriu a disciplina para todos
-- eles e travou a fila inteira.
-- Somente leitura.
-- ============================================================


-- ============================================================
-- QUERY A - QUANDO CADA AULA FOI CADASTRADA vs QUANDO FOI FEITA
-- ============================================================
-- Esta e a query decisiva.
--   aula_criada_em     = data de cadastro da aula
--   alunos_fizeram     = quantos fizeram o quiz dessa aula
--   primeira_atividade / ultima_atividade = janela de uso real
--
-- SE a hipotese estiver certa, as aulas 9-12 vao ter
-- aula_criada_em MUITO depois das aulas 1-8, e a ultima_atividade
-- das aulas 1-8 vai ser ANTERIOR a criacao das aulas 9-12.

SELECT
  d.name                                                        AS disciplina,
  l.order_index                                                 AS ordem,
  l.title                                                       AS aula,
  l.created_at                                                  AS aula_criada_em,
  (SELECT count(*) FROM lesson_quiz_results r WHERE r.lesson_id = l.id)  AS alunos_fizeram,
  (SELECT min(r.completed_at)::DATE FROM lesson_quiz_results r WHERE r.lesson_id = l.id) AS primeira_atividade,
  (SELECT max(r.completed_at)::DATE FROM lesson_quiz_results r WHERE r.lesson_id = l.id) AS ultima_atividade,
  (SELECT count(*) FROM quiz_questions q WHERE q.lesson_id = l.id)       AS questoes_quiz,
  (l.video_url IS NULL OR btrim(l.video_url) = '')              AS sem_video
FROM lessons l
JOIN disciplines d ON d.id = l.discipline_id
WHERE d.name ILIKE '%COMUNICA%AMBIENTE%TRABALHO%'
ORDER BY l.order_index;


-- ============================================================
-- QUERY B - OS "50" SAO OS MONITORES?
-- ============================================================
-- Quebra por papel quem fez o quiz de cada aula da disciplina 3.
-- Se a coluna monitores ficar ~50 e alunos despencar para ~0 a
-- partir da aula 9, esta confirmado: nenhum aluno chegou la.

SELECT
  l.order_index                                                       AS ordem,
  l.title                                                             AS aula,
  count(*) FILTER (WHERE COALESCE(ur.role, 'aluno') = 'monitor')      AS monitores,
  count(*) FILTER (WHERE COALESCE(ur.role, 'aluno') = 'admin')        AS admins,
  count(*) FILTER (WHERE COALESCE(ur.role, 'aluno') NOT IN ('monitor', 'admin')) AS alunos
FROM lessons l
JOIN disciplines d          ON d.id = l.discipline_id
LEFT JOIN lesson_quiz_results r ON r.lesson_id = l.id
LEFT JOIN auth.users u          ON u.id = r.user_id
LEFT JOIN public.user_roles ur  ON ur.user_id = u.id
WHERE d.name ILIKE '%COMUNICA%AMBIENTE%TRABALHO%'
GROUP BY l.order_index, l.title
ORDER BY l.order_index;


-- ============================================================
-- QUERY C - PANORAMA DAS DISCIPLINAS (o PASSO 1 do outro arquivo)
-- ============================================================
-- Confirma se existe quiz final cadastrado em cada disciplina e
-- qual a data da aula mais nova de cada uma.

SELECT
  row_number() OVER (ORDER BY d.order_index, d.created_at)          AS pos,
  d.name                                                            AS disciplina,
  (SELECT count(*) FROM lessons l WHERE l.discipline_id = d.id)     AS aulas,
  (SELECT count(DISTINCT q.lesson_id) FROM quiz_questions q
    WHERE q.discipline_id = d.id AND q.lesson_id IS NOT NULL)       AS aulas_com_quiz,
  (SELECT count(*) FROM quiz_questions q
    WHERE q.discipline_id = d.id AND q.lesson_id IS NULL)           AS questoes_quiz_final,
  (SELECT min(l.created_at)::DATE FROM lessons l WHERE l.discipline_id = d.id) AS aula_mais_antiga,
  (SELECT max(l.created_at)::DATE FROM lessons l WHERE l.discipline_id = d.id) AS aula_mais_nova,
  (SELECT count(*) FROM user_progress up
    WHERE up.discipline_id = d.id AND up.completed)                 AS alunos_concluiram
FROM disciplines d
ORDER BY d.order_index, d.created_at;


-- ============================================================
-- QUERY D - DISTRIBUICAO DAS AULAS FEITAS NA DISCIPLINA 3
-- ============================================================
-- Quantos alunos pararam com exatamente N aulas concluidas.
-- Um pico gigante em N = 8 confirma o degrau (todos pararam no
-- mesmo lugar). Uma distribuicao espalhada seria evasao real.

WITH alvo AS (
  SELECT d.id FROM disciplines d
   WHERE d.name ILIKE '%COMUNICA%AMBIENTE%TRABALHO%'
   LIMIT 1
),
alunos AS (
  SELECT u.id
    FROM auth.users u
    LEFT JOIN public.user_roles ur ON ur.user_id = u.id
   WHERE u.email IS NOT NULL
     AND u.deleted_at IS NULL
     AND COALESCE(ur.role, 'aluno') NOT IN ('monitor', 'admin')
),
contagem AS (
  SELECT a.id,
         (SELECT count(*) FROM lesson_progress lp
            JOIN lessons l ON l.id = lp.lesson_id
           WHERE lp.user_id = a.id AND l.discipline_id = (SELECT id FROM alvo)) AS aulas_feitas,
         EXISTS (SELECT 1 FROM quiz_results qr
                  WHERE qr.user_id = a.id AND qr.discipline_id = (SELECT id FROM alvo)) AS fez_quiz_final,
         EXISTS (SELECT 1 FROM user_progress up
                  WHERE up.user_id = a.id AND up.discipline_id = (SELECT id FROM alvo)
                    AND up.completed) AS concluiu
    FROM alunos a
)
SELECT
  aulas_feitas,
  count(*)                                    AS alunos,
  count(*) FILTER (WHERE fez_quiz_final)      AS fizeram_quiz_final,
  count(*) FILTER (WHERE concluiu)            AS marcados_concluido,
  (SELECT count(*) FROM lessons l WHERE l.discipline_id = (SELECT id FROM alvo)) AS aulas_na_disciplina
FROM contagem
GROUP BY aulas_feitas
ORDER BY aulas_feitas;
