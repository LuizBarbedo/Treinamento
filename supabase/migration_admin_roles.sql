-- ============================================
-- MIGRATION: Sistema de Roles (Admin/User)
-- ============================================
-- Execute este SQL no SQL Editor do Supabase
-- APÓS ter executado o schema.sql principal
-- ============================================

-- 1. Tabela de Roles de Usuário
CREATE TABLE IF NOT EXISTS user_roles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
  role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('admin', 'user')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;

-- 2. Função helper para verificar se o usuário é admin
--    Verifica o email do master admin OU a role na tabela user_roles
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN (
    (auth.jwt() ->> 'email') = 'aplicacao.treinamento@gmail.com'
    OR EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_id = auth.uid() AND role = 'admin'
    )
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Políticas de leitura para user_roles
CREATE POLICY "Users can read own role"
  ON user_roles FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Admin can read all roles"
  ON user_roles FOR SELECT
  TO authenticated
  USING (is_admin());

CREATE POLICY "Admin can manage roles"
  ON user_roles FOR ALL
  TO authenticated
  USING (is_admin());

-- 4. Se o usuário master já existe, inserir role admin agora
-- (Se ele ainda não existir, a função is_admin() já reconhece pelo email)
INSERT INTO public.user_roles (user_id, role)
SELECT id, 'admin' FROM auth.users WHERE email = 'aplicacao.treinamento@gmail.com'
ON CONFLICT (user_id) DO UPDATE SET role = 'admin';

-- ============================================
-- POLÍTICAS DE ADMIN PARA GERENCIAR CONTEÚDO
-- ============================================

-- DISCIPLINAS: Admin pode INSERT, UPDATE, DELETE
CREATE POLICY "Admin can insert disciplines"
  ON disciplines FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "Admin can update disciplines"
  ON disciplines FOR UPDATE
  TO authenticated
  USING (is_admin());

CREATE POLICY "Admin can delete disciplines"
  ON disciplines FOR DELETE
  TO authenticated
  USING (is_admin());

-- AULAS: Admin pode INSERT, UPDATE, DELETE
CREATE POLICY "Admin can insert lessons"
  ON lessons FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "Admin can update lessons"
  ON lessons FOR UPDATE
  TO authenticated
  USING (is_admin());

CREATE POLICY "Admin can delete lessons"
  ON lessons FOR DELETE
  TO authenticated
  USING (is_admin());

-- MATERIAIS: Admin pode INSERT, UPDATE, DELETE
CREATE POLICY "Admin can insert materials"
  ON materials FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "Admin can update materials"
  ON materials FOR UPDATE
  TO authenticated
  USING (is_admin());

CREATE POLICY "Admin can delete materials"
  ON materials FOR DELETE
  TO authenticated
  USING (is_admin());

-- QUESTÕES DO QUIZ: Admin pode INSERT, UPDATE, DELETE
CREATE POLICY "Admin can insert quiz_questions"
  ON quiz_questions FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "Admin can update quiz_questions"
  ON quiz_questions FOR UPDATE
  TO authenticated
  USING (is_admin());

CREATE POLICY "Admin can delete quiz_questions"
  ON quiz_questions FOR DELETE
  TO authenticated
  USING (is_admin());
