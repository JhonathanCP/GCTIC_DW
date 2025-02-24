import polars as pl
import psycopg2

# Configuración de la conexión a PostgreSQL
DB_CONFIG = {
    'dbname': 'DATAWAREHOUSE_ESSI',
    'user': 'postgres',
    'password': 'Password2',
    'host': '10.0.1.6',
    'port': '5432',
}

# Tablas origen y destino
TABLAS_CANCER = [
    # "sgss_ctdaa10_anio_cancer",
    # "sgss_mtdae10_anio_cancer",
    # "sgss_htdah10_anio_cancer",
    "sgss_qtiod10_anio_cancer",
]

TABLAS_ATENCION = [
    # "dw_consulta_externa",
    # "dw_emergencia_egresos",
    # "dw_hospitalizacion_egresos",
    "dw_centro_quirurgico",
]

TABLAS_TMP = [
    # "tmp_cancer_actmed_ctdaa10",
    # "tmp_cancer_actmed_mtdae10",
    # "tmp_cancer_actmed_htdah10",
    "tmp_cancer_actmed_qtiod10",
]

# Mapear prefijos para cada tabla
PREFIJOS = {
    # "sgss_ctdaa10_anio_cancer": "atenamb",
    # "sgss_mtdae10_anio_cancer": "ateeme",
    # "sgss_htdah10_anio_cancer": "atenhos",
    "sgss_qtiod10_anio_cancer": "infope"
}

# Mapeo de nombres de columna de fecha según la tabla de atención
MAPEO_FECHA_ATENCION = {
    # "dw_consulta_externa": "fecha_atencion",
    # "dw_emergencia_egresos": "fec_altadm",
    # "dw_hospitalizacion_egresos": "fec_egreso",
    "dw_centro_quirurgico": "fec_oper"
}

# Columnas estándar en las tablas temporales
COLUMNAS_STD = [
    "cod_oricentro", "cod_centro", "acto_med", "periodo", "fecha_atencion", 
    "cmame_pacsecnum", "cod_tipdoc_paciente", "doc_paciente", "anio_edad", "sexo",
    "cod_conddiag", "cod_diagnostico", "cod_orden", "cod_tipodiag", "area", 
    "anio_busqueda", "cod_secuencia", "cas_adscripcion", "cod_servicio", "cod_actividad",
    "cod_subactividad", "cod_cartera", "cod_cpms", "cod_tipdoc_medico", "dni_medico"
]

