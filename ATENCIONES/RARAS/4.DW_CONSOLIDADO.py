import pandas as pd
from sqlalchemy import create_engine, text
import psycopg2

# 🔹 Configuración de conexión a PostgreSQL
DB_CONFIG = {
    'dbname': 'DATAWAREHOUSE_ESSI',
    'user': 'postgres',
    'password': 'Password2',
    'host': '10.0.1.6',
    'port': '5432',
}

TABLAS_ATENCION = [
    "dw_consulta_externa",
    "dw_emergencia_egresos",
    "dw_hospitalizacion_egresos",
    "dw_centro_quirurgico",
]

LISTA_UNICA = "mtd_lista_unica_pacientes"
TIPO_BUSQUEDA = 10
DW_CONSOLIDADO = "mtd_consolidado_atenciones_ryh"

# 🔹 Mapeo de nombres de columna de fecha según la tabla de atención
MAPEO_FECHA_ATENCION = {
    "dw_consulta_externa": "fecha_atencion",
    "dw_emergencia_egresos": "fec_altadm",
    "dw_hospitalizacion_egresos": "fec_egreso",
    "dw_centro_quirurgico": "fec_oper"
}

# 🔹 Columnas estándar en la tabla temporal
COLUMNAS_STD = [
    "cod_oricentro", "cod_centro", "acto_med", "periodo", "fecha_atencion", 
    "cmame_pacsecnum", "cod_tipdoc_paciente", "doc_paciente", "anio_edad", "sexo",
    "area", "anio_busqueda", "cas_adscripcion", "cod_servicio", "cod_actividad",
    "cod_subactividad", "cod_cartera", "cod_cpms", "cod_tipdoc_medico", "dni_medico", "num_solicitud"
]

# 🔹 Crear conexión con autocommit para evitar bloqueos
engine = create_engine(f'postgresql://{DB_CONFIG["user"]}:{DB_CONFIG["password"]}@{DB_CONFIG["host"]}:{DB_CONFIG["port"]}/{DB_CONFIG["dbname"]}', isolation_level="AUTOCOMMIT")
connection = engine.connect()

# 🔹 Creación de tabla si no existe
try:
    connection.execute(text(f"""
        CREATE TABLE IF NOT EXISTS public.{DW_CONSOLIDADO} (
            cod_oricentro VARCHAR(1),
            cod_centro VARCHAR(3),
            acto_med NUMERIC(10),
            periodo VARCHAR(6),
            fecha_atencion VARCHAR(10),
            cmame_pacsecnum VARCHAR(20),
            cod_tipdoc_paciente VARCHAR(2),
            doc_paciente VARCHAR(20),
            anio_edad INT,
            sexo CHAR(1),
            area VARCHAR(500),
            anio_busqueda VARCHAR(500),
            cas_adscripcion VARCHAR(500),
            cod_servicio VARCHAR(20),
            cod_actividad VARCHAR(30),
            cod_subactividad VARCHAR(30),
            cod_cartera VARCHAR(30),
            cod_cpms VARCHAR(30),
            cod_tipdoc_medico VARCHAR(30),
            dni_medico VARCHAR(30),
            num_solicitud INT
        )
    """))
    print(f"✔ Tabla {DW_CONSOLIDADO} verificada/creada.")
except Exception as e:
    print(f"❌ Error al crear la tabla: {e}")

# 🔹 Vaciar la tabla temporal antes de insertar nuevos datos
try:
    connection.execute(text(f"TRUNCATE TABLE {DW_CONSOLIDADO}"))
    print(f"✔ Tabla {DW_CONSOLIDADO} vaciada correctamente.")
except Exception as e:
    print(f"❌ Error al truncar la tabla: {e}")

# 🔹 Obtener lista de DNIs únicos
try:
    df_lista_unica = pd.read_sql(f"SELECT cod_tipdoc_paciente, doc_paciente FROM {LISTA_UNICA} WHERE tipo_busqueda = {TIPO_BUSQUEDA}", connection)
    df_lista_unica = df_lista_unica.drop_duplicates(subset=['cod_tipdoc_paciente', 'doc_paciente'])
    print(f"✔ Lista única de DNIs cargada. {df_lista_unica.shape[0]} registros encontrados.")
except Exception as e:
    print(f"❌ Error al obtener la lista única de pacientes: {e}")

# 🔹 Proceso de consolidación de datos
fecha_inicio = '201901'
fecha_fin = '202512'

for tabla_a in TABLAS_ATENCION:
    columna_fecha = MAPEO_FECHA_ATENCION[tabla_a]

    for anio in range(int(fecha_inicio[:4]), int(fecha_fin[:4]) + 1):
        for mes in range(1, 13):
            mes_str = f"{mes:02d}"
            if f"{anio}{mes_str}" < fecha_inicio or f"{anio}{mes_str}" > fecha_fin:
                continue  

            tabla_particionada = f"{tabla_a}_{anio}_{mes_str}"
            print(f"🔹 Procesando tabla: {tabla_particionada}")

            area = "'CEXT'" if tabla_a == "dw_consulta_externa" else "'EMER'" if tabla_a == "dw_emergencia_egresos" else "'HOSP'" if tabla_a == "dw_hospitalizacion_egresos" else "'CQX'"
            cod_actividad = "cod_actividad" if tabla_a in ["dw_consulta_externa", "dw_hospitalizacion_egresos"] else "''"
            cod_subactividad = "cod_subactividad" if tabla_a == "dw_consulta_externa" else "''"
            cod_cartera = "cod_cartera" if tabla_a == "dw_consulta_externa" else "''"
            cod_cpms = "cod_cpms" if tabla_a in ["dw_consulta_externa", "dw_centro_quirurgico"] else "''"
            cod_tipdoc_medico = "cod_tipdoc_medico" if tabla_a in ["dw_consulta_externa", "dw_hospitalizacion_egresos", "dw_centro_quirurgico"] else "''"
            dni_medico = "dni_medico" if tabla_a in ["dw_consulta_externa", "dw_hospitalizacion_egresos", "dw_centro_quirurgico"] else "''"
            num_solicitud = "num_solicitud" if tabla_a == "dw_centro_quirurgico" else 0

            query = f"""
                SELECT a.cod_oricentro, a.cod_centro, a.acto_med, a.periodo,
                a.{columna_fecha} AS fecha_atencion, 
                a.cmame_pacsecnum, a.cod_tipdoc_paciente, 
                a.doc_paciente, a.anio_edad, a.sexo,
                {area} AS area, a.anio as anio_busqueda,
                a.cas_adscripcion, a.cod_servicio, {cod_actividad} AS cod_actividad, 
                {cod_subactividad} AS cod_subactividad, {cod_cartera} AS cod_cartera,
                {cod_cpms} AS cod_cpms, {cod_tipdoc_medico} AS cod_tipdoc_medico, {dni_medico} AS dni_medico,
                {num_solicitud} AS num_solicitud
                FROM {tabla_particionada} a
            """

            df_atenciones = pd.read_sql(query, connection)
            df_main = df_atenciones.merge(df_lista_unica, on=['cod_tipdoc_paciente', 'doc_paciente'], how='inner')
            df_main.to_sql(name=DW_CONSOLIDADO, con=connection, if_exists='append', index=False, chunksize=50000)
            print(f"✔ {df_main.shape[0]} registros insertados en {DW_CONSOLIDADO}.")


engine.dispose()
connection.close()