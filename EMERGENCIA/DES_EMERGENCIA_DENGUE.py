import pandas as pd
from sqlalchemy import create_engine

# Configuración de conexión con SQLAlchemy
engine = create_engine("postgresql+psycopg2://postgres:Password2@10.0.1.6/DATAWAREHOUSE_ESSI")

# Definir la consulta SQL
query = """
SELECT
    er.redasiscod,
    er.redasisdes,
    cen.cenasicod,
    cen.cenasides,
    diags.diagcod,
    emer.anio_edad,
    emer.sexo,
    emer.motivo,
    emer.prioridad,
    diags.anio,
    emer.cod_tipdoc_paciente,  
    emer.doc_paciente
FROM sgss_mtdae10_anio_dengue diags
LEFT JOIN dw_emergencia_egresos emer
    ON diags.ateemeoricenasicod = emer.cod_oricentro 
    AND diags.ateemecenasicod = emer.cod_centro  
    AND diags.ateemeactmednum = emer.acto_med
LEFT JOIN centros_essi cen
    ON cen.cenasicod = emer.cod_centro
LEFT JOIN essi_red er
    ON er.redasiscod = cen.redasiscod 
WHERE diags.anio >= '2023'
"""

# Leer los datos en Pandas
df = pd.read_sql(query, engine)

# Ruta base para guardar los archivos
base_path = "c:/Users/gg.uipad01/Documents/DW/"

# Separar por año y guardar en archivos CSV individuales
for anio in df['anio'].unique():
    df_anio = df[df['anio'] == anio]
    csv_filename = f"{base_path}reporte_dengue_{anio}.csv"
    df_anio.to_csv(csv_filename, index=False, sep=';', encoding='utf-8', quotechar='"', quoting=1)
    print(f"Datos exportados a {csv_filename}")
