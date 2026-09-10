# Analyse de la criminalité en France

## 📌 Présentation du projet

Ce projet a pour objectif d'analyser l'évolution de la criminalité en France à partir de données statistiques disponibles par département et par année.

### Source des données

 Depuis le site officiel https://www.data.gouv.fr/datasets/bases-statistiques-communale-departementale-et-regionale-de-la-delinquance-enregistree-par-la-police-et-la-gendarmerie-nationales

### Le fichier utilisé est :

donnee-dep-data.gouv-2025-geographie2026-produit-le2026-06-25.csv

L'analyse porte sur différents indicateurs de criminalité et cherche à mettre en évidence les évolutions, les disparités territoriales ainsi que les tendances observables au fil du temps.

Le projet est réalisé dans une démarche de **Data Analysis**, en utilisant principalement **Python et SQL** pour explorer, nettoyer, analyser et interpréter les données.

---

## 🎯 Objectifs

L'objectif est de mettre en pratique les compétences SQL à travers plusieurs étapes :

- exploration du jeu de données: 
  * Comprendre la structure d'un jeu de données de criminalité.
  * Identifier les indicateurs et les unités de compte disponibles.
- création d'une base de données MySQL,
- création d'une table adaptée aux données,
- importer les données d'un fichier CSV dans MySQL,
- vérifier la qualité et le nombre de lignes, la cohérence des données importées,
- réaliser les requêtes SQL pour répondre à des questions métiers,
- Comparer les résultats selon les années, les départements et les régions,
- interpréter les résultats.

---

## 📊 Données

Le jeu de données contient des informations sur différents indicateurs de criminalité à l'échelle départementale.

Les principales variables actuellement identifiées sont :

| Variable              | Description                                         |
| --------------------- | --------------------------------------------------- |
| `Code_departement`    | Code du département                                 |
| `Code_region`         | Code de la région                                   |
| `annee`               | Année de référence                                  |
| `indicateur`          | Indicateur de criminalité étudié                    |
| `unite_de_compte`     | Unité utilisée pour mesurer l'indicateur            |
| `nombre`              | Nombre de faits enregistrés                         |
| `taux_pour_mille`     | Taux rapporté à la population, pour 1 000 habitants |
| `insee_pop`           | Population issue des données INSEE                  |
| `insee_pop_millesime` | Millésime de la population INSEE                    |
| `insee_log`           | Nombre de logements                                 |
| `insee_log_millesime` | Millésime des données de logements INSEE            |

Le jeu de données comprend plusieurs catégories d'indicateurs de criminalité, qui seront étudiées au cours du projet.

---

## 🔎 Questions d'analyse

L'analyse a répondu aux questions métiers suivantes :

* Comment évolue la criminalité au cours des années ?
* Quels sont les indicateurs les plus représentés ?
* Quels départements présentent les taux les plus élevés ou les plus faibles ?
* Existe-t-il des différences importantes entre les régions ?
* Comment évoluent les différents indicateurs dans le temps ?
* Quels indicateurs présentent les évolutions les plus importantes ?
* Les départements les plus peuplés sont-ils nécessairement ceux qui présentent les taux les plus élevés ?
* Quelles tendances territoriales peut-on observer ?

Ces questions pourront être affinées au fur et à mesure de l'exploration des données.

---

## 🛠️ Technologies et outils utilisés

* Python
* Pandas
* Jupyter Notebook / VS Code
* MySQL 8.0.46
* MySQL Workbench
* SQL
* Git / GitHub

---

## 👩‍💻 Compétences mobilisées

Ce projet permet de mettre en pratique plusieurs compétences :

* Analyse exploratoire de données ;
* Nettoyage et préparation des données ;
* SQL ;
* Python / Pandas ;
* Statistiques descriptives ;
* Analyse géographique et temporelle ;
* Interprétation des résultats ;
* Documentation d'un projet Data ;
* Utilisation de Git et GitHub.

---

## Exploration initiale des données

Une première exploration a été réalisée avec Python et Pandas afin de comprendre la structure du fichier `exploration_donnees.ipynb`.

Le jeu de données contient :

18 180 lignes ;
11 colonnes ;
des années allant de 2016 à 2025 ;
101 départements ;
18 indicateurs ;
plusieurs unités de compte.

---
## Questions métiers étudiées
Plus de détails dans le fichier `04_requetes_metiers.sql` du dossier `sql`

1. Quels sont les différents indicateurs présents dans le jeu de données ?

Nous avons identifier les types de faits étudiés :

- homicides
- tentatives d'homicide
- violences physiques
- violences sexuelles
- cambriolages de logement
- vols de véhicules
- destructions et dégradations volontaires
- usage et trafic de stupéfiants
- escroqueries et fraudes.

2. Quels sont les départements qui enregistrent le plus d'homicides ?

Une première analyse a été réalisée sur les homicides, en utilisant l'unité de compte Victime.

Le classement cumulé sur la période 2016–2025 fait apparaître notamment :

- le département des Bouches-du-Rhône
- la Guyane
- le Nord
- Paris
- la Guadeloupe.

Cette analyse est réalisée en nombre absolu. Elle ne tient donc pas compte de la population des départements.

