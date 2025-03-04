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

# Diagnósticos de cancer a filtrar
DIAGCOD_CANCER = ('B21','B21.0','B21.1','B21.2','B21.3','B21.7','B21.8','B21.9','D00','D00.0','D00.1','D00.2','D01','D01.0','D01.1','D01.2','D01.3','D01.4','D01.5',
'D01.7','D01.9','D02','D02.0','D02.1','D02.2','D02.3','D02.4','D03','D03.0','D03.1','D03.2','D03.3','D03.4','D03.5','D03.6','D03.7','D03.8','D03.9','D04','D04.0','D04.1','D04.2','D04.3','D04.4',
'D04.5','D04.6','D04.7','D04.8','D04.9','D05','D05.0','D05.1','D05.7','D05.9','D06','D06.0','D06.1','D06.7','D06.9','D07','D07.0','D07.1','D07.2','D07.3','D07.4','D07.5','D07.6','D09','D09.0',
'D09.1','D09.2','D09.3','D09.7','D09.9','D32','D32.0','D32.1','D32.9','D33','D33.0','D33.1','D33.2','D33.3','D33.4','D33.7','D33.9','D35.2','D42','D42.0','D42.1','D42.9','D43','D43.0','D43.1',
'D43.2','D43.3','D43.4','D43.7','D43.9','D44.3','D44.4','D44.5','D45','D46','D46.0','D46.1','D46.2','D46.3','D46.4','D46.5','D46.7','D46.9','D47','D47.0','D47.1','D47.2','D47.3','D47.5','D47.7',
'D47.9')

# Años a considerar
ANIOS_PERMITIDOS = ('2019','2020','2021','2022','2023','2024','2025')

# Tablas de origen y destino
TABLAS_ORIGEN = [
    # "sgss_ctdaa10_anio",
    # "sgss_mtdae10_anio",
    # "sgss_htdah10_anio",
    "sgss_qtiod10_anio"
]

TABLAS_DESTINO = [
    # "sgss_ctdaa10_anio_cancer",
    # "sgss_mtdae10_anio_cancer",
    # "sgss_htdah10_anio_cancer",
    "sgss_qtiod10_anio_cancer"
]

# Columnas mapeadas para cada tabla
COLUMNAS = {
    # "sgss_ctdaa10_anio": [
    #     "ATENAMBORICENASICOD", "ATENAMBCENASICOD", "ATENAMBACTMEDNUM",
    #     "CONDDIAGCOD", "DIAGCOD", "ATENAMBDIAGORD", 
    #     "ATENAMBTIPODIAGCOD", "ATENAMBCASODIAGCOD", 
    #     "DIAGATENAMBALTAFLAG", "DIAGATENAMBPEAS", "periodo", "anio"
    # ],
    # "sgss_mtdae10_anio": [
    #     "ateemeoricenasicod", "ateemecenasicod", "ateemeactmednum",
    #     "ateemesecnum", "conddiagcod", "diagcod", "ateemediagord",
    #     "ateemetipodiagcod", "periodo", "anio"
    # ],
    # "sgss_htdah10_anio": [
    #     "atenhosoricenasicod", "atenhoscenasicod", "atenhosactmednum",
    #     "atenhosnumsec", "conddiagcod", "diagcod", "atenhosdiagord",
    #     "atenhostipodiagcod", "periodo", "anio"
    # ],
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
                    WHERE DIAGCOD IN {str(DIAGCOD_CANCER)}
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