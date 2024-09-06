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
		fecha_fin_mes = ultimo_dia_mes_actual.replace(day=1)

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





	tabla='qtian10'
	col_tabla = 'infopecrefecane'



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
	d1.INFOPEORICENASICOD,
	d1.INFOPECENASICOD,
	d1.INFOPESOLOPENUM,
	d1.INFOPEINFANE,
	--INFOPEDURANE,
	to_char(d1.INFOPEDURANE, 'YYYY-MM-DD HH24:MI:SS') as INFOPEDURANE,
	--INFOPECREFECANE,
	d1.INFOPEUSUCRECODANE,
	to_char(d1.INFOPECREFECANE, 'YYYY-MM-DD HH24:MI:SS') as INFOPECREFECANE,
	--d1.INFOPEMODFECANE,
	d1.INFOPEUSUMODCODANE,
	to_char(d1.INFOPEMODFECANE, 'YYYY-MM-DD HH24:MI:SS') as INFOPEMODFECANE,
	--d1.INFOPEDURANEI,
	to_char(d1.INFOPEDURANEI, 'YYYY-MM-DD HH24:MI:SS') as INFOPEDURANEI,
	--d1.INFOPEDURANEF,
	to_char(d1.INFOPEDURANEF, 'YYYY-MM-DD HH24:MI:SS') as INFOPEDURANEF,
	--d1.INFOPEDURSAL,
	to_char(d1.INFOPEDURSAL, 'YYYY-MM-DD HH24:MI:SS') as INFOPEDURSAL,
	--d1.INFOPEDURSALI,
	to_char(d1.INFOPEDURSALI, 'YYYY-MM-DD HH24:MI:SS') as INFOPEDURSALI,
	--d1.INFOPEDURSALF,
	to_char(d1.INFOPEDURSALF, 'YYYY-MM-DD HH24:MI:SS') as INFOPEDURSALF,
	d1.INFOPEANEDOCIDENNUM,
	d1.INFOPEANETIPDOC,
	--d1.INFOPEHINIOPE,
	to_char(d1.INFOPEHINIOPE, 'YYYY-MM-DD HH24:MI:SS') as INFOPEHINIOPE,
	--d1.INFOPEHFINOPE,
	to_char(d1.INFOPEHFINOPE, 'YYYY-MM-DD HH24:MI:SS') as INFOPEHFINOPE,
	--d1.INFOPEHDUROPE,
	to_char(d1.INFOPEHDUROPE, 'YYYY-MM-DD HH24:MI:SS') as INFOPEHDUROPE,
	d1.INFOPEANEDESOPE,

	a1.solopefec as solopefec,
	a1.SOLOPEACTMEDNUM,
	a1.SOLOPEBUSPACSECNUM
	from sgss.{tabla} d1
	left outer join qtsop10 a1 on a1.SOLOPEORICENASICOD = d1.INFOPEORICENASICOD
	and a1.SOLOPECENASICOD    = d1.INFOPECENASICOD
	and a1.SOLOPENUM    = d1.INFOPESOLOPENUM

	where d1.{col_tabla}>=TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and d1.{col_tabla}<TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD') 

	"""

	base1 = pd.read_sql_query(query0,con=connection0)


	connection0.close()



	#CREAMOS LA TABLA TEMPORAL
	base1.to_sql(name=f'tmp_{tabla}', con=engine3, if_exists='replace', index=False)




	#Borramos en caso el ETL se ejecute una segunda vez
	borrado = f"DELETE FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection3.execute(borrado)


	query=f"""

	ALTER TABLE tmp_{tabla} 
	ALTER COLUMN infopeoricenasicod TYPE character(1) USING infopeoricenasicod::character(1),
	ALTER COLUMN infopecenasicod TYPE character(3) USING infopecenasicod::character(3),
	ALTER COLUMN infopesolopenum TYPE numeric(10,0) USING infopesolopenum::numeric(10,0),
	ALTER COLUMN infopeinfane TYPE numeric(2,0) USING infopeinfane::numeric(2,0),
	ALTER COLUMN infopedurane TYPE date USING infopedurane::date,
	ALTER COLUMN infopeusucrecodane TYPE character(10) USING infopeusucrecodane::character(10),
	ALTER COLUMN infopecrefecane TYPE date USING infopecrefecane::date,
	ALTER COLUMN infopemodfecane TYPE date USING infopemodfecane::date,
	ALTER COLUMN infopeusumodcodane TYPE character(10) USING infopeusumodcodane::character(10),
	ALTER COLUMN infopeduranei TYPE date USING infopeduranei::date,
	ALTER COLUMN infopeduranef TYPE date USING infopeduranef::date,
	ALTER COLUMN infopedursal TYPE date USING infopedursal::date,
	ALTER COLUMN infopedursali TYPE date USING infopedursali::date,
	ALTER COLUMN infopedursalf TYPE date USING infopedursalf::date,
	ALTER COLUMN infopeanedocidennum TYPE character(10) USING infopeanedocidennum::character(10),
	ALTER COLUMN infopeanetipdoc TYPE character(1) USING infopeanetipdoc::character(1),
	ALTER COLUMN infopehiniope TYPE date USING infopehiniope::date,
	ALTER COLUMN infopehfinope TYPE date USING infopehfinope::date,
	ALTER COLUMN infopehdurope TYPE date USING infopehdurope::date,
	ALTER COLUMN infopeanedesope TYPE character(2) USING infopeanedesope::character(2),
	ALTER COLUMN solopefec TYPE date USING solopefec::date,
	ALTER COLUMN solopeactmednum TYPE numeric(10,0) USING solopeactmednum::numeric(10,0),
	ALTER COLUMN solopebuspacsecnum TYPE numeric(10,0) USING solopebuspacsecnum::numeric(10,0);


	INSERT INTO {tabla} 
	(infopeoricenasicod,infopecenasicod,infopesolopenum,infopeinfane,infopedurane,infopeusucrecodane,infopecrefecane,infopemodfecane,infopeusumodcodane,infopeduranei,infopeduranef,infopedursal,infopedursali,infopedursalf,infopeanedocidennum,infopeanetipdoc,infopehiniope,infopehfinope,infopehdurope,infopeanedesope,solopefec,solopeactmednum,solopebuspacsecnum) 

	SELECT 
	infopeoricenasicod,infopecenasicod,infopesolopenum,infopeinfane,infopedurane,infopeusucrecodane,infopecrefecane,infopemodfecane,infopeusumodcodane,infopeduranei,infopeduranef,infopedursal,infopedursali,infopedursalf,infopeanedocidennum,infopeanetipdoc,infopehiniope,infopehfinope,infopehdurope,infopeanedesope,solopefec,solopeactmednum,solopebuspacsecnum

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




	# AYUDA PARA EXTRAER COLUMNAS Y ESTRUCTURA DE TABLAS (NO ES PARTE DEL ETL)




	cadena = """
		infopeoricenasicod character(1) COLLATE pg_catalog."default",
		infopecenasicod character(3) COLLATE pg_catalog."default",
		infopesolopenum numeric(10,0),
		infopeinfane numeric(2,0),
		infopedurane date,
		infopeusucrecodane character(10) COLLATE pg_catalog."default",
		infopecrefecane date,
		infopemodfecane date,
		infopeusumodcodane character(10) COLLATE pg_catalog."default",
		infopeduranei date,
		infopeduranef date,
		infopedursal date,
		infopedursali date,
		infopedursalf date,
		infopeanedocidennum character(10) COLLATE pg_catalog."default",
		infopeanetipdoc character(1) COLLATE pg_catalog."default",
		infopehiniope date,
		infopehfinope date,
		infopehdurope date,
		infopeanedesope character(2) COLLATE pg_catalog."default",
		solopefec date,
		solopeactmednum numeric(10,0),
		solopebuspacsecnum numeric(10,0)
	"""

	# Reemplaza los caracteres innecesarios
	cadena = cadena.replace(" COLLATE pg_catalog.\"default\",", "")
	cadena = cadena.replace(" with time zone", "")

	# Divide la cadena en una lista de líneas
	lineas = cadena.split("\n")

	# Crea la cadena de alteración de columnas
	cadena_alter = ""
	for i, linea in enumerate(lineas):
		palabras = linea.split()
		if len(palabras) >= 2:
			columna = palabras[0]
			tipo = palabras[1]
			if i == len(lineas) - 2:
				# Última línea, agrega punto y coma
				cadena_alter += f"ALTER COLUMN {columna} TYPE {tipo};\n"
			else:
				# Otras líneas, agrega coma
				cadena_alter += f"ALTER COLUMN {columna} TYPE {tipo},\n"

	# Utiliza una expresión regular para eliminar las comas duplicadas
	cadena_alter = re.sub(r',+$', ',', cadena_alter, flags=re.MULTILINE)




	nombrecitos = re.findall(r'ALTER COLUMN\s+(\S+)', cadena_alter)
	insertado_col = ",".join(nombrecitos)




	tabla='qtian10'
	col_tabla = 'infopecrefecane'
	essi='essi_dat_cqx003_etl'
	col_essi='fec_cre'






	base1 = base1.rename(columns={
		'infopeoricenasicod': 'ori_cas',
		'infopecenasicod': 'cod_cas',
		'infopesolopenum': 'sol_num',
		'infopeinfane': 'inf_ane',
		'infopedurane': 'dur_ane',
		'infopeusucrecodane': 'usu_cre',
		'infopecrefecane': 'fec_cre',
		'infopeusumodcodane': 'usu_mod',
		'infopemodfecane': 'fec_mod',
		'infopeduranei': 'dur_ane_ini',
		'infopeduranef': 'dur_ane_fin',
		'infopedursal': 'dur_sal',
		'infopedursali': 'dur_sal_ini',
		'infopedursalf': 'dur_sal_fin',
		'infopeanedocidennum': 'num_doc',
		'infopeanetipdoc': 'cod_tdi',
		'infopehiniope': 'hor_ini_ope',
		'infopehfinope': 'hor_fin_ope',
		'infopehdurope': 'dur_ope',
		'infopeanedesope': 'cod_des',
		'solopefec': 'sol_fec',
		'solopeactmednum': 'sol_act',
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

	cqxdesegrsop=pd.read_sql_query(f"SELECT des_cod,des_des FROM dim_cqxdesegrsop", con=connection2)
	cqxdesegrsop['des_cod']=cqxdesegrsop['des_cod'].str.strip()


	a=base1.copy()





	base1=pd.merge(base1,cas_red,how='left',on='cod_cas')
	base1=base1.drop("id_red", axis=1)
	base1.shape





	#des_des
	base1['cod_des']=base1['cod_des'].str.strip()
	base1=pd.merge(base1,cqxdesegrsop,how='left',left_on='cod_des',right_on='des_cod')
	base1 = base1.drop("des_cod", axis=1)
	base1.shape





	base2.columns


	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df2_columns - df1_columns
	different_columns


	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df1_columns - df2_columns
	different_columns


	comunes = set(base1.columns).intersection(set(base2.columns)) 
	base = base1[list(comunes)]





	borrado = f"DELETE FROM {essi} WHERE {col_essi} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_essi} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection1.execute(borrado)

	base.to_sql(name=f'{essi}', con=connection1, if_exists='append', index=False,chunksize=10000)



	tabla='qtian10'
	col_tabla = 'infopecrefecane'
	dat= "dat_ceqx003_essi"
	col_dat='fec_cre'
	essi='essi_dat_cqx003_etl'
	col_essi='fec_cre'




	cas = pd.read_sql_query(f"SELECT id_cas,cod_cas FROM dim_cas where id_cas is not null", con=connection2)
	cas = cas.drop_duplicates(subset=['cod_cas'])
	cas=cas.dropna()
	red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)

	oricas = pd.read_sql_query(f"SELECT id_oricas,ori_cod FROM dim_oricas", con=connection2)
	oricas["ori_cod"]=oricas["ori_cod"].str.strip()

	numdoc = pd.read_sql_query(f"SELECT id_person,num_doc FROM dim_personal", con=connection2)
	numdoc["num_doc"]=numdoc["num_doc"].str.strip()
	numdoc["num_doc"]=numdoc["num_doc"].str.replace(' ', '', regex=True)
	numdoc=numdoc.drop_duplicates(subset="num_doc")

	tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
	tipdoc["cod_tdo"]=tipdoc["cod_tdo"].str.strip()

	cqxdesegrsop=pd.read_sql_query(f"SELECT id_desegr,des_cod FROM dim_cqxdesegrsop", con=connection2)
	cqxdesegrsop['des_cod']=cqxdesegrsop['des_cod'].str.strip()

	tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)

	pacsec = pd.read_sql_query(f"SELECT id_pacsec,per_sec FROM dim_pacsec", con=connection2)



	base1=base
	# #INICIO DEL DAT


	base1.shape


	#Eliminamos las columnas que no se usarán aquí: las descripciones y otras 4 más, previa evaluación

	# Lista de columnas a eliminar
	columnas_eliminar = ['des_des','des_cas', 'des_red']

	# Eliminar las columnas
	base1 = base1.drop(columns=columnas_eliminar)





	base2=pd.read_sql_query(f"SELECT * FROM {dat} LIMIT 10", con=connection2)


	base1.shape


	control_a.append(base1.shape[0])


	oricas=oricas.rename(columns={"ori_cod":"ori_cas"})
	base1['ori_cas']=base1['ori_cas'].str.strip()
	base1["ori_cas"]=base1["ori_cas"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,oricas,how='left',on='ori_cas')
	base1=pd.merge(base1,oricas,how='left',on='ori_cas')
	base1.shape


	log_falla('id_oricas', 'ori_cas', True)
	log_control('dim_oricas')
	base1=base1.drop('ori_cas',axis=1)


	base1['cod_cas']=base1['cod_cas'].str.strip()
	base1["cod_cas"]=base1["cod_cas"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,cas,how='left',on='cod_cas')
	base1=pd.merge(base1,cas,how='left',on='cod_cas')
	base1.shape


	log_falla('id_cas', 'cod_cas', True)
	log_control('dim_cas')
	base1=base1.drop('cod_cas',axis=1)


	base1['cod_red']=base1['cod_red'].str.strip()
	base1["cod_red"]=base1["cod_red"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,red,how='left',on='cod_red')
	base1=pd.merge(base1,red,how='left',on='cod_red')
	base1.shape


	log_falla('id_red', 'cod_red', True)
	log_control('dim_red')
	base1=base1.drop('cod_red',axis=1)


	merge.shape


	numdoc=numdoc.rename(columns={"num_doc": "usu_mod","id_person": "id_usumod"})
	base1['usu_mod']=base1['usu_mod'].str.strip()
	base1["usu_mod"]=base1["usu_mod"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,numdoc,how='left',on='usu_mod')
	base1=pd.merge(base1,numdoc,how='left',on='usu_mod')
	base1.shape


	merge.shape #Se reduce mucho si es left


	log_falla('id_usumod', 'usu_mod', True)
	log_control('dim_personal')
	base1=base1.drop('usu_mod',axis=1)


	numdoc=numdoc.rename(columns={"usu_mod": "usu_cre","id_usumod": "id_usucre"})
	base1['usu_cre']=base1['usu_cre'].str.strip()
	base1["usu_cre"]=base1["usu_cre"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,numdoc,how='left',on='usu_cre')
	base1=pd.merge(base1,numdoc,how='left',on='usu_cre')
	base1.shape


	merge.shape #Puede ser left


	log_falla('id_usucre', 'usu_cre', True)
	log_control('dim_personal')
	base1=base1.drop('usu_cre',axis=1)


	numdoc=numdoc.rename(columns={"usu_cre": "num_doc","id_usucre": "id_numdoc"})
	base1['num_doc']=base1['num_doc'].str.strip()
	base1["num_doc"]=base1["num_doc"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,numdoc,how='left',on='num_doc')
	base1=pd.merge(base1,numdoc,how='left',on='num_doc')
	base1.shape


	merge.shape #Puede ser left


	log_falla('id_numdoc', 'num_doc', True)
	log_control('dim_personal')
	base1=base1.drop('num_doc',axis=1)


	tipdoc=tipdoc.rename(columns={"cod_tdo": "cod_tdi"})
	base1['cod_tdi']=base1['cod_tdi'].str.strip()
	base1["cod_tdi"]=base1["cod_tdi"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,tipdoc,how='left',on='cod_tdi')
	base1=pd.merge(base1,tipdoc,how='left',on='cod_tdi')
	base1.shape


	merge.shape #Puede ser left


	log_falla('id_tipdoc', 'cod_tdi', True)
	log_control('dim_tipdoc')
	base1=base1.drop('cod_tdi',axis=1)


	pacsec=pacsec.rename(columns={"per_sec": "pac_sec"})
	pacsec['pac_sec']=pacsec['pac_sec'].astype(str).str.strip()
	pacsec["pac_sec"]=pacsec["pac_sec"].str.replace(' ', '', regex=True)
	base1['pac_sec']=base1['pac_sec'].astype(str).str.strip()
	base1["pac_sec"]=base1["pac_sec"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,pacsec,how='left',on='pac_sec')
	base1=pd.merge(base1,pacsec,how='left',on='pac_sec')
	base1.shape


	merge.shape


	log_falla('id_pacsec', 'pac_sec', True)
	log_control('dim_pacsec')
	base1=base1.drop('pac_sec',axis=1)


	cqxdesegrsop=cqxdesegrsop.rename(columns={"des_cod": "cod_des","id_desegr": "id_desope"})
	base1['cod_des']=base1['cod_des'].str.strip()
	base1["cod_des"]=base1["cod_des"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,cqxdesegrsop,how='left',on='cod_des')
	base1=pd.merge(base1,cqxdesegrsop,how='left',on='cod_des')
	base1.shape


	merge.shape


	log_falla('id_desope', 'cod_des', True)
	base1=base1.drop('cod_des',axis=1)
	dim.append('dim_cqxdesegrsop')
	control_d.append(base1.shape[0])


	base1['sol_fec_temp'] = base1['sol_fec'].astype(str).str.split().str[0]
	tiempo=tiempo.rename(columns={"dt_fecha":"sol_fec_temp"})
	tiempo["sol_fec_temp"] = tiempo['sol_fec_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='left', on='sol_fec_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='sol_fec_temp')
	base1=base1.rename(columns={"id_tiempo":"id_time_sol","dt_ano":"id_ano_sol","dt_mes":"id_mes_sol",
								"dt_dia":"id_dia_sol","dt_dia_sem":"id_diasem_sol","dt_sem":"id_sem_sol"})
	base1=base1.drop("sol_fec_temp",axis=1)
	base1.shape



























	
	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df2_columns - df1_columns
	different_columns

	


	# 
	borrando=f"DELETE FROM {dat} WHERE {col_dat} >='{fecha_ini_str}' and {col_dat} <'{fecha_fin_str}'"
	borrado = connection2.execute(borrando)



	
	comunes = set(base1.columns).intersection(set(base2.columns)) 
	base = base1[list(comunes)]

	
	base.to_sql(name=f'{dat}', con=connection2, if_exists='append', index=False,chunksize=10000)

		

	
	proceso = "DAT"

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

	
	tabla_logs.to_sql(name=f'logs', con=connection4, if_exists='append', index=False,chunksize=10000)

	
	


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


