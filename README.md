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

| Champ              | Type         | Contraintes                                             | Description                       |
| ------------------ | ------------ | ------------------------------------------------------- | --------------------------------- |
| `id_user`          | INT UNSIGNED | PRIMARY KEY, AUTO\_INCREMENT                            | Identifiant unique                |
| `nom`              | VARCHAR(20)  | NOT NULL                                                | Nom de l'utilisateur              |
| `prenom`           | VARCHAR(20)  | NOT NULL                                                | Prénom de l'utilisateur           |
| `sexe`             | CHAR(1)      | NOT NULL                                                | Sexe de l'utilisateur (H/F)       |
| `pseudo`           | VARCHAR(20)  | NOT NULL, UNIQUE                                        | Pseudo unique                     |
| `mot_de_passe`     | VARCHAR(250) | NOT NULL                                                | Mot de passe hashé                |
| `visuel`           | VARCHAR(250) | DEFAULT NULL                                            | URL/nom de fichier du visuel      |
| `date_inscription` | DATETIME     | DEFAULT CURRENT\_TIMESTAMP                              | Date d'inscription                |
| `update_at`        | DATETIME     | DEFAULT CURRENT\_TIMESTAMP ON UPDATE CURRENT\_TIMESTAMP | Date de dernière modification     |
| `role`             | ENUM(...)    | DEFAULT 'utilisateur'                                   | Rôle utilisateur/modérateur/admin |
| `accroche`         | TEXT         |                                                         | Phrase d’accroche ou bio          |

---

## 📌 Table : `statuts`
Description : Liste des statuts possibles pour une relation.

| Champ       | Type         | Contraintes                  | Description        |
| ----------- | ------------ | ---------------------------- | ------------------ |
| `id_statut` | INT UNSIGNED | PRIMARY KEY, AUTO\_INCREMENT | Identifiant unique |
| `titre`     | VARCHAR(30)  | NOT NULL                     | Titre du statut    |

---

## 🎯 Table : `hobbies`
Description : Liste des hobbies disponibles, avec nom unique et une image optionnelle.

| Champ           | Type         | Contraintes                  | Description          |
| --------------- | ------------ | ---------------------------- | -------------------- |
| `id_hobby`      | INT UNSIGNED | PRIMARY KEY, AUTO\_INCREMENT | Identifiant unique   |
| `nom_hobby`     | VARCHAR(100) | NOT NULL, UNIQUE             | Nom du hobby         |
| `affiche_hobby` | VARCHAR(250) | DEFAULT NULL                 | Icône/image associée |

---

## 🧩 Table : `user_hobbies`
Description : Table d’association entre utilisateurs et hobbies.

| Champ        | Type         | Contraintes                 | Description          |
| ------------ | ------------ | --------------------------- | -------------------- |
| `user_id`    | INT UNSIGNED | PRIMARY KEY, FK → `users`   | ID utilisateur       |
| `hobby_id`   | INT UNSIGNED | PRIMARY KEY, FK → `hobbies` | ID hobby             |
| `date_ajout` | DATETIME     | DEFAULT CURRENT\_TIMESTAMP  | Date d’ajout du lien |

---

## 🔗 Table : `relations`
Description : Définit les relations entre deux utilisateurs, leur état et statut.

| Champ                | Type         | Contraintes                                             | Description                |
| -------------------- | ------------ | ------------------------------------------------------- | -------------------------- |
| `id_relation`        | INT UNSIGNED | PRIMARY KEY, AUTO\_INCREMENT                            | Identifiant de la relation |
| `user_source_id`     | INT UNSIGNED | NOT NULL, FK → `users`                                  | Utilisateur source         |
| `user_cible_id`      | INT UNSIGNED | NOT NULL, FK → `users`                                  | Utilisateur cible          |
| `initiateur_id`      | INT UNSIGNED | NOT NULL, FK → `users`                                  | Initiateur de la relation  |
| `statut_relation_id` | INT UNSIGNED | FK → `statuts`                                          | Statut lié                 |
| `etat`               | ENUM(...)    | DEFAULT 'en\_attente'                                   | État actuel de la relation |
| `date_liaison`       | DATETIME     | DEFAULT CURRENT\_TIMESTAMP                              | Date de création           |
| `date_modif`         | DATETIME     | DEFAULT CURRENT\_TIMESTAMP ON UPDATE CURRENT\_TIMESTAMP | Date de dernière modif     |

