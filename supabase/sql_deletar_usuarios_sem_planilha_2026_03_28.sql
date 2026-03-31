-- ============================================================
-- Deletar usuários que não constam em nenhuma planilha final
-- Data: 2026-03-28
--
-- Usuários preservados (não incluídos aqui):
--   ramalhomarcusantonio@gmail.com, deboramellocamilo@gmail.com,
--   ecamilo@id.uff.br, eduardofelipe@gmail.com, fvergueiro@id.uff.br,
--   mfreitas@ivig.coppe.ufrj.br, nextmarte@hotmail.com,
--   nextmetal@gmail.com, ricardo.ganem@portosrio.gov.br,
--   rodnramos@gmail.com
--
-- Total a deletar: 33 usuários
--   - 32 com role monitor (não estão na planilha monitores.xlsx)
--   - 1 com role user (não está na planilha alunos.xlsx)
--
-- A deleção em auth.users remove automaticamente user_roles
-- via ON DELETE CASCADE.
-- ============================================================

-- Preview: confirme os usuários antes de deletar
SELECT u.email, ur.role, ur.cpf
FROM auth.users u
LEFT JOIN public.user_roles ur ON ur.user_id = u.id
WHERE lower(u.email) IN (
  'ana.carolina.lima.pereira@gmail.com',
  'anaclaravianadoamaralpaes@gmail.com',
  'andressasepulveda@yahoo.com.br',
  'caiofelipe0216@gmail.com',
  'claudiochumbinho13@gmail.com',
  'delimarmartins@gmail.com',
  'df0462230@gmail.com',
  'diegoferangel@hotmail.com',
  'edsandrorangel@hotmail.com',
  'edsonsalteiroxp@gmail.com',
  'eduardadisanto326@gmail.com',
  'elvirabrum99@gmail.com',
  'everaldo.medeiros@gmail.com',
  'fabio1977sapo@hotmail.com',
  'felipechumbinho02@gmail.com',
  'filipe_jean@outlook.com',
  'francisco.teixeira.jesus@gmail.com',
  'guimaia17@gmail.com',
  'isabelrascao5522@gmail.com',
  'katharymchaim333@gmail.com',
  'keyliane.sena@gmail.com',
  'lucimar.eufrasio@gmail.com',
  'ludmilla_quintanilha@hotmail.com',
  'marcosgoncalvez_@hotmail.com',
  'nathalicsfagundes@gmail.com',
  'pamellabarreto18@gmail.com',
  'peresluciano688@gmail.com',
  'ramagulinele@gmail.com',
  'ruthdesena333@gmail.com',
  'sebastiaocruz540@gmail.com',
  'thamyrescunhafe@gmail.com',
  'thayssasiqueira20@icloud.com',
  'vagnerleonidio.vl@gmail.com'
)
ORDER BY ur.role, u.email;

-- ============================================================
-- DELEÇÃO — execute após confirmar o preview acima
-- ============================================================

DELETE FROM auth.users
WHERE lower(email) IN (
  'ana.carolina.lima.pereira@gmail.com',
  'anaclaravianadoamaralpaes@gmail.com',
  'andressasepulveda@yahoo.com.br',
  'caiofelipe0216@gmail.com',
  'claudiochumbinho13@gmail.com',
  'delimarmartins@gmail.com',
  'df0462230@gmail.com',
  'diegoferangel@hotmail.com',
  'edsandrorangel@hotmail.com',
  'edsonsalteiroxp@gmail.com',
  'eduardadisanto326@gmail.com',
  'elvirabrum99@gmail.com',
  'everaldo.medeiros@gmail.com',
  'fabio1977sapo@hotmail.com',
  'felipechumbinho02@gmail.com',
  'filipe_jean@outlook.com',
  'francisco.teixeira.jesus@gmail.com',
  'guimaia17@gmail.com',
  'isabelrascao5522@gmail.com',
  'katharymchaim333@gmail.com',
  'keyliane.sena@gmail.com',
  'lucimar.eufrasio@gmail.com',
  'ludmilla_quintanilha@hotmail.com',
  'marcosgoncalvez_@hotmail.com',
  'nathalicsfagundes@gmail.com',
  'pamellabarreto18@gmail.com',
  'peresluciano688@gmail.com',
  'ramagulinele@gmail.com',
  'ruthdesena333@gmail.com',
  'sebastiaocruz540@gmail.com',
  'thamyrescunhafe@gmail.com',
  'thayssasiqueira20@icloud.com',
  'vagnerleonidio.vl@gmail.com'
);

-- ============================================================
-- VERIFICAÇÃO FINAL — deve retornar 0 linhas
-- ============================================================

SELECT u.email
FROM auth.users u
WHERE lower(u.email) IN (
  'ana.carolina.lima.pereira@gmail.com',
  'anaclaravianadoamaralpaes@gmail.com',
  'andressasepulveda@yahoo.com.br',
  'caiofelipe0216@gmail.com',
  'claudiochumbinho13@gmail.com',
  'delimarmartins@gmail.com',
  'df0462230@gmail.com',
  'diegoferangel@hotmail.com',
  'edsandrorangel@hotmail.com',
  'edsonsalteiroxp@gmail.com',
  'eduardadisanto326@gmail.com',
  'elvirabrum99@gmail.com',
  'everaldo.medeiros@gmail.com',
  'fabio1977sapo@hotmail.com',
  'felipechumbinho02@gmail.com',
  'filipe_jean@outlook.com',
  'francisco.teixeira.jesus@gmail.com',
  'guimaia17@gmail.com',
  'isabelrascao5522@gmail.com',
  'katharymchaim333@gmail.com',
  'keyliane.sena@gmail.com',
  'lucimar.eufrasio@gmail.com',
  'ludmilla_quintanilha@hotmail.com',
  'marcosgoncalvez_@hotmail.com',
  'nathalicsfagundes@gmail.com',
  'pamellabarreto18@gmail.com',
  'peresluciano688@gmail.com',
  'ramagulinele@gmail.com',
  'ruthdesena333@gmail.com',
  'sebastiaocruz540@gmail.com',
  'thamyrescunhafe@gmail.com',
  'thayssasiqueira20@icloud.com',
  'vagnerleonidio.vl@gmail.com'
);
