# 🧊 Cloud Data Lake on Snowflake + GCS

A cloud **data lake** that ingests files landed in **Google Cloud Storage**, loads them into **Snowflake** (both automatically via **Snowpipe** and manually), transforms them into analytics-ready tables, and surfaces the insights through a **Streamlit** app.

---

## 🏗️ Architecture

```
   ┌──────────────┐   Storage        ┌───────────────┐   transform   ┌──────────────┐   query   ┌─────────────┐
   │  GCS bucket  │─▶ Integration ─▶ │   Snowflake   │─────────────▶ │  curated      │─────────▶ │  Streamlit  │
   │  (raw files) │   + Snowpipe     │  stage/tables │               │  tables       │           │  dashboard  │
   └──────────────┘                  └───────────────┘               └──────────────┘           └─────────────┘
```

1. **Ingestion** — a Snowflake **storage integration** connects securely to a GCS bucket; files are auto-loaded with **Snowpipe** (event-driven) or via a manual pipeline.
2. **Transformation** — SQL worksheets clean and reshape the raw data into curated tables.
3. **Serving** — a **Streamlit** app queries Snowflake directly (via Snowpark session) and renders interactive visualizations.

---

## 📂 Repository layout

| Path | What it is |
|------|-----------|
| [`Snowflake/AccesBucketGCP.sql`](Snowflake/AccesBucketGCP.sql) | Storage integration + external stage to the GCS bucket |
| [`Snowflake/Snowpipe.sql`](Snowflake/Snowpipe.sql) | Auto-ingest pipe definition |
| [`Snowflake/PipelineManuelle.sql`](Snowflake/PipelineManuelle.sql) | Manual `COPY INTO` loading pipeline |
| [`Snowflake/Analyse de Transformation du Data Lake.sql`](Snowflake/Analyse%20de%20Transformation%20du%20Data%20Lake.sql) | Transformation / analysis queries |
| [`Snowflake/MainWorksheet.sql`](Snowflake/MainWorksheet.sql) | Main working worksheet |
| [`Snowflake/Presentation.sql`](Snowflake/Presentation.sql) | Presentation / demo queries |
| [`Streamlit/App.py`](Streamlit/App.py) | Streamlit visualization app (runs in Snowflake / Snowpark) |

---

## 🚀 How it works

**1. Connect Snowflake to GCS**
```sql
CREATE OR REPLACE STORAGE INTEGRATION gcs_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = GCS
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://<your-bucket>');
```

**2. Auto-ingest with Snowpipe** — new files landing in the bucket flow straight into Snowflake tables.

**3. Visualize** — the Streamlit app opens the active Snowpark session and charts the curated data:
```python
from snowflake.snowpark.context import get_active_session
session = get_active_session()
df = session.sql("SELECT * FROM public.exemple_data").to_pandas()
```

---

## 🛠️ Tech Stack

![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=flat-square&logo=snowflake&logoColor=white)
![GCP](https://img.shields.io/badge/Google_Cloud_Storage-4285F4?style=flat-square&logo=googlecloud&logoColor=white)
![Streamlit](https://img.shields.io/badge/Streamlit-FF4B4B?style=flat-square&logo=streamlit&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=flat-square&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)

Snowflake · Snowpipe · Storage Integration · GCS · Snowpark · Streamlit

---

## 💻 Run it locally (no Snowflake account needed)

The Snowflake scripts above target a real Snowflake + GCS setup. To let anyone reproduce the analytics, this repo also ships a **local DuckDB version** that mirrors the same transformations and the same dashboard:

```bash
pip install -r local/requirements.txt
python local/build_duckdb.py     # runs the transformations + prints insights
streamlit run local/app.py       # the interactive dashboard, locally
```

It loads [`local/data/transactions.csv`](local/data/transactions.csv) (schema `id, nom, valeur` — identical to the Snowflake `exemple_data` table) and rebuilds the per-customer aggregations.

### 💡 Sample insights (from the local run)

- Customers ranked by **total value** and **transaction count** (top customer stands out clearly)
- **High-value transactions** (> 200) isolated for review
- Average basket value per customer — a proxy for engagement

---

## 📚 What this project demonstrates

- Building a **cloud data lake** end to end
- **Secure cloud-to-cloud** access (Snowflake ↔ GCS storage integration)
- **Event-driven ingestion** with Snowpipe vs. manual `COPY INTO`
- Turning raw files into curated tables with SQL
- Delivering insights through a **Streamlit** data app

---

## 📄 License

Released under the [MIT License](LICENSE).
