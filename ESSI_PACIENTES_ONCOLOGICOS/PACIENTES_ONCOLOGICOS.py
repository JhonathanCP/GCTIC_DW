from decouple import config
from sqlalchemy import create_engine
import pandas as pd
from datetime import datetime, timedelta
import time 
from datetime import datetime
from sqlalchemy import text
import oracledb
import sys

DB_USER=config("USER2_BDI_POSTGRES")
DB_PASSWORD=config("PASS2_BDI_POSTGRES")
DB_NAME="dw_essalud"
DB_PORT="5432"
DB_HOST=config("HOST2_BDI_POSTGRES")
cadena2  = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine2 = create_engine(cadena2)
connection2 = engine2.connect()

oracledb.init_oracle_client()
oracledb.version = "8.3.0"
sys.modules["cx_Oracle"] = oracledb
un = config("USER4_BDI_POSTGRES")
pw = config("PASS4_BDI_POSTGRES")
hostname=config("HOST4_BDI_POSTGRES")
service_name="WNET"
port = 1527

engine0 = create_engine(f'oracle://{un}:{pw}@',connect_args={
        "host": hostname,
        "port": port,
        "service_name": service_name
    }
)

connection0 = engine0.connect()


fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=25", con=connection2)
fecha_ini= fecha_ini.iloc[0, 0]

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=25", con=connection2)
fecha_fin= fecha_fin.iloc[0, 0]


dias_por_intervalo = 10

# Inicializa la fecha actual
fecha_actual = fecha_ini

for i in range(0, (fecha_fin - fecha_ini).days + 1, dias_por_intervalo):

  inicioTiempo = time.time()
  now_inicio = datetime.now()

  fecha_ini_intervalo = fecha_actual

  fecha_fin_intervalo = fecha_actual + timedelta(days=dias_por_intervalo - 1)

  fecha_ini_str = fecha_ini_intervalo.strftime('%Y-%m-%d')	
  fecha_fin_str = fecha_fin_intervalo.strftime('%Y-%m-%d')

  print(f"Procesando de {fecha_ini_str} al {fecha_fin_str}")

  now1 = datetime.now()
  now2 = datetime.now().strftime('%Y-%m-%d')


  query1=f"UPDATE etl_act SET fec_act ='{now1}' WHERE id_mod=25"
  
  c1= text(query1)
  
  connection2.execute(c1)
  query = f"""
  SELECT t.oricenasicod,
        t.cenasicod,
        t.actmednum,
        t.actmedpacsecnum,
        p.solmatdocnum,
        a.solmatdocfec,
        p.matcod,
        p.solmadcan
    FROM CMAME10 t
    JOIN FTSMA10 a
      ON t.oricenasicod = a.oricenasicod
    AND t.cenasicod = a.cenasicod
    AND t.actmednum = a.actmednum
    join FTSMD10 p
      on a.oricenasicod = p.oricenasicod
    and a.cenasicod = p.cenasicod
    and a.solalmcod = p.solalmcod
    and a.solmatdocnum = p.solmatdocnum
  WHERE a.solmatdocfec >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and a.solmatdocfec < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')
        
  """
  base1 = pd.read_sql_query(query, con=connection0)

  #borrando = f"DELETE FROM farmacia WHERE solmatdocfec >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and solmatdocfec < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
  #borrado = connection3.execute(borrando)
  #print('borrado listo')

  base1.to_sql(name=f'farmacia', con=connection2, if_exists='append', index=False,chunksize=10000)
  fecha_actual = fecha_fin_intervalo

  finproceso=time.time()
  tiempoproceso=finproceso - inicioTiempo
  tiempoproceso=round(tiempoproceso,3)
  print("Proceso completado satisfactoriamente en " + str(tiempoproceso)+" segundos")
connection0.close()
query2=f"UPDATE etl_act SET fec_ini ='{now2}' WHERE id_mod=25"
c2= text(query2)
connection2.execute(c2)
connection0.close()