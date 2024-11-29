-- Analyse de Transformation du Data Lake

-- Utiliser la base de données et le schéma appropriés
USE DATABASE data_lake_commerce;
USE SCHEMA public;

-- Créer une table pour stocker les données importées depuis GCS
CREATE OR REPLACE TABLE exemple_data (
  id INT,
  nom STRING,
  valeur DECIMAL(10, 2)
);

-- Charger les données depuis un fichier CSV d'exemple dans le bucket GCS
COPY INTO exemple_data
FROM @gcs_stage/IdNomValeur.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"')
ON_ERROR = 'CONTINUE';

-- Vérifier les Données Importées
SELECT * FROM exemple_data;

-- Créer une vue qui agrège les valeurs pour chaque utilisateur
CREATE OR REPLACE VIEW total_valeur_par_utilisateur AS
SELECT nom, SUM(valeur) AS total_valeur
FROM exemple_data
GROUP BY nom;

-- Vérifier les données de la vue
SELECT * FROM total_valeur_par_utilisateur;

-- Requête pour explorer les données supplémentaires
SELECT nom, COUNT(*) AS nombre_transactions, AVG(valeur) AS valeur_moyenne
FROM exemple_data
GROUP BY nom;



