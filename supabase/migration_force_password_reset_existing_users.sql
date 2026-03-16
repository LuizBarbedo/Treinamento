-- ============================================
-- MIGRATION: Forçar redefinição de senha para usuários existentes
-- ============================================
-- Objetivo:
-- Marcar todos os usuários já cadastrados para que precisem
-- redefinir a senha no próximo login.
--
-- Como funciona no app:
-- A aplicação verifica user_metadata.must_reset_password.
-- Se true, redireciona o usuário para /redefinir-senha.
--
-- Execute este SQL no SQL Editor do Supabase.
-- ============================================

UPDATE auth.users
SET raw_user_meta_data = jsonb_set(
  COALESCE(raw_user_meta_data, '{}'::jsonb),
  '{must_reset_password}',
  'true'::jsonb,
  true
),
updated_at = NOW()
WHERE COALESCE((raw_user_meta_data ->> 'must_reset_password')::boolean, false) = false;

-- ============================================
-- VERIFICAÇÃO
-- ============================================
-- Quantos usuários ficaram marcados para redefinição:
-- SELECT COUNT(*) AS users_marked_to_reset
-- FROM auth.users
-- WHERE COALESCE((raw_user_meta_data ->> 'must_reset_password')::boolean, false) = true;

-- Listagem para conferência:
-- SELECT
--   email,
--   COALESCE((raw_user_meta_data ->> 'must_reset_password')::boolean, false) AS must_reset_password,
--   updated_at
-- FROM auth.users
-- ORDER BY email;
