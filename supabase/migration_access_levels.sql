-- ============================================================================
-- Migração: Níveis de acesso (Básico / Intermediário / Avançado)
-- ============================================================================
-- Adiciona o campo access_level em user_roles e expõe o valor via RPC.
--
-- Regras de conteúdo por nível:
--   basico         -> vídeos, apostila, quiz, fórum
--   intermediario  -> tudo do básico + atividade de reflexão
--   avancado       -> tudo do intermediário + artigo e texto técnico
--
-- Padrão: todos os usuários iniciam em 'basico'. O admin pode alterar depois.
-- ============================================================================

-- 1. Tipo enumerado
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'access_level_enum') THEN
    CREATE TYPE access_level_enum AS ENUM ('basico', 'intermediario', 'avancado');
  END IF;
END$$;

-- 2. Coluna em user_roles (default basico)
ALTER TABLE user_roles
  ADD COLUMN IF NOT EXISTS access_level access_level_enum NOT NULL DEFAULT 'basico';

-- 3. Garantir que todos os usuários existentes tenham uma linha em user_roles
--    com access_level = 'basico'. Usuários sem linha continuam default ao ler.
INSERT INTO user_roles (user_id, role, access_level)
SELECT u.id, 'user', 'basico'
FROM auth.users u
LEFT JOIN user_roles r ON r.user_id = u.id
WHERE r.user_id IS NULL
ON CONFLICT (user_id) DO NOTHING;

-- 4. Função para o próprio usuário ler seu nível de acesso
CREATE OR REPLACE FUNCTION get_my_access_level()
RETURNS TEXT AS $$
DECLARE
  lvl TEXT;
BEGIN
  SELECT access_level::TEXT INTO lvl
  FROM user_roles
  WHERE user_id = auth.uid();

  RETURN COALESCE(lvl, 'basico');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Função de admin para atualizar o nível de um usuário
CREATE OR REPLACE FUNCTION set_user_access_level(
  p_user_id UUID,
  p_access_level TEXT
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Acesso negado: apenas administradores podem alterar níveis de acesso';
  END IF;

  IF p_access_level NOT IN ('basico', 'intermediario', 'avancado') THEN
    RAISE EXCEPTION 'Nível de acesso inválido: %', p_access_level;
  END IF;

  INSERT INTO user_roles (user_id, role, access_level)
  VALUES (p_user_id, 'user', p_access_level::access_level_enum)
  ON CONFLICT (user_id)
  DO UPDATE SET access_level = EXCLUDED.access_level;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 6. Atualizar get_platform_users para incluir role e access_level
DROP FUNCTION IF EXISTS get_platform_users();
CREATE OR REPLACE FUNCTION get_platform_users()
RETURNS TABLE (
  id UUID,
  email TEXT,
  full_name TEXT,
  created_at TIMESTAMPTZ,
  last_sign_in_at TIMESTAMPTZ,
  role TEXT,
  access_level TEXT
) AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Acesso negado: apenas administradores podem acessar esta função';
  END IF;

  RETURN QUERY
  SELECT
    u.id,
    u.email::TEXT,
    COALESCE(u.raw_user_meta_data ->> 'full_name', u.email::TEXT)::TEXT AS full_name,
    u.created_at,
    u.last_sign_in_at,
    COALESCE(r.role, 'user')::TEXT AS role,
    COALESCE(r.access_level::TEXT, 'basico') AS access_level
  FROM auth.users u
  LEFT JOIN user_roles r ON r.user_id = u.id
  ORDER BY u.created_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
