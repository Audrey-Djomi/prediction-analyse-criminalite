# Journal de bord — Projet Analyse de la criminalité

## Jour 1: 03/09/2026 — Initialisation du projet

### Objectif
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

### Premières observations
- Télécharger la BD que nous utiliserons pour notre projet depuis le site officiel https://www.data.gouv.fr/datasets/bases-statistiques-communale-departementale-et-regionale-de-la-delinquance-enregistree-par-la-police-et-la-gendarmerie-nationales

- Le fichier contient 18 180 lignes et 11 colonnes.
- Les données couvrent les années 2016 à 2025.
- Les données sont disponibles à l'échelle départementale (101 départements).
- Aucune valeur manquante n'a été détectée lors de la première vérification.
- Aucun doublon n'a été détecté lors de la première vérification.
- Vérifier la structure du fichier et la signification des colonnes.

### Définir les questions métiers auxquelles l'analyse SQL devra répondre

1. Quels sont les différents types d'infractions présents dans le jeu de données ?
2. Quels sont les départements qui enregistrent le plus de faits pour un indicateur donné ?
3. Comment évolue le nombre de faits enregistrés entre 2016 et 2025 ?
4. Quels départements connaissent la plus forte évolution entre 2023 et 2025 ?
5. Quels sont les trois indicateurs les plus fréquents dans chaque région ?

## Jour 2: Préparation et import des données dans MySQL
- Création de la base de données criminalite_db dans MySQL afin de disposer d'un environnement structuré pour le stockage et l'analyse des données.
- Création de la table criminalite avec une structure adaptée aux données du fichier CSV.
- Les types de données ont notamment été définis pour distinguer les informations textuelles, les années, les nombres de faits et les taux.
- Une configuration de MySQL a été nécessaire pour autoriser l'import local des fichiers avec local_infile
- Importation des données depuis notre CSV local. Nous avons eu le résultat : 18 180 lignes importées, 0 ligne supprimée, 0 ligne ignorée et 0 avertissement.

### Prochaine étape
Poursuite de l'exploration et des contrôles de qualité des données dans MySQL, avant de réaliser les analyses permettant de répondre aux différentes questions métiers définies pour le projet.