✔️ Contraintes supplémentaires :

    CHECK(user_source_id <> user_cible_id)

    CHECK(user_source_id < user_cible_id)

    UNIQUE(user_source_id, user_cible_id)
---

## 💬 Table : `messages`
Description : Messages envoyés d’un utilisateur à un autre.

| Champ             | Type         | Contraintes                  | Description            |
| ----------------- | ------------ | ---------------------------- | ---------------------- |
| `id_message`      | INT UNSIGNED | PRIMARY KEY, AUTO\_INCREMENT | Identifiant du message |
| `expediteur_id`   | INT UNSIGNED | NOT NULL, FK → `users`       | Expéditeur             |
| `destinataire_id` | INT UNSIGNED | NOT NULL, FK → `users`       | Destinataire           |
| `contenu`         | TEXT         | NOT NULL                     | Contenu du message     |
| `date_envoi`      | DATETIME     | DEFAULT CURRENT\_TIMESTAMP   | Date d’envoi           |

---

## ✅ Table : `messages_lus`
Description : Messages lus par les utilisateurs.

| Champ            | Type         | Contraintes                  | Description          |
| ---------------- | ------------ | ---------------------------- | -------------------- |
| `message_id`     | INT UNSIGNED | PRIMARY KEY, FK → `messages` | Message lu           |
| `id_utilisateur` | INT UNSIGNED | PRIMARY KEY, FK → `users`    | Utilisateur ayant lu |
| `date_lecture`   | DATETIME     | DEFAULT CURRENT\_TIMESTAMP   | Date de lecture      |

---

## 🔵 Table : `cercles`
Description : Cercles sociaux créés par un utilisateur.

| Champ              | Type         | Contraintes                  | Description             |
| ------------------ | ------------ | ---------------------------- | ----------------------- |
| `id_cercle`        | INT UNSIGNED | PRIMARY KEY, AUTO\_INCREMENT | Identifiant du cercle   |
| `nom_cercle`       | VARCHAR(100) | NOT NULL                     | Nom du cercle           |
| `user_createur_id` | INT UNSIGNED | NOT NULL, FK → `users`       | Utilisateur créateur    |
| `description`      | TEXT         | NULL                         | Description facultative |

---

## 🧩 Table : `cercle_membres`
Description : Membres associés à un cercle.

| Champ        | Type         | Contraintes                 | Description            |
| ------------ | ------------ | --------------------------- | ---------------------- |
| `id_cercle`  | INT UNSIGNED | PRIMARY KEY, FK → `cercles` | Cercle                 |
| `id_membre`  | INT UNSIGNED | PRIMARY KEY, FK → `users`   | Membre du cercle       |
| `date_ajout` | DATETIME     | DEFAULT CURRENT\_TIMESTAMP  | Date d’ajout au cercle |

---

## 🕘 Table : `historique`
Description : Historique des événements liés aux utilisateurs (inscriptions, connexions, modifications, relations, suppressions).

| Champ            | Type         | Contraintes                  | Description                           |
| ---------------- | ------------ | ---------------------------- | ------------------------------------- |
| `id_hist`        | INT UNSIGNED | PRIMARY KEY, AUTO\_INCREMENT | Identifiant de l’événement            |
| `user_id`        | INT UNSIGNED | FK → `users` (NULLABLE)      | Utilisateur concerné                  |
| `date_evenement` | DATETIME     | DEFAULT CURRENT\_TIMESTAMP   | Date de l’événement                   |
| `mementos`       | TEXT         |                              | Détail ou note                        |
| `type_evenement` | ENUM(...)    | NOT NULL                     | Type (inscription, suppression, etc.) |

---

## 🕒 Table : `historique_user_hobbies`
Description : Historique des ajouts ou retraits de hobbies pour un utilisateur.

| Champ           | Type                      | Contraintes                                                         | Description                        |
| --------------- | ------------------------- | ------------------------------------------------------------------- | ---------------------------------- |
| `id_historique` | `INT UNSIGNED`            | `AUTO_INCREMENT`, `PRIMARY KEY` (`pk_hist_user_hobbies`)            | Identifiant unique de l’historique |
| `user_id`       | `INT UNSIGNED`            | `NOT NULL`, `FOREIGN KEY` → `users(id_user)` `ON DELETE CASCADE`    | L’utilisateur concerné             |
| `hobby_id`      | `INT UNSIGNED`            | `NOT NULL`, `FOREIGN KEY` → `hobbies(id_hobby)` `ON DELETE CASCADE` | Le loisir concerné                 |
| `action`        | `ENUM('ajout','retrait')` | `NOT NULL`                                                          | Type d’action effectuée            |
| `date_action`   | `DATETIME`                | `DEFAULT CURRENT_TIMESTAMP`                                         | Date et heure de l’action          |

