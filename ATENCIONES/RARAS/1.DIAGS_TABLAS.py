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

# Diagnósticos de raras a filtrar
DIAGCOD_RARAS = ('A05.1','A81.0','A81.1','A81.2','A81.8','B60.1','B60.2','B60.8','D33.0','D45','D55.0','D55.1','D55.2','D55.3','D55.8','D55.9','D56.0',
'D56.1','D56.2','D56.8','D56.9','D57.0','D57.1','D58.0','D58.1','D58.2','D58.8','D58.9','D59.5','D61.0','D61.3','D64.4','D66','D67',
'D68.0','D68.1','D68.2','D68.5','D68.8','D69.1','D70','D71','D72.0','D74.0','D74.9','D75.2','D76.0','D76.1','D76.3','D80.0','D80.1',
'D80.3','D80.4','D80.5','D80.6','D80.7','D80.8','D80.9','D81.0','D81.1','D81.2','D81.3','D81.4','D81.5','D81.6','D81.7','D81.8','D81.9',
'D82.0','D82.1','D82.2','D82.3','D82.4','D82.8','D82.9','D83.0','D83.1','D83.2','D83.8','D83.9','D84.0','D84.1','D84.8','D84.9','D89.8',
'E07.1','E16.1','E16.2','E16.3','E20.0','E20.9','E21.0','E22.0','E23.0','E23.2','E24.0','E24.1','E25.0','E25.8','E25.9','E26.0',
'E27.1','E27.4','E34.0','E34.3','E34.5','E34.8','E70.0','E70.1','E70.2','E70.3','E70.8','E70.9','E71.0','E71.1','E71.2','E71.3','E72.0',
'E72.1','E72.2','E72.3','E72.4','E72.5','E72.8','E72.9','E73.0','E74.0','E74.1','E74.2','E74.3','E74.4','E74.8','E74.9','E75.0','E75.1',
'E75.2','E75.3','E75.4','E75.5','E75.6','E76.0','E76.1','E76.2','E76.3','E76.8','E76.9','E77.0','E77.1','E77.8','E77.9','E78.3','E78.6',
'E78.8','E78.9','E79.1','E79.8','E79.9','E80.0','E80.1','E80.2','E80.3','E80.4','E80.5','E80.6','E80.7','E83.0','E83.3','E84.0','E84.1',
'E84.8','E84.9','E85.0','E88.1','E88.8','F00.0','F02.0','F80.3','G04.1','G04.8','G10','G11.0','G11.1','G11.2','G11.3','G11.4','G11.8',
'G11.9','G12.0','G12.1','G12.2','G12.8','G12.9','G13.0','G13.1','G13.2','G23.0','G23.1','G23.8','G23.9','G24.1','G24.2','G24.4','G25.8',
'G31.0','G31.8','G35','G36.0','G36.1','G36.8','G36.9','G37.0','G37.1','G37.2','G373','G37.5','G37.8','G37.9','G40.3','G40.4','G47.3',
'G47.8','G51.8','G60.0','G60.1','G61.0','G70.0','G70.2','G71.0','G71.1','G71.2','G71.3','G90.0','G90.1','G90.3','G93.0','G95.0','H05.2',
'H18.5','H27.0','H31.2','H33.1','H35.3','H35.5','H46','H53.6','H90.5','I27.0','I27.1','I42.8','I45.8','I67.3','I67.5','I78.0','J43.0',
'J84.0','J84.1','J84.8','J84.9','K10.8','K11.8','K74.0','K90.8','K91.2','L10.2','L10.3','L10.9','L90.1','L90.2','L90.3','L93.0','M08.0',
'M08.1','M08.2','M21.8','M30.0','M30.1','M30.2','M30.3','M31.1','M31.3','M31.4','M31.5','M32.0','M32.1','M32.8','M32.9','M33.0','M33.1',
'M33.2','M33.9','M34.0','M34.1','M34.9','M35.1','M35.2','M45.X','M61.1','M85.2','M89.0','M94.1','N07.0','N07.1','N07.2','N07.3','N07.4',
'N07.5','N07.6','N07.7','N07.8','N07.9','N15.8','Q00.0','Q00.1','Q00.2','Q01.0','Q01.1','Q01.2','Q01.8','Q01.9','Q03.0','Q03.1','Q03.8',
'Q03.9','Q04.0','Q04.1','Q04.2','Q04.3','Q04.4','Q04.5','Q04.6','Q06.0','Q06.1','Q06.2','Q06.3','Q06.4','Q06.8','Q06.9','Q07.0','Q10.5',
'Q13.1','Q14.3','Q15.0','Q20.0','Q20.1','Q20.2','Q20.3','Q20.4','Q20.5','Q20.6','Q22.0','Q22.5','Q22.6','Q23.4','Q25.2','Q25.5','Q25.8',
'Q25.9','Q26.2','Q26.3','Q26.4','Q26.8','Q27.8','Q28.2','Q28.8','Q33.6','Q34.8','Q38.0','Q38.3','Q43.1','Q44.2','Q44.3','Q44.7','Q45.0',
'Q45.3','Q55.5','Q56.0','Q56.1','Q56.2','Q56.3','Q60.1','Q60.4','Q60.6','Q61.1','Q61.2','Q61.3','Q61.4','Q61.5','Q61.8','Q61.9','Q62.0',
'Q64.1','Q68.8','Q71.0','Q71.1','Q71.2','Q71.3','Q71.4','Q71.5','Q71.6','Q71.8','Q71.9','Q72.0','Q72.1','Q72.2','Q72.3','Q72.4','Q72.5',
'Q72.6','Q72.7','Q72.8','Q72.9','Q73.0','Q73.1','Q74.0','Q74.3','Q75.0','Q75.1','Q75.4','Q75.5','Q75.8','Q76.1','Q76.2','Q76.8','Q77.0',
'Q77.1','Q77.2','Q77.3','Q77.4','Q77.5','Q77.6','Q77.7','Q77.8','Q77.9','Q78.0','Q78.1','Q78.2','Q78.3','Q78.4','Q78.5','Q78.6','Q78.8',
'Q78.9','Q79.0','Q79.2','Q79.3','Q79.4','Q79.5','Q79.6','Q79.8','Q79.9','Q80.0','Q80.1','Q80.2','Q80.3','Q80.4','Q80.8','Q80.9','Q81.0',
'Q81.1','Q81.2','Q81.8','Q81.9','Q82.0','Q82.1','Q82.2','Q82.3','Q82.4','Q82.8','Q85.0','Q85.1','Q85.8','Q85.9','Q86.0','Q87.0','Q87.1',
'Q87.2','Q87.3','Q87.4','Q87.5','Q87.8','Q89.1','Q89.2','Q89.3','Q89.4','Q89.7','Q89.8','Q91.0','Q91.1','Q91.2','Q91.3','Q91.4','Q91.5',
'Q91.6','Q91.7','Q92.0','Q92.1','Q92.2','Q92.3','Q92.4','Q92.5','Q92.6','Q92.7','Q92.8','Q92.9','Q93.0','Q93.1','Q93.2','Q93.3','Q93.4',
'Q93.5','Q93.6','Q93.7','Q93.8','Q93.9','Q95.5','Q95.8','Q95.9','Q96.0','Q96.1','Q96.2','Q96.3','Q96.4','Q96.8','Q96.9','Q97.0','Q97.1',
'Q97.2','Q97.3','Q97.8','Q97.9','Q98.0','Q98.1','Q98.2','Q98.3','Q98.4','Q98.5','Q98.6','Q98.7','Q98.8','Q98.9','Q99.0','Q99.1','Q99.2',
'Q99.8','T88.3','Q03.11')

# Años a considerar
ANIOS_PERMITIDOS = ('2022','2023','2024','2025')

# Tablas de origen y destino
TABLAS_ORIGEN = [
    "sgss_ctdaa10_anio",
    "sgss_mtdae10_anio",
    "sgss_htdah10_anio",
    "sgss_qtiod10_anio"
]

TABLAS_DESTINO = [
    "sgss_ctdaa10_anio_raras",
    "sgss_mtdae10_anio_raras",
    "sgss_htdah10_anio_raras",
    "sgss_qtiod10_anio_raras"
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
                    WHERE DIAGCOD IN {str(DIAGCOD_RARAS)}
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