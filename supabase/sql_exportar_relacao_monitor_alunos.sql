-- ============================================================
-- EXPORTAR A RELACAO MONITOR -> ALUNOS
-- ============================================================
-- Uso: cole no SQL Editor do Supabase, execute e baixe o
-- resultado em CSV ("Download CSV" no canto do painel de
-- resultados). O arquivo alimenta as tabelas "Alunos por
-- monitor" do Relatorio do Sistema de Monitoria.
--
-- Somente leitura: nao altera nenhum registro.
--
-- As colunas saem exatamente com os nomes esperados pelo
-- gerador do relatorio:
--   monitor_nome ; monitor_email ; aluno_nome ; aluno_email
-- ============================================================

SELECT
  COALESCE(mu.raw_user_meta_data ->> 'full_name', mu.email)::TEXT AS monitor_nome,
  lower(mu.email)::TEXT                                           AS monitor_email,
  COALESCE(au.raw_user_meta_data ->> 'full_name', au.email)::TEXT AS aluno_nome,
  lower(au.email)::TEXT                                           AS aluno_email
FROM public.monitor_students ms
JOIN auth.users mu ON mu.id = ms.monitor_id
JOIN auth.users au ON au.id = ms.student_id
WHERE mu.deleted_at IS NULL
  AND au.deleted_at IS NULL
ORDER BY monitor_nome, aluno_nome;


-- ============================================================
-- CONFERENCIA RAPIDA (opcional) - rode antes ou depois
-- ============================================================
-- Quantos alunos cada monitor tem, do maior para o menor.
-- Serve para confirmar se a distribuicao continua equilibrada.

-- SELECT
--   COALESCE(mu.raw_user_meta_data ->> 'full_name', mu.email)::TEXT AS monitor,
--   lower(mu.email)::TEXT                                           AS email,
--   count(*)                                                        AS alunos
-- FROM public.monitor_students ms
-- JOIN auth.users mu ON mu.id = ms.monitor_id
-- GROUP BY 1, 2
-- ORDER BY alunos DESC, monitor;


-- ============================================================
-- TOTAIS (opcional)
-- ============================================================
-- SELECT
--   count(DISTINCT ms.monitor_id) AS monitores_com_alunos,
--   count(DISTINCT ms.student_id) AS alunos_vinculados,
--   count(*)                      AS vinculos
-- FROM public.monitor_students ms;
