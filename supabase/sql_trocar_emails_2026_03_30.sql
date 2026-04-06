-- ============================================================
-- Troca de emails de alunos
-- Data: 2026-03-30
-- 282 emails a serem substituídos
-- ============================================================

-- Preview: confirme antes de atualizar
SELECT id, email FROM auth.users
WHERE email IN (
  'alexpagniez@gmail.com',
  'alexandrebarbosa042@gmail.com',
  'alexandre.barbosa.nascimento@gmail.com',
  'alicebianchiinimrs@gmail.com',
  'alineduncan@gmail.com',
  'amarildo.pereira@gmail.com',
  'amarojaperi331@gmail.com',
  'amelia.santos@gmail.com',
  'anacarlarj@hotmail.com',
  'anapaulabercotsilva@gmail.com',
  'andrelohan777@icloud.com',
  'andreiadesouza2376@gmail.com',
  'andrecarioca800@gmail.com',
  'andreluizlaureano1976@gmail.com',
  'andrewasley@gmail.com',
  'angmaria1988@gmail.com',
  'nemitzangela22@gmail.com',
  'angelica.dias.oliveira@gmail.com',
  'anilza.araujo002@gmail.com',
  'lucileneantonia@gmail.com',
  'toninho_ns@hotmail.com',
  'biaribeiro@gmail.com',
  'brendhaquintadilha123@gmail.com',
  'bruno.brito.silva@gmail.com',
  'bgonçalvesolkveira@gmail.com',
  'cailan.cardoso@gmail.com',
  'camilaabreudeoliveiraesteves@gmail.com',
  'carlos.moraes@gmail.com',
  'alexandrecarlos@gmail.com',
  'barretolou@hotmail.com',
  'carlinhos333@gmail.com',
  'carlos.correa.firmo@gmail.com',
  'rodriguescauelucas3103@gmail.com',
  'caduneves1@gmail.com',
  'calosjose@gmail.com',
  'carlos.menin@gmail.com',
  'carlos.ricardo.mendonca@gmail.com',
  'netvinyeugenio@hotmail.com',
  'clarissaadv83@gmail.com',
  'cristian.souza.mello@gmail.com',
  'cristianjardim18@gmai.com',
  'cris.kadupeixoto@gmail.com',
  'cristianesampaio2409@gmail.com',
  'cezar.sacramento.alves@gmail.com',
  'daiannacristinna@icloud.com',
  'darr89.da@gmail.com',
  'diclima42@gmail.com',
  'daniramos22@gmail.com',
  'dani.dasilvarangel@gmail.com',
  'danisouza194@hotmail.com',
  'danielleramosdp@gmail.com',
  'daniellevcosta187@gmail.com',
  'danielson.borges@gmail.com',
  'santosdeborah58@gmail.com',
  'nocogomesdapenha@gmail.com',
  'denilsanton@gmail.com',
  'denioaferreira@gmail.com',
  'garcezdenis46@gmail.com',
  'diana.silva@gmail.com',
  'diego.campos.gomes@gmail.com',
  'diogomartinsrj4@gmail.com',
  'dilceia.vieira@gmail.com',
  'ederson.souza@gmail.com',
  'edsandro624@gmail.com',
  'edsoncabral8239@gmail.com',
  'eduardojunqueira37@gmail.com',
  'elexandra lisboa@gmail.com',
  'lianelealribeiro@gmail.com',
  'elisangela.mota@gmail.com',
  'elizabethcostahjh@gmail.com',
  'emersonramos1502@gmail.com',
  'ds1119629@gmail.com',
  'cenzo15@yahoo.com',
  'erick.bloise.lima@gmail.com',
  'erikamaedakika2@gmail.com',
  'esteiroribeiro@hotmail.com',
  'eversonribeiro2025@gmail.com',
  'everton.silva@portosrio.temp.br',
  'expeditoguimaraes247@gmail.com',
  'fabiano.pereira.rocha@gmail.com',
  'fabiosants555@gmail.com',
  'fatima.azevedo@portosrio.temp.br',
  'fenelassed@hotmail.com',
  'feeprince19@gmail.com',
  'fernanda.fernandes@gmail.com',
  'fernandoboechatjr@hotmail.com',
  'flavioconceicao15@gmail.com',
  'fcchlcomento1954@hotmail.com',
  'francisconatao000@gmail.com',
  'gcg.0014@gmail.com',
  'gabrielcsantos234@gmail.com',
  'gabrielgoulartdearaujo@gmail.com',
  'gabpereira@gmail.com',
  'gabivirgo128@gmail.com',
  'gabizzinhahenriques@gmail.com',
  'gabiolinda@gmail.com',
  'gabriella.dg2018@hotmail.com',
  'genilson.santos.silva@gmail.com',
  'georgecosmenascimento@gmail.com',
  'geeh.gravessem@gmail.com',
  'geysongramos@gmail.com',
  'gilgomesrj@gmail.com',
  'pedrogilson2019@agmail.com',
  'gizele.conceicao.santos@gmail.com',
  'greicegov@gmail.com',
  'gressyrenner23@gmail.com',
  'guigas.campos@gmail.com',
  'hanna0033@gmail.com',
  'heitor.assis@gmail.com',
  'helena.ribeiro.nunes@gmail.com',
  'henrique.soares.silva@gmail.com',
  'hewfer@gmail.com',
  'heynegm21@gmail.com',
  'hugo.zevedo@gmail.com',
  'igorbeneditoprimeiro@gmail.com',
  'inara.goncalves@gmail.com',
  'isabellabarbosa034@gmail.com',
  'itamar.teixeira@gmail.com',
  'jaderjuniorcordeiro@gmail.com',
  'lenomorais23@gmail.com',
  'jair.cunha@gmail.com',
  'jane.souza@portosrio.temp.br',
  'jane.gomes@gmail.com',
  'jaquemerçam@gmail.com',
  'jefferson.alerj@gmail.com',
  'jeferson_andre10@gmail.com',
  'jeniffer.silvans@gmail.com',
  'jessepires12@gmail.com',
  'jb3772083@gmail.com',
  'xavierjosecarlosx@gmail.com',
  'zegalo000@gmail.com',
  'jgsobrinho12@gmail.com',
  'joseraimujndo423@gmail.com',
  'joselia.emilia.silva@gmail.com',
  'jojopelle@gmail.com',
  'josefaria332@gmail.com',
  'joyce.ramosclei@gmail.com',
  'joaogomesportorea@gmail.com',
  'eliasbrito 123@gmail.com',
  'joaolucas.vilela@gmail.com',
  'dossantosjoaovitorleandro@gmail.com',
  'aparecidajulia3002@gmail.com',
  'jucortespon@gmail.com',
  'juhbarrinha@gmail.com',
  'falarcomjuliogomes@gmail.com',
  'jurandimatos000@gmail.com',
  'katiapinheiro1986@gmail.com',
  'kaupinheiro@gmail.com',
  'kellygomesmonteiro3@gmail.com',
  'kelly.lucia.benvindo.batista.canust@gmail.com',
  'lairacristina915@gmail.com',
  'laiza.vellozo@icloud.com',
  'laripessanha@gmail.com',
  'leandro.goncalves.tiago@gmail.com',
  'pr.sperendio@gnail.com',
  'leonardobmoreira@live.com',
  'leonardo06barbosa@gmail.com',
  'leticiia.silva2505@gmail.com',
  'lidiane.alencar.ponce.gomes@gmail.com',
  'lidiane.santos.moreira@gmail.com',
  'liviasouza2110@gmail.com',
  'livyadiniz8@gmail.com',
  'lorranrodrigues4@gmail.com',
  'lorranagomes.adv@amail.com',
  'luana.prazeres@portosrio.temp.br',
  'lucasolisouzapj@gmail.com',
  'lucas.ferreira.silva@gmail.com',
  'lucassantos@gmail.com',
  'lucasrangelgomesperes@gmail.com',
  'lucilene.barbosa@portosrio.temp.br',
  'luisnovellinomarques@gmail.com',
  'luisotaviogomespereira1234@hotmail.com',
  'luiztimbauba82@gmail.com',
  'maicon.soares91@gmail.com',
  'maracriatinalaura@gmail.com',
  'marcel.correa@hotmail.com',
  'marcelocamposdas@gmail.com',
  'marceeva643@gmail.com',
  'diretormegamix@gmail.co',
  'marciaferreira.1805@gmail.com',
  'marciavictorfrazao@gmail.com',
  'marcio.muniz@portosrio.temp.br',
  'marcoantonio.paes@gmail.com',
  'mabbarros@yahoo.com.br',
  'marcosfelix452023@gmail.com',
  'marcospeixotosoaresp@gmail.com',
  'mvsouzapinturas3@gmail.com',
  'lizacamylle@hotmail.com',
  'mariaalmeida 123@gmail.com',
  'mariaaahcalvacanti234@gmail.com',
  'mariacleiderj@gmail.com',
  'msoarespereira19@gmail.com',
  'pablocontagp@gmail.com',
  'mariasilvavalentim19@gmail.com',
  'marianaveira000@gmail.com',
  'marianafarias3110@gmail.com',
  'marlon1coelho1234@gmail.com',
  'mateus.vieira.teixeira@gmail.com',
  'matheus.quintal@portosrio.temp.br',
  'matheusstellet922@gmail.com',
  'omaxslei@gmail.com',
  'maxwellmariadasilva@gmail.com',
  'maycon.senra@hotmail.com',
  'millenariopsi@gmail.com',
  'moacirfilho10@gmail.com',
  'murilovieira10@hotmail.com',
  'nathalicsbarros@gmail.com',
  'nathaliadasilvavalente2020@gmail.com',
  'nathaliafrancelino1@gmail.com',
  'nathalia.sperendio.oliveira@gmail.com',
  'nathielly.sophi/2gmail.com',
  'nubia.estevao@gmail.com',
  'osirisamaral7@gmail.com',
  'osfer@gmail.com',
  'ostairferreira@gmail.com',
  'pablorhuanbuffa@gmail.com',
  'castilhopaola373@gmail.com',
  'paulo.carvalho.silva@gmail.com',
  'peterson212709@gmail.com',
  '22997958734pae@gmail.com',
  'priscilla.gama@portosrio.temp.br',
  'rafael.dias.ribeiro@gmail.com',
  'rafaoliveiralima07@gmail.com',
  'pedroregisgato0508@gmail.com',
  'raimundononatodesouza199@gmail.com',
  'raissabrito680@gmail.com',
  'raquelcorrea55@gmail.com',
  'raul.nascimento@gmail.com',
  'reginaldovalentim050@gmail.com',
  'souzarenata321@gmail.com',
  'richardison.ri@hotmail.com',
  'rn06456@gmail.com',
  'rogerio.jose.silva@gmail.com',
  'roldiney.terrason@gmail.com',
  'rosanaamaral184@gmail.com',
  'sanfreitas@gmail.com',
  'sandra.rosa.santana.jesus@gmail.com',
  'sergio.alves.ceda@gmail.com',
  'sfseveriano@hotmail.com',
  'nerysergioso@hotmail.com',
  'silvani.maria25@gmail.com',
  'smatrb.maciel@gmail.com',
  'silvio.santos.souza@gmail.com',
  'simone.aparecida.menezes.abreu@gmail.com',
  'simone.regina.teixeira@gmail.com',
  'sornandes@gmail.com',
  'suelen.maisa.lipe@gmail.com',
  'smirandadama@gmail.com',
  'suzelane.macario.barros.paula@gmail.com',
  'soaniawerneck05@gmail.com',
  'taise.cavallieri@gmail.com',
  'tsreserva.1@gmail.com',
  'lindinhatatiana06@gmail.com',
  'tatiane.nunes.mota@gmail.com',
  'thdomingoss022@gmail.com',
  'titimacuco@gmail.com',
  'valdecir.madeira@portosrio.temp.br',
  'valeria.machado.silva@gmail.com',
  'floridovaleria66@gmail.com',
  'vanderlei.correa789@gmail.com',
  'vanderleyronan@gmail.com',
  'victor.moraes@portosrio.temp.br',
  'victorocs@gmail.com',
  'virgilio.panissolo.pereira@gmail.com',
  'vvjales@gmail.com',
  'vitorcorreafotografo@gmail.com',
  'vhcruz2003@gmail.com',
  'vitoriamontes58@gmail.com',
  'ivianeangelidarodrigues@gmail.com',
  'sodanii@yahoo.com.br',
  'vitrini123alves@hotmail.com',
  'warlocarvalhosumi@gmail.com',
  'webson.silva.santos1@gmail.com',
  'wellingtonwado160@gmail.com',
  'w.lacerda2028@gmail.com',
  'alencarsilva369@gmail.com',
  'wilsonfranca555@gmail.com',
  'yuridesousatelleslopes@gmail.com',
  'alvari@gmail.com',
  'isac.sales@gmail.com',
  'JOSEERIVA@GMAIL.COM',
  'JRDOPULAPULA2248@GMAIL.COM'
)
ORDER BY email;

