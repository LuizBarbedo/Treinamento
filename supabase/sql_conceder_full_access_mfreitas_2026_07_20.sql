-- Concede acesso total ao coordenador Marcos Freitas
-- Login: mfreitas@ivig.coppe.ufrj.br
-- Data: 2026-07-20
--
-- Rode DEPOIS de migration_full_access.sql.
--
-- Não toca em auth.users: a senha e a identity já foram criadas pelo
-- sql_cadastrar_aluno_mfreitas_2026_07_20.sql. Aqui só marcamos o perfil.
--
-- full_access = TRUE  -> ignora o bloqueio sequencial de disciplinas/aulas
-- access_level        -> 'avancado' para ver reflexão e artigo técnico
-- role                -> continua 'user': não é admin, não gerencia conteúdo
--
-- Idempotente. Rode no Supabase Dashboard -> SQL Editor.

BEGIN;

INSERT INTO user_roles (user_id, role, access_level, full_access)
SELECT u.id, 'user', 'avancado', TRUE
FROM auth.users u
WHERE lower(u.email) = lower('mfreitas@ivig.coppe.ufrj.br')
ON CONFLICT (user_id)
DO UPDATE SET access_level = 'avancado', full_access = TRUE;

-- Verificação: deve retornar 1 linha com full_access = true
SELECT u.email, r.role, r.access_level, r.full_access
FROM auth.users u
JOIN user_roles r ON r.user_id = u.id
WHERE lower(u.email) = lower('mfreitas@ivig.coppe.ufrj.br');

-- Confere que ninguém mais ficou com acesso total
SELECT u.email, r.full_access
FROM user_roles r
JOIN auth.users u ON u.id = r.user_id
WHERE r.full_access;

COMMIT;
-- Para ensaio sem gravar: troque COMMIT por ROLLBACK.
