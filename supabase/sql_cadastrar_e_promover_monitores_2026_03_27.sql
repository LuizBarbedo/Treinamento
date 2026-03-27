-- Script gerado em 2026-03-27
-- Objetivo:
-- 1) Criar usuários ausentes em auth.users
-- 2) Garantir role = 'monitor' para todos os e-mails abaixo
--
-- Observações:
-- - Script idempotente: pode ser executado mais de uma vez.
-- - Usuários novos serão criados com senha inicial baseada no primeiro nome.
-- - Regra da senha inicial: primeiro nome, e se tiver menos de 6 caracteres,
--   completar com "0" até chegar a 6.
-- - Usuários novos terão must_reset_password = true no metadata.

DO $$
DECLARE
  v_email TEXT;
  v_user_id UUID;
  v_first_name TEXT;
  v_initial_password TEXT;
BEGIN
  FOREACH v_email IN ARRAY ARRAY[
    'arcila.alves@gmail.com',
    'carlosalexaurelio@gmail.com',
    'oadriano2727@yahoo.com',
    'andersonsampaio.jll@gmail.com',
    'andre.luiz.araujo.oliveira@gmail.com',
    'arthuraureliomed@gmail.com',
    'claudiapxto@gmail.com',
    'edilene.rodrigues.silva@gmail.com',
    'kenia.souza.goncalves.santos@gmail.com',
    'leandro.rocha.paura@gmail.com',
    'rneversonrocha31@gmail.com',
    'vander.araujo@gmail.com'
  ]
  LOOP
    -- Define senha inicial por e-mail (primeiro nome + padding com 0 até 6)
    v_first_name := CASE lower(v_email)
      WHEN 'oadriano2727@yahoo.com' THEN 'Adriano'
      WHEN 'andersonsampaio.jll@gmail.com' THEN 'Anderson'
      WHEN 'andre.luiz.araujo.oliveira@gmail.com' THEN 'Andre'
      WHEN 'arthuraureliomed@gmail.com' THEN 'Arthur'
      WHEN 'claudiapxto@gmail.com' THEN 'Claudia'
      WHEN 'edilene.rodrigues.silva@gmail.com' THEN 'Edilene'
      WHEN 'kenia.souza.goncalves.santos@gmail.com' THEN 'Kenia'
      WHEN 'leandro.rocha.paura@gmail.com' THEN 'Leandro'
      WHEN 'rneversonrocha31@gmail.com' THEN 'Neverson'
      WHEN 'vander.araujo@gmail.com' THEN 'Vander'
      ELSE split_part(v_email, '@', 1)
    END;

    v_initial_password := v_first_name;
    IF length(v_initial_password) < 6 THEN
      v_initial_password := v_initial_password || repeat('0', 6 - length(v_initial_password));
    END IF;

    -- Procura usuário existente por e-mail
    SELECT id
      INTO v_user_id
      FROM auth.users
     WHERE lower(email) = lower(v_email)
     LIMIT 1;

    -- Se não existir, cria no Auth com senha temporária
    IF v_user_id IS NULL THEN
      INSERT INTO auth.users (
        instance_id,
        id,
        aud,
        role,
        email,
        encrypted_password,
        email_confirmed_at,
        raw_app_meta_data,
        raw_user_meta_data,
        created_at,
        updated_at,
        confirmation_token,
        email_change,
        email_change_token_new,
        recovery_token
      ) VALUES (
        '00000000-0000-0000-0000-000000000000',
        gen_random_uuid(),
        'authenticated',
        'authenticated',
        lower(v_email),
        crypt(v_initial_password, gen_salt('bf')),
        NOW(),
        '{"provider": "email", "providers": ["email"]}',
        jsonb_build_object(
          'full_name', split_part(v_email, '@', 1),
          'must_reset_password', true
        ),
        NOW(),
        NOW(),
        '', '', '', ''
      )
      RETURNING id INTO v_user_id;
    END IF;

    -- Garante role monitor
    INSERT INTO public.user_roles (user_id, role)
    VALUES (v_user_id, 'monitor')
    ON CONFLICT (user_id)
    DO UPDATE SET role = 'monitor';
  END LOOP;
END
$$;

-- Verificação final
SELECT
  u.email,
  ur.role,
  u.created_at
FROM auth.users u
LEFT JOIN public.user_roles ur ON ur.user_id = u.id
WHERE lower(u.email) IN (
  'arcila.alves@gmail.com',
  'carlosalexaurelio@gmail.com',
  'oadriano2727@yahoo.com',
  'andersonsampaio.jll@gmail.com',
  'andre.luiz.araujo.oliveira@gmail.com',
  'arthuraureliomed@gmail.com',
  'claudiapxto@gmail.com',
  'edilene.rodrigues.silva@gmail.com',
  'kenia.souza.goncalves.santos@gmail.com',
  'leandro.rocha.paura@gmail.com',
  'rneversonrocha31@gmail.com',
  'vander.araujo@gmail.com'
)
ORDER BY lower(u.email);
