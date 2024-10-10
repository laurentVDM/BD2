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
    email varchar (100) UNIQUE NOT NULL CHECK ( email SIMILAR TO '%@student.vinci.be' ),
    mdp varchar(50) NOT NULL CHECK ( mdp <> '' )

);

CREATE TABLE projet.projets(
    code_projet char(15) PRIMARY KEY,
    nom varchar(50) NOT NULL CHECK ( nom <> '' ),
    date_debut DATE NOT NULL DEFAULT ( current_date ),             -- DATE FORMAT AAAA-MM-JJ
    date_fin DATE NOT NULL CHECK ( date_fin > date_debut ),
    nbr_groupes INTEGER NOT NULL DEFAULT ( 0 ),
    cours char(8) NOT NULL REFERENCES projet.cours( code_cours )
);

CREATE TABLE projet.groupes(
    num_groupe INTEGER NOT NULL,
    projet char(15) NOT NULL REFERENCES projet.projets( code_projet ),
    PRIMARY KEY ( num_groupe, projet ),
    nbr_place_groupe INTEGER NOT NULL CHECK ( nbr_place_groupe > 1 ),
    valide bool NOT NULL DEFAULT ( FALSE ),
    nbr_membres INTEGER NOT NULL DEFAULT ( 0 )
);

CREATE TABLE projet.inscriptions_cours(
    cours CHAR(50) NOT NULL REFERENCES projet.cours( code_cours ),
    email_etudiant varchar(100) NOT NULL REFERENCES projet.etudiants( email ),
    PRIMARY KEY ( cours, email_etudiant )
);

CREATE TABLE projet.inscriptions_groupe(
    num_groupe INTEGER NOT NULL,
    projet char(15) NOT NULL,
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

INSERT INTO projet.inscriptions_cours VALUES ( 'BINV2040', 'laurent.vandermeersch@student.vinci.be' );
INSERT INTO projet.inscriptions_cours VALUES ( 'BINV2040', 'ibrahim.bekkari@student.vinci.be' );
INSERT INTO projet.inscriptions_cours VALUES ( 'BINV2040', 'christophe.damas@student.vinci.be' );

INSERT INTO projet.projets VALUES ( 'PROJ00000000000', 'projet sql', DEFAULT, '2022-12-10', 10, 'BINV2040' );
INSERT INTO projet.projets VALUES ( 'PROJ00000000010', 'projet java', DEFAULT, '2022-12-10', 10, 'BINV2130' );
--
-- ATTENTION, VERIFIER QUE NUM_GROUPE NE DOIT PAS ETRE DEFAULT ET PAS 1
--
INSERT INTO projet.groupes VALUES ( 1, 'PROJ00000000000', 2, DEFAULT, DEFAULT );
INSERT INTO projet.groupes VALUES ( 2, 'PROJ00000000000', 2, TRUE, 2 );

INSERT INTO projet.inscriptions_groupe VALUES ( 2, 'PROJ00000000000', 1);
INSERT INTO projet.inscriptions_groupe VALUES ( 2, 'PROJ00000000000', 2);

--APPLICATION CENTRALE
-- 1) ajouter cours
CREATE OR REPLACE FUNCTION projet.ajouterCours(_code_cours char(8), _nom varchar(50), _nbr_credit integer, _bloc integer ) RETURNS CHAR AS $$
    DECLARE
        _cours char(8):= ' ';
    BEGIN
        IF EXISTS(
            SELECT c.code_cours
            FROM projet.cours c
            WHERE c.code_cours = _code_cours
        ) THEN RAISE 'Cours existant';
        END IF;
        INSERT INTO projet.cours VALUES(_code_cours, _nom, _nbr_credit, _bloc)
            RETURNING _code_cours INTO _cours;
        RETURN _code_cours;
        END;
$$ LANGUAGE plpgsql;

--2) ajouter Etudiant
CREATE OR REPLACE FUNCTION projet.ajouterEtudiant(_nom varchar(50), _prenom varchar(50), _email varchar(100), _mdp varchar(50)) RETURNS INTEGER AS $$
DECLARE
    _id INTEGER :=0;
BEGIN
    IF EXISTS(
        SELECT e.email
        FROM projet.etudiants e
        WHERE e.email = _email
        ) THEN RAISE 'adresse mail deja utilisee';
    END IF;
    INSERT INTO projet.etudiants VALUES (DEFAULT, _nom, _prenom, _email, _mdp)
        RETURNING id_etudiant INTO _id;
    RETURN _id;
