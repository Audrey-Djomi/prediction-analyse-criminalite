-- Exploration des données

-- Structure de nos données

SELECT *
FROM criminalite
LIMIT 10;
/* Cette requête nous montre que chaque ligne contient des données recensés : un département ;
une région,
une année,
un indicateur,
une unité de compte,
un nombre de faits,
un taux pour mille,
des données de population et de logements. 

Par exemple, le premier résultat signifie que, pour le département 01, en 2016 :
l’indicateur est Homicides,
l’unité de compte est Victime,
5 victimes ont été enregistrées,
le taux est de 0.0078318 pour 1 000 habitants. */

-- Question métier 1 : Quels sont les différents types d'infractions présents dans le jeu de données ?

SELECT DISTINCT (indicateur)
FROM criminalite
ORDER BY indicateur;

SELECT COUNT(DISTINCT indicateur) as nombre_indicateurs
FROM criminalite ;

/* Nous avons 18 indicateurs distincts : 
les cambriolages de logement,
les destructions et dégradations,
les escroqueries et fraudes,
les homicides,
Tentatives d'homicide,
Trafics de stupéfiants,
les usages de stupéfiants,
les violences,
les violences sexuelles,
les vols (avec armes, d'accessoires sur véhicules, dans les véhicules, violents sans armes, sans violence contre des personnes),
les vols de véhicules. */

-- Question métier 2 : Quels sont les départements qui enregistrent le plus de faits ?

-- Nous allons au préalable vérifier les différents unités de compte

SELECT distinct unite_de_compte
FROM criminalite;

-- Nous allons faire une analyse pour chaque indicateur et selon les unités de comptes
-- Question métier 2A: Quelles sont les dix combinaisons département/année ayant enregistré le plus grand nombre d'homicides ?

SELECT 
	code_departement,
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
-- Cette requête nous donne les 10 lignes présentant le plus grand nombre d’homicides enregistrés
		-- Le département 06 correspond aux Alpes-Maritimes,
        -- Le département 13 correspond aux Bouches-du-Rhône,
		-- Le département 973 correspond à la Guyane.
        
-- Question métier 2B: quels sont les départements ayant enregistré le plus grand nombre de victimes d’homicides sur l’ensemble de la période 2016–2025

SELECT code_departement,
		SUM(nombre) as nombre_total
FROM criminalite
WHERE indicateur = 'Homicides'
	AND unite_de_compte = 'Victime'
GROUP BY code_departement
ORDER BY nombre_total DESC
LIMIT 10 ;

/* de 2016-2025, le département 13, correspondant aux Bouches-du-Rhône qui présente 
le plus grand nombre cumulé de victimes d’homicides enregistrées, avec 622 victimes.
Il est suivi par :
la Guyane, avec 391 victimes ;
le Nord, avec 329 victimes ;
Paris, avec 306 victimes ;
la Guadeloupe, avec 285 victimes.*/

-- Nous allons maintenant comparer les départements avec leur taux pour mille annuel, afin de ne plus regarder uniquement les nombres absolus
-- Question métier 2C : Quels sont les départements présentant le taux moyen d homicides le plus élevé entre 2016 et 2025 ?
-- La valeur calculée correspond à une moyenne des taux annuels et non à un taux global cumulé sur toute la période.

SELECT code_departement,
		SUM(nombre) as total_victimes,
        AVG(taux_pour_mille) as taux_moyen
FROM criminalite
WHERE indicateur = 'Homicides'
	AND unite_de_compte = 'Victime'
GROUP BY code_departement
ORDER BY taux_moyen DESC
LIMIT 10 ;

-- Question métier 3: Comment évoluent les infractions entre 2016 et 2025 ?

SELECT annee,
		SUM(nombre) as total_victimes
FROM criminalite
WHERE indicateur = 'Homicides'
	AND unite_de_compte = 'Victime'
GROUP BY annee
ORDER BY annee DESC
LIMIT 10 ;

-- Pour mesurer l’évolution entre deux années
WITH evolution as (
SELECT annee,
		SUM(nombre) as total_victimes
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
    AS evolution_absolue
FROM evolution
ORDER BY annee;
/* Sur l’ensemble de la période, le nombre de victimes passe de 911 en 2016 à 975 en 2025, 
soit une augmentation absolue de 64 victimes. 
Le nombre de victimes reste toutefois fluctuant d’une année à l’autre.
*/
-- Question métier 4 : Quels départements connaissent la plus forte évolution entre 2023 et 2025 ?
-- Nous allons parcourir chaque indicateur et pour cela nous commencerons par les homicides entre 2023 et 2025
-- Question métier 4A: Comparer les homicides entre 2023 et 2025


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

-- Les plus fortes diminutions sont les suivantes :
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

-- Question métier 4B: Quels départements connaissent la plus forte évolution du nombre de cambriolages de logement entre 2023 et 2025 ?
-- Nous allons vérifier quel est l'unite de compte de l'indicateur 'cambriolages de logement'

SELECT DISTINCT indicateur, unite_de_compte
FROM criminalite
WHERE indicateur = 'cambriolages de logement';

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

