-- ============================================
-- RELATÓRIO: Todos os usuários com email, role e CPF
-- Execute no SQL Editor do Supabase
-- Após executar, clique em "Download CSV" para exportar
-- O LIMIT 10000 bypassa o limite padrão de 100 linhas da UI
-- ============================================

SELECT
  u.email,
  COALESCE(ur.role, 'sem_role')          AS role,
  ur.cpf,
  COALESCE(u.raw_user_meta_data ->> 'full_name', '') AS full_name,
  u.created_at::DATE                      AS criado_em
FROM auth.users u
LEFT JOIN public.user_roles ur ON ur.user_id = u.id
WHERE u.email != 'aplicacao.treinamento@gmail.com'
ORDER BY u.email
LIMIT 10000;
