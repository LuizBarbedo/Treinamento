-- ============================================
-- MIGRATION: Sistema de Monitores e Dúvidas
-- ============================================
-- Execute este SQL no SQL Editor do Supabase
-- APÓS ter executado as migrations anteriores
-- ============================================

-- ============================================
-- 1. Atualizar user_roles para suportar 'monitor'
-- ============================================

-- Remover constraint antiga e adicionar nova com 'monitor'
ALTER TABLE user_roles DROP CONSTRAINT IF EXISTS user_roles_role_check;
ALTER TABLE user_roles ADD CONSTRAINT user_roles_role_check CHECK (role IN ('admin', 'monitor', 'user'));

-- Atualizar a função is_admin (sem alteração, monitores NÃO são admin)
-- A is_admin() existente já está correta - só reconhece 'admin'

-- 2. Função helper para verificar se o usuário é monitor
CREATE OR REPLACE FUNCTION is_monitor()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_roles
    WHERE user_id = auth.uid() AND role = 'monitor'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Função helper para verificar se é admin ou monitor
CREATE OR REPLACE FUNCTION is_admin_or_monitor()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN is_admin() OR is_monitor();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 4. Tabela de vínculo Monitor -> Alunos
-- ============================================
CREATE TABLE IF NOT EXISTS monitor_students (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  monitor_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  student_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  assigned_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(monitor_id, student_id)
);

ALTER TABLE monitor_students ENABLE ROW LEVEL SECURITY;

-- Monitor pode ver seus próprios vínculos
CREATE POLICY "Monitor can read own assignments"
  ON monitor_students FOR SELECT
  TO authenticated
  USING (auth.uid() = monitor_id);

-- Aluno pode ver quem é seu monitor
CREATE POLICY "Student can read own monitor"
  ON monitor_students FOR SELECT
  TO authenticated
  USING (auth.uid() = student_id);

-- Admin gerencia todos os vínculos
CREATE POLICY "Admin can manage all monitor assignments"
  ON monitor_students FOR ALL
  TO authenticated
  USING (is_admin());

-- ============================================
-- 5. Tabela de Dúvidas
-- ============================================
CREATE TABLE IF NOT EXISTS doubts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  discipline_id UUID REFERENCES disciplines(id) ON DELETE CASCADE,
  lesson_id UUID REFERENCES lessons(id) ON DELETE SET NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'answered', 'resolved')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE doubts ENABLE ROW LEVEL SECURITY;

-- Aluno vê suas próprias dúvidas
CREATE POLICY "Users can read own doubts"
  ON doubts FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- Aluno pode criar dúvidas
CREATE POLICY "Users can insert own doubts"
  ON doubts FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Aluno pode atualizar suas dúvidas (ex: marcar como resolvida)
CREATE POLICY "Users can update own doubts"
  ON doubts FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- Monitor pode ler dúvidas dos seus alunos
CREATE POLICY "Monitor can read student doubts"
  ON doubts FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM monitor_students ms
      WHERE ms.monitor_id = auth.uid()
      AND ms.student_id = doubts.user_id
    )
  );

-- Monitor pode atualizar dúvidas dos seus alunos (mudar status)
CREATE POLICY "Monitor can update student doubts"
  ON doubts FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM monitor_students ms
      WHERE ms.monitor_id = auth.uid()
      AND ms.student_id = doubts.user_id
    )
  );

-- Admin pode ver todas as dúvidas
CREATE POLICY "Admin can read all doubts"
  ON doubts FOR ALL
  TO authenticated
  USING (is_admin());

-- ============================================
-- 6. Tabela de Respostas das Dúvidas
-- ============================================
CREATE TABLE IF NOT EXISTS doubt_replies (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  doubt_id UUID REFERENCES doubts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE doubt_replies ENABLE ROW LEVEL SECURITY;

-- Aluno pode ler respostas das suas dúvidas
CREATE POLICY "Users can read replies on own doubts"
  ON doubt_replies FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM doubts d
      WHERE d.id = doubt_replies.doubt_id
      AND d.user_id = auth.uid()
    )
  );

