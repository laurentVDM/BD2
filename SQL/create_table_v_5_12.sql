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
    mdp varchar(60) NOT NULL CHECK ( mdp <> '' )

);

CREATE TABLE projet.projets(
    code_projet varchar(50) PRIMARY KEY ,
    nom varchar(50) NOT NULL CHECK ( nom <> '' ),
    date_debut DATE NOT NULL DEFAULT ( current_date ),             -- DATE FORMAT AAAA-MM-JJ
    date_fin DATE NOT NULL CHECK ( date_fin > date_debut ),
    nbr_groupes INTEGER NOT NULL DEFAULT ( 0 ),
    cours char(8) NOT NULL REFERENCES projet.cours( code_cours )
);

CREATE TABLE projet.groupes(
    num_groupe INTEGER NOT NULL,
    projet varchar(50) NOT NULL REFERENCES projet.projets( code_projet ),
    PRIMARY KEY ( num_groupe, projet ),
    nbr_place_groupe INTEGER NOT NULL CHECK ( nbr_place_groupe > 1 ),
    valide bool NOT NULL DEFAULT ( FALSE ),
    nbr_membres INTEGER NOT NULL DEFAULT ( 0 )
);

CREATE TABLE projet.inscriptions_cours(
    cours char(50) NOT NULL REFERENCES projet.cours( code_cours ),
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


--APPLICATION CENTRALE
-- 1) ajouter cours
CREATE OR REPLACE FUNCTION projet.ajouterCours(_code_cours char(8), _nom varchar(50), _nbr_credit integer, _bloc integer ) RETURNS char AS $$
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
CREATE OR REPLACE FUNCTION projet.ajouterEtudiant(_nom varchar(50), _prenom varchar(50), _email varchar(100), _mdp varchar(60)) RETURNS INTEGER AS $$
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

--4) ajouter un projet a un cours
CREATE OR REPLACE FUNCTION projet.ajouterProjet(_code_projet varchar(50), _nom varchar(50), _date_debut DATE, _date_fin DATE,
    _nbr_groupes INTEGER, _cours char(8)) RETURNS varchar(50) AS $$
DECLARE
    -- DATE FORMAT AAAA-MM-JJ
    _varchar varchar(50) :='';
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
        RETURNING _code_projet INTO _varchar;
    RETURN _varchar;
END;
$$ LANGUAGE plpgsql;

--5)


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


--7)

CREATE OR REPLACE FUNCTION projet.countGroupesValides(_code_projet char(8)) RETURNS INTEGER AS $$
DECLARE
    _count integer :=0;
BEGIN
    SELECT count(g.num_groupe)
    FROM projet.projets p LEFT OUTER JOIN projet.groupes g ON g.projet = p.code_projet
    WHERE p.code_projet = _code_projet
    AND g.valide = true INTO _count;
    RETURN _count;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION projet.countGroupesComplets(_code_projet char(8)) RETURNS INTEGER AS $$
DECLARE
    _count integer :=0;
BEGIN
    SELECT count(g.num_groupe)
    FROM projet.projets p LEFT OUTER JOIN projet.groupes g ON g.projet = p.code_projet
    WHERE p.code_projet = _code_projet
    AND g.nbr_place_groupe = g.nbr_membres INTO _count;
    RETURN _count;
END;
$$ LANGUAGE plpgsql;

--7)
-- afficher les projets
CREATE VIEW projet.afficherProjet AS
    SELECT p.code_projet AS "code_projet", p.nom AS "nom", p.cours AS "code cours",
           count(g.num_groupe) AS "nbr groupes", projet.countGroupesValides(p.code_projet) AS "nbr groupes valides",
           projet.countGroupesComplets(p.code_projet) AS "nbr groupes complets"
    FROM projet.projets p LEFT OUTER JOIN projet.groupes g ON g.projet = p.code_projet
    GROUP BY p.code_projet, p.nom, p.cours;

--8)
--Visualiser toutes les compositions de groupe d’un projet (en donnant l’identifiant de projet).
--Les résultats seront affichés sur 5 colonnes. On affichera le numéro de groupe, le nom et prénom de l’étudiant,
-- si le groupe est complet, et si le groupe a été validé. Tous les numéros de groupe doivent apparaître même si les
-- groupes correspondants sont vides. SI un groupe est vide, on affichera null pour le nom et prénom de l’étudiant.
-- Les résultats seront triés par numéro de groupe