---

## 🕒 Table : `historique_users`
Description : Historique des modifications sur les utilisateurs (champs modifiés, valeurs anciennes et nouvelles).

| Champ               | Type           | Contraintes                                                      | Description                                |
| ------------------- | -------------- | ---------------------------------------------------------------- | ------------------------------------------ |
| `id_historique`     | `INT UNSIGNED` | `AUTO_INCREMENT`, `PRIMARY KEY` (`pk_historique_users`)          | Identifiant unique de l’historique         |
| `user_id`           | `INT UNSIGNED` | `NOT NULL`, `FOREIGN KEY` → `users(id_user)` `ON DELETE CASCADE` | L’utilisateur dont une info a été modifiée |
| `champ_modifie`     | `VARCHAR(50)`  | `NOT NULL`                                                       | Nom du champ modifié                       |
| `ancienne_valeur`   | `TEXT`         | *(NULL par défaut)*                                              | Valeur avant modification                  |
| `nouvelle_valeur`   | `TEXT`         | *(NULL par défaut)*                                              | Valeur après modification                  |
| `modifie_par`       | `INT UNSIGNED` | `FOREIGN KEY` → `users(id_user)` `ON DELETE SET NULL`            | Utilisateur ayant effectué le changement   |
| `date_modification` | `DATETIME`     | `DEFAULT CURRENT_TIMESTAMP`                                      | Date et heure de la modification           |

---



## 🕒 Table : `historique_relations`
Description : Historique des actions sur les relations entre utilisateurs.

| Champ           | Type         | Contraintes                     | Description            |
| --------------- | ------------ | ------------------------------- | ---------------------- |
| `id_historique` | INT UNSIGNED | PRIMARY KEY, AUTO\_INCREMENT    | Identifiant historique |
| `id_rel`        | INT UNSIGNED | NOT NULL, FK → `relations`      | Relation concernée     |
| `action`        | ENUM(...)    | NOT NULL                        | Type d’action          |
| `fait_par`      | INT UNSIGNED | NOT NULL, FK → `users` SET NULL | Auteur de l’action     |
| `commentaire`   | TEXT         |                                 | Commentaire optionnel  |
| `date_action`   | DATETIME     | DEFAULT CURRENT\_TIMESTAMP      | Date de l’action       |


## 🕒 Table : `historique_cercles`
Description : Historique des actions sur les cercles sociaux.

| Champ           | Type         | Contraintes                     | Description            |
| --------------- | ------------ | ------------------------------- | ---------------------- |
| `id_historique` | INT UNSIGNED | PRIMARY KEY, AUTO\_INCREMENT    | Identifiant historique |
| `id_circle`     | INT UNSIGNED | NOT NULL, FK → `cercles`        | Cercle concerné        |
| `action`        | ENUM(...)    | NOT NULL                        | Type d’action          |
| `fait_par`      | INT UNSIGNED | NOT NULL, FK → `users` SET NULL | Auteur de l’action     |
| `commentaire`   | TEXT         |                                 | Détail facultatif      |
| `date_action`   | DATETIME     | DEFAULT CURRENT\_TIMESTAMP      | Date de l’action       |

---

## 🕒 Table : `historique_messages`
Description : Historique des modifications ou suppressions des messages.

| Champ             | Type         | Contraintes                     | Description                   |
| ----------------- | ------------ | ------------------------------- | ----------------------------- |
| `id_historique`   | INT UNSIGNED | PRIMARY KEY, AUTO\_INCREMENT    | Identifiant historique        |
| `id_mensage`      | INT UNSIGNED | FK → `messages`                 | Message concerné              |
| `action`          | ENUM(...)    | NOT NULL                        | 'modification', 'suppression' |
| `fait_par`        | INT UNSIGNED | NOT NULL, FK → `users` SET NULL | Auteur de l’action            |
| `ancien_contenu`  | TEXT         |                                 | Contenu précédent             |
| `nouveau_contenu` | TEXT         |                                 | Nouveau contenu               |
| `date_action`     | DATETIME     | DEFAULT CURRENT\_TIMESTAMP      | Date de l’action              |

---




