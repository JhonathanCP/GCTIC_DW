from decouple import config
from sqlalchemy import create_engine
import pandas as pd
from datetime import datetime, timedelta
import time 
import datetime
from sqlalchemy import text
import oracledb
import sys
import re

tabla='hthod10'
col_essi='fec_ing'
col_tabla='hosdingfec'
col_dat='fec_ing'
dat='dat_hosp0002_essi'
essi='essi_dat_hos002_etl'

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

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=11", con=connection2)
fecha_fin= fecha_fin.iloc[0, 0]


# Definir el número total de meses desde la fecha de inicio hasta la fecha actual
total_meses = (fecha_fin.year - fecha_ini.year) * 12 + (fecha_fin.month - fecha_ini.month)


for i in range(total_meses+1):
	
	inicioTiempo = time.time()
	now_inicio = datetime.datetime.now()

	# Calcular la fecha de inicio y fin del intervalo mensual
	fecha_ini_mes = fecha_ini
		
	# Obtener el último día del mes actual
	if fecha_fin.month==fecha_ini.month and fecha_fin.year==fecha_ini.year:
		fecha_fin_mes = fecha_fin
	else :
		ultimo_dia_mes_actual = datetime.date(fecha_ini_mes.year, fecha_ini_mes.month, 1) + datetime.timedelta(days=32)
		fecha_fin_mes = ultimo_dia_mes_actual.replace(day=1)

	fecha_ini_str = fecha_ini_mes.strftime('%Y-%m-%d')
	fecha_fin_str = fecha_fin_mes.strftime('%Y-%m-%d')

	print(f"Procesando de {fecha_ini_str} al {fecha_fin_str}")



	now = datetime.datetime.now()

	query=f"UPDATE etl_act SET fec_act ='{now}' WHERE id_mod=11"

	c1= text(query)
	connection2.execute(c1)


	######################FUNCIONES DE LOG###########################
	global dim, control_a, control_d, base1, falla, merge
	control_a=[]
	control_d=[]
	dim=[]
	falla=[]
	id_afectado=[]

	def log_falla(id, cod, isNeeded):
		if isNeeded:
			filas_perdidas = merge.loc[pd.isnull(merge[id])]
			filas_perdidas = filas_perdidas.drop_duplicates(subset=[cod])
			filas_perdidas=filas_perdidas[[cod]]
			if filas_perdidas.empty:
				filas_perdidas_string = 0
			else:
				filas_perdidas_string = filas_perdidas.to_string(index=False, header=False)
				filas_perdidas_string = filas_perdidas_string.replace('\n', ',')
		else:
			filas_perdidas_string = 0
		falla.append(filas_perdidas_string)
		id_afectado.append(id)

	def log_control(table):    
		dim.append(table)
		control_d.append(base1.shape[0])
		control_a.append(base1.shape[0])




	tabla='hthod10'
	col_tabla='hosdingfec'





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



	query=f"""
	select 
	a1.HOSPORICENASICOD,
	a1.HOSPCENASICOD,
	a1.HOSPACTMEDNUM,
	a1.HOSDNUMSEC,
	a1.HOSDAREHOSINTCOD,
	a1.HOSDSERHOSINTCOD,
	a1.HOSDESEHOSINTCOD,
	a1.HOSDAREHOSCOD,
	a1.HOSDSERVHOSCOD,
	a1.HOSDESTENFCOD,
	a1.HOSDHABCOD,
	a1.HOSDCAMCOD,
	a1.ESTPEHCOD,
	a1.HOSDINGFEC,

	CASE WHEN (a1.HOSDINGHOR is null)  THEN '0001-01-01 00:00:00' ELSE to_char(a1.HOSDINGHOR, 'YYYY-MM-DD HH24:MI:SS') end as HOSDINGHOR,
	HOSDEGRFEC,

	CASE WHEN (a1.HOSDEGRHOR is null)  THEN '0001-01-01 00:00:00' ELSE to_char(a1.HOSDEGRHOR, 'YYYY-MM-DD HH24:MI:SS') end as HOSDEGRHOR,

	a1.HOSDTIPDOCIDENPERCOD,
	a1.HOSDPERASISDOCIDENNUM,
	b1.hospbuspacsecnum
		from hthod10 a1

	LEFT JOIN hthos10 b1
		ON a1.HOSPCENASICOD = b1.HOSPCENASICOD and 
		a1.HOSPORICENASICOD=b1.HOSPORICENASICOD and a1.HOSPACTMEDNUM=b1.HOSPACTMEDNUM
	where a1.{col_tabla}>= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and a1.{col_tabla}< TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')
	"""



	base2 = pd.read_sql_query(query, con=connection0)


	connection0.close()





	base2.to_sql(name=f'tmp_{tabla}', con=engine3, if_exists='replace', index=False)



	#Borramos en caso el ETL se ejecute una segunda vez
	borrado = f"DELETE FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection3.execute(borrado)





	query=f"""

	ALTER TABLE tmp_{tabla}
	ALTER COLUMN hosporicenasicod TYPE character(1) USING hosporicenasicod::character(1),
	ALTER COLUMN hospcenasicod TYPE character(3) USING hospcenasicod::character(3),
	ALTER COLUMN hospactmednum TYPE numeric(10,0) USING hospactmednum::numeric(10,0),
	ALTER COLUMN hosdnumsec TYPE numeric(2,0) USING hosdnumsec::numeric(2,0),
	ALTER COLUMN hosdarehosintcod TYPE character(2) USING hosdarehosintcod::character(2),
	ALTER COLUMN hosdserhosintcod TYPE character(3) USING hosdserhosintcod::character(3),
	ALTER COLUMN hosdesehosintcod TYPE character(2) USING hosdesehosintcod::character(2),
	ALTER COLUMN hosdarehoscod TYPE character(2) USING hosdarehoscod::character(2),
	ALTER COLUMN hosdservhoscod TYPE character(3) USING hosdservhoscod::character(3),
	ALTER COLUMN hosdestenfcod TYPE character(2) USING hosdestenfcod::character(2),
	ALTER COLUMN hosdhabcod TYPE character(4) USING hosdhabcod::character(4),
	ALTER COLUMN hosdcamcod TYPE character(5) USING hosdcamcod::character(5),
	ALTER COLUMN estpehcod TYPE character(1) USING estpehcod::character(1),
	ALTER COLUMN hosdingfec TYPE date USING hosdingfec::date,
	ALTER COLUMN hosdinghor TYPE timestamp with time zone USING hosdinghor::timestamp with time zone,
	ALTER COLUMN hosdegrfec TYPE date USING hosdegrfec::date,
	ALTER COLUMN hosdegrhor TYPE timestamp with time zone USING hosdegrhor::timestamp with time zone,
	ALTER COLUMN hosdtipdocidenpercod TYPE character(1) USING hosdtipdocidenpercod::character(1),
	ALTER COLUMN hosdperasisdocidennum TYPE character(10) USING hosdperasisdocidennum::character(10),
	ALTER COLUMN hospbuspacsecnum TYPE numeric(10,0) USING hospbuspacsecnum::numeric(10,0);


	INSERT INTO {tabla} 
	(hosporicenasicod,hospcenasicod,hospactmednum,hosdnumsec,hosdarehosintcod,hosdserhosintcod,hosdesehosintcod,hosdarehoscod,hosdservhoscod,hosdestenfcod,hosdhabcod,hosdcamcod,estpehcod,hosdingfec,hosdinghor,hosdegrfec,hosdegrhor,hosdtipdocidenpercod,hosdperasisdocidennum,hospacsecnum) 

	SELECT 
	hosporicenasicod,hospcenasicod,hospactmednum,hosdnumsec,hosdarehosintcod,hosdserhosintcod,hosdesehosintcod,hosdarehoscod,hosdservhoscod,hosdestenfcod,hosdhabcod,hosdcamcod,estpehcod,hosdingfec,hosdinghor,hosdegrfec,hosdegrhor,hosdtipdocidenpercod,hosdperasisdocidennum,hospbuspacsecnum

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







	borrado = f"DELETE FROM {essi} WHERE {col_essi} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_essi} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection1.execute(borrado)


	base1=pd.read_sql_query(f"SELECT * FROM {essi} LIMIT 10", con=connection1)


	base2.rename(columns={
		'estpehcod': 'est_per',
		'hosdarehoscod': 'are_cam',
		'hosdarehosintcod': 'are_int',
		'hosdcamcod': 'cama',
		'hosdegrfec': 'fec_egr',
		'hosdegrhor': 'hor_egr',
		'hosdhabcod': 'habita',
		'hosdingfec': 'fec_ing',
		'hosdinghor': 'hor_ing',
		'hosdnumsec': 'num_sec',
		'hosdperasisdocidennum': 'num_doc',
		'hosdserhosintcod': 'ser_int',
		'hosdservhoscod': 'ser_cam',
		'hosdtipdocidenpercod': 'tip_doc',
		'hospactmednum': 'act_med',
		'hospcenasicod': 'cod_cas',
		'hosporicenasicod': 'ori_cas',
		'hosdesehosintcod': 'are_enf',
		'hosdestenfcod': 'est_cam',
		'hospbuspacsecnum': 'pac_sec'
	}, inplace=True)



	base2.columns


	cas = pd.read_sql_query(f"SELECT id_red,cod_cas,des_cas FROM dim_cas where id_red is not null", con=connection2)
	red = pd.read_sql_query(f"SELECT id_red,cod_red,des_red FROM dim_red", con=connection2)
	cas_red=pd.merge(cas,red,how='left',on='id_red')
	base2=pd.merge(base2,cas_red,how='left',on='cod_cas')




	servicios = pd.read_sql_query(f"SELECT des_ser,cod_ser FROM dim_servicios", con=connection2)
	servicios_cam=servicios.rename(columns={"des_ser":"des_ser_cam"})
	servicios_cam=servicios_cam.rename(columns={"cod_ser":"ser_cam"})
	base2=pd.merge(base2,servicios_cam,how='left',on='ser_cam')


	base2.columns


	servicios_int=servicios.rename(columns={"des_ser":"des_ser_int"})
	servicios_int=servicios_int.rename(columns={"cod_ser":"ser_int"})
	base2=pd.merge(base2,servicios_int,how='left',on='ser_int')


	estenf = pd.read_sql_query(f"SELECT est_des,ori_cas,cod_cas,ser_cod,are_cod,est_cod FROM dim_estenf", con=connection2)
	estenf['KEY']=estenf['ori_cas']+estenf['cod_cas']+estenf['ser_cod']+estenf['are_cod']+estenf['est_cod']
	base2['KEY']=base2['ori_cas']+base2['cod_cas']+base2['ser_cam']+base2['are_cam']+base2['est_cam']
	estenf=estenf.drop(['ori_cas','cod_cas','ser_cod','are_cod','est_cod'],axis=1)
	estenf=estenf.rename(columns={"est_des":"des_est_cam"})
	base2=pd.merge(base2,estenf,how='left',on='KEY')
	base2 = base2.drop(["KEY"],axis=1)



	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df1_columns - df2_columns
	different_columns


	comunes = set(base2.columns).intersection(set(base1.columns)) 
	base = base2[list(comunes)]


	base.to_sql(name=f'{essi}', con=connection1, if_exists='append', index=False,chunksize=10000)



	


	base1=base





	base2=pd.read_sql_query(f"SELECT * FROM {dat} LIMIT 10", con=connection2)

	control_a.append(base1.shape[0])


	tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)
	
	base1['fec_ing_temp'] = base1['fec_ing'].astype(str).str.split().str[0]
	tiempo=tiempo.rename(columns={"dt_fecha":"fec_ing_temp"})
	tiempo["fec_ing_temp"] = tiempo['fec_ing_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='inner', on='fec_ing_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='fec_ing_temp')
	base1=base1.rename(columns={"id_tiempo":"id_time_ing","dt_mes":"mes_ing","dt_dia":"dia_ing","dt_dia_sem":"dia_sem_ing","dt_sem":"semana_ing","dt_ano":"ano_ing"})
	base1=base1.drop("fec_ing_temp",axis=1)
	base1.shape
	
	
	# tiempo=tiempo.rename(columns={"id_tiempo":"id_time_ing","dt_fecha":"fec_ing","dt_mes":"mes_ing","dt_dia":"dia_ing","dt_dia_sem":"dia_sem_ing","dt_sem":"semana_ing","dt_ano":"ano_ing"})
	# tiempo['fec_ing'] = pd.to_datetime(tiempo['fec_ing'])
	# base1=pd.merge(base1,tiempo,how='left',on='fec_ing')


	base1['fec_egr_temp'] = base1['fec_egr'].astype(str).str.split().str[0]
	tiempo=tiempo.rename(columns={"fec_ing_temp":"fec_egr_temp"})
	tiempo["fec_egr_temp"] = tiempo['fec_egr_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='inner', on='fec_egr_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='fec_egr_temp')
	base1=base1.rename(columns={"id_tiempo":"id_time_egr","dt_mes":"mes_egr","dt_dia":"dia_egr","dt_dia_sem":"dia_sem_egr","dt_sem":"semana_egr","dt_ano":"ano_egr"})
	base1=base1.drop("fec_egr_temp",axis=1)
	base1.shape


	# tiempo=tiempo.rename(columns={"id_tiempo":"id_time_egr","dt_fecha":"fec_egr","dt_mes":"mes_egr","dt_dia":"dia_egr","dt_dia_sem":"dia_sem_egr","dt_sem":"semana_egr","dt_ano":"ano_egr"})
	# tiempo['fec_egr'] = pd.to_datetime(tiempo['fec_egr'])
	# base1=pd.merge(base1,tiempo,how='left',on='fec_egr')





	cama = pd.read_sql_query(f"SELECT id_cama,cas_cod,ser_cod,hab_cod,are_cod,cam_cod,enf_cod FROM dim_hoscamas", con=connection2)
	cama['KEY']=cama['cas_cod']+cama['ser_cod']+cama['hab_cod']+cama['are_cod']+cama['cam_cod']+cama['enf_cod']
	base1['KEY']=base1['cod_cas']+base1['ser_cam']+base1['habita']+base1['are_cam']+base1['cama']+base1['are_enf']
	merge=pd.merge(base1,cama,how='left',on='KEY')
	base1=pd.merge(base1,cama,how='left',on='KEY')


	log_falla('id_cama', 'KEY', True)
	log_control('dim_hoscamas')
	base1 = base1.drop(["KEY"],axis=1)



	estcam = pd.read_sql_query(f"SELECT id_estenf,ori_cas,cod_cas,ser_cod,are_cod,est_cod FROM dim_estenf", con=connection2)
	estcam['KEY']=estcam['ori_cas']+estcam['cod_cas']+estcam['ser_cod']+estcam['are_cod']+estcam['est_cod']
	base1['KEY']=base1['ori_cas']+base1['cod_cas']+base1['ser_cam']+base1['are_cam']+base1['est_cam']
	estcam=estcam.drop(['ori_cas','cod_cas','ser_cod','are_cod','est_cod'],axis=1)
	estcam=estcam.rename(columns={"id_estenf":"id_estcam"})
	merge=pd.merge(base1,estcam,how='left',on='KEY')
	base1=pd.merge(base1,estcam,how='left',on='KEY')

	log_falla('id_estcam', 'KEY', True)
	log_control('dim_estenf')
	base1 = base1.drop(["KEY"],axis=1)


	base1.shape


	oricas = pd.read_sql_query(f"SELECT id_oricas,ori_cod FROM dim_oricas", con=connection2)
	oricas=oricas.rename(columns={"ori_cod":"ori_cas"})
	merge=pd.merge(base1,oricas,how='left',on='ori_cas')
	base1=pd.merge(base1,oricas,how='left',on='ori_cas')


	log_falla('id_oricas', 'ori_cas', True)
	log_control('dim_oricas')
	base1 = base1.drop(["ori_cas"],axis=1)


	base1.shape


	red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)
	merge=pd.merge(base1,red,how='left',on='cod_red')
	base1=pd.merge(base1,red,how='left',on='cod_red')

	log_falla('id_red', 'cod_red', True)
	log_control('dim_red')
	base1 = base1.drop(["cod_red"],axis=1)


	base1.shape


	cas = pd.read_sql_query(f"SELECT id_cas,cod_cas FROM dim_cas where id_red is not null", con=connection2)
	merge=pd.merge(base1,cas,how='left',on='cod_cas')
	base1=pd.merge(base1,cas,how='left',on='cod_cas')

	log_falla('id_cas', 'cod_cas', True)
	log_control('dim_cas')
	base1 = base1.drop(["cod_cas"],axis=1)

	base1.shape


	tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
	tipdoc=tipdoc.rename(columns={"cod_tdo":"tip_doc"})
	merge=pd.merge(base1,tipdoc,how='left',on='tip_doc')
	base1=pd.merge(base1,tipdoc,how='left',on='tip_doc')

	log_falla('id_tipdoc', 'tip_doc', True)
	log_control('dim_tipdoc')
	base1 = base1.drop(["tip_doc"],axis=1)

	base1.shape


	estper = pd.read_sql_query(f"SELECT id_estper,cod_est FROM dim_emeestper", con=connection2)
	estper=estper.rename(columns={"cod_est":"est_per"})
	merge=pd.merge(base1,estper,how='left',on='est_per')
	base1=pd.merge(base1,estper,how='left',on='est_per')

	log_falla('id_estper', 'est_per', True)
	log_control('dim_emeestper')
	base1 = base1.drop(["est_per"],axis=1)

	base1.shape


	personal = pd.read_sql_query(f"SELECT id_person,num_doc FROM dim_personal", con=connection2)
	personal=personal.drop_duplicates(subset="num_doc")
	personal=personal.rename(columns={"id_person":"id_personal"})
	merge=pd.merge(base1,personal,how='left',on='num_doc')
	base1=pd.merge(base1,personal,how='left',on='num_doc')

	log_falla('id_personal', 'num_doc', True)
	log_control('dim_personal')
	base1 = base1.drop(["num_doc"],axis=1)

	base1.shape


	areas = pd.read_sql_query(f"SELECT id_area,cod_are FROM dim_areas", con=connection2)
	areas=areas.rename(columns={"id_area":"id_areint"})
	areas=areas.rename(columns={"cod_are":"are_int"})
	merge=pd.merge(base1,areas,how='left',on='are_int')
	base1=pd.merge(base1,areas,how='left',on='are_int')

	log_falla('id_areint', 'are_int', True)
	log_control('dim_areas')
	base1 = base1.drop(["are_int"],axis=1)

	base1.shape


	areas = pd.read_sql_query(f"SELECT id_area,cod_are FROM dim_areas", con=connection2)
	areas=areas.rename(columns={"id_area":"id_areenf"})
	areas=areas.rename(columns={"cod_are":"are_cam"})
	merge=pd.merge(base1,areas,how='left',on='are_cam')
	base1=pd.merge(base1,areas,how='left',on='are_cam')

	log_falla('id_areenf', 'are_cam', True)
	log_control('dim_areas')
	base1 = base1.drop(["are_cam"],axis=1)

	base1.shape


	areas = pd.read_sql_query(f"SELECT id_area,cod_are FROM dim_areas", con=connection2)
	areas=areas.rename(columns={"id_area":"id_arecam"})
	areas=areas.rename(columns={"cod_are":"are_enf"})
	merge=pd.merge(base1,areas,how='left',on='are_enf')
	base1=pd.merge(base1,areas,how='left',on='are_enf')

	log_falla('id_arecam', 'are_enf', True)
	log_control('dim_areas')
	base1 = base1.drop(["are_enf"],axis=1)

	base1.shape


	servicios = pd.read_sql_query(f"SELECT id_serv,cod_ser FROM dim_servicios", con=connection2)
	servicios=servicios.rename(columns={"cod_ser":"ser_int"})
	servicios=servicios.rename(columns={"id_serv":"id_serint"})
	merge=pd.merge(base1,servicios,how='left',on='ser_int')
	base1=pd.merge(base1,servicios,how='left',on='ser_int')

	log_falla('id_serint', 'cas_cod', True)
	log_control('dim_servicios')
	base1 = base1.drop(["ser_int"],axis=1)

	base1.shape


	servicios = pd.read_sql_query(f"SELECT id_serv,cod_ser FROM dim_servicios", con=connection2)
	servicios=servicios.rename(columns={"cod_ser":"ser_cam"})
	servicios=servicios.rename(columns={"id_serv":"id_sercam"})
	merge=pd.merge(base1,servicios,how='left',on='ser_cam')
	base1=pd.merge(base1,servicios,how='left',on='ser_cam')

	log_falla('id_sercam', 'ser_cam', True)
	base1 = base1.drop(["ser_cam"],axis=1)
	dim.append('dim_servicios')
	control_d.append(base1.shape[0])



	base1=base1.rename(columns={"pac_sec":"id_pacien"})

















	
	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df2_columns - df1_columns
	different_columns

	


	# 
	borrando=f"DELETE FROM {dat} WHERE {col_dat} >='{fecha_ini_str}' and {col_dat} <'{fecha_fin_str}'"
	borrado = connection2.execute(borrando)



	
	comunes = set(base1.columns).intersection(set(base2.columns)) 
	base = base1[list(comunes)]

	
	base.to_sql(name=f'{dat}', con=connection2, if_exists='append', index=False)

		

	
	proceso = "DAT"

	proceso = pd.read_sql_query("SELECT des_mod FROM etl_act where id_mod=11", con=connection2)
	proceso = proceso.iloc[0, 0]
	cod_proceso = pd.read_sql_query("SELECT id_mod FROM etl_act where id_mod=11", con=connection2)
	cod_proceso = cod_proceso.iloc[0, 0]

	now_fin = datetime.datetime.now()
	fecha_log = now.strftime("%Y-%m-%d")
	hora_log_inicio = now_inicio.strftime("%H:%M")
	hora_log_fin = now_fin.strftime("%H:%M")
	tabla_logs = pd.DataFrame({'esperado':control_a,'obtenido':control_d,'dim':dim,'falla':falla})
	tabla_logs['proceso']=proceso
	tabla_logs['dat']=dat
	tabla_logs['fecha_ejecucion']=fecha_log
	tabla_logs['hora_inicio']=hora_log_inicio
	tabla_logs['hora_fin']=hora_log_fin
	tabla_logs['faltante']=tabla_logs['esperado']-tabla_logs['obtenido']
	tabla_logs['codigo']=cod_proceso
	tabla_logs['fecha_ini']=fecha_ini_str
	tabla_logs['fecha_ter']=fecha_fin_str
	tabla_logs['id_afectado']=id_afectado
	nuevas_columnas = ['codigo', 'proceso', 'dat', 'fecha_ejecucion', 'hora_inicio','hora_fin', 'dim', 'fecha_ini','fecha_ter','esperado', 'obtenido', 'faltante','falla', 'id_afectado']
	tabla_logs = tabla_logs.reindex(columns=nuevas_columnas)

	
	
	tabla_logs.to_sql(name=f'logs', con=connection4, if_exists='append', index=False)

	
	

	fecha_ini = fecha_fin_mes




	finproceso=time.time()
	tiempoproceso=finproceso - inicioTiempo
	tiempoproceso=round(tiempoproceso,3)
	print("Proceso completado satisfactoriamente en " + str(tiempoproceso)+" segundos")
	
connection1.close()
connection2.close()
connection3.close()

engine1.dispose()
engine2.dispose()
engine3.dispose()

