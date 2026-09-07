## Contexte

L'objectif de ce projet est d'analyser les faits de délinquance enregistrés
dans les départements français à partir de données publiques.

L'analyse portera sur les indicateurs disponibles, leur évolution dans le temps
et leur répartition géographique.

Les résultats concerneront les faits enregistrés et ne permettront pas, à eux
seuls, de mesurer l'ensemble de la criminalité réelle.

## Questions métiers

Nous allons Définir quelques questions métiers de notre projet qui pourrons évoluer :

### Question 1 - Quels sont les différents types d'infractions présents dans le jeu de données ?

    Objectif : découvrir les indicateurs disponibles (Comprendre les données).

    ```sql
SELECT DISTINCT indicateur
FROM criminalite
ORDER BY indicateur;

Le jeu de données contient 18 indicateurs distincts. Ils couvrent notamment les homicides, les violences, les vols, les cambriolages, les dégradations, les stupéfiants et les escroqueries.

```text
docs/images/q1_types_infractions.png

### Question 2 - Quels sont les départements qui enregistrent le plus de faits ?

    Objectif : comparer les départements.

Pour répondre à cette question, nous analyserons pour chaque indicateur car il ne mesure pas tous les mêmes unités:

- Homicides - l'unité : victime

#### Question métier 2A: Quelles sont les dix combinaisons département/année ayant enregistré le plus grand nombre d’homicides ?

```sql
SELECT
    Code_departement,
    annee,
    indicateur,
    unite_de_compte,
    nombre,
    taux_pour_mille
FROM criminalite
WHERE indicateur = 'Homicides'
  AND unite_de_compte = 'Victime'
ORDER BY nombre DESC
LIMIT 10;

Le résultat montre que les valeurs les plus élevées concernent notamment
le département 06 en 2016, avec 97 victimes, et le département 13 en
2023, avec 84 victimes.

Le département 13 apparaît plusieurs fois dans le classement, car il s’agit d’un classement par année et non d’un classement global des départements.

Le nombre doit être distingué du taux pour mille : un département peut enregistrer davantage de victimes en raison de sa population plus importante, tandis qu’un autre peut présenter un taux plus élevé.

```text
docs/images/q2a_top_homicides_departement_annee.png

#### Question métier 2B : Quels sont les départements ayant enregistré le plus grand nombre de victimes d’homicides sur la période de 2016 à 2025 ?

```sql
SELECT
    Code_departement,
    SUM(nombre) AS total_homicides
FROM criminalite
WHERE indicateur = 'Homicides'
  AND unite_de_compte = 'Victime'
GROUP BY Code_departement
ORDER BY total_homicides DESC
LIMIT 10; 

Le département 13, correspondant aux Bouches-du-Rhône, présente le nombre cumulé le plus élevé de victimes d’homicides enregistrées sur la période 2016–2025, avec 622 victimes.

Il est suivi par la Guyane avec 391 victimes, le Nord avec 329 victimes
et Paris avec 306 victimes.

Ce classement repose sur les nombres absolus. Il ne tient pas compte
de la population des départements.

```text
docs/images/q2b_top_departements_homicides.png

Nous allons maintenant comparer les départements avec leur taux pour mille, afin de ne plus regarder uniquement les nombres absolus

#### Question métier 2C : Quels sont les départements présentant le taux moyen d homicides le plus élevé entre 2016 et 2025 ?

``` sql 
SELECT
    Code_departement,
    SUM(nombre) AS nombre_total,
    AVG(taux_pour_mille) AS taux_moyen
FROM criminalite
WHERE indicateur = 'Homicides'
  AND unite_de_compte = 'Victime'
GROUP BY Code_departement
ORDER BY taux_moyen DESC
LIMIT 10;

Le classement change par rapport au nombre total de victimes.

- Les Bouches-du-Rhône arrivaient en première position avec 622 victimes cumulées.
Mais lorsqu’on regarde le taux moyen, 
la Guyane arrive en première position avec environ 0,137 victime pour 1 000 habitants.
La Guadeloupe et la Martinique présentent également des taux moyens élevés.
Le département 13 reste dans le classement, mais il arrive désormais en septième position.

- Le classement diffère de celui basé sur le nombre total de victimes.
Les Bouches-du-Rhône présentent le nombre cumulé le plus élevé,
mais leur taux moyen est inférieur à celui de plusieurs départements
ultramarins.

Cela montre l’importance de distinguer :
le nombre absolu, qui dépend notamment de la taille de la population ;
le taux pour mille, qui permet une comparaison plus proportionnelle entre territoires.

```text
docs/images/q2c_top_homicides_taux_moyen_departement.png


### Question 3 - Comment évoluent les infractions entre 2016 et 2025 ?

    Objectif : comprendre la tendance temporelle (analyser l évolution).





### Question 4 - Quels départements connaissent la plus forte évolution entre 2023 et 2025 par exemple? ou Quels départements connaissent la plus forte progression ?
    
    Objectif : comparer deux périodes ou deux années


### Question 5 - Quels sont les trois indicateurs les plus fréquents dans chaque région ?

    Objectif : croiser les territoires et les indicateurs

Nos questions métiers nous permettrons de savoir quelles tables SQL devons-nous créer afin de les répondre ?

## Limites de l'analyse

Les données correspondent aux faits enregistrés par les services de police
et de gendarmerie. Elles ne représentent pas nécessairement l'ensemble des
faits réellement commis.

Les indicateurs peuvent utiliser des unités de compte différentes. Les
comparaisons devront donc tenir compte de cette distinction.