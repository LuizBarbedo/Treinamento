-- ============================================
-- SCHEMA DO SUPABASE - Plataforma de Treinamento
-- ============================================
-- Execute este SQL no SQL Editor do Supabase
-- (Dashboard > SQL Editor > New query)
-- ============================================

-- 1. Tabela de Disciplinas
CREATE TABLE disciplines (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  icon TEXT DEFAULT '📚',
  order_index INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Tabela de Aulas (vídeos)
CREATE TABLE lessons (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  discipline_id UUID REFERENCES disciplines(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  video_url TEXT,
  order_index INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Tabela de Materiais (livros, artigos, PDFs)
CREATE TABLE materials (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  discipline_id UUID REFERENCES disciplines(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  type TEXT DEFAULT 'link',  -- 'livro', 'artigo', 'pdf', 'link'
  url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Tabela de Questões do Quiz
-- Se lesson_id for NULL = questão do quiz geral da disciplina (10 perguntas)
-- Se lesson_id preenchido = questão do quiz da aula (3 perguntas)
CREATE TABLE quiz_questions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  discipline_id UUID REFERENCES disciplines(id) ON DELETE CASCADE,
  lesson_id UUID REFERENCES lessons(id) ON DELETE CASCADE, -- NULL = quiz geral, preenchido = quiz da aula
  question TEXT NOT NULL,
  options JSONB NOT NULL,       -- Array de strings: ["Opção A", "Opção B", "Opção C", "Opção D"]
  correct_option INTEGER NOT NULL, -- Índice da resposta correta (0, 1, 2, 3)
  order_index INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Tabela de Resultados do Quiz
CREATE TABLE quiz_results (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  discipline_id UUID REFERENCES disciplines(id) ON DELETE CASCADE,
  score INTEGER NOT NULL,
  total_questions INTEGER NOT NULL,
  correct_answers INTEGER NOT NULL,
  completed_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, discipline_id)
);

-- 6. Tabela de Progresso do Aluno
CREATE TABLE user_progress (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  discipline_id UUID REFERENCES disciplines(id) ON DELETE CASCADE,
  completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, discipline_id)
);

-- 7. Tabela de Resultados do Quiz por Aula
CREATE TABLE lesson_quiz_results (
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

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Habilitar RLS em todas as tabelas
ALTER TABLE disciplines ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE materials ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE lesson_quiz_results ENABLE ROW LEVEL SECURITY;

-- Disciplinas, aulas, materiais e questões: qualquer usuário autenticado pode ler
CREATE POLICY "Authenticated users can read disciplines"
  ON disciplines FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can read lessons"
  ON lessons FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can read materials"
  ON materials FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can read quiz_questions"
  ON quiz_questions FOR SELECT
  TO authenticated
  USING (true);

-- Quiz results: usuário só vê/edita os seus próprios
CREATE POLICY "Users can read own quiz results"
  ON quiz_results FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own quiz results"
  ON quiz_results FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own quiz results"
  ON quiz_results FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- Progress: usuário só vê/edita o seu próprio progresso
CREATE POLICY "Users can read own progress"
  ON user_progress FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own progress"
  ON user_progress FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own progress"
  ON user_progress FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- Lesson quiz results: usuário só vê/edita os seus próprios
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
-- DADOS DE EXEMPLO (opcional)
-- ============================================

-- Disciplina de exemplo
INSERT INTO disciplines (name, description, icon, order_index) VALUES
  ('Segurança do Trabalho', 'Normas e práticas de segurança no ambiente corporativo.', '🦺', 1),
  ('Compliance e Ética', 'Políticas de compliance, anticorrupção e conduta ética.', '⚖️', 2),
  ('Excel Avançado', 'Fórmulas, tabelas dinâmicas, gráficos e automação com VBA.', '📊', 3);

-- Aulas de exemplo (Segurança do Trabalho)
INSERT INTO lessons (discipline_id, title, description, video_url, order_index)
SELECT id, 'Introdução à Segurança do Trabalho', 'Conceitos fundamentais de segurança.', 'https://www.youtube.com/watch?v=exemplo1', 1
FROM disciplines WHERE name = 'Segurança do Trabalho';

INSERT INTO lessons (discipline_id, title, description, video_url, order_index)
SELECT id, 'EPIs - Equipamentos de Proteção', 'Uso correto dos EPIs.', 'https://www.youtube.com/watch?v=exemplo2', 2
FROM disciplines WHERE name = 'Segurança do Trabalho';

INSERT INTO lessons (discipline_id, title, description, video_url, order_index)
SELECT id, 'Prevenção de Acidentes', 'Como identificar e prevenir riscos.', 'https://www.youtube.com/watch?v=exemplo3', 3
FROM disciplines WHERE name = 'Segurança do Trabalho';

-- Materiais de exemplo
INSERT INTO materials (discipline_id, title, type, url)
SELECT id, 'Manual de Segurança - NR06', 'pdf', 'https://exemplo.com/nr06.pdf'
FROM disciplines WHERE name = 'Segurança do Trabalho';

INSERT INTO materials (discipline_id, title, type, url)
SELECT id, 'Artigo: Cultura de Segurança', 'artigo', 'https://exemplo.com/artigo-seguranca'
FROM disciplines WHERE name = 'Segurança do Trabalho';

-- Quiz de exemplo (Segurança do Trabalho)
INSERT INTO quiz_questions (discipline_id, question, options, correct_option, order_index)
SELECT id,
  'O que significa a sigla EPI?',
  '["Equipamento de Proteção Individual", "Equipamento de Prevenção Industrial", "Estrutura de Proteção Interna", "Equipamento Provisório de Inspeção"]',
  0, 1
FROM disciplines WHERE name = 'Segurança do Trabalho';

INSERT INTO quiz_questions (discipline_id, question, options, correct_option, order_index)
SELECT id,
  'Qual NR trata sobre Equipamentos de Proteção Individual?',
  '["NR 05", "NR 06", "NR 10", "NR 35"]',
  1, 2
FROM disciplines WHERE name = 'Segurança do Trabalho';

INSERT INTO quiz_questions (discipline_id, question, options, correct_option, order_index)
SELECT id,
  'De quem é a responsabilidade de fornecer os EPIs?',
  '["Do funcionário", "Do governo", "Do empregador", "Do sindicato"]',
  2, 3
FROM disciplines WHERE name = 'Segurança do Trabalho';
