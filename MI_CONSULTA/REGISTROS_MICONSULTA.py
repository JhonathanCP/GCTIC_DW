# %%
from decouple import config
from sqlalchemy import create_engine
import pandas as pd
from datetime import datetime, timedelta
import time 
from datetime import datetime
from sqlalchemy import text
import oracledb
import sys

# %%
oracledb.init_oracle_client()
oracledb.version = "8.3.0"
sys.modules["cx_Oracle"] = oracledb
un = 'sgss'
pw = 'sgss_c4l1d4d'
hostname='10.56.1.127'
service_name="wnetqa"
port = 1521

engine0 = create_engine(f'oracle://{un}:{pw}@',connect_args={
        "host": hostname,
        "port": port,
        "service_name": service_name
    }
)

connection0 = engine0.connect()

# %%
asegurados = pd.read_sql_query(f"""SELECT
	COD_RED,
    NOMBRERED,
    NIVEL,
    CAS,
    DESC_CAS,
    DGACECA,
    COUNT(*) AS TOTAL
FROM 
    pob_pobafil_activa_202309f_ok pp
where pp.edad>=18
GROUP BY 
    COD_RED,NOMBRERED, NIVEL, CAS, DESC_CAS, DGACECA
""", con=connection0)
connection0.close()

# %%
DB_USER='root'
DB_PASSWORD='OJlehXTRlEa6^zsFNILjnVoew9ku=E'
DB_NAME='essidb'
DB_PORT="5432"
DB_HOST='read-only-powerbi.cktgjnvajmd8.us-east-1.rds.amazonaws.com'
cadena1  = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine1 = create_engine(cadena1)
connection1 = engine1.connect()

# %%
registros_app = pd.read_sql_query(f"""select u.username as "Usuario",
e.primer_nombre as "PrimerNombre",
e.segundo_nombre as "SegundoNombre",
e.apellido_paterno as "ApellidoPaterno",
e.apellido_materno as "ApellidoMaterno",
e.fecha_nacimiento as"FechaNacimiento",
u.date_create as "FechaCreacion",
p.cod_centro as "CodigoCentro",
c.descripcion as "CentroAsistencial",
c.cod_red as "CodigoRed",
r.descripcion as "Red",
c2.nro_celular  as "Celular",
c2.email as "Correo"
from usuario u
left join paciente p on u.id_usuario = p.id_paciente
left join centro c on c.cen_asi_cod = p.cod_centro
left join red r on r.cod_red = c.cod_red
left join persona e on e.id_persona = p.id_paciente
left join contacto c2 on c2.id_persona= e.id_persona""", con=connection1)

# %%
DB_USER='postgres'
DB_PASSWORD='AKindOfMagic'
DB_NAME="dw_essalud"
DB_PORT="5432"
DB_HOST='10.0.1.228'
cadena2  = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine2 = create_engine(cadena2)
connection2 = engine2.connect()

# %%
registros_app.to_sql(name=f'registros_app', con=connection2, if_exists='replace', index=False,chunksize=10000)
asegurados.to_sql(name=f'asegurados', con=connection2, if_exists='replace', index=False,chunksize=10000)

# %%
fecha = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=4.0", con=connection2)
fecha= fecha.iloc[0, 0]
print(fecha)

now = datetime.now()

query=f"UPDATE etl_act SET fec_act ='{now}' WHERE id_mod=21"

c1= text(query)
connection2.execute(c1)

# %%
connection1.close()
connection2.close()
engine1.dispose()
engine2.dispose()


