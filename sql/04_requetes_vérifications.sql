-- Vérifier notre table créée

SELECT *
FROM criminalite;

-- Vérifier que la variable taux_pour_mille, ses valeurs marques les '.' et pas ',"

SELECT taux_pour_mille
FROM criminalite
LIMIT 10;

-- Vérifier la présence de valeurs manquantes

SELECT 
	COUNT(*) AS total,
    COUNT(code_departement) AS departements,
    COUNT(nombre) AS nombres,
    COUNT(indicateur) AS indicateurs,
    COUNT(taux_pour_mille) AS taux
FROM criminalite;