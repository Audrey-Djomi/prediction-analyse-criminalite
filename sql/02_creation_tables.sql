-- Créer une table qui contiendra les données du fichier CSV téléchargées.
CREATE TABLE criminalite (
code_departement VARCHAR(3),
code_region VARCHAR(3),
annee YEAR,
indicateur VARCHAR(150),
unite_de_compte VARCHAR(50),
nombre INT,
taux_pour_mille DECIMAL(10,7),
insee_pop INT,
insee_pop_millesime YEAR,
insee_log INT,
insee_log_millesime YEAR
);

SHOW TABLES;

DESCRIBE criminalite;

SHOW COLUMNS 
FROM criminalite;