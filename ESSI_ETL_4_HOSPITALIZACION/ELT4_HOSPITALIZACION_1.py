
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




fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=11", con=connection2)
fecha_ini= fecha_ini.iloc[0, 0]
#ACTIVAR PARA ACTUALIZAR
fecha_ini = date(fecha_ini.year, fecha_ini.month, fecha_ini.day) - timedelta(days=32)

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=11", con=connection2)
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

	query=f"UPDATE etl_act SET fec_act ='{now}' WHERE id_mod=11"

	c1= text(query)
	connection2.execute(c1)
	
	tabla='hthos10'
	col_tabla='hospintfec'
	col_dat='fec_int'
	dat='dat_hosp0001_essi'

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

	query = f"""SELECT c.*, c2.PERTIPDOCIDENCOD, c2.PERDOCIDENNUM, c2.PERNACFEC, c2.PERSEXOCOD FROM {tabla} c LEFT JOIN (
    SELECT PERSECNUM, PERTIPDOCIDENCOD, PERDOCIDENNUM, PERNACFEC, PERSEXOCOD
    FROM CMPER10
    GROUP BY PERSECNUM, PERTIPDOCIDENCOD, PERDOCIDENNUM, PERNACFEC, PERSEXOCOD 
	) c2 ON c.hospbuspacsecnum = c2.PERSECNUM WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') AND {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"""
	base1 = pd.read_sql_query(query, con=connection0)


	connection0.close()


	base1.to_sql(name=f'tmp_{tabla}', con=engine3, if_exists='replace', index=False)



	borrado = f"DELETE FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection3.execute(borrado)



	query=f"""

	ALTER TABLE tmp_{tabla} 
	ALTER COLUMN hosporicenasicod TYPE character(1) USING hosporicenasicod::character(1),
	ALTER COLUMN hospcenasicod TYPE character(3) USING hospcenasicod::character(3),
	ALTER COLUMN hospactmednum TYPE numeric(10,0) USING hospactmednum::numeric(10,0),
	ALTER COLUMN hospintfec TYPE date USING hospintfec::date,
	ALTER COLUMN hospinthor TYPE timestamp with time zone USING hospinthor::timestamp with time zone,
	ALTER COLUMN oioricenasicod TYPE character(1) USING oioricenasicod::character(1),
	ALTER COLUMN oicenasicod TYPE character(3) USING oicenasicod::character(3),
	ALTER COLUMN oiordintnum TYPE numeric(10,0) USING oiordintnum::numeric(10,0),
	ALTER COLUMN hosppacperm TYPE character(1) USING hosppacperm::character(1),
	ALTER COLUMN hospultserfec TYPE date USING hospultserfec::date,
	ALTER COLUMN hospaltprofec TYPE date USING hospaltprofec::date,
	ALTER COLUMN hospegrflg TYPE character(1) USING hospegrflg::character(1),
	ALTER COLUMN hospaltmedfec TYPE date USING hospaltmedfec::date,
	ALTER COLUMN hospaltmedhor TYPE timestamp with time zone USING hospaltmedhor::timestamp with time zone,
	ALTER COLUMN hospaltadmfec TYPE date USING hospaltadmfec::date,
	ALTER COLUMN hospaltadmhor TYPE timestamp with time zone USING hospaltadmhor::timestamp with time zone,
	ALTER COLUMN motegrcod TYPE character(2) USING motegrcod::character(2),
	ALTER COLUMN hospegroricenasirefcod TYPE character(1) USING hospegroricenasirefcod::character(1),
	ALTER COLUMN hospegrcenasirefcod TYPE character(3) USING hospegrcenasirefcod::character(3),
	ALTER COLUMN hospusucrecod TYPE character(10) USING hospusucrecod::character(10),
	ALTER COLUMN hospcrefec TYPE date USING hospcrefec::date,
	ALTER COLUMN hospusumodcod TYPE character(10) USING hospusumodcod::character(10),
	ALTER COLUMN hospmodfec TYPE date USING hospmodfec::date,
	ALTER COLUMN hosptipdocidenpercod TYPE character(1) USING hosptipdocidenpercod::character(1),
	ALTER COLUMN hospperasisdocidennum TYPE character(10) USING hospperasisdocidennum::character(10),
	ALTER COLUMN hospbuspacsecnum TYPE numeric(10,0) USING hospbuspacsecnum::numeric(10,0),
	ALTER COLUMN hosparehoscod TYPE character(2) USING hosparehoscod::character(2),
	ALTER COLUMN hospnumsec TYPE numeric(2,0) USING hospnumsec::numeric(2,0),
	ALTER COLUMN pertipdocidencod type character(2),
	ALTER COLUMN perdocidennum type character(15),
	ALTER COLUMN pernacfec TYPE date USING pernacfec::date,
	ALTER COLUMN persexocod type character(2);


	INSERT INTO {tabla} 
	(hosporicenasicod,hospcenasicod,hospactmednum,hospintfec,hospinthor,oioricenasicod,oicenasicod,oiordintnum,hosppacperm,hospultserfec,hospaltprofec,hospegrflg,hospaltmedfec,hospaltmedhor,hospaltadmfec,hospaltadmhor,motegrcod,hospegroricenasirefcod,hospegrcenasirefcod,hospusucrecod,hospcrefec,hospusumodcod,hospmodfec,hosptipdocidenpercod,hospperasisdocidennum,hospbuspacsecnum,hosparehoscod,hospnumsec, pertipdocidencod, perdocidennum, pernacfec, persexocod) 

	SELECT 
	hosporicenasicod,hospcenasicod,hospactmednum,hospintfec,hospinthor,oioricenasicod,oicenasicod,oiordintnum,hosppacperm,hospultserfec,hospaltprofec,hospegrflg,hospaltmedfec,hospaltmedhor,hospaltadmfec,hospaltadmhor,motegrcod,hospegroricenasirefcod,hospegrcenasirefcod,hospusucrecod,hospcrefec,hospusumodcod,hospmodfec,hosptipdocidenpercod,hospperasisdocidennum,hospbuspacsecnum,hosparehoscod,hospnumsec, pertipdocidencod, perdocidennum, pernacfec, persexocod

	FROM tmp_{tabla} 
	;
	"""

	c1= text(query)
	connection3.execute(c1)



	#BORRAMOS LAS TABLAS
	query2=f"""
	DROP TABLE tmp_{tabla};
	"""
	c2= text(query2)
	cursor=connection3.execute(c2)


	base1.rename(columns={
		'hospactmednum': 'act_med',
		'hospaltmedfec': 'fec_med',
		'hospaltmedhor': 'hor_med',
		'hospaltprofec': 'fec_pro',
		'hosparehoscod': 'are_hos',
		'hospbuspacsecnum': 'pac_sec',
		'hospcenasicod': 'cod_cas',
		'hospcrefec': 'fec_cre',
		'hospegrcenasirefcod': 'cas_ref',
		'hospegrflg': 'egr_hos',
		'hospegroricenasirefcod': 'ori_ref',
		'hospintfec': 'fec_int',
		'hospinthor': 'hor_int',
		'hospmodfec': 'fec_mod',
		'hospnumsec': 'hos_nse',
		'hosporicenasicod': 'ori_cas',
		'hosppacperm': 'pac_perm',
		'hospperasisdocidennum': 'num_doc_med',
		'hosptipdocidenpercod': 'cod_tdi_med',
		'hospultserfec': 'fec_ser',
		'hospusucrecod': 'usu_cre',
		'hospusumodcod': 'usu_mod',
		'motegrcod': 'mot_egr',
		'oicenasicod': 'cas_cod',
		'oioricenasicod': 'cas_ori',
		'oiordintnum': 'ord_int',
		'hospaltadmfec': 'fec_alt',
		'hospaltadmhor': 'hor_alt',
		'pertipdocidencod': 'cod_tdi_pac', 
		'perdocidennum': 'num_doc_pac',
		'pernacfec': 'pac_fec_nac',
		'persexocod': 'pac_sexo'
	}, inplace=True)

	
	base1 = base1.drop('hospaltobs', axis=1)

	
	oricas = pd.read_sql_query(f"SELECT id_oricas, ori_cod FROM dim_oricas", con=connection2)
	oricas = oricas.rename(columns={"ori_cod": "ori_cas"})
	oricas = oricas.rename(columns={"id_oricas": "id_origen"})
	oricas['ori_cas']=oricas['ori_cas'].str.strip()
	base1['ori_cas']=base1['ori_cas'].str.strip()
	base1 = pd.merge(base1, oricas, on='ori_cas', how="left")
	base1 = base1.drop('ori_cas', axis=1)

	
	oricas = pd.read_sql_query(f"SELECT id_oricas, ori_cod FROM dim_oricas", con=connection2)
	oricas = oricas.rename(columns={"ori_cod": "cas_ori"})
	oricas = oricas.rename(columns={"id_oricas": "id_casori"})
	oricas['cas_ori']=oricas['cas_ori'].str.strip()
	base1['cas_ori']=base1['cas_ori'].str.strip()
	base1 = pd.merge(base1, oricas, on='cas_ori', how="left")
	base1 = base1.drop('cas_ori', axis=1)

	
	cas = pd.read_sql_query(f"SELECT id_cas,cod_cas, cod_red FROM dim_cas where id_cas is not null", con=connection2)
	cas = cas.drop_duplicates(subset=['cod_cas'])
	cas=cas.dropna()
	red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)
	cas_red = pd.merge(cas, red, how="left", on="cod_red")
	base1 = pd.merge(base1, cas_red, on='cod_cas', how="left")
	base1 = base1.drop('cod_red', axis=1)
	base1 = base1.drop('cod_cas', axis=1)

	
	cas = cas.rename(columns={"cod_cas": "cas_cod"})
	cas = cas.rename(columns={"id_cas": "id_cascod"})
	base1 = pd.merge(base1, cas, on='cas_cod', how="left")
	base1 = base1.drop('cas_cod', axis=1)
	base1 = base1.drop('cod_red', axis=1)

	
	pacper = pd.read_sql_query(f"SELECT id_pacper, pac_per FROM dim_hospacper", con=connection2)
	pacper = pacper.rename(columns={"pac_per": "pac_perm"})
	base1=pd.merge(base1,pacper ,how='left',on='pac_perm')
	base1 = base1.drop('pac_perm', axis=1)

	
	hosegr = pd.read_sql_query(f"SELECT id_egrhos, cod_egr FROM dim_hosegr", con=connection2)
	base1 = base1.rename(columns={"egr_hos": "cod_egr"})
	base1=pd.merge(base1,hosegr ,how='left',on='cod_egr')
	base1 = base1.drop('cod_egr', axis=1)

	
	motegr = pd.read_sql_query(f"SELECT id_motegr, cod_mot FROM dim_motegr", con=connection2)
	base1 = base1.rename(columns={"mot_egr": "cod_mot"})
	base1=pd.merge(base1,motegr ,how='left',on='cod_mot')
	base1 = base1.drop('cod_mot', axis=1)

	
	oricas = pd.read_sql_query(f"SELECT id_oricas, ori_cod FROM dim_oricas", con=connection2)
	cas = pd.read_sql_query(f"SELECT id_cas,cod_cas FROM dim_cas where id_cas is not null", con=connection2)
	cas = cas.drop_duplicates(subset=['cod_cas'])
	cas=cas.dropna()
	oricas = oricas.rename(columns={"ori_cod": "ori_ref"})
	oricas = oricas.rename(columns={"id_oricas": "id_oriref"})
	oricas['ori_ref']=oricas['ori_ref'].str.strip()
	base1['ori_ref']=base1['ori_ref'].str.strip()
	base1 = pd.merge(base1, oricas, on='ori_ref', how="left")
	base1 = base1.drop('ori_ref', axis=1)
	cas = cas.rename(columns={"cod_cas": "cas_ref"})
	cas = cas.rename(columns={"id_cas": "id_casref"})
	base1 = pd.merge(base1, cas, on='cas_ref', how="left")
	base1 = base1.drop('cas_ref', axis=1)

	
	tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
	tipdoc=tipdoc.rename(columns={"id_tipdoc":"id_tdi_med"})
	tipdoc=tipdoc.rename(columns={"cod_tdo":"cod_tdi_med"})
	base1=pd.merge(base1,tipdoc,how='left',on='cod_tdi_med')
	base1 = base1.drop('cod_tdi_med', axis=1)

	tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
	tipdoc=tipdoc.rename(columns={"id_tipdoc":"id_tdi_pac"})
	tipdoc=tipdoc.rename(columns={"cod_tdo":"cod_tdi_pac"})
	base1=pd.merge(base1,tipdoc,how='left',on='cod_tdi_pac')
	base1 = base1.drop('cod_tdi_pac', axis=1)

	
	base1.columns

	
	are = pd.read_sql_query(f"SELECT id_area,cod_are FROM dim_areas", con=connection2)
	are=are.rename(columns={"cod_are":"are_hos"})
	base1=pd.merge(base1,are,how='left',on='are_hos')

	base1=base1.drop('are_hos',axis=1)

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
query2=f"UPDATE etl_act SET fec_ini ='{now2}' WHERE id_mod=11"
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