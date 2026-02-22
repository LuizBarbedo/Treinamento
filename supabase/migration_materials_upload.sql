-- ============================================
-- MIGRATION: Suporte a Upload de Arquivos em Materiais
-- ============================================
-- Execute este SQL no SQL Editor do Supabase
-- (Dashboard > SQL Editor > New query)
-- ============================================

-- 1. Adicionar coluna file_path à tabela materials
-- (armazena o caminho do arquivo no Supabase Storage para possibilitar exclusão)
ALTER TABLE materials ADD COLUMN IF NOT EXISTS file_path TEXT;

-- 2. Criar bucket de Storage para materiais
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'materials',
  'materials',
  true,
  52428800, -- 50MB limite
  ARRAY[
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  ]::text[]
)
ON CONFLICT (id) DO NOTHING;

-- 3. Políticas de Storage

-- Qualquer usuário autenticado pode LER (download) os materiais
CREATE POLICY "Authenticated users can read materials files"
  ON storage.objects FOR SELECT
  TO authenticated
  USING (bucket_id = 'materials');

-- Qualquer usuário autenticado pode fazer UPLOAD
-- (Na prática, apenas admins terão acesso à tela de upload)
CREATE POLICY "Authenticated users can upload materials files"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'materials');

-- Qualquer usuário autenticado pode DELETAR
-- (Na prática, apenas admins terão acesso à funcionalidade de deletar)
CREATE POLICY "Authenticated users can delete materials files"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'materials');

-- Acesso público para leitura (para URLs públicas funcionarem)
CREATE POLICY "Public can read materials files"
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'materials');
