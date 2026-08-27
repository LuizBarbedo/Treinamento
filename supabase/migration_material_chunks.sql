-- ============================================
-- MIGRATION: Chunks de materiais para RAG (busca full-text)
-- ============================================
-- Execute este SQL no SQL Editor do Supabase
-- (Dashboard > SQL Editor > New query)
--
-- Guarda o texto dos materiais (PDF/Word) quebrado em pedaços
-- pesquisáveis, para o chat de IA buscar só os trechos relevantes
-- para cada pergunta em vez de usar o material inteiro.
--
-- Usa busca full-text nativa do Postgres (tsvector/ts_rank) em vez
-- de embeddings vetoriais: o endpoint de embeddings do Ollama Cloud
-- não está disponível no plano atual.
-- ============================================

CREATE TABLE IF NOT EXISTS material_chunks (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  material_id UUID REFERENCES materials(id) ON DELETE CASCADE,
  discipline_id UUID REFERENCES disciplines(id) ON DELETE CASCADE,
  chunk_index INTEGER NOT NULL,
  content TEXT NOT NULL,
  search_vector TSVECTOR GENERATED ALWAYS AS (to_tsvector('portuguese', content)) STORED,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS material_chunks_search_idx ON material_chunks USING GIN (search_vector);
CREATE INDEX IF NOT EXISTS material_chunks_discipline_idx ON material_chunks (discipline_id);
CREATE INDEX IF NOT EXISTS material_chunks_material_idx ON material_chunks (material_id);

ALTER TABLE material_chunks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read material_chunks"
  ON material_chunks FOR SELECT
  TO authenticated
  USING (true);

-- Inserção/exclusão acontece na tela de admin ao salvar um material
-- (mesmo padrão de permissão usado hoje para a tabela materials: gate
-- de admin é feito na UI, não em RLS)
CREATE POLICY "Authenticated users can insert material_chunks"
  ON material_chunks FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete material_chunks"
  ON material_chunks FOR DELETE
  TO authenticated
  USING (true);

-- Função de busca: retorna os trechos mais relevantes de uma disciplina
-- para uma pergunta, ranqueados por relevância textual (ts_rank).
CREATE OR REPLACE FUNCTION search_material_chunks(
  p_discipline_id UUID,
  p_query TEXT,
  p_limit INTEGER DEFAULT 5
)
RETURNS TABLE (
  material_id UUID,
  material_title TEXT,
  content TEXT,
  rank REAL
)
LANGUAGE sql
STABLE
AS $$
  SELECT
    mc.material_id,
    m.title AS material_title,
    mc.content,
    ts_rank(mc.search_vector, plainto_tsquery('portuguese', p_query)) AS rank
  FROM material_chunks mc
  JOIN materials m ON m.id = mc.material_id
  WHERE mc.discipline_id = p_discipline_id
    AND mc.search_vector @@ plainto_tsquery('portuguese', p_query)
  ORDER BY rank DESC
  LIMIT p_limit;
$$;

GRANT EXECUTE ON FUNCTION search_material_chunks(UUID, TEXT, INTEGER) TO authenticated;
