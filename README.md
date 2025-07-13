# Cercle_Social – Réseau personnel de gestion de contacts

## Projet web personnel fullstack en PHP, SQL, JS et Bootstrap.

## 🛠 Technologies utilisées

PHP (avec PDO)

MySQL

HTML, CSS, Bootstrap

JavaScript (AJAX, DOM)

Git

## ✨ Fonctionnalités principales

🔐 Système d’inscription et connexion sécurisé (sessions)

🧑‍🤝‍🧑 Création de profils pour les contacts

➕ Ajout d’amis, famille, ou autres relations avec statut

📊 Affichage du cercle social regroupé par type de relation

🔎 Recherche dynamique en JavaScript

🎨 Design responsive avec Bootstrap

🧱 Base de données (extrait)
users : infos utilisateur (id, pseudo, email, mot de passe…)

connections : relations entre utilisateurs, avec statut (pending, accepted, etc.)

## 🚀 Lancer le projet en local

Cloner ce dépôt :
git clone https://github.com/tonpseudo/cercle-social.git

Configurer la base de données avec le fichier cercle_social.sql

Modifier les identifiants de connexion à la base (includes/db.php)

Lancer un serveur local (ex : php -S localhost:8000)

## 📸 Captures d’écran
(Tu pourras les ajouter plus tard une fois l’interface plus avancée)

## 👨‍💻 Auteur
Willo Njog Eyoum

Étudiant en Licence Informatique, futur alternant motivé 💼

[LinkedIn] – [Email] – [GitHub]

>>>>>>> 0c55efe (modification du README)


# 📚 Base de Données – Cercle Social

---

## 🧑‍💼 Table : `users`
Description : Contient les informations des utilisateurs du site, leurs rôles, et des données personnelles.

| Champ             | Type                                   | Contraintes                            |
|-------------------|--------------------------------------|--------------------------------------|
| `id_user`         | INT UNSIGNED AUTO_INCREMENT          | PRIMARY KEY                          |
| `nom`             | VARCHAR(20)                          | NOT NULL                            |
| `prenom`          | VARCHAR(20)                          | NOT NULL                            |
| `sexe`            | CHAR(1)                             | NOT NULL                            |
| `pseudo`          | VARCHAR(20)                          | NOT NULL, UNIQUE                    |
| `mot_de_passe`    | VARCHAR(250)                        | NOT NULL                            |
| `visuel`          | VARCHAR(250)                        | NULL par défaut                     |
| `date_inscription` | DATETIME                           | DEFAULT CURRENT_TIMESTAMP           |
| `update_at`       | DATETIME                           | DEFAULT CURRENT_TIMESTAMP ON UPDATE |
| `role`            | ENUM('utilisateur','moderateur','admin') | DEFAULT 'utilisateur'          |
| `accroche`        | TEXT                                | NULL par défaut                     |

---

## 📌 Table : `statuts`
Description : Liste des statuts possibles pour une relation.

| Champ           | Type                     | Contraintes      |
|-----------------|--------------------------|------------------|
| `id_statut`     | INT UNSIGNED AUTO_INCREMENT | PRIMARY KEY     |
| `titre`         | VARCHAR(30)              | NOT NULL         |

---

## 🎯 Table : `hobbies`
Description : Liste des hobbies disponibles, avec nom unique et une image optionnelle.

| Champ           | Type                     | Contraintes        |
|-----------------|--------------------------|--------------------|
| `id_hobby`      | INT UNSIGNED AUTO_INCREMENT | PRIMARY KEY       |
| `nom_hobby`     | VARCHAR(100)             | NOT NULL, UNIQUE   |
| `affiche_hobby` | VARCHAR(250)             | NULL par défaut    |

---

## 🕘 Table : `historique`
Description : Historique des événements liés aux utilisateurs (inscriptions, connexions, modifications, relations, suppressions).

| Champ            | Type                                             | Contraintes                                    |
|------------------|--------------------------------------------------|-----------------------------------------------|
| `id`             | INT UNSIGNED AUTO_INCREMENT                       | PRIMARY KEY                                  |
| `user_id`        | INT UNSIGNED                                     | FOREIGN KEY → `users(id_user)` ON DELETE SET NULL |
| `date_evenement` | DATETIME                                         | DEFAULT CURRENT_TIMESTAMP                      |
| `mementos`       | TEXT                                             | NULL par défaut                                |
| `type_evenement` | ENUM('inscription','connexion','modification','relation','suppression') | NOT NULL                   |

