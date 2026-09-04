-- Nous allons importer le fichier CSV téléchargé sur le site officiel
LOAD DATA LOCAL INFILE 'E:/projet-analyse-criminalite/data/raw/donnee-dep-data.gouv-2025-geographie2026-produit-le2026-06-25.csv'
INTO TABLE criminalite
FIELDS terminated by ';'
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(
code_departement,
code_region,
annee,
indicateur,
unite_de_compte,
nombre,
@taux_pour_mille,
insee_pop,
insee_pop_millesime,
insee_log,
insee_log_millesime
)
SET taux_pour_mille = replace(@taux_pour_mille, ',', '.');

-- Affichons le nombre de lignes de notre BD

SELECT COUNT(*) FROM criminalite;

-- Affichons les premières lignes de notre BD
SELECT *
FROM criminalite
LIMIT 10;