-- ============================================
-- MIGRATION: Comentários de correção nas questões do quiz
-- Execute no SQL Editor do Supabase
-- ============================================

-- Adicionar coluna correction_comment à tabela quiz_questions
-- Este campo armazena o comentário de correção que aparece
-- ao aluno quando ele finaliza o quiz (apenas após enviar respostas)
ALTER TABLE quiz_questions ADD COLUMN IF NOT EXISTS correction_comment TEXT;
