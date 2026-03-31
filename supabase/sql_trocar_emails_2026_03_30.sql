-- ============================================================
-- Troca de emails de alunos
-- Data: 2026-03-30
-- 9 emails a serem substituídos
-- ============================================================

-- Preview: confirme antes de atualizar
SELECT id, email FROM auth.users
WHERE email IN (
  'bruno_lacerda16@hotmail.com',
  'lfelinto.silva@gmail.com',
  'lucilene.lopes@portosrio.temp.br',
  'marcelazanela@yahoo.com.br',
  'mauro.souza@portosrio.temp.br',
  'pedrolasevitch@gmail.com',
  'viviane7381@yahoo.com..br',
  'arcila.alves@gmail.com',
  'carlosalexaurelio@gmail.com'
)
ORDER BY email;

-- ============================================================
-- CORREÇÃO — execute após confirmar o preview acima
-- ============================================================

UPDATE auth.users SET email = 'brunolacerdaest@outlook.com'      WHERE email = 'bruno_lacerda16@hotmail.com';
UPDATE auth.users SET email = 'leandrosilveiraest@outlook.com'   WHERE email = 'lfelinto.silva@gmail.com';
UPDATE auth.users SET email = 'lucieneest@outlook.com'           WHERE email = 'lucilene.lopes@portosrio.temp.br';
UPDATE auth.users SET email = 'marcelapereiraest@outlook.com'    WHERE email = 'marcelazanela@yahoo.com.br';
UPDATE auth.users SET email = 'mauromartinsest@outlook.com'      WHERE email = 'mauro.souza@portosrio.temp.br';
UPDATE auth.users SET email = 'pedrolasevitchest@outlook.com'    WHERE email = 'pedrolasevitch@gmail.com';
UPDATE auth.users SET email = 'viviane7381@yahoo.com.br'         WHERE email = 'viviane7381@yahoo.com..br';
UPDATE auth.users SET email = 'arcilaalvesest@outlook.com'       WHERE email = 'arcila.alves@gmail.com';
UPDATE auth.users SET email = 'alexsilvaest@outlook.com'         WHERE email = 'carlosalexaurelio@gmail.com';

-- ============================================================
-- VERIFICAÇÃO FINAL — deve retornar 9 linhas com emails novos
-- ============================================================

SELECT id, email FROM auth.users
WHERE email IN (
  'brunolacerdaest@outlook.com',
  'leandrosilveiraest@outlook.com',
  'lucieneest@outlook.com',
  'marcelapereiraest@outlook.com',
  'mauromartinsest@outlook.com',
  'pedrolasevitchest@outlook.com',
  'viviane7381@yahoo.com.br',
  'arcilaalvesest@outlook.com',
  'alexsilvaest@outlook.com'
)
ORDER BY email;
