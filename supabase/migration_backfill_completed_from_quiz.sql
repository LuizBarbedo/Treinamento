-- ============================================
-- BACKFILL: Marcar disciplinas como concluídas
-- para alunos que passaram no quiz final (>= 50%)
-- mas não estão registrados como completed no user_progress.
--
-- Contexto: havia um bug que permitia ao aluno fazer o quiz final
-- sem ter assistido as aulas / feito os quizzes de aula.
-- Esses alunos têm quiz_results aprovado mas ficam aparecendo
-- como "Inativo" no relatório porque não há registro em user_progress.
-- ============================================

INSERT INTO user_progress (user_id, discipline_id, completed, completed_at)
SELECT
  qr.user_id,
  qr.discipline_id,
  TRUE,
  COALESCE(qr.completed_at, NOW())
FROM quiz_results qr
WHERE qr.score >= 50
ON CONFLICT (user_id, discipline_id)
DO UPDATE SET
  completed = TRUE,
  completed_at = COALESCE(user_progress.completed_at, EXCLUDED.completed_at);
