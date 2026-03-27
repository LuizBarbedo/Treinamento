-- Script de correção de senhas de monitores
-- Data: 2026-03-27
-- Uso: executar no SQL Editor do Supabase
--
-- Objetivo:
-- 1) Atualizar a senha inicial dos 10 usuários criados no script antigo
-- 2) Marcar must_reset_password = true para forçar troca no primeiro acesso

BEGIN;

DO $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN
    SELECT *
    FROM (
      VALUES
        ('oadriano2727@yahoo.com', 'Adriano'),
        ('andersonsampaio.jll@gmail.com', 'Anderson'),
        ('andre.luiz.araujo.oliveira@gmail.com', 'Andre0'),
        ('arthuraureliomed@gmail.com', 'Arthur'),
        ('claudiapxto@gmail.com', 'Claudia'),
        ('edilene.rodrigues.silva@gmail.com', 'Edilene'),
        ('kenia.souza.goncalves.santos@gmail.com', 'Kenia0'),
        ('leandro.rocha.paura@gmail.com', 'Leandro'),
        ('rneversonrocha31@gmail.com', 'Neverson'),
        ('vander.araujo@gmail.com', 'Vander')
    ) AS t(email, new_password)
  LOOP
    UPDATE auth.users u
    SET
      encrypted_password = crypt(rec.new_password, gen_salt('bf')),
      raw_user_meta_data = COALESCE(u.raw_user_meta_data, '{}'::jsonb) || '{"must_reset_password": true}'::jsonb,
      updated_at = NOW()
    WHERE lower(u.email) = lower(rec.email);
  END LOOP;
END
$$;

COMMIT;

-- Verificação: confirma se os usuários existem e se must_reset_password ficou ativo.
SELECT
  u.email,
  COALESCE((u.raw_user_meta_data ->> 'must_reset_password')::boolean, false) AS must_reset_password,
  u.updated_at
FROM auth.users u
WHERE lower(u.email) IN (
  'oadriano2727@yahoo.com',
  'andersonsampaio.jll@gmail.com',
  'andre.luiz.araujo.oliveira@gmail.com',
  'arthuraureliomed@gmail.com',
  'claudiapxto@gmail.com',
  'edilene.rodrigues.silva@gmail.com',
  'kenia.souza.goncalves.santos@gmail.com',
  'leandro.rocha.paura@gmail.com',
  'rneversonrocha31@gmail.com',
  'vander.araujo@gmail.com'
)
ORDER BY lower(u.email);