-- Aluno pode responder nas suas dúvidas
CREATE POLICY "Users can reply on own doubts"
  ON doubt_replies FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id
    AND EXISTS (
      SELECT 1 FROM doubts d
      WHERE d.id = doubt_replies.doubt_id
      AND d.user_id = auth.uid()
    )
  );

-- Monitor pode ler respostas das dúvidas dos seus alunos
CREATE POLICY "Monitor can read student doubt replies"
  ON doubt_replies FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM doubts d
      JOIN monitor_students ms ON ms.student_id = d.user_id
      WHERE d.id = doubt_replies.doubt_id
      AND ms.monitor_id = auth.uid()
    )
  );

-- Monitor pode responder nas dúvidas dos seus alunos
CREATE POLICY "Monitor can reply on student doubts"
  ON doubt_replies FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id
    AND EXISTS (
      SELECT 1 FROM doubts d
      JOIN monitor_students ms ON ms.student_id = d.user_id
      WHERE d.id = doubt_replies.doubt_id
      AND ms.monitor_id = auth.uid()
    )
  );

-- Admin pode gerenciar todas as respostas
CREATE POLICY "Admin can manage all doubt replies"
  ON doubt_replies FOR ALL
  TO authenticated
  USING (is_admin());

-- ============================================
-- 7. Políticas para Monitor ler dados dos seus alunos
-- ============================================

-- Monitor pode ler progresso dos seus alunos
CREATE POLICY "Monitor can read student progress"
  ON user_progress FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM monitor_students ms
      WHERE ms.monitor_id = auth.uid()
      AND ms.student_id = user_progress.user_id
    )
  );

-- Monitor pode ler resultados de quiz dos seus alunos
CREATE POLICY "Monitor can read student quiz results"
  ON quiz_results FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM monitor_students ms
      WHERE ms.monitor_id = auth.uid()
      AND ms.student_id = quiz_results.user_id
    )
  );

-- Monitor pode ler resultados de quiz por aula dos seus alunos
CREATE POLICY "Monitor can read student lesson quiz results"
  ON lesson_quiz_results FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM monitor_students ms
      WHERE ms.monitor_id = auth.uid()
      AND ms.student_id = lesson_quiz_results.user_id
    )
  );

-- Monitor pode ler progresso de aulas dos seus alunos
CREATE POLICY "Monitor can read student lesson progress"
  ON lesson_progress FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM monitor_students ms
      WHERE ms.monitor_id = auth.uid()
      AND ms.student_id = lesson_progress.user_id
    )
  );

-- ============================================
-- 8. Função para o monitor obter seus alunos com dados básicos
-- ============================================
CREATE OR REPLACE FUNCTION get_monitor_students(p_monitor_id UUID)
RETURNS TABLE (
  id UUID,
  email TEXT,
  full_name TEXT,
  created_at TIMESTAMPTZ,
  last_sign_in_at TIMESTAMPTZ,
  assigned_at TIMESTAMPTZ
) AS $$
BEGIN
  -- Verifica se é admin ou se é o próprio monitor
  IF NOT (is_admin() OR auth.uid() = p_monitor_id) THEN
    RAISE EXCEPTION 'Acesso negado';
  END IF;

  -- Verifica se o usuário é monitor (se não for admin)
  IF NOT is_admin() AND NOT EXISTS (
    SELECT 1 FROM user_roles WHERE user_id = p_monitor_id AND role = 'monitor'
  ) THEN
    RAISE EXCEPTION 'Usuário não é monitor';
  END IF;

  RETURN QUERY
  SELECT
    u.id,
    u.email::TEXT,
    COALESCE(u.raw_user_meta_data ->> 'full_name', u.email::TEXT)::TEXT AS full_name,
    u.created_at,
    u.last_sign_in_at,
    ms.assigned_at
  FROM auth.users u
  JOIN monitor_students ms ON ms.student_id = u.id
  WHERE ms.monitor_id = p_monitor_id
  ORDER BY u.raw_user_meta_data ->> 'full_name', u.email;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 9. Função para admin obter lista de monitores
