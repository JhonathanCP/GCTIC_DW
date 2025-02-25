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
DIAGCOD_RENAL = (
    'Z49.0', 'Z49.1', 'Z49.2', 'Z94.0', 'T86.1', 'T82.4', 'I12.0', 'Y84.1', 'Z99.2'
)

# Diagnósticos con patrón LIKE
DIAGCOD_LIKE = ('N17%', 'N18%', 'N19%')

# Periodo de inicio y fin
PERIODO_INICIO = '201901'
PERIODO_FIN = '202512'

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

# Función para crear tablas destino
def crear_tablas_destino():
    try:
        conn = psycopg2.connect(**DB_CONFIG, connect_timeout=10)  # Timeout de 10s
        cursor = conn.cursor()

        for tabla_origen, tabla_destino in zip(TABLAS_ORIGEN, TABLAS_DESTINO):
            # Crear la tabla destino con la misma estructura de la tabla origen
            query_create = f"""
                CREATE TABLE IF NOT EXISTS {tabla_destino} (LIKE {tabla_origen} INCLUDING ALL);
            """
            cursor.execute(query_create)
            conn.commit()
            print(f"Tabla {tabla_destino} creada exitosamente.")

        cursor.close()
        conn.close()

    except Exception as e:
        print(f"Error al crear las tablas destino: {e}")

# Función para eliminar datos en las tablas destino
def eliminar_datos_tablas_destino():
    try:
        conn = psycopg2.connect(**DB_CONFIG, connect_timeout=10)  # Timeout de 10s
        cursor = conn.cursor()

        for tabla_destino in TABLAS_DESTINO:
            # Eliminar datos desde el periodo_inicio hasta el periodo_fin
            query_delete = f"""
                DELETE FROM {tabla_destino}
                WHERE periodo >= %s AND periodo <= %s;
            """
            cursor.execute(query_delete, (PERIODO_INICIO, PERIODO_FIN))
            conn.commit()
            print(f"Datos eliminados de {tabla_destino} para el rango de periodo {PERIODO_INICIO} a {PERIODO_FIN}.")

        cursor.close()
        conn.close()

    except Exception as e:
        print(f"Error al eliminar los datos de las tablas destino: {e}")

# Función para extraer e insertar datos por periodo
def procesar_tablas_por_periodo():
    try:
        conn = psycopg2.connect(**DB_CONFIG, connect_timeout=10)  # Timeout de 10s
        cursor = conn.cursor()

        # Procesar por cada año permitido
        for periodo in range(int(PERIODO_INICIO), int(PERIODO_FIN)+1):
            periodo_str = str(periodo)
            print(f"Procesando datos para el periodo {periodo_str}...")

            for i in range(len(TABLAS_ORIGEN)):
                tabla_origen = TABLAS_ORIGEN[i]
                tabla_destino = TABLAS_DESTINO[i]
                columnas = COLUMNAS[tabla_origen]

                # Query para extraer datos filtrados por periodo y diagnóstico
                query_select = f"""
                    SELECT {', '.join(columnas)}
                    FROM {tabla_origen}
                    WHERE (DIAGCOD IN {str(DIAGCOD_RENAL)} OR DIAGCOD LIKE ANY (%s))
                    AND periodo = %s
                """

                # Leer los datos para el periodo actual
                df = pd.read_sql(query_select, conn, params=[DIAGCOD_LIKE, periodo_str])

                if not df.empty:
                    # Insertar datos en la tabla destino
                    values_placeholder = ", ".join(["%s"] * len(columnas))
                    query_insert = f"""
                        INSERT INTO {tabla_destino} ({', '.join(columnas)})
                        VALUES ({values_placeholder})
                    """
                    cursor.executemany(query_insert, df.values.tolist())
                    conn.commit()

                    print(f"Datos insertados en {tabla_destino} para el periodo {periodo_str}: {len(df)} registros.")
                else:
                    print(f"No se encontraron datos en {tabla_origen} para el periodo {periodo_str}.")

        cursor.close()
        conn.close()
        print("Proceso completado.")

    except Exception as e:
        print(f"Error: {e}")

# Ejecutar los pasos
crear_tablas_destino()
eliminar_datos_tablas_destino()
procesar_tablas_por_periodo()
