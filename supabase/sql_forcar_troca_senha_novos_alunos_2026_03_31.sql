-- ============================================================
-- Forçar troca de senha no primeiro acesso (novos alunos)
-- Data: 2026-03-31
-- Uso: executar no SQL Editor do Supabase
-- ============================================================

BEGIN;

UPDATE auth.users u
SET
  raw_user_meta_data = COALESCE(u.raw_user_meta_data, '{}'::jsonb) || '{"must_reset_password": true}'::jsonb,
  updated_at = NOW()
WHERE lower(u.email) IN (
  'fagner.dias@portosrio.gov.br',
  'fernanda.sasaoka@portosrio.gov.br',
  'flavio.vieira@portosrio.gov.br',
  'renan.almeida@portosrio.gov.br',
  'aramis.junior@portosrio.gov.br',
  'francisco.diogo@portosrio.gov.br',
  'elisabete.souza@portosrio.gov.br'
);

COMMIT;

-- Verificação
SELECT
  u.email,
  COALESCE((u.raw_user_meta_data ->> 'must_reset_password')::boolean, false) AS must_reset_password,
  u.updated_at
FROM auth.users u
WHERE lower(u.email) IN (
  'fagner.dias@portosrio.gov.br',
  'fernanda.sasaoka@portosrio.gov.br',
  'flavio.vieira@portosrio.gov.br',
  'renan.almeida@portosrio.gov.br',
  'aramis.junior@portosrio.gov.br',
  'francisco.diogo@portosrio.gov.br',
  'elisabete.souza@portosrio.gov.br'
)
ORDER BY lower(u.email);
