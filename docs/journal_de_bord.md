# Jour 1: 03/09/2026 — Initialisation du projet

## Objectif
Démarrer un projet d'analyse de données centré sur un SGBDR, à partir de données publiques sur la délinquance enregistrée en France.

### Travaux réalisés
- Création de l'architecture du projet.
- Ajout du dossier `data/raw/` pour les données brutes.
- Ajout du dossier `docs/` pour la documentation.
- Ajout du dossier `sql/` pour les scripts SQL.
- Ajout du notebook `exploration_donnees.ipynb`.
- Création du fichier `requirements.txt`.
- Création du fichier `.gitignore` afin d'exclure notamment l'environnement virtuel Python.
- Téléchargement d'un jeu de données départementales depuis data.gouv.fr.
- Première exploration du fichier : dimensions, informations générales, valeurs manquantes et doublons.

## Premières observations
- Télécharger la BD que nous utiliserons pour notre projet depuis le site officiel https://www.data.gouv.fr/datasets/bases-statistiques-communale-departementale-et-regionale-de-la-delinquance-enregistree-par-la-police-et-la-gendarmerie-nationales

- Le fichier contient 18 180 lignes et 11 colonnes.
- Les données couvrent les années 2016 à 2025.
- Les données sont disponibles à l'échelle départementale (101 départements).
- Aucune valeur manquante n'a été détectée lors de la première vérification.
- Aucun doublon n'a été détecté lors de la première vérification.
- Vérifier la structure du fichier et la signification des colonnes.

## Définir les questions métiers auxquelles l'analyse SQL devra répondre

1. Quels sont les différents types d'infractions présents dans le jeu de données ?
2. Quels sont les départements qui enregistrent le plus de faits pour un indicateur donné ?
3. Comment évolue le nombre de faits enregistrés entre 2016 et 2025 ?
4. Quels départements connaissent la plus forte évolution entre 2023 et 2025 ?
5. Quels sont les trois indicateurs les plus fréquents dans chaque région ?

# Jour 2: Préparation et import des données dans MySQL
- Création de la base de données criminalite_db dans MySQL afin de disposer d'un environnement structuré pour le stockage et l'analyse des données.
- Création de la table criminalite avec une structure adaptée aux données du fichier CSV.
- Les types de données ont notamment été définis pour distinguer les informations textuelles, les années, les nombres de faits et les taux.
- Une configuration de MySQL a été nécessaire pour autoriser l'import local des fichiers avec local_infile
- Importation des données depuis notre CSV local. Nous avons eu le résultat : 18 180 lignes importées, 0 ligne supprimée, 0 ligne ignorée et 0 avertissement.

# Jour 3 : Analyse de l’évolution des homicides
- La colonne taux_pour_mille a bien été pris en compte et les valeurs décimales ont été converties avec un point comme séparateur décimal, conformément au format attendu par MySQL.
- quelques requêtes de contrôles effectués pour vérifier le nombre de lignes importées et la présence de valeurs manquantes.
- Analyse des données à l’aide de requêtes SQL,
- Etude les homicides afin de répondre aux question métiers voir le fichier sql/04_requetes_metiers.sql
- Synthèse des résultats et leur interprétation sont dans le fichier docs/questions_metiers.md.
- Analyse de l’évolution des homicides entre 2016 et 2025

# Jour 4: Suite Analyses
- Analyse de l’évolution des homicides entre 2023 et 2025

Les plus fortes hausses sont enregistrées dans :

- le Rhône et la Martinique, avec 14 victimes supplémentaires chacun ;
- l’Ille-et-Vilaine, avec 11 victimes supplémentaires ;
- Paris, avec 10 victimes supplémentaires ;
- la Meurthe-et-Moselle, avec 9 victimes supplémentaires.

À l’inverse, les plus fortes baisses concernent :

- les Bouches-du-Rhône, avec 28 victimes de moins ;
- la Guyane, avec 19 victimes de moins ;
- le Pas-de-Calais et la Seine-Maritime, avec 11 victimes de moins chacun.

Cette analyse montre que l’évolution nationale ne se traduit pas de manière uniforme dans les différents départements. Certains territoires connaissent une hausse, tandis que d’autres enregistrent une baisse importante.

- Analyse de l’évolution des cambriolages de logement entre 2023 et 2025

- requête pour vérifier l’unité de compte utilisée pour cet indicateur. Les cambriolages de logement sont exprimés en infractions.

- Comparer le nombre d’infractions enregistrées en 2023 et en 2025 pour chaque département. La requête calcule également l’évolution absolue entre les deux années.

Les résultats montrent des évolutions très contrastées.

Les plus fortes hausses sont observées dans :

- l’Ain, avec 782 cambriolages supplémentaires,
- la Meurthe-et-Moselle, avec 686 infractions supplémentaires,
- l’Isère, avec 608 infractions supplémentaires,
- les Côtes-d’Armor, avec 606 infractions supplémentaires,
- le Morbihan, avec 566 infractions supplémentaires.

Les plus fortes baisses concernent :

- Paris, avec 4 889 cambriolages de moins,
- les Bouches-du-Rhône, avec 2 728 infractions de moins,
- les Hauts-de-Seine, avec 1 944 infractions de moins,
- la Seine-Saint-Denis, avec 1 054 infractions de moins,
- la Gironde, avec 1 048 infractions de moins.

Cette analyse montre que les évolutions peuvent être très différentes selon les départements. Cependant, la comparaison en nombre absolu doit être interprétée avec prudence, car les départements n’ont pas tous la même population.

# Jour 5: Suite et fin Analyses

- Identification des trois indicateurs les plus fréquents dans chaque région
- Nous avons comparer les volumes d’infractions enregistrées selon les régions et d’identifier les indicateurs qui représentent les plus grands nombres de faits.

- Avant, nous avons vérifier les unités de compte présentes dans le jeu de données.
- Puis nous avons fait une analyse aux lignes dont l’unité de compte est `Infraction`.

Nous avons utilisé une requête SQL reposant sur une CTE et la fonction de classement `ROW_NUMBER()`. Cette fonction permet de classer les indicateurs à l’intérieur de chaque région et de conserver uniquement les trois premiers.

Les résultats montrent que les trois indicateurs les plus fréquents sont principalement :

1. Destructions et dégradations volontaires ;
2. Cambriolages de logement ;
3. Vols violents sans arme.

Les destructions et dégradations volontaires arrivent en première position dans toutes les régions étudiées. Les cambriolages de logement occupent généralement la deuxième position, tandis que les vols violents sans arme apparaissent le plus souvent en troisième position.

Les volumes les plus importants sont observés dans les régions les plus peuplées, notamment l’Île-de-France, les Hauts-de-France, l’Auvergne-Rhône-Alpes et la Provence-Alpes-Côte d’Azur.

Cette analyse doit toutefois être interprétée avec prudence, car les régions n’ont pas toutes la même population ni le même nombre de départements. Les résultats représentent des volumes absolus d’infractions enregistrées et non des taux rapportés à la population.

L'ensemble de nos requêtes utilisées sont conservées dans le fichier `sql/04_requetes_metiers.sql`. La synthèse des résultats est ajoutée dans `docs/questions_metiers.md`.

