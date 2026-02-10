-- ============================================
-- MIGRATION: Relatórios Admin (Visão Master)
-- ============================================
-- Execute este SQL no SQL Editor do Supabase
-- APÓS ter executado as migrations anteriores
-- ============================================

-- 1. Políticas para Admin ler TODOS os dados de progresso/resultados
-- (Necessário para o relatório geral de usuários)

-- Admin pode ler todo o progresso de usuários
CREATE POLICY "Admin can read all user progress"
  ON user_progress FOR SELECT
  TO authenticated
  USING (is_admin());

-- Admin pode ler todos os resultados de quiz
CREATE POLICY "Admin can read all quiz results"
  ON quiz_results FOR SELECT
  TO authenticated
  USING (is_admin());

-- Admin pode ler todos os resultados de quiz por aula
CREATE POLICY "Admin can read all lesson quiz results"
  ON lesson_quiz_results FOR SELECT
  TO authenticated
  USING (is_admin());

-- Admin pode ler todo o progresso de aulas
CREATE POLICY "Admin can read all lesson progress"
  ON lesson_progress FOR SELECT
  TO authenticated
  USING (is_admin());

-- 2. Função segura para obter lista de usuários (somente admin)
-- Retorna dados básicos dos usuários da plataforma
CREATE OR REPLACE FUNCTION get_platform_users()
RETURNS TABLE (
  id UUID,
  email TEXT,
  full_name TEXT,
  created_at TIMESTAMPTZ,
  last_sign_in_at TIMESTAMPTZ
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
    u.last_sign_in_at
  FROM auth.users u
  ORDER BY u.created_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Função para obter estatísticas gerais da plataforma (somente admin)
CREATE OR REPLACE FUNCTION get_platform_stats()
RETURNS JSON AS $$
DECLARE
  result JSON;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Acesso negado: apenas administradores podem acessar esta função';
  END IF;

  SELECT json_build_object(
    'total_users', (SELECT COUNT(*) FROM auth.users),
    'total_disciplines', (SELECT COUNT(*) FROM disciplines),
    'total_lessons', (SELECT COUNT(*) FROM lessons),
    'total_quiz_questions', (SELECT COUNT(*) FROM quiz_questions),
    'completed_disciplines', (SELECT COUNT(*) FROM user_progress WHERE completed = true),
    'quiz_attempts', (SELECT COUNT(*) FROM quiz_results),
    'lesson_quiz_attempts', (SELECT COUNT(*) FROM lesson_quiz_results),
    'avg_quiz_score', (SELECT COALESCE(ROUND(AVG(score)::numeric, 1), 0) FROM quiz_results),
    'avg_lesson_quiz_score', (SELECT COALESCE(ROUND(AVG(score)::numeric, 1), 0) FROM lesson_quiz_results)
  ) INTO result;

  RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
