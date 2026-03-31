-- ============================================================
-- Correcao do banco de dados Supabase
-- Data: 2026-03-27
-- Objetivo: Inserir 92 alunos faltando, corrigir roles e CPFs
--
-- Resumo:
--   PARTE 1 -- Inserir 92 alunos que estao na planilha mas nao no banco
--   PARTE 2 -- Corrigir role de 3 usuarios (monitor -> user)
--   PARTE 3 -- Atualizar CPF de 11 usuarios com CPF nulo ou incorreto
-- ============================================================

-- ============================================================
-- PARTE 1: Inserir 92 alunos faltando no banco
-- ============================================================
DO $$
DECLARE
  v_user_id UUID;
BEGIN

  -- Aluno 1: ADRIANO RODRIGUES DE ARAUJO
  -- Email: adriano.rodrigues.araujo@gmail.com | CPF: 180.374.317-46 | Senha: Adriano
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'adriano.rodrigues.araujo@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'adriano.rodrigues.araujo@gmail.com',
      crypt('Adriano', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ADRIANO RODRIGUES DE ARAUJO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '180.374.317-46')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '180.374.317-46';

  -- Aluno 2: ADRIELE SILVA DE MELO
  -- Email: adriele.melo@live.com | CPF: 127.090.227-02 | Senha: Adriele
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'adriele.melo@live.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'adriele.melo@live.com',
      crypt('Adriele', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ADRIELE SILVA DE MELO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '127.090.227-02')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '127.090.227-02';

  -- Aluno 3: AILTON LUIS DE MENDONÇA
  -- Email: ailtonmendonça333@gmail.com | CPF: 676.786.884-15 | Senha: Ailton
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'ailtonmendonça333@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'ailtonmendonça333@gmail.com',
      crypt('Ailton', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'AILTON LUIS DE MENDONÇA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '676.786.884-15')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '676.786.884-15';

  -- Aluno 4: ALAN ASSIS GRADES
  -- Email: assisgrades@gmail.com | CPF: 110.425.217-19 | Senha: Alan00
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'assisgrades@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'assisgrades@gmail.com',
      crypt('Alan00', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ALAN ASSIS GRADES', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '110.425.217-19')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '110.425.217-19';

  -- Aluno 5: ALESSANDRO ROCHA PAURA
  -- Email: alessandro.rocha.paura@gmail.com | CPF: 058.673.787-13 | Senha: Alessandro
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'alessandro.rocha.paura@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'alessandro.rocha.paura@gmail.com',
      crypt('Alessandro', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ALESSANDRO ROCHA PAURA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '058.673.787-13')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '058.673.787-13';

  -- Aluno 6: ALEXANDRE DOS SANTOS JOSÉ
  -- Email: aj4605480@gmail.com | CPF: 072.812.377-07 | Senha: Alexandre
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'aj4605480@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'aj4605480@gmail.com',
      crypt('Alexandre', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ALEXANDRE DOS SANTOS JOSÉ', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '072.812.377-07')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '072.812.377-07';

  -- Aluno 7: ALEXANDRE JANUARIO
  -- Email: alexandre.januario@gmail.com | CPF: 100.099.797-94 | Senha: Alexandre
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'alexandre.januario@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'alexandre.januario@gmail.com',
      crypt('Alexandre', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ALEXANDRE JANUARIO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '100.099.797-94')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '100.099.797-94';

  -- Aluno 8: ANA KARLA DE MOURA LACERDA
  -- Email: ana.carla.lima.pereira@gmail.com | CPF: 095.283.987-31 | Senha: Ana000
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'ana.carla.lima.pereira@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'ana.carla.lima.pereira@gmail.com',
      crypt('Ana000', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ANA KARLA DE MOURA LACERDA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '095.283.987-31')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '095.283.987-31';

  -- Aluno 9: ANA LUIZA PESSANHA DE JESUS RODRIGUES
  -- Email: analuizapessanha414@gmail.com | CPF: 030.382.297-09 | Senha: Ana000
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'analuizapessanha414@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'analuizapessanha414@gmail.com',
      crypt('Ana000', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ANA LUIZA PESSANHA DE JESUS RODRIGUES', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '030.382.297-09')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '030.382.297-09';

  -- Aluno 10: ANA MARIA RODRIGUES DE SOUZA FARIA
  -- Email: floranasouza1@gmail.com | CPF: 027.399.527-83 | Senha: Ana000
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'floranasouza1@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'floranasouza1@gmail.com',
      crypt('Ana000', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ANA MARIA RODRIGUES DE SOUZA FARIA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '027.399.527-83')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '027.399.527-83';

  -- Aluno 11: ANDERSON RODRIGUES DE OLIVEIRA
  -- Email: anderson.rodrigues.oliveira@gmail.com | CPF: 119.930.297-02 | Senha: Anderson
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'anderson.rodrigues.oliveira@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'anderson.rodrigues.oliveira@gmail.com',
      crypt('Anderson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ANDERSON RODRIGUES DE OLIVEIRA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '119.930.297-02')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '119.930.297-02';

  -- Aluno 12: ANDRESSA RODRIGUES DE OLIVEIRA
  -- Email: rodrigues.dessa.1989@gmail.com | CPF: 138.880.007-18 | Senha: Andressa
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'rodrigues.dessa.1989@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'rodrigues.dessa.1989@gmail.com',
      crypt('Andressa', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ANDRESSA RODRIGUES DE OLIVEIRA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '138.880.007-18')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '138.880.007-18';

  -- Aluno 13: ANDRYNE LÚCIA DE PAULA DOS SANTOS
  -- Email: andrynedepaulal6@gmail.com | CPF: 214.852.857-20 | Senha: Andryne
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'andrynedepaulal6@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'andrynedepaulal6@gmail.com',
      crypt('Andryne', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ANDRYNE LÚCIA DE PAULA DOS SANTOS', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '214.852.857-20')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '214.852.857-20';

  -- Aluno 14: ANGELINA GONÇALVES SILVA SOUZA
  -- Email: angelinaaninha02@gmail.com | CPF: 110.286.857-42 | Senha: Angelina
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'angelinaaninha02@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'angelinaaninha02@gmail.com',
      crypt('Angelina', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ANGELINA GONÇALVES SILVA SOUZA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '110.286.857-42')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '110.286.857-42';

  -- Aluno 15: ANTONIO ALISON COSTA MATIAS
  -- Email: antonio.alison.costa.matias@gmail.com | CPF: 091.603.717-73 | Senha: Antonio
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'antonio.alison.costa.matias@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'antonio.alison.costa.matias@gmail.com',
      crypt('Antonio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ANTONIO ALISON COSTA MATIAS', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '091.603.717-73')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '091.603.717-73';

  -- Aluno 16: BRUNO ACCIOLI COSTA
  -- Email: bruno.accioli.costa@gmail.com | CPF: 403.709.238-71 | Senha: Bruno0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'bruno.accioli.costa@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'bruno.accioli.costa@gmail.com',
      crypt('Bruno0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'BRUNO ACCIOLI COSTA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '403.709.238-71')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '403.709.238-71';

  -- Aluno 17: BRUNO CARVALHO BORGES
  -- Email: brunocarvalho.gestao@gmail.com | CPF: 107.295.607-16 | Senha: Bruno0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'brunocarvalho.gestao@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'brunocarvalho.gestao@gmail.com',
      crypt('Bruno0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'BRUNO CARVALHO BORGES', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '107.295.607-16')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '107.295.607-16';

  -- Aluno 18: BRUNO DORNA DE SOUZA
  -- Email: bruno.dorna.souza@gmail.com | CPF: 104.184.987-76 | Senha: Bruno0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'bruno.dorna.souza@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'bruno.dorna.souza@gmail.com',
      crypt('Bruno0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'BRUNO DORNA DE SOUZA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '104.184.987-76')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '104.184.987-76';

  -- Aluno 19: CAMILA ALENCAR CORTES
  -- Email: camila.alencar.cortes@gmail.com | CPF: 150.651.967-96 | Senha: Camila
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'camila.alencar.cortes@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'camila.alencar.cortes@gmail.com',
      crypt('Camila', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'CAMILA ALENCAR CORTES', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '150.651.967-96')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '150.651.967-96';

  -- Aluno 20: CAMILA MARTINS LEAL DO NASCIMENTO
  -- Email: camila.martins.leal.nascimento@gmail.com | CPF: 144.247.987-63 | Senha: Camila
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'camila.martins.leal.nascimento@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'camila.martins.leal.nascimento@gmail.com',
      crypt('Camila', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'CAMILA MARTINS LEAL DO NASCIMENTO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '144.247.987-63')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '144.247.987-63';

  -- Aluno 21: CARLOS ALBERTO DE SOUZA
  -- Email: carlos.alberto.souza@gmail.com | CPF: 084.785.507-47 | Senha: Carlos
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'carlos.alberto.souza@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'carlos.alberto.souza@gmail.com',
      crypt('Carlos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'CARLOS ALBERTO DE SOUZA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '084.785.507-47')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '084.785.507-47';

  -- Aluno 22: CARLOS RIBEIRO SIMÕES
  -- Email: carlos.ribeiro.simoes@hotmail.com | CPF: 063.780.557-77 | Senha: Carlos
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'carlos.ribeiro.simoes@hotmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'carlos.ribeiro.simoes@hotmail.com',
      crypt('Carlos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'CARLOS RIBEIRO SIMÕES', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '063.780.557-77')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '063.780.557-77';

  -- Aluno 23: CAROLINE MAYARA CAMPOS MORAES DA COSTA
  -- Email: carolinemayara800@gmail.com | CPF: 062.901.187-73 | Senha: Caroline
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'carolinemayara800@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'carolinemayara800@gmail.com',
      crypt('Caroline', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'CAROLINE MAYARA CAMPOS MORAES DA COSTA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '062.901.187-73')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '062.901.187-73';

  -- Aluno 24: CLAYTON DOS SANTOS LIBERATORI
  -- Email: clayton.santos.liberatori@gmail.com | CPF: 112.005.647-07 | Senha: Clayton
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'clayton.santos.liberatori@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'clayton.santos.liberatori@gmail.com',
      crypt('Clayton', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'CLAYTON DOS SANTOS LIBERATORI', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '112.005.647-07')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '112.005.647-07';

  -- Aluno 25: CLEBER SIQUEIRA SILVA PEREIRA
  -- Email: cleber.siqueira.silva.pereira@gmail.com | CPF: 061.730.737-73 | Senha: Cleber
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'cleber.siqueira.silva.pereira@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'cleber.siqueira.silva.pereira@gmail.com',
      crypt('Cleber', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'CLEBER SIQUEIRA SILVA PEREIRA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '061.730.737-73')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '061.730.737-73';

  -- Aluno 26: DANIEL TEIXEIRA DE SOUZA
  -- Email: daniel.teixeira.souza@gmail.com | CPF: 134.441.797-31 | Senha: Daniel
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'daniel.teixeira.souza@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'daniel.teixeira.souza@gmail.com',
      crypt('Daniel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'DANIEL TEIXEIRA DE SOUZA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '134.441.797-31')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '134.441.797-31';

  -- Aluno 27: DAYANA DINIZ DA ROCHA
  -- Email: dayanadiniz468@gmail.com | CPF: 143.420.607-60 | Senha: Dayana
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'dayanadiniz468@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'dayanadiniz468@gmail.com',
      crypt('Dayana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'DAYANA DINIZ DA ROCHA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '143.420.607-60')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '143.420.607-60';

  -- Aluno 28: DEMETRIUS LIMA DE FIGUEIREDO
  -- Email: demetrius.figueiredo@gmail.com | CPF: 113.496.727-69 | Senha: Demetrius
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'demetrius.figueiredo@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'demetrius.figueiredo@gmail.com',
      crypt('Demetrius', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'DEMETRIUS LIMA DE FIGUEIREDO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '113.496.727-69')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '113.496.727-69';

  -- Aluno 29: ELAINE MORAES SANCHES
  -- Email: elaine.moraes.sanches@gmail.com | CPF: 133.167.627-44 | Senha: Elaine
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'elaine.moraes.sanches@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'elaine.moraes.sanches@gmail.com',
      crypt('Elaine', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ELAINE MORAES SANCHES', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '133.167.627-44')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '133.167.627-44';

  -- Aluno 30: ELISABETE ROSA SOUZA DE ARAUJO
  -- Email: elisaaraujo@gmail.com | CPF: 080.698.867-30 | Senha: Elisabete
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'elisaaraujo@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'elisaaraujo@gmail.com',
      crypt('Elisabete', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ELISABETE ROSA SOUZA DE ARAUJO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '080.698.867-30')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '080.698.867-30';

  -- Aluno 31: EMANUELLE DE ANDRADE IVAN
  -- Email: manuh_ivanovich@hotmail.com | CPF: 133.413.157-05 | Senha: Emanuelle
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'manuh_ivanovich@hotmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'manuh_ivanovich@hotmail.com',
      crypt('Emanuelle', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'EMANUELLE DE ANDRADE IVAN', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '133.413.157-05')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '133.413.157-05';

  -- Aluno 32: EMERSON LEONARDO DA SILVA GOMES
  -- Email: emerson.leonardo.silva.gomes@gmail.com | CPF: 163.246.827-14 | Senha: Emerson
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'emerson.leonardo.silva.gomes@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'emerson.leonardo.silva.gomes@gmail.com',
      crypt('Emerson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'EMERSON LEONARDO DA SILVA GOMES', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '163.246.827-14')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '163.246.827-14';

  -- Aluno 33: FABIO DA SILVA SOUZA
  -- Email: fabiosilva@gmail.com | CPF: 114.825.417-00 | Senha: Fabio0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'fabiosilva@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'fabiosilva@gmail.com',
      crypt('Fabio0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'FABIO DA SILVA SOUZA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '114.825.417-00')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '114.825.417-00';

  -- Aluno 34: FATIMA DE CARVALHO DOS SANTOS
  -- Email: fatimacarvalhoo804@gmail.com | CPF: 021.454.347-12 | Senha: Fatima
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'fatimacarvalhoo804@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'fatimacarvalhoo804@gmail.com',
      crypt('Fatima', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'FATIMA DE CARVALHO DOS SANTOS', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '021.454.347-12')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '021.454.347-12';

  -- Aluno 35: FERNANDO DA CRUZ DA SILVA
  -- Email: fernando.cruz.silva@gmail.com | CPF: 114.475.367-89 | Senha: Fernando
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'fernando.cruz.silva@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'fernando.cruz.silva@gmail.com',
      crypt('Fernando', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'FERNANDO DA CRUZ DA SILVA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '114.475.367-89')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '114.475.367-89';

  -- Aluno 36: GABRIEL GORGES WERNECK
  -- Email: gabrielgorgeswerneck@gmail.com | CPF: 169.584.327-46 | Senha: Gabriel
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'gabrielgorgeswerneck@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'gabrielgorgeswerneck@gmail.com',
      crypt('Gabriel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'GABRIEL GORGES WERNECK', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '169.584.327-46')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '169.584.327-46';

  -- Aluno 37: HENRIQUE CARVALHO PEREIRA
  -- Email: henrique.carvalho.pereira@gmail.com | CPF: 554.814.777-34 | Senha: Henrique
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'henrique.carvalho.pereira@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'henrique.carvalho.pereira@gmail.com',
      crypt('Henrique', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'HENRIQUE CARVALHO PEREIRA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '554.814.777-34')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '554.814.777-34';

  -- Aluno 38: HENRIQUE DE JESUS DA SILVA FERREIRA
  -- Email: henrique.jesus.silva.ferreira@gmail.com | CPF: 159.826.037-59 | Senha: Henrique
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'henrique.jesus.silva.ferreira@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'henrique.jesus.silva.ferreira@gmail.com',
      crypt('Henrique', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'HENRIQUE DE JESUS DA SILVA FERREIRA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '159.826.037-59')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '159.826.037-59';

  -- Aluno 39: ISRAEL CESAR MARQUES JUNIOR
  -- Email: israel.cesar.marques.junior@gmail.com | CPF: 085.253.877-46 | Senha: Israel
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'israel.cesar.marques.junior@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'israel.cesar.marques.junior@gmail.com',
      crypt('Israel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ISRAEL CESAR MARQUES JUNIOR', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '085.253.877-46')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '085.253.877-46';

  -- Aluno 40: ISRAEL VALDEVIDO LIMEIRA
  -- Email: israel.valdevido.limeira@gmail.com | CPF: 144.515.707-19 | Senha: Israel
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'israel.valdevido.limeira@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'israel.valdevido.limeira@gmail.com',
      crypt('Israel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'ISRAEL VALDEVIDO LIMEIRA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '144.515.707-19')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '144.515.707-19';

  -- Aluno 41: IZABELLA MACEDO RODRIGUES
  -- Email: izabellamrodrigues2001@gmail.com | CPF: 182.723.457-14 | Senha: Izabella
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'izabellamrodrigues2001@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'izabellamrodrigues2001@gmail.com',
      crypt('Izabella', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'IZABELLA MACEDO RODRIGUES', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '182.723.457-14')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '182.723.457-14';

  -- Aluno 42: JAIME DE SOUZA SA
  -- Email: jaime.souza.sa@gmail.com | CPF: 862.060.957-20 | Senha: Jaime0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'jaime.souza.sa@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'jaime.souza.sa@gmail.com',
      crypt('Jaime0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'JAIME DE SOUZA SA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '862.060.957-20')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '862.060.957-20';

  -- Aluno 43: JEFERSON MATOS DE ASSIS
  -- Email: jefferson.matos.assis@gmail.com | CPF: 128.533.977-00 | Senha: Jeferson
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'jefferson.matos.assis@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'jefferson.matos.assis@gmail.com',
      crypt('Jeferson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'JEFERSON MATOS DE ASSIS', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '128.533.977-00')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '128.533.977-00';

  -- Aluno 44: JILVANIA SOARES MOTA ALBINO
  -- Email: jilvania.soares.mota.albino@gmail.com | CPF: 136.387.997-94 | Senha: Jilvania
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'jilvania.soares.mota.albino@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'jilvania.soares.mota.albino@gmail.com',
      crypt('Jilvania', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'JILVANIA SOARES MOTA ALBINO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '136.387.997-94')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '136.387.997-94';

  -- Aluno 45: JONATHAN ALVES DE CARVALHO
  -- Email: lpnjhon@gmail.com | CPF: 137.020.287-30 | Senha: Jonathan
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'lpnjhon@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'lpnjhon@gmail.com',
      crypt('Jonathan', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'JONATHAN ALVES DE CARVALHO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '137.020.287-30')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '137.020.287-30';

  -- Aluno 46: JORDANNA RIBEIRO DE LIMA
  -- Email: jordanna.lima24@gmail.com | CPF: 175.012.417-32 | Senha: Jordanna
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'jordanna.lima24@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'jordanna.lima24@gmail.com',
      crypt('Jordanna', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'JORDANNA RIBEIRO DE LIMA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '175.012.417-32')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '175.012.417-32';

  -- Aluno 47: JOSE ERIVANALDO DA SILVA
  -- Email: joseeriva@gmail.com | CPF: 030.354.347-78 | Senha: Jose00
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'joseeriva@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'joseeriva@gmail.com',
      crypt('Jose00', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'JOSE ERIVANALDO DA SILVA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '030.354.347-78')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '030.354.347-78';

  -- Aluno 48: JOSE LEANDRO CAMPELO CARDOSO
  -- Email: joseleandrocampelocardoso@gmail.com | CPF: 115.575.437-61 | Senha: Jose00
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'joseleandrocampelocardoso@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'joseleandrocampelocardoso@gmail.com',
      crypt('Jose00', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'JOSE LEANDRO CAMPELO CARDOSO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '115.575.437-61')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '115.575.437-61';

  -- Aluno 49: JOSÉ GARCIA CASTRO
  -- Email: jose.garcia.castro@gmail.com | CPF: 016.301.497-67 | Senha: José00
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'jose.garcia.castro@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'jose.garcia.castro@gmail.com',
      crypt('José00', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'JOSÉ GARCIA CASTRO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '016.301.497-67')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '016.301.497-67';

  -- Aluno 50: JOYCE GONÇALVES SOUZA
  -- Email: joyce.goncalves.souza@gmail.com | CPF: 189.506.567-44 | Senha: Joyce0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'joyce.goncalves.souza@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'joyce.goncalves.souza@gmail.com',
      crypt('Joyce0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'JOYCE GONÇALVES SOUZA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '189.506.567-44')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '189.506.567-44';

  -- Aluno 51: JULIO CESAR LOURENÇO DA SILVA
  -- Email: julio.cesar.lourenco.silva@gmail.com | CPF: 998.288.437-72 | Senha: Julio0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'julio.cesar.lourenco.silva@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'julio.cesar.lourenco.silva@gmail.com',
      crypt('Julio0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'JULIO CESAR LOURENÇO DA SILVA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '998.288.437-72')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '998.288.437-72';

  -- Aluno 52: JULIO CESAR LOURENÇO DA SILVA JUNIOR
  -- Email: julio.cesar.lourenco.silva.junior@gmail.com | CPF: 133.819.597-27 | Senha: Julio0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'julio.cesar.lourenco.silva.junior@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'julio.cesar.lourenco.silva.junior@gmail.com',
      crypt('Julio0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'JULIO CESAR LOURENÇO DA SILVA JUNIOR', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '133.819.597-27')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '133.819.597-27';

  -- Aluno 53: JULIO CEZAR DE SOUZA DA SILVA
  -- Email: julio.cezar.souza.silva@gmail.com | CPF: 094.811.197-69 | Senha: Julio0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'julio.cezar.souza.silva@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'julio.cezar.souza.silva@gmail.com',
      crypt('Julio0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'JULIO CEZAR DE SOUZA DA SILVA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '094.811.197-69')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '094.811.197-69';

  -- Aluno 54: LEANDRO ANTONIO DE SOUZA PONTES
  -- Email: leandropontes323@gmail.com | CPF: 091.520.537-84 | Senha: Leandro
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'leandropontes323@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'leandropontes323@gmail.com',
      crypt('Leandro', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'LEANDRO ANTONIO DE SOUZA PONTES', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '091.520.537-84')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '091.520.537-84';

  -- Aluno 55: LEONARDO JUNIOR LIMA SACRAMENTO
  -- Email: leonardo.junior.lima.sacramento@gmail.com | CPF: 120.785.157-44 | Senha: Leonardo
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'leonardo.junior.lima.sacramento@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'leonardo.junior.lima.sacramento@gmail.com',
      crypt('Leonardo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'LEONARDO JUNIOR LIMA SACRAMENTO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '120.785.157-44')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '120.785.157-44';

  -- Aluno 56: LETHÍCIA CAVALCANTI DOS SANTOS
  -- Email: lethiciasantosss@gmail.com | CPF: 205.677.697-98 | Senha: Lethícia
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'lethiciasantosss@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'lethiciasantosss@gmail.com',
      crypt('Lethícia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'LETHÍCIA CAVALCANTI DOS SANTOS', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '205.677.697-98')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '205.677.697-98';

  -- Aluno 57: LUCAS MESSIAS DE MORAES
  -- Email: lucas.messias.moraes@gmail.com | CPF: 156.593.917-45 | Senha: Lucas0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'lucas.messias.moraes@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'lucas.messias.moraes@gmail.com',
      crypt('Lucas0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'LUCAS MESSIAS DE MORAES', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '156.593.917-45')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '156.593.917-45';

  -- Aluno 58: LUCIENE DINIZ DA ROCHA
  -- Email: lucienerocha@gmail.com | CPF: 113.876.427-23 | Senha: Luciene
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'lucienerocha@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'lucienerocha@gmail.com',
      crypt('Luciene', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'LUCIENE DINIZ DA ROCHA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '113.876.427-23')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '113.876.427-23';

  -- Aluno 59: LUIZ FELIPE GONÇALVES
  -- Email: felipe.021@hotmail.com | CPF: 108.083.207-69 | Senha: Luiz00
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'felipe.021@hotmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'felipe.021@hotmail.com',
      crypt('Luiz00', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'LUIZ FELIPE GONÇALVES', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '108.083.207-69')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '108.083.207-69';

  -- Aluno 60: LUIZ FELIPE SOUZA DE ARAUJO
  -- Email: l.phelie@gmail.com | CPF: 149.444.937-46 | Senha: Luiz00
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'l.phelie@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'l.phelie@gmail.com',
      crypt('Luiz00', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'LUIZ FELIPE SOUZA DE ARAUJO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '149.444.937-46')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '149.444.937-46';

  -- Aluno 61: MAGNO FURTADO NÓBREGA
  -- Email: magno.furtado.nobrega@gmail.com | CPF: 106.726.907-05 | Senha: Magno0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'magno.furtado.nobrega@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'magno.furtado.nobrega@gmail.com',
      crypt('Magno0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'MAGNO FURTADO NÓBREGA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '106.726.907-05')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '106.726.907-05';

  -- Aluno 62: MARCO ANTONIO MORAES DE ARAUJO BASTOS
  -- Email: marco.bastos@gmail.com | CPF: 070.980.947-65 | Senha: Marco0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'marco.bastos@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'marco.bastos@gmail.com',
      crypt('Marco0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'MARCO ANTONIO MORAES DE ARAUJO BASTOS', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '070.980.947-65')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '070.980.947-65';

  -- Aluno 63: MARIA ANGÉLICA BRANDÃO TEIXEIRA
  -- Email: mariaangelbrandao25@gmail.com | CPF: 044.862.667-57 | Senha: Maria0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'mariaangelbrandao25@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'mariaangelbrandao25@gmail.com',
      crypt('Maria0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'MARIA ANGÉLICA BRANDÃO TEIXEIRA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '044.862.667-57')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '044.862.667-57';

  -- Aluno 64: MARIO LUCIO PEREIRA
  -- Email: mariopereira19222@hotmail.com | CPF: 457.095.307-78 | Senha: Mario0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'mariopereira19222@hotmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'mariopereira19222@hotmail.com',
      crypt('Mario0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'MARIO LUCIO PEREIRA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '457.095.307-78')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '457.095.307-78';

  -- Aluno 65: MARISA FARROCO TAVARES DE AZEVEDO
  -- Email: marisa.farroco.tavares.azevedo@gmail.com | CPF: 135.256.057-73 | Senha: Marisa
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'marisa.farroco.tavares.azevedo@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'marisa.farroco.tavares.azevedo@gmail.com',
      crypt('Marisa', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'MARISA FARROCO TAVARES DE AZEVEDO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '135.256.057-73')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '135.256.057-73';

  -- Aluno 66: MATHEUS MOURA DA COSTA
  -- Email: matheus.moura.costa@gmail.com | CPF: 178.861.377-52 | Senha: Matheus
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'matheus.moura.costa@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'matheus.moura.costa@gmail.com',
      crypt('Matheus', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'MATHEUS MOURA DA COSTA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '178.861.377-52')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '178.861.377-52';

  -- Aluno 67: MAURICIO QUINTINO RIBEIRO JUNIOR
  -- Email: jrdopulapula2248@gmail.com | CPF: 055.272.867-58 | Senha: Mauricio
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'jrdopulapula2248@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'jrdopulapula2248@gmail.com',
      crypt('Mauricio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'MAURICIO QUINTINO RIBEIRO JUNIOR', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '055.272.867-58')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '055.272.867-58';

  -- Aluno 68: MAXUEL BATISTA DO CARMO SILVEIRA
  -- Email: maxuel.batista1978@gmail.com | CPF: 081.849.457-36 | Senha: Maxuel
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'maxuel.batista1978@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'maxuel.batista1978@gmail.com',
      crypt('Maxuel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'MAXUEL BATISTA DO CARMO SILVEIRA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '081.849.457-36')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '081.849.457-36';

  -- Aluno 69: MICHEL ANDERSON BELMIRA DE SOUZA
  -- Email: michel.anderson.belmira.souza@gmail.com | CPF: 053.959.697-30 | Senha: Michel
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'michel.anderson.belmira.souza@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'michel.anderson.belmira.souza@gmail.com',
      crypt('Michel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'MICHEL ANDERSON BELMIRA DE SOUZA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '053.959.697-30')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '053.959.697-30';

  -- Aluno 70: NATALIA DE MIRANDA MENDES
  -- Email: eunataliamiranda@hotmail.com | CPF: 177.689.617-30 | Senha: Natalia
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'eunataliamiranda@hotmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'eunataliamiranda@hotmail.com',
      crypt('Natalia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'NATALIA DE MIRANDA MENDES', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '177.689.617-30')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '177.689.617-30';

  -- Aluno 71: PABLO AUGUSTO GONÇALVES FAGUNDES DA SILVA
  -- Email: augustopablo408@gmail.com | CPF: 154.394.497-36 | Senha: Pablo0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'augustopablo408@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'augustopablo408@gmail.com',
      crypt('Pablo0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'PABLO AUGUSTO GONÇALVES FAGUNDES DA SILVA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '154.394.497-36')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '154.394.497-36';

  -- Aluno 72: PABLO POLEZI PACA
  -- Email: 3p.pablo@gmail.com | CPF: 103.155.977-98 | Senha: Pablo0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = '3p.pablo@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      '3p.pablo@gmail.com',
      crypt('Pablo0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'PABLO POLEZI PACA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '103.155.977-98')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '103.155.977-98';

  -- Aluno 73: PATRICIA DE MENDONÇA CORTES
  -- Email: patricia.cortes@gmail.com | CPF: 027.163.577-06 | Senha: Patricia
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'patricia.cortes@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'patricia.cortes@gmail.com',
      crypt('Patricia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'PATRICIA DE MENDONÇA CORTES', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '027.163.577-06')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '027.163.577-06';

  -- Aluno 74: POLLIANA DA SILVA AMARAL
  -- Email: poliamral@gmail.com | CPF: 128.775.377-90 | Senha: Polliana
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'poliamral@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'poliamral@gmail.com',
      crypt('Polliana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'POLLIANA DA SILVA AMARAL', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '128.775.377-90')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '128.775.377-90';

  -- Aluno 75: PRISCILA DE OLIVEIRA MENECHINI
  -- Email: priscila.menechini@gmail.com | CPF: 081.735.227-90 | Senha: Priscila
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'priscila.menechini@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'priscila.menechini@gmail.com',
      crypt('Priscila', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'PRISCILA DE OLIVEIRA MENECHINI', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '081.735.227-90')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '081.735.227-90';

  -- Aluno 76: RAFAEL DE OLIVEIRA FELICIO
  -- Email: rafael@gmail.com | CPF: 105.971.697-64 | Senha: Rafael
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'rafael@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'rafael@gmail.com',
      crypt('Rafael', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'RAFAEL DE OLIVEIRA FELICIO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '105.971.697-64')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '105.971.697-64';

  -- Aluno 77: RAFAEL LUCIANO FAUSTINO SILVEIRA
  -- Email: rafael.luciano.faustino.silveira@gmail.com | CPF: 183.582.977-50 | Senha: Rafael
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'rafael.luciano.faustino.silveira@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'rafael.luciano.faustino.silveira@gmail.com',
      crypt('Rafael', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'RAFAEL LUCIANO FAUSTINO SILVEIRA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '183.582.977-50')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '183.582.977-50';

  -- Aluno 78: RALFE ASSAD RODRIGUES
  -- Email: ralfe.assad.rodrigues@gmail.com | CPF: 136.408.067-27 | Senha: Ralfe0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'ralfe.assad.rodrigues@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'ralfe.assad.rodrigues@gmail.com',
      crypt('Ralfe0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'RALFE ASSAD RODRIGUES', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '136.408.067-27')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '136.408.067-27';

  -- Aluno 79: RAMON VERISSIMO DOS SANTOS
  -- Email: ramon.verissimo.santos@gmail.com | CPF: 129.708.827-10 | Senha: Ramon0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'ramon.verissimo.santos@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'ramon.verissimo.santos@gmail.com',
      crypt('Ramon0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'RAMON VERISSIMO DOS SANTOS', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '129.708.827-10')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '129.708.827-10';

  -- Aluno 80: RENAN TEIXEIRA CARNEIRO
  -- Email: renan.teixeira.c@hotmail.com | CPF: 149.642.027-63 | Senha: Renan0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'renan.teixeira.c@hotmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'renan.teixeira.c@hotmail.com',
      crypt('Renan0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'RENAN TEIXEIRA CARNEIRO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '149.642.027-63')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '149.642.027-63';

  -- Aluno 81: SANDRELI COSTA DIAS
  -- Email: sandrelilourenco22@gmail.com | CPF: 069.135.297-67 | Senha: Sandreli
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'sandrelilourenco22@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'sandrelilourenco22@gmail.com',
      crypt('Sandreli', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'SANDRELI COSTA DIAS', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '069.135.297-67')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '069.135.297-67';

  -- Aluno 82: SILVANA TEIXEIRA DE ABREU
  -- Email: silvana.teixeira.abreu@gmail.com | CPF: 005.498.797-06 | Senha: Silvana
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'silvana.teixeira.abreu@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'silvana.teixeira.abreu@gmail.com',
      crypt('Silvana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'SILVANA TEIXEIRA DE ABREU', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '005.498.797-06')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '005.498.797-06';

  -- Aluno 83: SIMONE DA SILVA CARDOSO
  -- Email: cardosoloira50@gmail.com | CPF: 084.760.577-92 | Senha: Simone
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'cardosoloira50@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'cardosoloira50@gmail.com',
      crypt('Simone', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'SIMONE DA SILVA CARDOSO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '084.760.577-92')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '084.760.577-92';

  -- Aluno 84: TATIANA DE SOZA PONTES TEIXEIRA
  -- Email: pontestatiana1984@gmail.com | CPF: 103.526.877-97 | Senha: Tatiana
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'pontestatiana1984@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'pontestatiana1984@gmail.com',
      crypt('Tatiana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'TATIANA DE SOZA PONTES TEIXEIRA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '103.526.877-97')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '103.526.877-97';

  -- Aluno 85: THAIANE CARDOSO PEREIRA
  -- Email: thaicpenf@gmail.com | CPF: 129.348.437-77 | Senha: Thaiane
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'thaicpenf@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'thaicpenf@gmail.com',
      crypt('Thaiane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'THAIANE CARDOSO PEREIRA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '129.348.437-77')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '129.348.437-77';

  -- Aluno 86: THIAGO DE OLIVEIRA ROSA
  -- Email: to788484@gmail.com | CPF: 150.382.327-01 | Senha: Thiago
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'to788484@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'to788484@gmail.com',
      crypt('Thiago', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'THIAGO DE OLIVEIRA ROSA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '150.382.327-01')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '150.382.327-01';

  -- Aluno 87: TIAGO CORREA DE MEDEIROS
  -- Email: contatotiagomedeiros@hotmail.com | CPF: 099.024.137-81 | Senha: Tiago0
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'contatotiagomedeiros@hotmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'contatotiagomedeiros@hotmail.com',
      crypt('Tiago0', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'TIAGO CORREA DE MEDEIROS', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '099.024.137-81')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '099.024.137-81';

  -- Aluno 88: UILIAN CARDOSO DOS SANTOS
  -- Email: uilian.cardoso.santos@gmail.com | CPF: 054.460.897-66 | Senha: Uilian
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'uilian.cardoso.santos@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'uilian.cardoso.santos@gmail.com',
      crypt('Uilian', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'UILIAN CARDOSO DOS SANTOS', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '054.460.897-66')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '054.460.897-66';

  -- Aluno 89: VINICIUS MENEZES DE OLIVEIRA
  -- Email: vinicius.vmo@gmail.com | CPF: 088.136.644-78 | Senha: Vinicius
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'vinicius.vmo@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'vinicius.vmo@gmail.com',
      crypt('Vinicius', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'VINICIUS MENEZES DE OLIVEIRA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '088.136.644-78')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '088.136.644-78';

  -- Aluno 90: WANDERSON PAES LEME DA SILVA
  -- Email: wanderson.paes.leme.silva@gmail.com | CPF: 099.396.597-09 | Senha: Wanderson
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'wanderson.paes.leme.silva@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'wanderson.paes.leme.silva@gmail.com',
      crypt('Wanderson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'WANDERSON PAES LEME DA SILVA', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '099.396.597-09')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '099.396.597-09';

  -- Aluno 91: WILLIAM CRUZ DE SOUZA BORGES
  -- Email: borgeswillia852@gmail.com | CPF: 129.354.987-80 | Senha: William
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'borgeswillia852@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'borgeswillia852@gmail.com',
      crypt('William', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'WILLIAM CRUZ DE SOUZA BORGES', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '129.354.987-80')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '129.354.987-80';

  -- Aluno 92: YAGO DE ARAUJO FIDALGO
  -- Email: yagofidalgo@gmail.com | CPF: 140.735.077-37 | Senha: Yago00
  SELECT id INTO v_user_id FROM auth.users WHERE lower(email) = 'yagofidalgo@gmail.com';
  IF v_user_id IS NULL THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(), 'authenticated', 'authenticated',
      'yagofidalgo@gmail.com',
      crypt('Yago00', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      jsonb_build_object('full_name', 'YAGO DE ARAUJO FIDALGO', 'must_reset_password', true),
      NOW(), NOW(), '', '', '', ''
    ) RETURNING id INTO v_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (v_user_id, 'user', '140.735.077-37')
  ON CONFLICT (user_id) DO UPDATE SET role = 'user', cpf = '140.735.077-37';

END
$$;

-- ============================================================
-- PARTE 2: Corrigir role de 3 usuarios (monitor -> user)
-- ============================================================
UPDATE public.user_roles ur
SET role = 'user'
FROM auth.users u
WHERE ur.user_id = u.id
  AND lower(u.email) IN (
  'aanalaura880@gmail.com',
  'luizacalazans11@icloud.com',
  'xavierjosecarlosx@gmail.com'
);

-- ============================================================
-- PARTE 3: Atualizar CPF de 11 usuarios com CPF nulo ou incorreto
-- ============================================================
UPDATE public.user_roles ur
SET cpf = CASE lower(u.email)
  WHEN 'andersonsampaio.jll@gmail.com' THEN '090.652.037-10'
  WHEN 'andre.luiz.araujo.oliveira@gmail.com' THEN '023.019.367-67'
  WHEN 'arthuraureliomed@gmail.com' THEN '126.012.007-40'
  WHEN 'carlosestofadosni@gmail.com' THEN '083.779.837-02'
  WHEN 'claudiapxto@gmail.com' THEN '047.070.277-09'
  WHEN 'edilene.rodrigues.silva@gmail.com' THEN '016.235.607-21'
  WHEN 'kenia.souza.goncalves.santos@gmail.com' THEN '044.750.047-30'
  WHEN 'leandro.rocha.paura@gmail.com' THEN '099.849.247-77'
  WHEN 'oadriano2727@yahoo.com' THEN '080.176.067-45'
  WHEN 'rneversonrocha31@gmail.com' THEN '113.096.037-40'
  WHEN 'vander.araujo@gmail.com' THEN '103.722.919-21'
END
FROM auth.users u
WHERE ur.user_id = u.id
  AND lower(u.email) IN (
  'andersonsampaio.jll@gmail.com',
  'andre.luiz.araujo.oliveira@gmail.com',
  'arthuraureliomed@gmail.com',
  'carlosestofadosni@gmail.com',
  'claudiapxto@gmail.com',
  'edilene.rodrigues.silva@gmail.com',
  'kenia.souza.goncalves.santos@gmail.com',
  'leandro.rocha.paura@gmail.com',
  'oadriano2727@yahoo.com',
  'rneversonrocha31@gmail.com',
  'vander.araujo@gmail.com'
);

-- ============================================================
-- VERIFICACAO FINAL
-- ============================================================

-- 1. Total de usuarios com role='user'
SELECT COUNT(*) AS total_users
FROM public.user_roles
WHERE role = 'user';

-- 2. Confirmar que os 92 alunos inseridos existem no banco
SELECT u.email, ur.role, ur.cpf
FROM auth.users u
JOIN public.user_roles ur ON ur.user_id = u.id
WHERE lower(u.email) IN (
  'adriano.rodrigues.araujo@gmail.com',
  'adriele.melo@live.com',
  'ailtonmendonça333@gmail.com',
  'assisgrades@gmail.com',
  'alessandro.rocha.paura@gmail.com',
  'aj4605480@gmail.com',
  'alexandre.januario@gmail.com',
  'ana.carla.lima.pereira@gmail.com',
  'analuizapessanha414@gmail.com',
  'floranasouza1@gmail.com',
  'anderson.rodrigues.oliveira@gmail.com',
  'rodrigues.dessa.1989@gmail.com',
  'andrynedepaulal6@gmail.com',
  'angelinaaninha02@gmail.com',
  'antonio.alison.costa.matias@gmail.com',
  'bruno.accioli.costa@gmail.com',
  'brunocarvalho.gestao@gmail.com',
  'bruno.dorna.souza@gmail.com',
  'camila.alencar.cortes@gmail.com',
  'camila.martins.leal.nascimento@gmail.com',
  'carlos.alberto.souza@gmail.com',
  'carlos.ribeiro.simoes@hotmail.com',
  'carolinemayara800@gmail.com',
  'clayton.santos.liberatori@gmail.com',
  'cleber.siqueira.silva.pereira@gmail.com',
  'daniel.teixeira.souza@gmail.com',
  'dayanadiniz468@gmail.com',
  'demetrius.figueiredo@gmail.com',
  'elaine.moraes.sanches@gmail.com',
  'elisaaraujo@gmail.com',
  'manuh_ivanovich@hotmail.com',
  'emerson.leonardo.silva.gomes@gmail.com',
  'fabiosilva@gmail.com',
  'fatimacarvalhoo804@gmail.com',
  'fernando.cruz.silva@gmail.com',
  'gabrielgorgeswerneck@gmail.com',
  'henrique.carvalho.pereira@gmail.com',
  'henrique.jesus.silva.ferreira@gmail.com',
  'israel.cesar.marques.junior@gmail.com',
  'israel.valdevido.limeira@gmail.com',
  'izabellamrodrigues2001@gmail.com',
  'jaime.souza.sa@gmail.com',
  'jefferson.matos.assis@gmail.com',
  'jilvania.soares.mota.albino@gmail.com',
  'lpnjhon@gmail.com',
  'jordanna.lima24@gmail.com',
  'joseeriva@gmail.com',
  'joseleandrocampelocardoso@gmail.com',
  'jose.garcia.castro@gmail.com',
  'joyce.goncalves.souza@gmail.com',
  'julio.cesar.lourenco.silva@gmail.com',
  'julio.cesar.lourenco.silva.junior@gmail.com',
  'julio.cezar.souza.silva@gmail.com',
  'leandropontes323@gmail.com',
  'leonardo.junior.lima.sacramento@gmail.com',
  'lethiciasantosss@gmail.com',
  'lucas.messias.moraes@gmail.com',
  'lucienerocha@gmail.com',
  'felipe.021@hotmail.com',
  'l.phelie@gmail.com',
  'magno.furtado.nobrega@gmail.com',
  'marco.bastos@gmail.com',
  'mariaangelbrandao25@gmail.com',
  'mariopereira19222@hotmail.com',
  'marisa.farroco.tavares.azevedo@gmail.com',
  'matheus.moura.costa@gmail.com',
  'jrdopulapula2248@gmail.com',
  'maxuel.batista1978@gmail.com',
  'michel.anderson.belmira.souza@gmail.com',
  'eunataliamiranda@hotmail.com',
  'augustopablo408@gmail.com',
  '3p.pablo@gmail.com',
  'patricia.cortes@gmail.com',
  'poliamral@gmail.com',
  'priscila.menechini@gmail.com',
  'rafael@gmail.com',
  'rafael.luciano.faustino.silveira@gmail.com',
  'ralfe.assad.rodrigues@gmail.com',
  'ramon.verissimo.santos@gmail.com',
  'renan.teixeira.c@hotmail.com',
  'sandrelilourenco22@gmail.com',
  'silvana.teixeira.abreu@gmail.com',
  'cardosoloira50@gmail.com',
  'pontestatiana1984@gmail.com',
  'thaicpenf@gmail.com',
  'to788484@gmail.com',
  'contatotiagomedeiros@hotmail.com',
  'uilian.cardoso.santos@gmail.com',
  'vinicius.vmo@gmail.com',
  'wanderson.paes.leme.silva@gmail.com',
  'borgeswillia852@gmail.com',
  'yagofidalgo@gmail.com'
)
ORDER BY u.email;

-- 3. Confirmar correcao de roles (deve retornar 3 linhas com role='user')
SELECT u.email, ur.role
FROM auth.users u
JOIN public.user_roles ur ON ur.user_id = u.id
WHERE lower(u.email) IN (
  'aanalaura880@gmail.com',
  'luizacalazans11@icloud.com',
  'xavierjosecarlosx@gmail.com'
);

-- 4. Confirmar CPFs atualizados (deve retornar 11 linhas com CPF preenchido)
SELECT u.email, ur.cpf
FROM auth.users u
JOIN public.user_roles ur ON ur.user_id = u.id
WHERE lower(u.email) IN (
  'andersonsampaio.jll@gmail.com',
  'andre.luiz.araujo.oliveira@gmail.com',
  'arthuraureliomed@gmail.com',
  'carlosestofadosni@gmail.com',
  'claudiapxto@gmail.com',
  'edilene.rodrigues.silva@gmail.com',
  'kenia.souza.goncalves.santos@gmail.com',
  'leandro.rocha.paura@gmail.com',
  'oadriano2727@yahoo.com',
  'rneversonrocha31@gmail.com',
  'vander.araujo@gmail.com'
)
ORDER BY u.email;
