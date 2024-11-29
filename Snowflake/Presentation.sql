-- Utiliser la base de données et le rôle appropriés
USE DATABASE data_lake_commerce;
USE ROLE ACCOUNTADMIN;

-- Étape 1 : Créer des Schémas pour Organiser les Données
CREATE SCHEMA IF NOT EXISTS transactions_clients;
CREATE SCHEMA IF NOT EXISTS logs_serveurs;
CREATE SCHEMA IF NOT EXISTS medias_sociaux;
CREATE SCHEMA IF NOT EXISTS campagnes_pub;

-- Étape 2 : Créer des Tables de Test pour les Données

-- Table Transactions Clients
USE SCHEMA transactions_clients;
CREATE OR REPLACE TABLE transactions_clients (
  transaction_id INT,
  client_id INT,
  montant DECIMAL(10, 2),
  date_transaction TIMESTAMP
);

INSERT INTO transactions_clients VALUES 
(1, 1, 150.75, '2024-11-28 10:00:00'),
(2, 2, 300.50, '2024-11-28 11:00:00');

-- Logs des Serveurs Web (données non structurées)
USE SCHEMA logs_serveurs;
CREATE OR REPLACE TABLE logs_serveurs (
  log_id INT,
  timestamp TIMESTAMP,
  niveau_log STRING,
  message STRING
);

INSERT INTO logs_serveurs VALUES 
(1, '2024-11-28 09:00:00', 'INFO', 'Serveur Aziz démarré avec succès'),
(2, '2024-11-28 09:15:00', 'ERROR', 'Erreur de connexion à la base de données Bago');

-- Données des Médias Sociaux (semi-structurées)
USE SCHEMA medias_sociaux;
CREATE OR REPLACE TABLE medias_sociaux (
  post_id INT,
  utilisateur_id STRING,
  contenu VARIANT,
  date_post TIMESTAMP
);

INSERT INTO medias_sociaux
SELECT 1, 'Aziz', PARSE_JSON('{"likes": 10, "shares": 2}'), '2024-11-28 08:30:00'
UNION ALL
SELECT 2, 'Bago', PARSE_JSON('{"likes": 5, "comments": 1}'), '2024-11-28 09:00:00';

-- Flux de Données des Campagnes Publicitaires
USE SCHEMA campagnes_pub;
CREATE OR REPLACE TABLE campagnes_pub (
  campagne_id INT,
  clics INT,
  impressions INT,
  cout DECIMAL(10, 2),
  date TIMESTAMP
);

INSERT INTO campagnes_pub VALUES 
(1, 100, 5000, 100.00, '2024-11-28 12:00:00'),
(2, 200, 10000, 300.00, '2024-11-28 13:00:00'),
(3, 300, 15000, 500.00, '2024-11-28 14:00:00');

-- Étape 3 : Configurer Snowflake pour Accéder à GCS
USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE STORAGE INTEGRATION gcs_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = GCS
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://data-lake-bucket-aziz-bago');

-- Étape 4 : Créer le Stage pour le Bucket GCS
CREATE OR REPLACE STAGE gcs_stage
  URL = 'gcs://data-lake-bucket-aziz-bago'
  STORAGE_INTEGRATION = gcs_integration;

-- Étape 5 : Vérifier l'Accès
LIST @gcs_stage;

-- Étape 6 : Charger un Fichier d'Exemple depuis GCS dans une Table Snowflake
CREATE OR REPLACE TABLE exemple_data (
  id INT,
  nom STRING,
  valeur DECIMAL(10, 2)
);

COPY INTO exemple_data
FROM @gcs_stage/IdNomValeur.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"')
ON_ERROR = 'CONTINUE';

-- Étape 7 : Vérifier les Données Importées
SELECT * FROM exemple_data;

-- Étape 8 : Création de Vues pour l'Analyse des Données

-- Vue pour agréger les valeurs pour chaque utilisateur
CREATE OR REPLACE VIEW total_valeur_par_utilisateur AS
SELECT nom, SUM(valeur) AS total_valeur
FROM exemple_data
GROUP BY nom;

-- Vue pour calculer la moyenne des valeurs par utilisateur
CREATE OR REPLACE VIEW moyenne_valeur_par_utilisateur AS
SELECT nom, AVG(valeur) AS moyenne_valeur
FROM exemple_data
GROUP BY nom;

-- Vue pour compter le nombre de transactions par utilisateur
CREATE OR REPLACE VIEW nombre_transactions_par_utilisateur AS
SELECT nom, COUNT(*) AS nombre_transactions
FROM exemple_data
GROUP BY nom;

-- Vue pour obtenir les transactions dont la valeur est supérieure à 200
CREATE OR REPLACE VIEW transactions_importantes AS
SELECT *
FROM exemple_data
WHERE valeur > 200;

-- Étape 9 : Requêtes d'Analyse des Données

-- Obtenir une synthèse de toutes les valeurs par utilisateur
SELECT nom, SUM(valeur) AS total_valeur, COUNT(*) AS nombre_transactions, AVG(valeur) AS valeur_moyenne
FROM exemple_data
GROUP BY nom;

-- Classement des utilisateurs par ordre décroissant de la valeur totale
SELECT nom, SUM(valeur) AS total_valeur
FROM exemple_data
GROUP BY nom
ORDER BY total_valeur DESC;


