-- script contenant les requêtes demandées
--
--[REQUETES]
--Requête 1 On souhaite obtenir par secteur d’activité la moyenne des charges estimées des projets.
--
 select libelle_court, nom_secteur_activite from projet inner join secteur_activite on projet.id_secteur_activite = secteur_activite.id_secteur_activite;
--Requête 2  On souhaite obtenir la liste des projets (libellé court) sur lesquels un collaborateur est intervenu.
--Préciser également sa fonction dans les projets.
select libelle_court, nom_fonction from projet 
inner join activite on projet.id_activite = activite.id_activite 
inner join intervient on activite.id_activite = intervient.id_activite 
inner join fonction on intervient.id_fonction = fonction.id_fonction;
--
--Requête 3 On souhaite obtenir à la date du jour la liste des projets en cours, par secteur d’activité.
--Préciser le nombre de collaborateurs associés aux projets et ceci par fonction.
-- 2 triggers de création
-- 1 trigger de mise a jour
-- 1 trigger de suppression
-- 3 procédures stockées
--
--Requêtes de mise a jour
-- - Augmenter tous les salaires des collaborateurs de :
-- - 5% si ils ont plus de 5 ans d’ancienneté.
-- - Supprimer de la base de données les projets qui sont terminés et qui n’ont pas eu de charges (étapes) associées.

--[TRIGGERS]
--
--Triggers de création
--
--table projet
--Vérifier que la date prévisionnelle de début du projet est inférieure ou égale la date prévisionnelle de fin du projet.
drop trigger if exists verif_date on projet cascade;
CREATE OR REPLACE FUNCTION verif_date() RETURNS trigger AS 
$$
    BEGIN
        -- Verifie que nom_employe et salary sont donnés
        IF NEW.date_prevue_debut >= NEW.date_prevue_fin THEN
            RAISE EXCEPTION 'ERROR la date de debut ne peut pas etre supérieur a la date de fin';
        END IF;
           RETURN NEW;
    END;
$$ 
LANGUAGE plpgsql;

CREATE TRIGGER verif_date BEFORE INSERT OR UPDATE ON projet
    FOR EACH ROW EXECUTE PROCEDURE verif_date();
   
--
--table client
--Vérifier la cohérence du chiffre d’affaire du client, si supérieur à 1 million d’euros par personne la valeur du CA est erronée.
--
drop trigger if exists verif_ca on client cascade;
CREATE OR REPLACE FUNCTION verif_ca() RETURNS trigger AS
$$
BEGIN
IF NEW.CA > 1000000 THEN
RAISE EXCEPTION 'ERROR la valeur du CA est erronée';
END IF;
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER verif_ca BEFORE INSERT OR UPDATE ON client
FOR EACH ROW EXECUTE PROCEDURE verif_ca();
--Triggers de mise a jour
--Table personnel
--Vérifier la cohérence du code statut,
--Passages possibles de :
-- - S (stagiaire) à D (CDD) ou I (CDI),
-- - D (CDD) à I (CDI).
--
--Triggers de suppresion
--
--table projet
-- Ne pas supprimer un projet si la date réelle de fin du projet est inférieure à 2 mois par rapport à la date du jour.
--
--[PROCEDURES]
--
--Procédure1
--On souhaite obtenir la moyenne des charges estimées sur les projets en cours.
--
--Procédure 2
--On souhaite obtenir sur un thème technique donné la liste des projets associés et terminés depuis moins de 2 ans
--
--Procédure 3
--On veut lister les interventions des collaborateurs sur un projet entre deux dates.
--La procédure renvoie pour chaque intervention :
-- - Le nom du collaborateur associé
-- - La fonction en clair du collaborateur
-- - Les dates début et fin d’intervention
-- - La tâche ou activité associée.
select nom_prenom, date_intervention, fonction, nom_activite from collaborateur inner join intervention on collaborateur.id_collaborateur = intervention.id_collaborateur inner join activite on intervention.id_activite = activite.id_activite inner join projet on activite.id_projet = projet.id_projet inner join fonction on collaborateur.id_fonction = fonction.id_fonction inner join liste_activite on activite.id_liste_activite = liste_activite.id_liste_activite;
