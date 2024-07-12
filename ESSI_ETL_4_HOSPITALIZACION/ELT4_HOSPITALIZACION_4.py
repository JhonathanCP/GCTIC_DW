
tabla='hthos10'
col_essi='fec_int'
col_tabla='hospintfec'
col_dat='fec_int'
dat='dat_hosp0001_essi'
essi='essi_dat_hos001_etl'

from decouple import config
from sqlalchemy import create_engine
import pandas as pd
from datetime import datetime, timedelta, date
import time 
from sqlalchemy import text
import oracledb
import sys
import re

#CONEXIONES
DB_USER=config("USER2_BDI_POSTGRES")
DB_PASSWORD=config("PASS2_BDI_POSTGRES")
DB_NAME="essi_etl"
DB_PORT="5432"
DB_HOST=config("HOST2_BDI_POSTGRES")
cadena1  = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine1 = create_engine(cadena1)
connection1 = engine1.connect()

DB_USER=config("USER2_BDI_POSTGRES")
DB_PASSWORD=config("PASS2_BDI_POSTGRES")
DB_NAME="dw_essalud"
DB_PORT="5432"
DB_HOST=config("HOST2_BDI_POSTGRES")
cadena2  = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine2 = create_engine(cadena2)
connection2 = engine2.connect()

DB_USER=config("USER2_BDI_POSTGRES")
DB_PASSWORD=config("PASS2_BDI_POSTGRES")
DB_NAME="dl_essi"
DB_PORT="5432"
DB_HOST=config("HOST2_BDI_POSTGRES")
cadena3  = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine3 = create_engine(cadena3)
connection3 = engine3.connect()


DB_USER=config("USER2_BDI_POSTGRES")
DB_PASSWORD=config("PASS2_BDI_POSTGRES")
DB_NAME="etl_logs"
DB_PORT="5432"
DB_HOST=config("HOST2_BDI_POSTGRES")
cadena4  = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine4 = create_engine(cadena4)
connection4 = engine4.connect()




fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=14", con=connection2)
fecha_ini= fecha_ini.iloc[0, 0]
#ACTIVAR PARA ACTUALIZAR
#fecha_ini = date(fecha_ini.year, fecha_ini.month, fecha_ini.day) - timedelta(days=32)

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=14", con=connection2)
fecha_fin= fecha_fin.iloc[0, 0]


# Definir el número total de meses desde la fecha de inicio hasta la fecha actual
total_meses = (fecha_fin.year - fecha_ini.year) * 12 + (fecha_fin.month - fecha_ini.month)


