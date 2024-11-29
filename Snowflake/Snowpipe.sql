USE DATABASE data_lake_commerce;
USE ROLE ACCOUNTADMIN;

-- Créer l'intégration de stockage (si elle n'existe pas déjà)
CREATE OR REPLACE STORAGE INTEGRATION gcs_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = GCS
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://data-lake-bucket-aziz-bago');

-- Configurer l'intégration de stockage manuellement dans la console Snowflake

-- Créer le stage
CREATE OR REPLACE STAGE gcs_stage
  URL = 'gcs://data-lake-bucket-aziz-bago'
  STORAGE_INTEGRATION = gcs_integration;

-- Créer le format de fichier
CREATE OR REPLACE FILE FORMAT my_csv_format
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1;

-- Créer le pipe avec l'intégration spécifiée
CREATE OR REPLACE PIPE exemple_pipe
AUTO_INGEST = true
INTEGRATION = 'GCS_INTEGRATION'
AS
COPY INTO exemple_data
FROM @gcs_stage/IdNomValeur.csv
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format');

SHOW STORAGE INTEGRATIONS;
GRANT OWNERSHIP ON INTEGRATION GCS_INTEGRATION TO ROLE ACCOUNTADMIN;