-- ============================================
CREATE OR REPLACE FUNCTION get_monitors()
RETURNS TABLE (
  id UUID,
  email TEXT,
  full_name TEXT,
  student_count BIGINT
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
    COUNT(ms.student_id) AS student_count
  FROM auth.users u
  JOIN user_roles ur ON ur.user_id = u.id AND ur.role = 'monitor'
  LEFT JOIN monitor_students ms ON ms.monitor_id = u.id
  GROUP BY u.id, u.email, u.raw_user_meta_data
  ORDER BY full_name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 10. Função para obter usuários que não são admin nem monitor (alunos disponíveis)
-- ============================================
CREATE OR REPLACE FUNCTION get_available_students()
RETURNS TABLE (
  id UUID,
  email TEXT,
  full_name TEXT
) AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Acesso negado';
  END IF;

  RETURN QUERY
  SELECT
    u.id,
    u.email::TEXT,
    COALESCE(u.raw_user_meta_data ->> 'full_name', u.email::TEXT)::TEXT AS full_name
  FROM auth.users u
  WHERE NOT EXISTS (
    SELECT 1 FROM user_roles ur
    WHERE ur.user_id = u.id AND ur.role IN ('admin', 'monitor')
  )
  AND u.email != 'aplicacao.treinamento@gmail.com'
  ORDER BY full_name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 11. Função para obter a contagem de dúvidas pendentes do monitor
-- ============================================
CREATE OR REPLACE FUNCTION get_monitor_pending_doubts_count(p_monitor_id UUID)
RETURNS INTEGER AS $$
DECLARE
  count_result INTEGER;
BEGIN
  SELECT COUNT(*)::INTEGER INTO count_result
  FROM doubts d
  JOIN monitor_students ms ON ms.student_id = d.user_id
  WHERE ms.monitor_id = p_monitor_id
  AND d.status = 'open';

  RETURN count_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 12. Trigger para atualizar updated_at nas dúvidas
-- ============================================
CREATE OR REPLACE FUNCTION update_doubt_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_doubt_updated_at
  BEFORE UPDATE ON doubts
  FOR EACH ROW
  EXECUTE FUNCTION update_doubt_updated_at();

-- ============================================
-- 13. Tabela de código de acesso para monitores
-- ============================================
CREATE TABLE IF NOT EXISTS monitor_access_codes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  code TEXT NOT NULL UNIQUE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE monitor_access_codes ENABLE ROW LEVEL SECURITY;

-- Somente admin pode gerenciar códigos
CREATE POLICY "Admin can manage monitor access codes"
  ON monitor_access_codes FOR ALL
  TO authenticated
  USING (is_admin());

-- Inserir um código padrão (o admin pode alterar depois)
INSERT INTO monitor_access_codes (code, is_active)
VALUES ('MONITOR2026', TRUE)
ON CONFLICT (code) DO NOTHING;

-- ============================================
-- 14. Função para monitor se auto-cadastrar com código de acesso
-- ============================================
CREATE OR REPLACE FUNCTION claim_monitor_role(p_access_code TEXT)
RETURNS JSON AS $$
DECLARE
  valid_code BOOLEAN;
BEGIN
  -- Verifica se o código é válido e ativo
  SELECT EXISTS (
    SELECT 1 FROM monitor_access_codes
    WHERE code = p_access_code AND is_active = TRUE
  ) INTO valid_code;

  IF NOT valid_code THEN
    RETURN json_build_object('success', FALSE, 'message', 'Código de acesso inválido.');
  END IF;

  -- Verifica se o usuário já tem uma role
  IF EXISTS (SELECT 1 FROM user_roles WHERE user_id = auth.uid()) THEN
    -- Atualiza para monitor
    UPDATE user_roles SET role = 'monitor' WHERE user_id = auth.uid();
  ELSE
    -- Insere como monitor
    INSERT INTO user_roles (user_id, role) VALUES (auth.uid(), 'monitor');
  END IF;

  RETURN json_build_object('success', TRUE, 'message', 'Cadastrado como monitor com sucesso!');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
