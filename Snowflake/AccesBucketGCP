USE DATABASE data_lake_commerce;
DROP STORAGE INTEGRATION gcs_integration;

-- Étape 1 : Configurer Snowflake pour accéder à GCS
USE ROLE ACCOUNTADMIN;

-- Étape 2 : Créer une Integration GCS dans Snowflake
CREATE OR REPLACE STORAGE INTEGRATION gcs_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = GCS
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://data-lake-bucket-aziz-bago');

-- Étape 3 : Obtenir les informations d'intégration
DESC STORAGE INTEGRATION gcs_integration;

-- On utilise ces informations pour configurer l'accès dans Google Cloud IAM.

-- Étape 4 : Créer le Stage pour le Bucket GCS
CREATE OR REPLACE STAGE gcs_stage
  URL = 'gcs://data-lake-bucket-aziz-bago'
  STORAGE_INTEGRATION = gcs_integration;

-- Étape 5 : Vérifier l'Accès
LIST @gcs_stage;

-- Étape 6 : Charger un fichier d'exemple depuis GCS dans une table Snowflake
-- Créer une table simple pour stocker les données
CREATE OR REPLACE TABLE exemple_data (
  id INT,
  nom STRING,
  valeur DECIMAL(10, 2)
);


-- Charger les données depuis COPY INTO exemple_data
COPY INTO exemple_data
FROM @gcs_stage/IdNomValeur.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"')
ON_ERROR = 'CONTINUE';

-- Étape 7 : Vérifier les Données Importées
SELECT * FROM exemple_data;
