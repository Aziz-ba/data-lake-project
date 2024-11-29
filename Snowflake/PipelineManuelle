-- Utiliser la base de données et le schéma appropriés
USE DATABASE data_lake_commerce;
USE SCHEMA public;

-- Créer des vues complémentaires pour l'analyse des données

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

-- Requêtes d'analyse des données

-- Obtenir une synthèse de toutes les valeurs par utilisateur
SELECT nom, SUM(valeur) AS total_valeur, COUNT(*) AS nombre_transactions, AVG(valeur) AS valeur_moyenne
FROM exemple_data
GROUP BY nom;

-- Classement des utilisateurs par ordre décroissant de la valeur totale
SELECT nom, SUM(valeur) AS total_valeur
FROM exemple_data
GROUP BY nom
ORDER BY total_valeur DESC;

-- Création de graphiques dans avec charts et aussi streamlit
