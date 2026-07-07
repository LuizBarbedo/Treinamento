-- ============================================================
-- Correção de login de alunos
-- Data: 2026-06-09
-- Origem: planilha "Login alunos com erro #1.xlsx" (27 alunos)
--
-- DIAGNÓSTICO
--   Esses alunos foram criados/alterados via SQL bruto em lotes
--   posteriores (sql_correcao_usuarios_2026_03_27.sql,
--   sql_inserir_novos_alunos_2026_03_30.sql) e por troca de e-mail
--   (sql_trocar_emails_2026_03_30.sql). Problemas encontrados:
--     1) Usuários sem linha em auth.identities  -> GoTrue resolve o
--        login pela identity; sem ela, signInWithPassword falha com
--        "Invalid login credentials" mesmo com a senha correta.
--     2) E-mail trocado direto em auth.users sem sincronizar
--        auth.identities (casos "...est@outlook.com").
--     3) auth.users existente sem email_confirmed_at.
--
-- O QUE ESTE SCRIPT FAZ (idempotente — pode rodar mais de uma vez)
--   Para cada um dos 27 alunos:
--     - Garante o usuário em auth.users com o e-mail da planilha
--       (cria se não existir; atualiza se existir).
--     - Define a SENHA = '123Abc*!' (coluna SENHA da planilha).
--     - must_reset_password = true (força troca de senha no 1º acesso).
--     - email_confirmed_at preenchido.
--     - Cria/sincroniza a linha de auth.identities (provider 'email').
--
-- OBSERVAÇÕES IMPORTANTES
--   * SENHA = '123Abc*!' para todos (única senha da planilha). É uma senha
--     PROVISÓRIA: no 1º login o sistema redireciona para /redefinir-senha
--     (via flag must_reset_password) e exige criar uma nova senha.
--   * 'ailtonmendonça333@gmail.com' (com 'ç', não-ASCII) foi trocado por
--     'ailtonmendonca333@gmail.com' (sem acento). O registro antigo é
--     renomeado no PASSO 0 da PARTE 2, evitando criar usuário duplicado.
--   * 'andrynedepaulal6@gmall.com' (gmall) foi CORRIGIDO para
--     'andrynedepaulal6@gmail.com' (gmail) — que é o e-mail real
--     cadastrado no banco em sql_correcao_usuarios_2026_03_27.sql.
-- ============================================================


-- ============================================================
-- PARTE 1 — PREVIEW (somente leitura). Rode primeiro e confira.
--   tem_identity = false  -> faltando identity (causa nº 1)
--   email_identity <> email_users -> e-mail dessincronizado (causa nº 2)
--   existe = false -> usuário não existe ainda (será criado)
-- ============================================================
WITH planilha(email_raw, full_name) AS (
  VALUES
    ('pontestatiana1984@gmail.com', 'TATIANA DE SOZA PONTES TEIXEIRA'),
    ('THAICPENF@GMAIL.COM', 'THAIANE CARDOSO PEREIRA'),
    ('To788484@gmail.com', 'THIAGO DE OLIVEIRA ROSA'),
    ('contatotiagomedeiros@hotmail.com', 'TIAGO CORREA DE MEDEIROS'),
    ('uilian.cardoso.santos@gmail.com', 'UILIAN CARDOSO DOS SANTOS'),
    ('vinicius.vmo@gmail.com', 'VINICIUS MENEZES DE OLIVEIRA'),
    ('wanderson.paes.leme.silva@gmail.com', 'WANDERSON PAES LEME DA SILVA'),
    ('BORGESWILLIA852@GMAIL.COM', 'WILLIAM CRUZ DE SOUZA BORGES'),
    ('yagofidalgo@gmail.com', 'YAGO DE ARAUJO FIDALGO'),
    ('mauricioteixeiraest@outlook.com', 'MAURICIO QUINTINO RIBEIRO JUNIOR'),
    ('jose.garcia.castro@gmail.com', 'JOSÉ GARCIA CASTRO'),
    ('andrynedepaulal6@gmail.com', 'ANDRYNE LÚCIA DE PAULA DOS SANTOS'),
    ('ailtonmendonca333@gmail.com', 'AILTON LUIS DE MENDONÇA'),
    ('marianaalmeidaest@outlook.com', 'MARIA ASSUNÇÃO DE ALMEIDA'),
    ('lorransouzaest@outlook.com', 'LORRANA GOMES DE SOUZA'),
    ('joaobritoest@outlook.com', 'JOÃO ELIAS CHAVES DE BRITO'),
    ('heitorassisest@outlook.com', 'HEITOR ABIB FABRI DE ASSIS'),
    ('gilsonpedroest@outlook.com', 'GILSON SOUZA PEDRO'),
    ('elexandraamaranteest@outlook.com', 'ELEXANDRA LISBÔA DOS SANTOS AMARANTE'),
    ('denioferreiraest@outlook.com', 'DENIO ALMEIDA ANDRADE FERREIRA'),
    ('kenia.souza.goncalves.santos@gmail.com', 'KENIA DE SOUZA GONÇALVES DOS SANTOS'),
    ('alexsilvaest@outlook.com', 'CARLOS ALEX AURELIO DA SILVA JUNIOR'),
    ('andre.luiz.araujo.oliveira@gmail.com', 'ANDRE LUIZ ARAUJO DE OLIVEIRA'),
    ('paolasenhorinho723@gmail.com', 'PAOLA CORREA SENHORINHO'),
    ('mauromartinsest@outlook.com', 'MAURO MARTINS DE SOUZA'),
    ('lucieneest@outlook.com', 'LUCILENE ARAUJO DOS SANTOS OLIVEIRA LOPES'),
    ('larissarezendeub@gmail.com', 'LARISSA PINHEIRO REZENDE DO NASCIMENTO')
)
SELECT
  p.full_name,
  lower(btrim(p.email_raw))                          AS email_planilha,
  (u.id IS NOT NULL)                                 AS existe,
  u.email                                            AS email_em_auth_users,
  (i.id IS NOT NULL)                                 AS tem_identity,
  i.identity_data->>'email'                          AS email_identity,
  (u.email_confirmed_at IS NOT NULL)                 AS email_confirmado