---

## 🔗 Table : `relations`
Description : Définit les relations entre deux utilisateurs, leur état et statut.

| Champ              | Type                                       | Contraintes                                    |
|--------------------|--------------------------------------------|-----------------------------------------------|
| `id_relation`      | INT UNSIGNED AUTO_INCREMENT                 | PRIMARY KEY                                  |
| `user_source_id`   | INT UNSIGNED                              | FOREIGN KEY → `users(id_user)` ON DELETE CASCADE |
| `user_cible_id`    | INT UNSIGNED                              | FOREIGN KEY → `users(id_user)` ON DELETE CASCADE |
| `initiateur_id`    | INT UNSIGNED                              | FOREIGN KEY → `users(id_user)` ON DELETE CASCADE |
| `statut_relation_id` | INT UNSIGNED                            | FOREIGN KEY → `statuts(id_statut)` ON DELETE CASCADE |
| `etat`             | ENUM('en_attente','acceptee','refusee')  | DEFAULT 'en_attente'                          |
| `date_liaison`     | DATETIME                                  | DEFAULT CURRENT_TIMESTAMP                      |
| `date_modif`       | DATETIME                                  | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
|                    |                                            | CHECK (user_source_id <> user_cible_id)        |
|                    |                                            | CHECK (user_source_id < user_cible_id)          |
|                    |                                            | UNIQUE (user_source_id, user_cible_id)          |

---

## 🧩 Table : `user_hobbies`
Description : Table d’association entre utilisateurs et hobbies.

| Champ          | Type                      | Contraintes                                    |
|----------------|---------------------------|-----------------------------------------------|
| `user_id`      | INT UNSIGNED             | FOREIGN KEY → `users(id_user)` ON DELETE CASCADE |
| `hobby_id`     | INT UNSIGNED             | FOREIGN KEY → `hobbies(id_hobby)` ON DELETE CASCADE |
| `date_ajout`   | DATETIME                 | DEFAULT CURRENT_TIMESTAMP                      |
|                |                           | PRIMARY KEY (`user_id`, `hobby_id`)            |

---

## 💬 Table : `messages`
Description : Messages envoyés d’un utilisateur à un autre.

| Champ            | Type                                   | Contraintes                                  |
|------------------|--------------------------------------|---------------------------------------------|
| `id_message`     | INT UNSIGNED AUTO_INCREMENT          | PRIMARY KEY                                |
| `expediteur_id`  | INT UNSIGNED                        | FOREIGN KEY → `users(id_user)` ON DELETE CASCADE |
| `destinataire_id`| INT UNSIGNED                        | FOREIGN KEY → `users(id_user)` ON DELETE CASCADE |
| `contenu`        | TEXT                                | NOT NULL                                   |
| `date_envoi`     | DATETIME                           | DEFAULT CURRENT_TIMESTAMP                   |

---

## 🔵 Table : `cercles`
Description : Cercles sociaux créés par un utilisateur.

| Champ             | Type                             | Contraintes                                  |
|-------------------|---------------------------------|---------------------------------------------|
| `id_cercle`       | INT UNSIGNED AUTO_INCREMENT     | PRIMARY KEY                                |
| `nom_cercle`      | VARCHAR(100)                   | NOT NULL                                   |
| `user_createur_id`| INT UNSIGNED                   | FOREIGN KEY → `users(id_user)` ON DELETE CASCADE |
| `description`     | TEXT                           | NULL par défaut                            |

---

## 🧩 Table : `cercle_membres`
Description : Membres associés à un cercle.

| Champ        | Type                      | Contraintes                                      |
|--------------|---------------------------|-------------------------------------------------|
| `id_cercle`  | INT UNSIGNED             | FOREIGN KEY → `cercles(id_cercle)` ON DELETE CASCADE |
| `id_membre`  | INT UNSIGNED             | FOREIGN KEY → `users(id_user)` ON DELETE CASCADE     |
| `date_ajout` | DATETIME                 | DEFAULT CURRENT_TIMESTAMP                         |
|              |                           | PRIMARY KEY (`id_cercle`, `id_membre`)            |

---

## ✅ Table : `messages_lus`
Description : Messages lus par les utilisateurs.