CREATE OR REPLACE FUNCTION projet.afficherGroupes(_code_projet varchar(50)) RETURNS SETOF RECORD AS $$
DECLARE
    _num_groupe integer;
    _nom_etudiant varchar(50);
    _prenom_etudiant varchar(50);
    _est_complet bool := false;
    _est_valide bool := false;
    _ligne_sortie RECORD;
BEGIN
    FOR _num_groupe in
        SELECT g.projet
        FROM projet.groupes g, projet.inscriptions_groupe ig
        WHERE g.projet = _code_projet
        AND ig.projet = g.projet
    LOOP

    END LOOP;
    IF NOT EXISTS(
        SELECT ig.etudiant
        FROM projet.inscriptions_groupe ig, projet.groupes g
        WHERE g.num_groupe = ig.num_groupe
        AND g.projet = ig.projet
        ) THEN _nom_etudiant = 'null' AND _prenom_etudiant = 'null' AND _est_complet = FALSE AND _est_valide = FALSE;
    END IF;

    SELECT _num_groupe, _nom_etudiant, _prenom_etudiant, _est_complet,  _est_valide INTO _ligne_sortie;
    RETURN NEXT _ligne_sortie;

END;
$$ LANGUAGE plpgsql;




--9) valider un groupe
CREATE OR REPLACE FUNCTION projet.validerGroupe( _num_groupe INTEGER, _code_projet varchar(50)) RETURNS varchar(50) AS $$
DECLARE
    _varchar varchar(50) ;
BEGIN
    IF EXISTS(
        SELECT g.projet FROM projet.groupes g
        WHERE g.projet = _code_projet AND g.num_groupe = _num_groupe AND g.nbr_place_groupe = nbr_membres AND g.valide != TRUE
        ) THEN UPDATE projet.groupes SET valide = TRUE WHERE projet = _code_projet AND num_groupe = _num_groupe
            RETURNING _code_projet INTO _varchar;
            RETURN _code_projet;
    END if;
    RETURN _varchar;
END;
$$ LANGUAGE plpgsql;

--10)
CREATE OR REPLACE FUNCTION projet.valideTousLesGroupe(_code_projet varchar(50)) RETURNS VOID AS $$
DECLARE

BEGIN
    IF EXISTS(
        SELECT g.projet
        FROM projet.groupes g
        WHERE g.projet = _code_projet AND g.nbr_place_groupe != g.nbr_membres
    )THEN RAISE 'Un groupes nest pas complet';
    END IF;
    UPDATE projet.groupes SET valide = TRUE WHERE projet = _code_projet;

END;
$$LANGUAGE plpgsql;

---------
--EXTRA--
---------
CREATE OR REPLACE FUNCTION projet.recupererIdEtudiant(_email varchar(50)) RETURNS INTEGER AS $$
DECLARE
   _id INTEGER :=0;
BEGIN
   SELECT e.id_etudiant
   FROM projet.etudiants e
   WHERE e.email = _email INTO _id;
   RETURN _id;
END;
$$ language plpgsql;

---------
--EXTRA--
---------
CREATE OR REPLACE FUNCTION projet.recupererMdpEtudiant(_email varchar(50)) RETURNS VARCHAR AS $$
DECLARE
   _mdp VARCHAR;
BEGIN
    SELECT e.mdp
        FROM projet.etudiants e
        WHERE e.email = _email INTO _mdp;
    RETURN _mdp;
END;
$$ language plpgsql;


----------------------------
--- Application Etudiant ---
----------------------------

--1)

--2)
CREATE OR REPLACE FUNCTION incrementerNbrMembres() RETURNS TRIGGER AS $$
DECLARE
    _nbr_place INTEGER;
    _nbr_membres INTEGER;
