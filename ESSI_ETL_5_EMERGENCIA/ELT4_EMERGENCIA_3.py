
from decouple import config
from sqlalchemy import create_engine
import pandas as pd
from datetime import datetime, timedelta, date
import time 
from sqlalchemy import text
import oracledb
import sys


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


fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=4", con=connection2)
fecha_ini= fecha_ini.iloc[0, 0]

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=4", con=connection2)
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

	tabla='mtaem10'
	col_tabla = "ateemefec"
	dat= "dat_emer003_essi"
	col_dat='fec_ate'


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
		ah.ATEEMEORICENASICOD,
		ah.ATEEMECENASICOD,
		ah.ATEEMEACTMEDNUM,
		ah.ATEEMEFEC,
		ah.ATEEMEHOR,
		ah.ATEEMESECNUM,
		ah.ATEEMEPERORICENASICOD,
		ah.ATEEMEPERCENASICOD,
		ah.ATEEMEAREHOSCOD,
		ah.ATEEMESERVHOSCOD,
		ah.ATEEMEACTCOD,
		ah.ATEEMETIPDOCIDENPERCOD,
		ah.ATEEMEPERASISDOCIDENNUM,
		ah.ATEEMEPERPROFLG,
		ah.TIPOATEEMECOD,
		ah.CPSCOD,
		ah.ATEEMEUSUCRECOD,
		ah.ATEEMECREFEC,
		ah.ATEEMEUSUMODCOD,
		ah.ATEEMEMODFEC,
		ah.ATEEMEMOVSECNUM,
		ah.MOTEGRCOD,	
		hd.CONDDIAGCOD, 
		hd.DIAGCOD, 
		hd.ATEEMEDIAGORD, 
		hd.ATEEMETIPODIAGCOD,
		c.PERSECNUM AS PACSECNUM,
		c.PERTIPDOCIDENCOD,
		c.PERDOCIDENNUM,
		c.PERNACFEC,
		c.PERSEXOCOD

	FROM {tabla} ah
	LEFT OUTER JOIN MTDAE10 hd ON ah.ATEEMEORICENASICOD = hd.ATEEMEORICENASICOD
		AND ah.ATEEMECENASICOD = hd.ATEEMECENASICOD 
		AND ah.ATEEMEACTMEDNUM  = hd.ATEEMEACTMEDNUM
		AND ah.ATEEMESECNUM = hd.ATEEMESECNUM
	LEFT OUTER JOIN MTADE10 ad ON ah.ATEEMEORICENASICOD = ad.ADMEMEORICENASICOD 
		AND ah.ATEEMECENASICOD = ad.ADMEMECENASICOD  
		AND ah.ATEEMEACTMEDNUM  = ad.ADMEMEACTMEDNUM
	LEFT OUTER JOIN CMPER10 c ON ad.ADMEMEPACSECNUM = c.PERSECNUM
	WHERE ah.{col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') AND ah.{col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')
	"""

	base1 = pd.read_sql_query(query0, con=connection0)

	connection0.close()

	base1.to_sql(name=f'tmp_{tabla}', con=engine3, if_exists='replace', index=False)

	borrado = f"DELETE FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection3.execute(borrado)



	query=f"""

	ALTER TABLE tmp_{tabla}
	ALTER COLUMN ateemeoricenasicod TYPE character(1),
	ALTER COLUMN ateemecenasicod TYPE character(3),
	ALTER COLUMN ateemeactmednum TYPE numeric(10,0) USING ateemeactmednum::numeric(10,0),
	ALTER COLUMN ateemefec TYPE date USING ateemefec::date,
	ALTER COLUMN ateemehor TYPE timestamp USING ateemehor::timestamp with time zone,
	ALTER COLUMN ateemesecnum TYPE numeric(4,0) USING ateemesecnum::numeric(4,0),
	ALTER COLUMN ateemeperoricenasicod TYPE character(1),
	ALTER COLUMN ateemepercenasicod TYPE character(3),
	ALTER COLUMN ateemearehoscod TYPE character(2),
	ALTER COLUMN ateemeservhoscod TYPE character(3),
	ALTER COLUMN ateemeactcod TYPE character(2),
	ALTER COLUMN ateemetipdocidenpercod TYPE character(2),
	ALTER COLUMN ateemeperasisdocidennum TYPE character(15),
	ALTER COLUMN ateemeperproflg TYPE character(1),
	ALTER COLUMN tipoateemecod TYPE character(2),
	ALTER COLUMN cpscod TYPE character(10),
	ALTER COLUMN ateemeusucrecod TYPE character(15),
	ALTER COLUMN ateemecrefec TYPE date USING ateemecrefec::date,
	ALTER COLUMN ateemeusumodcod TYPE character(15),
	ALTER COLUMN ateememodfec TYPE date USING ateememodfec::date,
	ALTER COLUMN ateememovsecnum TYPE numeric(2,0) USING ateememovsecnum::numeric(2,0),
	ALTER COLUMN motegrcod TYPE character(2),
	ALTER COLUMN conddiagcod TYPE character(1),
	ALTER COLUMN diagcod TYPE character(7),
	ALTER COLUMN ateemediagord TYPE numeric(2,0) USING ateemediagord::numeric(2,0),
	ALTER COLUMN ateemetipodiagcod TYPE numeric(2,0) USING ateemetipodiagcod::numeric(2,0),
	ALTER COLUMN pacsecnum TYPE numeric(10,0) USING pacsecnum::numeric(15,0),
	ALTER COLUMN pertipdocidencod TYPE character(2),
	ALTER COLUMN perdocidennum TYPE character(20),
	ALTER COLUMN pernacfec TYPE date USING pernacfec::date,
	ALTER COLUMN persexocod TYPE numeric(1,0) USING persexocod::numeric(1,0);

	INSERT INTO {tabla} 
	(ateemeoricenasicod,ateemecenasicod,ateemeactmednum,ateemefec,ateemehor,ateemesecnum,ateemeperoricenasicod,ateemepercenasicod,ateemearehoscod,ateemeservhoscod,ateemeactcod,ateemetipdocidenpercod,ateemeperasisdocidennum,ateemeperproflg,tipoateemecod,cpscod,ateemeusucrecod,ateemecrefec,ateemeusumodcod,ateememodfec,ateememovsecnum,motegrcod,conddiagcod,diagcod,ateemediagord,ateemetipodiagcod,pacsecnum,pertipdocidencod,perdocidennum,pernacfec,persexocod)
	SELECT 
	ateemeoricenasicod,ateemecenasicod,ateemeactmednum,ateemefec,ateemehor,ateemesecnum,ateemeperoricenasicod,ateemepercenasicod,ateemearehoscod,ateemeservhoscod,ateemeactcod,ateemetipdocidenpercod,ateemeperasisdocidennum,ateemeperproflg,tipoateemecod,cpscod,ateemeusucrecod,ateemecrefec,ateemeusumodcod,ateememodfec,ateememovsecnum,motegrcod,conddiagcod,diagcod,ateemediagord,ateemetipodiagcod,pacsecnum,pertipdocidencod,perdocidennum,pernacfec,persexocod


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
		'ateemeoricenasicod': 'ori_cas',
		'ateemecenasicod': 'cod_cas',
		'ateemeactmednum': 'act_med',
		'ateemefec': 'fec_ate',
		'ateemehor': 'hor_ate',
		'ateemesecnum': 'num_sec',
		'ateemeperoricenasicod': 'ori_cas_per',
		'ateemepercenasicod': 'cod_cas_per',
		'ateemearehoscod': 'cod_are',
		'ateemeservhoscod': 'cod_ser',
		'ateemeactcod': 'cod_act',
		'ateemetipdocidenpercod': 'cod_tdi_med',
		'ateemeperasisdocidennum': 'num_doc_med',
		'ateemeperproflg': 'med_pro_flg',
		'tipoateemecod': 'cod_eme',
		'cpscod': 'cod_cps',
		'ateemeusucrecod': 'usu_cre',
		'ateemecrefec': 'fec_cre',
		'ateemeusumodcod': 'usu_mod',
		'ateememodfec': 'fec_mod',
		'ateememovsecnum': 'mov_secnum',
		'motegrcod': 'mot_egr',
		'conddiagcod': 'cond_diag',
		'diagcod': 'cod_diag',
		'ateemediagord': 'ord_diag',
		'ateemetipodiagcod': 'tip_diag',
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
	tipdoc=tipdoc.rename(columns={"id_tipdoc":"id_tdi_pac"})
	tipdoc=tipdoc.rename(columns={"cod_tdo":"cod_tdi_pac"})
	base1=pd.merge(base1,tipdoc,how='inner',on='cod_tdi_pac')

	tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
	tipdoc=tipdoc.rename(columns={"id_tipdoc":"id_tdi_med"})
	tipdoc=tipdoc.rename(columns={"cod_tdo":"cod_tdi_med"})
	base1=pd.merge(base1,tipdoc,how='left',on='cod_tdi_med')
	base1 = base1.drop('cod_tdi_med', axis=1)


	eme = pd.read_sql_query(f"SELECT id_emecod, cod_eme FROM dim_emecod", con=connection2)
	eme['cod_eme']=eme['cod_eme'].astype('int64')
	base1['cod_eme']=base1['cod_eme'].astype('int64')
	base1=pd.merge(base1,eme,how='left',on='cod_eme')
	base1=base1.drop('cod_eme',axis=1)


	cps = pd.read_sql_query(f"SELECT id_cps,cod_cps FROM dim_cps", con=connection2)
	cps['cod_cps']=cps['cod_cps'].str.strip()
	base1['cod_cps']=base1['cod_cps'].str.strip()
	base1 = pd.merge(base1, cps, on='cod_cps', how="left")
	base1 = base1.drop('cod_cps', axis=1)


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


	motegr = pd.read_sql_query(f"SELECT id_motegr, cod_mot FROM dim_motegr", con=connection2)
	base1 = base1.rename(columns={"mot_egr": "cod_mot"})
	base1=pd.merge(base1,motegr ,how='left',on='cod_mot')
	base1 = base1.drop('cod_mot', axis=1)


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
query2=f"UPDATE etl_act SET fec_ini ='{now2}' WHERE id_mod=4"
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