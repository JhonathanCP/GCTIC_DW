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

# Diagnósticos de renal a filtrar
DIAGCOD_RENAL = ('Z49.0', 'Z49.1', 'Z49.2', 'Z94.0', 'T86.1', 'T82.4', 'I12.0', 'Y84.1', 'Z99.2')
DIAGCOD_RENAL_LIKE = ['N17%', 'N18%', 'N19%']

# Años a considerar
ANIOS_PERMITIDOS = ('2019', '2020', '2021', '2022', '2023', '2024', '2025')

# Tablas de origen y destino
TABLAS_ORIGEN = [
    "sgss_ctdaa10_anio",
    "sgss_mtdae10_anio",
    "sgss_htdah10_anio",
    "sgss_qtiod10_anio"
]

TABLAS_DESTINO = [
    "sgss_ctdaa10_anio_renal",
    "sgss_mtdae10_anio_renal",
    "sgss_htdah10_anio_renal",
    "sgss_qtiod10_anio_renal"
]

# Columnas mapeadas para cada tabla
COLUMNAS = {
    "sgss_ctdaa10_anio": [
        "ATENAMBORICENASICOD", "ATENAMBCENASICOD", "ATENAMBACTMEDNUM",
        "CONDDIAGCOD", "DIAGCOD", "ATENAMBDIAGORD", 
        "ATENAMBTIPODIAGCOD", "ATENAMBCASODIAGCOD", 
        "DIAGATENAMBALTAFLAG", "DIAGATENAMBPEAS", "periodo", "anio"
    ],
    "sgss_mtdae10_anio": [
        "ateemeoricenasicod", "ateemecenasicod", "ateemeactmednum",
        "ateemesecnum", "conddiagcod", "diagcod", "ateemediagord",
        "ateemetipodiagcod", "periodo", "anio"
    ],
    "sgss_htdah10_anio": [
        "atenhosoricenasicod", "atenhoscenasicod", "atenhosactmednum",
        "atenhosnumsec", "conddiagcod", "diagcod", "atenhosdiagord",
        "atenhostipodiagcod", "periodo", "anio"
    ],
    "sgss_qtiod10_anio": [
        "infopeoricenasicod", "infopecenasicod", "infopeactmednum",
        "infopesecnum", "conddiagcod", "diagcod", "infopetipodiagcod",
        "infopediagord", "periodo", "anio"
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

                # Query para extraer datos filtrados por año con DIAGCOD y LIKE
                query_select = f"""
                    SELECT {', '.join(columnas)}
                    FROM {tabla_origen}
                    WHERE (
                        DIAGCOD IN {str(DIAGCOD_RENAL)}
                        OR DIAGCOD LIKE ANY (ARRAY[{', '.join(['%s'] * len(DIAGCOD_RENAL_LIKE))}])
                    )
                    AND anio = %s
                """

                params = DIAGCOD_RENAL_LIKE + [año]

                # Leer los datos para el año actual
                df = pd.read_sql(query_select, conn, params=params)

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
