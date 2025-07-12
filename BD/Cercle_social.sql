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
    pseudo VARCHAR(20) NOT NULL,
    mot_de_passe VARCHAR(20) NOT NULL,
    visuel VARCHAR(250) DEFAULT NULL,
    date_inscription DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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

create table memoire(
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    mementos TEXT NOT NULL
);

create table relations(
    id_relation INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_source_id INT UNSIGNED NOT NULL,
    user_cible_id INT UNSIGNED NOT NULL,

    initiateur_id INT UNSIGNED NOT NULL,

    statut_relation VARCHAR(30) NOT NULL DEFAULT 'connaissance',
    etat ENUM('en_attente', 'acceptee', 'refusee') NOT NULL DEFAULT 'en_attente',

    date_liaison DATETIME DEFAULT CURRENT_TIMESTAMP,
    date_modif DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_source FOREIGN KEY (user_source_id) REFERENCES users(id_user) ON DELETE CASCADE,
    CONSTRAINT fk_cible FOREIGN KEY (user_cible_id) REFERENCES users(id_user) ON DELETE CASCADE,
    CONSTRAINT fk_initiateur FOREIGN KEY (initiateur_id) REFERENCES users(id_user) ON DELETE CASCADE,

    CONSTRAINT fk_statut FOREIGN KEY (statut_relation) REFERENCES statuts(titre) ON DELETE CASCADE,


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
    CONSTRAINT fk_uh_hobby FOREIGN KEY(hobby_id) REFERENCES hobbies(id_hobby) ON DELETE CASCADE,


);