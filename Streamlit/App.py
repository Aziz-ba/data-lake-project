# Import python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session
import pandas as pd

# Title of the app
st.title("Data Lake Insights: Visualizing Business Data with Snowflake")

# Write a description
st.write(
    """Cette application Streamlit vous permet de visualiser les données du projet Data Lake, extraites de Snowflake.\n
    Utilisez les différentes visualisations pour explorer les tendances et obtenir des informations importantes.\n
    """
)

# Get the current Snowflake session
session = get_active_session()

# Query Snowflake data using raw SQL to extract data from the "exemple_data" table
exemple_data_query = session.sql("SELECT * FROM public.exemple_data")
exemple_data_df = exemple_data_query.to_pandas()

# Display queried data
st.subheader("Données des Transactions Clients")
st.dataframe(exemple_data_df, use_container_width=True)

# Visualisation: Total des valeurs par utilisateur
st.subheader("Total des Valeurs par Utilisateur")
total_values_query = session.sql(
    """
    SELECT NOM, SUM(VALEUR) AS TOTAL_VALEUR
    FROM public.exemple_data
    GROUP BY NOM
    """
)
total_values_df = total_values_query.to_pandas()
st.bar_chart(data=total_values_df, x="NOM", y="TOTAL_VALEUR")

# Visualisation: Nombre de Transactions par Utilisateur
st.subheader("Nombre de Transactions par Utilisateur")
transactions_count_query = session.sql(
    """
    SELECT NOM, COUNT(*) AS NOMBRE_TRANSACTIONS
    FROM public.exemple_data
    GROUP BY NOM
    """
)
transactions_count_df = transactions_count_query.to_pandas()
st.bar_chart(data=transactions_count_df, x="NOM", y="NOMBRE_TRANSACTIONS")

# Visualisation: Transactions Importantes (Valeur > 200)
st.subheader("Transactions Importantes (Valeur > 200)")
important_transactions_query = session.sql(
    """
    SELECT *
    FROM public.exemple_data
    WHERE VALEUR > 200
    """
)
important_transactions_df = important_transactions_query.to_pandas()
st.dataframe(important_transactions_df, use_container_width=True)

# Add some insights based on the data
st.subheader("Observations et Insights")
st.write(
    """
    - Les utilisateurs avec les valeurs totales les plus élevées sont mis en évidence dans le graphique des valeurs totales.
    - Le nombre de transactions par utilisateur est une mesure clé pour comprendre l'engagement de chaque client.
    - Les transactions importantes (celles dont la valeur est supérieure à 200) sont affichées ci-dessus pour évaluer les grosses contributions.
    """
)
