
from decouple import config
from sqlalchemy import create_engine, MetaData, Table, text, inspect
import pandas as pd
from datetime import datetime, timedelta
import time 
from datetime import datetime
from sqlalchemy import text
import oracledb
import sys
import tempfile


DB_USER='postgres'
DB_PASSWORD='AKindOfMagic'
DB_NAME="dw_essalud"
DB_PORT="5432"
DB_HOST='10.0.1.228'
cadena1  = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine1 = create_engine(cadena1)
connection1 = engine1.connect()


# Configuración para la base de datos de destino
DB_USER_DEST = 'postgres'
DB_PASSWORD_DEST = 'AKindOfMagic'
DB_NAME_DEST = 'gc'
DB_PORT_DEST = '5432'
DB_HOST_DEST = '10.0.1.228'
cadena_dest = f"postgresql://{DB_USER_DEST}:{DB_PASSWORD_DEST}@{DB_HOST_DEST}:{DB_PORT_DEST}/{DB_NAME_DEST}"
engine_dest = create_engine(cadena_dest)
metadata_dest = MetaData(bind=engine_dest)



# Configuración para la base de datos de origen
DB_USER_SRC = 'ConsultaPRD'
DB_PASSWORD_SRC = 'Essalud2023'
DB_NAME_SRC = 'gestion_atencion_db'
DB_PORT_SRC = '5432'
DB_HOST_SRC = '10.0.1.27'
cadena_src = f"postgresql://{DB_USER_SRC}:{DB_PASSWORD_SRC}@{DB_HOST_SRC}:{DB_PORT_SRC}/{DB_NAME_SRC}"
engine_src = create_engine(cadena_src)
metadata_src = MetaData(bind=engine_src)
metadata_src.reflect()


# Define el orden correcto de creación de las tablas considerando dependencias
table_order = metadata_src.sorted_tables

# Crear primero las tablas que no tienen dependencias
for table in table_order:
    if not table.foreign_keys:
        try:
            table.create(engine_dest, checkfirst=True)
            print(f'Tabla {table.name} creada en la base de datos de destino.')
        except Exception as e:
            print(f'Error creando la tabla {table.name} en la base de datos de destino: {str(e)}')

# Crear luego las tablas que tienen dependencias
for table in table_order:
    if table.foreign_keys:
        try:
            table.create(engine_dest, checkfirst=True)
            print(f'Tabla {table.name} creada en la base de datos de destino.')
        except Exception as e:
            print(f'Error creando la tabla {table.name} en la base de datos de destino: {str(e)}')

# Copia los datos de una base de datos a otra
for table in table_order:
    try:
        # Ejecuta la consulta de selección
        select_query = table.select()
        result = engine_src.execute(select_query)

        # Copia los datos utilizando el resultado de la consulta
        data_to_insert = [dict(row) for row in result]
        if data_to_insert:
            engine_dest.execute(table.insert(), data_to_insert)
            print(f'Datos de la tabla {table.name} copiados correctamente.')
        else:
            print(f'La tabla {table.name} está vacía, no se copiaron datos.')
    except Exception as e:
        print(f'Error copiando datos de la tabla {table.name}: {str(e)}')

print("Proceso completado. Todas las tablas y datos han sido copiados de la base de datos origen a la base de datos destino.")


fecha = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=22.0", con=connection1)
fecha= fecha.iloc[0, 0]
print(fecha)

now = datetime.now()    

query=f"UPDATE etl_act SET fec_act ='{now}' WHERE id_mod=22"

c1= text(query)
connection1.execute(c1)


connection1.close()
engine1.dispose()
engine_src.dispose()
engine_dest.dispose()