-- ============================================================
-- CORREÇÃO — execute após confirmar o preview acima
-- ============================================================

UPDATE auth.users SET email = 'alexandercamargoest@outlook.com'         WHERE email = 'alexpagniez@gmail.com';
UPDATE auth.users SET email = 'alexandrenascimentoest@outlook.com'      WHERE email = 'alexandrebarbosa042@gmail.com';
UPDATE auth.users SET email = 'alexandresantosest@outlook.com'          WHERE email = 'alexandre.barbosa.nascimento@gmail.com';
UPDATE auth.users SET email = 'alicestorkest@outlook.com'               WHERE email = 'alicebianchiinimrs@gmail.com';
UPDATE auth.users SET email = 'alinesoaresest@outlook.com'              WHERE email = 'alineduncan@gmail.com';
UPDATE auth.users SET email = 'amarildopereiraest@outlook.com'          WHERE email = 'amarildo.pereira@gmail.com';
UPDATE auth.users SET email = 'amaronetoest@outlook.com'                WHERE email = 'amarojaperi331@gmail.com';
UPDATE auth.users SET email = 'ameliasantosest@outlook.com'             WHERE email = 'amelia.santos@gmail.com';
UPDATE auth.users SET email = 'anacarlasantosest@outlook.com'           WHERE email = 'anacarlarj@hotmail.com';
UPDATE auth.users SET email = 'anabercotest@outlook.com'                WHERE email = 'anapaulabercotsilva@gmail.com';
UPDATE auth.users SET email = 'andrevieiraest@outlook.com'              WHERE email = 'andrelohan777@icloud.com';
UPDATE auth.users SET email = 'andreiasouzaest@outlook.com'             WHERE email = 'andreiadesouza2376@gmail.com';
UPDATE auth.users SET email = 'andreversongoncalvesest@outlook.com'     WHERE email = 'andrecarioca800@gmail.com';
UPDATE auth.users SET email = 'andreloureanoest@outlook.com'            WHERE email = 'andreluizlaureano1976@gmail.com';
UPDATE auth.users SET email = 'andrefirmoest@outlook.com'               WHERE email = 'andrewasley@gmail.com';
UPDATE auth.users SET email = 'angelasantosest@outlook.com'             WHERE email = 'angmaria1988@gmail.com';
UPDATE auth.users SET email = 'angelaoliveiraest@outlook.com'           WHERE email = 'nemitzangela22@gmail.com';
UPDATE auth.users SET email = 'angelicaoliveiraest@outlook.com'         WHERE email = 'angelica.dias.oliveira@gmail.com';
UPDATE auth.users SET email = 'anilzaaraujoest@outlook.com'             WHERE email = 'anilza.araujo002@gmail.com';
UPDATE auth.users SET email = 'antoniamendesest@outlook.com'            WHERE email = 'lucileneantonia@gmail.com';
UPDATE auth.users SET email = 'carlos_souzaest@outlook.com'             WHERE email = 'toninho_ns@hotmail.com';
UPDATE auth.users SET email = 'beatrizrochaest@outlook.com'             WHERE email = 'biaribeiro@gmail.com';
UPDATE auth.users SET email = 'brendhadiasest@outlook.com'              WHERE email = 'brendhaquintadilha123@gmail.com';
UPDATE auth.users SET email = 'brunosilvaest@outlook.com'               WHERE email = 'bruno.brito.silva@gmail.com';
UPDATE auth.users SET email = 'brunooliveiraest@outlook.com'            WHERE email = 'bgonçalvesolkveira@gmail.com';
UPDATE auth.users SET email = 'cailancardosoest@outlook.com'            WHERE email = 'cailan.cardoso@gmail.com';
UPDATE auth.users SET email = 'camilaoliveiraest@outlook.com'           WHERE email = 'camilaabreudeoliveiraesteves@gmail.com';
UPDATE auth.users SET email = 'carlosmoraesest@outlook.com'             WHERE email = 'carlos.moraes@gmail.com';
UPDATE auth.users SET email = 'carlosgomesest@outlook.com'              WHERE email = 'alexandrecarlos@gmail.com';
UPDATE auth.users SET email = 'carlosloureiroest@outlook.com'           WHERE email = 'barretolou@hotmail.com';
UPDATE auth.users SET email = 'carlosmedeirosest@outlook.com'           WHERE email = 'carlinhos333@gmail.com';
UPDATE auth.users SET email = 'carlosfirmoest@outlook.com'              WHERE email = 'carlos.correa.firmo@gmail.com';
UPDATE auth.users SET email = 'carloslimaest@outlook.com'               WHERE email = 'rodriguescauelucas3103@gmail.com';
UPDATE auth.users SET email = 'carlosnevesest@outlook.com'              WHERE email = 'caduneves1@gmail.com';
UPDATE auth.users SET email = 'carlossouzaest@outlook.com'              WHERE email = 'calosjose@gmail.com';
UPDATE auth.users SET email = 'carlosmeninest@outlook.com'              WHERE email = 'carlos.menin@gmail.com';
UPDATE auth.users SET email = 'carlosmendoncaest@outlook.com'           WHERE email = 'carlos.ricardo.mendonca@gmail.com';
UPDATE auth.users SET email = 'celinaeugenioest@outlook.com'            WHERE email = 'netvinyeugenio@hotmail.com';
UPDATE auth.users SET email = 'clarissaleopoldinoest@outlook.com'       WHERE email = 'clarissaadv83@gmail.com';
UPDATE auth.users SET email = 'cristianmelloest@outlook.com'            WHERE email = 'cristian.souza.mello@gmail.com';
UPDATE auth.users SET email = 'cristiannanascimentoest@outlook.com'     WHERE email = 'cristianjardim18@gmai.com';
UPDATE auth.users SET email = 'cristianecarvalhoest@outlook.com'        WHERE email = 'cris.kadupeixoto@gmail.com';
UPDATE auth.users SET email = 'cristianesampaiorest@outlook.com'        WHERE email = 'cristianesampaio2409@gmail.com';
UPDATE auth.users SET email = 'cezaralvesest@outlook.com'               WHERE email = 'cezar.sacramento.alves@gmail.com';
UPDATE auth.users SET email = 'daianegouveaest@outlook.com'             WHERE email = 'daiannacristinna@icloud.com';
UPDATE auth.users SET email = 'danielribeiroest@outlook.com'            WHERE email = 'darr89.da@gmail.com';
UPDATE auth.users SET email = 'daniellimaest@outlook.com'               WHERE email = 'diclima42@gmail.com';
UPDATE auth.users SET email = 'danielamancoest@outlook.com'             WHERE email = 'daniramos22@gmail.com';
UPDATE auth.users SET email = 'danielasilvaest@outlook.com'             WHERE email = 'dani.dasilvarangel@gmail.com';
UPDATE auth.users SET email = 'daniellelimaest@outlook.com'             WHERE email = 'danisouza194@hotmail.com';
UPDATE auth.users SET email = 'danielleramosest@outlook.com'            WHERE email = 'danielleramosdp@gmail.com';
UPDATE auth.users SET email = 'daniellecostaest@outlook.com'            WHERE email = 'daniellevcosta187@gmail.com';
UPDATE auth.users SET email = 'danielsonborgesest@outlook.com'          WHERE email = 'danielson.borges@gmail.com';
UPDATE auth.users SET email = 'deborahbarreirosest@outlook.com'         WHERE email = 'santosdeborah58@gmail.com';
UPDATE auth.users SET email = 'dejacirpenhaest@otulook.com'             WHERE email = 'nocogomesdapenha@gmail.com';
UPDATE auth.users SET email = 'denilciasantoest@outlook.com'            WHERE email = 'denilsanton@gmail.com';
UPDATE auth.users SET email = 'denioferreiraest@outlook.com'            WHERE email = 'denioaferreira@gmail.com';
UPDATE auth.users SET email = 'denisgarcez@outlook.com'                 WHERE email = 'garcezdenis46@gmail.com';
UPDATE auth.users SET email = 'dianasilvaest@outlook.com'               WHERE email = 'diana.silva@gmail.com';
UPDATE auth.users SET email = 'diegogomesest@outlook.com'               WHERE email = 'diego.campos.gomes@gmail.com';
UPDATE auth.users SET email = 'diegomartinsest@outlook.com'             WHERE email = 'diogomartinsrj4@gmail.com';
UPDATE auth.users SET email = 'dilceiavieiraest@outlook.com'            WHERE email = 'dilceia.vieira@gmail.com';
UPDATE auth.users SET email = 'edersonsouzaest@outlook.com'             WHERE email = 'ederson.souza@gmail.com';
UPDATE auth.users SET email = 'edsandromerlinest@outlook.com'           WHERE email = 'edsandro624@gmail.com';
UPDATE auth.users SET email = 'edsonjuniorest@outlook.com'              WHERE email = 'edsoncabral8239@gmail.com';
UPDATE auth.users SET email = 'eduardojunqueiraest@outlook.com'         WHERE email = 'eduardojunqueira37@gmail.com';
UPDATE auth.users SET email = 'elexandraamaranteest@outlook.com'        WHERE email = 'elexandra lisboa@gmail.com';
UPDATE auth.users SET email = 'elianeribeiroest@outlook.com'            WHERE email = 'lianelealribeiro@gmail.com';
UPDATE auth.users SET email = 'elisangelamotaest@outlook.com'           WHERE email = 'elisangela.mota@gmail.com';
UPDATE auth.users SET email = 'elizabethlimaest@outlook.com'            WHERE email = 'elizabethcostahjh@gmail.com';
UPDATE auth.users SET email = 'emersonromoaldoest@outlook.com'          WHERE email = 'emersonramos1502@gmail.com';
UPDATE auth.users SET email = 'enirsilvaest@outlook.com'                WHERE email = 'ds1119629@gmail.com';
UPDATE auth.users SET email = 'enzopintorest@outlook.com'               WHERE email = 'cenzo15@yahoo.com';
UPDATE auth.users SET email = 'ericklimaest@outlook.com'                WHERE email = 'erick.bloise.lima@gmail.com';
UPDATE auth.users SET email = 'erikasouzaest@outlook.com'               WHERE email = 'erikamaedakika2@gmail.com';
UPDATE auth.users SET email = 'estesiodantesest@outlook.com'            WHERE email = 'esteiroribeiro@hotmail.com';
UPDATE auth.users SET email = 'eversonribeiroest@outlook.com'           WHERE email = 'eversonribeiro2025@gmail.com';
UPDATE auth.users SET email = 'evertonsilvaest@outlook.com'             WHERE email = 'everton.silva@portosrio.temp.br';
UPDATE auth.users SET email = 'expeditosilvaest@outlook.com'            WHERE email = 'expeditoguimaraes247@gmail.com';
UPDATE auth.users SET email = 'fabianorochaest@outlook.com'             WHERE email = 'fabiano.pereira.rocha@gmail.com';
UPDATE auth.users SET email = 'fabiomourasantosest@outlook.com'         WHERE email = 'fabiosants555@gmail.com';
UPDATE auth.users SET email = 'fatimaazevedoest@outlook.com'            WHERE email = 'fatima.azevedo@portosrio.temp.br';
UPDATE auth.users SET email = 'fenelaassedest@outlook.com'              WHERE email = 'fenelassed@hotmail.com';
UPDATE auth.users SET email = 'fernandapachecoest@outlook.com'          WHERE email = 'feeprince19@gmail.com';
UPDATE auth.users SET email = 'fernandafernandesest@outlook.com'        WHERE email = 'fernanda.fernandes@gmail.com';
UPDATE auth.users SET email = 'fernandojuniorest@outlook.com'           WHERE email = 'fernandoboechatjr@hotmail.com';
UPDATE auth.users SET email = 'flavioconceicaoest@outlook.com'          WHERE email = 'flavioconceicao15@gmail.com';
UPDATE auth.users SET email = 'franciscomendesest@outlook.com'          WHERE email = 'fcchlcomento1954@hotmail.com';
UPDATE auth.users SET email = 'franciscoferreiraest@outlook.com'        WHERE email = 'francisconatao000@gmail.com';
UPDATE auth.users SET email = 'gabrielalvesest@outlook.com'             WHERE email = 'gcg.0014@gmail.com';
UPDATE auth.users SET email = 'gabriel_santosest@outlook.com'           WHERE email = 'gabrielcsantos234@gmail.com';
UPDATE auth.users SET email = 'gabrielmacedoest@outlook.com'            WHERE email = 'gabrielgoulartdearaujo@gmail.com';
UPDATE auth.users SET email = 'gabrielsilvaest@outlook.com'             WHERE email = 'gabpereira@gmail.com';
UPDATE auth.users SET email = 'gabrielsantosest@outlook.com'            WHERE email = 'gabivirgo128@gmail.com';
UPDATE auth.users SET email = 'gabrielahenriquesest@outlook.com'        WHERE email = 'gabizzinhahenriques@gmail.com';
UPDATE auth.users SET email = 'gabriellacastroest@outlook.com'          WHERE email = 'gabiolinda@gmail.com';
UPDATE auth.users SET email = 'gabirellasilvaest@outlook.com'           WHERE email = 'gabriella.dg2018@hotmail.com';
UPDATE auth.users SET email = 'genilsonsilvaest@outlook.com'            WHERE email = 'genilson.santos.silva@gmail.com';
UPDATE auth.users SET email = 'georgenascimentoest@outlook.com'         WHERE email = 'georgecosmenascimento@gmail.com';
UPDATE auth.users SET email = 'geovanisantosest@outlook.com'            WHERE email = 'geeh.gravessem@gmail.com';
UPDATE auth.users SET email = 'geysonsilvaest@outlook.com'              WHERE email = 'geysongramos@gmail.com';
UPDATE auth.users SET email = 'gilmargomesest@outlook.com'              WHERE email = 'gilgomesrj@gmail.com';
UPDATE auth.users SET email = 'gilsonpedroest@outlook.com'              WHERE email = 'pedrogilson2019@agmail.com';
UPDATE auth.users SET email = 'gizelesantosest@outlook.com'             WHERE email = 'gizele.conceicao.santos@gmail.com';
UPDATE auth.users SET email = 'greicesouzaest@outlook.com'              WHERE email = 'greicegov@gmail.com';
UPDATE auth.users SET email = 'gresyferreiraest@outlook.com'            WHERE email = 'gressyrenner23@gmail.com';
UPDATE auth.users SET email = 'guidopessanhaest@outlook.com'            WHERE email = 'guigas.campos@gmail.com';
UPDATE auth.users SET email = 'hannapereiraest@outlook.com'             WHERE email = 'hanna0033@gmail.com';
UPDATE auth.users SET email = 'heitorassisest@outlook.com'              WHERE email = 'heitor.assis@gmail.com';
UPDATE auth.users SET email = 'helenaribeiroest@outlook.com'            WHERE email = 'helena.ribeiro.nunes@gmail.com';
UPDATE auth.users SET email = 'henriquesilvaest@outlook.com'            WHERE email = 'henrique.soares.silva@gmail.com';
UPDATE auth.users SET email = 'hewertonsouzaest@outlook.com'            WHERE email = 'hewfer@gmail.com';
UPDATE auth.users SET email = 'heynemartinsest@outlook.com'             WHERE email = 'heynegm21@gmail.com';
UPDATE auth.users SET email = 'hugozevedoest@outlook.com'               WHERE email = 'hugo.zevedo@gmail.com';
UPDATE auth.users SET email = 'igorcamposest@outlook.com'               WHERE email = 'igorbeneditoprimeiro@gmail.com';
UPDATE auth.users SET email = 'inaragoncalvesest@outlook.com'           WHERE email = 'inara.goncalves@gmail.com';
UPDATE auth.users SET email = 'isabelasantosest@outlook.com'            WHERE email = 'isabellabarbosa034@gmail.com';
UPDATE auth.users SET email = 'itamarteixeiraest@outlook.com'           WHERE email = 'itamar.teixeira@gmail.com';
UPDATE auth.users SET email = 'jaderalmadaest@outlook.com'              WHERE email = 'jaderjuniorcordeiro@gmail.com';
UPDATE auth.users SET email = 'jailtonsouzaest@outlook.com'             WHERE email = 'lenomorais23@gmail.com';
UPDATE auth.users SET email = 'jaircunhaest@outlook.com'                WHERE email = 'jair.cunha@gmail.com';
UPDATE auth.users SET email = 'janesouzaest@outlook.com'                WHERE email = 'jane.souza@portosrio.temp.br';
UPDATE auth.users SET email = 'janegomesest@outlook.com'                WHERE email = 'jane.gomes@gmail.com';
UPDATE auth.users SET email = 'jaquelinemercamest@outlook.com'          WHERE email = 'jaquemerçam@gmail.com';
UPDATE auth.users SET email = 'jefersongomesest@outlook.com'            WHERE email = 'jefferson.alerj@gmail.com';
UPDATE auth.users SET email = 'jefersonvianaest@outlook.com'            WHERE email = 'jeferson_andre10@gmail.com';
UPDATE auth.users SET email = 'jeniffersilvaest@outlook.com'            WHERE email = 'jeniffer.silvans@gmail.com';
UPDATE auth.users SET email = 'jesserochaest@outlook.com'               WHERE email = 'jessepires12@gmail.com';
UPDATE auth.users SET email = 'jonatanfurrielest@outlook.com'           WHERE email = 'jb3772083@gmail.com';
UPDATE auth.users SET email = 'josexavierest@outlook.com'               WHERE email = 'xavierjosecarlosx@gmail.com';
UPDATE auth.users SET email = 'josegalloest@outlook.com'                WHERE email = 'zegalo000@gmail.com';
UPDATE auth.users SET email = 'josesobrinhoest@outlook.com'             WHERE email = 'jgsobrinho12@gmail.com';
UPDATE auth.users SET email = 'josedesouzaest@outlook.com'              WHERE email = 'joseraimujndo423@gmail.com';
UPDATE auth.users SET email = 'joseliasilvaest@outlook.com'             WHERE email = 'joselia.emilia.silva@gmail.com';
UPDATE auth.users SET email = 'josianepellegriniest@outlook.com'        WHERE email = 'jojopelle@gmail.com';
UPDATE auth.users SET email = 'josefariaest@outlook.com'                WHERE email = 'josefaria332@gmail.com';
UPDATE auth.users SET email = 'joycesilvaest@outlook.com'               WHERE email = 'joyce.ramosclei@gmail.com';
UPDATE auth.users SET email = 'joagomesest@outlook.com'                 WHERE email = 'joaogomesportorea@gmail.com';
UPDATE auth.users SET email = 'joaobritoest@outlook.com'                WHERE email = 'eliasbrito 123@gmail.com';
UPDATE auth.users SET email = 'joaovilelaest@outlook.com'               WHERE email = 'joaolucas.vilela@gmail.com';
UPDATE auth.users SET email = 'joaosantosest@outlook.com'               WHERE email = 'dossantosjoaovitorleandro@gmail.com';
UPDATE auth.users SET email = 'juliaaraujosest@outlook.com'             WHERE email = 'aparecidajulia3002@gmail.com';
UPDATE auth.users SET email = 'juliapontesest@outlook.com'              WHERE email = 'jucortespon@gmail.com';
UPDATE auth.users SET email = 'julianaoliveiraest@outlook.com'          WHERE email = 'juhbarrinha@gmail.com';
UPDATE auth.users SET email = 'juliogomesest@outlook.com'               WHERE email = 'falarcomjuliogomes@gmail.com';
UPDATE auth.users SET email = 'jurandirbrandaoest@outlook.com'          WHERE email = 'jurandimatos000@gmail.com';
UPDATE auth.users SET email = 'katiapinheiroest@outlook.com'            WHERE email = 'katiapinheiro1986@gmail.com';
UPDATE auth.users SET email = 'kauansouzaest@outlook.com'               WHERE email = 'kaupinheiro@gmail.com';
UPDATE auth.users SET email = 'kellysouzaest@outlook.com'               WHERE email = 'kellygomesmonteiro3@gmail.com';
UPDATE auth.users SET email = 'kellycanustest@outlook.com'              WHERE email = 'kelly.lucia.benvindo.batista.canust@gmail.com';
UPDATE auth.users SET email = 'lairasoaresest@outlook.com'              WHERE email = 'lairacristina915@gmail.com';
UPDATE auth.users SET email = 'laizagilest@outlook.com'                 WHERE email = 'laiza.vellozo@icloud.com';
UPDATE auth.users SET email = 'larissapessanhaest@outlook.com'          WHERE email = 'laripessanha@gmail.com';
UPDATE auth.users SET email = 'leandrotiagoest@outlook.com'             WHERE email = 'leandro.goncalves.tiago@gmail.com';
UPDATE auth.users SET email = 'pr.sperendio@gmail.com'                  WHERE email = 'pr.sperendio@gnail.com';
UPDATE auth.users SET email = 'leonardomoreiraest@outlook.com'          WHERE email = 'leonardobmoreira@live.com';
UPDATE auth.users SET email = 'leonardobarbosaest@outlook.com'          WHERE email = 'leonardo06barbosa@gmail.com';
UPDATE auth.users SET email = 'leticiaguilhermeest@outlook.com'         WHERE email = 'leticiia.silva2505@gmail.com';
UPDATE auth.users SET email = 'lidianegomesest@outlook.com'             WHERE email = 'lidiane.alencar.ponce.gomes@gmail.com';
UPDATE auth.users SET email = 'lidianemoreireaest@outlook.com'          WHERE email = 'lidiane.santos.moreira@gmail.com';
UPDATE auth.users SET email = 'liviasouzaest@outlook.com'               WHERE email = 'liviasouza2110@gmail.com';
UPDATE auth.users SET email = 'livycostaest@outlook.com'                WHERE email = 'livyadiniz8@gmail.com';
UPDATE auth.users SET email = 'lorranrodriguesest@outlook.com'          WHERE email = 'lorranrodrigues4@gmail.com';
UPDATE auth.users SET email = 'lorransouzaest@outlook.com'              WHERE email = 'lorranagomes.adv@amail.com';
UPDATE auth.users SET email = 'luanaprazeresest@outlook.com'            WHERE email = 'luana.prazeres@portosrio.temp.br';
UPDATE auth.users SET email = 'lucassouzaest@outlook.com'               WHERE email = 'lucasolisouzapj@gmail.com';
UPDATE auth.users SET email = 'lucassilvaest@outlook.com'               WHERE email = 'lucas.ferreira.silva@gmail.com';
UPDATE auth.users SET email = 'lucas_santosest@outlook.com'             WHERE email = 'lucassantos@gmail.com';
UPDATE auth.users SET email = 'lucasperesest@outlook.com'               WHERE email = 'lucasrangelgomesperes@gmail.com';
UPDATE auth.users SET email = 'lucilenebarbosaest@outlook.com'          WHERE email = 'lucilene.barbosa@portosrio.temp.br';
UPDATE auth.users SET email = 'luismarquesest@outlook.com'              WHERE email = 'luisnovellinomarques@gmail.com';
UPDATE auth.users SET email = 'luispereiraest@outlook.com'              WHERE email = 'luisotaviogomespereira1234@hotmail.com';
UPDATE auth.users SET email = 'luizsantosest@outlook.com'               WHERE email = 'luiztimbauba82@gmail.com';
UPDATE auth.users SET email = 'maiconsoaresest@outlook.com'             WHERE email = 'maicon.soares91@gmail.com';
UPDATE auth.users SET email = 'maracostaest@outlook.com'                WHERE email = 'maracriatinalaura@gmail.com';
UPDATE auth.users SET email = 'marceltavaresest@outlook.com'            WHERE email = 'marcel.correa@hotmail.com';
UPDATE auth.users SET email = 'marcelobaptistaest@outlook.com'          WHERE email = 'marcelocamposdas@gmail.com';
UPDATE auth.users SET email = 'marcelovieiraest@outlook.com'            WHERE email = 'marceeva643@gmail.com';
UPDATE auth.users SET email = 'marcelolamenhaest@outlook.com'           WHERE email = 'diretormegamix@gmail.co';
UPDATE auth.users SET email = 'marciasouzaest@outlook.com'              WHERE email = 'marciaferreira.1805@gmail.com';
UPDATE auth.users SET email = 'marciafrazaoest@outlook.com'             WHERE email = 'marciavictorfrazao@gmail.com';
UPDATE auth.users SET email = 'marciomunizest@outlook.com'              WHERE email = 'marcio.muniz@portosrio.temp.br';
UPDATE auth.users SET email = 'marcopaesest@outlook.com'                WHERE email = 'marcoantonio.paes@gmail.com';
UPDATE auth.users SET email = 'marcossilvaest@outlook.com'              WHERE email = 'mabbarros@yahoo.com.br';
UPDATE auth.users SET email = 'marcosfelixest@outlook.com'              WHERE email = 'marcosfelix452023@gmail.com';
UPDATE auth.users SET email = 'marcossoaresest@outlook.com'             WHERE email = 'marcospeixotosoaresp@gmail.com';
UPDATE auth.users SET email = 'marcussouzaest@outlook.com'              WHERE email = 'mvsouzapinturas3@gmail.com';
UPDATE auth.users SET email = 'mariaaparecidaest@outlook.com'           WHERE email = 'lizacamylle@hotmail.com';
UPDATE auth.users SET email = 'marianaalmeidaest@outlook.com'           WHERE email = 'mariaalmeida 123@gmail.com';
UPDATE auth.users SET email = 'mariadesouzaest@outlook.com'             WHERE email = 'mariaaahcalvacanti234@gmail.com';
UPDATE auth.users SET email = 'marialimaest@outlook.com'                WHERE email = 'mariacleiderj@gmail.com';
UPDATE auth.users SET email = 'mariapereiraest@outlook.com'             WHERE email = 'msoarespereira19@gmail.com';
UPDATE auth.users SET email = 'mariaeduardaliraest@outlook.com'         WHERE email = 'pablocontagp@gmail.com';
UPDATE auth.users SET email = 'mariavalentimest@outlook.com'            WHERE email = 'mariasilvavalentim19@gmail.com';
UPDATE auth.users SET email = 'marianavieiraest@outlook.com'            WHERE email = 'marianaveira000@gmail.com';
UPDATE auth.users SET email = 'marianafariaest@outlook.com'             WHERE email = 'marianafarias3110@gmail.com';
UPDATE auth.users SET email = 'marloncoelhoest@outlook.com'             WHERE email = 'marlon1coelho1234@gmail.com';
UPDATE auth.users SET email = 'mateusteixeiraest@outlook.com'           WHERE email = 'mateus.vieira.teixeira@gmail.com';
UPDATE auth.users SET email = 'matheusquintalest@outlook.com'           WHERE email = 'matheus.quintal@portosrio.temp.br';
UPDATE auth.users SET email = 'matheusalmeidaest@outlook.com'           WHERE email = 'matheusstellet922@gmail.com';
UPDATE auth.users SET email = 'maxsleisilvaest@outlook.com'             WHERE email = 'omaxslei@gmail.com';
UPDATE auth.users SET email = 'maxuelsilvaest@outlook.com'              WHERE email = 'maxwellmariadasilva@gmail.com';
UPDATE auth.users SET email = 'mayconsilvaest@outlook.com'              WHERE email = 'maycon.senra@hotmail.com';
UPDATE auth.users SET email = 'milenapereiraest@outlook.com'            WHERE email = 'millenariopsi@gmail.com';
UPDATE auth.users SET email = 'moacirfilhoest@outlook.com'              WHERE email = 'moacirfilho10@gmail.com';
UPDATE auth.users SET email = 'murilovieiraest@outlook.com'             WHERE email = 'murilovieira10@hotmail.com';
UPDATE auth.users SET email = 'nathalibarrosest@outlook.com'            WHERE email = 'nathalicsbarros@gmail.com';
UPDATE auth.users SET email = 'nathaliavalenteest@outlook.com'          WHERE email = 'nathaliadasilvavalente2020@gmail.com';
UPDATE auth.users SET email = 'nathaliafrancelinoest@outlook.com'       WHERE email = 'nathaliafrancelino1@gmail.com';
UPDATE auth.users SET email = 'nathaliaoliveiraest@outlook.com'         WHERE email = 'nathalia.sperendio.oliveira@gmail.com';
UPDATE auth.users SET email = 'nathiellyfreitasest@outlook.com'         WHERE email = 'nathielly.sophi/2gmail.com';
UPDATE auth.users SET email = 'nubiaestevaoest@outlook.com'             WHERE email = 'nubia.estevao@gmail.com';
UPDATE auth.users SET email = 'osirisjuniorest@outlook.com'             WHERE email = 'osirisamaral7@gmail.com';
UPDATE auth.users SET email = 'osmarjuniorest@outlook.com'              WHERE email = 'osfer@gmail.com';
UPDATE auth.users SET email = 'ostayrfilhoest@outlook.com'              WHERE email = 'ostairferreira@gmail.com';
UPDATE auth.users SET email = 'pablooliveiraest@outlook.com'            WHERE email = 'pablorhuanbuffa@gmail.com';
UPDATE auth.users SET email = 'paolasilvaest@otutlook.com'              WHERE email = 'castilhopaola373@gmail.com';
UPDATE auth.users SET email = 'paulosilvaest@outlook.com'               WHERE email = 'paulo.carvalho.silva@gmail.com';
UPDATE auth.users SET email = 'petersonrochaest@outlook.com'            WHERE email = 'peterson212709@gmail.com';
UPDATE auth.users SET email = 'polyanarangelest@outlook.com'            WHERE email = '22997958734pae@gmail.com';
UPDATE auth.users SET email = 'priscillagamaest@outlook.com'            WHERE email = 'priscilla.gama@portosrio.temp.br';
UPDATE auth.users SET email = 'rafaelribeiroest@outlook.com'            WHERE email = 'rafael.dias.ribeiro@gmail.com';
UPDATE auth.users SET email = 'rafael_limaest@outlook.com'              WHERE email = 'rafaoliveiralima07@gmail.com';
UPDATE auth.users SET email = 'raianeoliveiraest@outlook.com'           WHERE email = 'pedroregisgato0508@gmail.com';
UPDATE auth.users SET email = 'raimundosouzaest@outlook.com'            WHERE email = 'raimundononatodesouza199@gmail.com';
UPDATE auth.users SET email = 'raissabritoest@outlook.com'              WHERE email = 'raissabrito680@gmail.com';
UPDATE auth.users SET email = 'raquelsilvaest@outlook.com'              WHERE email = 'raquelcorrea55@gmail.com';
UPDATE auth.users SET email = 'raulnascimentoest@outlook.com'           WHERE email = 'raul.nascimento@gmail.com';
UPDATE auth.users SET email = 'reginaldosilvaest@outlook.com'           WHERE email = 'reginaldovalentim050@gmail.com';
UPDATE auth.users SET email = 'renatasouzaest@outlook.com'              WHERE email = 'souzarenata321@gmail.com';
UPDATE auth.users SET email = 'richardisonbragaest@outlook.com'         WHERE email = 'richardison.ri@hotmail.com';
UPDATE auth.users SET email = 'rodrigonascimentoest@outlook.com'        WHERE email = 'rn06456@gmail.com';
UPDATE auth.users SET email = 'rogeriosilvaest@outlook.com'             WHERE email = 'rogerio.jose.silva@gmail.com';
UPDATE auth.users SET email = 'roldineyterrasonest@outlook.com'         WHERE email = 'roldiney.terrason@gmail.com';
UPDATE auth.users SET email = 'rosanachaimest@outlook.com'              WHERE email = 'rosanaamaral184@gmail.com';
UPDATE auth.users SET email = 'sandrasouzaest@outlook.com'              WHERE email = 'sanfreitas@gmail.com';
UPDATE auth.users SET email = 'sandradejesusest@outlook.com'            WHERE email = 'sandra.rosa.santana.jesus@gmail.com';
UPDATE auth.users SET email = 'sergioalencarest@outlook.com'            WHERE email = 'sergio.alves.ceda@gmail.com';
UPDATE auth.users SET email = 'sergioseverianoest@outlook.com'          WHERE email = 'sfseveriano@hotmail.com';
UPDATE auth.users SET email = 'sergiooliveiraest@outlook.com'           WHERE email = 'nerysergioso@hotmail.com';
UPDATE auth.users SET email = 'silvaniconceicaoest@outlook.com'         WHERE email = 'silvani.maria25@gmail.com';
UPDATE auth.users SET email = 'silviamacielest@outlook.com'             WHERE email = 'smatrb.maciel@gmail.com';
UPDATE auth.users SET email = 'silviosouzaest@outlook.com'              WHERE email = 'silvio.santos.souza@gmail.com';
UPDATE auth.users SET email = 'simoneabreuest@outlook.com'              WHERE email = 'simone.aparecida.menezes.abreu@gmail.com';
UPDATE auth.users SET email = 'simoneteixeiraest@outlook.com'           WHERE email = 'simone.regina.teixeira@gmail.com';
UPDATE auth.users SET email = 'soratoandreest@outlook.com'              WHERE email = 'sornandes@gmail.com';
UPDATE auth.users SET email = 'suelenoliveiraest@outlook.com'           WHERE email = 'suelen.maisa.lipe@gmail.com';
UPDATE auth.users SET email = 'suelidamaest@outlook.com'                WHERE email = 'smirandadama@gmail.com';
UPDATE auth.users SET email = 'suzelanepaulaest@outlook.com'            WHERE email = 'suzelane.macario.barros.paula@gmail.com';
UPDATE auth.users SET email = 'soniawerneckest@outlook.com'             WHERE email = 'soaniawerneck05@gmail.com';
UPDATE auth.users SET email = 'taisevieiraest@outlook.com'              WHERE email = 'taise.cavallieri@gmail.com';
UPDATE auth.users SET email = 'talitasantosest@outlook.com'             WHERE email = 'tsreserva.1@gmail.com';
UPDATE auth.users SET email = 'tatianarodriguesest@outlook.com'         WHERE email = 'lindinhatatiana06@gmail.com';
UPDATE auth.users SET email = 'tatianemotaest@outlook.com'              WHERE email = 'tatiane.nunes.mota@gmail.com';
UPDATE auth.users SET email = 'thiagosouzaest@outlook.com'              WHERE email = 'thdomingoss022@gmail.com';
UPDATE auth.users SET email = 'tiagosilvaest@outlook.com'               WHERE email = 'titimacuco@gmail.com';
UPDATE auth.users SET email = 'valdecirmadeiraest@outlook.com'          WHERE email = 'valdecir.madeira@portosrio.temp.br';
UPDATE auth.users SET email = 'valeriasilvaest@outlook.com'             WHERE email = 'valeria.machado.silva@gmail.com';
UPDATE auth.users SET email = 'valeriasouzaest@outlook.com'             WHERE email = 'floridovaleria66@gmail.com';
UPDATE auth.users SET email = 'vanderleisouzaest@outlook.com'           WHERE email = 'vanderlei.correa789@gmail.com';
UPDATE auth.users SET email = 'vanderleyalvesest@outlook.com'           WHERE email = 'vanderleyronan@gmail.com';
UPDATE auth.users SET email = 'victormoraesest@outlook.com'             WHERE email = 'victor.moraes@portosrio.temp.br';
UPDATE auth.users SET email = 'victorsilvaest@outlook.com'              WHERE email = 'victorocs@gmail.com';
UPDATE auth.users SET email = 'virgiliopereiraest@outlook.com'          WHERE email = 'virgilio.panissolo.pereira@gmail.com';
UPDATE auth.users SET email = 'virgmonteiroest@outlook.com'             WHERE email = 'vvjales@gmail.com';
UPDATE auth.users SET email = 'vitorsantosest@outlook.com'              WHERE email = 'vitorcorreafotografo@gmail.com';
UPDATE auth.users SET email = 'vitorsilvaest@outlook.com'               WHERE email = 'vhcruz2003@gmail.com';
UPDATE auth.users SET email = 'vitoriasouzaest@outlook.com'             WHERE email = 'vitoriamontes58@gmail.com';
UPDATE auth.users SET email = 'vivianerodriguesest@outlook.com'         WHERE email = 'ivianeangelidarodrigues@gmail.com';
UPDATE auth.users SET email = 'wallacemoreiraest@outlook.com'           WHERE email = 'sodanii@yahoo.com.br';
UPDATE auth.users SET email = 'walteralvesest@outlook.com'              WHERE email = 'vitrini123alves@hotmail.com';
UPDATE auth.users SET email = 'warloncarvalhoest@outlook.com'           WHERE email = 'warlocarvalhosumi@gmail.com';
UPDATE auth.users SET email = 'websonsantosest@outlook.com'             WHERE email = 'webson.silva.santos1@gmail.com';
UPDATE auth.users SET email = 'wellingtonoliveiraest@outlook.com'       WHERE email = 'wellingtonwado160@gmail.com';
UPDATE auth.users SET email = 'wellingtonlimaest@outlook.com'           WHERE email = 'w.lacerda2028@gmail.com';
UPDATE auth.users SET email = 'willianalencarest@outlook.com'           WHERE email = 'alencarsilva369@gmail.com';
UPDATE auth.users SET email = 'wilsonfrancaest@outlook.com'             WHERE email = 'wilsonfranca555@gmail.com';
UPDATE auth.users SET email = 'yurilopesest@outlook.com'                WHERE email = 'yuridesousatelleslopes@gmail.com';
UPDATE auth.users SET email = 'alvaroleixasest@outlook.com'             WHERE email = 'alvari@gmail.com';
UPDATE auth.users SET email = 'isacsalesest@outlook.com'                WHERE email = 'isac.sales@gmail.com';
UPDATE auth.users SET email = 'josesilvaest@outlook.com'                WHERE email = 'JOSEERIVA@GMAIL.COM';
UPDATE auth.users SET email = 'mauricioteixeiraest@outlook.com'         WHERE email = 'JRDOPULAPULA2248@GMAIL.COM';
