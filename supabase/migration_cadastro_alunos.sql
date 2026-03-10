-- ============================================
-- MIGRATION: Adicionar campo CPF e cadastrar alunos
-- ============================================
-- Execute este SQL no SQL Editor do Supabase
-- APÓS ter executado as migrations anteriores
-- ============================================

-- ============================================
-- PARTE 1: Adicionar coluna CPF à tabela user_roles
-- ============================================

ALTER TABLE user_roles ADD COLUMN IF NOT EXISTS cpf TEXT;

-- Índice único para evitar CPFs duplicados (ignora NULLs)
CREATE UNIQUE INDEX IF NOT EXISTS idx_user_roles_cpf ON user_roles (cpf) WHERE cpf IS NOT NULL;

-- ============================================
-- PARTE 2: Cadastro dos alunos via Supabase Auth
-- ============================================
-- IMPORTANTE: Este SQL deve ser executado no SQL Editor do Supabase
-- A senha de cada aluno é o PRIMEIRO NOME com a primeira letra maiúscula.
-- Exemplo: LUCILENE ARAUJO -> senha: Lucilene
-- Os alunos devem trocar a senha no primeiro acesso.
-- ============================================

DO $$
DECLARE
  new_user_id UUID;
BEGIN

  -- 1. GABRIELLE TELLES DE MORAES (Alunos)
  -- Email: gabisouza220229@gmail.com | CPF: 131.260.927-30 | Senha: Gabrielle
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'gabisouza220229@gmail.com';
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
      'gabisouza220229@gmail.com',
      crypt('Gabrielle', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GABRIELLE TELLES DE MORAES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '131.260.927-30')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '131.260.927-30';

  -- 2. ULISSIS DOS SANTOS BERTY (Alunos)
  -- Email: uli_ber@gmail.com | CPF: 161.232.627-77 | Senha: Ulissis
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'uli_ber@gmail.com';
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
      'uli_ber@gmail.com',
      crypt('Ulissis', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ULISSIS DOS SANTOS BERTY"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '161.232.627-77')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '161.232.627-77';

  -- 3. THOBIAS ABELHA RIBEIRO (Alunos)
  -- Email: thobias_abelha@gmail.com | CPF: 155.637.707-02 | Senha: Thobias
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'thobias_abelha@gmail.com';
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
      'thobias_abelha@gmail.com',
      crypt('Thobias', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "THOBIAS ABELHA RIBEIRO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '155.637.707-02')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '155.637.707-02';

  -- 4. MARIA EDUARDA DE OLIVEIRA CUCO TRALLI (Alunos)
  -- Email: dudatralli70@gmail.com | CPF: 189.877.557-54 | Senha: Maria
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'dudatralli70@gmail.com';
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
      'dudatralli70@gmail.com',
      crypt('Maria', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARIA EDUARDA DE OLIVEIRA CUCO TRALLI"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '189.877.557-54')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '189.877.557-54';

  -- 5. JOÃO GABRIEL MONTEIRO (Alunos)
  -- Email: gabslok1br@gmail.com | CPF: 177.438.767-05 | Senha: João
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'gabslok1br@gmail.com';
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
      'gabslok1br@gmail.com',
      crypt('João', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOÃO GABRIEL MONTEIRO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '177.438.767-05')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '177.438.767-05';

  -- 6. PEDRO LASEVITCH PINHEIRO (Alunos)
  -- Email: pedrolasevitch@gmail.com | CPF: 136.562.307-65 | Senha: Pedro
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'pedrolasevitch@gmail.com';
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
      'pedrolasevitch@gmail.com',
      crypt('Pedro', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "PEDRO LASEVITCH PINHEIRO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '136.562.307-65')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '136.562.307-65';

  -- 7. ADENILSON DA SILVA ZACHARIAS (Alunos)
  -- Email: adenilsonzacarias123@gmail.com | CPF: 042.018.587-90 | Senha: Adenilson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'adenilsonzacarias123@gmail.com';
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
      'adenilsonzacarias123@gmail.com',
      crypt('Adenilson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ADENILSON DA SILVA ZACHARIAS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '042.018.587-90')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '042.018.587-90';

  -- 8. DANIELE BARBOSA MOREIRA (Alunos)
  -- Email: barbosadani388@gmail.com | CPF: 122.264.927-63 | Senha: Daniele
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'barbosadani388@gmail.com';
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
      'barbosadani388@gmail.com',
      crypt('Daniele', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DANIELE BARBOSA MOREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '122.264.927-63')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '122.264.927-63';

  -- 9. JOÃO LUIZ DA SILVA BERTO (Alunos)
  -- Email: joaoberto@gmail.com | CPF: 041.971.897-45 | Senha: João
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'joaoberto@gmail.com';
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
      'joaoberto@gmail.com',
      crypt('João', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOÃO LUIZ DA SILVA BERTO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '041.971.897-45')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '041.971.897-45';

  -- 10. DENILSON PEREIRA RODRIGUES (Alunos)
  -- Email: denipereira@gmail.com | CPF: 039.469.487-23 | Senha: Denilson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'denipereira@gmail.com';
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
      'denipereira@gmail.com',
      crypt('Denilson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DENILSON PEREIRA RODRIGUES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '039.469.487-23')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '039.469.487-23';

  -- 11. EDUARDA DI SANTO SALOMONE (Alunos)
  -- Email: eduardadisanto326@gmail.com | CPF: 138.138.837-01 | Senha: Eduarda
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'eduardadisanto326@gmail.com';
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
      'eduardadisanto326@gmail.com',
      crypt('Eduarda', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "EDUARDA DI SANTO SALOMONE"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '138.138.837-01')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '138.138.837-01';

  -- 12. ALINE LEIROZ WERNECK (Alunos)
  -- Email: alinewerneck96leiroz@gmail.com | CPF: 176.871.817-27 | Senha: Aline
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'alinewerneck96leiroz@gmail.com';
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
      'alinewerneck96leiroz@gmail.com',
      crypt('Aline', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ALINE LEIROZ WERNECK"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '176.871.817-27')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '176.871.817-27';

  -- 13. NATAN DE OLIVEIRA RIBEIRO (Alunos)
  -- Email: ribeironatan566@gmail.com | CPF: 143.755.577-29 | Senha: Natan
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'ribeironatan566@gmail.com';
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
      'ribeironatan566@gmail.com',
      crypt('Natan', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "NATAN DE OLIVEIRA RIBEIRO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '143.755.577-29')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '143.755.577-29';

  -- 14. LEANDRO BARRETO ANTUNES DOS SANTOS (Alunos)
  -- Email: leannunes17@gmail.com | CPF: 081.935.207-18 | Senha: Leandro
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'leannunes17@gmail.com';
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
      'leannunes17@gmail.com',
      crypt('Leandro', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LEANDRO BARRETO ANTUNES DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '081.935.207-18')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '081.935.207-18';

  -- 15. MARCOS VENICIO PEREIRA GONÇALVES (Alunos)
  -- Email: marcosgoncalvez_@hotmail.com | CPF: 135.928.997-67 | Senha: Marcos
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marcosgoncalvez_@hotmail.com';
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
      'marcosgoncalvez_@hotmail.com',
      crypt('Marcos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCOS VENICIO PEREIRA GONÇALVES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '135.928.997-67')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '135.928.997-67';

  -- 16. PAULO ROGERIO PIRES SENHORINHO (Alunos)
  -- Email: paulosenhorinho1@gmail.com | CPF: 029.743.827-11 | Senha: Paulo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'paulosenhorinho1@gmail.com';
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
      'paulosenhorinho1@gmail.com',
      crypt('Paulo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "PAULO ROGERIO PIRES SENHORINHO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '029.743.827-11')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '029.743.827-11';

  -- 17. VAGNER SANTOS LEONIDIO (Alunos)
  -- Email: vagnerleonidio.vl@gmail.com | CPF: 085.416.347-60 | Senha: Vagner
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'vagnerleonidio.vl@gmail.com';
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
      'vagnerleonidio.vl@gmail.com',
      crypt('Vagner', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "VAGNER SANTOS LEONIDIO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '085.416.347-60')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '085.416.347-60';

  -- 18. CAIO FELIPE SODRÉ BARBOSA (Alunos)
  -- Email: caiofelipe0216@gmail.com | CPF: 204.414.727-02 | Senha: Caio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'caiofelipe0216@gmail.com';
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
      'caiofelipe0216@gmail.com',
      crypt('Caio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CAIO FELIPE SODRÉ BARBOSA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '204.414.727-02')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '204.414.727-02';

  -- 19. DIEGO FERREIRA RANGEL (Alunos)
  -- Email: diegoferangel@hotmail.com | CPF: 119.388.147-11 | Senha: Diego
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'diegoferangel@hotmail.com';
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
      'diegoferangel@hotmail.com',
      crypt('Diego', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DIEGO FERREIRA RANGEL"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '119.388.147-11')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '119.388.147-11';

  -- 20. FABIO DE AZEVEDO BARBOSA (Alunos)
  -- Email: fabio1977sapo@hotmail.com | CPF: 081.664.057-25 | Senha: Fabio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'fabio1977sapo@hotmail.com';
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
      'fabio1977sapo@hotmail.com',
      crypt('Fabio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "FABIO DE AZEVEDO BARBOSA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '081.664.057-25')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '081.664.057-25';

  -- 21. FILIPE JEAN BARROS TZOULAS (Alunos)
  -- Email: filipe_jean@outlook.com | CPF: 099.701.957-35 | Senha: Filipe
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'filipe_jean@outlook.com';
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
      'filipe_jean@outlook.com',
      crypt('Filipe', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "FILIPE JEAN BARROS TZOULAS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '099.701.957-35')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '099.701.957-35';

  -- 22. PÂMELLA BARRETO BARBOSA (Alunos)
  -- Email: pamellabarreto18@gmail.com | CPF: 138.704.797-36 | Senha: Pâmella
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'pamellabarreto18@gmail.com';
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
      'pamellabarreto18@gmail.com',
      crypt('Pâmella', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "PÂMELLA BARRETO BARBOSA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '138.704.797-36')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '138.704.797-36';

  -- 23. THAMYRES CUNHA FERREIRA BRANCO (Alunos)
  -- Email: thamyrescunhafe@gmail.com | CPF: 149.991.837-22 | Senha: Thamyres
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'thamyrescunhafe@gmail.com';
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
      'thamyrescunhafe@gmail.com',
      crypt('Thamyres', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "THAMYRES CUNHA FERREIRA BRANCO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '149.991.837-22')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '149.991.837-22';

  -- 24. LUIZA DE SOUZA CALAZANS (Alunos)
  -- Email: luizacalazans11@icloud.com | CPF: 195.477.337-45 | Senha: Luiza
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'luizacalazans11@icloud.com';
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
      'luizacalazans11@icloud.com',
      crypt('Luiza', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LUIZA DE SOUZA CALAZANS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '195.477.337-45')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '195.477.337-45';

  -- 25. LUDIMILLA QUINTANILHA FURTADO (Alunos)
  -- Email: ludmilla_quintanilha@hotmail.com | CPF: 147.405.847-78 | Senha: Ludimilla
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'ludmilla_quintanilha@hotmail.com';
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
      'ludmilla_quintanilha@hotmail.com',
      crypt('Ludimilla', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LUDIMILLA QUINTANILHA FURTADO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '147.405.847-78')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '147.405.847-78';

  -- 26. GUILHERME MAIA PEDRA RIBEIRO DE C GONÇALVES (Alunos)
  -- Email: guimaia17@gmail.com | CPF: 199.686.307-65 | Senha: Guilherme
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'guimaia17@gmail.com';
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
      'guimaia17@gmail.com',
      crypt('Guilherme', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GUILHERME MAIA PEDRA RIBEIRO DE C GONÇALVES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '199.686.307-65')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '199.686.307-65';

  -- 27. ANA CLARA VIANA DO AMARAL PAES (Alunos)
  -- Email: anaclaravianadoamaralpaes@gmail.com | CPF: 176.095.917-00 | Senha: Ana
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'anaclaravianadoamaralpaes@gmail.com';
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
      'anaclaravianadoamaralpaes@gmail.com',
      crypt('Ana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANA CLARA VIANA DO AMARAL PAES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '176.095.917-00')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '176.095.917-00';

  -- 28. GIOVANNA CORREA SENHORINHO (Alunos)
  -- Email: giovannasenhorinho6@gmail.com | CPF: 208.903.817-98 | Senha: Giovanna
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'giovannasenhorinho6@gmail.com';
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
      'giovannasenhorinho6@gmail.com',
      crypt('Giovanna', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GIOVANNA CORREA SENHORINHO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '208.903.817-98')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '208.903.817-98';

  -- 29. EDSON SALTEIRO CAVALCANTI DE SÁ (Alunos)
  -- Email: edsonsalteiroxp@gmail.com | CPF: 064.200.237-18 | Senha: Edson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'edsonsalteiroxp@gmail.com';
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
      'edsonsalteiroxp@gmail.com',
      crypt('Edson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "EDSON SALTEIRO CAVALCANTI DE SÁ"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '064.200.237-18')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '064.200.237-18';

  -- 30. LUCIANO GONÇALVES PERES (Alunos)
  -- Email: peresluciano688@gmail.com | CPF: 089.102.267.81 | Senha: Luciano
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'peresluciano688@gmail.com';
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
      'peresluciano688@gmail.com',
      crypt('Luciano', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LUCIANO GONÇALVES PERES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '089.102.267.81')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '089.102.267.81';

  -- 31. ANA LAURA NOBREGA AMORIM (Alunos)
  -- Email: aanalaura880@gmail.com | CPF: 179.414.267-30 | Senha: Ana
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'aanalaura880@gmail.com';
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
      'aanalaura880@gmail.com',
      crypt('Ana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANA LAURA NOBREGA AMORIM"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '179.414.267-30')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '179.414.267-30';

  -- 32. JOÃO PAULO CORRÊA SENHORINHO (Alunos)
  -- Email: joãopaulosenhorinho3@gmail.com | CPF: 197.736.497-76 | Senha: João
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'joãopaulosenhorinho3@gmail.com';
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
      'joãopaulosenhorinho3@gmail.com',
      crypt('João', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOÃO PAULO CORRÊA SENHORINHO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '197.736.497-76')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '197.736.497-76';

  -- 33. SOLANGE CORREA DIAS (Alunos)
  -- Email: solangecorreadias3@gmail.com | CPF: 095.480.217-90 | Senha: Solange
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'solangecorreadias3@gmail.com';
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
      'solangecorreadias3@gmail.com',
      crypt('Solange', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SOLANGE CORREA DIAS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '095.480.217-90')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '095.480.217-90';

  -- 34. PAOLA CORREA SENHORINHO (Alunos)
  -- Email: paolasenhorinho723@gmail.com | CPF: 145.290.217-85 | Senha: Paola
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'paolasenhorinho723@gmail.com';
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
      'paolasenhorinho723@gmail.com',
      crypt('Paola', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "PAOLA CORREA SENHORINHO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '145.290.217-85')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '145.290.217-85';

  -- 35. BRUNO LACERDA DE OLIVEIRA (Alunos)
  -- Email: bruno_lacerda16@hotmail.com | CPF: 166.669.047-37 | Senha: Bruno
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'bruno_lacerda16@hotmail.com';
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
      'bruno_lacerda16@hotmail.com',
      crypt('Bruno', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "BRUNO LACERDA DE OLIVEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '166.669.047-37')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '166.669.047-37';

  -- 36. JOSE CARLOS XAVIER (Alunos)
  -- Email: carlosalexaurelio@gmail.com | CPF: 210.179.537-08 | Senha: Jose
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'carlosalexaurelio@gmail.com';
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
      'carlosalexaurelio@gmail.com',
      crypt('Jose', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOSE CARLOS XAVIER"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '210.179.537-08')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '210.179.537-08';

  -- 37. CLAUDIO VASQUES CHUMBINHO DOS SANTOS (Alunos)
  -- Email: claudiochumbinho13@gmail.com | CPF: 026.413.407-98 | Senha: Claudio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'claudiochumbinho13@gmail.com';
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
      'claudiochumbinho13@gmail.com',
      crypt('Claudio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CLAUDIO VASQUES CHUMBINHO DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '026.413.407-98')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '026.413.407-98';

  -- 38. FELIPE MARQUES CHUMBINHO DOS SANTOS (Alunos)
  -- Email: felipechumbinho02@gmail.com | CPF: 188.815.287-70 | Senha: Felipe
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'felipechumbinho02@gmail.com';
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
      'felipechumbinho02@gmail.com',
      crypt('Felipe', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "FELIPE MARQUES CHUMBINHO DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '188.815.287-70')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '188.815.287-70';

  -- 39. ISABEL CAMPOS OLIVEIRA RASCÃO DOS SANTOS (Alunos)
  -- Email: isabelrascao5522@gmail.com | CPF: 129.612.367-70 | Senha: Isabel
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'isabelrascao5522@gmail.com';
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
      'isabelrascao5522@gmail.com',
      crypt('Isabel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ISABEL CAMPOS OLIVEIRA RASCÃO DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '129.612.367-70')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '129.612.367-70';

  -- 40. ELVIRA VILELA BRUM DE MACEDO (Alunos)
  -- Email: elvirabrum99@gmail.com | CPF: 106.502.517-33 | Senha: Elvira
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'elvirabrum99@gmail.com';
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
      'elvirabrum99@gmail.com',
      crypt('Elvira', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ELVIRA VILELA BRUM DE MACEDO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '106.502.517-33')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '106.502.517-33';

  -- 41. VIVIANE ALVES DE PAULA CORDEIRO (Alunos)
  -- Email: viviane7381@yahoo.com..br | CPF: 041.201.077-10 | Senha: Viviane
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'viviane7381@yahoo.com..br';
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
      'viviane7381@yahoo.com..br',
      crypt('Viviane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "VIVIANE ALVES DE PAULA CORDEIRO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '041.201.077-10')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '041.201.077-10';

  -- 42. MARIA JOSÉ DE SOUZA FOLLY (Alunos)
  -- Email: maria.folly@gmail.com | CPF: 027.002.287-23 | Senha: Maria
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'maria.folly@gmail.com';
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
      'maria.folly@gmail.com',
      crypt('Maria', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARIA JOSÉ DE SOUZA FOLLY"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '027.002.287-23')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '027.002.287-23';

  -- 43. ANDRÉ LAMAS DE LIMA COUTINHO (Alunos)
  -- Email: andrecoutinho20@hotmail.com | CPF: 185.710.407-29 | Senha: André
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'andrecoutinho20@hotmail.com';
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
      'andrecoutinho20@hotmail.com',
      crypt('André', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANDRÉ LAMAS DE LIMA COUTINHO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '185.710.407-29')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '185.710.407-29';

  -- 44. DAVID FERREIRA SANTOS FONTOURA (Alunos)
  -- Email: df0462230@gmail.com | CPF: 146.495.917-08 | Senha: David
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'df0462230@gmail.com';
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
      'df0462230@gmail.com',
      crypt('David', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DAVID FERREIRA SANTOS FONTOURA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '146.495.917-08')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '146.495.917-08';

  -- 45. KATHARYM CAROL ROJAS BÒRQUEZ JOY (Alunos)
  -- Email: katharymchaim333@gmail.com | CPF: 082.924.377-11 | Senha: Katharym
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'katharymchaim333@gmail.com';
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
      'katharymchaim333@gmail.com',
      crypt('Katharym', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "KATHARYM CAROL ROJAS BÒRQUEZ JOY"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '082.924.377-11')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '082.924.377-11';

  -- 46. LUCIMAR ROSA CARDOSO EUFRASIO (Alunos)
  -- Email: lucimar.eufrasio@gmail.com | CPF: 120.008.357-16 | Senha: Lucimar
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lucimar.eufrasio@gmail.com';
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
      'lucimar.eufrasio@gmail.com',
      crypt('Lucimar', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LUCIMAR ROSA CARDOSO EUFRASIO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '120.008.357-16')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '120.008.357-16';

  -- 47. NATHALIA CRUZ DE MORAES FAGUNDES (Alunos)
  -- Email: nathalicsfagundes@gmail.com | CPF: 170.986.717-54 | Senha: Nathalia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'nathalicsfagundes@gmail.com';
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
      'nathalicsfagundes@gmail.com',
      crypt('Nathalia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "NATHALIA CRUZ DE MORAES FAGUNDES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '170.986.717-54')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '170.986.717-54';

  -- 48. RAMA BEZERRA AZEVEDO GULINELE LOPES (Alunos)
  -- Email: ramagulinele@gmail.com | CPF: 115.390.297-43 | Senha: Rama
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'ramagulinele@gmail.com';
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
      'ramagulinele@gmail.com',
      crypt('Rama', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "RAMA BEZERRA AZEVEDO GULINELE LOPES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '115.390.297-43')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '115.390.297-43';

  -- 49. EDSANDRO RANGEL JOIA MERLIN (Alunos)
  -- Email: edsandrorangel@hotmail.com | CPF: 165.117.047-93 | Senha: Edsandro
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'edsandrorangel@hotmail.com';
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
      'edsandrorangel@hotmail.com',
      crypt('Edsandro', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "EDSANDRO RANGEL JOIA MERLIN"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '165.117.047-93')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '165.117.047-93';

  -- 50. THAYSSA ANDRADE SIQUEIRA ANTUNES (Alunos)
  -- Email: thayssasiqueira20@icloud.com | CPF: 201.224.457-24 | Senha: Thayssa
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'thayssasiqueira20@icloud.com';
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
      'thayssasiqueira20@icloud.com',
      crypt('Thayssa', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "THAYSSA ANDRADE SIQUEIRA ANTUNES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '201.224.457-24')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '201.224.457-24';

  -- 51. DELIMAR MARTINS DA SILVA (Alunos)
  -- Email: delimarmartins@gmail.com | CPF: 078.044.027-75 | Senha: Delimar
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'delimarmartins@gmail.com';
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
      'delimarmartins@gmail.com',
      crypt('Delimar', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DELIMAR MARTINS DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '078.044.027-75')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '078.044.027-75';

  -- 52. EVERALDO DE ALMEIDA MEDEIROS (Alunos)
  -- Email: everaldo.medeiros@gmail.com | CPF: 835.339.907-53 | Senha: Everaldo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'everaldo.medeiros@gmail.com';
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
      'everaldo.medeiros@gmail.com',
      crypt('Everaldo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "EVERALDO DE ALMEIDA MEDEIROS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '835.339.907-53')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '835.339.907-53';

  -- 53. CRISTIANO GONÇALVES MARIA (Alunos)
  -- Email: cristiano.maria@gmail.com | CPF: 026.914.089-14 | Senha: Cristiano
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'cristiano.maria@gmail.com';
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
      'cristiano.maria@gmail.com',
      crypt('Cristiano', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CRISTIANO GONÇALVES MARIA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '026.914.089-14')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '026.914.089-14';

  -- 54. FRANCISCO TEIXEIRA DE JESUS (Alunos)
  -- Email: francisco.teixeira.jesus@gmail.com | CPF: 860.572.525-78 | Senha: Francisco
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'francisco.teixeira.jesus@gmail.com';
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
      'francisco.teixeira.jesus@gmail.com',
      crypt('Francisco', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "FRANCISCO TEIXEIRA DE JESUS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '860.572.525-78')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '860.572.525-78';

  -- 55. KEYLIANE MARIA GUERREIRO DE SENA (Alunos)
  -- Email: keyliane.sena@gmail.com | CPF: 004.047.473-96 | Senha: Keyliane
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'keyliane.sena@gmail.com';
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
      'keyliane.sena@gmail.com',
      crypt('Keyliane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "KEYLIANE MARIA GUERREIRO DE SENA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '004.047.473-96')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '004.047.473-96';

  -- 56. LEANDRO FELINTO DA SILVA (Alunos)
  -- Email: lfelinto.silva@gmail.com | CPF: 111.681.917-75 | Senha: Leandro
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lfelinto.silva@gmail.com';
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
      'lfelinto.silva@gmail.com',
      crypt('Leandro', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LEANDRO FELINTO DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '111.681.917-75')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '111.681.917-75';

  -- 57. PEDRO PEREIRA DE SENA NETO (Alunos)
  -- Email: ppsenaneto@gmail.com | CPF: 158.770.967-88 | Senha: Pedro
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'ppsenaneto@gmail.com';
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
      'ppsenaneto@gmail.com',
      crypt('Pedro', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "PEDRO PEREIRA DE SENA NETO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '158.770.967-88')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '158.770.967-88';

  -- 58. RUTH GUERREIRO DE SENA DE SOUZA (Alunos)
  -- Email: ruthdesena333@gmail.com | CPF: 164.052.827-08 | Senha: Ruth
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'ruthdesena333@gmail.com';
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
      'ruthdesena333@gmail.com',
      crypt('Ruth', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "RUTH GUERREIRO DE SENA DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '164.052.827-08')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '164.052.827-08';

  -- 59. ANDRESSA SEPULVEDA SILVA (Alunos)
  -- Email: andressasepulveda@yahoo.com.br | CPF: 177.890.337-19 | Senha: Andressa
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'andressasepulveda@yahoo.com.br';
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
      'andressasepulveda@yahoo.com.br',
      crypt('Andressa', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANDRESSA SEPULVEDA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '177.890.337-19')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '177.890.337-19';

  -- 60. INGRID LIRIEL DE JESUS GOMES (Alunos)
  -- Email: liri.sampaio2002@gmail.com | CPF: 202.219.797-60 | Senha: Ingrid
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'liri.sampaio2002@gmail.com';
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
      'liri.sampaio2002@gmail.com',
      crypt('Ingrid', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "INGRID LIRIEL DE JESUS GOMES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '202.219.797-60')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '202.219.797-60';

  -- 61. ROGELSON SANCHES FONTOURA (Alunos)
  -- Email: rogelson852@gmail.com | CPF: 026.641.677-23 | Senha: Rogelson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'rogelson852@gmail.com';
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
      'rogelson852@gmail.com',
      crypt('Rogelson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ROGELSON SANCHES FONTOURA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '026.641.677-23')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '026.641.677-23';

  -- 62. AMANDA BARBOSA SANCHEZ (Alunos)
  -- Email: amanda.barbosa.sanchez@gmail.com | CPF: 159.294.217-22 | Senha: Amanda
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'amanda.barbosa.sanchez@gmail.com';
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
      'amanda.barbosa.sanchez@gmail.com',
      crypt('Amanda', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "AMANDA BARBOSA SANCHEZ"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '159.294.217-22')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '159.294.217-22';

  -- 63. MARINA FIGUEIREDO FONTOURA (Alunos)
  -- Email: marina.figueiredo.fontoura@gmail.com | CPF: 167.497.597-00 | Senha: Marina
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marina.figueiredo.fontoura@gmail.com';
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
      'marina.figueiredo.fontoura@gmail.com',
      crypt('Marina', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARINA FIGUEIREDO FONTOURA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '167.497.597-00')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '167.497.597-00';

  -- 64. DANIEL FIGUEIREDO FONTOURA (Alunos)
  -- Email: daniel.figueiredo.fontoura@gmail.com | CPF: 062.365.407-56 | Senha: Daniel
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'daniel.figueiredo.fontoura@gmail.com';
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
      'daniel.figueiredo.fontoura@gmail.com',
      crypt('Daniel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DANIEL FIGUEIREDO FONTOURA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '062.365.407-56')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '062.365.407-56';

  -- 65. DANIELE CRISTINA FIGUEIREDO FONTOURA (Alunos)
  -- Email: daniele.cristina.fontoura@gmail.com | CPF: 086.246.457-94 | Senha: Daniele
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'daniele.cristina.fontoura@gmail.com';
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
      'daniele.cristina.fontoura@gmail.com',
      crypt('Daniele', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DANIELE CRISTINA FIGUEIREDO FONTOURA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '086.246.457-94')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '086.246.457-94';

  -- 66. MAIANE LOPES GONÇALVES (Alunos)
  -- Email: maiane.lopes.goncalves@gmail.com | CPF: 152.691.207-47 | Senha: Maiane
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'maiane.lopes.goncalves@gmail.com';
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
      'maiane.lopes.goncalves@gmail.com',
      crypt('Maiane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MAIANE LOPES GONÇALVES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '152.691.207-47')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '152.691.207-47';

  -- 67. MARCUS VINICIUS RODRIGUES MORAES SILVA (Alunos)
  -- Email: marcus.vinicius.rodrigues.moraes.silva@gmail.com | CPF: 094.212.807-92 | Senha: Marcus
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marcus.vinicius.rodrigues.moraes.silva@gmail.com';
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
      'marcus.vinicius.rodrigues.moraes.silva@gmail.com',
      crypt('Marcus', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCUS VINICIUS RODRIGUES MORAES SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '094.212.807-92')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '094.212.807-92';

  -- 68. MARCELA ZANELA PEREIRA (Alunos)
  -- Email: marcelazanela@yahoo.com.br | CPF: 088.347.637-18 | Senha: Marcela
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marcelazanela@yahoo.com.br';
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
      'marcelazanela@yahoo.com.br',
      crypt('Marcela', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCELA ZANELA PEREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '088.347.637-18')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '088.347.637-18';

  -- 69. ANA CAROLINA LIMA PEREIRA (Alunos)
  -- Email: ana.carolina.lima.pereira@gmail.com | CPF: 151.435.757.70 | Senha: Ana
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'ana.carolina.lima.pereira@gmail.com';
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
      'ana.carolina.lima.pereira@gmail.com',
      crypt('Ana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANA CAROLINA LIMA PEREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '151.435.757.70')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '151.435.757.70';

  -- 70. KEYLON SILVA DOS SANTOS (Alunos)
  -- Email: keylon.silva.santos@gmail.com | CPF: 053.833.197-50 | Senha: Keylon
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'keylon.silva.santos@gmail.com';
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
      'keylon.silva.santos@gmail.com',
      crypt('Keylon', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "KEYLON SILVA DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '053.833.197-50')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '053.833.197-50';

  -- 71. MAURO MARTINS DE SOUZA (Alunos)
  -- Email: mauro.souza@portosrio.temp.br | CPF: 788.496.087-72 | Senha: Mauro
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'mauro.souza@portosrio.temp.br';
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
      'mauro.souza@portosrio.temp.br',
      crypt('Mauro', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MAURO MARTINS DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '788.496.087-72')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '788.496.087-72';

  -- 72. LUCILENE ARAUJO DOS SANTOS OLIVEIRA LOPES (Alunos)
  -- Email: lucilene.lopes@portosrio.temp.br | CPF: 053.033.164-08 | Senha: Lucilene
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lucilene.lopes@portosrio.temp.br';
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
      'lucilene.lopes@portosrio.temp.br',
      crypt('Lucilene', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LUCILENE ARAUJO DOS SANTOS OLIVEIRA LOPES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '053.033.164-08')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '053.033.164-08';

  -- 73. LARISSA PINHEIRO REZENDE DO NASCIMENTO (Alunos)
  -- Email: larissarezendeub@gmail.com | CPF: 210.709.147-11 | Senha: Larissa
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'larissarezendeub@gmail.com';
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
      'larissarezendeub@gmail.com',
      crypt('Larissa', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LARISSA PINHEIRO REZENDE DO NASCIMENTO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '210.709.147-11')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '210.709.147-11';

  -- 74. LAIZA VELLOZO BENEDITO GIL (Alunos 2)
  -- Email: laiza.vellozo@icloud.com | CPF: 180.029.797-10 | Senha: Laiza
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'laiza.vellozo@icloud.com';
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
      'laiza.vellozo@icloud.com',
      crypt('Laiza', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LAIZA VELLOZO BENEDITO GIL"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '180.029.797-10')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '180.029.797-10';

  -- 75. JADER JUNIOR CORRêA ALMADA (Alunos 2)
  -- Email: jaderjuniorcordeiro@gmail.com | CPF: 133.977.557-35 | Senha: Jader
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'jaderjuniorcordeiro@gmail.com';
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
      'jaderjuniorcordeiro@gmail.com',
      crypt('Jader', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JADER JUNIOR CORRêA ALMADA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '133.977.557-35')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '133.977.557-35';

  -- 76. DANIELA RAMOS DOS SANTOS MANÇO (Alunos 2)
  -- Email: daniramos22@gmail.com | CPF: 157.962.347-65 | Senha: Daniela
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'daniramos22@gmail.com';
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
      'daniramos22@gmail.com',
      crypt('Daniela', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DANIELA RAMOS DOS SANTOS MANÇO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '157.962.347-65')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '157.962.347-65';

  -- 77. NATHALI CUSTODIO DA SILVA BARROS (Alunos 2)
  -- Email: nathalicsbarros@gmail.com | CPF: 129.132.687-14 | Senha: Nathali
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'nathalicsbarros@gmail.com';
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
      'nathalicsbarros@gmail.com',
      crypt('Nathali', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "NATHALI CUSTODIO DA SILVA BARROS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '129.132.687-14')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '129.132.687-14';

  -- 78. MAXSLEI DE OLIVEIRA SILVA (Alunos 2)
  -- Email: omaxslei@gmail.com | CPF: 183.537.967-24 | Senha: Maxslei
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'omaxslei@gmail.com';
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
      'omaxslei@gmail.com',
      crypt('Maxslei', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MAXSLEI DE OLIVEIRA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '183.537.967-24')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '183.537.967-24';

  -- 79. GABRIELA LEPORE GOMES HENRIQUES (Alunos 2)
  -- Email: gabizzinhahenriques@gmail.com | CPF: 158.457.947-14 | Senha: Gabriela
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'gabizzinhahenriques@gmail.com';
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
      'gabizzinhahenriques@gmail.com',
      crypt('Gabriela', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GABRIELA LEPORE GOMES HENRIQUES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '158.457.947-14')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '158.457.947-14';

  -- 80. MARCIA FERREIRA DE PAULA SOUZA (Alunos 2)
  -- Email: marciaferreira.1805@gmail.com | CPF: 007.215.687-26 | Senha: Marcia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marciaferreira.1805@gmail.com';
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
      'marciaferreira.1805@gmail.com',
      crypt('Marcia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCIA FERREIRA DE PAULA SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '007.215.687-26')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '007.215.687-26';

  -- 81. OSTAYR FERREIRA BRAGA FILHO (Alunos 2)
  -- Email: ostairferreira@gmail.com | CPF: 106.817.617-25 | Senha: Ostayr
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'ostairferreira@gmail.com';
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
      'ostairferreira@gmail.com',
      crypt('Ostayr', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "OSTAYR FERREIRA BRAGA FILHO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '106.817.617-25')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '106.817.617-25';

  -- 82. RAFAEL OLIVEIRA LIMA (Alunos 2)
  -- Email: rafaoliveiralima07@gmail.com | CPF: 170.454,947-77 | Senha: Rafael
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'rafaoliveiralima07@gmail.com';
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
      'rafaoliveiralima07@gmail.com',
      crypt('Rafael', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "RAFAEL OLIVEIRA LIMA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '170.454,947-77')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '170.454,947-77';

  -- 83. SORATO FERNANDES ANDRE (Alunos 2)
  -- Email: sornandes@gmail.com | CPF: 118.431.967-78 | Senha: Sorato
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'sornandes@gmail.com';
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
      'sornandes@gmail.com',
      crypt('Sorato', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SORATO FERNANDES ANDRE"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '118.431.967-78')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '118.431.967-78';

  -- 84. VANDELEI CORREA DE SOUZA (Alunos 2)
  -- Email: vanderlei.correa789@gmail.com | CPF: 081.886.837-60 | Senha: Vandelei
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'vanderlei.correa789@gmail.com';
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
      'vanderlei.correa789@gmail.com',
      crypt('Vandelei', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "VANDELEI CORREA DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '081.886.837-60')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '081.886.837-60';

  -- 85. DANIEL AUGUSTO REIS RIBEIRO (Alunos 2)
  -- Email: darr89.da@gmail.com | CPF: 137.147.897-07 | Senha: Daniel
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'darr89.da@gmail.com';
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
      'darr89.da@gmail.com',
      crypt('Daniel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DANIEL AUGUSTO REIS RIBEIRO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '137.147.897-07')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '137.147.897-07';

  -- 86. MAICON WILSON SOARES (Alunos 2)
  -- Email: maicon.soares91@gmail.com | CPF: 131.085.187-55 | Senha: Maicon
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'maicon.soares91@gmail.com';
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
      'maicon.soares91@gmail.com',
      crypt('Maicon', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MAICON WILSON SOARES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '131.085.187-55')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '131.085.187-55';

  -- 87. GABRIEL CARVALHO GONÇALVES (Alunos 2)
  -- Email: gcg.0014@gmail.com | CPF: 004.234.957-55 | Senha: Gabriel
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'gcg.0014@gmail.com';
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
      'gcg.0014@gmail.com',
      crypt('Gabriel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GABRIEL CARVALHO GONÇALVES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '004.234.957-55')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '004.234.957-55';

  -- 88. WARLON LOPES CARVALHO (Alunos 2)
  -- Email: warlocarvalhosumi@gmail.com | CPF: 135.776.787-04 | Senha: Warlon
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'warlocarvalhosumi@gmail.com';
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
      'warlocarvalhosumi@gmail.com',
      crypt('Warlon', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "WARLON LOPES CARVALHO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '135.776.787-04')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '135.776.787-04';

  -- 89. WALTER VIEIRA ALVES (Alunos 2)
  -- Email: vitrini123alves@hotmail.com | CPF: 015.744.497-02 | Senha: Walter
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'vitrini123alves@hotmail.com';
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
      'vitrini123alves@hotmail.com',
      crypt('Walter', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "WALTER VIEIRA ALVES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '015.744.497-02')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '015.744.497-02';

  -- 90. ANDREVERSON MENDES GONÇALVES (Alunos 2)
  -- Email: andrecarioca800@gmail.com | CPF: 095.979.227-97 | Senha: Andreverson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'andrecarioca800@gmail.com';
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
      'andrecarioca800@gmail.com',
      crypt('Andreverson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANDREVERSON MENDES GONÇALVES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '095.979.227-97')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '095.979.227-97';

  -- 91. JOSE GERALDO DE SOUZA SOBRINHO (Alunos 2)
  -- Email: jgsobrinho12@gmail.com | CPF: 655.880.617-72 | Senha: Jose
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'jgsobrinho12@gmail.com';
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
      'jgsobrinho12@gmail.com',
      crypt('Jose', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOSE GERALDO DE SOUZA SOBRINHO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '655.880.617-72')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '655.880.617-72';

  -- 92. JOSIANE DE FATIMA FREITAS PELLEGRINI (Alunos 2)
  -- Email: jojopelle@gmail.com | CPF: 106.087.347-80 | Senha: Josiane
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'jojopelle@gmail.com';
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
      'jojopelle@gmail.com',
      crypt('Josiane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOSIANE DE FATIMA FREITAS PELLEGRINI"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '106.087.347-80')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '106.087.347-80';

  -- 93. OSMAR FERREIRA JUNIOR (Alunos 2)
  -- Email: osfer@gmail.com | CPF: 173.382.037-09 | Senha: Osmar
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'osfer@gmail.com';
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
      'osfer@gmail.com',
      crypt('Osmar', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "OSMAR FERREIRA JUNIOR"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '173.382.037-09')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '173.382.037-09';

  -- 94. MARCO ANTONIO DA SILVA PAES (Alunos 2)
  -- Email: marcoantonio.paes@gmail.com | CPF: 007.283.847-79 | Senha: Marco
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marcoantonio.paes@gmail.com';
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
      'marcoantonio.paes@gmail.com',
      crypt('Marco', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCO ANTONIO DA SILVA PAES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '007.283.847-79')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '007.283.847-79';

  -- 95. GABRIEL SYMEONE BRAGA ALVES (Alunos 2)
  -- Email: gabrielsymeonegerl@gmail.com | CPF: 183.226.487-40 | Senha: Gabriel
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'gabrielsymeonegerl@gmail.com';
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
      'gabrielsymeonegerl@gmail.com',
      crypt('Gabriel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GABRIEL SYMEONE BRAGA ALVES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '183.226.487-40')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '183.226.487-40';

  -- 96. VICTOR OLIVEIRA CORDEIRO DA SILVA (Alunos 2)
  -- Email: victorocs@gmail.com | CPF: 152.066.057-00 | Senha: Victor
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'victorocs@gmail.com';
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
      'victorocs@gmail.com',
      crypt('Victor', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "VICTOR OLIVEIRA CORDEIRO DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '152.066.057-00')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '152.066.057-00';

  -- 97. DEBORAH DOS SANTOS BARREIROS (Alunos 2)
  -- Email: santosdeborah58@gmail.com | CPF: 207.141.447-93 | Senha: Deborah
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'santosdeborah58@gmail.com';
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
      'santosdeborah58@gmail.com',
      crypt('Deborah', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DEBORAH DOS SANTOS BARREIROS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '207.141.447-93')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '207.141.447-93';

  -- 98. JOÃO DE SOUZA GOMES (Alunos 2)
  -- Email: joaogomesportorea@gmail.com | CPF: 469.304.267-68 | Senha: João
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'joaogomesportorea@gmail.com';
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
      'joaogomesportorea@gmail.com',
      crypt('João', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOÃO DE SOUZA GOMES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '469.304.267-68')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '469.304.267-68';

  -- 99. SUELI MIRANDA DAMA (Alunos 2)
  -- Email: smirandadama@gmail.com | CPF: 840.772.717-20 | Senha: Sueli
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'smirandadama@gmail.com';
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
      'smirandadama@gmail.com',
      crypt('Sueli', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SUELI MIRANDA DAMA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '840.772.717-20')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '840.772.717-20';

  -- 100. DENIO ALMEIDA ANDRADE FERREIRA (Alunos 2)
  -- Email: denioaferreira@gmail.com | CPF: 087.516.637-75 | Senha: Denio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'denioaferreira@gmail.com';
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
      'denioaferreira@gmail.com',
      crypt('Denio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DENIO ALMEIDA ANDRADE FERREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '087.516.637-75')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '087.516.637-75';

  -- 101. ELIZABETH REGINA COSTA DE ALCÂNTARA DE LIMA (Alunos 2)
  -- Email: elizabethcostahjh@gmail.com | CPF: 174.944.287-63 | Senha: Elizabeth
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'elizabethcostahjh@gmail.com';
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
      'elizabethcostahjh@gmail.com',
      crypt('Elizabeth', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ELIZABETH REGINA COSTA DE ALCÂNTARA DE LIMA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '174.944.287-63')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '174.944.287-63';

  -- 102. DENILCIA REZENDE DOS SANTOS (Alunos 2)
  -- Email: denilsanton@gmail.com | CPF: 148.325.497-66 | Senha: Denilcia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'denilsanton@gmail.com';
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
      'denilsanton@gmail.com',
      crypt('Denilcia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DENILCIA REZENDE DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '148.325.497-66')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '148.325.497-66';

  -- 103. GABRIEL PEREIRA DA SILVA (Alunos 2)
  -- Email: gabpereira@gmail.com | CPF: 017.539.467-94 | Senha: Gabriel
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'gabpereira@gmail.com';
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
      'gabpereira@gmail.com',
      crypt('Gabriel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GABRIEL PEREIRA DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '017.539.467-94')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '017.539.467-94';

  -- 104. AMARO ABIDO NETO (Alunos 2)
  -- Email: amarojaperi331@gmail.com | CPF: 076.119.977-26 | Senha: Amaro
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'amarojaperi331@gmail.com';
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
      'amarojaperi331@gmail.com',
      crypt('Amaro', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "AMARO ABIDO NETO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '076.119.977-26')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '076.119.977-26';

  -- 105. ALICE MELO BIANCHINI RICHA STORK (Alunos 2)
  -- Email: alicebianchiinimrs@gmail.com | CPF: 123.872.007-21 | Senha: Alice
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'alicebianchiinimrs@gmail.com';
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
      'alicebianchiinimrs@gmail.com',
      crypt('Alice', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ALICE MELO BIANCHINI RICHA STORK"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '123.872.007-21')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '123.872.007-21';

  -- 106. RICHARDISON DO NASCIMENTO BRAGA (Alunos 2)
  -- Email: richardison.ri@hotmail.com | CPF: 162.066.387-23 | Senha: Richardison
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'richardison.ri@hotmail.com';
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
      'richardison.ri@hotmail.com',
      crypt('Richardison', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "RICHARDISON DO NASCIMENTO BRAGA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '162.066.387-23')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '162.066.387-23';

  -- 107. WELLINGTON RIBEIRO LACERDA DE LIMA (Alunos 2)
  -- Email: w.lacerda2028@gmail.com | CPF: 079.473.147-30 | Senha: Wellington
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'w.lacerda2028@gmail.com';
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
      'w.lacerda2028@gmail.com',
      crypt('Wellington', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "WELLINGTON RIBEIRO LACERDA DE LIMA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '079.473.147-30')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '079.473.147-30';

  -- 108. JOYCE RAMOS DA SILVA (Alunos 2)
  -- Email: joyce.ramosclei@gmail.com | CPF: 189.168.987-81 | Senha: Joyce
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'joyce.ramosclei@gmail.com';
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
      'joyce.ramosclei@gmail.com',
      crypt('Joyce', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOYCE RAMOS DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '189.168.987-81')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '189.168.987-81';

  -- 109. ANA CARLA MONTEIRO SANTOS (Alunos 2)
  -- Email: anacarlarj@hotmail.com | CPF: 069.567.307-66 | Senha: Ana
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'anacarlarj@hotmail.com';
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
      'anacarlarj@hotmail.com',
      crypt('Ana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANA CARLA MONTEIRO SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '069.567.307-66')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '069.567.307-66';

  -- 110. MARIA EDUARDA SILVA DE LIRA (Alunos 2)
  -- Email: pablocontagp@gmail.com | CPF: 217.450.757-98 | Senha: Maria
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'pablocontagp@gmail.com';
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
      'pablocontagp@gmail.com',
      crypt('Maria', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARIA EDUARDA SILVA DE LIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '217.450.757-98')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '217.450.757-98';

  -- 111. JAQUELINE PEREIRA MERÇAM (Alunos 2)
  -- Email: jaquemerçam@gmail.com | CPF: 095.334.637-40 | Senha: Jaqueline
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'jaquemerçam@gmail.com';
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
      'jaquemerçam@gmail.com',
      crypt('Jaqueline', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JAQUELINE PEREIRA MERÇAM"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '095.334.637-40')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '095.334.637-40';

  -- 112. IGOR BENEDITO BORGES LISBOA DE CAMPOS (Alunos 2)
  -- Email: igorbeneditoprimeiro@gmail.com | CPF: 109.325.707-55 | Senha: Igor
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'igorbeneditoprimeiro@gmail.com';
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
      'igorbeneditoprimeiro@gmail.com',
      crypt('Igor', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "IGOR BENEDITO BORGES LISBOA DE CAMPOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '109.325.707-55')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '109.325.707-55';

  -- 113. JOSE DA ROSA GALLO (Alunos 2)
  -- Email: zegalo000@gmail.com | CPF: 876.401.397-91 | Senha: Jose
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'zegalo000@gmail.com';
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
      'zegalo000@gmail.com',
      crypt('Jose', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOSE DA ROSA GALLO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '876.401.397-91')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '876.401.397-91';

  -- 114. SEBASTIÃO CARLOS DA CRUZ PAULA (Alunos 2)
  -- Email: sebastiaocruz540@gmail.com | CPF: 116.927.387-47 | Senha: Sebastião
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'sebastiaocruz540@gmail.com';
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
      'sebastiaocruz540@gmail.com',
      crypt('Sebastião', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SEBASTIÃO CARLOS DA CRUZ PAULA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '116.927.387-47')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '116.927.387-47';

  -- 115. BRENDHA QUINTADILHA CAMPOS BRAGA DIAS (Alunos 2)
  -- Email: brendhaquintadilha123@gmail.com | CPF: 186.314.207-00 | Senha: Brendha
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'brendhaquintadilha123@gmail.com';
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
      'brendhaquintadilha123@gmail.com',
      crypt('Brendha', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "BRENDHA QUINTADILHA CAMPOS BRAGA DIAS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '186.314.207-00')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '186.314.207-00';

  -- 116. MARIA DE LOURDES SOARES PEREIRA (Alunos 2)
  -- Email: msoarespereira19@gmail.com | CPF: 026.417.407-02 | Senha: Maria
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'msoarespereira19@gmail.com';
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
      'msoarespereira19@gmail.com',
      crypt('Maria', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARIA DE LOURDES SOARES PEREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '026.417.407-02')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '026.417.407-02';

  -- 117. GABRIEL GOULART DE ARAUJO CANDIDO MACEDO (Alunos 2)
  -- Email: gabrielgoulartdearaujo@gmail.com | CPF: 180.236.897-38 | Senha: Gabriel
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'gabrielgoulartdearaujo@gmail.com';
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
      'gabrielgoulartdearaujo@gmail.com',
      crypt('Gabriel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GABRIEL GOULART DE ARAUJO CANDIDO MACEDO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '180.236.897-38')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '180.236.897-38';

  -- 118. LAIRA CRISTINA FERNANDES SOARES (Alunos 2)
  -- Email: lairacristina915@gmail.com | CPF: 123.923.927-06 | Senha: Laira
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lairacristina915@gmail.com';
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
      'lairacristina915@gmail.com',
      crypt('Laira', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LAIRA CRISTINA FERNANDES SOARES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '123.923.927-06')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '123.923.927-06';

  -- 119. JULIA DE PAULA CÔRTES PONTES (Alunos 2)
  -- Email: jucortespon@gmail.com | CPF: 161.749.967-60 | Senha: Julia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'jucortespon@gmail.com';
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
      'jucortespon@gmail.com',
      crypt('Julia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JULIA DE PAULA CÔRTES PONTES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '161.749.967-60')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '161.749.967-60';

  -- 120. LIVIA CASTRO DE SOUZA (Alunos 2)
  -- Email: liviasouza2110@gmail.com | CPF: 210.474.887-95 | Senha: Livia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'liviasouza2110@gmail.com';
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
      'liviasouza2110@gmail.com',
      crypt('Livia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LIVIA CASTRO DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '210.474.887-95')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '210.474.887-95';

  -- 121. CARLOS EDUARDO RODRIGUES NEVES (Alunos 2)
  -- Email: caduneves1@gmail.com | CPF: 193.206.347-18 | Senha: Carlos
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'caduneves1@gmail.com';
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
      'caduneves1@gmail.com',
      crypt('Carlos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CARLOS EDUARDO RODRIGUES NEVES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '193.206.347-18')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '193.206.347-18';

  -- 122. JOSE CARLOS XAVIER (Alunos 2)
  -- Email: xavierjosecarlosx@gmail.com | CPF: 586.902.477-34 | Senha: Jose
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'xavierjosecarlosx@gmail.com';
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
      'xavierjosecarlosx@gmail.com',
      crypt('Jose', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOSE CARLOS XAVIER"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '586.902.477-34')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '586.902.477-34';

  -- 123. CLARISSA DE OLIVEIRA LEOPOLDINO (Alunos 2)
  -- Email: clarissaadv83@gmail.com | CPF: 163.842.447-05 | Senha: Clarissa
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'clarissaadv83@gmail.com';
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
      'clarissaadv83@gmail.com',
      crypt('Clarissa', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CLARISSA DE OLIVEIRA LEOPOLDINO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '163.842.447-05')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '163.842.447-05';

  -- 124. DEJACIR GOMES DA PENHA (Alunos 2)
  -- Email: nocogomesdapenha@gmail.com | CPF: 044.792.687-07 | Senha: Dejacir
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'nocogomesdapenha@gmail.com';
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
      'nocogomesdapenha@gmail.com',
      crypt('Dejacir', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DEJACIR GOMES DA PENHA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '044.792.687-07')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '044.792.687-07';

  -- 125. EDUARDO ANTAS JUNQUEIRA (Alunos 2)
  -- Email: eduardojunqueira37@gmail.com | CPF: 102.916.887-30 | Senha: Eduardo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'eduardojunqueira37@gmail.com';
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
      'eduardojunqueira37@gmail.com',
      crypt('Eduardo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "EDUARDO ANTAS JUNQUEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '102.916.887-30')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '102.916.887-30';

  -- 126. ERIKA CRISTINA BRAGA DE SOUZA (Alunos 2)
  -- Email: erikamaedakika2@gmail.com | CPF: 121.051.867-85 | Senha: Erika
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'erikamaedakika2@gmail.com';
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
      'erikamaedakika2@gmail.com',
      crypt('Erika', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ERIKA CRISTINA BRAGA DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '121.051.867-85')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '121.051.867-85';

  -- 127. JOÃO VITOR LEANDRO DOS SANTOS (Alunos 2)
  -- Email: dossantosjoaovitorleandro@gmail.com | CPF: 163.697.467-89 | Senha: João
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'dossantosjoaovitorleandro@gmail.com';
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
      'dossantosjoaovitorleandro@gmail.com',
      crypt('João', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOÃO VITOR LEANDRO DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '163.697.467-89')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '163.697.467-89';

  -- 128. MARCELO DAS DORES BAPTISTA (Alunos 2)
  -- Email: marcelocamposdas@gmail.com | CPF: 044.711.247-30 | Senha: Marcelo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marcelocamposdas@gmail.com';
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
      'marcelocamposdas@gmail.com',
      crypt('Marcelo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCELO DAS DORES BAPTISTA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '044.711.247-30')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '044.711.247-30';

  -- 129. WILSON CIPRIANO DE FRANÇA (Alunos 2)
  -- Email: wilsonfranca555@gmail.com | CPF: 038.287.897-30 | Senha: Wilson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'wilsonfranca555@gmail.com';
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
      'wilsonfranca555@gmail.com',
      crypt('Wilson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "WILSON CIPRIANO DE FRANÇA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '038.287.897-30')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '038.287.897-30';

  -- 130. ANGELA MARILA NEMITX DE OLIVEIRA (Alunos 2)
  -- Email: nemitzangela22@gmail.com | CPF: 052.349.707-52 | Senha: Angela
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'nemitzangela22@gmail.com';
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
      'nemitzangela22@gmail.com',
      crypt('Angela', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANGELA MARILA NEMITX DE OLIVEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '052.349.707-52')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '052.349.707-52';

  -- 131. CAMILA ABREU DE OLIVEIRA (Alunos 2)
  -- Email: camilaabreudeoliveiraesteves@gmail.com | CPF: 130.008.397-20 | Senha: Camila
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'camilaabreudeoliveiraesteves@gmail.com';
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
      'camilaabreudeoliveiraesteves@gmail.com',
      crypt('Camila', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CAMILA ABREU DE OLIVEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '130.008.397-20')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '130.008.397-20';

  -- 132. CARLOS ALEXANDRE GOMES (Alunos 2)
  -- Email: alexandrecarlos@gmail.com | CPF: 086.221.696-69 | Senha: Carlos
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'alexandrecarlos@gmail.com';
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
      'alexandrecarlos@gmail.com',
      crypt('Carlos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CARLOS ALEXANDRE GOMES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '086.221.696-69')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '086.221.696-69';

  -- 133. DANIELLE VASCONCELLOS DA COSTA (Alunos 2)
  -- Email: daniellevcosta187@gmail.com | CPF: 029.431.507-11 | Senha: Danielle
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'daniellevcosta187@gmail.com';
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
      'daniellevcosta187@gmail.com',
      crypt('Danielle', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DANIELLE VASCONCELLOS DA COSTA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '029.431.507-11')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '029.431.507-11';

  -- 134. ELIANE LEAL RIBEIRO (Alunos 2)
  -- Email: lianelealribeiro@gmail.com | CPF: 858.894.317-49 | Senha: Eliane
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lianelealribeiro@gmail.com';
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
      'lianelealribeiro@gmail.com',
      crypt('Eliane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ELIANE LEAL RIBEIRO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '858.894.317-49')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '858.894.317-49';

  -- 135. ENIR CARLOS DA SILVA (Alunos 2)
  -- Email: ds1119629@gmail.com | CPF: 001.948.127-66 | Senha: Enir
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'ds1119629@gmail.com';
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
      'ds1119629@gmail.com',
      crypt('Enir', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ENIR CARLOS DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '001.948.127-66')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '001.948.127-66';

  -- 136. EVERSON LUIZ RIBEIRO (Alunos 2)
  -- Email: eversonribeiro2025@gmail.com | CPF: 138.586.177-63 | Senha: Everson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'eversonribeiro2025@gmail.com';
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
      'eversonribeiro2025@gmail.com',
      crypt('Everson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "EVERSON LUIZ RIBEIRO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '138.586.177-63')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '138.586.177-63';

  -- 137. EXPEDITO GUIMARÃES DA SILVA (Alunos 2)
  -- Email: expeditoguimaraes247@gmail.com | CPF: 748.247.597-49 | Senha: Expedito
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'expeditoguimaraes247@gmail.com';
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
      'expeditoguimaraes247@gmail.com',
      crypt('Expedito', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "EXPEDITO GUIMARÃES DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '748.247.597-49')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '748.247.597-49';

  -- 138. FERNANDO BOECHAT JUNIOR (Alunos 2)
  -- Email: fernandoboechatjr@hotmail.com | CPF: 030.485.557-06 | Senha: Fernando
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'fernandoboechatjr@hotmail.com';
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
      'fernandoboechatjr@hotmail.com',
      crypt('Fernando', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "FERNANDO BOECHAT JUNIOR"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '030.485.557-06')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '030.485.557-06';

  -- 139. FLAVIO OLIVEIRA DA CONCEIÇÃO (Alunos 2)
  -- Email: flavioconceicao15@gmail.com | CPF: 065.697.487-77 | Senha: Flavio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'flavioconceicao15@gmail.com';
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
      'flavioconceicao15@gmail.com',
      crypt('Flavio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "FLAVIO OLIVEIRA DA CONCEIÇÃO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '065.697.487-77')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '065.697.487-77';

  -- 140. FRANCISCO CARLOS DE SOUZA MENDES (Alunos 2)
  -- Email: fcchlcomento1954@hotmail.com | CPF: 365.782.907-53 | Senha: Francisco
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'fcchlcomento1954@hotmail.com';
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
      'fcchlcomento1954@hotmail.com',
      crypt('Francisco', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "FRANCISCO CARLOS DE SOUZA MENDES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '365.782.907-53')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '365.782.907-53';

  -- 141. GILMAR RIOS SOARES GOMES (Alunos 2)
  -- Email: gilgomesrj@gmail.com | CPF: 099.635.527-81 | Senha: Gilmar
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'gilgomesrj@gmail.com';
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
      'gilgomesrj@gmail.com',
      crypt('Gilmar', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GILMAR RIOS SOARES GOMES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '099.635.527-81')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '099.635.527-81';

  -- 142. GILSON SOUZA PEDRO (Alunos 2)
  -- Email: pedrogilson2019@agmail.com | CPF: 853.927.237-72 | Senha: Gilson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'pedrogilson2019@agmail.com';
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
      'pedrogilson2019@agmail.com',
      crypt('Gilson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GILSON SOUZA PEDRO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '853.927.237-72')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '853.927.237-72';

  -- 143. HEYNE GOMES MARTINS (Alunos 2)
  -- Email: heynegm21@gmail.com | CPF: 815.232.463-91 | Senha: Heyne
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'heynegm21@gmail.com';
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
      'heynegm21@gmail.com',
      crypt('Heyne', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "HEYNE GOMES MARTINS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '815.232.463-91')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '815.232.463-91';

  -- 144. JEFERSON ANDRÉ DOS SANTOS VIANA (Alunos 2)
  -- Email: jeferson_andre10@gmail.com | CPF: 108.052.537-85 | Senha: Jeferson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'jeferson_andre10@gmail.com';
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
      'jeferson_andre10@gmail.com',
      crypt('Jeferson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JEFERSON ANDRÉ DOS SANTOS VIANA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '108.052.537-85')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '108.052.537-85';

  -- 145. JONATAN BATISTA FURRIEL (Alunos 2)
  -- Email: jb3772083@gmail.com | CPF: 167.009.627-06 | Senha: Jonatan
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'jb3772083@gmail.com';
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
      'jb3772083@gmail.com',
      crypt('Jonatan', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JONATAN BATISTA FURRIEL"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '167.009.627-06')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '167.009.627-06';

  -- 146. LUIS FERNANDO DA CONCEIÇÃO NOVELLINO MARQUES (Alunos 2)
  -- Email: luisnovellinomarques@gmail.com | CPF: 713.192.807-06 | Senha: Luis
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'luisnovellinomarques@gmail.com';
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
      'luisnovellinomarques@gmail.com',
      crypt('Luis', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LUIS FERNANDO DA CONCEIÇÃO NOVELLINO MARQUES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '713.192.807-06')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '713.192.807-06';

  -- 147. MARCELA PACIÊNCIA PEREIRA (Alunos 2)
  -- Email: marcelapacienciapereira@gmail.com | CPF: 131.788.247-40 | Senha: Marcela
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marcelapacienciapereira@gmail.com';
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
      'marcelapacienciapereira@gmail.com',
      crypt('Marcela', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCELA PACIÊNCIA PEREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '131.788.247-40')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '131.788.247-40';

  -- 148. MOACIR BASTOS FILHO (Alunos 2)
  -- Email: moacirfilho10@gmail.com | CPF: 999.757.777-91 | Senha: Moacir
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'moacirfilho10@gmail.com';
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
      'moacirfilho10@gmail.com',
      crypt('Moacir', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MOACIR BASTOS FILHO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '999.757.777-91')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '999.757.777-91';

  -- 149. NATHALIA MENDES DE SOUZA FRANCELINO (Alunos 2)
  -- Email: nathaliafrancelino1@gmail.com | CPF: 140.112.057-10 | Senha: Nathalia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'nathaliafrancelino1@gmail.com';
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
      'nathaliafrancelino1@gmail.com',
      crypt('Nathalia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "NATHALIA MENDES DE SOUZA FRANCELINO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '140.112.057-10')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '140.112.057-10';

  -- 150. PETERSON HENRIQUE LIMA DA ROCHA (Alunos 2)
  -- Email: peterson212709@gmail.com | CPF: 166.059.307-70 | Senha: Peterson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'peterson212709@gmail.com';
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
      'peterson212709@gmail.com',
      crypt('Peterson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "PETERSON HENRIQUE LIMA DA ROCHA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '166.059.307-70')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '166.059.307-70';

  -- 151. POLYANA ANDRADE RANGEL (Alunos 2)
  -- Email: 22997958734pae@gmail.com | CPF: 124.280.817-56 | Senha: Polyana
  SELECT id INTO new_user_id FROM auth.users WHERE email = '22997958734pae@gmail.com';
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
      '22997958734pae@gmail.com',
      crypt('Polyana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "POLYANA ANDRADE RANGEL"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '124.280.817-56')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '124.280.817-56';

  -- 152. RAISSA ASSIS ANDRADE BRITO (Alunos 2)
  -- Email: raissabrito680@gmail.com | CPF: 158.329.657-36 | Senha: Raissa
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'raissabrito680@gmail.com';
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
      'raissabrito680@gmail.com',
      crypt('Raissa', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "RAISSA ASSIS ANDRADE BRITO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '158.329.657-36')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '158.329.657-36';

  -- 153. RODRIGO DOS SANTOS NASCIMENTO (Alunos 2)
  -- Email: rn06456@gmail.com | CPF: 099.111.217-20 | Senha: Rodrigo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'rn06456@gmail.com';
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
      'rn06456@gmail.com',
      crypt('Rodrigo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "RODRIGO DOS SANTOS NASCIMENTO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '099.111.217-20')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '099.111.217-20';

  -- 154. SERGIO NERY DA SILVA OLIVEIRA (Alunos 2)
  -- Email: nerysergioso@hotmail.com | CPF: 119.391.467-12 | Senha: Sergio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'nerysergioso@hotmail.com';
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
      'nerysergioso@hotmail.com',
      crypt('Sergio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SERGIO NERY DA SILVA OLIVEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '119.391.467-12')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '119.391.467-12';

  -- 155. SILVANI MARIA DA CONCEICAO (Alunos 2)
  -- Email: silvani.maria25@gmail.com | CPF: 387.108.270-08 | Senha: Silvani
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'silvani.maria25@gmail.com';
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
      'silvani.maria25@gmail.com',
      crypt('Silvani', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SILVANI MARIA DA CONCEICAO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '387.108.270-08')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '387.108.270-08';

  -- 156. THIAGO DOMINGOS DE SOUZA (Alunos 2)
  -- Email: thdomingoss022@gmail.com | CPF: 055.550.567-70 | Senha: Thiago
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'thdomingoss022@gmail.com';
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
      'thdomingoss022@gmail.com',
      crypt('Thiago', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "THIAGO DOMINGOS DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '055.550.567-70')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '055.550.567-70';

  -- 157. VANDERLEY FRANCISCO ALVES (Alunos 2)
  -- Email: vanderleyronan@gmail.com | CPF: 017.601.727-58 | Senha: Vanderley
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'vanderleyronan@gmail.com';
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
      'vanderleyronan@gmail.com',
      crypt('Vanderley', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "VANDERLEY FRANCISCO ALVES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '017.601.727-58')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '017.601.727-58';

  -- 158. VIVIANE ANGELINA RODRIGUES (Alunos 2)
  -- Email: ivianeangelidarodrigues@gmail.com | CPF: 053.635.807-99 | Senha: Viviane
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'ivianeangelidarodrigues@gmail.com';
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
      'ivianeangelidarodrigues@gmail.com',
      crypt('Viviane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "VIVIANE ANGELINA RODRIGUES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '053.635.807-99')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '053.635.807-99';

  -- 159. WEBSON SILVA DOS SANTOS (Alunos 2)
  -- Email: webson.silva.santos1@gmail.com | CPF: 118.193.717-51 | Senha: Webson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'webson.silva.santos1@gmail.com';
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
      'webson.silva.santos1@gmail.com',
      crypt('Webson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "WEBSON SILVA DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '118.193.717-51')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '118.193.717-51';

  -- 160. CRISTIAN SOARES DO NASCIMENTO (Alunos 2)
  -- Email: cristianjardim18@gmai.com | CPF: 145.486.187-83 | Senha: Cristian
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'cristianjardim18@gmai.com';
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
      'cristianjardim18@gmai.com',
      crypt('Cristian', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CRISTIAN SOARES DO NASCIMENTO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '145.486.187-83')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '145.486.187-83';

  -- 161. LUCAS MOTA SANTOS (Alunos 2)
  -- Email: lucassantos@gmail.com | CPF: 162.327.377-33 | Senha: Lucas
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lucassantos@gmail.com';
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
      'lucassantos@gmail.com',
      crypt('Lucas', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LUCAS MOTA SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '162.327.377-33')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '162.327.377-33';

  -- 162. OSIRIS MIRANDA DO AMARAL JUNIOR (Alunos 2)
  -- Email: osirisamaral7@gmail.com | CPF: 128.247.347-60 | Senha: Osiris
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'osirisamaral7@gmail.com';
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
      'osirisamaral7@gmail.com',
      crypt('Osiris', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "OSIRIS MIRANDA DO AMARAL JUNIOR"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '128.247.347-60')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '128.247.347-60';

  -- 163. RAIMUNDO NONATO DE SOUZA (Alunos 2)
  -- Email: raimundononatodesouza199@gmail.com | CPF: 420.904.404-06 | Senha: Raimundo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'raimundononatodesouza199@gmail.com';
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
      'raimundononatodesouza199@gmail.com',
      crypt('Raimundo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "RAIMUNDO NONATO DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '420.904.404-06')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '420.904.404-06';

  -- 164. GEYSON GUIMARAES OLIVEIRA RAMOS DA SILVA (Alunos 2)
  -- Email: geysongramos@gmail.com | CPF: 134.352.497-06 | Senha: Geyson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'geysongramos@gmail.com';
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
      'geysongramos@gmail.com',
      crypt('Geyson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GEYSON GUIMARAES OLIVEIRA RAMOS DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '134.352.497-06')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '134.352.497-06';

  -- 165. LETICIA DA SILVA GUILHERME (Alunos 2)
  -- Email: leticiia.silva2505@gmail.com | CPF: 225.179.987-79 | Senha: Leticia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'leticiia.silva2505@gmail.com';
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
      'leticiia.silva2505@gmail.com',
      crypt('Leticia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LETICIA DA SILVA GUILHERME"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '225.179.987-79')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '225.179.987-79';

  -- 166. CARLOS AUGUSTO MORAES DE MEDEIROS (Alunos 2)
  -- Email: carlinhos333@gmail.com | CPF: 070.373.837-24 | Senha: Carlos
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'carlinhos333@gmail.com';
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
      'carlinhos333@gmail.com',
      crypt('Carlos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CARLOS AUGUSTO MORAES DE MEDEIROS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '070.373.837-24')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '070.373.837-24';

  -- 167. NATHIELLY DOS SANTOS DE FREITAS (Alunos 2)
  -- Email: nathielly.sophi/2gmail.com | CPF: 164.384.827-57 | Senha: Nathielly
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'nathielly.sophi/2gmail.com';
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
      'nathielly.sophi/2gmail.com',
      crypt('Nathielly', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "NATHIELLY DOS SANTOS DE FREITAS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '164.384.827-57')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '164.384.827-57';

  -- 168. NATHALIA DA SILVA VALENTE (Alunos 2)
  -- Email: nathaliadasilvavalente2020@gmail.com | CPF: 140.956.007-48 | Senha: Nathalia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'nathaliadasilvavalente2020@gmail.com';
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
      'nathaliadasilvavalente2020@gmail.com',
      crypt('Nathalia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "NATHALIA DA SILVA VALENTE"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '140.956.007-48')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '140.956.007-48';

  -- 169. MARCELO EVARISTO VIEIRA (Alunos 2)
  -- Email: marceeva643@gmail.com | CPF: 084.220.597-70 | Senha: Marcelo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marceeva643@gmail.com';
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
      'marceeva643@gmail.com',
      crypt('Marcelo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCELO EVARISTO VIEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '084.220.597-70')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '084.220.597-70';

  -- 170. MARIANA DIAS VIEIRA (Alunos 2)
  -- Email: marianaveira000@gmail.com | CPF: 150.577.727-59 | Senha: Mariana
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marianaveira000@gmail.com';
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
      'marianaveira000@gmail.com',
      crypt('Mariana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARIANA DIAS VIEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '150.577.727-59')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '150.577.727-59';

  -- 171. MURILO DIAS VIEIRA (Alunos 2)
  -- Email: murilovieira10@hotmail.com | CPF: 150.577.217-63 | Senha: Murilo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'murilovieira10@hotmail.com';
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
      'murilovieira10@hotmail.com',
      crypt('Murilo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MURILO DIAS VIEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '150.577.217-63')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '150.577.217-63';

  -- 172. FABIO MOURA DOS SANTOS (Alunos 2)
  -- Email: fabiosants555@gmail.com | CPF: 022.795.075-52 | Senha: Fabio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'fabiosants555@gmail.com';
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
      'fabiosants555@gmail.com',
      crypt('Fabio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "FABIO MOURA DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '022.795.075-52')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '022.795.075-52';

  -- 173. MARCOS PEIXOTO SOARES (Alunos 2)
  -- Email: marcospeixotosoaresp@gmail.com | CPF: 828.392.557-15 | Senha: Marcos
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marcospeixotosoaresp@gmail.com';
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
      'marcospeixotosoaresp@gmail.com',
      crypt('Marcos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCOS PEIXOTO SOARES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '828.392.557-15')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '828.392.557-15';

  -- 174. BRUNO GONÇALVES DE OLIVEIRA (Alunos 2)
  -- Email: bgonçalvesolkveira@gmail.com | CPF: 123.369.627-05 | Senha: Bruno
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'bgonçalvesolkveira@gmail.com';
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
      'bgonçalvesolkveira@gmail.com',
      crypt('Bruno', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "BRUNO GONÇALVES DE OLIVEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '123.369.627-05')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '123.369.627-05';

  -- 175. LUCAS FERREIRA DA SILVA (Alunos 2)
  -- Email: lucas.ferreira.silva@gmail.com | CPF: 158.427.837-46 | Senha: Lucas
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lucas.ferreira.silva@gmail.com';
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
      'lucas.ferreira.silva@gmail.com',
      crypt('Lucas', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LUCAS FERREIRA DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '158.427.837-46')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '158.427.837-46';

  -- 176. DILCEIA SILVA LIMA VIEIRA (Alunos 2)
  -- Email: dilceia.vieira@gmail.com | CPF: 156.767.317-10 | Senha: Dilceia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'dilceia.vieira@gmail.com';
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
      'dilceia.vieira@gmail.com',
      crypt('Dilceia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DILCEIA SILVA LIMA VIEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '156.767.317-10')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '156.767.317-10';

  -- 177. RAUL FAES NASCIMENTO (Alunos 2)
  -- Email: raul.nascimento@gmail.com | CPF: 134.335.957-04 | Senha: Raul
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'raul.nascimento@gmail.com';
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
      'raul.nascimento@gmail.com',
      crypt('Raul', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "RAUL FAES NASCIMENTO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '134.335.957-04')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '134.335.957-04';

  -- 178. ENZO CAMPOS PINTOR (Alunos 2)
  -- Email: cenzo15@yahoo.com | CPF: 144.194.987-90 | Senha: Enzo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'cenzo15@yahoo.com';
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
      'cenzo15@yahoo.com',
      crypt('Enzo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ENZO CAMPOS PINTOR"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '144.194.987-90')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '144.194.987-90';

  -- 179. CARLOS ALBERTO DE QUEIROZ MORAES (Alunos 2)
  -- Email: carlos.moraes@gmail.com | CPF: 423.988.517-53 | Senha: Carlos
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'carlos.moraes@gmail.com';
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
      'carlos.moraes@gmail.com',
      crypt('Carlos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CARLOS ALBERTO DE QUEIROZ MORAES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '423.988.517-53')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '423.988.517-53';

  -- 180. ROLDINEY NAVEGA TERRASON (Alunos 2)
  -- Email: roldiney.terrason@gmail.com | CPF: 105.435.557-63 | Senha: Roldiney
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'roldiney.terrason@gmail.com';
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
      'roldiney.terrason@gmail.com',
      crypt('Roldiney', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ROLDINEY NAVEGA TERRASON"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '105.435.557-63')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '105.435.557-63';

  -- 181. CAILAN DA SILVA CARDOSO (Alunos 2)
  -- Email: cailan.cardoso@gmail.com | CPF: 152.177.207-00 | Senha: Cailan
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'cailan.cardoso@gmail.com';
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
      'cailan.cardoso@gmail.com',
      crypt('Cailan', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CAILAN DA SILVA CARDOSO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '152.177.207-00')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '152.177.207-00';

  -- 182. NUBIA BARRETO DE OLIVEIRA SANTOS ESTEVAO (Alunos 2)
  -- Email: nubia.estevao@gmail.com | CPF: 113.692.537-61 | Senha: Nubia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'nubia.estevao@gmail.com';
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
      'nubia.estevao@gmail.com',
      crypt('Nubia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "NUBIA BARRETO DE OLIVEIRA SANTOS ESTEVAO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '113.692.537-61')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '113.692.537-61';

  -- 183. ISAC ALVES DO NASCIMENTO SALES (Alunos 2)
  -- Email: isac.sales@gmail.com | CPF: 132.071.477-39 | Senha: Isac
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'isac.sales@gmail.com';
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
      'isac.sales@gmail.com',
      crypt('Isac', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ISAC ALVES DO NASCIMENTO SALES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '132.071.477-39')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '132.071.477-39';

  -- 184. DIANA MYUCKI ARAÚJO JACINTO DA SILVA (Alunos 2)
  -- Email: diana.silva@gmail.com | CPF: 218.286.897-69 | Senha: Diana
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'diana.silva@gmail.com';
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
      'diana.silva@gmail.com',
      crypt('Diana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DIANA MYUCKI ARAÚJO JACINTO DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '218.286.897-69')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '218.286.897-69';

  -- 185. LUIS OTAVIO GOMES PEREIRA (Alunos 2)
  -- Email: luisotaviogomespereira1234@hotmail.com | CPF: 205.884.227-89 | Senha: Luis
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'luisotaviogomespereira1234@hotmail.com';
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
      'luisotaviogomespereira1234@hotmail.com',
      crypt('Luis', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LUIS OTAVIO GOMES PEREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '205.884.227-89')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '205.884.227-89';

  -- 186. ARCILA MARIA VIEIRA ALVES (Alunos 2)
  -- Email: arcila.alves@gmail.com | CPF: 638.620.857-91 | Senha: Arcila
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'arcila.alves@gmail.com';
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
      'arcila.alves@gmail.com',
      crypt('Arcila', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ARCILA MARIA VIEIRA ALVES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '638.620.857-91')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '638.620.857-91';

  -- 187. AMELIA COUTINHO TAVARES DOS SANTOS (Alunos 2)
  -- Email: amelia.santos@gmail.com | CPF: 002.354.177-69 | Senha: Amelia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'amelia.santos@gmail.com';
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
      'amelia.santos@gmail.com',
      crypt('Amelia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "AMELIA COUTINHO TAVARES DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '002.354.177-69')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '002.354.177-69';

  -- 188. EMERSON RAMOS ROMOALDO (Alunos 2)
  -- Email: emersonramos1502@gmail.com | CPF: 187.984.417-48 | Senha: Emerson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'emersonramos1502@gmail.com';
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
      'emersonramos1502@gmail.com',
      crypt('Emerson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "EMERSON RAMOS ROMOALDO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '187.984.417-48')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '187.984.417-48';

  -- 189. ANA PAULA BERCOT (Alunos 2)
  -- Email: anapaulabercotsilva@gmail.com | CPF: 075.874.557-52 | Senha: Ana
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'anapaulabercotsilva@gmail.com';
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
      'anapaulabercotsilva@gmail.com',
      crypt('Ana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANA PAULA BERCOT"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '075.874.557-52')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '075.874.557-52';

  -- 190. EDSANDRO JOIA MERLIN (Alunos 2)
  -- Email: edsandro624@gmail.com | CPF: 030.453.137-52 | Senha: Edsandro
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'edsandro624@gmail.com';
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
      'edsandro624@gmail.com',
      crypt('Edsandro', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "EDSANDRO JOIA MERLIN"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '030.453.137-52')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '030.453.137-52';

  -- 191. MARIA JOSÉ DA SILVA VALENTIM (Alunos 2)
  -- Email: mariasilvavalentim19@gmail.com | CPF: 152.672.927-02 | Senha: Maria
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'mariasilvavalentim19@gmail.com';
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
      'mariasilvavalentim19@gmail.com',
      crypt('Maria', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARIA JOSÉ DA SILVA VALENTIM"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '152.672.927-02')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '152.672.927-02';

  -- 192. PAULO VICTOR DE CARVALHO SILVA (Alunos 2)
  -- Email: paulo.carvalho.silva@gmail.com | CPF: 185.673.777-22 | Senha: Paulo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'paulo.carvalho.silva@gmail.com';
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
      'paulo.carvalho.silva@gmail.com',
      crypt('Paulo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "PAULO VICTOR DE CARVALHO SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '185.673.777-22')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '185.673.777-22';

  -- 193. JAIR FAUSTINO DA CUNHA (Alunos 2)
  -- Email: jair.cunha@gmail.com | CPF: 571.543.927-20 | Senha: Jair
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'jair.cunha@gmail.com';
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
      'jair.cunha@gmail.com',
      crypt('Jair', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JAIR FAUSTINO DA CUNHA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '571.543.927-20')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '571.543.927-20';

  -- 194. JANE DE MATOS GOMES (Alunos 2)
  -- Email: jane.gomes@gmail.com | CPF: 070.604.017-17 | Senha: Jane
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'jane.gomes@gmail.com';
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
      'jane.gomes@gmail.com',
      crypt('Jane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JANE DE MATOS GOMES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '070.604.017-17')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '070.604.017-17';

  -- 195. INARA DOS SANTOS GONÇALVES (Alunos 2)
  -- Email: inara.goncalves@gmail.com | CPF: 146.685.557-62 | Senha: Inara
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'inara.goncalves@gmail.com';
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
      'inara.goncalves@gmail.com',
      crypt('Inara', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "INARA DOS SANTOS GONÇALVES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '146.685.557-62')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '146.685.557-62';

  -- 196. ELISÂNGELA GONÇALVES MOTA (Alunos 2)
  -- Email: elisangela.mota@gmail.com | CPF: 108.369.417-05 | Senha: Elisângela
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'elisangela.mota@gmail.com';
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
      'elisangela.mota@gmail.com',
      crypt('Elisângela', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ELISÂNGELA GONÇALVES MOTA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '108.369.417-05')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '108.369.417-05';

  -- 197. MAYCONN SENRA DA SILVA (Alunos 2)
  -- Email: maycon.senra@hotmail.com | CPF: 147.391.627-50 | Senha: Mayconn
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'maycon.senra@hotmail.com';
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
      'maycon.senra@hotmail.com',
      crypt('Mayconn', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MAYCONN SENRA DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '147.391.627-50')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '147.391.627-50';

  -- 198. JULIO CESAR DOS SANTOS GOMES (Alunos 2)
  -- Email: falarcomjuliogomes@gmail.com | CPF: 196.690.497-50 | Senha: Julio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'falarcomjuliogomes@gmail.com';
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
      'falarcomjuliogomes@gmail.com',
      crypt('Julio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JULIO CESAR DOS SANTOS GOMES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '196.690.497-50')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '196.690.497-50';

  -- 199. JOÃO LUCAS CAMPOS VILELA (Alunos 2)
  -- Email: joaolucas.vilela@gmail.com | CPF: 148.217.017-58 | Senha: João
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'joaolucas.vilela@gmail.com';
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
      'joaolucas.vilela@gmail.com',
      crypt('João', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOÃO LUCAS CAMPOS VILELA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '148.217.017-58')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '148.217.017-58';

  -- 200. PAOLA APARECIDA CASTILHO DA SILVA (Alunos 2)
  -- Email: castilhopaola373@gmail.com | CPF: 136.311.027-63 | Senha: Paola
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'castilhopaola373@gmail.com';
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
      'castilhopaola373@gmail.com',
      crypt('Paola', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "PAOLA APARECIDA CASTILHO DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '136.311.027-63')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '136.311.027-63';

  -- 201. MARCEL ANTONIO CORREA TAVARES (Alunos 2)
  -- Email: marcel.correa@hotmail.com | CPF: 087.652.647.46 | Senha: Marcel
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marcel.correa@hotmail.com';
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
      'marcel.correa@hotmail.com',
      crypt('Marcel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCEL ANTONIO CORREA TAVARES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '087.652.647.46')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '087.652.647.46';

  -- 202. CARLOS MARCELO MENIN (Alunos 2)
  -- Email: carlos.menin@gmail.com | CPF: 094.501.337-00 | Senha: Carlos
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'carlos.menin@gmail.com';
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
      'carlos.menin@gmail.com',
      crypt('Carlos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CARLOS MARCELO MENIN"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '094.501.337-00')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '094.501.337-00';

  -- 203. LUCAS DE OLIVEIRA SOUZA (Alunos 2)
  -- Email: lucasolisouzapj@gmail.com | CPF: 146.301.027-36 | Senha: Lucas
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lucasolisouzapj@gmail.com';
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
      'lucasolisouzapj@gmail.com',
      crypt('Lucas', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LUCAS DE OLIVEIRA SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '146.301.027-36')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '146.301.027-36';

  -- 204. MARCOS ANTONIO BARROS DA SILVA (Alunos 2)
  -- Email: mabbarros@yahoo.com.br | CPF: 018.354.577-03 | Senha: Marcos
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'mabbarros@yahoo.com.br';
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
      'mabbarros@yahoo.com.br',
      crypt('Marcos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCOS ANTONIO BARROS DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '018.354.577-03')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '018.354.577-03';

  -- 205. MARLON DA SILVA MANHAES COELHO (Alunos 2)
  -- Email: marlon1coelho1234@gmail.com | CPF: 124.527.027-30 | Senha: Marlon
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marlon1coelho1234@gmail.com';
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
      'marlon1coelho1234@gmail.com',
      crypt('Marlon', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARLON DA SILVA MANHAES COELHO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '124.527.027-30')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '124.527.027-30';

  -- 206. JOSÉ RONDINELI DE MEDEIROS DA SILVA (Alunos 2)
  -- Email: grasiflordepaulo@gmail.com | CPF: 053.088.467-40 | Senha: José
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'grasiflordepaulo@gmail.com';
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
      'grasiflordepaulo@gmail.com',
      crypt('José', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOSÉ RONDINELI DE MEDEIROS DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '053.088.467-40')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '053.088.467-40';

  -- 207. FERNANDA KELEN MATTOS DE LIMA FERNANDES (Alunos 2)
  -- Email: fernanda.fernandes@gmail.com | CPF: 086.683.487-79 | Senha: Fernanda
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'fernanda.fernandes@gmail.com';
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
      'fernanda.fernandes@gmail.com',
      crypt('Fernanda', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "FERNANDA KELEN MATTOS DE LIMA FERNANDES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '086.683.487-79')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '086.683.487-79';

  -- 208. HEITOR ABIB FABRI DE ASSIS (Alunos 2)
  -- Email: heitor.assis@gmail.com | CPF: 136.810.827-07 | Senha: Heitor
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'heitor.assis@gmail.com';
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
      'heitor.assis@gmail.com',
      crypt('Heitor', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "HEITOR ABIB FABRI DE ASSIS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '136.810.827-07')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '136.810.827-07';

  -- 209. DANIELSON JOSE DA SILVA BORGES (Alunos 2)
  -- Email: danielson.borges@gmail.com | CPF: 103.655.857-69 | Senha: Danielson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'danielson.borges@gmail.com';
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
      'danielson.borges@gmail.com',
      crypt('Danielson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DANIELSON JOSE DA SILVA BORGES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '103.655.857-69')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '103.655.857-69';

  -- 210. ROSANA DO AMARAL CHAIM (Alunos 2)
  -- Email: rosanaamaral184@gmail.com | CPF: 146.892.767-14 | Senha: Rosana
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'rosanaamaral184@gmail.com';
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
      'rosanaamaral184@gmail.com',
      crypt('Rosana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ROSANA DO AMARAL CHAIM"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '146.892.767-14')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '146.892.767-14';

  -- 211. MATHEUS SILVA STELLET DE ALMEIDA (Alunos 2)
  -- Email: matheusstellet922@gmail.com | CPF: 155.607.177-97 | Senha: Matheus
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'matheusstellet922@gmail.com';
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
      'matheusstellet922@gmail.com',
      crypt('Matheus', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MATHEUS SILVA STELLET DE ALMEIDA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '155.607.177-97')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '155.607.177-97';

  -- 212. WILLIAN LUIS DA SILVA ALENCAR (Alunos 2)
  -- Email: alencarsilva369@gmail.com | CPF: 130.346.907-38 | Senha: Willian
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'alencarsilva369@gmail.com';
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
      'alencarsilva369@gmail.com',
      crypt('Willian', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "WILLIAN LUIS DA SILVA ALENCAR"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '130.346.907-38')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '130.346.907-38';

  -- 213. EDERSON ARAUJO DE SOUZA (Alunos 2)
  -- Email: ederson.souza@gmail.com | CPF: 090.448.907-86 | Senha: Ederson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'ederson.souza@gmail.com';
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
      'ederson.souza@gmail.com',
      crypt('Ederson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "EDERSON ARAUJO DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '090.448.907-86')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '090.448.907-86';

  -- 214. HUGO MACIEL DE ZEVEDO (Alunos 2)
  -- Email: hugo.zevedo@gmail.com | CPF: 181.294.707-05 | Senha: Hugo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'hugo.zevedo@gmail.com';
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
      'hugo.zevedo@gmail.com',
      crypt('Hugo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "HUGO MACIEL DE ZEVEDO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '181.294.707-05')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '181.294.707-05';

  -- 215. ANTONIA LUCILENE PEREIRA MENDES (Alunos 2)
  -- Email: lucileneantonia@gmail.com | CPF: 066.104.053-44 | Senha: Antonia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lucileneantonia@gmail.com';
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
      'lucileneantonia@gmail.com',
      crypt('Antonia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANTONIA LUCILENE PEREIRA MENDES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '066.104.053-44')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '066.104.053-44';

  -- 216. MARIA BETANIA CAVALCANTE DE SOUZA (Alunos 2)
  -- Email: mariaaahcalvacanti234@gmail.com | CPF: 026.743.114-79 | Senha: Maria
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'mariaaahcalvacanti234@gmail.com';
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
      'mariaaahcalvacanti234@gmail.com',
      crypt('Maria', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARIA BETANIA CAVALCANTE DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '026.743.114-79')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '026.743.114-79';

  -- 217. JOSE RAIMUNDO DOS SANTOS SOUZA (Alunos 2)
  -- Email: joseraimujndo423@gmail.com | CPF: 001.782.915-10 | Senha: Jose
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'joseraimujndo423@gmail.com';
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
      'joseraimujndo423@gmail.com',
      crypt('Jose', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOSE RAIMUNDO DOS SANTOS SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '001.782.915-10')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '001.782.915-10';

  -- 218. SÔNIA DE FÁTIMA ESTANISLAU WERNECK (Alunos 2)
  -- Email: soaniawerneck05@gmail.com | CPF: 008.515.127-04 | Senha: Sônia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'soaniawerneck05@gmail.com';
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
      'soaniawerneck05@gmail.com',
      crypt('Sônia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SÔNIA DE FÁTIMA ESTANISLAU WERNECK"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '008.515.127-04')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '008.515.127-04';

  -- 219. RAQUEL CORRÊA DA SILVA (Alunos 2)
  -- Email: raquelcorrea55@gmail.com | CPF: 165.813.137-18 | Senha: Raquel
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'raquelcorrea55@gmail.com';
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
      'raquelcorrea55@gmail.com',
      crypt('Raquel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "RAQUEL CORRÊA DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '165.813.137-18')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '165.813.137-18';

  -- 220. HANNA PAOLA NAZARIO SANTOS PEREIRA (Alunos 2)
  -- Email: hanna0033@gmail.com | CPF: 106.476.137-27 | Senha: Hanna
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'hanna0033@gmail.com';
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
      'hanna0033@gmail.com',
      crypt('Hanna', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "HANNA PAOLA NAZARIO SANTOS PEREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '106.476.137-27')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '106.476.137-27';

  -- 221. LORRAN WERNECK RODRIGUES (Alunos 2)
  -- Email: lorranrodrigues4@gmail.com | CPF: 059.872.007-33 | Senha: Lorran
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lorranrodrigues4@gmail.com';
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
      'lorranrodrigues4@gmail.com',
      crypt('Lorran', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LORRAN WERNECK RODRIGUES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '059.872.007-33')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '059.872.007-33';

  -- 222. ITAMAR TEIXEIRA (Alunos 2)
  -- Email: itamar.teixeira@gmail.com | CPF: 503.674.636-87 | Senha: Itamar
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'itamar.teixeira@gmail.com';
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
      'itamar.teixeira@gmail.com',
      crypt('Itamar', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ITAMAR TEIXEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '503.674.636-87')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '503.674.636-87';

  -- 223. CARLOS RICARDO SILVA MENDONÇA (Alunos 2)
  -- Email: carlos.ricardo.mendonca@gmail.com | CPF: 134.611.797-79 | Senha: Carlos
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'carlos.ricardo.mendonca@gmail.com';
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
      'carlos.ricardo.mendonca@gmail.com',
      crypt('Carlos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CARLOS RICARDO SILVA MENDONÇA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '134.611.797-79')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '134.611.797-79';

  -- 224. SIMONE REGINA VIEIRA TEIXEIRA (Alunos 2)
  -- Email: simone.regina.teixeira@gmail.com | CPF: 033.180.307-08 | Senha: Simone
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'simone.regina.teixeira@gmail.com';
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
      'simone.regina.teixeira@gmail.com',
      crypt('Simone', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SIMONE REGINA VIEIRA TEIXEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '033.180.307-08')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '033.180.307-08';

  -- 225. MATEUS VIEIRA TEIXEIRA (Alunos 2)
  -- Email: mateus.vieira.teixeira@gmail.com | CPF: 198.101.837-98 | Senha: Mateus
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'mateus.vieira.teixeira@gmail.com';
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
      'mateus.vieira.teixeira@gmail.com',
      crypt('Mateus', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MATEUS VIEIRA TEIXEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '198.101.837-98')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '198.101.837-98';

  -- 226. BRUNO BRITO DA SILVA (Alunos 2)
  -- Email: bruno.brito.silva@gmail.com | CPF: 055.906.227-35 | Senha: Bruno
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'bruno.brito.silva@gmail.com';
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
      'bruno.brito.silva@gmail.com',
      crypt('Bruno', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "BRUNO BRITO DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '055.906.227-35')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '055.906.227-35';

  -- 227. AMARILDO PEREIRA (Alunos 2)
  -- Email: amarildo.pereira@gmail.com | CPF: 017.613.697-50 | Senha: Amarildo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'amarildo.pereira@gmail.com';
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
      'amarildo.pereira@gmail.com',
      crypt('Amarildo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "AMARILDO PEREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '017.613.697-50')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '017.613.697-50';

  -- 228. VALÉRIA TERRA FLORIDO DE SOUZA (Alunos 2)
  -- Email: floridovaleria66@gmail.com | CPF: 112.552.967-66 | Senha: Valéria
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'floridovaleria66@gmail.com';
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
      'floridovaleria66@gmail.com',
      crypt('Valéria', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "VALÉRIA TERRA FLORIDO DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '112.552.967-66')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '112.552.967-66';

  -- 229. SUZELANE MACARIO DE BARROS PAULA (Alunos 2)
  -- Email: suzelane.macario.barros.paula@gmail.com | CPF: 093.923.717-21 | Senha: Suzelane
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'suzelane.macario.barros.paula@gmail.com';
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
      'suzelane.macario.barros.paula@gmail.com',
      crypt('Suzelane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SUZELANE MACARIO DE BARROS PAULA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '093.923.717-21')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '093.923.717-21';

  -- 230. EDSON CABRAL TARDIVO JUNIOR (Alunos 2)
  -- Email: edsoncabral8239@gmail.com | CPF: 011.457.487-16 | Senha: Edson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'edsoncabral8239@gmail.com';
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
      'edsoncabral8239@gmail.com',
      crypt('Edson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "EDSON CABRAL TARDIVO JUNIOR"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '011.457.487-16')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '011.457.487-16';

  -- 231. LIDIANE DOS SANTOS MOREIRA (Alunos 2)
  -- Email: lidiane.santos.moreira@gmail.com | CPF: 170.156.457-26 | Senha: Lidiane
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lidiane.santos.moreira@gmail.com';
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
      'lidiane.santos.moreira@gmail.com',
      crypt('Lidiane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LIDIANE DOS SANTOS MOREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '170.156.457-26')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '170.156.457-26';

  -- 232. ALEXANDRE BARBOSA DO NASCIMENTO (Alunos 2)
  -- Email: alexandrebarbosa042@gmail.com | CPF: 091.750.577-86 | Senha: Alexandre
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'alexandrebarbosa042@gmail.com';
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
      'alexandrebarbosa042@gmail.com',
      crypt('Alexandre', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ALEXANDRE BARBOSA DO NASCIMENTO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '091.750.577-86')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '091.750.577-86';

  -- 233. ALEXANDRE TORRES SANTOS (Alunos 2)
  -- Email: alexandre.barbosa.nascimento@gmail.com | CPF: 123.454.447-46 | Senha: Alexandre
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'alexandre.barbosa.nascimento@gmail.com';
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
      'alexandre.barbosa.nascimento@gmail.com',
      crypt('Alexandre', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ALEXANDRE TORRES SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '123.454.447-46')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '123.454.447-46';

  -- 234. ANILZA DA SILVA ARAÚJO (Alunos 2)
  -- Email: anilza.araujo002@gmail.com | CPF: 055.578.127-50 | Senha: Anilza
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'anilza.araujo002@gmail.com';
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
      'anilza.araujo002@gmail.com',
      crypt('Anilza', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANILZA DA SILVA ARAÚJO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '055.578.127-50')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '055.578.127-50';

  -- 235. CARLOS ALBERTO MENDONÇA DE SOUZA (Alunos 2)
  -- Email: carlosestofadosni@gmail.com | CPF: 099.483.497-76 | Senha: Carlos
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'carlosestofadosni@gmail.com';
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
      'carlosestofadosni@gmail.com',
      crypt('Carlos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CARLOS ALBERTO MENDONÇA DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '099.483.497-76')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '099.483.497-76';

  -- 236. CARLOS EDUARDO RODRIGUES DE LIMA (Alunos 2)
  -- Email: rodriguescauelucas3103@gmail.com | CPF: 183.199.587-50 | Senha: Carlos
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'rodriguescauelucas3103@gmail.com';
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
      'rodriguescauelucas3103@gmail.com',
      crypt('Carlos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CARLOS EDUARDO RODRIGUES DE LIMA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '183.199.587-50')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '183.199.587-50';

  -- 237. CÉZAR SACRAMENTO ALVES (Alunos 2)
  -- Email: cezar.sacramento.alves@gmail.com | CPF: 105.145.377-10 | Senha: Cézar
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'cezar.sacramento.alves@gmail.com';
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
      'cezar.sacramento.alves@gmail.com',
      crypt('Cézar', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CÉZAR SACRAMENTO ALVES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '105.145.377-10')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '105.145.377-10';

  -- 238. CRISTIAN DE SOUZA MELLO (Alunos 2)
  -- Email: cristian.souza.mello@gmail.com | CPF: 116.459.797-33 | Senha: Cristian
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'cristian.souza.mello@gmail.com';
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
      'cristian.souza.mello@gmail.com',
      crypt('Cristian', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CRISTIAN DE SOUZA MELLO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '116.459.797-33')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '116.459.797-33';

  -- 239. DANIEL INACIO DE LIMA (Alunos 2)
  -- Email: diclima42@gmail.com | CPF: 120.381.907-20 | Senha: Daniel
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'diclima42@gmail.com';
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
      'diclima42@gmail.com',
      crypt('Daniel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DANIEL INACIO DE LIMA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '120.381.907-20')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '120.381.907-20';

  -- 240. DIEGO DE SOUZA MARTINS (Alunos 2)
  -- Email: diogomartinsrj4@gmail.com | CPF: 173.137.827-05 | Senha: Diego
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'diogomartinsrj4@gmail.com';
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
      'diogomartinsrj4@gmail.com',
      crypt('Diego', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DIEGO DE SOUZA MARTINS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '173.137.827-05')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '173.137.827-05';

  -- 241. HENRIQUE SOARES DA SILVA (Alunos 2)
  -- Email: henrique.soares.silva@gmail.com | CPF: 041.251.617-98 | Senha: Henrique
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'henrique.soares.silva@gmail.com';
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
      'henrique.soares.silva@gmail.com',
      crypt('Henrique', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "HENRIQUE SOARES DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '041.251.617-98')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '041.251.617-98';

  -- 242. JOSELIA EMILIA DA SILVA (Alunos 2)
  -- Email: joselia.emilia.silva@gmail.com | CPF: 002.244.527-70 | Senha: Joselia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'joselia.emilia.silva@gmail.com';
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
      'joselia.emilia.silva@gmail.com',
      crypt('Joselia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOSELIA EMILIA DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '002.244.527-70')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '002.244.527-70';

  -- 243. LEONARDO DA SILVA BARBOSA (Alunos 2)
  -- Email: leonardo06barbosa@gmail.com | CPF: 059.124.487-03 | Senha: Leonardo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'leonardo06barbosa@gmail.com';
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
      'leonardo06barbosa@gmail.com',
      crypt('Leonardo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LEONARDO DA SILVA BARBOSA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '059.124.487-03')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '059.124.487-03';

  -- 244. MARIA CLEIDE DE LEMOS LIMA (Alunos 2)
  -- Email: mariacleiderj@gmail.com | CPF: 955.020.767-68 | Senha: Maria
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'mariacleiderj@gmail.com';
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
      'mariacleiderj@gmail.com',
      crypt('Maria', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARIA CLEIDE DE LEMOS LIMA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '955.020.767-68')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '955.020.767-68';

  -- 245. MARIANA MIRANDA FARIA (Alunos 2)
  -- Email: marianafarias3110@gmail.com | CPF: 091.147.167-71 | Senha: Mariana
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marianafarias3110@gmail.com';
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
      'marianafarias3110@gmail.com',
      crypt('Mariana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARIANA MIRANDA FARIA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '091.147.167-71')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '091.147.167-71';

  -- 246. RAIANE SANTOS DE OLIVEIRA (Alunos 2)
  -- Email: pedroregisgato0508@gmail.com | CPF: 201.442.757-75 | Senha: Raiane
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'pedroregisgato0508@gmail.com';
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
      'pedroregisgato0508@gmail.com',
      crypt('Raiane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "RAIANE SANTOS DE OLIVEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '201.442.757-75')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '201.442.757-75';

  -- 247. SANDRA ROSA SANTANA DE JESUS (Alunos 2)
  -- Email: sandra.rosa.santana.jesus@gmail.com | CPF: 093.018.277-43 | Senha: Sandra
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'sandra.rosa.santana.jesus@gmail.com';
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
      'sandra.rosa.santana.jesus@gmail.com',
      crypt('Sandra', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SANDRA ROSA SANTANA DE JESUS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '093.018.277-43')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '093.018.277-43';

  -- 248. TALITA DOS SANTOS (Alunos 2)
  -- Email: tsreserva.1@gmail.com | CPF: 193.048767-37 | Senha: Talita
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'tsreserva.1@gmail.com';
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
      'tsreserva.1@gmail.com',
      crypt('Talita', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "TALITA DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '193.048767-37')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '193.048767-37';

  -- 249. REGINALDO VALENTIM DA SILVA (Alunos 2)
  -- Email: reginaldovalentim050@gmail.com | CPF: 047.065.777-48 | Senha: Reginaldo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'reginaldovalentim050@gmail.com';
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
      'reginaldovalentim050@gmail.com',
      crypt('Reginaldo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "REGINALDO VALENTIM DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '047.065.777-48')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '047.065.777-48';

  -- 250. VALERIA MACHADO DA SILVA (Alunos 2)
  -- Email: valeria.machado.silva@gmail.com | CPF: 013.278.727-06 | Senha: Valeria
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'valeria.machado.silva@gmail.com';
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
      'valeria.machado.silva@gmail.com',
      crypt('Valeria', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "VALERIA MACHADO DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '013.278.727-06')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '013.278.727-06';

  -- 251. VITOR HUGO DA CRUZ SILVA (Alunos 2)
  -- Email: vhcruz2003@gmail.com | CPF: 156.476.657-80 | Senha: Vitor
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'vhcruz2003@gmail.com';
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
      'vhcruz2003@gmail.com',
      crypt('Vitor', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "VITOR HUGO DA CRUZ SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '156.476.657-80')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '156.476.657-80';

  -- 252. VITORIA DA SILVA MONTE DE SOUZA (Alunos 2)
  -- Email: vitoriamontes58@gmail.com | CPF: 169.791.667-86 | Senha: Vitoria
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'vitoriamontes58@gmail.com';
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
      'vitoriamontes58@gmail.com',
      crypt('Vitoria', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "VITORIA DA SILVA MONTE DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '169.791.667-86')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '169.791.667-86';

  -- 253. WALLACE DA SILVA MOREIRA (Alunos 2)
  -- Email: sodanii@yahoo.com.br | CPF: 165.330.377-81 | Senha: Wallace
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'sodanii@yahoo.com.br';
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
      'sodanii@yahoo.com.br',
      crypt('Wallace', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "WALLACE DA SILVA MOREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '165.330.377-81')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '165.330.377-81';

  -- 254. ALEX DE SOUZA DA SILVA (Alunos 2)
  -- Email: souzaalex0248@gmail.com | CPF: 093.425.527-06 | Senha: Alex
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'souzaalex0248@gmail.com';
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
      'souzaalex0248@gmail.com',
      crypt('Alex', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ALEX DE SOUZA DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '093.425.527-06')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '093.425.527-06';

  -- 255. CELINA DE JESUS EUGENIO (Alunos 2)
  -- Email: netvinyeugenio@hotmail.com | CPF: 074741457-23 | Senha: Celina
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'netvinyeugenio@hotmail.com';
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
      'netvinyeugenio@hotmail.com',
      crypt('Celina', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CELINA DE JESUS EUGENIO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '074741457-23')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '074741457-23';

  -- 256. CRISTIANE SOUZA DE JESUS SAMPAIO (Alunos 2)
  -- Email: cristianesampaio2409@gmail.com | CPF: 113.442.487-64 | Senha: Cristiane
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'cristianesampaio2409@gmail.com';
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
      'cristianesampaio2409@gmail.com',
      crypt('Cristiane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CRISTIANE SOUZA DE JESUS SAMPAIO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '113.442.487-64')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '113.442.487-64';

  -- 257. DAIANA CRISTINA ROSA DE BRITO GOUVEA (Alunos 2)
  -- Email: daiannacristinna@icloud.com | CPF: 113.182.237-41 | Senha: Daiana
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'daiannacristinna@icloud.com';
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
      'daiannacristinna@icloud.com',
      crypt('Daiana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DAIANA CRISTINA ROSA DE BRITO GOUVEA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '113.182.237-41')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '113.182.237-41';

  -- 258. DIEGO CAMPOS GOMES (Alunos 2)
  -- Email: diego.campos.gomes@gmail.com | CPF: 128.999.487-09 | Senha: Diego
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'diego.campos.gomes@gmail.com';
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
      'diego.campos.gomes@gmail.com',
      crypt('Diego', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DIEGO CAMPOS GOMES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '128.999.487-09')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '128.999.487-09';

  -- 259. ERICK BLOISE LIMA (Alunos 2)
  -- Email: erick.bloise.lima@gmail.com | CPF: 132.046.557-92 | Senha: Erick
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'erick.bloise.lima@gmail.com';
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
      'erick.bloise.lima@gmail.com',
      crypt('Erick', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ERICK BLOISE LIMA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '132.046.557-92')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '132.046.557-92';

  -- 260. GABRIEL DA CONCEICAO DOS SANTOS (Alunos 2)
  -- Email: gabrielcsantos234@gmail.com | CPF: 115.107.607-41 | Senha: Gabriel
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'gabrielcsantos234@gmail.com';
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
      'gabrielcsantos234@gmail.com',
      crypt('Gabriel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GABRIEL DA CONCEICAO DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '115.107.607-41')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '115.107.607-41';

  -- 261. GEORGE COSME DO NASCIMENTO (Alunos 2)
  -- Email: georgecosmenascimento@gmail.com | CPF: 124.602.187-02 | Senha: George
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'georgecosmenascimento@gmail.com';
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
      'georgecosmenascimento@gmail.com',
      crypt('George', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GEORGE COSME DO NASCIMENTO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '124.602.187-02')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '124.602.187-02';

  -- 262. GIZELE DA CONCEIÇÃO DOS SANTOS (Alunos 2)
  -- Email: gizele.conceicao.santos@gmail.com | CPF: 094.554.737-47 | Senha: Gizele
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'gizele.conceicao.santos@gmail.com';
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
      'gizele.conceicao.santos@gmail.com',
      crypt('Gizele', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GIZELE DA CONCEIÇÃO DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '094.554.737-47')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '094.554.737-47';

  -- 263. ISABELA BARBOSA DOS SANTOS (Alunos 2)
  -- Email: isabellabarbosa034@gmail.com | CPF: 060.273.487-80 | Senha: Isabela
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'isabellabarbosa034@gmail.com';
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
      'isabellabarbosa034@gmail.com',
      crypt('Isabela', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ISABELA BARBOSA DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '060.273.487-80')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '060.273.487-80';

  -- 264. JOSÉ LISBOA PEREIRA (Alunos 2)
  -- Email: jose.lisboa.pereira@gmail.com | CPF: 632.099.854-72 | Senha: José
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'jose.lisboa.pereira@gmail.com';
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
      'jose.lisboa.pereira@gmail.com',
      crypt('José', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOSÉ LISBOA PEREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '632.099.854-72')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '632.099.854-72';

  -- 265. JULIA APARECIDA VICTOR DE ARAUJO (Alunos 2)
  -- Email: aparecidajulia3002@gmail.com | CPF: 221.220.007-24 | Senha: Julia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'aparecidajulia3002@gmail.com';
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
      'aparecidajulia3002@gmail.com',
      crypt('Julia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JULIA APARECIDA VICTOR DE ARAUJO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '221.220.007-24')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '221.220.007-24';

  -- 266. KELLY LUCIA BENVINDO BATISTA CANUST (Alunos 2)
  -- Email: kelly.lucia.benvindo.batista.canust@gmail.com | CPF: 111.902.007-75 | Senha: Kelly
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'kelly.lucia.benvindo.batista.canust@gmail.com';
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
      'kelly.lucia.benvindo.batista.canust@gmail.com',
      crypt('Kelly', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "KELLY LUCIA BENVINDO BATISTA CANUST"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '111.902.007-75')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '111.902.007-75';

  -- 267. LEANDRO GONÇALVES TIAGO (Alunos 2)
  -- Email: leandro.goncalves.tiago@gmail.com | CPF: 224.958.427-39 | Senha: Leandro
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'leandro.goncalves.tiago@gmail.com';
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
      'leandro.goncalves.tiago@gmail.com',
      crypt('Leandro', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LEANDRO GONÇALVES TIAGO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '224.958.427-39')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '224.958.427-39';

  -- 268. LORRANA GOMES DE SOUZA (Alunos 2)
  -- Email: lorranagomes.adv@amail.com | CPF: 118.013.827-94 | Senha: Lorrana
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lorranagomes.adv@amail.com';
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
      'lorranagomes.adv@amail.com',
      crypt('Lorrana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LORRANA GOMES DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '118.013.827-94')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '118.013.827-94';

  -- 269. MARCIA VICTOR DE ASSIS FRAZÃO (Alunos 2)
  -- Email: marciavictorfrazao@gmail.com | CPF: 129.168.677-08 | Senha: Marcia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marciavictorfrazao@gmail.com';
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
      'marciavictorfrazao@gmail.com',
      crypt('Marcia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCIA VICTOR DE ASSIS FRAZÃO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '129.168.677-08')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '129.168.677-08';

  -- 270. MARCOS DOS SANTOS FELIX (Alunos 2)
  -- Email: marcosfelix452023@gmail.com | CPF: 042.703.297-00 | Senha: Marcos
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marcosfelix452023@gmail.com';
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
      'marcosfelix452023@gmail.com',
      crypt('Marcos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCOS DOS SANTOS FELIX"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '042.703.297-00')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '042.703.297-00';

  -- 271. MARIA APARECIDA DA SILVA (Alunos 2)
  -- Email: lizacamylle@hotmail.com | CPF: 741.318.187-87 | Senha: Maria
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lizacamylle@hotmail.com';
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
      'lizacamylle@hotmail.com',
      crypt('Maria', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARIA APARECIDA DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '741.318.187-87')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '741.318.187-87';

  -- 272. NATHALIA SPERENDIO DE OLIVEIRA (Alunos 2)
  -- Email: nathalia.sperendio.oliveira@gmail.com | CPF: 164.796.637-05 | Senha: Nathalia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'nathalia.sperendio.oliveira@gmail.com';
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
      'nathalia.sperendio.oliveira@gmail.com',
      crypt('Nathalia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "NATHALIA SPERENDIO DE OLIVEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '164.796.637-05')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '164.796.637-05';

  -- 273. SILVIA MARIA ALVES MACIEL (Alunos 2)
  -- Email: smatrb.maciel@gmail.com | CPF: 078.880.677-78 | Senha: Silvia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'smatrb.maciel@gmail.com';
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
      'smatrb.maciel@gmail.com',
      crypt('Silvia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SILVIA MARIA ALVES MACIEL"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '078.880.677-78')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '078.880.677-78';

  -- 274. TATIANE NUNES MOTA (Alunos 2)
  -- Email: tatiane.nunes.mota@gmail.com | CPF: 056.800.577-51 | Senha: Tatiane
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'tatiane.nunes.mota@gmail.com';
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
      'tatiane.nunes.mota@gmail.com',
      crypt('Tatiane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "TATIANE NUNES MOTA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '056.800.577-51')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '056.800.577-51';

  -- 275. LEANDRO SPERENDIO DE OLIVEIRA (Alunos 2)
  -- Email: pr.sperendio@gnail.com | CPF: 097.222.787-38 | Senha: Leandro
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'pr.sperendio@gnail.com';
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
      'pr.sperendio@gnail.com',
      crypt('Leandro', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LEANDRO SPERENDIO DE OLIVEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '097.222.787-38')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '097.222.787-38';

  -- 276. ANDRÉ LUIZ LAUREANO (Alunos 2)
  -- Email: andreluizlaureano1976@gmail.com | CPF: 109.684.687-05 | Senha: André
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'andreluizlaureano1976@gmail.com';
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
      'andreluizlaureano1976@gmail.com',
      crypt('André', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANDRÉ LUIZ LAUREANO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '109.684.687-05')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '109.684.687-05';

  -- 277. ANTONIO CARLOS DO NASCIMENTO DE SOUZA (Alunos 2)
  -- Email: toninho_ns@hotmail.com | CPF: 116.282.187-62 | Senha: Antonio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'toninho_ns@hotmail.com';
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
      'toninho_ns@hotmail.com',
      crypt('Antonio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANTONIO CARLOS DO NASCIMENTO DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '116.282.187-62')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '116.282.187-62';

  -- 278. GABRIELLA RANGEL DA SILVA (Alunos 2)
  -- Email: gabriella.dg2018@hotmail.com | CPF: 172.477.407-79 | Senha: Gabriella
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'gabriella.dg2018@hotmail.com';
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
      'gabriella.dg2018@hotmail.com',
      crypt('Gabriella', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GABRIELLA RANGEL DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '172.477.407-79')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '172.477.407-79';

  -- 279. GABRIELLA OLINDA DE CASTRO (Alunos 2)
  -- Email: gabiolinda@gmail.com | CPF: 101.089.307-69 | Senha: Gabriella
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'gabiolinda@gmail.com';
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
      'gabiolinda@gmail.com',
      crypt('Gabriella', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GABRIELLA OLINDA DE CASTRO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '101.089.307-69')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '101.089.307-69';

  -- 280. GREICE MARA DE SOUZA (Alunos 2)
  -- Email: greicegov@gmail.com | CPF: 017.742.367-61 | Senha: Greice
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'greicegov@gmail.com';
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
      'greicegov@gmail.com',
      crypt('Greice', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GREICE MARA DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '017.742.367-61')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '017.742.367-61';

  -- 281. GUIDO SIQUEIRA PESSANHA (Alunos 2)
  -- Email: guigas.campos@gmail.com | CPF: 102.667.517-09 | Senha: Guido
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'guigas.campos@gmail.com';
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
      'guigas.campos@gmail.com',
      crypt('Guido', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GUIDO SIQUEIRA PESSANHA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '102.667.517-09')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '102.667.517-09';

  -- 282. HEWERTON FERNANDES GOMES DE SOUZA (Alunos 2)
  -- Email: hewfer@gmail.com | CPF: 112.389.267-97 | Senha: Hewerton
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'hewfer@gmail.com';
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
      'hewfer@gmail.com',
      crypt('Hewerton', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "HEWERTON FERNANDES GOMES DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '112.389.267-97')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '112.389.267-97';

  -- 283. KELLY GOMES MONTEIRO DE SOUZA (Alunos 2)
  -- Email: kellygomesmonteiro3@gmail.com | CPF: 115.879.217-40 | Senha: Kelly
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'kellygomesmonteiro3@gmail.com';
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
      'kellygomesmonteiro3@gmail.com',
      crypt('Kelly', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "KELLY GOMES MONTEIRO DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '115.879.217-40')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '115.879.217-40';

  -- 284. LARISSA ALVES PESSANHA (Alunos 2)
  -- Email: laripessanha@gmail.com | CPF: 167.416.267-78 | Senha: Larissa
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'laripessanha@gmail.com';
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
      'laripessanha@gmail.com',
      crypt('Larissa', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LARISSA ALVES PESSANHA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '167.416.267-78')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '167.416.267-78';

  -- 285. LEONARDO BARROS CORDEIRO MOREIRA (Alunos 2)
  -- Email: leonardobmoreira@live.com | CPF: 103.565.597-77 | Senha: Leonardo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'leonardobmoreira@live.com';
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
      'leonardobmoreira@live.com',
      crypt('Leonardo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LEONARDO BARROS CORDEIRO MOREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '103.565.597-77')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '103.565.597-77';

  -- 286. LUCAS RANGEL GOMES PERES (Alunos 2)
  -- Email: lucasrangelgomesperes@gmail.com | CPF: 149.748.837-04 | Senha: Lucas
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lucasrangelgomesperes@gmail.com';
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
      'lucasrangelgomesperes@gmail.com',
      crypt('Lucas', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LUCAS RANGEL GOMES PERES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '149.748.837-04')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '149.748.837-04';

  -- 287. VITOR CORREA THOMAZ DOS SANTOS (Alunos 2)
  -- Email: vitorcorreafotografo@gmail.com | CPF: 149.921.037-07 | Senha: Vitor
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'vitorcorreafotografo@gmail.com';
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
      'vitorcorreafotografo@gmail.com',
      crypt('Vitor', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "VITOR CORREA THOMAZ DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '149.921.037-07')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '149.921.037-07';

  -- 288. TIAGO SOUZA SILVA (Alunos 2)
  -- Email: titimacuco@gmail.com | CPF: 163.819.877-23 | Senha: Tiago
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'titimacuco@gmail.com';
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
      'titimacuco@gmail.com',
      crypt('Tiago', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "TIAGO SOUZA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '163.819.877-23')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '163.819.877-23';

  -- 289. JEFERSON ALENCAR PONCE GOMES (Alunos 2)
  -- Email: jefferson.alerj@gmail.com | CPF: 125.580.847-04 | Senha: Jeferson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'jefferson.alerj@gmail.com';
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
      'jefferson.alerj@gmail.com',
      crypt('Jeferson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JEFERSON ALENCAR PONCE GOMES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '125.580.847-04')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '125.580.847-04';

  -- 290. ALINE DUNCAN DA SILVA SOARES (Alunos 2)
  -- Email: alineduncan@gmail.com | CPF: 102.101.297-19 | Senha: Aline
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'alineduncan@gmail.com';
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
      'alineduncan@gmail.com',
      crypt('Aline', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ALINE DUNCAN DA SILVA SOARES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '102.101.297-19')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '102.101.297-19';

  -- 291. ÁLVARO RIBEIRO LEIXAS (Alunos 2)
  -- Email: alvari@gmail.com | CPF: 182.024.147-50 | Senha: Álvaro
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'alvari@gmail.com';
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
      'alvari@gmail.com',
      crypt('Álvaro', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ÁLVARO RIBEIRO LEIXAS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '182.024.147-50')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '182.024.147-50';

  -- 292. ANGELA MARIA FERNANDES DE SOUZA SANTOS (Alunos 2)
  -- Email: angmaria1988@gmail.com | CPF: 130.210.677-51 | Senha: Angela
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'angmaria1988@gmail.com';
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
      'angmaria1988@gmail.com',
      crypt('Angela', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANGELA MARIA FERNANDES DE SOUZA SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '130.210.677-51')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '130.210.677-51';

  -- 293. CARLOS AUGUSTO BARRETO LOUREIRO (Alunos 2)
  -- Email: barretolou@hotmail.com | CPF: 624.088.957-15 | Senha: Carlos
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'barretolou@hotmail.com';
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
      'barretolou@hotmail.com',
      crypt('Carlos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CARLOS AUGUSTO BARRETO LOUREIRO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '624.088.957-15')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '624.088.957-15';

  -- 294. DANIELA RANGEL DA SILVA (Alunos 2)
  -- Email: dani.dasilvarangel@gmail.com | CPF: 196.417.777-42 | Senha: Daniela
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'dani.dasilvarangel@gmail.com';
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
      'dani.dasilvarangel@gmail.com',
      crypt('Daniela', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DANIELA RANGEL DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '196.417.777-42')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '196.417.777-42';

  -- 295. DANIELLE AMARAL PINAGE DE LIMA (Alunos 2)
  -- Email: danisouza194@hotmail.com | CPF: 078.509.477-62 | Senha: Danielle
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'danisouza194@hotmail.com';
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
      'danisouza194@hotmail.com',
      crypt('Danielle', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DANIELLE AMARAL PINAGE DE LIMA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '078.509.477-62')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '078.509.477-62';

  -- 296. DENIS DE ALMEIDA GARCEZ (Alunos 2)
  -- Email: garcezdenis46@gmail.com | CPF: 095.412.597-58 | Senha: Denis
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'garcezdenis46@gmail.com';
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
      'garcezdenis46@gmail.com',
      crypt('Denis', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DENIS DE ALMEIDA GARCEZ"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '095.412.597-58')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '095.412.597-58';

  -- 297. GABRIEL VIRGOLINO DOS SANTOS (Alunos 2)
  -- Email: gabivirgo128@gmail.com | CPF: 165.289.907-35 | Senha: Gabriel
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'gabivirgo128@gmail.com';
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
      'gabivirgo128@gmail.com',
      crypt('Gabriel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GABRIEL VIRGOLINO DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '165.289.907-35')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '165.289.907-35';

  -- 298. JULIANA BARRINHA DE OLIVEIRA (Alunos 2)
  -- Email: juhbarrinha@gmail.com | CPF: 151.803.827-18 | Senha: Juliana
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'juhbarrinha@gmail.com';
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
      'juhbarrinha@gmail.com',
      crypt('Juliana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JULIANA BARRINHA DE OLIVEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '151.803.827-18')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '151.803.827-18';

  -- 299. KATIA REGINA PINHEIRO (Alunos 2)
  -- Email: katiapinheiro1986@gmail.com | CPF: 058.021.477-09 | Senha: Katia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'katiapinheiro1986@gmail.com';
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
      'katiapinheiro1986@gmail.com',
      crypt('Katia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "KATIA REGINA PINHEIRO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '058.021.477-09')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '058.021.477-09';

  -- 300. KAUAN PINHEIRO DE SOUZA (Alunos 2)
  -- Email: kaupinheiro@gmail.com | CPF: 202.845.077-09 | Senha: Kauan
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'kaupinheiro@gmail.com';
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
      'kaupinheiro@gmail.com',
      crypt('Kauan', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "KAUAN PINHEIRO DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '202.845.077-09')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '202.845.077-09';

  -- 301. MILLENA RIOS PEREIRA (Alunos 2)
  -- Email: millenariopsi@gmail.com | CPF: 119.864.577-61 | Senha: Millena
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'millenariopsi@gmail.com';
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
      'millenariopsi@gmail.com',
      crypt('Millena', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MILLENA RIOS PEREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '119.864.577-61')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '119.864.577-61';

  -- 302. ROGÉRIO RODRIGUES DOS SANTOS (Alunos 2)
  -- Email: rogerodrigues199@gmail.com | CPF: 060.029.617-20 | Senha: Rogério
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'rogerodrigues199@gmail.com';
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
      'rogerodrigues199@gmail.com',
      crypt('Rogério', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ROGÉRIO RODRIGUES DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '060.029.617-20')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '060.029.617-20';

  -- 303. ANDRÉ WASLEY RIBEIRO FIRMO (Alunos 2)
  -- Email: andrewasley@gmail.com | CPF: 058.983.277-89 | Senha: André
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'andrewasley@gmail.com';
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
      'andrewasley@gmail.com',
      crypt('André', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANDRÉ WASLEY RIBEIRO FIRMO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '058.983.277-89')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '058.983.277-89';

  -- 304. JURANDIR MATOS BRANDÃO (Alunos 2)
  -- Email: jurandimatos000@gmail.com | CPF: 622.011.405-10 | Senha: Jurandir
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'jurandimatos000@gmail.com';
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
      'jurandimatos000@gmail.com',
      crypt('Jurandir', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JURANDIR MATOS BRANDÃO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '622.011.405-10')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '622.011.405-10';

  -- 305. FRANCISCO JOSE NATAL FERREIRA (Alunos 2)
  -- Email: francisconatao000@gmail.com | CPF: 086.257.737-37 | Senha: Francisco
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'francisconatao000@gmail.com';
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
      'francisconatao000@gmail.com',
      crypt('Francisco', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "FRANCISCO JOSE NATAL FERREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '086.257.737-37')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '086.257.737-37';

  -- 306. JOÃO ELIAS CHAVES DE BRITO (Alunos 2)
  -- Email: eliasbrito 123@gmail.com | CPF: 011 .600.807-55 | Senha: João
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'eliasbrito 123@gmail.com';
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
      'eliasbrito 123@gmail.com',
      crypt('João', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOÃO ELIAS CHAVES DE BRITO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '011 .600.807-55')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '011 .600.807-55';

  -- 307. MAXUEL MARIA DA SILVA (Alunos 2)
  -- Email: maxwellmariadasilva@gmail.com | CPF: 133.305.637-02 | Senha: Maxuel
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'maxwellmariadasilva@gmail.com';
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
      'maxwellmariadasilva@gmail.com',
      crypt('Maxuel', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MAXUEL MARIA DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '133.305.637-02')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '133.305.637-02';

  -- 308. MAURÍCIO DE SOUZA TEIXEIRA (Alunos 2)
  -- Email: mausouza@gmail.com | CPF: 102.053.347-17 | Senha: Maurício
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'mausouza@gmail.com';
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
      'mausouza@gmail.com',
      crypt('Maurício', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MAURÍCIO DE SOUZA TEIXEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '102.053.347-17')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '102.053.347-17';

  -- 309. ELEXANDRA LISBÔA DOS SANTOS AMARANTE (Alunos 2)
  -- Email: elexandra lisboa@gmail.com | CPF: 096.496.397-30 | Senha: Elexandra
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'elexandra lisboa@gmail.com';
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
      'elexandra lisboa@gmail.com',
      crypt('Elexandra', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ELEXANDRA LISBÔA DOS SANTOS AMARANTE"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '096.496.397-30')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '096.496.397-30';

  -- 310. ANGELICA DIAS DE OLIVEIRA (Alunos 2)
  -- Email: angelica.dias.oliveira@gmail.com | CPF: 046.379.897-01 | Senha: Angelica
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'angelica.dias.oliveira@gmail.com';
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
      'angelica.dias.oliveira@gmail.com',
      crypt('Angelica', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANGELICA DIAS DE OLIVEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '046.379.897-01')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '046.379.897-01';

  -- 311. CARLOS CORREA FIRMO (Alunos 2)
  -- Email: carlos.correa.firmo@gmail.com | CPF: 051.678.087-58 | Senha: Carlos
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'carlos.correa.firmo@gmail.com';
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
      'carlos.correa.firmo@gmail.com',
      crypt('Carlos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CARLOS CORREA FIRMO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '051.678.087-58')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '051.678.087-58';

  -- 312. GENILSON DOS SANTOS SILVA (Alunos 2)
  -- Email: genilson.santos.silva@gmail.com | CPF: 099.464.187-70 | Senha: Genilson
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'genilson.santos.silva@gmail.com';
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
      'genilson.santos.silva@gmail.com',
      crypt('Genilson', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GENILSON DOS SANTOS SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '099.464.187-70')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '099.464.187-70';

  -- 313. HELENA RIBEIRO (Alunos 2)
  -- Email: helena.ribeiro.nunes@gmail.com | CPF: 917. 484. 537-34 | Senha: Helena
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'helena.ribeiro.nunes@gmail.com';
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
      'helena.ribeiro.nunes@gmail.com',
      crypt('Helena', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "HELENA RIBEIRO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '917. 484. 537-34')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '917. 484. 537-34';

  -- 314. JAILTON MORAIS DE SOUZA (Alunos 2)
  -- Email: lenomorais23@gmail.com | CPF: 730.883.584-72 | Senha: Jailton
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lenomorais23@gmail.com';
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
      'lenomorais23@gmail.com',
      crypt('Jailton', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JAILTON MORAIS DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '730.883.584-72')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '730.883.584-72';

  -- 315. LIVYA MARCELLY DINIZ COSTA (Alunos 2)
  -- Email: livyadiniz8@gmail.com | CPF: 185.130.337-58 | Senha: Livya
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'livyadiniz8@gmail.com';
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
      'livyadiniz8@gmail.com',
      crypt('Livya', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LIVYA MARCELLY DINIZ COSTA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '185.130.337-58')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '185.130.337-58';

  -- 316. MARIA ASSUNÇÃO DE ALMEIDA (Alunos 2)
  -- Email: mariaalmeida 123@gmail.com | CPF: 306.402.887-15 | Senha: Maria
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'mariaalmeida 123@gmail.com';
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
      'mariaalmeida 123@gmail.com',
      crypt('Maria', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARIA ASSUNÇÃO DE ALMEIDA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '306.402.887-15')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '306.402.887-15';

  -- 317. RAFAEL DIAS RIBEIRO (Alunos 2)
  -- Email: rafael.dias.ribeiro@gmail.com | CPF: 095.270.567-21 | Senha: Rafael
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'rafael.dias.ribeiro@gmail.com';
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
      'rafael.dias.ribeiro@gmail.com',
      crypt('Rafael', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "RAFAEL DIAS RIBEIRO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '095.270.567-21')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '095.270.567-21';

  -- 318. SIMONE APARECIDA MENEZES DE ABREU (Alunos 2)
  -- Email: simone.aparecida.menezes.abreu@gmail.com | CPF: 000.116.466-08 | Senha: Simone
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'simone.aparecida.menezes.abreu@gmail.com';
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
      'simone.aparecida.menezes.abreu@gmail.com',
      crypt('Simone', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SIMONE APARECIDA MENEZES DE ABREU"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '000.116.466-08')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '000.116.466-08';

  -- 319. VIRGILIO PANISSOLO PEREIRA (Alunos 2)
  -- Email: virgilio.panissolo.pereira@gmail.com | CPF: 066.487.657-84 | Senha: Virgilio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'virgilio.panissolo.pereira@gmail.com';
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
      'virgilio.panissolo.pereira@gmail.com',
      crypt('Virgilio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "VIRGILIO PANISSOLO PEREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '066.487.657-84')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '066.487.657-84';

  -- 320. SILVIO DOS SANTOS SOUZA (Alunos 2)
  -- Email: silvio.santos.souza@gmail.com | CPF: 037.172.207-13 | Senha: Silvio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'silvio.santos.souza@gmail.com';
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
      'silvio.santos.souza@gmail.com',
      crypt('Silvio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SILVIO DOS SANTOS SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '037.172.207-13')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '037.172.207-13';

  -- 321. FABIANO PEREIRA ROCHA (Alunos 2)
  -- Email: fabiano.pereira.rocha@gmail.com | CPF: 133.381.877-77 | Senha: Fabiano
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'fabiano.pereira.rocha@gmail.com';
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
      'fabiano.pereira.rocha@gmail.com',
      crypt('Fabiano', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "FABIANO PEREIRA ROCHA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '133.381.877-77')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '133.381.877-77';

  -- 322. SUELEN OLIVEIRA SILVA (Alunos 2)
  -- Email: suelen.maisa.lipe@gmail.com | CPF: 145.652.707-06 | Senha: Suelen
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'suelen.maisa.lipe@gmail.com';
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
      'suelen.maisa.lipe@gmail.com',
      crypt('Suelen', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SUELEN OLIVEIRA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '145.652.707-06')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '145.652.707-06';

  -- 323. MARCELO RODRIGUES LAMENHA (Alunos 2)
  -- Email: diretormegamix@gmail.co | CPF: 053.276.067-08 | Senha: Marcelo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'diretormegamix@gmail.co';
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
      'diretormegamix@gmail.co',
      crypt('Marcelo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCELO RODRIGUES LAMENHA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '053.276.067-08')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '053.276.067-08';

  -- 324. FENELA FREITAS ASSED (Alunos 2)
  -- Email: fenelassed@hotmail.com | CPF: 113.241.437-70 | Senha: Fenela
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'fenelassed@hotmail.com';
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
      'fenelassed@hotmail.com',
      crypt('Fenela', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "FENELA FREITAS ASSED"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '113.241.437-70')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '113.241.437-70';

  -- 325. LIDIANE ALENCAR PONCE GOMES (Alunos 2)
  -- Email: lidiane.alencar.ponce.gomes@gmail.com | CPF: 132.687.707-03 | Senha: Lidiane
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lidiane.alencar.ponce.gomes@gmail.com';
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
      'lidiane.alencar.ponce.gomes@gmail.com',
      crypt('Lidiane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LIDIANE ALENCAR PONCE GOMES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '132.687.707-03')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '132.687.707-03';

  -- 326. SERGIO CARLOS FERREIRA SEVERIANO (Alunos 2)
  -- Email: sfseveriano@hotmail.com | CPF: 030.538.417-11 | Senha: Sergio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'sfseveriano@hotmail.com';
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
      'sfseveriano@hotmail.com',
      crypt('Sergio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SERGIO CARLOS FERREIRA SEVERIANO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '030.538.417-11')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '030.538.417-11';

  -- 327. ESTESIO RIBEIRO DANTES (Alunos 2)
  -- Email: esteiroribeiro@hotmail.com | CPF: 098.429.317-57 | Senha: Estesio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'esteiroribeiro@hotmail.com';
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
      'esteiroribeiro@hotmail.com',
      crypt('Estesio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ESTESIO RIBEIRO DANTES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '098.429.317-57')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '098.429.317-57';

  -- 328. ROGÉRIO MENEZES BATISTA (Alunos 2)
  -- Email: rogerioeletrica@gmail.com | CPF: 085.657.867-30 | Senha: Rogério
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'rogerioeletrica@gmail.com';
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
      'rogerioeletrica@gmail.com',
      crypt('Rogério', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ROGÉRIO MENEZES BATISTA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '085.657.867-30')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '085.657.867-30';

  -- 329. YURI DE SOUSA TELLES LOPES (Alunos 2)
  -- Email: yuridesousatelleslopes@gmail.com | CPF: 172.751.037-29 | Senha: Yuri
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'yuridesousatelleslopes@gmail.com';
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
      'yuridesousatelleslopes@gmail.com',
      crypt('Yuri', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "YURI DE SOUSA TELLES LOPES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '172.751.037-29')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '172.751.037-29';

  -- 330. RENATA DE SOUZA (Alunos 2)
  -- Email: souzarenata321@gmail.com | CPF: 084.173.797-54 | Senha: Renata
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'souzarenata321@gmail.com';
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
      'souzarenata321@gmail.com',
      crypt('Renata', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "RENATA DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '084.173.797-54')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '084.173.797-54';

  -- 331. ANDREIA DE SOUZA (Alunos 2)
  -- Email: andreiadesouza2376@gmail.com | CPF: 172.982.798-58 | Senha: Andreia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'andreiadesouza2376@gmail.com';
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
      'andreiadesouza2376@gmail.com',
      crypt('Andreia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANDREIA DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '172.982.798-58')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '172.982.798-58';

  -- 332. FERNANDA DOS SANTOS PACHECO (Alunos 2)
  -- Email: feeprince19@gmail.com | CPF: 170.784.017-27 | Senha: Fernanda
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'feeprince19@gmail.com';
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
      'feeprince19@gmail.com',
      crypt('Fernanda', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "FERNANDA DOS SANTOS PACHECO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '170.784.017-27')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '170.784.017-27';

  -- 333. LUIZ ANTONIO GONÇALVES DOS SANTOS (Alunos 2)
  -- Email: luiztimbauba82@gmail.com | CPF: 090.591.887-80 | Senha: Luiz
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'luiztimbauba82@gmail.com';
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
      'luiztimbauba82@gmail.com',
      crypt('Luiz', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LUIZ ANTONIO GONÇALVES DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '090.591.887-80')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '090.591.887-80';

  -- 334. MARCUS VINICIUS VILELA DE SOUZA (Alunos 2)
  -- Email: mvsouzapinturas3@gmail.com | CPF: 116.961.377-21 | Senha: Marcus
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'mvsouzapinturas3@gmail.com';
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
      'mvsouzapinturas3@gmail.com',
      crypt('Marcus', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCUS VINICIUS VILELA DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '116.961.377-21')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '116.961.377-21';

  -- 335. ROGERIO JOSE DA SILVA (Alunos 2)
  -- Email: rogerio.jose.silva@gmail.com | CPF: 92989195734 | Senha: Rogerio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'rogerio.jose.silva@gmail.com';
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
      'rogerio.jose.silva@gmail.com',
      crypt('Rogerio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ROGERIO JOSE DA SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '92989195734')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '92989195734';

  -- 336. TATIANA DA CONCEIÇÃO RODRIGUES (Alunos 2)
  -- Email: lindinhatatiana06@gmail.com | CPF: 106.413.387-83 | Senha: Tatiana
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lindinhatatiana06@gmail.com';
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
      'lindinhatatiana06@gmail.com',
      crypt('Tatiana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "TATIANA DA CONCEIÇÃO RODRIGUES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '106.413.387-83')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '106.413.387-83';

  -- 337. VIRGINIA DA SILVA JALES MONTEIRO (Alunos 2)
  -- Email: vvjales@gmail.com | CPF: 009.266.957-38 | Senha: Virginia
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'vvjales@gmail.com';
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
      'vvjales@gmail.com',
      crypt('Virginia', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "VIRGINIA DA SILVA JALES MONTEIRO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '009.266.957-38')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '009.266.957-38';

  -- 338. WELLINGTON AGUIAR DE OLIVEIRA (Alunos 2)
  -- Email: wellingtonwado160@gmail.com | CPF: 091.041.887-05 | Senha: Wellington
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'wellingtonwado160@gmail.com';
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
      'wellingtonwado160@gmail.com',
      crypt('Wellington', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "WELLINGTON AGUIAR DE OLIVEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '091.041.887-05')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '091.041.887-05';

  -- 339. BEATRIZ RIBEIRO PONTES ROCHA (Alunos 2)
  -- Email: biaribeiro@gmail.com | CPF: 125.106.057-98 | Senha: Beatriz
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'biaribeiro@gmail.com';
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
      'biaribeiro@gmail.com',
      crypt('Beatriz', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "BEATRIZ RIBEIRO PONTES ROCHA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '125.106.057-98')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '125.106.057-98';

  -- 340. JESSE PIRES ROCHA (Alunos 2)
  -- Email: jessepires12@gmail.com | CPF: 151.854.917-95 | Senha: Jesse
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'jessepires12@gmail.com';
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
      'jessepires12@gmail.com',
      crypt('Jesse', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JESSE PIRES ROCHA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '151.854.917-95')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '151.854.917-95';

  -- 341. PABLO RUAN FARIAS DE OLIVEIRA (Alunos 2)
  -- Email: pablorhuanbuffa@gmail.com | CPF: 158.431.467-23 | Senha: Pablo
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'pablorhuanbuffa@gmail.com';
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
      'pablorhuanbuffa@gmail.com',
      crypt('Pablo', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "PABLO RUAN FARIAS DE OLIVEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '158.431.467-23')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '158.431.467-23';

  -- 342. SANDRA FREITAS DE SOUZA (Alunos 2)
  -- Email: sanfreitas@gmail.com | CPF: 012.802.157-80 | Senha: Sandra
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'sanfreitas@gmail.com';
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
      'sanfreitas@gmail.com',
      crypt('Sandra', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SANDRA FREITAS DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '012.802.157-80')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '012.802.157-80';

  -- 343. JANE APARECIDA DA CUNHA DE SOUZA (Alunos 2)
  -- Email: jane.souza@portosrio.temp.br | CPF: 019.306.167-83 | Senha: Jane
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'jane.souza@portosrio.temp.br';
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
      'jane.souza@portosrio.temp.br',
      crypt('Jane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JANE APARECIDA DA CUNHA DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '019.306.167-83')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '019.306.167-83';

  -- 344. PRISCILLA DA CUNHA GAMA (Alunos 2)
  -- Email: priscilla.gama@portosrio.temp.br | CPF: 125.088.547-78 | Senha: Priscilla
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'priscilla.gama@portosrio.temp.br';
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
      'priscilla.gama@portosrio.temp.br',
      crypt('Priscilla', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "PRISCILLA DA CUNHA GAMA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '125.088.547-78')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '125.088.547-78';

  -- 345. SERGIO ALVES DE ALENCAR (Alunos 2)
  -- Email: sergio.alves.ceda@gmail.com | CPF: 585.588.967-04 | Senha: Sergio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'sergio.alves.ceda@gmail.com';
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
      'sergio.alves.ceda@gmail.com',
      crypt('Sergio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "SERGIO ALVES DE ALENCAR"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '585.588.967-04')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '585.588.967-04';

  -- 346. GEOVANI GRAVE DOS SANTOS (Alunos 2)
  -- Email: geeh.gravessem@gmail.com | CPF: 137.347.387-84 | Senha: Geovani
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'geeh.gravessem@gmail.com';
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
      'geeh.gravessem@gmail.com',
      crypt('Geovani', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GEOVANI GRAVE DOS SANTOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '137.347.387-84')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '137.347.387-84';

  -- 347. JENIFFER DO NASCIMENTO E SILVA (Alunos 2)
  -- Email: jeniffer.silvans@gmail.com | CPF: 172.430.277-92 | Senha: Jeniffer
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'jeniffer.silvans@gmail.com';
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
      'jeniffer.silvans@gmail.com',
      crypt('Jeniffer', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JENIFFER DO NASCIMENTO E SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '172.430.277-92')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '172.430.277-92';

  -- 348. VALDECIR MADEIRA (Alunos 2)
  -- Email: valdecir.madeira@portosrio.temp.br | CPF: 023.203.157-64 | Senha: Valdecir
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'valdecir.madeira@portosrio.temp.br';
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
      'valdecir.madeira@portosrio.temp.br',
      crypt('Valdecir', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "VALDECIR MADEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '023.203.157-64')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '023.203.157-64';

  -- 349. MARCIO DE OLIVEIRA SILVA BARROSO MUNIZ (Alunos 2)
  -- Email: marcio.muniz@portosrio.temp.br | CPF: 101.151.427-38 | Senha: Marcio
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'marcio.muniz@portosrio.temp.br';
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
      'marcio.muniz@portosrio.temp.br',
      crypt('Marcio', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARCIO DE OLIVEIRA SILVA BARROSO MUNIZ"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '101.151.427-38')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '101.151.427-38';

  -- 350. MATHEUS HENRIQUE DA CUNHA QUINTAL (Alunos 2)
  -- Email: matheus.quintal@portosrio.temp.br | CPF: 174.800.907-90 | Senha: Matheus
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'matheus.quintal@portosrio.temp.br';
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
      'matheus.quintal@portosrio.temp.br',
      crypt('Matheus', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MATHEUS HENRIQUE DA CUNHA QUINTAL"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '174.800.907-90')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '174.800.907-90';

  -- 351. LUCILENE LUCAS SILVA BARBOSA (Alunos 2)
  -- Email: lucilene.barbosa@portosrio.temp.br | CPF: 059.881.387-18 | Senha: Lucilene
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'lucilene.barbosa@portosrio.temp.br';
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
      'lucilene.barbosa@portosrio.temp.br',
      crypt('Lucilene', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LUCILENE LUCAS SILVA BARBOSA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '059.881.387-18')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '059.881.387-18';

  -- 352. LUANA LUCAS BARBOSA DOS PRAZERES (Alunos 2)
  -- Email: luana.prazeres@portosrio.temp.br | CPF: 132.057.647-81 | Senha: Luana
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'luana.prazeres@portosrio.temp.br';
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
      'luana.prazeres@portosrio.temp.br',
      crypt('Luana', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "LUANA LUCAS BARBOSA DOS PRAZERES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '132.057.647-81')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '132.057.647-81';

  -- 353. ANDRE LOHAN LUCAS VIEIRA (Alunos 2)
  -- Email: andrelohan777@icloud.com | CPF: 214.665.977-71 | Senha: Andre
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'andrelohan777@icloud.com';
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
      'andrelohan777@icloud.com',
      crypt('Andre', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ANDRE LOHAN LUCAS VIEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '214.665.977-71')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '214.665.977-71';

  -- 354. VICTOR GABRIEL FARIA DE MORAES (Alunos 2)
  -- Email: victor.moraes@portosrio.temp.br | CPF: 163.747.047-97 | Senha: Victor
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'victor.moraes@portosrio.temp.br';
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
      'victor.moraes@portosrio.temp.br',
      crypt('Victor', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "VICTOR GABRIEL FARIA DE MORAES"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '163.747.047-97')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '163.747.047-97';

  -- 355. MARA CRISTINA LOPES DA COSTA (Alunos 2)
  -- Email: maracriatinalaura@gmail.com | CPF: 023.234.547-30 | Senha: Mara
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'maracriatinalaura@gmail.com';
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
      'maracriatinalaura@gmail.com',
      crypt('Mara', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "MARA CRISTINA LOPES DA COSTA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '023.234.547-30')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '023.234.547-30';

  -- 356. CRISTIANE PEIXOTO DE CARVALHO (Alunos 2)
  -- Email: cris.kadupeixoto@gmail.com | CPF: 112.998.467-26 | Senha: Cristiane
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'cris.kadupeixoto@gmail.com';
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
      'cris.kadupeixoto@gmail.com',
      crypt('Cristiane', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CRISTIANE PEIXOTO DE CARVALHO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '112.998.467-26')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '112.998.467-26';

  -- 357. DANIELLE DIAS RAMOS (Alunos 2)
  -- Email: danielleramosdp@gmail.com | CPF: 091.078.377-20 | Senha: Danielle
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'danielleramosdp@gmail.com';
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
      'danielleramosdp@gmail.com',
      crypt('Danielle', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "DANIELLE DIAS RAMOS"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '091.078.377-20')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '091.078.377-20';

  -- 358. CARLOS JOSE RODRIGUES DE SOUZA (Alunos 2)
  -- Email: calosjose@gmail.com | CPF: 807.842.677-15 | Senha: Carlos
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'calosjose@gmail.com';
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
      'calosjose@gmail.com',
      crypt('Carlos', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "CARLOS JOSE RODRIGUES DE SOUZA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '807.842.677-15')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '807.842.677-15';

  -- 359. GRESY RENNER CAETANO FERREIRA (Alunos 2)
  -- Email: gressyrenner23@gmail.com | CPF: 084.141.647-81 | Senha: Gresy
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'gressyrenner23@gmail.com';
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
      'gressyrenner23@gmail.com',
      crypt('Gresy', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "GRESY RENNER CAETANO FERREIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '084.141.647-81')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '084.141.647-81';

  -- 360. FATIMA NASCIMENTO DE AZEVEDO (Alunos 2)
  -- Email: fatima.azevedo@portosrio.temp.br | CPF: 033.595.607-60 | Senha: Fatima
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'fatima.azevedo@portosrio.temp.br';
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
      'fatima.azevedo@portosrio.temp.br',
      crypt('Fatima', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "FATIMA NASCIMENTO DE AZEVEDO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '033.595.607-60')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '033.595.607-60';

  -- 361. EVERTON DA CONCEIÇÃO SILVA (Alunos 2)
  -- Email: everton.silva@portosrio.temp.br | CPF: 173.539.667-26 | Senha: Everton
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'everton.silva@portosrio.temp.br';
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
      'everton.silva@portosrio.temp.br',
      crypt('Everton', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "EVERTON DA CONCEIÇÃO SILVA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '173.539.667-26')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '173.539.667-26';

  -- 362. ALEXANDER PAGNIEZ KAUTSCHER CAMARGO (Alunos 2)
  -- Email: alexpagniez@gmail.com | CPF: 033.686.567-83 | Senha: Alexander
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'alexpagniez@gmail.com';
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
      'alexpagniez@gmail.com',
      crypt('Alexander', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "ALEXANDER PAGNIEZ KAUTSCHER CAMARGO"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '033.686.567-83')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '033.686.567-83';

  -- 363. TAISE FERNANDES CAVALLIERI VIEIRA (Alunos 2)
  -- Email: taise.cavallieri@gmail.com | CPF: 672.827.097-34 | Senha: Taise
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'taise.cavallieri@gmail.com';
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
      'taise.cavallieri@gmail.com',
      crypt('Taise', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "TAISE FERNANDES CAVALLIERI VIEIRA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '672.827.097-34')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '672.827.097-34';

  -- 364. JOSÉ LUIS SIQUEIRA DE FARIA (Alunos 2)
  -- Email: josefaria332@gmail.com | CPF: 680.939.267-04 | Senha: José
  SELECT id INTO new_user_id FROM auth.users WHERE email = 'josefaria332@gmail.com';
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
      'josefaria332@gmail.com',
      crypt('José', gen_salt('bf')),
      NOW(),
      '{"provider": "email", "providers": ["email"]}',
      '{"full_name": "JOSÉ LUIS SIQUEIRA DE FARIA"}',
      NOW(),
      NOW(),
      '', '', '', ''
    ) RETURNING id INTO new_user_id;
  END IF;
  INSERT INTO public.user_roles (user_id, role, cpf)
  VALUES (new_user_id, 'user', '680.939.267-04')
  ON CONFLICT (user_id) DO UPDATE SET cpf = '680.939.267-04';

  -- Criar registros de identidade para todos os novos usuários
  INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
  SELECT
    gen_random_uuid(),
    u.id,
    json_build_object('sub', u.id::text, 'email', u.email, 'full_name', u.raw_user_meta_data ->> 'full_name')::jsonb,
    'email',
    u.id::text,
    NOW(),
    NOW(),
    NOW()
  FROM auth.users u
  WHERE NOT EXISTS (
    SELECT 1 FROM auth.identities i WHERE i.user_id = u.id AND i.provider = 'email'
  );

END $$;

-- ============================================
-- VERIFICAÇÃO
-- ============================================
-- Total de usuários cadastrados:
-- SELECT COUNT(*) FROM auth.users;
--
-- Listar todos os alunos com CPF:
-- SELECT u.email, u.raw_user_meta_data ->> 'full_name' AS nome, ur.cpf, ur.role
-- FROM auth.users u
-- JOIN public.user_roles ur ON ur.user_id = u.id
-- ORDER BY u.email;
--
-- Alunos com email temporário:
-- SELECT u.email, u.raw_user_meta_data ->> 'full_name' AS nome
-- FROM auth.users u
-- WHERE u.email LIKE '%@portosrio.temp.br';