FROM planilha p
LEFT JOIN auth.users u       ON lower(u.email) = lower(btrim(p.email_raw))
LEFT JOIN auth.identities i  ON i.user_id = u.id AND i.provider = 'email'
ORDER BY existe, tem_identity, p.full_name;


-- ============================================================
-- PARTE 2 — CORREÇÃO. Rode após revisar a PARTE 1.
--   Está em transação: troque COMMIT por ROLLBACK no final para
--   um "ensaio" sem gravar.
-- ============================================================
BEGIN;

-- PASSO 0: renomeia o registro antigo do Ailton (e-mail com 'ç') para a
-- versão sem acento, para que o loop abaixo conserte o usuário existente
-- em vez de criar um duplicado. Só renomeia se o e-mail limpo ainda não
-- existir (evita violar a constraint de e-mail único).
UPDATE auth.users
SET email = 'ailtonmendonca333@gmail.com'
WHERE lower(email) = 'ailtonmendonça333@gmail.com'
  AND NOT EXISTS (
    SELECT 1 FROM auth.users u2
    WHERE lower(u2.email) = 'ailtonmendonca333@gmail.com'
  );

CREATE TEMP TABLE tmp_alunos_login (email_raw text, full_name text) ON COMMIT DROP;
INSERT INTO tmp_alunos_login (email_raw, full_name) VALUES
  ('pontestatiana1984@gmail.com', 'TATIANA DE SOZA PONTES TEIXEIRA'),
  ('THAICPENF@GMAIL.COM', 'THAIANE CARDOSO PEREIRA'),
  ('To788484@gmail.com', 'THIAGO DE OLIVEIRA ROSA'),
  ('contatotiagomedeiros@hotmail.com', 'TIAGO CORREA DE MEDEIROS'),
  ('uilian.cardoso.santos@gmail.com', 'UILIAN CARDOSO DOS SANTOS'),
  ('vinicius.vmo@gmail.com', 'VINICIUS MENEZES DE OLIVEIRA'),
  ('wanderson.paes.leme.silva@gmail.com', 'WANDERSON PAES LEME DA SILVA'),
  ('BORGESWILLIA852@GMAIL.COM', 'WILLIAM CRUZ DE SOUZA BORGES'),
  ('yagofidalgo@gmail.com', 'YAGO DE ARAUJO FIDALGO'),
  ('mauricioteixeiraest@outlook.com', 'MAURICIO QUINTINO RIBEIRO JUNIOR'),
  ('jose.garcia.castro@gmail.com', 'JOSÉ GARCIA CASTRO'),
  ('andrynedepaulal6@gmail.com', 'ANDRYNE LÚCIA DE PAULA DOS SANTOS'),
  ('ailtonmendonca333@gmail.com', 'AILTON LUIS DE MENDONÇA'),
  ('marianaalmeidaest@outlook.com', 'MARIA ASSUNÇÃO DE ALMEIDA'),
  ('lorransouzaest@outlook.com', 'LORRANA GOMES DE SOUZA'),
  ('joaobritoest@outlook.com', 'JOÃO ELIAS CHAVES DE BRITO'),
  ('heitorassisest@outlook.com', 'HEITOR ABIB FABRI DE ASSIS'),
  ('gilsonpedroest@outlook.com', 'GILSON SOUZA PEDRO'),
  ('elexandraamaranteest@outlook.com', 'ELEXANDRA LISBÔA DOS SANTOS AMARANTE'),
  ('denioferreiraest@outlook.com', 'DENIO ALMEIDA ANDRADE FERREIRA'),
  ('kenia.souza.goncalves.santos@gmail.com', 'KENIA DE SOUZA GONÇALVES DOS SANTOS'),
  ('alexsilvaest@outlook.com', 'CARLOS ALEX AURELIO DA SILVA JUNIOR'),
  ('andre.luiz.araujo.oliveira@gmail.com', 'ANDRE LUIZ ARAUJO DE OLIVEIRA'),
  ('paolasenhorinho723@gmail.com', 'PAOLA CORREA SENHORINHO'),
  ('mauromartinsest@outlook.com', 'MAURO MARTINS DE SOUZA'),
  ('lucieneest@outlook.com', 'LUCILENE ARAUJO DOS SANTOS OLIVEIRA LOPES'),
  ('larissarezendeub@gmail.com', 'LARISSA PINHEIRO REZENDE DO NASCIMENTO');

