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
un = 'User_oper'
pw = 'TmLQL$Yq.1'
hostname='10.56.1.76'
service_name="WNET"
port = 1527

engine0 = create_engine(f'oracle://{un}:{pw}@',connect_args={
        "host": hostname,
        "port": port,
        "service_name": service_name
    }
)
connection0 = engine0.connect()

# %%
servicios_ipress = pd.read_sql_query(f"""select distinct l.redasiscod as cod_red_asistencial,
       (select red.redasisdes
          from sgss.cmras10 red
         where red.redasiscod = l.redasiscod) as red_asistencial,
       t.oricenasicod as origen,
       t.cenasicod as cod_centro,
       l.cenasides as centro,
       t.arehoscod as cod_area,
       l.NIVCENTASISCOD AS NIVEL,
       (select h.arehosdes from cmaho10 h where t.arehoscod = h.arehoscod) as area,
       t.servhoscod as codservicio,
       (select e.servhosdes from cmsho10 e where t.servhoscod = e.servhoscod) as servicio
  from sgss.cmsas10 t
  left outer join cmcas10 l
    on l.oricenasicod = t.oricenasicod
   and l.cenasicod = t.cenasicod
  left outer join cspar10 m
    on m.paroricenasicod = t.oricenasicod
   and m.parcenasicod = t.cenasicod
 where t.areseractsubciteelflg = '1'
   and m.parciteel = '1'
 order by l.redasiscod, t.cenasicod""", con=connection0)

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
servicios_ipress.to_sql(name=f'servicios_ipress', con=connection2, if_exists='replace', index=False,chunksize=10000)

# %%
fecha = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=21.0", con=connection2)
fecha= fecha.iloc[0, 0]
print(fecha)

now = datetime.now()

query=f"UPDATE etl_act SET fec_act ='{now}' WHERE id_mod=21"

c1= text(query)
connection2.execute(c1)

# %%
connection0.close()
connection2.close()
engine0.dispose()
engine2.dispose()


