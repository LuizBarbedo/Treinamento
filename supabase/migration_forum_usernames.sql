-- ============================================
-- MIGRATION: Função para buscar nomes de usuários no fórum
-- ============================================
-- Execute este SQL no SQL Editor do Supabase
-- (Dashboard > SQL Editor > New query)
-- ============================================

-- Função que retorna nomes de usuários a partir de seus IDs
-- Qualquer usuário autenticado pode chamar (apenas expõe nomes)
CREATE OR REPLACE FUNCTION get_user_names(p_user_ids UUID[])
RETURNS TABLE (
  user_id UUID,
  full_name TEXT
) AS $$
BEGIN
  -- Apenas usuários autenticados
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Não autenticado';
  END IF;

  RETURN QUERY
  SELECT
    u.id AS user_id,
    COALESCE(u.raw_user_meta_data ->> 'full_name', u.email::TEXT)::TEXT AS full_name
  FROM auth.users u
  WHERE u.id = ANY(p_user_ids);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
