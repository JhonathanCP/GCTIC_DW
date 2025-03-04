import psycopg2
import pandas as pd

# Configuración de la conexión a PostgreSQL
DB_CONFIG = {
    'dbname': 'DATAWAREHOUSE_ESSI',
    'user': 'postgres',
    'password': 'Password2',
    'host': '10.0.1.6',
    'port': '5432',
}

# Diagnósticos de vph a filtrar
DIAGCOD_VPH = ('B97.7%','gggg')  # Uso de LIKE con '%'

# Años a considerar
ANIOS_PERMITIDOS = ('2019', '2020', '2021', '2022', '2023', '2024', '2025')

# Tablas de origen y destino
TABLAS_ORIGEN = [
    "sgss_ctdaa10_anio",
]

TABLAS_DESTINO = [
    "sgss_ctdaa10_anio_vph",
]

# Columnas mapeadas para cada tabla
COLUMNAS = {
    "sgss_ctdaa10_anio": [
        "ATENAMBORICENASICOD", "ATENAMBCENASICOD", "ATENAMBACTMEDNUM",
        "CONDDIAGCOD", "DIAGCOD", "ATENAMBDIAGORD", 
        "ATENAMBTIPODIAGCOD", "ATENAMBCASODIAGCOD", 
        "DIAGATENAMBALTAFLAG", "DIAGATENAMBPEAS", "periodo", "anio"
    ]
}

# Función para extraer e insertar datos por año
def procesar_tablas_por_año():
    try:
        conn = psycopg2.connect(**DB_CONFIG, connect_timeout=10)  # Timeout de 10s
        cursor = conn.cursor()

        # Procesar por cada año permitido
        for año in ANIOS_PERMITIDOS:
            print(f"Procesando datos para el año {año}...")

            for i in range(len(TABLAS_ORIGEN)):
                tabla_origen = TABLAS_ORIGEN[i]
                tabla_destino = TABLAS_DESTINO[i]
                columnas = COLUMNAS[tabla_origen]

                # Query para extraer datos filtrados por año y diagnóstico
                query_select = f"""
                    SELECT {', '.join(columnas)}
                    FROM {tabla_origen}
                    WHERE (DIAGCOD LIKE %s or DIAGCOD = %s)
                    AND anio = %s
                """

                # Leer los datos para el año actual
                df = pd.read_sql(query_select, conn, params=(*DIAGCOD_VPH, año))

                if not df.empty:
                    # Insertar datos en la tabla destino
                    values_placeholder = ", ".join(["%s"] * len(columnas))
                    query_insert = f"""
                        INSERT INTO {tabla_destino} ({', '.join(columnas)})
                        VALUES ({values_placeholder})
                    """
                    cursor.executemany(query_insert, df.values.tolist())
                    conn.commit()

                    print(f"Datos insertados en {tabla_destino} para el año {año}: {len(df)} registros.")
                else:
                    print(f"No se encontraron datos en {tabla_origen} para el año {año}.")

        cursor.close()
        conn.close()
        print("Proceso completado.")

    except Exception as e:
        print(f"Error: {e}")

# Ejecutar el proceso por año
procesar_tablas_por_año()
