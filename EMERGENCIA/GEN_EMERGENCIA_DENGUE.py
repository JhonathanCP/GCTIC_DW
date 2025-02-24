import psycopg2
import pandas as pd

# Configuración de la conexión a la base de datos PostgreSQL
conn = psycopg2.connect(
    host="10.0.1.6",  # Cambiar por el host
    dbname="DATAWAREHOUSE_ESSI",  # Cambiar por el nombre de la base de datos
    user="postgres",  # Cambiar por el usuario
    password="Password2"  # Cambiar por la contraseña
)

cur = conn.cursor()

# Definir las tablas particionadas (por ejemplo, dw_emergencia_egresos_2019, dw_emergencia_egresos_2020, etc.)
particiones = [f'dw_emergencia_egresos_{year}' for year in range(2019, 2025)]

# Tamaño del bloque de registros (por ejemplo, 10,000 registros por vez)
block_size = 1500000

# Consulta base con ROW_NUMBER() ajustado para particionar por cod_oricentro, cod_centro y acto_med
query = """
WITH temp_table AS (
    SELECT 
        emer.cod_oricentro,
        emer.cod_centro,
        emer.acto_med,
        diags.conddiagcod,
        diags.diagcod,
        diags.ateemediagord,
        diags.ateemetipodiagcod,
        diags.periodo,
        diags.anio,
        diags.ateemesecnum,  -- Agregamos ateemesecnum
        ROW_NUMBER() OVER (
            PARTITION BY emer.cod_oricentro, emer.cod_centro, emer.acto_med  -- Particionamos por estas 3 columnas
            ORDER BY diags.ateemesecnum DESC, emer.fec_altadm ASC  -- Ordenamos por el criterio deseado
        ) AS row_num
    FROM 
        {table_name} AS emer  -- Correctamente se asocia el alias 'emer' con la tabla particionada
    INNER JOIN 
        sgss_mtdae10_anio diags
    ON 
        emer.cod_oricentro = diags.ateemeoricenasicod
        AND emer.cod_centro = diags.ateemecenasicod
        AND emer.acto_med = diags.ateemeactmednum
    WHERE 
        diags.diagcod IN ('A97.1', 'A97.2', 'A97.0', 'A97.9', 'R50.9')
)
SELECT 
    cod_oricentro,
    cod_centro,
    acto_med,
    conddiagcod, 
    diagcod, 
    ateemediagord, 
    ateemetipodiagcod, 
    periodo, 
    anio,
    ateemesecnum  -- Incluir ateemesecnum en la selección
FROM 
    temp_table
WHERE 
    row_num = 1  -- Solo seleccionamos el primer registro de cada grupo
OFFSET {offset} LIMIT {block_size};
"""

for particion in particiones:
    offset = 0  # Inicializamos el offset para cada partición
    
    while True:
        query_with_table = query.format(table_name=particion, offset=offset, block_size=block_size)
        
        try:
            cur.execute(query_with_table)
            data = cur.fetchall()
            
            if not data:
                print(f"Bloque {offset}-{offset + block_size - 1} para la tabla {particion} está vacío.")
                break  # Salimos del ciclo si no hay más datos
            
            columns = ['ateemeoricenasicod', 'ateemecenasicod', 'ateemeactmednum', 
                       'conddiagcod', 'diagcod', 'ateemediagord', 'ateemetipodiagcod', 'periodo', 'anio', 'ateemesecnum']
            df = pd.DataFrame(data, columns=columns)
            
            print(f"Bloque cargado de la tabla {particion} (registros {offset}-{offset + block_size - 1})")
            print(df.head())

            for index, row in df.iterrows():
                insert_query = """
                INSERT INTO sgss_mtdae10_anio_dengue (
                    ateemeoricenasicod, ateemecenasicod, ateemeactmednum,
                    conddiagcod, diagcod, ateemediagord, ateemetipodiagcod, periodo, anio, ateemesecnum
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """
                cur.execute(insert_query, tuple(row))
            
            conn.commit()
            print(f"Datos insertados con éxito para la tabla {particion}, bloque {offset}-{offset + block_size - 1}")
            
            # Incrementamos el offset para procesar el siguiente bloque
            offset += block_size
        
        except Exception as e:
            conn.rollback()
            print(f"Error al procesar el bloque {offset}-{offset + block_size - 1} para la tabla {particion}: {e}")

cur.close()
conn.close()
