from sqlalchemy import create_engine, MetaData, Table, select, text
from sqlalchemy.engine.url import URL

# Configuración de la base de datos
DB_CONFIG = {
    'drivername': 'postgresql',
    'username': 'postgres',
    'password': 'Password2',
    'host': '10.0.1.6',
    'port': '5432',
    'database': 'DATAWAREHOUSE_ESSI',
}

# Crear conexión con SQLAlchemy
engine = create_engine(URL.create(**DB_CONFIG))
metadata = MetaData()
metadata.reflect(bind=engine)

# Crear la tabla destino si no existe
with engine.connect() as conn:
    conn.execute(text("""
        CREATE TABLE IF NOT EXISTS tmp_obesidad_actmed_ctdan10_1 AS 
        TABLE tmp_obesidad_actmed_ctdan10 WITH NO DATA;
    """))

# Definir las tablas
source_table = Table('tmp_obesidad_actmed_ctdan10', metadata, autoload_with=engine)
dest_table = Table('tmp_obesidad_actmed_ctdan10_1', metadata, autoload_with=engine)

# Construir consulta con filtros
stmt = select(source_table).where(
    (source_table.c.cod_servicio.in_(['F11', 'F31'])) &
    (((source_table.c.cod_servicio == 'F11') & (source_table.c.anio_edad < 18)) | 
    ((source_table.c.cod_servicio == 'F31') & (source_table.c.anio_edad >= 18)))
)

# Ejecutar la consulta y transferir datos con transacción segura
with engine.begin() as conn:  # Usa engine.begin() para manejar la transacción correctamente
    # Truncar la tabla destino antes de insertar los nuevos datos
    conn.execute(dest_table.delete())
    
    # Insertar los datos filtrados en la tabla destino
    result = conn.execute(stmt)
    rows = [dict(row) for row in result]
    if rows:
        conn.execute(dest_table.insert(), rows)

print("Proceso completado exitosamente.")
