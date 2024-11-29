USE DATABASE data_lake_commerce;

-- Créer des schémas pour organiser les données
CREATE SCHEMA IF NOT EXISTS transactions_clients;
CREATE SCHEMA IF NOT EXISTS logs_serveurs;
CREATE SCHEMA IF NOT EXISTS medias_sociaux;
CREATE SCHEMA IF NOT EXISTS campagnes_pub;

-- Étape 1 : Créer des Tables de Test pour les Données

-- Table Transactions Clients :
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

-- Logs des Serveurs Web (données non structurées) :
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

-- Données des Médias Sociaux (semi-structurées) :
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

-- Flux de Données des Campagnes Publicitaires :
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
