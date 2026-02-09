-- ============================================
-- MIGRATION: Tabela de progresso por aula
-- Execute no SQL Editor do Supabase
-- ============================================

-- Tabela para rastrear quais aulas o aluno completou
CREATE TABLE IF NOT EXISTS lesson_progress (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  lesson_id UUID REFERENCES lessons(id) ON DELETE CASCADE,
  discipline_id UUID REFERENCES disciplines(id) ON DELETE CASCADE,
  completed_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, lesson_id)
);

-- Habilitar RLS
ALTER TABLE lesson_progress ENABLE ROW LEVEL SECURITY;

-- Políticas: usuário só vê/edita o seu próprio progresso
CREATE POLICY "Users can read own lesson progress"
  ON lesson_progress FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own lesson progress"
  ON lesson_progress FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own lesson progress"
  ON lesson_progress FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);