BEGIN
    SELECT g.nbr_place_groupe FROM projet.groupes g WHERE g.num_groupe = NEW.num_groupe AND g.projet = NEW.projet INTO  _nbr_place;
    SELECT g.nbr_membres FROM projet.groupes g WHERE g.num_groupe = NEW.num_groupe AND g.projet = NEW.projet INTO  _nbr_membres;
    IF(_nbr_membres >= _nbr_place)
        THEN  RAISE 'Le groupes est full';
    END IF;
    UPDATE projet.groupes g  SET nbr_membres = g.nbr_membres +1 WHERE g.num_groupe = NEW.num_groupe AND g.projet = NEW.projet;
        RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER groupes_trigger BEFORE INSERT ON projet.inscriptions_groupe FOR EACH ROW
EXECUTE PROCEDURE incrementerNbrMembres();

CREATE OR REPLACE FUNCTION projet.ajouterGroupe( _num_groupe INTEGER,_code_projet char(15), _email_etudiant varchar(50)) RETURNS VOID AS $$
DECLARE
    _id_etudiant INTEGER;
BEGIN
    SELECT e.id_etudiant
    FROM projet.etudiants e
    WHERE e.email = _email_etudiant INTO _id_etudiant;

    IF NOT EXISTS(
        SELECT c.code_cours
        FROM projet.cours c, projet.inscriptions_cours ic
        WHERE c.code_cours = ic.cours
        AND ic.email_etudiant = _email_etudiant
        AND c.code_cours IN (
            SELECT p.cours
            FROM projet.projets p WHERE p.code_projet = _code_projet
            )
        ) THEN RAISE 'Pas inscrit au cours !!!!!!!!!!!!!!!!!!!';
    END IF;
        INSERT INTO projet.inscriptions_groupe VALUES (_num_groupe, _code_projet, _id_etudiant);
END;
$$ language plpgsql;


--3)
CREATE OR REPLACE FUNCTION decrementerNbrMembres() RETURNS TRIGGER AS $$
BEGIN
    UPDATE projet.groupes g SET nbr_membres = g.nbr_membres -1 WHERE g.num_groupe = OLD.num_groupe AND g.projet = OLD.projet;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER groupes_delete_trigger
    BEFORE DELETE ON projet.inscriptions_groupe FOR EACH ROW EXECUTE PROCEDURE decrementerNbrMembres();

CREATE OR REPLACE FUNCTION projet.retireGroupe(_code_projet char(15), _email_etudiant varchar(50)) RETURNS VOID AS $$
DECLARE
    _delete_number INTEGER;
    _id_etudiant INTEGER;
BEGIN
    SELECT e.id_etudiant
    FROM projet.etudiants e
    WHERE e.email = _email_etudiant INTO _id_etudiant;

    IF (1 = (
        SELECT count(g.projet)
        FROM projet.groupes g
        WHERE  g.projet = _code_projet  AND g.valide = TRUE)
        ) THEN RAISE 'cours deja valide ne peut pas etre retire';
    END IF;
    SELECT ic.num_groupe
        FROM projet.inscriptions_groupe ic, projet.etudiants e
        WHERE e.id_etudiant = ic.etudiant AND ic.projet = _code_projet
        AND ic.etudiant = (SELECT e.id_etudiant WHERE e.email = _email_etudiant) INTO _delete_number;

    DELETE FROM projet.inscriptions_groupe ic WHERE ic.num_groupe = _delete_number AND ic.projet = _code_projet AND ic.etudiant = _id_etudiant;

END;
$$ LANGUAGE plpgsql;


--4)


--5)


--6)





-- Grant
-- CREATE USER laurentvandermeersch WITH PASSWORD '123';
--
GRANT CONNECT ON DATABASE postgres TO laurentvandermeersch;
GRANT USAGE ON SCHEMA projet TO laurentvandermeersch;
GRANT SELECT ON TABLE projet.etudiants, projet.groupes, projet.projets, projet.cours, projet.inscriptions_cours,
    projet.inscriptions_groupe, projet.afficherProjet, projet.afficherCours TO laurentvandermeersch;
--GRANT INSERT ON TABLE projet. TO laurentvandermeersch;
--GRANT DELETE ON TABLE projet. TO laurentvandermeersch;
--GRANT UPDATE ON TABLE projet. TO laurentvandermeersch;











