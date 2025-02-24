import pandas as pd
from sqlalchemy import create_engine

# Configuración de la conexión
DB_CONFIG = {
    'dbname': 'DATAWAREHOUSE_ESSI',
    'user': 'postgres',
    'password': 'Password2',
    'host': '10.0.1.6',
    'port': '5432',
}

# Crear el engine de SQLAlchemy
engine = create_engine(f"postgresql+psycopg2://{DB_CONFIG['user']}:{DB_CONFIG['password']}@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['dbname']}")

# Consulta SQL
SQL_QUERY = """
with datos as (
    select ROW_NUMBER() OVER (PARTITION BY d.cod_tipdoc_paciente, d.doc_paciente, to_char(to_date(d.fecha_atencion, 'dd/mm/yyyy'),'yyyy') ORDER BY TO_DATE(d.fecha_atencion, 'DD/MM/YYYY')) AS row_num,		
    d.*
    from public.mtd_oncologico d),
datos2 as (
    select cod_oricentro, cod_centro, acto_med, cod_secuencia, cod_conddiag, cod_diagnostico, cod_orden, cod_tipodiag, cmame_pacsecnum, cod_tipdoc_paciente, doc_paciente, 
        anio_edad, sexo, cas_adscripcion, area, anio_busqueda, cod_tipo_busqueda, fecha_atencion
    from datos
    where row_num = '1' and to_char(to_date(fecha_atencion, 'dd/mm/yyyy'),'yyyy') = '2024'),
datos3 as (
    select ROW_NUMBER() OVER (PARTITION BY d.cod_tipdoc_paciente, d.doc_paciente ORDER BY TO_DATE(d.fecha_atencion, 'DD/MM/YYYY')) AS row_num,		
    d.*
    from datos2 d
    where cast(d.anio_edad as numeric) < 18),
datos4 as (
    select a.cod_tipdoc_paciente, a.doc_paciente from datos3 a
    where a.row_num = '1')
select n.* from datos4 d
left outer join public.procedimientos_historico n on n.dni = d.doc_paciente							
where to_char(to_date(n.fecha_aten, 'dd/mm/yyyy'),'yyyy') = '2024'
"""

# Leer los datos desde PostgreSQL usando SQLAlchemy
df = pd.read_sql(SQL_QUERY, engine)

# Guardar como CSV con la configuración especificada
csv_filename = "c:/Users/gg.uipad01/Documents/DW/EMERGENCIA/resultado_2024.csv"
df.to_csv(csv_filename, index=False, sep=';', encoding='utf-8', quotechar='"', quoting=1)

print(f"Exportación completada: {csv_filename}")
