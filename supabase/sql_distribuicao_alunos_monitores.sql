-- ============================================================
-- DISTRIBUICAO DE ALUNOS ENTRE MONITORES
-- ============================================================
-- Preenche a tabela monitor_students vinculando cada aluno a um
-- monitor, de forma aleatoria e balanceada (cada monitor recebe
-- a mesma quantidade, com diferenca maxima de 1 aluno).
--
-- FONTE DOS MONITORES: o proprio banco -- user_roles.role = 'monitor'.
-- Nao ha lista de monitores fixa neste script.
--
-- REGRAS APLICADAS:
--  - MONITORES: todos os usuarios ativos com role = 'monitor',
--    tirando os e-mails da lista de excecao abaixo.
--  - EXCECOES (v_excluidos): NAO recebem alunos, NAO viram aluno de
--    ninguem e NENHUM registro existente deles e alterado ou removido.
--  - ALUNOS: todos os demais usuarios ativos de auth.users.
--  - assigned_at recebe a data de criacao das contas envolvidas
--    (o vinculo aparece como existente desde o inicio), nunca a
--    data em que este script for executado.
--
-- Execute cada PASSO separadamente no SQL Editor do Supabase.
-- ============================================================


-- ============================================================
-- PASSO 1 - QUEM SAO OS MONITORES (somente leitura)
-- ============================================================
-- Confira esta lista antes de qualquer outra coisa. Sao exatamente
-- os monitores que vao receber alunos no PASSO 3.
--   alunos_hoje = quantos alunos ja estao vinculados a essa pessoa
--                 (deve ser 0 se a distribuicao nunca foi feita)

SELECT
  row_number() OVER (ORDER BY COALESCE(u.raw_user_meta_data ->> 'full_name', u.email)) AS n,
  COALESCE(u.raw_user_meta_data ->> 'full_name', '')  AS nome,
  u.email,
  ur.cpf,
  u.created_at::DATE                                  AS criado_em,
  (SELECT count(*) FROM monitor_students ms
    WHERE ms.monitor_id = u.id)                       AS alunos_hoje
  FROM auth.users u
  JOIN public.user_roles ur ON ur.user_id = u.id
 WHERE ur.role = 'monitor'
   AND u.email IS NOT NULL
   AND u.deleted_at IS NULL
   AND lower(u.email) <> ALL (ARRAY[
     'deborat@id.uff.br',
     'elisabete.souza@portosrio.gov.br',
     'aramis.junior@portosrio.gov.br',
     'fernanda.sasaoka@portosrio.gov.br',
     'flavio.vieira@portosrio.gov.br',
     'renan.almeida@portosrio.gov.br',
     'francisco.diogo@portosrio.gov.br',
     'fagner.dias@portosrio.gov.br',
     'fvergueiro@id.uff.br',
     'ramalhomarcusantonio@gmail.com',
     'ecamilo@id.uff.br',
     'ricardo.ganem@portosrio.gov.br',
     'mfreitas@ivig.coppe.ufrj.br',
     'deboramellocamilo@gmail.com',
     'nextmetal@gmail.com',
     'rodnramos@gmail.com',
     'eduardofelipe@gmail.com',
     'aureliomurtacopy@gmail.com',
     'nextmarte@hotmail.com',
     'barbedoluiz@gmail.com',
     'aplicacao.treinamento@gmail.com',
     'barbedoluizfelipe@gmail.com',
     'eliasbrito123@gmail.com'
   ])
 ORDER BY nome, u.email
 LIMIT 10000;


-- ============================================================
-- PASSO 2 - CONFERENCIA DOS NUMEROS (somente leitura)
-- ============================================================
-- Esperado: total = 461, monitores = 50, excluidos = 23, alunos = 388.
-- (461 - 50 - 23 = 388)

