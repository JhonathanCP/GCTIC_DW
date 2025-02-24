import pandas as pd
from sqlalchemy import create_engine, text

# Configuración de conexión con SQLAlchemy
engine = create_engine("postgresql+psycopg2://postgres:Password2@10.0.1.6/DATAWAREHOUSE_ESSI")

# Consulta para obtener solo las tablas principales (excluyendo particiones)
query_tables = text("""
SELECT t.table_name 
FROM information_schema.tables t
LEFT JOIN pg_inherits i ON t.table_name = (SELECT relname FROM pg_class WHERE oid = i.inhrelid)
WHERE t.table_schema = 'public' 
AND (t.table_name LIKE 'dw_%' OR t.table_name = 'centro_quirurgico_historico_2')
AND i.inhrelid IS NULL;  -- Excluye particiones
""")

# Ejecutar la consulta y obtener los nombres de las tablas principales
with engine.connect() as conn:
    df_tables = pd.read_sql(query_tables, conn)

# Lista para almacenar los datos de las columnas
column_data = []

# Iterar sobre cada tabla principal para obtener sus columnas
for table in df_tables["table_name"]:
    query_columns = text(f"""
    SELECT column_name, data_type 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = '{table}';
    """)
    
    with engine.connect() as conn:
        df_columns = pd.read_sql(query_columns, conn)
    
    df_columns["table_name"] = table  # Agregar el nombre de la tabla a las columnas
    column_data.append(df_columns)

# Unir todos los datos en un solo DataFrame
df_final = pd.concat(column_data, ignore_index=True)

# Guardar en un archivo Excel
excel_filename = "c:/Users/gg.uipad01/Documents/DW/GENERAL/datos_tablas.xlsx"
df_final.to_excel(excel_filename, index=False)

print(f"Datos exportados a {excel_filename}")