END;
$$ LANGUAGE plpgsql;

--test 2 )ajout etudiant
--SELECT projet.ajouterEtudiant('stephanie', 'ferneeuw', 'stephanie.ferneeuw@student.vinci.be', 'mdp');


--3) inscrire etudiant a un cours
CREATE OR REPLACE FUNCTION projet.insciptionAuCours(_code_cours char(8), _email_etudiant varchar(100)) RETURNS RECORD AS $$
DECLARE
    _sortie RECORD;
BEGIN
    IF EXISTS(
        SELECT cours, email_etudiant
        FROM projet.inscriptions_cours
        WHERE cours = _code_cours
        AND email_etudiant = _email_etudiant
        ) THEN RAISE 'etudiant deja inscrit au cours';
    END IF;
IF EXISTS(
    SELECT p.code_projet
    FROM projet.projets p
    WHERE p.cours = _code_cours
    ) THEN RAISE 'il existe un projet pour ce cours, inscription impossible';
END IF;

    INSERT INTO projet.inscriptions_cours VALUES (_code_cours, _email_etudiant)
        RETURNING _code_cours, _email_etudiant INTO _sortie;
 --SELECT _cours, _email  INTO _sortie;
    RETURN _sortie;
END;
$$ LANGUAGE plpgsql;

--test 3) inscription cours
--SELECT projet.insciptionAuCours('BINV2130', 'laurent.vandermeersch@student.vinci.be');


--4) ajouter un projet a un cours
CREATE OR REPLACE FUNCTION projet.ajouterProjet(_code_projet char(15), _nom varchar(50), _date_debut DATE, _date_fin DATE,
    _nbr_groupes INTEGER, _cours char(8)) RETURNS char(15) AS $$
DECLARE
    -- DATE FORMAT AAAA-MM-JJ
    _char char(15) :='';
BEGIN
    IF EXISTS(
        SELECT p.code_projet
        FROM projet.projets p
        WHERE p.code_projet = _code_projet
        ) THEN RAISE 'code de projet deja existant';
    END IF;
    IF NOT EXISTS(
        SELECT c.code_cours
        FROM projet.cours c
        WHERE c.code_cours = _cours
        ) THEN RAISE 'il n existe pas de cours correspondant';
    END IF;
    INSERT INTO projet.projets VALUES (_code_projet, _nom, _date_debut, _date_fin , _nbr_groupes , _cours )
        RETURNING _code_projet INTO _char;
    RETURN _char;
END;
$$ LANGUAGE plpgsql;

--test 4)
SELECT projet.ajouterProjet('PROJ00000000001', 'projet sql', '2022-12-9', '2022-12-10', 10, 'BINV2040')

--APPLICATION ETUDIANT

--check format email

--6)
CREATE OR REPLACE FUNCTION projet.afficherProjetsParCours(_code_cours char(8)) RETURNS varchar AS $$
DECLARE
    _projet RECORD ;
    _sep varchar := '';
    _sortie varchar := '';
BEGIN
    IF NOT EXISTS(SELECT c.code_cours
        FROM projet.cours c, projet.projets p
        WHERE p.cours = c.code_cours
        AND c.code_cours = _code_cours)
    THEN _sortie = 'pas encore de projet';
    RETURN _sortie;
    END IF;
        FOR _projet in
            SELECT p.code_projet
            FROM projet.cours c, projet.projets p
            WHERE p.cours = c.code_cours
            AND c.code_cours = _code_cours
        LOOP
            _sortie:= _sortie || _sep || _projet.code_projet;
            _sep := ', ';
        END LOOP;
    RETURN _sortie;
END;
$$ LANGUAGE plpgsql;

-- 6)
-- afficher les cours

CREATE VIEW projet.afficherCours AS
    SELECT DISTINCT c.code_cours AS "code_cours", c.nom AS "nom", projet.afficherProjetsParCours(c.code_cours) AS "projets"
        FROM projet.cours c LEFT OUTER JOIN projet.projets p ON p.cours = c.code_cours;

--test 6)
--SELECT * FROM projet.afficherProjetsParCours('BINV4040');
SELECT * FROM projet.afficherCours;




