-- Creation de la base de données de notte Cercle Social

show databases;
create database cercle_social;
use cercle_social;

-- Creation des diferentes tables de la BD
show tables;

create table users(
    id_user INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(20) NOT NULL,
    prenom VARCHAR(20) NOT NULL,
    sexe CHAR(1) NOT NULL,
    pseudo VARCHAR(20) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(250) NOT NULL,
    visuel VARCHAR(250) DEFAULT NULL,
    date_inscription DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    role ENUM('utilisateur', 'moderateur', 'admin') DEFAULT 'utilisateur',
    accroche TEXT 

);

create table statuts(
    id_statut INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(30) NOT NULL
);

create table hobbies(
    id_hobby INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nom_hobby VARCHAR(100) NOT NULL UNIQUE,
    affiche_hobby VARCHAR(250) DEFAULT NULL
);

create table historique (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED DEFAULT NULL,
    date_evenement DATETIME DEFAULT CURRENT_TIMESTAMP,
    mementos TEXT,
    type_evenement ENUM('inscription', 'connexion', 'modification', 'relation', 'suppression') NOT NULL,


    CONSTRAINT fk_his_user_id FOREIGN KEY (user_id) REFERENCES users(id_user) ON DELETE SET NULL
);


create table relations(
    id_relation INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_source_id INT UNSIGNED NOT NULL,
    user_cible_id INT UNSIGNED NOT NULL,

    initiateur_id INT UNSIGNED NOT NULL,

    statut_relation_id INT UNSIGNED ,
    etat ENUM('en_attente', 'acceptee', 'refusee') NOT NULL DEFAULT 'en_attente',

    date_liaison DATETIME DEFAULT CURRENT_TIMESTAMP,
    date_modif DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_source FOREIGN KEY (user_source_id) REFERENCES users(id_user) ON DELETE CASCADE,
    CONSTRAINT fk_cible FOREIGN KEY (user_cible_id) REFERENCES users(id_user) ON DELETE CASCADE,
    CONSTRAINT fk_initiateur FOREIGN KEY (initiateur_id) REFERENCES users(id_user) ON DELETE CASCADE,

    CONSTRAINT fk_statut FOREIGN KEY (statut_relation_id) REFERENCES statuts(id_statut) ON DELETE CASCADE,


    CONSTRAINT chk_diff_user CHECK(user_source_id <> user_cible_id),
    CONSTRAINT chk_ordre_ids CHECK(user_source_id < user_cible_id),
    UNIQUE KEY unique_relation (user_source_id,user_cible_id)



);

create table user_hobbies(
    user_id INT UNSIGNED NOT NULL,
    hobby_id INT UNSIGNED NOT NULL,

    date_ajout DATETIME DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (user_id, hobby_id),

    CONSTRAINT fk_uh_user FOREIGN KEY(user_id) REFERENCES users(id_user) ON DELETE CASCADE,
    CONSTRAINT fk_uh_hobby FOREIGN KEY(hobby_id) REFERENCES hobbies(id_hobby) ON DELETE CASCADE


);


create table messages (
    id_message INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    expediteur_id INT UNSIGNED NOT NULL,
    destinataire_id INT UNSIGNED NOT NULL,
    contenu TEXT NOT NULL,
    date_envoi DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_expe_id FOREIGN KEY (expediteur_id) REFERENCES users(id_user) ON DELETE CASCADE,
    CONSTRAINT fk_dest_id FOREIGN KEY (destinataire_id) REFERENCES users(id_user) ON DELETE CASCADE
);

create table cercles (
    id_cercle INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nom_cercle VARCHAR(100) NOT NULL,
    user_createur_id INT UNSIGNED NOT NULL,
    description TEXT NULL,

    CONSTRAINT fk_cercle_user FOREIGN KEY (user_createur_id) REFERENCES users(id_user) ON DELETE CASCADE
);

create table cercle_membres (
    id_cercle INT UNSIGNED NOT NULL,
    id_membre INT UNSIGNED NOT NULL,
    date_ajout DATETIME DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_cercle, id_membre),

    CONSTRAINT fk_cer_mem_id_cercle FOREIGN KEY (id_cercle) REFERENCES cercles(id_cercle) ON DELETE CASCADE,
    CONSTRAINT fk_cer_mem_id_membre FOREIGN KEY (id_membre) REFERENCES users(id_user) ON DELETE CASCADE
);

CREATE TABLE messages_lus (
    id_message INT UNSIGNED NOT NULL,
    id_utilisateur INT UNSIGNED NOT NULL,
    date_lecture DATETIME DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_message, id_utilisateur),

    CONSTRAINT fk_lus_id_mess FOREIGN KEY (id_message) REFERENCES messages(id_message) ON DELETE CASCADE,
    CONSTRAINT fk_lus_id_user FOREIGN KEY (id_utilisateur) REFERENCES users(id_user) ON DELETE CASCADE
);

