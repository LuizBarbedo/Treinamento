-- Cadastro de aluno individual
-- Login: mfreitas@ivig.coppe.ufrj.br
-- Data: 2026-07-20
--
-- Baseado em sql_corrigir_login_alunos_2026_06_09.sql:
-- cria auth.users E auth.identities (a identity é obrigatória, senão o
-- login falha com "Invalid login credentials"). Idempotente: se o e-mail
-- já existir, apenas ressincroniza senha/identity.
--
-- Aluno = auth.users com role 'user' (não precisa de linha em user_roles).
-- Rode no Supabase Dashboard -> SQL Editor.

BEGIN;

DO $$
DECLARE
  v_user_id  uuid;
  v_login    constant text := lower('mfreitas@ivig.coppe.ufrj.br');
  v_pass     constant text := 'mfreitasivig';
  v_name     constant text := 'MARCOS FREITAS';
BEGIN
  SELECT id INTO v_user_id
  FROM auth.users
  WHERE lower(email) = v_login
  LIMIT 1;

  IF v_user_id IS NULL THEN
    -- Cria do zero
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
      jsonb_build_object('full_name', v_name, 'must_reset_password', false),
      now(), now(), '', '', '', ''
    );
  ELSE
    -- Já existe: ressincroniza senha, confirmação e flag
    UPDATE auth.users
    SET encrypted_password = crypt(v_pass, gen_salt('bf')),
        email_confirmed_at = COALESCE(email_confirmed_at, now()),
        raw_user_meta_data = COALESCE(raw_user_meta_data, '{}'::jsonb)
                             || jsonb_build_object('full_name', v_name,
                                                   'must_reset_password', false),
        confirmation_token     = '',
        email_change           = '',
        email_change_token_new = '',
        recovery_token         = '',
        updated_at         = now()
    WHERE id = v_user_id;
  END IF;

  -- Garante a identity de e-mail (causa raiz dos logins quebrados)
  IF EXISTS (
    SELECT 1 FROM auth.identities
    WHERE user_id = v_user_id AND provider = 'email'
  ) THEN
    UPDATE auth.identities
    SET identity_data = jsonb_build_object(
          'sub', v_user_id::text,
          'email', v_login,
          'email_verified', true,
          'full_name', v_name),
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
        'full_name', v_name),
      'email',
      v_user_id::text,
      now(), now(), now()
    );
  END IF;
END $$;

-- Verificação
SELECT
  u.email                               AS email_login,
  u.raw_user_meta_data->>'full_name'    AS nome,
  (i.id IS NOT NULL)                    AS tem_identity,
  (i.identity_data->>'email' = u.email) AS identity_sincronizada,
  (u.email_confirmed_at IS NOT NULL)    AS confirmado,
  (u.raw_user_meta_data->>'must_reset_password') AS must_reset
FROM auth.users u
LEFT JOIN auth.identities i ON i.user_id = u.id AND i.provider = 'email'
WHERE lower(u.email) = lower('mfreitas@ivig.coppe.ufrj.br');

COMMIT;
-- Para ensaio sem gravar: troque COMMIT por ROLLBACK.