Une analyse complémentaire avec le taux pour mille a permis par la suite d'obtenir une comparaison différente entre les territoires.

Le classement change par rapport au nombre total de victimes.

Les Bouches-du-Rhône arrivaient en première position avec 622 victimes cumulées.
Mais lorsqu’on regarde le taux moyen, 
la Guyane arrive en première position avec environ 0,137 victime pour 1 000 habitants.
La Guadeloupe et la Martinique présentent également des taux moyens élevés.
Le département 13 reste dans le classement, mais il arrive désormais en septième position.

3. Comment évolue le nombre de victimes d'homicides entre 2016 et 2025 ?

Les résultats annuels montrent que :

le nombre le plus faible a été enregistré en 2020, avec 788 victimes ;
le nombre le plus élevé a été enregistré en 2023, avec 996 victimes ;
le nombre de victimes est passé de 911 en 2016 à 975 en 2025.

L'évolution absolue entre 2016 et 2025 est donc de :

+64 victimes

Une analyse avec la fonction LAG() a également permis de comparer les résultats entre deux années successives.

4. Quels départements connaissent la plus forte évolution entre 2023 et 2025 ?

Cette question a été étudiée sur deux indicateurs :

- les homicides et
- les cambriolages de logement.

Pour les homicides, les plus fortes hausses concernent notamment :

- le Rhône
- la Martinique
- l'Ille-et-Vilaine
- Paris
- la Meurthe-et-Moselle.

Les plus fortes baisses concernent notamment :

- les Bouches-du-Rhône
- la Guyane
- le Pas-de-Calais
- la Seine-Maritime
- la Seine-et-Marne.

Pour les cambriolages de logement, les plus fortes hausses concernent notamment :

- l'Ain
- la Meurthe-et-Moselle
- l'Isère
- les Côtes-d'Armor
- le Morbihan.

Les plus fortes baisses concernent notamment :

- Paris
- les Bouches-du-Rhône
- les Hauts-de-Seine
- la Seine-Saint-Denis
- la Gironde.

5. Quels sont les trois indicateurs les plus fréquents dans chaque région ?

Cette analyse a été réalisée en utilisant uniquement les lignes dont l'unité de compte est Infraction.

Les trois indicateurs les plus fréquents sont généralement :

- Destructions et dégradations volontaires
- Cambriolages de logement
- Vols violents sans arme.

La requête utilise la fonction de fenêtrage ROW_NUMBER() afin de classer les indicateurs à l'intérieur de chaque région.

Il faut distinguer les codes régionaux des codes départementaux.

Par exemple :

le code régional 11 correspond à l'Île-de-France
le code régional 94 correspond à la Corse
le code départemental 94 correspond au Val-de-Marne.

---

## Limites de l'analyse

Les résultats doivent être interprétés avec prudence.

Les principales limites sont les suivantes :

- les nombres absolus favorisent mécaniquement les territoires les plus peuplés
- les données correspondent aux faits enregistrés et non nécessairement à l'ensemble des faits réellement commis
- les unités de compte diffèrent selon les indicateurs
- les taux moyens calculés sur plusieurs années constituent une moyenne exploratoire
- les codes régionaux et départementaux doivent être correctement distingués
- les résultats ne permettent pas, à eux seuls, d'expliquer les causes des évolutions observées.

Une analyse complémentaire pourrait consister à utiliser les taux pour mille afin de comparer les territoires en tenant compte de leur population.

---
## Analyse complémentaire

Au cours de l'exploration des différents indicateurs, j'ai souhaité approfondir l'analyse des violences physiques intrafamiliales.

Cet indicateur utilise l'unité de compte `Victime`. J'ai donc réalisé une requête permettant de calculer le nombre cumulé de victimes enregistrées par département sur la période 2016-2025.

Le classement fait notamment apparaître :

- le Nord (59) : 92 512 victimes,
- la Seine-Saint-Denis (93) : 65 925,
- le Pas-de-Calais (62) : 60 214,
- les Bouches-du-Rhône (13) : 59 627,
- le Rhône (69) : 47 080.

Cette analyse est exprimée en nombre absolu et doit donc être interprétée avec prudence. Une comparaison rapportée à la population pourrait apporter une vision complémentaire des différences entre départements.

Cette analyse complémentaire illustre également la démarche exploratoire adoptée au cours du projet : partir des données disponibles pour identifier de nouvelles questions et approfondir certains indicateurs.

---
## Perspectives d'amélioration

Plusieurs améliorations pourraient être ajoutées par la suite :

* ajouter les noms des départements et des régions
* calculer des taux pour mille cumulés
* comparer les régions selon leur population
* créer des vues SQL pour simplifier les analyses
* produire des graphiques avec Python ou Power BI
* ajouter une analyse géographique
* automatiser l'importation des données
* ajouter des contrôles qualité reproductibles.

---

## 📄 Licence

Projet réalisé dans le cadre d'un portfolio Data Analyst.

👩 Auteur

Audrey DJOMI

Data Analyst | Python| SQL |

GitHub : https://github.com/Audrey-Djomi



## ✅ Projet terminé
