-- ============================================
-- MIGRATION: Permitir que admin exclua posts e respostas do fórum
-- ============================================
-- Execute este SQL no SQL Editor do Supabase
-- (Dashboard > SQL Editor > New query)
--
-- Pré-requisitos:
--   - migration_forum.sql       (cria forum_posts / forum_replies)
--   - migration_admin_roles.sql (cria a função is_admin())
-- ============================================

-- Forum Posts: admin pode deletar qualquer post
DROP POLICY IF EXISTS "Admin can delete any forum post" ON forum_posts;
CREATE POLICY "Admin can delete any forum post"
  ON forum_posts FOR DELETE
  TO authenticated
  USING (is_admin());

-- Forum Replies: admin pode deletar qualquer resposta
DROP POLICY IF EXISTS "Admin can delete any forum reply" ON forum_replies;
CREATE POLICY "Admin can delete any forum reply"
  ON forum_replies FOR DELETE
  TO authenticated
  USING (is_admin());
