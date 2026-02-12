-- ============================================
-- MIGRATION: Fórum de Discussão
-- ============================================
-- Execute este SQL no SQL Editor do Supabase
-- (Dashboard > SQL Editor > New query)
-- ============================================

-- 1. Tabela de Posts do Fórum
CREATE TABLE forum_posts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  discipline_id UUID REFERENCES disciplines(id) ON DELETE CASCADE,
  lesson_id UUID REFERENCES lessons(id) ON DELETE SET NULL,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  category TEXT DEFAULT 'discussao', -- 'pergunta', 'discussao', 'insight'
  is_pinned BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Tabela de Respostas/Comentários do Fórum
CREATE TABLE forum_replies (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  post_id UUID REFERENCES forum_posts(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  content TEXT NOT NULL,
  is_solution BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Tabela de Curtidas em Posts
CREATE TABLE forum_post_likes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  post_id UUID REFERENCES forum_posts(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(post_id, user_id)
);

-- 4. Tabela de Curtidas em Respostas
CREATE TABLE forum_reply_likes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  reply_id UUID REFERENCES forum_replies(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(reply_id, user_id)
);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

ALTER TABLE forum_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_replies ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_post_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_reply_likes ENABLE ROW LEVEL SECURITY;

-- Forum Posts: todos autenticados podem ler
CREATE POLICY "Authenticated users can read forum posts"
  ON forum_posts FOR SELECT
  TO authenticated
  USING (true);

-- Forum Posts: autenticados podem criar
CREATE POLICY "Authenticated users can create forum posts"
  ON forum_posts FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Forum Posts: autor pode atualizar
CREATE POLICY "Users can update own forum posts"
  ON forum_posts FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- Forum Posts: autor pode deletar
CREATE POLICY "Users can delete own forum posts"
  ON forum_posts FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Forum Replies: todos autenticados podem ler
CREATE POLICY "Authenticated users can read forum replies"
  ON forum_replies FOR SELECT
  TO authenticated
  USING (true);

-- Forum Replies: autenticados podem criar
CREATE POLICY "Authenticated users can create forum replies"
  ON forum_replies FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Forum Replies: autor pode atualizar
CREATE POLICY "Users can update own forum replies"
  ON forum_replies FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- Forum Replies: autor pode deletar
CREATE POLICY "Users can delete own forum replies"
  ON forum_replies FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Post Likes: todos autenticados podem ler
CREATE POLICY "Authenticated users can read post likes"
  ON forum_post_likes FOR SELECT
  TO authenticated
  USING (true);

-- Post Likes: autenticados podem criar
CREATE POLICY "Authenticated users can like posts"
  ON forum_post_likes FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Post Likes: autor pode remover like
CREATE POLICY "Users can remove own post likes"
  ON forum_post_likes FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Reply Likes: todos autenticados podem ler
CREATE POLICY "Authenticated users can read reply likes"
  ON forum_reply_likes FOR SELECT
  TO authenticated
  USING (true);

-- Reply Likes: autenticados podem criar
CREATE POLICY "Authenticated users can like replies"
  ON forum_reply_likes FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Reply Likes: autor pode remover like
CREATE POLICY "Users can remove own reply likes"
  ON forum_reply_likes FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- ============================================
-- ÍNDICES para performance
-- ============================================
CREATE INDEX idx_forum_posts_discipline ON forum_posts(discipline_id);
CREATE INDEX idx_forum_posts_user ON forum_posts(user_id);
CREATE INDEX idx_forum_posts_created ON forum_posts(created_at DESC);
CREATE INDEX idx_forum_replies_post ON forum_replies(post_id);
CREATE INDEX idx_forum_replies_user ON forum_replies(user_id);
CREATE INDEX idx_forum_post_likes_post ON forum_post_likes(post_id);
CREATE INDEX idx_forum_reply_likes_reply ON forum_reply_likes(reply_id);