CREATE TABLE historique_relations (
    id_historique INT UNSIGNED AUTO_INCREMENT,
    id_relation INT UNSIGNED NOT NULL,
    action ENUM('creation', 'modification', 'suppression') NOT NULL,
    fait_par INT UNSIGNED NOT NULL,
    commentaire TEXT,
    date_action DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_historique_relations PRIMARY KEY (id_historique),
    CONSTRAINT fk_hr_relation FOREIGN KEY (id_relation) REFERENCES relations(id_relation) ON DELETE CASCADE,
    CONSTRAINT fk_hr_fait_par FOREIGN KEY (fait_par) REFERENCES users(id_user) ON DELETE SET NULL
);

CREATE TABLE historique_cercles (
    id_historique INT UNSIGNED AUTO_INCREMENT,
    id_cercle INT UNSIGNED NOT NULL,
    action ENUM('creation', 'modification', 'ajout_membre', 'retrait_membre', 'suppression') NOT NULL,
    fait_par INT UNSIGNED NOT NULL,
    commentaire TEXT,
    date_action DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_historique_cercles PRIMARY KEY (id_historique),
    CONSTRAINT fk_hc_cercle FOREIGN KEY (id_cercle) REFERENCES cercles(id_cercle) ON DELETE CASCADE,
    CONSTRAINT fk_hc_fait_par FOREIGN KEY (fait_par) REFERENCES users(id_user) ON DELETE SET NULL
);

CREATE TABLE historique_messages (
    id_historique INT UNSIGNED AUTO_INCREMENT,
    id_message INT UNSIGNED,
    action ENUM('modification', 'suppression') NOT NULL,
    fait_par INT UNSIGNED NOT NULL,
    ancien_contenu TEXT,
    nouveau_contenu TEXT,
    date_action DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_historique_messages PRIMARY KEY (id_historique),
    CONSTRAINT fk_hm_message FOREIGN KEY (id_message) REFERENCES messages(id_message) ON DELETE CASCADE,
    CONSTRAINT fk_hm_user FOREIGN KEY (fait_par) REFERENCES users(id_user) ON DELETE SET NULL
);

CREATE TABLE historique_user_hobbies (
    id_historique INT UNSIGNED AUTO_INCREMENT,
    user_id INT UNSIGNED NOT NULL,
    hobby_id INT UNSIGNED NOT NULL,
    action ENUM('ajout', 'retrait') NOT NULL,
    date_action DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_hist_user_hobbies PRIMARY KEY (id_historique),
    CONSTRAINT fk_huh_user FOREIGN KEY (user_id) REFERENCES users(id_user) ON DELETE CASCADE,
    CONSTRAINT fk_huh_hobby FOREIGN KEY (hobby_id) REFERENCES hobbies(id_hobby) ON DELETE CASCADE
);

CREATE TABLE historique_users (
    id_historique INT UNSIGNED AUTO_INCREMENT,
    id_user INT UNSIGNED NOT NULL,
    champ_modifie VARCHAR(50) NOT NULL,
    ancienne_valeur TEXT,
    nouvelle_valeur TEXT,
    modifie_par INT UNSIGNED DEFAULT NULL, -- l'auteur du changement si identifiable
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_historique_users PRIMARY KEY (id_historique),
    CONSTRAINT fk_hu_user FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE,
    CONSTRAINT fk_hu_modif_par FOREIGN KEY (modifie_par) REFERENCES users(id_user) ON DELETE SET NULL
);

/*
DELIMITER $$

CREATE TRIGGER after_update_users
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    -- Changement du pseudo
    IF OLD.pseudo <> NEW.pseudo THEN
        INSERT INTO historique_users (id_user, champ_modifie, ancienne_valeur, nouvelle_valeur, modifie_par)
        VALUES (OLD.id_user, 'pseudo', OLD.pseudo, NEW.pseudo, NULL);
    END IF;

    -- Changement du mot de passe
    IF OLD.mot_de_passe <> NEW.mot_de_passe THEN
        INSERT INTO historique_users (id_user, champ_modifie, ancienne_valeur, nouvelle_valeur, modifie_par)
        VALUES (OLD.id_user, 'mot_de_passe', OLD.mot_de_passe, NEW.mot_de_passe, NULL);
    END IF;

    -- Changement du rôle
    IF OLD.role <> NEW.role THEN
        INSERT INTO historique_users (id_user, champ_modifie, ancienne_valeur, nouvelle_valeur, modifie_par)
        VALUES (OLD.id_user, 'role', OLD.role, NEW.role, NULL);
    END IF;

    -- Changement de l'accroche
    IF OLD.accroche <> NEW.accroche THEN
        INSERT INTO historique_users (id_user, champ_modifie, ancienne_valeur, nouvelle_valeur, modifie_par)
        VALUES (OLD.id_user, 'accroche', OLD.accroche, NEW.accroche, NULL);
    END IF;

    -- Changement de l'image/visuel
    IF OLD.visuel <> NEW.visuel THEN
        INSERT INTO historique_users (id_user, champ_modifie, ancienne_valeur, nouvelle_valeur, modifie_par)
        VALUES (OLD.id_user, 'visuel', OLD.visuel, NEW.visuel, NULL);
    END IF;
END$$

DELIMITER ;
*/