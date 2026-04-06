-- ============================================================
-- Cadastro de novos alunos
-- Data: 2026-03-30
-- ============================================================
DO $$
DECLARE
  new_user_id UUID;
BEGIN

  -- Fagner Dias
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'fagner.dias@portosrio.gov.br';
  IF new_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(),
      'authenticated',
      'authenticated',
      'fagner.dias@portosrio.gov.br',
      crypt('Fagner', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "Fagner Dias", "must_reset_password": true}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  
  INSERT INTO public.user_roles (user_id, role)
  VALUES (new_user_id, 'user')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user';

  -- Fernanda Sasaoka
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'fernanda.sasaoka@portosrio.gov.br';
  IF new_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(),
      'authenticated',
      'authenticated',
      'fernanda.sasaoka@portosrio.gov.br',
      crypt('Fernanda', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "Fernanda Sasaoka", "must_reset_password": true}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  
  INSERT INTO public.user_roles (user_id, role)
  VALUES (new_user_id, 'user')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user';

  -- Flavio Vieira
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'flavio.vieira@portosrio.gov.br';
  IF new_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(),
      'authenticated',
      'authenticated',
      'flavio.vieira@portosrio.gov.br',
      crypt('Flavio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "Flavio Vieira", "must_reset_password": true}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  
  INSERT INTO public.user_roles (user_id, role)
  VALUES (new_user_id, 'user')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user';

  -- Renan Almeida
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'renan.almeida@portosrio.gov.br';
  IF new_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(),
      'authenticated',
      'authenticated',
      'renan.almeida@portosrio.gov.br',
      crypt('Renan0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "Renan Almeida", "must_reset_password": true}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  
  INSERT INTO public.user_roles (user_id, role)
  VALUES (new_user_id, 'user')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user';

  -- Aramis Junior
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'aramis.junior@portosrio.gov.br';
  IF new_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(),
      'authenticated',
      'authenticated',
      'aramis.junior@portosrio.gov.br',
      crypt('Aramis', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "Aramis Junior", "must_reset_password": true}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  
  INSERT INTO public.user_roles (user_id, role)
  VALUES (new_user_id, 'user')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user';

  -- Francisco Diogo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'francisco.diogo@portosrio.gov.br';
  IF new_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(),
      'authenticated',
      'authenticated',
      'francisco.diogo@portosrio.gov.br',
      crypt('Francisco', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "Francisco Diogo", "must_reset_password": true}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  
  INSERT INTO public.user_roles (user_id, role)
  VALUES (new_user_id, 'user')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user';

  -- Elisabete Souza
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'elisabete.souza@portosrio.gov.br';
  IF new_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(),
      'authenticated',
      'authenticated',
      'elisabete.souza@portosrio.gov.br',
      crypt('Elisabete', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "Elisabete Souza", "must_reset_password": true}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  
  INSERT INTO public.user_roles (user_id, role)
  VALUES (new_user_id, 'user')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user';

  -- Garante troca de senha no primeiro acesso, inclusive para usuários já existentes.
  UPDATE auth.users u
  SET
    raw_user_meta_data = COALESCE(u.raw_user_meta_data, '{}'::jsonb) || '{"must_reset_password": true}'::jsonb,
    updated_at = NOW()
  WHERE lower(u.email) IN (
    'fagner.dias@portosrio.gov.br',
    'fernanda.sasaoka@portosrio.gov.br',
    'flavio.vieira@portosrio.gov.br',
    'renan.almeida@portosrio.gov.br',
    'aramis.junior@portosrio.gov.br',
    'francisco.diogo@portosrio.gov.br',
    'elisabete.souza@portosrio.gov.br'
  );

END $$;
