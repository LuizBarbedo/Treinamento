-- ============================================
-- MIGRATION: Quiz por aula + Quiz geral da disciplina
-- Execute no SQL Editor do Supabase
-- ============================================

-- 1. Adicionar lesson_id à tabela quiz_questions
-- Perguntas com lesson_id = quiz da aula (3 perguntas)
-- Perguntas sem lesson_id (NULL) = quiz geral da disciplina (10 perguntas)
ALTER TABLE quiz_questions ADD COLUMN IF NOT EXISTS lesson_id UUID REFERENCES lessons(id) ON DELETE CASCADE;

-- 2. Tabela de resultados do quiz por aula
CREATE TABLE IF NOT EXISTS lesson_quiz_results (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  lesson_id UUID REFERENCES lessons(id) ON DELETE CASCADE,
  discipline_id UUID REFERENCES disciplines(id) ON DELETE CASCADE,
  score INTEGER NOT NULL,
  total_questions INTEGER NOT NULL,
  correct_answers INTEGER NOT NULL,
  passed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, lesson_id)
);

-- Habilitar RLS
ALTER TABLE lesson_quiz_results ENABLE ROW LEVEL SECURITY;

-- Políticas: usuário só vê/edita os seus próprios resultados
CREATE POLICY "Users can read own lesson quiz results"
  ON lesson_quiz_results FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own lesson quiz results"
  ON lesson_quiz_results FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own lesson quiz results"
  ON lesson_quiz_results FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- ============================================
-- EXEMPLO: Quiz por aula (3 perguntas cada)
-- ============================================
-- Para adicionar perguntas a uma aula específica:
--
-- INSERT INTO quiz_questions (discipline_id, lesson_id, question, options, correct_option, order_index)
-- SELECT d.id, l.id,
--   'Qual é o conceito principal desta aula?',
--   '["Opção A", "Opção B", "Opção C", "Opção D"]',
--   0, 1
-- FROM disciplines d
-- JOIN lessons l ON l.discipline_id = d.id
-- WHERE d.name = 'Nome da Disciplina'
-- AND l.title = 'Título da Aula';
--
-- Para o quiz geral da disciplina (10 perguntas), insira SEM lesson_id:
--
-- INSERT INTO quiz_questions (discipline_id, question, options, correct_option, order_index)
-- VALUES ('discipline-uuid', 'Pergunta?', '["A","B","C","D"]', 0, 1);
