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
		-- Le départeemnt 973 correspond à la Guyane.