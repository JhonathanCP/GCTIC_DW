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
ipress = pd.read_sql_query(f"""SELECT * FROM CMCAS10 c WHERE ORICENASICOD = '1' AND (NIVCENTASISCOD = '1' OR NIVCENTASISCOD ='2') AND ESTREGCOD = '1'""", con=connection0)
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
ipress_miconsulta = pd.read_sql_query(f"""select * from ipress_cita_app""", con=connection1)

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
ipress.to_sql(name=f'ipress', con=connection2, if_exists='replace', index=False,chunksize=10000)
ipress_miconsulta.to_sql(name=f'ipress_miconsulta', con=connection2, if_exists='replace', index=False,chunksize=10000)

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


