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
DIAGCOD_SALUD_MENTAL = ('X60','X61','X62','X63','X64','X65','X66','X67','X68','X69','X70','X71','X72','X73','X74','X75','X76','X77','X78','X79','X80','X81','X82','X83','T74.0','T74.1','T74.2','T74.3',
	'T74.8','T74.9','Y04.0','Y04.1','Y04.2','Y04.8','Y04.9','Y05.0','Y05.1','Y05.2','Y05.8','Y05.9','Y06.0','Y06.1','Y06.2','Y06.8','Y07.0','Y07.1','Y07.2','Y07.3','Y07.8','Y07.9','Y87.0','Y87.1',
	'R45.6','Z60.0','Z60.1','Z60.2','Z60.3','Z60.4','Z60.5','Z60.8','Z60.9','Z61.0','Z61.1','Z61.2','Z61.3','Z61.4','Z61.5','Z61.6','Z61.7','Z61.9','Z62.0','Z62.1','Z62.2','Z62.3','Z62.4','Z62.5',
	'Z62.6','Z62.8','Z62.9','Z63.0','Z63.1','Z63.2','Z63.3','Z63.4','Z63.5','Z63.6','Z63.7','Z63.8','Z63.9','Z64.0','Z64.1','Z64.2','Z64.3','Z64.4','Z65.0','Z65.1','Z65.2','Z65.3','Z65.4','Z65.5',
	'Z65.8','Z65.9','Z72.0','Z72.1','Z72.2','Z72.8','Z73.3','Z73.4')

# Años a considerar
ANIOS_PERMITIDOS = ('2019','2020','2021','2022','2023','2024','2025')

# Tablas de origen y destino
TABLAS_ORIGEN = [
    "sgss_ctdaa10_anio",
    "sgss_ctdan10_anio"
]

TABLAS_DESTINO = [
    "sgss_ctdaa10_anio_salud_mental",
    "sgss_ctdan10_anio_salud_mental",
]

# Columnas mapeadas para cada tabla
COLUMNAS = {
    "sgss_ctdaa10_anio": [
        "ATENAMBORICENASICOD", "ATENAMBCENASICOD", "ATENAMBACTMEDNUM",
        "CONDDIAGCOD", "DIAGCOD", "ATENAMBDIAGORD", 
        "ATENAMBTIPODIAGCOD", "ATENAMBCASODIAGCOD", 
        "DIAGATENAMBALTAFLAG", "DIAGATENAMBPEAS", "periodo", "anio"
    ],
    "sgss_ctdan10_anio": [
        "ATENOMORICENASICOD", "ATENOMCENASICOD", "ATENOMACTMEDNUM",
        "CONDDIAGCOD", "DIAGCOD", "ATENOMDIAGORD",
        "ATENOMTIPODIAGCOD", "periodo", "anio"
    ]
}

# Función para extraer e insertar datos
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
                    WHERE DIAGCOD IN {str(DIAGCOD_SALUD_MENTAL)}
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


