"""Local reproduction of the Snowflake transformations using DuckDB.

Loads local/data/transactions.csv, builds the same aggregations the Snowflake
SQL creates, and prints insights. No Snowflake account required.

    python local/build_duckdb.py
"""
import pathlib
import duckdb

ROOT = pathlib.Path(__file__).resolve().parent
csv_path = ROOT / "data" / "transactions.csv"

con = duckdb.connect(str(ROOT / "data_lake.duckdb"))
con.execute("CREATE OR REPLACE TABLE exemple_data AS SELECT * FROM read_csv_auto(?)", [str(csv_path)])

# Mirror of total_valeur_par_utilisateur (Snowflake view)
con.execute("""
  CREATE OR REPLACE VIEW total_valeur_par_utilisateur AS
  SELECT nom, ROUND(SUM(valeur), 2) AS total_valeur,
         COUNT(*) AS nombre_transactions,
         ROUND(AVG(valeur), 2) AS valeur_moyenne
  FROM exemple_data GROUP BY nom ORDER BY total_valeur DESC
""")

print("=== Total value per customer ===")
print(con.sql("SELECT * FROM total_valeur_par_utilisateur").df().to_string(index=False))

top = con.sql("SELECT nom, total_valeur FROM total_valeur_par_utilisateur LIMIT 1").fetchone()
big = con.sql("SELECT COUNT(*) FROM exemple_data WHERE valeur > 200").fetchone()[0]
total = con.sql("SELECT ROUND(SUM(valeur),2) FROM exemple_data").fetchone()[0]
print("\n=== Insights ===")
print(f"Top customer by value: {top[0]} ({top[1]})")
print(f"High-value transactions (>200): {big}")
print(f"Total transaction value: {total}")
con.close()
