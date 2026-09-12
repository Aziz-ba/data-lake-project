"""Local Streamlit dashboard (DuckDB) — mirror of the Snowflake Streamlit app.

    pip install streamlit duckdb pandas
    streamlit run local/app.py
"""
import pathlib
import duckdb
import streamlit as st

ROOT = pathlib.Path(__file__).resolve().parent
con = duckdb.connect()
con.execute("CREATE OR REPLACE TABLE exemple_data AS SELECT * FROM read_csv_auto(?)",
            [str(ROOT / "data" / "transactions.csv")])

st.title("Data Lake Insights — Commerce Transactions")
st.caption("Local DuckDB reproduction of the Snowflake data-lake dashboard.")

df = con.sql("SELECT * FROM exemple_data").df()
st.subheader("Customer transactions")
st.dataframe(df, use_container_width=True)

st.subheader("Total value per customer")
totals = con.sql("SELECT nom, SUM(valeur) AS total_valeur FROM exemple_data GROUP BY nom ORDER BY total_valeur DESC").df()
st.bar_chart(totals, x="nom", y="total_valeur")

st.subheader("Transactions per customer")
counts = con.sql("SELECT nom, COUNT(*) AS nombre FROM exemple_data GROUP BY nom").df()
st.bar_chart(counts, x="nom", y="nombre")

st.subheader("High-value transactions (> 200)")
st.dataframe(con.sql("SELECT * FROM exemple_data WHERE valeur > 200 ORDER BY valeur DESC").df(),
             use_container_width=True)
