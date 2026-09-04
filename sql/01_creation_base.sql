/* Créer une nouvelle base de données et enregistrer les caractères et les textes en tenant compte des accents et autres 
case insensible : ne pas faire de différence entre les majuscules et les minuscules lors des comparaisons. */

CREATE DATABASE criminalite_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE criminalite_db;

SELECT DATABASE();
SHOW TABLES;



