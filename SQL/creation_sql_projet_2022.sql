DROP SCHEMA IF EXISTS projet CASCADE;

CREATE SCHEMA projet;

--TABLES

CREATE TABLE projet.cours(
    code_cours CHAR(8) PRIMARY KEY CHECK ( code_cours SIMILAR TO 'BINV[0-9][0-9][0-9][0-9]' ),
    nom varchar(50) NOT NULL CHECK( nom <> '' ),
    nbr_credits INTEGER NOT NULL CHECK ( nbr_credits > 0 ),
    bloc INTEGER NOT NULL CHECK ( bloc >= 1 AND bloc <= 3 )
);

CREATE TABLE projet.etudiants(
    id_etudiant serial PRIMARY KEY,
    nom varchar(50) NOT NULL CHECK ( nom <> '' ),
    prenom varchar(50) NOT NULL CHECK ( prenom <> '' ),
    email varchar (100) NOT NULL CHECK ( email SIMILAR TO '%@student.vinci.be' ),
    mdp varchar(50) NOT NULL CHECK ( mdp <> '' )

);

CREATE TABLE projet.projets(
    id_projet serial PRIMARY KEY,
    nom varchar(50) NOT NULL CHECK ( nom <> '' ),
    date_debut DATE NOT NULL DEFAULT ( current_date ),             -- DATE FORMAT AAAA-MM-JJ
    date_fin DATE NOT NULL CHECK ( date_fin > date_debut ),
    nbr_groupes INTEGER NOT NULL DEFAULT ( 0 ),
    cours char(8) NOT NULL REFERENCES projet.cours( code_cours )
);

CREATE TABLE projet.groupes(
    num_groupe INTEGER NOT NULL,
    projet INTEGER NOT NULL REFERENCES projet.projets( id_projet ),
    PRIMARY KEY ( num_groupe, projet ),
    nbr_place_groupe INTEGER NOT NULL CHECK ( nbr_place_groupe > 1 ),
    valide bool NOT NULL DEFAULT ( FALSE ),
    nbr_membres INTEGER NOT NULL DEFAULT ( 0 )
);

CREATE TABLE projet.inscriptions_cours(
    cours CHAR(50) NOT NULL REFERENCES projet.cours( code_cours ),
    etudiant INTEGER NOT NULL REFERENCES projet.etudiants( id_etudiant ),
    PRIMARY KEY ( cours,etudiant )
);

CREATE TABLE projet.inscriptions_groupe(
    num_groupe INTEGER NOT NULL,
    projet INTEGER NOT NULL,
    etudiant INTEGER NOT NULL REFERENCES projet.etudiants( id_etudiant ),
    PRIMARY KEY ( num_groupe, projet, etudiant ),
    FOREIGN KEY ( num_groupe, projet ) REFERENCES projet.groupes( num_groupe, projet )
);

--INSERTS

INSERT INTO projet.etudiants VALUES ( DEFAULT, 'Vandermeersch', 'laurent', 'laurent.vandermeersch@student.vinci.be', 'mdp' );
INSERT INTO projet.etudiants VALUES ( DEFAULT, 'Bekkari', 'ibrahim', 'ibrahim.bekkari@student.vinci.be', 'mdp' );
INSERT INTO projet.etudiants VALUES ( DEFAULT, 'Damas', 'christophe', 'christophe.damas@student.vinci.be', 'mdp' );

INSERT INTO projet.cours VALUES ( 'BINV2040', 'Gestion de donnees', 6, 2 );
INSERT INTO projet.cours VALUES ( 'BINV2080', 'Organisation des entreprises', 6, 2 );
INSERT INTO projet.cours VALUES ( 'BINV2130', 'Programmation java avance', 5, 2 );

INSERT INTO projet.inscriptions_cours VALUES ( 'BINV2040', 3 );
INSERT INTO projet.inscriptions_cours VALUES ( 'BINV2040', 2 );
INSERT INTO projet.inscriptions_cours VALUES ( 'BINV2040', 1 );

INSERT INTO projet.projets VALUES ( DEFAULT, 'projet sql', DEFAULT, '2022-12-10', 10, 'BINV2040' );
--
-- ATTENTION, VERIFIER QUE NUM_GROUPE NE DOIT PAS ETRE DEFAULT ET PAS 1
--
INSERT INTO projet.groupes VALUES ( 1, 1, 2, DEFAULT, DEFAULT );
INSERT INTO projet.groupes VALUES ( 2, 1, 2, TRUE, 2 );

INSERT INTO projet.inscriptions_groupe VALUES ( 2, 1, 1);
INSERT INTO projet.inscriptions_groupe VALUES ( 2, 1, 2);

--APPLICATION CENTRALE
--1 ajouter Etudiant




--APPLICATION ETUDIANT



