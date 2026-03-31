-- ============================================================
-- Corrigir emails digitados incorretamente no banco
-- Data: 2026-03-28
-- 9 emails já inseridos via migration com grafia errada
-- ============================================================

-- Preview: confirme antes de atualizar
SELECT id, email FROM auth.users
WHERE email IN (
  'elexandra lisboa@gmail.com',
  'eliasbrito 123@gmail.com',
  'joãopaulosenhorinho3@gmail.com',
  'lorranagomes.adv@amail.com',
  'mariaalmeida 123@gmail.com',
  'nathielly.sophi/2gmail.com',
  'pedrogilson2019@agmail.com',
  'pr.sperendio@gnail.com',
  'viviane7381@yahoo.com..br'
)
ORDER BY email;

-- ============================================================
-- CORREÇÃO — execute após confirmar o preview acima
-- ============================================================

UPDATE auth.users SET email = 'elexandralisboa@gmail.com'   WHERE email = 'elexandra lisboa@gmail.com';
UPDATE auth.users SET email = 'eliasbrito123@gmail.com'     WHERE email = 'eliasbrito 123@gmail.com';
UPDATE auth.users SET email = 'joaopaulosenhorinho3@gmail.com' WHERE email = 'joãopaulosenhorinho3@gmail.com';
UPDATE auth.users SET email = 'lorranagomes.adv@gmail.com'  WHERE email = 'lorranagomes.adv@amail.com';
UPDATE auth.users SET email = 'mariaalmeida123@gmail.com'   WHERE email = 'mariaalmeida 123@gmail.com';
UPDATE auth.users SET email = 'nathielly.sophi@gmail.com'   WHERE email = 'nathielly.sophi/2gmail.com';
UPDATE auth.users SET email = 'pedrogilson2019@gmail.com'   WHERE email = 'pedrogilson2019@agmail.com';
UPDATE auth.users SET email = 'pr.sperendio@gmail.com'      WHERE email = 'pr.sperendio@gnail.com';
UPDATE auth.users SET email = 'viviane7381@yahoo.com.br'    WHERE email = 'viviane7381@yahoo.com..br';

-- ============================================================
-- VERIFICAÇÃO FINAL — deve retornar 9 linhas com emails corretos
-- ============================================================

SELECT id, email FROM auth.users
WHERE email IN (
  'elexandralisboa@gmail.com',
  'eliasbrito123@gmail.com',
  'joaopaulosenhorinho3@gmail.com',
  'lorranagomes.adv@gmail.com',
  'mariaalmeida123@gmail.com',
  'nathielly.sophi@gmail.com',
  'pedrogilson2019@gmail.com',
  'pr.sperendio@gmail.com',
  'viviane7381@yahoo.com.br'
)
ORDER BY email;