for i in range(total_meses+1):
	inicioTiempo = time.time()
	now_inicio = datetime.now()

	# Calcular la fecha de inicio y fin del intervalo mensual
	fecha_ini_mes = fecha_ini
		
	# Obtener el último día del mes actual
	if fecha_fin.month==fecha_ini.month and fecha_fin.year==fecha_ini.year:
		fecha_fin_mes = fecha_fin
	else :
		ultimo_dia_mes_actual = date(fecha_ini_mes.year, fecha_ini_mes.month, 1) + timedelta(days=32)
		fecha_fin_mes = ultimo_dia_mes_actual.replace(day=1)

	fecha_ini_str = fecha_ini_mes.strftime('%Y-%m-%d')
	fecha_fin_str = fecha_fin_mes.strftime('%Y-%m-%d')

	print(f"Procesando 2.1 de {fecha_ini_str} al {fecha_fin_str}")


	now = datetime.now()

	query=f"UPDATE etl_act SET fec_act ='{now}' WHERE id_mod=14"

	c1= text(query)
	connection2.execute(c1)

	tabla='htaho10'
	col_tabla = "atenhosfec"
	dat= "dat_hosp0004_essi"
	col_dat='fec_hos'


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


	query0 = f"""
	SELECT 
		ah.ATENHOSORICENASICOD, 
		ah.ATENHOSCENASICOD, 
		ah.ATENHOSACTMEDNUM, 
		ah.ATENHOSFEC, 
		ah.ATENHOSHOR, 
		ah.ATENHOSNUMSEC, 
		ah.ATENHOSPERORICENASICOD, 
		ah.ATENHOSPERCENASICOD, 
		ah.ATENHOSAREHOSCOD, 
		ah.ATENHOSSERVHOSCOD, 
		ah.ATENHOSACTCOD, 
		ah.ATENHOSTIPDOCIDENPERCOD, 
		ah.ATENHOSPERASISDOCIDENNUM, 
		ah.ATENHOSPERPROFLG, 
		ah.TIPATEHOSCOD, 
		ah.CPSCOD, 
		ah.ATENHOSUSUCRECOD, 
		ah.ATENHOSCREFEC, 
		ah.ATENHOSUSUMODCOD, 
		ah.ATENHOSMODFEC, 
		ah.ATENHOSMOVSECNUM, 
		hd.CONDDIAGCOD, 
		hd.DIAGCOD, 
		hd.ATENHOSDIAGORD, 
		hd.ATENHOSTIPODIAGCOD,
		c.PERSECNUM AS PACSECNUM,
		c.PERTIPDOCIDENCOD,
		c.PERDOCIDENNUM,
		c.PERNACFEC,
		c.PERSEXOCOD
	FROM htaho10 ah
	LEFT OUTER JOIN HTDAH10 hd ON ah.ATENHOSORICENASICOD = hd.ATENHOSORICENASICOD
		AND ah.ATENHOSCENASICOD = hd.ATENHOSCENASICOD 
		AND ah.ATENHOSACTMEDNUM  = hd.ATENHOSACTMEDNUM
		AND ah.ATENHOSNUMSEC = hd.ATENHOSNUMSEC
	LEFT OUTER JOIN HTHOS10 ho ON ah.ATENHOSORICENASICOD = ho.HOSPORICENASICOD 
		AND ah.ATENHOSCENASICOD = ho.HOSPCENASICOD  
		AND ah.ATENHOSACTMEDNUM = ho.HOSPACTMEDNUM 
	LEFT OUTER JOIN CMPER10 c ON ho.HOSPBUSPACSECNUM  = c.PERSECNUM
	WHERE ah.{col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') AND ah.{col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')
	"""

	base1 = pd.read_sql_query(query0, con=connection0)
	connection0.close()

	base1['atenhosdiagord'] = base1['atenhosdiagord'].fillna(0).astype('int64')

	base1.to_sql(name=f'tmp_{tabla}', con=engine3, if_exists='replace', index=False)

	borrado = f"DELETE FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection3.execute(borrado)



	query=f"""

	ALTER TABLE tmp_{tabla} 
	ALTER COLUMN atenhosoricenasicod TYPE character(1),
	ALTER COLUMN atenhoscenasicod TYPE character(3),
	ALTER COLUMN atenhosactmednum TYPE numeric(10,0) USING atenhosactmednum::numeric(10,0),
	ALTER COLUMN atenhosfec TYPE date USING atenhosfec::date,
	ALTER COLUMN atenhoshor TYPE timestamp USING atenhoshor::timestamp with time zone,
	ALTER COLUMN atenhosnumsec TYPE numeric(4,0) USING atenhosnumsec::numeric(4,0),
	ALTER COLUMN atenhosperoricenasicod TYPE character(1),
	ALTER COLUMN atenhospercenasicod TYPE character(3),
	ALTER COLUMN atenhosarehoscod TYPE character(2),
	ALTER COLUMN atenhosservhoscod TYPE character(3),
	ALTER COLUMN atenhosactcod TYPE character(2),
	ALTER COLUMN atenhostipdocidenpercod TYPE character(2),
	ALTER COLUMN atenhosperasisdocidennum TYPE character(15),
	ALTER COLUMN atenhosperproflg TYPE character(1),
	ALTER COLUMN tipatehoscod TYPE character(1),
	ALTER COLUMN cpscod TYPE character(10),
	ALTER COLUMN atenhosusucrecod TYPE character(15),
	ALTER COLUMN atenhoscrefec TYPE date USING atenhoscrefec::date,
	ALTER COLUMN atenhosusumodcod TYPE character(15),
	ALTER COLUMN atenhosmodfec TYPE date USING atenhosmodfec::date,
	ALTER COLUMN atenhosmovsecnum TYPE numeric(2,0) USING atenhosmovsecnum::numeric(2,0),
	ALTER COLUMN conddiagcod TYPE character(1),
	ALTER COLUMN diagcod TYPE character(7),
	ALTER COLUMN atenhosdiagord TYPE numeric(2,0) USING atenhosdiagord::numeric(2,0),
	ALTER COLUMN atenhostipodiagcod TYPE numeric(2,0) USING atenhostipodiagcod::numeric(2,0),
	ALTER COLUMN pacsecnum TYPE numeric(10,0) USING pacsecnum::numeric(15,0),
	ALTER COLUMN pertipdocidencod TYPE character(2),
	ALTER COLUMN perdocidennum TYPE character(20),
	ALTER COLUMN pernacfec TYPE date USING pernacfec::date,
	ALTER COLUMN persexocod TYPE numeric(1,0) USING persexocod::numeric(1,0);

	INSERT INTO {tabla} 
	(atenhosoricenasicod,atenhoscenasicod,atenhosactmednum,atenhosfec,atenhoshor,atenhosnumsec,atenhosperoricenasicod,atenhospercenasicod,atenhosarehoscod,atenhosservhoscod,atenhosactcod,atenhostipdocidenpercod,atenhosperasisdocidennum,atenhosperproflg,tipatehoscod,cpscod,atenhosusucrecod,atenhoscrefec,atenhosusumodcod,atenhosmodfec,atenhosmovsecnum,conddiagcod,diagcod,atenhosdiagord,atenhostipodiagcod,pacsecnum,pertipdocidencod,perdocidennum,pernacfec,persexocod)
	SELECT 
	atenhosoricenasicod,atenhoscenasicod,atenhosactmednum,atenhosfec,atenhoshor,atenhosnumsec,atenhosperoricenasicod,atenhospercenasicod,atenhosarehoscod,atenhosservhoscod,atenhosactcod,atenhostipdocidenpercod,atenhosperasisdocidennum,atenhosperproflg,tipatehoscod,cpscod,atenhosusucrecod,atenhoscrefec,atenhosusumodcod,atenhosmodfec,atenhosmovsecnum,conddiagcod,diagcod,atenhosdiagord,atenhostipodiagcod,pacsecnum,pertipdocidencod,perdocidennum,pernacfec,persexocod


	FROM tmp_{tabla};
	"""

	c1= text(query)
	connection3.execute(c1)



	#BORRAMOS LAS TABLAS
	query2=f"""
	DROP TABLE tmp_{tabla};
	"""
	c2= text(query2)
	cursor=connection3.execute(c2)

	base1 = base1.rename(columns={
		'atenhosoricenasicod': 'ori_cas',
		'atenhoscenasicod': 'cod_cas',
		'atenhosactmednum': 'act_med',
		'atenhosfec': 'fec_hos',
		'atenhoshor': 'hor_hos',
		'atenhosnumsec': 'num_sec',
		'atenhosperoricenasicod': 'ori_cas_per',
		'atenhospercenasicod': 'cod_cas_per',
		'atenhosarehoscod': 'cod_are',
		'atenhosservhoscod': 'cod_ser',
		'atenhosactcod': 'cod_act',
		'atenhostipdocidenpercod': 'cod_tdi_med',
		'atenhosperasisdocidennum': 'num_doc_med',
		'atenhosperproflg': 'med_pro_flg',
		'tipatehoscod': 'cod_tiphos',
		'cpscod': 'cod_cps',
		'atenhosusucrecod': 'usu_cre',
		'atenhoscrefec': 'fec_cre',
		'atenhosusumodcod': 'usu_mod',
		'atenhosmodfec': 'fec_mod',
		'atenhosmovsecnum': 'mov_secnum',
		'conddiagcod': 'cond_diag',
		'diagcod': 'cod_diag',
		'atenhosdiagord': 'ord_diag',
		'atenhostipodiagcod': 'tip_diag',
		'pacsecnum': 'pac_sec',
		'pertipdocidencod': 'cod_tdi_pac',
		'perdocidennum': 'num_doc_pac',
		'pernacfec': 'fec_nac_pac',
		'persexocod': 'sexo_pac'
	})

	
	oricas = pd.read_sql_query(f"SELECT id_oricas, ori_cod FROM dim_oricas", con=connection2)
	oricas = oricas.rename(columns={"ori_cod": "ori_cas"})
	oricas['ori_cas']=oricas['ori_cas'].str.strip()
	base1['ori_cas']=base1['ori_cas'].str.strip()
	base1 = pd.merge(base1, oricas, on='ori_cas', how="left")
	base1 = base1.drop('ori_cas', axis=1)

	
	cas = pd.read_sql_query(f"SELECT id_cas,cod_cas, cod_red FROM dim_cas where id_cas is not null", con=connection2)
	cas = cas.drop_duplicates(subset=['cod_cas'])
	cas=cas.dropna()
	red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)
	cas_red = pd.merge(cas, red, how="left", on="cod_red")
	base1 = pd.merge(base1, cas_red, on='cod_cas', how="left")
	base1 = base1.drop('cod_red', axis=1)
	base1 = base1.drop('cod_cas', axis=1)

	
	oricas = pd.read_sql_query(f"SELECT id_oricas, ori_cod FROM dim_oricas", con=connection2)
	oricas = oricas.rename(columns={"id_oricas": "id_oricas_per"})
	oricas = oricas.rename(columns={"ori_cod": "ori_cas_per"})
	oricas['ori_cas_per']=oricas['ori_cas_per'].str.strip()
	base1['ori_cas_per']=base1['ori_cas_per'].str.strip()
	base1 = pd.merge(base1, oricas, on='ori_cas_per', how="left")
	base1 = base1.drop('ori_cas_per', axis=1)

	
	cas = pd.read_sql_query(f"SELECT id_cas,cod_cas, cod_red FROM dim_cas where id_cas is not null", con=connection2)
	cas = cas.drop_duplicates(subset=['cod_cas'])
	cas=cas.dropna()
	red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)
	cas_red = pd.merge(cas, red, how="left", on="cod_red")
	cas_red = cas_red.rename(columns={"cod_cas": "cod_cas_per"})
	cas_red = cas_red.rename(columns={"id_cas": "id_cas_per"})
	cas_red = cas_red.rename(columns={"id_red": "id_red_per"})
	base1 = pd.merge(base1, cas_red, on='cod_cas_per', how="left")
	base1 = base1.drop('cod_red', axis=1)
	base1 = base1.drop('cod_cas_per', axis=1)

	
	are = pd.read_sql_query(f"SELECT id_area,cod_are FROM dim_areas", con=connection2)
	are['cod_are']=are['cod_are'].str.strip()
	base1['cod_are']=base1['cod_are'].str.strip()
	base1=pd.merge(base1,are,how='left',on='cod_are')
	base1=base1.drop('cod_are',axis=1)

	
	serv= pd.read_sql_query(f"SELECT id_serv,cod_ser FROM dim_servicios", con=connection2)
	serv['cod_ser']=serv['cod_ser'].str.strip()
	base1['cod_ser']=base1['cod_ser'].str.strip()
	base1=pd.merge(base1,serv,how='left',on='cod_ser')
	base1=base1.drop('cod_ser',axis=1)

	
	activi = pd.read_sql_query(f"SELECT id_activi, cod_act FROM dim_activi", con=connection2)
	activi['cod_act']=activi['cod_act'].str.strip()
	base1['cod_act']=base1['cod_act'].str.strip()
	activi=activi.rename(columns={"id_activi":"id_acti"})
	base1=pd.merge(base1,activi,how='left',on='cod_act')
	base1=base1.drop('cod_act',axis=1)

	
	tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
	tipdoc=tipdoc.rename(columns={"id_tipdoc":"id_tdi_med"})
	tipdoc=tipdoc.rename(columns={"cod_tdo":"cod_tdi_med"})
	base1=pd.merge(base1,tipdoc,how='left',on='cod_tdi_med')
	base1 = base1.drop('cod_tdi_med', axis=1)

	
	tipate = pd.read_sql_query(f"SELECT id_tiphos, cod_tipate FROM dim_tiphos", con=connection2)
	tipate =tipate.rename(columns={"id_tiphos":"id_tipatehos"})
	tipate=tipate.rename(columns={"cod_tipate":"cod_tiphos"})
	base1=pd.merge(base1,tipate,how='left',on='cod_tiphos')
	base1 = base1.drop('cod_tiphos', axis=1)

	
	cps = pd.read_sql_query(f"SELECT id_cps,cod_cps FROM dim_cps", con=connection2)
	cps['cod_cps']=cps['cod_cps'].str.strip()
	base1['cod_cps']=base1['cod_cps'].str.strip()
	base1 = pd.merge(base1, cps, on='cod_cps', how="left")
	base1 = base1.drop('cod_cps', axis=1)

	tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
	tipdoc=tipdoc.rename(columns={"id_tipdoc":"id_tdi_pac"})
	tipdoc=tipdoc.rename(columns={"cod_tdo":"cod_tdi_pac"})
	base1=pd.merge(base1,tipdoc,how='inner',on='cod_tdi_pac')
	
	condiag = pd.read_sql_query(f"SELECT id_condia,cod_con FROM dim_condiag", con=connection2)
	base1 = base1.rename(columns={"cond_diag": "cod_con"})
	condiag['cod_con']=condiag['cod_con'].str.strip()
	base1['cod_con']=base1['cod_con'].str.strip()
	base1 = pd.merge(base1, condiag, on='cod_con', how="left")
	base1 = base1.drop('cod_con', axis=1)


	cie10 = pd.read_sql_query(f"SELECT id_cie,cod_cie FROM dim_cie10", con=connection2)
	base1 = base1.rename(columns={"cod_diag": "cod_cie"})
	cie10['cod_cie']=cie10['cod_cie'].str.strip()
	base1['cod_cie']=base1['cod_cie'].str.strip()
	base1 = pd.merge(base1, cie10, on='cod_cie', how="left")
	base1 = base1.drop('cod_cie', axis=1)


	tipdx = pd.read_sql_query(f"SELECT id_tipdx,cod_tdx FROM dim_tipdx", con=connection2)
	tipdx = tipdx.rename(columns={"cod_tdx": "tip_diag"})
	tipdx['tip_diag']=tipdx['tip_diag'].str.strip()
	base1['tip_diag']=base1['tip_diag'].str.strip()
	base1 = pd.merge(base1, tipdx, on='tip_diag', how="left")
	base1 = base1.drop('tip_diag', axis=1)

	base2=pd.read_sql_query(f"SELECT * FROM {dat} LIMIT 10", con=connection2)

	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df2_columns - df1_columns
	different_columns

	borrando=f"DELETE FROM {dat} WHERE {col_dat} >='{fecha_ini_str}' and {col_dat} <'{fecha_fin_str}'"
	borrado = connection2.execute(borrando)

	comunes = set(base1.columns).intersection(set(base2.columns)) 
	base = base1[list(comunes)]
	base.to_sql(name=f'{dat}', con=engine2, if_exists='append', index=False,chunksize=5000)

	
	fecha_ini = fecha_fin_mes

	finproceso=time.time()
	tiempoproceso=finproceso - inicioTiempo
	tiempoproceso=round(tiempoproceso,3)
	print("Proceso completado satisfactoriamente en " + str(tiempoproceso)+" segundos")


now2 = datetime.now().strftime('%Y-%m-%d')
query2=f"UPDATE etl_act SET fec_ini ='{now2}' WHERE id_mod=14"
c2= text(query2)
connection2.execute(c2)

connection1.close()
connection2.close()
connection3.close()
connection4.close()

engine1.dispose()
engine2.dispose()
engine3.dispose()
engine4.dispose()