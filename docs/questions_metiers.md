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

- Nous nous concrerons sur l'indicateur Homicides - l'unité : victime

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

    Objectif : comprendre la tendance temporelle (en analysant l'évolution).

```sql

SELECT annee,
		SUM(nombre) as total_victimes
FROM criminalite
WHERE indicateur = 'Homicides'
	AND unite_de_compte = 'Victime'
GROUP BY annee
ORDER BY annee DESC
LIMIT 10 ;

Entre 2016 et 2025, le nombre de victimes d’homicides enregistrées évolue de manière irrégulière :

2016 : 911 victimes
2017 : 835 victimes, soit une baisse de 76 victimes
2018 : 845 victimes, soit une hausse de 10 victimes
2019 : 878 victimes, soit une hausse de 33 victimes
2020 : 788 victimes, soit une baisse de 90 victimes
2021 : 840 victimes, soit une hausse de 52 victimes
2022 : 958 victimes, soit une hausse de 118 victimes
2023 : 996 victimes, soit une hausse de 38 victimes
2024 : 976 victimes, soit une baisse de 20 victimes
2025 : 975 victimes, soit une légère baisse de 1 victime

La valeur la plus faible est enregistrée en 2020 avec 788 victimes, tandis que la valeur la plus élevée est observée en 2023 avec 996 victimes.
Une hausse importante entre 2021 et 2023, une légère baisse est observée en 2024 et 2025.


```text
docs/images/q3_evolution_infraction_2016_2025.png

#### Question métier 3A : mesurer l’évolution entre deux années

```sql
WITH evolution AS (
    SELECT
        annee,
        SUM(nombre) AS total_victimes
    FROM criminalite
    WHERE indicateur = 'Homicides'
      AND unite_de_compte = 'Victime'
    GROUP BY annee
)

SELECT
    annee,
    total_victimes,
    LAG(total_victimes) OVER (ORDER BY annee) AS victimes_annee_precedente,
    total_victimes
        - LAG(total_victimes) OVER (ORDER BY annee)
        AS evolution_absolue,
    ROUND(
        (
            total_victimes
            - LAG(total_victimes) OVER (ORDER BY annee)
        )
        / NULLIF(LAG(total_victimes) OVER (ORDER BY annee), 0)
        * 100,
        2
    ) AS evolution_pourcentage
FROM evolution
ORDER BY annee;

On observe les principales variations annuelles :

- La plus forte baisse est observée entre 2019 et 2020, avec 90 victimes en moins.
- La plus forte hausse est observée entre 2021 et 2022, avec 118 victimes supplémentaires.
- Entre 2024 et 2025, le nombre de victimes diminue très légèrement, avec une victime en moins.

```text
docs/images/q3a_evolution_entre_deux_annee.png

### Question 4 - Quels départements connaissent la plus forte évolution entre 2023 et 2025? ou Quels départements connaissent la plus forte progression ?
    
    Objectif : comparer deux périodes ou deux années

Pour cette analyse, nous allons comparer les données de 2023 et de 2025, indicateur par indicateur.

Comme les indicateurs n’ont pas tous la même unité de compte, 
- nous allons commencer avec les homicides, que nous avons déjà étudiés ci-dessus.

```sql
    SELECT 
	code_departement,
    SUM(
		CASE 
			WHEN annee = 2023 THEN nombre
            ELSE 0
		END
        ) AS victimes_2023,
	SUM(
		CASE
			WHEN annee = 2025 THEN nombre
            ELSE 0
		END
        ) AS victimes_2025,
	SUM(
		CASE
			WHEN annee = 2025 THEN nombre
            ELSE 0
		END
		)
        -
	SUM(
		CASE
			WHEN annee = 2023 THEN nombre
            ELSE 0
		END
		) AS homicides_2023_2025
FROM criminalite
WHERE indicateur = 'Homicides'
	AND unite_de_compte = 'Victime'
    AND annee IN (2023,2025)
GROUP BY code_departement 
HAVING victimes_2023 IS NOT NULL
	AND victimes_2025 IS NOT NULL
ORDER BY homicides_2023_2025 DESC 
LIMIT 10;

Les départements ayant connu la plus forte hausse en nombre absolu sont donc :

le Rhône (69) et la Martinique (972), avec 14 victimes supplémentaires ;
l’Ille-et-Vilaine (35), avec 11 victimes supplémentaires ;
Paris (75), avec 10 victimes supplémentaires.
```text
docs/images/q4a_homicide_2023_2025.png

Les plus fortes diminutions sont les suivantes :

```sql
SELECT 
	code_departement,
    SUM(
		CASE 
			WHEN annee = 2023 THEN nombre
            ELSE 0
		END
        ) AS victimes_2023,
	SUM(
		CASE
			WHEN annee = 2025 THEN nombre
            ELSE 0
		END
        ) AS victimes_2025,
	SUM(
		CASE
			WHEN annee = 2025 THEN nombre
            ELSE 0
		END
		)
        -
	SUM(
		CASE
			WHEN annee = 2023 THEN nombre
            ELSE 0
		END
		) AS homicides_2023_2025
FROM criminalite
WHERE indicateur = 'Homicides'
	AND unite_de_compte = 'Victime'
    AND annee IN (2023,2025)
GROUP BY code_departement 
HAVING victimes_2023 IS NOT NULL
	AND victimes_2025 IS NOT NULL
ORDER BY homicides_2023_2025 ASC 
LIMIT 10;

La plus forte baisse entre 2023 et 2025 concerne donc :

les Bouches-du-Rhône (13), avec 28 victimes de moins;
la Guyane (973) avec 19 victimes de moins et suivi du Pas-de-Calais(62) et Seine-Maritime(76) avec 11 victimes de moins.

Ces résultats montrent que l’évolution nationale observée précédemment ne se traduit pas de la même manière dans tous les territoires. Certains départements connaissent une hausse importante, tandis que d’autres enregistrent une baisse.

Il faut toutefois rester prudent : cette comparaison porte sur des nombres absolus. Elle ne tient pas compte de la population de chaque département. 
Une analyse complémentaire avec les taux pour mille permettrait de mieux comparer les territoires de tailles différentes.

- Question métier 4B: Quels départements connaissent la plus forte évolution du nombre de cambriolages de logement entre 2023 et 2025 ?

- Nous allons vérifier quel est l unite de compte de lindicateur cambriolages de logement

```sql

SELECT DISTINCT indicateur, unite_de_compte
FROM criminalite
WHERE indicateur = 'cambriolages de logement';

Puis 

```sql

SELECT code_departement,
	SUM(
    CASE
		WHEN annee = 2023 THEN nombre
        ELSE 0
	END
    ) as cambriolages_2023,
    
    SUM( 
		CASE
			WHEN annee = 2025 THEN nombre
            ELSE 0
		END
            ) as cambriolages_2025,
            
	SUM(
		CASE
			WHEN annee = 2025 THEN nombre
            ELSE 0
		END
            )
	- 
    SUM(
		CASE
			WHEN annee = 2023 THEN nombre
            ELSE 0
		END
            ) as cambriolages_2023_2025
            
FROM criminalite
WHERE indicateur = 'cambriolages de logement'
	AND unite_de_compte = 'Infraction'
    AND annee IN (2023,2025)
GROUP BY code_departement
ORDER BY cambriolages_2023_2025 DESC;

Le département qui connaît la plus forte hausse est  l’Ain, avec 782 cambriolages supplémentaires entre 2023 et 2025.
On peut aussi trouver cette hausse dans la Meurthe-et-Moselle(54) avec plus de 686 cambriolages, l’Isère(38) avec plus de 608 , les Côtes-d’Armor(22) avec plus de 606, le Morbihan(56) avec plus de 566 cambriolages.

La plus forte baisse concerne Paris, avec 4 889 cambriolages de moins en 2025 par rapport à 2023.
On trouve cette diminution dans les Bouches-du-Rhône(13) avec moins de 2 728, les Hauts-de-Seine(92) avec moins de 1 944, la Seine-Saint-Denis(93) avec moins de 1 054 , la Gironde(33) avec moins de 1 048 cambriolages.

``` text
docs/images/q4b_cambriolages_2023_2025.png

Entre 2023 et 2025, les cambriolages de logement évoluent différemment selon les départements. L’Ain connaît la plus forte hausse, avec 782 infractions supplémentaires. Paris enregistre la plus forte baisse, avec 4 889 infractions de moins.

### Question 5 - Quels sont les trois indicateurs les plus fréquents dans chaque région ?

    Objectif : croiser les territoires et les indicateurs
Certaines requêtes ont été réalisées avant, à voir dans le fichier `04_requetes_metiers`

```sql
    WITH classement AS (
	SELECT code_region,
        indicateur,
        SUM(nombre) AS total_faits,
        ROW_NUMBER() OVER (PARTITION BY code_region
							ORDER BY SUM(nombre) DESC
					) AS rang
FROM criminalite
GROUP BY code_region, indicateur
)

SELECT code_region,
		indicateur,
        total_faits,
        rang
FROM classement
WHERE rang <=3
ORDER BY code_region, rang;

Rappelons nous que :
cette requête additionne directement tous les indicateurs, ce qui peut donc mélanger des éléments différents. Par exemple, une victime ne représente pas nécessairement une infraction, et un véhicule ne représente pas une personne.

Nous pouvons observer que les principalement que: 

- Les destructions et dégradations volontaires arrivent en première position dans toutes les régions étudiées.
- Les cambriolages de logement arrivent en deuxième position dans toutes les régions.
- Les vols violents sans arme occupent généralement la troisième position.

Les régions 11 (Île-de-France), 84(Auvergne-Rhône-Alpes), 93(Provence-Alpes-Côte d’Azur), 32(Hauts-de-France) et 44(Grand Est) présentent les volumes les plus élevés, ce qui peut s’expliquer notamment par leur population et leur nombre de départements.

La région 94(Corse) présente des volumes beaucoup plus faibles.

``` text
docs/images/q5_top3_indicateurs_regions.png

Si nous voulons filtrer quand l'unité de compte est Infraction, nous ferions:
```sql
WITH classement AS (
    SELECT
        Code_region,
        indicateur,
        SUM(nombre) AS total_faits,
        ROW_NUMBER() OVER (
            PARTITION BY Code_region
            ORDER BY SUM(nombre) DESC
        ) AS rang
    FROM criminalite
    WHERE unite_de_compte = 'Infraction'
    GROUP BY
        Code_region,
        indicateur
)
SELECT
    Code_region,
    indicateur,
    total_faits,
    rang
FROM classement
WHERE rang <= 3
ORDER BY total_faits DESC, Code_region, rang;


Les régions 11 (Île-de-France), 84(Auvergne-Rhône-Alpes), 32(Hauts-de-France),93(Provence-Alpes-Côte d’Azur), 84(Auvergne-Rhône-Alpes) présentent les volumes les plus élevés.

En Île-de-France, les trois indicateurs les plus fréquents sont :
Vols sans violence contre des personnes lorsque toutes les unités de compte sont incluses ;
Destructions et dégradations volontaires ;
Escroqueries et fraudes aux moyens de paiement.

Cependant, lorsque nous limitons l’analyse aux lignes dont l’unité est Infraction, le classement devient :

Destructions et dégradations volontaires : 1 102 495 infractions ;
Cambriolages de logement : 444 585 infractions ;
Vols violents sans arme : 311 017 infractions.

Cette différence montre pourquoi il était important de contrôler l’unité de compte avant de comparer les indicateurs.

La région Corse(94) présente les volumes d’infractions les plus faibles parmi les régions étudiées, ce qui peut notamment s’expliquer par une population moins importante que celle des grandes régions métropolitaines.

``` text
docs/images/q5_top_homicides_regions.png

### Limites de l'analyse

Les données correspondent aux faits enregistrés par les services de police et de gendarmerie. Elles ne représentent pas nécessairement l'ensemble des faits réellement commis.

Les indicateurs utilisent des unités de compte différentes. Les comparaisons tiennent compte de cette distinction.