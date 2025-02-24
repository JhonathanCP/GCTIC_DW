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

# Diagnósticos de diabetes a filtrar
DIAGCOD_DIABETES = ('E10','E10.0','E10.1','E10.2','E10.3','E10.4','E10.5','E10.6','E10.7','E10.8','E10.9','E11','E11.0','E11.1','E11.2','E11.3','E11.4','E11.5','E11.6','E11.7','E11.8','E11.9','E12.0','E12.1','E12.2','E12.3',
'E12.4','E12.5','E12.6','E12.7','E12.8','E12.9','E13.0','E13.1','E13.2','E13.3','E13.4','E13.5','E13.6','E13.7','E13.8','E13.9','E14','E14.0','E14.1','E14.2','E14.3','E14.4','E14.5','E14.6','E14.7','E14.8',
'E14.9','O24','O24.0','O24.1','O24.3','O24.4','O24.9')

# Años a considerar
ANIOS_PERMITIDOS = ('2019','2020','2021','2022','2023','2024','2025')

# Tablas de origen y destino
TABLAS_ORIGEN = [
    "sgss_ctdaa10_anio",
    "sgss_mtdae10_anio",
    "sgss_htdah10_anio",
    "sgss_qtiod10_anio"
]

TABLAS_DESTINO = [
    "sgss_ctdaa10_anio_diabetes",
    "sgss_mtdae10_anio_diabetes",
    "sgss_htdah10_anio_diabetes",
    "sgss_qtiod10_anio_diabetes"
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
    # "sgss_qtiod10_anio": [
    #     "infopeoricenasicod", "infopecenasicod", "infopesolopenum",
    #     "infopesecnum", "conddiagcod", "infopediagcod", "tipodiagcod",
    #     "infopediagord", "periodo", "anio"
    # ],
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

                # Query para extraer datos filtrados por año
                query_select = f"""
                    SELECT {', '.join(columnas)}
                    FROM {tabla_origen}
                    WHERE DIAGCOD IN {str(DIAGCOD_DIABETES)}
                    AND anio = %s
                """

                # Leer los datos para el año actual
                df = pd.read_sql(query_select, conn, params=[año])

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