| Champ           | Type                       | Contraintes                                      |
|-----------------|----------------------------|-------------------------------------------------|
| `id_message`    | INT UNSIGNED               | FOREIGN KEY → `messages(id_message)` ON DELETE CASCADE |
| `id_utilisateur`| INT UNSIGNED               | FOREIGN KEY → `users(id_user)` ON DELETE CASCADE        |
| `date_lecture`  | DATETIME                   | DEFAULT CURRENT_TIMESTAMP                         |
|                 |                            | PRIMARY KEY (`id_message`, `id_utilisateur`)     |

---

## 🕒 Table : `historique_relations`
Description : Historique des actions sur les relations entre utilisateurs.

| Champ           | Type                            | Contraintes                                      |
|-----------------|---------------------------------|-------------------------------------------------|
| `id_historique` | INT UNSIGNED AUTO_INCREMENT     | PRIMARY KEY                                    |
| `id_relation`   | INT UNSIGNED                   | FOREIGN KEY → `relations(id_relation)` ON DELETE CASCADE |
| `action`        | ENUM('creation','modification','suppression') | NOT NULL                      |
| `fait_par`      | INT UNSIGNED                   | FOREIGN KEY → `users(id_user)` ON DELETE SET NULL        |
| `commentaire`   | TEXT                           | NULL par défaut                                 |
| `date_action`   | DATETIME                       | DEFAULT CURRENT_TIMESTAMP                       |

---

## 🕒 Table : `historique_cercles`
Description : Historique des actions sur les cercles sociaux.

| Champ           | Type                                                         | Contraintes                                      |
|-----------------|--------------------------------------------------------------|-------------------------------------------------|
| `id_historique` | INT UNSIGNED AUTO_INCREMENT                                   | PRIMARY KEY                                    |
| `id_cercle`     | INT UNSIGNED                                               | FOREIGN KEY → `cercles(id_cercle)` ON DELETE CASCADE |
| `action`        | ENUM('creation','modification','ajout_membre','retrait_membre','suppression') | NOT NULL              |
| `fait_par`      | INT UNSIGNED                                               | FOREIGN KEY → `users(id_user)` ON DELETE SET NULL        |
| `commentaire`   | TEXT                                                         | NULL par défaut                                 |
| `date_action`   | DATETIME                                                     | DEFAULT CURRENT_TIMESTAMP                       |

---

## 🕒 Table : `historique_messages`
Description : Historique des modifications ou suppressions des messages.

| Champ            | Type                                                       | Contraintes                                      |
|------------------|------------------------------------------------------------|-------------------------------------------------|
| `id_historique`  | INT UNSIGNED AUTO_INCREMENT                                 | PRIMARY KEY                                    |
| `id_message`     | INT UNSIGNED                                             | FOREIGN KEY → `messages(id_message)` ON DELETE CASCADE, NULLABLE |
| `action`         | ENUM('modification','suppression')                         | NOT NULL                                       |
| `fait_par`       | INT UNSIGNED                                             | FOREIGN KEY → `users(id_user)` ON DELETE SET NULL        |
| `ancien_contenu` | TEXT                                                       | NULL par défaut                                 |
| `nouveau_contenu`| TEXT                                                       | NULL par défaut                                 |
| `date_action`    | DATETIME                                                   | DEFAULT CURRENT_TIMESTAMP                       |

---

## 🕒 Table : `historique_user_hobbies`
Description : Historique des ajouts ou retraits de hobbies pour un utilisateur.


| Champ           | Type                                                     | Contraintes                                      |
|-----------------|----------------------------------------------------------|-------------------------------------------------|
| `id_historique` | INT UNSIGNED AUTO_INCREMENT                               | PRIMARY KEY                                    |
| `user_id`       | INT UNSIGNED                                           | FOREIGN KEY → `users(id_user)` ON DELETE CASCADE        |
| `hobby_id`      | INT UNSIGNED


## 🕒 Table : `historique_users`
Description : Historique des modifications sur les utilisateurs (champs modifiés, valeurs anciennes et nouvelles).

| Champ             | Type                         | Contraintes                                      |
| ----------------- | ---------------------------- | ------------------------------------------------ |
| `id_historique`   | INT UNSIGNED AUTO\_INCREMENT | PRIMARY KEY                                      |
| `id_user`         | INT UNSIGNED                 | FOREIGN KEY → `users(id_user)` ON DELETE CASCADE |
| `champ`           | VARCHAR(50)                  | NOT NULL                                         |
| `ancienne_valeur` | TEXT                         | NULL par défaut                                  |
| `nouvelle_valeur` | TEXT                         | NULL par défaut                                  |
| `date_modif`      | DATETIME                     | DEFAULT CURRENT\_TIMESTAMP                       |
