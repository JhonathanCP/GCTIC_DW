import polars as pl
import psycopg2
import time

# Configuración de la conexión a PostgreSQL
DB_CONFIG = {
    'dbname': 'DATAWAREHOUSE_ESSI',
    'user': 'postgres',
    'password': 'Password2',
    'host': '10.0.1.6',
    'port': '5432',
}

# Nombres de las tablas temporales
TABLAS_TMP = [
    "tmp_raras_actmed_ctdaa10",
    "tmp_raras_actmed_mtdae10",
    "tmp_raras_actmed_htdah10",
    "tmp_raras_actmed_qtiod10",
]

# Orden de columnas esperado en la tabla PostgreSQL
COLUMN_ORDER = [
    "cod_oricentro", "cod_centro", "acto_med", "cod_secuencia",
    "cod_conddiag", "cod_diagnostico", "cod_orden", "cod_tipodiag",
    "cmame_pacsecnum", "cod_tipdoc_paciente", "doc_paciente",
    "anio_edad", "sexo", "cas_adscripcion", "area", "cod_servicio",
    "anio_busqueda", "fecha_atencion", "tipo_busqueda", "row_num"
]

def procesar_datos():
    start_time = time.time()
    
    print("Conectando a la base de datos...")
    conn = psycopg2.connect(**DB_CONFIG)
    cursor = conn.cursor()

    print("Creando la tabla si no existe...")
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS mtd_lista_unica_pacientes(
            cod_oricentro VARCHAR(3),
            cod_centro VARCHAR(4),
            acto_med NUMERIC(10),
            cod_secuencia VARCHAR(500),
            cod_conddiag VARCHAR(3),
            cod_diagnostico VARCHAR(7),
            cod_orden NUMERIC(2),
            cod_tipodiag VARCHAR(3),
            cmame_pacsecnum VARCHAR(500),
            cod_tipdoc_paciente VARCHAR(500),
            doc_paciente VARCHAR(500),
            anio_edad VARCHAR(500),
            sexo VARCHAR(500),
            cas_adscripcion VARCHAR(500),
            area VARCHAR(500),
            cod_servicio VARCHAR(500),
            anio_busqueda VARCHAR(500),
            fecha_atencion VARCHAR(500),
            tipo_busqueda NUMERIC(2),
            row_num VARCHAR(1)
        )
    """)
    conn.commit()

    print("Leyendo el primer registro por paciente de cada tabla temporal...")
    registros = []
    for tabla in TABLAS_TMP:
        df = pl.read_database(f"""
            with datos as (
                select
                ROW_NUMBER() OVER (PARTITION BY cod_tipdoc_paciente, doc_paciente ORDER BY TO_DATE(fecha_atencion, 'DD/MM/YYYY')) AS row_num_2,*
                FROM {tabla})
            select * from datos where
            row_num_2 = '1'
        """, connection=conn)

        if df.shape[0] > 0:  # Verificar que la tabla no esté vacía
            registros.append(df)

    if not registros:
        print("No hay datos en las tablas temporales.")
        return

    print("Combinando registros de las tablas...")
    combined_df = pl.concat(registros)

    print("Agregando tipo_busqueda = 10...")
    combined_df = combined_df.with_columns(pl.lit(10).alias("tipo_busqueda"))

    print("Ordenando por paciente y fecha_atencion, asignando row_num...")

    combined_df = combined_df.with_columns([pl.col('fecha_atencion').str.to_date(format='%d/%m/%Y').alias('fecha_atencion')])

    combined_df = combined_df.sort(["cod_tipdoc_paciente", "doc_paciente", "fecha_atencion"]).with_columns(
        pl.col("cod_tipdoc_paciente").cum_count().over(["cod_tipdoc_paciente", "doc_paciente"]).cast(pl.Utf8).alias("row_num")
    )

    combined_df = combined_df.with_columns([pl.col('fecha_atencion').dt.to_string("%d/%m/%y").alias('fecha_atencion')])

    print("Reordenando columnas según el esquema...")
    combined_df = combined_df.select(COLUMN_ORDER)

    print("Insertando los datos en la base de datos...")
    for row in combined_df.iter_rows(named=True):
        values = tuple(row[col] for col in COLUMN_ORDER)
        cursor.execute(f"""
            INSERT INTO mtd_lista_unica_pacientes ({", ".join(COLUMN_ORDER)}) 
            VALUES ({", ".join(["%s"] * len(COLUMN_ORDER))})
        """, values)

    conn.commit()
    cursor.close()
    conn.close()
    
    print(f"Proceso completado en {time.time() - start_time:.2f} segundos.")

procesar_datos()