WITH v_excluidos(email) AS (VALUES
  ('deborat@id.uff.br'),
  ('elisabete.souza@portosrio.gov.br'),
  ('aramis.junior@portosrio.gov.br'),
  ('fernanda.sasaoka@portosrio.gov.br'),
  ('flavio.vieira@portosrio.gov.br'),
  ('renan.almeida@portosrio.gov.br'),
  ('francisco.diogo@portosrio.gov.br'),
  ('fagner.dias@portosrio.gov.br'),
  ('fvergueiro@id.uff.br'),
  ('ramalhomarcusantonio@gmail.com'),
  ('ecamilo@id.uff.br'),
  ('ricardo.ganem@portosrio.gov.br'),
  ('mfreitas@ivig.coppe.ufrj.br'),
  ('deboramellocamilo@gmail.com'),
  ('nextmetal@gmail.com'),
  ('rodnramos@gmail.com'),
  ('eduardofelipe@gmail.com'),
  ('aureliomurtacopy@gmail.com'),
  ('nextmarte@hotmail.com'),
  ('barbedoluiz@gmail.com'),
  ('aplicacao.treinamento@gmail.com'),
  ('barbedoluizfelipe@gmail.com'),
  ('eliasbrito123@gmail.com')
),
base AS (
  SELECT u.id,
         lower(u.email)                    AS email,
         COALESCE(ur.role, 'sem_role')     AS role
    FROM auth.users u
    LEFT JOIN public.user_roles ur ON ur.user_id = u.id
   WHERE u.email IS NOT NULL
     AND u.deleted_at IS NULL
),
elegiveis AS (
  SELECT * FROM base
   WHERE email NOT IN (SELECT email FROM v_excluidos)
)
SELECT
  (SELECT count(*) FROM base)                                          AS total_usuarios,
  (SELECT count(*) FROM elegiveis WHERE role = 'monitor')              AS monitores,
  (SELECT count(*) FROM base b JOIN v_excluidos e ON e.email = b.email) AS excluidos_encontrados,
  (SELECT count(*) FROM v_excluidos)                                   AS excluidos_na_lista,
  (SELECT count(*) FROM elegiveis WHERE role <> 'monitor')             AS alunos_a_distribuir,
  (SELECT count(*) FROM elegiveis WHERE role = 'admin')                AS admins_entre_os_alunos,
  (SELECT count(*) FROM elegiveis WHERE role = 'sem_role')             AS sem_role_entre_os_alunos;

-- Se `excluidos_encontrados` vier menor que 23, algum e-mail da lista
-- nao existe no banco (nada a fazer - so nao ha o que preservar).
-- Se `admins_entre_os_alunos` for maior que 0, veja quem sao antes de
-- seguir: eles receberiam um monitor.
--
--   SELECT u.email, ur.role FROM auth.users u
--     JOIN public.user_roles ur ON ur.user_id = u.id
--    WHERE ur.role = 'admin' AND u.deleted_at IS NULL;


-- ============================================================
-- PASSO 3 - DISTRIBUICAO
-- ============================================================
-- So rode depois de conferir os PASSOS 1 e 2.
-- Os dois guards abaixo abortam tudo se os numeros nao baterem.

DO $$
DECLARE
  v_excluidos TEXT[] := ARRAY[
    'deborat@id.uff.br',
    'elisabete.souza@portosrio.gov.br',
    'aramis.junior@portosrio.gov.br',
    'fernanda.sasaoka@portosrio.gov.br',
    'flavio.vieira@portosrio.gov.br',
    'renan.almeida@portosrio.gov.br',
    'francisco.diogo@portosrio.gov.br',
    'fagner.dias@portosrio.gov.br',
    'fvergueiro@id.uff.br',
    'ramalhomarcusantonio@gmail.com',
    'ecamilo@id.uff.br',
    'ricardo.ganem@portosrio.gov.br',
    'mfreitas@ivig.coppe.ufrj.br',
    'deboramellocamilo@gmail.com',
    'nextmetal@gmail.com',
    'rodnramos@gmail.com',
    'eduardofelipe@gmail.com',
    'aureliomurtacopy@gmail.com',
    'nextmarte@hotmail.com',
    'barbedoluiz@gmail.com',
    'aplicacao.treinamento@gmail.com',
    'barbedoluizfelipe@gmail.com',
    'eliasbrito123@gmail.com'
  ];
  v_monitores_esperado INT := 50;    -- 0 desliga a checagem
  v_alunos_esperado    INT := 388;   -- 0 desliga a checagem
  v_qtd_monitores INT;
  v_qtd_alunos    INT;
  v_removidos     INT;
  v_inseridos     INT;