DO $$
DECLARE
  r          RECORD;
  v_user_id  uuid;
  v_login    text;  -- e-mail normalizado (login)
  v_pass     constant text := '123Abc*!';  -- [SENHA] senha definitiva (coluna SENHA da planilha)
BEGIN
  FOR r IN SELECT email_raw, full_name FROM tmp_alunos_login LOOP
    v_login := lower(btrim(r.email_raw));

    SELECT id INTO v_user_id
    FROM auth.users
    WHERE lower(email) = v_login
    LIMIT 1;

    IF v_user_id IS NULL THEN
      -- Usuário não existe: cria do zero (auth.users + identity)
      v_user_id := gen_random_uuid();
      INSERT INTO auth.users (
        instance_id, id, aud, role, email, encrypted_password,
        email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
        created_at, updated_at, confirmation_token, email_change,
        email_change_token_new, recovery_token
      ) VALUES (
        '00000000-0000-0000-0000-000000000000',
        v_user_id, 'authenticated', 'authenticated',
        v_login,
        crypt(v_pass, gen_salt('bf')),
        now(),
        '{"provider": "email", "providers": ["email"]}',
        jsonb_build_object('full_name', r.full_name, 'must_reset_password', true),
        now(), now(), '', '', '', ''
      );
    ELSE
      -- Usuário existe: ressincroniza e-mail, senha, confirmação e flag
      UPDATE auth.users
      SET email              = v_login,
          encrypted_password = crypt(v_pass, gen_salt('bf')),
          email_confirmed_at = COALESCE(email_confirmed_at, now()),
          raw_user_meta_data = COALESCE(raw_user_meta_data, '{}'::jsonb)
                               || jsonb_build_object('full_name', r.full_name,
                                                     'must_reset_password', true),
          confirmation_token     = '',
          email_change           = '',
          email_change_token_new = '',
          recovery_token         = '',
          updated_at         = now()
      WHERE id = v_user_id;
    END IF;

    -- Garante/sincroniza a identity de e-mail (causa raiz nº 1 e nº 2)
    IF EXISTS (
      SELECT 1 FROM auth.identities
      WHERE user_id = v_user_id AND provider = 'email'
    ) THEN
      UPDATE auth.identities
      SET identity_data = jsonb_build_object(
            'sub', v_user_id::text,
            'email', v_login,
            'email_verified', true,
            'full_name', r.full_name),
          provider_id = v_user_id::text,
          updated_at  = now()
      WHERE user_id = v_user_id AND provider = 'email';
    ELSE
      INSERT INTO auth.identities (
        id, user_id, identity_data, provider, provider_id,
        last_sign_in_at, created_at, updated_at
      ) VALUES (
        gen_random_uuid(),
        v_user_id,
        jsonb_build_object(
          'sub', v_user_id::text,
          'email', v_login,
          'email_verified', true,
          'full_name', r.full_name),
        'email',
        v_user_id::text,
        now(), now(), now()
      );
    END IF;

  END LOOP;
END $$;

-- Verificação pós-correção (estado depois das alterações)
SELECT
  t.full_name,
  u.email                              AS email_login,
  (i.id IS NOT NULL)                   AS tem_identity,
  (i.identity_data->>'email' = u.email) AS identity_sincronizada,
  (u.email_confirmed_at IS NOT NULL)   AS confirmado,
  (u.raw_user_meta_data->>'must_reset_password') AS must_reset
FROM tmp_alunos_login t
JOIN auth.users u      ON lower(u.email) = lower(btrim(t.email_raw))
LEFT JOIN auth.identities i ON i.user_id = u.id AND i.provider = 'email'
ORDER BY t.full_name;

COMMIT;
-- Para ensaio sem gravar: troque a linha acima por  ROLLBACK;