def procesar_datos(fecha_inicio, fecha_fin):
    conn = psycopg2.connect(**DB_CONFIG)
    cursor = conn.cursor()
    
    for i in range(len(TABLAS_CANCER)):
        tabla_a = TABLAS_CANCER[i]
        tabla_b = TABLAS_ATENCION[i]
        tabla_tmp = TABLAS_TMP[i]
        prefijo = PREFIJOS[tabla_a]
        columna_fecha = MAPEO_FECHA_ATENCION[tabla_b]  # Obtiene el nombre correcto de la fecha

        # Crear tabla temporal si no existe
        cursor.execute(f"""
            CREATE TABLE IF NOT EXISTS {tabla_tmp} (
                cod_oricentro VARCHAR(1),
                cod_centro VARCHAR(3),
                acto_med NUMERIC(10),
                periodo VARCHAR(6),
                fecha_atencion VARCHAR(10),  -- Se mantiene como string "DD/MM/YYYY"
                cmame_pacsecnum VARCHAR(20),
                cod_tipdoc_paciente VARCHAR(2),
                doc_paciente VARCHAR(20),
                anio_edad INT,
                sexo CHAR(1),
                cod_conddiag VARCHAR(1),
                cod_diagnostico VARCHAR(10),
                cod_orden INT,
                cod_tipodiag VARCHAR(1),
                area VARCHAR(500),
                anio_busqueda VARCHAR(500),
                cod_secuencia VARCHAR(500),
                cas_adscripcion VARCHAR(500),
                cod_servicio VARCHAR(20),
                cod_actividad VARCHAR(30),
                cod_subactividad VARCHAR(30),
                cod_cartera VARCHAR(30),
                cod_cpms VARCHAR(30),
                cod_tipdoc_medico VARCHAR(30),
                dni_medico VARCHAR(30)
            )
        """)
        conn.commit()
        
        # Vaciar la tabla temporal
        cursor.execute(f"TRUNCATE {tabla_tmp}")
        conn.commit()
        
        # Procesar datos por mes
        for anio in range(int(fecha_inicio[:4]), int(fecha_fin[:4]) + 1):
            for mes in range(1, 13):
                mes_str = f"{mes:02d}"
                if f"{anio}{mes_str}" < fecha_inicio or f"{anio}{mes_str}" > fecha_fin:
                    continue
                
                tabla_particionada = f"{tabla_b}_{anio}_{mes_str}"
                
                try:
                    area = "'CEXT'" if tabla_a == "sgss_ctdaa10_anio_cancer" else \
                            "'EMER'" if tabla_a == "sgss_mtdae10_anio_cancer" else \
                            "'HOSP'" if tabla_a == "sgss_htdah10_anio_cancer" else \
                            "'CQX'" if tabla_a == "sgss_qtiod10_anio_cancer" else ''
                    cod_secuencia = "''" if tabla_a == "sgss_ctdaa10_anio_cancer" else \
                            f"{prefijo}secnum"
                    cod_actividad = "cod_actividad" if tabla_a == "sgss_ctdaa10_anio_cancer" else \
                            "''" if tabla_a == "sgss_mtdae10_anio_cancer" else \
                            "cod_actividad" if tabla_a == "sgss_htdah10_anio_cancer" else \
                            "''" if tabla_a == "sgss_qtiod10_anio_cancer" else ''
                    cod_subactividad = "cod_subactividad" if tabla_a == "sgss_ctdaa10_anio_cancer" else \
                            "''" if tabla_a == "sgss_mtdae10_anio_cancer" else \
                            "''" if tabla_a == "sgss_htdah10_anio_cancer" else \
                            "''" if tabla_a == "sgss_qtiod10_anio_cancer" else ''
                    cod_cartera = "cod_cartera" if tabla_a == "sgss_ctdaa10_anio_cancer" else \
                            "''" if tabla_a == "sgss_mtdae10_anio_cancer" else \
                            "''" if tabla_a == "sgss_htdah10_anio_cancer" else \
                            "''" if tabla_a == "sgss_qtiod10_anio_cancer" else ''
                    cod_cpms = "cod_cpms" if tabla_a == "sgss_ctdaa10_anio_cancer" else \
                            "''" if tabla_a == "sgss_mtdae10_anio_cancer" else \
                            "''" if tabla_a == "sgss_htdah10_anio_cancer" else \
                            "cod_cpms" if tabla_a == "sgss_qtiod10_anio_cancer" else ''
                    cod_tipdoc_medico = "cod_tipdoc_medico" if tabla_a == "sgss_ctdaa10_anio_cancer" else \
                            "''" if tabla_a == "sgss_mtdae10_anio_cancer" else \
                            "cod_tipdoc_medico" if tabla_a == "sgss_htdah10_anio_cancer" else \
                            "cod_tipdoc_medico" if tabla_a == "sgss_qtiod10_anio_cancer" else ''
                    dni_medico = "dni_medico" if tabla_a == "sgss_ctdaa10_anio_cancer" else \
                            "''" if tabla_a == "sgss_mtdae10_anio_cancer" else \
                            "dni_medico" if tabla_a == "sgss_htdah10_anio_cancer" else \
                            "dni_medico" if tabla_a == "sgss_qtiod10_anio_cancer" else ''
                    query = f"""
                                SELECT b.cod_oricentro, b.cod_centro, b.acto_med, b.periodo,
                                    b.{columna_fecha} AS fecha_atencion,  -- 🔹 Se mapea a "fecha_atencion"
                                    b.cmame_pacsecnum, b.cod_tipdoc_paciente, 
                                    b.doc_paciente, b.anio_edad, b.sexo,
                                    a.conddiagcod AS cod_conddiag, a.diagcod as cod_diagnostico, 
                                    a.{prefijo}diagord AS cod_orden, a.{prefijo}tipodiagcod AS cod_tipodiag,
                                    {area} AS area, b.anio as anio_busqueda, {cod_secuencia} AS cod_secuencia,
                                    cas_adscripcion, b.cod_servicio, {cod_actividad} AS cod_actividad, 
                                    {cod_subactividad} AS cod_subactividad, {cod_cartera} AS cod_cartera,
                                    {cod_cpms} AS cod_cpms, {cod_tipdoc_medico} AS cod_tipdoc_medico, {dni_medico} AS dni_medico
                                FROM {tabla_a} a
                                JOIN {tabla_particionada} b
                                ON a.{prefijo}oricenasicod = b.cod_oricentro
                                AND a.{prefijo}cenasicod = b.cod_centro
                                AND a.{prefijo}actmednum = cast(b.num_solicitud as int)"""
                    df = pl.read_database(query, connection=conn)
                    if not df.is_empty():
                        cursor.executemany(
                            f"INSERT INTO {tabla_tmp} ({', '.join(COLUMNAS_STD)}) VALUES ({', '.join(['%s'] * len(COLUMNAS_STD))})",
                            df.to_numpy().tolist()
                        )
                        conn.commit()
                        print(f"Datos insertados en {tabla_tmp} para {anio}-{mes_str}: {df.shape[0]} registros.")
                except Exception as e:
                    print(f"Error procesando {tabla_particionada}: {e}")
    
    cursor.close()
    conn.close()
    print("Proceso completado.")

# Ejecutar
procesar_datos("201901", "202512")