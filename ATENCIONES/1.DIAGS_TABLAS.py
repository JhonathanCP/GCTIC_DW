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

# Diagnósticos de hipertensión a filtrar
DIAGCOD_HIPERTENSION = ('I10', 'I10.X', 'I11', 'I11.0', 'I11.9', 
                        'I12', 'I12.0', 'I12.9', 'I13', 'I13.0', 
                        'I13.1', 'I13.2', 'I13.9')

# Años a considerar
ANIOS_PERMITIDOS = ('2023', '2024')

# Tablas de origen y destino
TABLAS_ORIGEN = [
    "sgss_ctdaa10_anio",
    "sgss_mtdae10_anio",
    "sgss_htdah10_anio"
]

TABLAS_DESTINO = [
    "sgss_ctdaa10_anio_hipertension",
    "sgss_mtdae10_anio_hipertension",
    "sgss_htdah10_anio_hipertension"
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
        "ATEEMEORICENASICOD", "ATEEMECENASICOD", "ATEEMEACTMEDNUM",
        "ATEEMENUMSEC", "CONDDIAGCOD", "DIAGCOD", "ATEEMEDIAGORD",
        "ATEEMETIPODIAGCOD", "periodo", "anio"
    ],
    "sgss_htdah10_anio": [
        "ATENHOSORICENASICOD", "ATENHOSCENASICOD", "ATENHOSACTMEDNUM",
        "ATENHOSNUMSEC", "CONDDIAGCOD", "DIAGCOD", "ATENHOSDIAGORD",
        "ATENHOSTIPODIAGCOD", "periodo", "anio"
    ]
}

# Función para extraer e insertar datos
def procesar_tablas():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()

        for i in range(len(TABLAS_ORIGEN)):
            tabla_origen = TABLAS_ORIGEN[i]
            tabla_destino = TABLAS_DESTINO[i]
            columnas = COLUMNAS[tabla_origen]

            # Query para extraer datos filtrados
            query_select = f"""
                SELECT {', '.join(columnas)}
                FROM {tabla_origen}
                WHERE DIAGCOD IN {DIAGCOD_HIPERTENSION}
                AND anio IN {ANIOS_PERMITIDOS}
            """

            df = pd.read_sql(query_select, conn)

            if not df.empty:
                # Insertar datos en la tabla destino
                values_placeholder = ", ".join(["%s"] * len(columnas))
                query_insert = f"""
                    INSERT INTO {tabla_destino} ({', '.join(columnas)})
                    VALUES ({values_placeholder})
                """
                cursor.executemany(query_insert, df.values.tolist())
                conn.commit()

                print(f"Datos insertados en {tabla_destino}: {len(df)} registros.")
            else:
                print(f"No se encontraron datos en {tabla_origen} para insertar.")

        cursor.close()
        conn.close()
        print("Proceso completado.")

    except Exception as e:
        print(f"Error: {e}")

# Ejecutar el proceso
procesar_tablas()