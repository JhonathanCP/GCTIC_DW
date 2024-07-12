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


	tabla='qtiop10'
	col_tabla = 'infopefec'


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
	d1.INFOPESECNUM,
	--INFOPEFEC,
	to_char(d1.INFOPEFEC, 'YYYY-MM-DD HH24:MI:SS') as INFOPEFEC,
	--d1.INFOPEINGSOPHOR,
	to_char(d1.INFOPEINGSOPHOR, 'YYYY-MM-DD HH24:MI:SS') as INFOPEINGSOPHOR,
	--d1.INFOPESOPTPO,
	to_char(d1.INFOPESOPTPO, 'YYYY-MM-DD HH24:MI:SS') as INFOPESOPTPO,
	--d1.INFOPEANETPO,
	to_char(d1.INFOPEANETPO, 'YYYY-MM-DD HH24:MI:SS') as INFOPEANETPO,
	--d1.INFOPEOPETPO,
	to_char(d1.INFOPEOPETPO, 'YYYY-MM-DD HH24:MI:SS') as INFOPEOPETPO,
	d1.INFOPEEXAPATFLG,
	d1.TIPHOPCOD,
	d1.INFOPEUSUCRECOD,
	--d1.INFOPECREFEC,
	to_char(d1.INFOPECREFEC, 'YYYY-MM-DD HH24:MI:SS') as INFOPECREFEC,
	INFOPEUSUMODCOD,
	--d1.INFOPEMODFEC,
	to_char(d1.INFOPEMODFEC, 'YYYY-MM-DD HH24:MI:SS') as INFOPEMODFEC,
	d1.DESESOCOD,
	d1.INFOPEACTMEDOPENUM,
	d1.INFOPEBTB,
	d1.INFOPENROGES,
	d1.INFOPENROPART,
	d1.INFOPECESAANTE,
	d1.INFOPETRABPART,
	d1.INFOPEEXPUL,
	d1.INFOPEDARES,

	a1.solopefec as solopefec,  
	a1.SOLOPEACTMEDNUM,
	a1.SOLOPEBUSPACSECNUM

	from {tabla} d1 
	left outer join qtsop10 a1 on a1.SOLOPEORICENASICOD = d1.INFOPEORICENASICOD
	and a1.SOLOPECENASICOD    = d1.INFOPECENASICOD
	and a1.SOLOPENUM    = d1.INFOPESOLOPENUM
	where d1.{col_tabla}>=TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and d1.{col_tabla}<TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD') 

	"""



	base1 = pd.read_sql_query(query0,con=connection0)


	connection0.close()


	base1.shape





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
	ALTER COLUMN infopesecnum TYPE numeric(2,0) USING infopesecnum::numeric(2,0),
	ALTER COLUMN infopefec TYPE date USING infopefec::date,
	ALTER COLUMN infopeingsophor TYPE timestamp USING infopeingsophor::timestamp without time zone,
	ALTER COLUMN infopesoptpo TYPE timestamp USING infopesoptpo::timestamp without time zone,
	ALTER COLUMN infopeanetpo TYPE timestamp USING infopeanetpo::timestamp without time zone,
	ALTER COLUMN infopeopetpo TYPE timestamp USING infopeopetpo::timestamp without time zone,
	ALTER COLUMN infopeexapatflg TYPE character(1) USING infopeexapatflg::character(1),
	ALTER COLUMN tiphopcod TYPE character(1) USING tiphopcod::character(1),
	ALTER COLUMN infopeusucrecod TYPE character(10) USING infopeusucrecod::character(10),
	ALTER COLUMN infopecrefec TYPE timestamp USING infopecrefec::timestamp without time zone,
	ALTER COLUMN infopeusumodcod TYPE character(10) USING infopeusumodcod::character(10),
	ALTER COLUMN infopemodfec TYPE timestamp USING infopemodfec::timestamp without time zone,
	ALTER COLUMN desesocod TYPE character(2) USING desesocod::character(2),
	ALTER COLUMN infopeactmedopenum TYPE numeric(10,0) USING infopeactmedopenum::numeric(10,0),
	ALTER COLUMN infopebtb TYPE numeric(1,0) USING infopebtb::numeric(1,0),
	ALTER COLUMN infopenroges TYPE numeric(2,0) USING infopenroges::numeric(2,0),
	ALTER COLUMN infopenropart TYPE numeric(2,0) USING infopenropart::numeric(2,0),
	ALTER COLUMN infopecesaante TYPE character(2) USING infopecesaante::character(2),
	ALTER COLUMN infopetrabpart TYPE numeric(1,0) USING infopetrabpart::numeric(1,0),
	ALTER COLUMN infopeexpul TYPE numeric(1,0) USING infopeexpul::numeric(1,0),
	ALTER COLUMN infopedares TYPE numeric(1,0) USING infopedares::numeric(1,0),
	ALTER COLUMN solopefec TYPE date USING solopefec::date,
	ALTER COLUMN solopeactmednum TYPE numeric(10,0) USING solopeactmednum::numeric(10,0),
	ALTER COLUMN solopebuspacsecnum TYPE numeric(10,0) USING solopebuspacsecnum::numeric(10,0);



	INSERT INTO {tabla} 
	(infopeoricenasicod,infopecenasicod,infopesolopenum,infopesecnum,infopefec,infopeingsophor,infopesoptpo,infopeanetpo,infopeopetpo,infopeexapatflg,tiphopcod,infopeusucrecod,infopecrefec,infopeusumodcod,infopemodfec,desesocod,infopeactmedopenum,infopebtb,infopenroges,infopenropart,infopecesaante,infopetrabpart,infopeexpul,infopedares,solopefec,solopeactmednum,solopebuspacsecnum) 

	SELECT 
	infopeoricenasicod,infopecenasicod,infopesolopenum,infopesecnum,infopefec,infopeingsophor,infopesoptpo,infopeanetpo,infopeopetpo,infopeexapatflg,tiphopcod,infopeusucrecod,infopecrefec,infopeusumodcod,infopemodfec,desesocod,infopeactmedopenum,infopebtb,infopenroges,infopenropart,infopecesaante,infopetrabpart,infopeexpul,infopedares,solopefec,solopeactmednum,solopebuspacsecnum

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


	import re

	cadena = """
		infopeoricenasicod character(1) COLLATE pg_catalog."default",
		infopecenasicod character(3) COLLATE pg_catalog."default",
		infopesolopenum numeric(10,0),
		infopesecnum numeric(2,0),
		infopefec date,
		infopeingsophor timestamp with time zone,
		infopesoptpo timestamp with time zone,
		infopeanetpo timestamp with time zone,
		infopeopetpo timestamp with time zone,
		infopeexapatflg character(1) COLLATE pg_catalog."default",
		tiphopcod character(1) COLLATE pg_catalog."default",
		infopeusucrecod character(10) COLLATE pg_catalog."default",
		infopecrefec timestamp with time zone,
		infopeusumodcod character(10) COLLATE pg_catalog."default",
		infopemodfec timestamp with time zone,
		desesocod character(2) COLLATE pg_catalog."default",
		infopeactmedopenum numeric(10,0),
		infopebtb numeric(1,0),
		infopenroges numeric(2,0),
		infopenropart numeric(2,0),
		infopecesaante character(2) COLLATE pg_catalog."default",
		infopetrabpart numeric(1,0),
		infopeexpul numeric(1,0),
		infopedares numeric(1,0),
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



	import re

	nombrecitos = re.findall(r'ALTER COLUMN\s+(\S+)', cadena_alter)
	insertado_col = ",".join(nombrecitos)




	tabla='qtiop10'
	col_tabla = "infopefec"
	dat= "dat_ceqx002_essi"
	col_essi='fec_ope'
	essi='essi_dat_cqx002_etl'















	base1 = base1.rename(columns={
		'infopeoricenasicod': 'ori_cas',
		'infopecenasicod': 'cod_cas',
		'infopesolopenum': 'num_sol',
		'infopesecnum': 'num_sec',
		'infopefec': 'fec_ope',
		'infopeingsophor': 'hor_ing_sop',
		'infopesoptpo': 'tie_uso_sop',
		'infopeanetpo': 'tie_ane',
		'infopeopetpo': 'tie_ope',
		'infopeexapatflg': 'res_pat',
		'tiphopcod': 'her_ope',
		'infopeusucrecod': 'usu_cre',
		'infopecrefec': 'fec_cre',
		'infopeusumodcod': 'usu_mod',
		'infopemodfec': 'fec_mod',
		'desesocod': 'cod_des',
		'infopeactmedopenum': 'act_med',
		'infopebtb': 'inf_peb',
		'infopenroges': 'inf_rog',
		'infopenropart': 'inf_per',
		'infopecesaante': 'inf_ces',
		'infopetrabpart': 'inf_tra',
		'infopeexpul': 'inf_exp',
		'infopedares': 'inf_are',
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

	cqxrespat=pd.read_sql_query(f"SELECT cod_res,des_res FROM dim_cqxrespat", con=connection2)
	cqxrespat['cod_res']=cqxrespat['cod_res'].str.strip()

	cqxtipher=pd.read_sql_query(f"SELECT cod_the,des_the FROM dim_cqxtipher", con=connection2)
	cqxtipher['cod_the']=cqxtipher['cod_the'].str.strip()

	cqxdesegrsop=pd.read_sql_query(f"SELECT des_cod,des_des FROM dim_cqxdesegrsop", con=connection2)
	cqxdesegrsop['des_cod']=cqxdesegrsop['des_cod'].str.strip()


	a=base1.copy()


	base1=a





	base1=pd.merge(base1,cas_red,how='left',on='cod_cas')
	base1=base1.drop("id_red", axis=1)
	base1.shape





	#des_res
	base1['res_pat']=base1['res_pat'].str.strip()
	base1=pd.merge(base1,cqxrespat,how='left',left_on='res_pat',right_on='cod_res')
	base1 = base1.drop("cod_res", axis=1)
	base1.shape


	#des_her
	base1['her_ope']=base1['her_ope'].str.strip()
	base1=pd.merge(base1,cqxtipher,how='left',left_on='her_ope',right_on='cod_the')
	base1=base1.rename(columns={"des_the":"des_her"})
	base1 = base1.drop("cod_the", axis=1)
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







	tabla='qtiop10'
	col_tabla = "infopefec"
	dat= "dat_ceqx002_essi"
	col_essi='fec_ope'
	col_dat='fec_ope'
	essi='essi_dat_cqx002_etl'






	cas = pd.read_sql_query(f"SELECT id_cas,cod_cas FROM dim_cas where id_cas is not null", con=connection2)
	cas = cas.drop_duplicates(subset=['cod_cas'])
	cas=cas.dropna()
	red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)

	oricas = pd.read_sql_query(f"SELECT id_oricas,ori_cod FROM dim_oricas", con=connection2)
	oricas["ori_cod"]=oricas["ori_cod"].str.strip()

	tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)

	cqxrespat=pd.read_sql_query(f"SELECT id_respat,cod_res FROM dim_cqxrespat", con=connection2)
	cqxrespat['cod_res']=cqxrespat['cod_res'].str.strip()

	cqxtipher=pd.read_sql_query(f"SELECT id_tipher,cod_the FROM dim_cqxtipher", con=connection2)
	cqxtipher['cod_the']=cqxtipher['cod_the'].str.strip()

	cqxdesegrsop=pd.read_sql_query(f"SELECT id_desegr,des_cod FROM dim_cqxdesegrsop", con=connection2)
	cqxdesegrsop['des_cod']=cqxdesegrsop['des_cod'].str.strip()

	numdoc = pd.read_sql_query(f"SELECT id_person,num_doc FROM dim_personal", con=connection2)
	numdoc["num_doc"]=numdoc["num_doc"].str.strip()
	numdoc["num_doc"]=numdoc["num_doc"].str.replace(' ', '', regex=True)
	numdoc=numdoc.drop_duplicates(subset="num_doc")



	base1=base


	# #INICIO DEL DAT


	base1.shape


	#Eliminamos las columnas que no se usarán aquí: las descripciones y otras 4 más, previa evaluación

	# Lista de columnas a eliminar
	columnas_eliminar = ['des_cas', 'des_des', 'des_her', 'des_red', 'des_res']

	# Eliminar las columnas
	base1 = base1.drop(columns=columnas_eliminar)


	base1.shape



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


	numdoc=numdoc.rename(columns={"num_doc": "usu_mod","id_person": "id_usumod"})
	base1['usu_mod']=base1['usu_mod'].str.strip()
	base1["usu_mod"]=base1["usu_mod"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,numdoc,how='left',on='usu_mod')
	base1=pd.merge(base1,numdoc,how='left',on='usu_mod')
	base1.shape


	merge.shape #Se pierden datos


	log_falla('id_usumod', 'usu_mod', True)
	log_control('dim_personal')
	base1=base1.drop('usu_mod',axis=1)


	numdoc=numdoc.rename(columns={"usu_mod": "usu_cre","id_usumod": "id_usucred"})
	base1['usu_cre']=base1['usu_cre'].str.strip()
	base1["usu_cre"]=base1["usu_cre"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,numdoc,how='left',on='usu_cre')
	base1=pd.merge(base1,numdoc,how='left',on='usu_cre') 
	base1.shape


	merge.shape #Se pierden muy pocos datos


	log_falla('id_usucred', 'usu_cre', True)
	log_control('dim_personal')
	base1=base1.drop('usu_cre',axis=1)


	cqxrespat=cqxrespat.rename(columns={"cod_res": "res_pat"})
	base1['res_pat']=base1['res_pat'].str.strip()
	base1["res_pat"]=base1["res_pat"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,cqxrespat,how='left',on='res_pat')
	base1=pd.merge(base1,cqxrespat,how='left',on='res_pat')
	base1.shape


	merge.shape


	log_falla('id_respat', 'res_pat', True)
	log_control('dim_cqxrespat')
	base1=base1.drop('res_pat',axis=1)


	cqxtipher=cqxtipher.rename(columns={"cod_the": "her_ope","id_tipher": "id_herope"})
	base1['her_ope']=base1['her_ope'].str.strip()
	base1["her_ope"]=base1["her_ope"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,cqxtipher,how='left',on='her_ope')
	base1=pd.merge(base1,cqxtipher,how='left',on='her_ope')
	base1.shape


	merge.shape



	log_falla('id_herope', 'her_ope', True)
	log_control('dim_cqxtipher')
	base1=base1.drop('her_ope',axis=1)


	cqxdesegrsop=cqxdesegrsop.rename(columns={"des_cod": "cod_des","id_desegr": "id_dessop"})
	base1['cod_des']=base1['cod_des'].str.strip()
	base1["cod_des"]=base1["cod_des"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,cqxdesegrsop,how='left',on='cod_des')
	base1=pd.merge(base1,cqxdesegrsop,how='left',on='cod_des')
	base1.shape


	merge.shape


	log_falla('id_dessop', 'cod_des', True)
	base1=base1.drop('cod_des',axis=1)
	dim.append('dim_cqxdesegrsop')
	control_d.append(base1.shape[0])


	base1['fec_ope_temp'] = base1['fec_ope'].astype(str).str.split().str[0]
	tiempo=tiempo.rename(columns={"dt_fecha":"fec_ope_temp"})
	tiempo["fec_ope_temp"] = tiempo['fec_ope_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='left', on='fec_ope_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='fec_ope_temp')
	base1=base1.rename(columns={"id_tiempo":"id_time_ope","dt_ano":"ano_ope","dt_mes":"mes_ope",
								"dt_dia":"dia_ope","dt_dia_sem":"dia_sem_ope","dt_sem":"sem_ope"})
	base1=base1.drop("fec_ope_temp",axis=1)
	base1.shape


	tiempo


	base1['fec_cre_temp'] = base1['fec_cre'].astype(str).str.split().str[0]
	tiempo=tiempo.rename(columns={"fec_ope_temp":"fec_cre_temp"})
	tiempo["fec_cre_temp"] = tiempo['fec_cre_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='left', on='fec_cre_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='fec_cre_temp')
	base1=base1.rename(columns={"id_tiempo":"id_time_cre","dt_ano":"ano_cre","dt_mes":"mes_cre",
								"dt_dia":"dia_cre","dt_dia_sem":"dia_sem_cre","dt_sem":"sem_cre"})
	base1=base1.drop("fec_cre_temp",axis=1)
	base1.shape


	base1['fec_mod_temp'] = base1['fec_mod'].astype(str).str.split().str[0]
	tiempo=tiempo.rename(columns={"fec_cre_temp":"fec_mod_temp"})
	tiempo["fec_mod_temp"] = tiempo['fec_mod_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='left', on='fec_mod_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='fec_mod_temp')
	base1=base1.rename(columns={"id_tiempo":"id_time_mod","dt_ano":"ano_mod","dt_mes":"mes_mod",
								"dt_dia":"dia_mod","dt_dia_sem":"dia_sem_mod","dt_sem":"sem_mod"})
	base1=base1.drop("fec_mod_temp",axis=1)
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


