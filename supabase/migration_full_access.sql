-- ============================================================================
-- Migração: Acesso total (bypass do bloqueio sequencial de disciplinas)
-- ============================================================================
-- Adiciona o campo full_access em user_roles.
--
-- Regra normal (inalterada): o aluno só desbloqueia a próxima disciplina
-- depois de concluir todas as aulas, os quizzes de aula e o quiz final da
-- disciplina atual. O mesmo vale para a ordem das aulas dentro da disciplina.
--
-- Com full_access = TRUE o usuário enxerga e acessa todas as disciplinas,
-- todas as aulas e todos os quizzes finais desde o início, sem precisar
-- completar nada. Destinado a coordenadores que avaliam o conteúdo.
--
-- Padrão: FALSE para todo mundo. Conceder caso a caso (ver passo 3).
-- ============================================================================

-- 1. Coluna em user_roles
ALTER TABLE user_roles
  ADD COLUMN IF NOT EXISTS full_access BOOLEAN NOT NULL DEFAULT FALSE;

-- 2. Função para o próprio usuário ler sua flag
CREATE OR REPLACE FUNCTION get_my_full_access()
RETURNS BOOLEAN AS $$
DECLARE
  flag BOOLEAN;
BEGIN
  SELECT full_access INTO flag
  FROM user_roles
  WHERE user_id = auth.uid();

  RETURN COALESCE(flag, FALSE);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Função de admin para conceder/revogar acesso total
CREATE OR REPLACE FUNCTION set_user_full_access(
  p_user_id UUID,
  p_full_access BOOLEAN
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Acesso negado: apenas administradores podem conceder acesso total';
  END IF;

  INSERT INTO user_roles (user_id, role, full_access)
  VALUES (p_user_id, 'user', p_full_access)
  ON CONFLICT (user_id)
  DO UPDATE SET full_access = EXCLUDED.full_access;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. Incluir full_access na listagem de usuários do admin
DROP FUNCTION IF EXISTS get_platform_users();
CREATE OR REPLACE FUNCTION get_platform_users()
RETURNS TABLE (
  id UUID,
  email TEXT,
  full_name TEXT,
  created_at TIMESTAMPTZ,
  last_sign_in_at TIMESTAMPTZ,
  role TEXT,
  access_level TEXT,
  full_access BOOLEAN
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
    COALESCE(r.access_level::TEXT, 'basico') AS access_level,
    COALESCE(r.full_access, FALSE) AS full_access
  FROM auth.users u
  LEFT JOIN user_roles r ON r.user_id = u.id
  ORDER BY u.created_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
