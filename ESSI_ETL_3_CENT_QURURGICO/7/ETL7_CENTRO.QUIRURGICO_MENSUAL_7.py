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


fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=13", con=connection2)
fecha_ini= fecha_ini.iloc[0, 0]

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=13", con=connection2)
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
		fecha_fin_mes = ultimo_dia_mes_actual.replace(day=1) - datetime.timedelta(days=1)




	fecha_ini_str = fecha_ini_mes.strftime('%Y-%m-%d')
	fecha_fin_str = fecha_fin_mes.strftime('%Y-%m-%d')

	print(f"Procesando de {fecha_ini_str} al {fecha_fin_str}")

	now = datetime.datetime.now()

	query=f"UPDATE etl_act SET fec_act ='{now}' WHERE id_mod=13"

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


	tabla='qtsoo10'
	col_tabla = 'solopefec'

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
	select
	d1.SOLOPEORICENASICOD,  
	d1.SOLOPECENASICOD,  
	d1.SOLOPENUM,
	d1.SOLOPECPSCOD,
	d1.SOLOPEFLGPRI,
	d1.SOLOPEPQXCPSCOD,
	d1.SOLOPEPQXSECUEN,
	d1.SOLOPESOLMATDOCNUM,
	d1.SOLOPEGRDCOMOPECOD,a1.solopefec as solopefec,  
	a1.SOLOPEACTMEDNUM,  
	a1.SOLOPEBUSPACSECNUM
	from {tabla} d1  
	left outer join qtsop10 a1 on a1.SOLOPEORICENASICOD = d1.SOLOPEORICENASICOD  
	and a1.SOLOPECENASICOD = d1.SOLOPECENASICOD  
	and a1.SOLOPENUM = d1.SOLOPENUM

	where a1.{col_tabla}>=TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and a1.{col_tabla}<=TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')
	"""

	base1 = pd.read_sql_query(query0,con=connection0)


	connection0.close()


	base1.shape


	#CREAMOS LA TABLA TEMPORAL
	base1.to_sql(name=f'tmp_{tabla}', con=engine3, if_exists='replace', index=False)



	#Borramos en caso el ETL se ejecute una segunda vez
	borrado = f"DELETE FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} <= TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection3.execute(borrado)


	query=f"""

	ALTER TABLE tmp_{tabla} 
	ALTER COLUMN solopeoricenasicod TYPE character(1),
	ALTER COLUMN solopecenasicod TYPE character(3),
	ALTER COLUMN solopenum TYPE numeric(10,0),
	ALTER COLUMN solopecpscod TYPE character(10),
	ALTER COLUMN solopeflgpri TYPE numeric(1,0),
	ALTER COLUMN solopepqxcpscod TYPE character(10),
	ALTER COLUMN solopepqxsecuen TYPE numeric(2,0),
	ALTER COLUMN solopesolmatdocnum TYPE numeric(10,0),
	ALTER COLUMN solopegrdcomopecod TYPE character(1),
	ALTER COLUMN solopefec TYPE date,
	ALTER COLUMN solopeactmednum TYPE numeric(10,0),
	ALTER COLUMN solopebuspacsecnum TYPE numeric(10,0);


	INSERT INTO {tabla} 
	(solopeoricenasicod,solopecenasicod,solopenum,solopecpscod,solopeflgpri,solopepqxcpscod,solopepqxsecuen,solopesolmatdocnum,
	solopegrdcomopecod,solopefec,solopeactmednum,solopebuspacsecnum) 

	SELECT 
	solopeoricenasicod,solopecenasicod,solopenum,solopecpscod,solopeflgpri,solopepqxcpscod,solopepqxsecuen,solopesolmatdocnum,
	solopegrdcomopecod,solopefec,solopeactmednum,solopebuspacsecnum


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



	#INICIO DEL ESSI

	tabla='qtsoo10'
	col_tabla = 'solopefec'
	essi='essi_dat_cqx007_etl'
	col_essi='sol_fec'

	base1 = base1.rename(columns={
		'solopeoricenasicod': 'ori_cas',
		'solopecenasicod': 'cod_cas',
		'solopenum': 'sol_num',
		'solopecpscod': 'cod_cps',
		'solopeflgpri': 'flg_pri',
		'solopepqxcpscod': 'paq_qui',
		'solopepqxsecuen': 'paq_sec',
		'solopesolmatdocnum': 'sol_med',
		'solopegrdcomopecod': 'grd_com',
		'solopefec': 'sol_fec',
		'solopeactmednum': 'act_med',
		'solopebuspacsecnum': 'pac_sec'
	})

	base1.shape


	base2=pd.read_sql_query(f"SELECT * FROM {essi} LIMIT 10", con=connection1)




	# #TRAEMOS TODOS LOS MAESTROS

	cas = pd.read_sql_query(f"SELECT id_red,cod_cas,des_cas FROM dim_cas where id_red is not null", con=connection2)
	cas = cas.drop_duplicates(subset=['cod_cas'])
	cas=cas.dropna()
	red = pd.read_sql_query(f"SELECT id_red,cod_red,des_red FROM dim_red", con=connection2)
	cas_red=pd.merge(cas,red,how='left',on='id_red')
	#id_red,cod_cas,des_cas,cod_red,des_red

	base1=pd.merge(base1,cas_red,how='left',on='cod_cas')
	base1=base1.drop("id_red", axis=1)
	base1.shape


	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df2_columns - df1_columns
	different_columns


	comunes = set(base1.columns).intersection(set(base2.columns)) 
	base = base1[list(comunes)]


	base.columns


	borrado = f"DELETE FROM {essi} WHERE {col_essi} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_essi} <= TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection1.execute(borrado)



	base.to_sql(name=f'{essi}', con=connection1, if_exists='append', index=False,chunksize=10000)



	#INICIA EL DAT
	base1=base

	tabla='qtsoo10'
	col_tabla = 'solopefec'
	essi='essi_dat_cqx007_etl'
	col_essi='sol_fec'
	dat= "dat_ceqx007_essi"
	col_dat='sol_fec'



	cas = pd.read_sql_query(f"SELECT id_cas,cod_cas FROM dim_cas where id_cas is not null", con=connection2)
	cas = cas.drop_duplicates(subset=['cod_cas'])
	cas=cas.dropna()
	red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)

	oricas = pd.read_sql_query(f"SELECT id_oricas,ori_cod FROM dim_oricas", con=connection2)
	oricas["ori_cod"]=oricas["ori_cod"].str.strip()

	cps= pd.read_sql_query(f"SELECT id_cps,cod_cps FROM dim_cps", con=connection2)
	cps["cod_cps"]=cps["cod_cps"].str.strip()

	tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)

	pacsec = pd.read_sql_query(f"SELECT id_pacsec,per_sec FROM dim_pacsec", con=connection2)




	base2=pd.read_sql_query(f"SELECT * FROM {dat} LIMIT 10", con=connection2)

	#Eliminamos las columnas que no se usarán aquí: las descripciones previa evaluación

	# Lista de columnas a eliminar
	columnas_eliminar = ['des_cas', 'des_red', 'grd_com']

	# Eliminar las columnas
	base1 = base1.drop(columns=columnas_eliminar)


	control_a.append(base1.shape[0])


	oricas=oricas.rename(columns={"ori_cod":"ori_cas"})
	base1['ori_cas']=base1['ori_cas'].str.strip()
	base1["ori_cas"]=base1["ori_cas"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,oricas,how='left',on='ori_cas')
	base1=pd.merge(base1,oricas,how='inner',on='ori_cas')
	base1.shape


	log_falla('id_oricas', 'ori_cas', True)
	log_control('dim_oricas')
	base1=base1.drop('ori_cas',axis=1)


	base1['cod_cas']=base1['cod_cas'].str.strip()
	base1["cod_cas"]=base1["cod_cas"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,cas,how='left',on='cod_cas')
	base1=pd.merge(base1,cas,how='inner',on='cod_cas')
	base1.shape


	log_falla('id_cas', 'cod_cas', True)
	log_control('dim_cas')
	base1=base1.drop('cod_cas',axis=1)


	base1['cod_red']=base1['cod_red'].str.strip()
	base1["cod_red"]=base1["cod_red"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,red,how='left',on='cod_red')
	base1=pd.merge(base1,red,how='inner',on='cod_red')
	base1.shape


	log_falla('id_red', 'cod_red', True)
	log_control('dim_red')
	base1=base1.drop('cod_red',axis=1)


	base1['cod_cps']=base1['cod_cps'].str.strip()
	base1["cod_cps"]=base1["cod_cps"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,cps,how='inner',on='cod_cps')
	base1=pd.merge(base1,cps,how='left',on='cod_cps')
	base1.shape

	log_falla('id_cps', 'cod_cps', True)
	log_control('dim_cps')
	base1=base1.drop('cod_cps',axis=1)

	cps=cps.rename(columns={"id_cps": "id_paqqui", "cod_cps":"paq_qui"})
	base1['paq_qui']=base1['paq_qui'].str.strip()
	base1["paq_qui"]=base1["paq_qui"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,cps,how='inner',on='paq_qui')
	base1=pd.merge(base1,cps,how='left',on='paq_qui')
	base1.shape
	
	log_falla('id_paqqui', 'paq_qui', True)
	log_control('dim_cps')
	base1=base1.drop('paq_qui',axis=1)
 
	pacsec=pacsec.rename(columns={"per_sec": "pac_sec"})
	pacsec['pac_sec']=pacsec['pac_sec'].astype(str).str.strip()
	pacsec["pac_sec"]=pacsec["pac_sec"].str.replace(' ', '', regex=True)
	base1['pac_sec']=base1['pac_sec'].astype(str).str.strip()
	base1["pac_sec"]=base1["pac_sec"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,pacsec,how='inner',on='pac_sec')
	base1=pd.merge(base1,pacsec,how='left',on='pac_sec')
	base1.shape

	log_falla('id_pacsec', 'pac_sec', True)
	base1=base1.drop('pac_sec',axis=1)
	dim.append('dim_pacsec')
	control_d.append(base1.shape[0])


	base1['sol_fec_temp'] = base1['sol_fec'].astype(str).str.split().str[0]
	tiempo=tiempo.rename(columns={"dt_fecha":"sol_fec_temp"})
	tiempo["sol_fec_temp"] = tiempo['sol_fec_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='inner', on='sol_fec_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='sol_fec_temp')
	base1=base1.rename(columns={"id_tiempo":"id_time_sol","dt_ano":"ano_sol","dt_mes":"mes_sol",
								"dt_dia":"dia_sol","dt_dia_sem":"dia_sem_sol","dt_sem":"sem_sol"})
	base1=base1.drop("sol_fec_temp",axis=1)
	base1.shape


	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df2_columns - df1_columns
	different_columns

	borrando=f"DELETE FROM {dat} WHERE {col_dat} >='{fecha_ini_str}' and {col_dat} <='{fecha_fin_str}'"
	borrado = connection2.execute(borrando)


	comunes = set(base1.columns).intersection(set(base2.columns)) 
	base = base1[list(comunes)]


	base.to_sql(name=f'{dat}', con=connection2, if_exists='append', index=False,chunksize=10000)


	# proceso = "DAT"
	# cod_proceso = 13

	proceso = pd.read_sql_query("SELECT des_mod FROM etl_act where id_mod=13", con=connection2)
	proceso = proceso.iloc[0, 0]
	cod_proceso = pd.read_sql_query("SELECT id_mod FROM etl_act where id_mod=13", con=connection2)
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

	tabla_logs



	tabla_logs.to_sql(name=f'logs_borrar1', con=connection4, if_exists='append', index=False,chunksize=10000)


	fecha_ini = fecha_fin_mes + datetime.timedelta(days=1)

	finproceso=time.time()
	tiempoproceso=finproceso - inicioTiempo
	tiempoproceso=round(tiempoproceso,3)
	print("Proceso completado satisfactoriamente en " + str(tiempoproceso)+" segundos")


connection1.close()
connection2.close()
connection3.close()
connection4.close()


engine1.dispose()
engine2.dispose()
engine3.dispose()
engine4.dispose()