BEGIN
  -- ---------- monitores, em ordem aleatoria ----------
  CREATE TEMP TABLE tmp_monitores ON COMMIT DROP AS
  SELECT u.id,
         u.created_at,
         (row_number() OVER (ORDER BY random()) - 1) AS idx
    FROM auth.users u
    JOIN public.user_roles ur ON ur.user_id = u.id
   WHERE ur.role = 'monitor'
     AND u.email IS NOT NULL
     AND u.deleted_at IS NULL
     AND lower(u.email) <> ALL (v_excluidos);

  SELECT count(*) INTO v_qtd_monitores FROM tmp_monitores;

  IF v_qtd_monitores = 0 THEN
    RAISE EXCEPTION 'Nenhum monitor encontrado. Abortando.';
  END IF;

  IF v_monitores_esperado > 0 AND v_qtd_monitores <> v_monitores_esperado THEN
    RAISE EXCEPTION
      'Monitores encontrados: %, esperados: %. Confira o PASSO 1 antes de seguir.',
      v_qtd_monitores, v_monitores_esperado;
  END IF;

  -- ---------- alunos, em ordem aleatoria ----------
  CREATE TEMP TABLE tmp_alunos ON COMMIT DROP AS
  SELECT u.id,
         u.created_at,
         (row_number() OVER (ORDER BY random()) - 1) AS idx
    FROM auth.users u
    LEFT JOIN public.user_roles ur ON ur.user_id = u.id
   WHERE u.email IS NOT NULL
     AND u.deleted_at IS NULL
     AND COALESCE(ur.role, 'sem_role') <> 'monitor'
     AND lower(u.email) <> ALL (v_excluidos);

  SELECT count(*) INTO v_qtd_alunos FROM tmp_alunos;

  IF v_alunos_esperado > 0 AND v_qtd_alunos <> v_alunos_esperado THEN
    RAISE EXCEPTION
      'Alunos encontrados: %, esperados: %. Confira o PASSO 2 antes de seguir.',
      v_qtd_alunos, v_alunos_esperado;
  END IF;

  -- ---------- limpa vinculos antigos SOMENTE destes alunos ----------
  -- Restrito a student_id: qualquer registro envolvendo os e-mails da
  -- lista de excecao permanece intacto.
  DELETE FROM monitor_students ms
   WHERE ms.student_id IN (SELECT id FROM tmp_alunos);
  GET DIAGNOSTICS v_removidos = ROW_COUNT;

  -- ---------- round-robin sobre as duas listas embaralhadas ----------
  INSERT INTO monitor_students (monitor_id, student_id, assigned_at)
  SELECT m.id,
         a.id,
         GREATEST(m.created_at, a.created_at)
    FROM tmp_alunos a
    JOIN tmp_monitores m
      ON m.idx = a.idx % v_qtd_monitores
  ON CONFLICT (monitor_id, student_id) DO NOTHING;
  GET DIAGNOSTICS v_inseridos = ROW_COUNT;

  RAISE NOTICE 'Monitores: %  |  Alunos: %  |  Vinculos antigos removidos: %  |  Vinculos criados: %',
    v_qtd_monitores, v_qtd_alunos, v_removidos, v_inseridos;
  RAISE NOTICE 'Por monitor: entre % e % alunos (media %)',
    v_qtd_alunos / v_qtd_monitores,
    CASE WHEN v_qtd_alunos % v_qtd_monitores = 0
         THEN v_qtd_alunos / v_qtd_monitores
         ELSE v_qtd_alunos / v_qtd_monitores + 1 END,
    round(v_qtd_alunos::numeric / v_qtd_monitores, 2);
END $$;


-- ============================================================
-- PASSO 4 - VERIFICACAO
-- ============================================================

-- 4.1 Quantos alunos cada monitor recebeu
SELECT COALESCE(u.raw_user_meta_data ->> 'full_name', '') AS monitor,
       u.email,
       count(ms.student_id)                               AS alunos
  FROM monitor_students ms
  JOIN auth.users u ON u.id = ms.monitor_id
 GROUP BY u.raw_user_meta_data ->> 'full_name', u.email
 ORDER BY alunos DESC, monitor
 LIMIT 10000;

-- 4.2 Nenhum aluno pode ter mais de um monitor (tem que vir vazio)
SELECT ms.student_id, count(*) AS qtd_monitores
  FROM monitor_students ms
 GROUP BY ms.student_id
HAVING count(*) > 1;

-- 4.3 Nenhum monitor pode ter virado aluno de outro (tem que vir vazio)
SELECT u.email
  FROM monitor_students ms
  JOIN auth.users u          ON u.id = ms.student_id
  JOIN public.user_roles ur  ON ur.user_id = u.id
 WHERE ur.role = 'monitor';

-- 4.4 Nenhum e-mail da lista de excecao pode aparecer como aluno
--     (tem que vir vazio)
SELECT u.email
  FROM monitor_students ms
  JOIN auth.users u ON u.id = ms.student_id
 WHERE lower(u.email) = ANY (ARRAY[
   'deborat@id.uff.br',
   'elisabete.souza@portosrio.gov.br',
   'aramis.junior@portosrio.gov.br',
   'fernanda.sasaoka@portosrio.gov.br',
   'flavio.vieira@portosrio.gov.br',
   'renan.almeida@portosrio.gov.br',
   'francisco.diogo@portosrio.gov.br',
   'fagner.dias@portosrio.gov.br',
   'fvergueiro@id.uff.br',
   'ramalhomarcusantonio@gmail.com',
   'ecamilo@id.uff.br',
   'ricardo.ganem@portosrio.gov.br',
   'mfreitas@ivig.coppe.ufrj.br',
   'deboramellocamilo@gmail.com',
   'nextmetal@gmail.com',
   'rodnramos@gmail.com',
   'eduardofelipe@gmail.com',
   'aureliomurtacopy@gmail.com',
   'nextmarte@hotmail.com',
   'barbedoluiz@gmail.com',
   'aplicacao.treinamento@gmail.com',
   'barbedoluizfelipe@gmail.com',
   'eliasbrito123@gmail.com'
 ]);

-- 4.5 Total de vinculos e faixa de datas
SELECT count(*)           AS total_vinculos,
       min(assigned_at)   AS mais_antigo,
       max(assigned_at)   AS mais_recente
  FROM monitor_students;
