--cours
INSERT INTO projet.cours VALUES ('BINV2040', 'BD2', 6, 2 );
INSERT INTO projet.cours VALUES ('BINV1020', 'APOO', 6, 1 );
--etudiants
INSERT INTO projet.etudiants VALUES ( DEFAULT, 'damas', 'christophe', 'cd@student.vinci.be',
                                     '$2a$10$P8iktWWGCHLKCiCZtyk.n.nldkfoKNgyRqsGPpp79lvz8H8MpmIhi' );  --mdp = 'mdp'
INSERT INTO projet.etudiants VALUES ( DEFAULT, 'ferneeuw', 'stephanie', 'sf@student.vinci.be',
                                     '$2a$10$P8iktWWGCHLKCiCZtyk.n.nldkfoKNgyRqsGPpp79lvz8H8MpmIhi' );  --mdp = 'mdp'
--inscription bd2
INSERT INTO projet.inscriptions_cours VALUES ( 'BINV2040', 'cd@student.vinci.be' );
INSERT INTO projet.inscriptions_cours VALUES ( 'BINV2040', 'sf@student.vinci.be' );
--projets dans bd2
INSERT INTO projet.projets VALUES ( 'projSQL', 'projet SQL', '2023-09-10', '2023-12-15', 10, 'BINV2040' );
INSERT INTO projet.projets VALUES ( 'dsd', 'DSD', '2023-09-30', '2023-12-1', 10, 'BINV2040');
--ajout de 1 groupe vide de 2 etudiants a projSQL
INSERT INTO projet.groupes VALUES ( 1, 'projSQL', 2, false, 0);

--test
--SELECT projet.afficherGroupes('projSQL');

