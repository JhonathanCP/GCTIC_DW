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



	
	tabla='qtsop10'
	col_tabla = "solopefec"




	
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

	query = f"SELECT * FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') AND {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	base2 = pd.read_sql_query(query, con=connection0)

	connection0.close()

	
	base2.head()

	
	



	
	base2.to_sql(name=f'tmp_{tabla}', con=engine3, if_exists='replace', index=False)

	
	#CREAMOS LA TABLA TEMPORAL Y LA SUBIMOS AL POSTGRES SQL


	
	#Borramos en caso el ETL se ejecute una segunda vez
	borrado = f"DELETE FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection3.execute(borrado)

	
	query=f"""

	ALTER TABLE tmp_{tabla} 
	ALTER COLUMN solopeoricenasicod TYPE character(1),
	ALTER COLUMN solopecenasicod TYPE character(3),
	ALTER COLUMN solopenum TYPE numeric(10,0) USING solopenum::numeric(10,0),
	ALTER COLUMN solopefec TYPE date USING solopefec::date, 
	ALTER COLUMN solopeactmednum TYPE numeric(10,0) USING solopeactmednum::numeric(10,0),
	ALTER COLUMN solopemedtipdocidenpercod TYPE character(1),
	ALTER COLUMN solopemedperasisdocidennum TYPE character(10),
	ALTER COLUMN solopesolfec TYPE date USING solopesolfec::date,
	ALTER COLUMN solopeprofec TYPE date USING solopeprofec::date,
	ALTER COLUMN solopeprohor TYPE timestamp USING solopeprohor::timestamp without time zone,
	ALTER COLUMN estfiscod TYPE character(1),
	ALTER COLUMN estsopcod TYPE character(1),
	ALTER COLUMN solopeestregcod TYPE character(1),
	ALTER COLUMN solopeusucrecod TYPE character(10),
	ALTER COLUMN solopecrefec TYPE timestamp USING solopecrefec::timestamp without time zone,
	ALTER COLUMN solopeusumodcod TYPE character(10),
	ALTER COLUMN solopemodfec TYPE timestamp USING solopemodfec::timestamp without time zone,
	ALTER COLUMN solopecenquicod TYPE character(2),
	ALTER COLUMN solopesalopecod TYPE character(2),
	ALTER COLUMN solopeesttpo TYPE timestamp USING solopeesttpo::timestamp without time zone,
	ALTER COLUMN solopearehoscod TYPE character(2),
	ALTER COLUMN solopeservhoscod TYPE character(3),
	ALTER COLUMN solopeordnum TYPE numeric(2,0) USING solopeordnum::numeric(2,0),
	ALTER COLUMN solopeemecod TYPE character(2),
	ALTER COLUMN solopesolarehoscod TYPE character(2),
	ALTER COLUMN solopesolservhoscod TYPE character(3),
	ALTER COLUMN conopecod TYPE character(1),
	ALTER COLUMN solopeactmedopenum TYPE numeric(10,0) USING solopeactmedopenum::numeric(10,0),
	ALTER COLUMN priopecod TYPE character(1),
	ALTER COLUMN riequicod TYPE character(1),
	ALTER COLUMN solopediashosprecan TYPE numeric(2,0) USING solopediashosprecan::numeric(2,0),
	ALTER COLUMN solopediashosposcan TYPE numeric(2,0) USING solopediashosposcan::numeric(2,0),
	ALTER COLUMN motsopcod TYPE character(2),
	ALTER COLUMN solopetipanecod TYPE character(1),
	ALTER COLUMN soloperesexalabflg TYPE character(1),
	ALTER COLUMN soloperiequiflg TYPE character(1),
	ALTER COLUMN soloperieneuflg TYPE character(1),
	ALTER COLUMN solopeconinfflg TYPE character(1),
	ALTER COLUMN solopeordtraflg TYPE character(1),
	ALTER COLUMN solopeevalpqxflg TYPE character(1),
	ALTER COLUMN solopeevalpqxfec TYPE date USING solopeevalpqxfec::date,
	ALTER COLUMN solopeevalpqxoricenasicod TYPE character(1),
	ALTER COLUMN solopeevalpqxcenasicod TYPE character(3),
	ALTER COLUMN solopeevalpqxactmednum TYPE numeric(10,0) USING solopeevalpqxactmednum::numeric(10,0),
	ALTER COLUMN solopetopemecod TYPE character(2),
	ALTER COLUMN solopeatesecnum TYPE numeric(4,0) USING solopeatesecnum::numeric(4,0),
	ALTER COLUMN solopebuspacsecnum TYPE numeric(10,0) 	USING solopebuspacsecnum::numeric(10,0),
	ALTER COLUMN solopesolexafec TYPE date USING solopesolexafec::date,
	ALTER COLUMN soloperesexalabfec TYPE date USING soloperesexalabfec::date,
	ALTER COLUMN soloperiequifec TYPE date USING soloperiequifec::date,
	ALTER COLUMN soloperieneufec TYPE date USING soloperieneufec::date,
	ALTER COLUMN solopeevalpqxmedtipdoc TYPE character(1),
	ALTER COLUMN solopeevalpqxmeddocnum TYPE character(15),
	ALTER COLUMN solopediashospreflg TYPE character(1),
	ALTER COLUMN solopediashosposflg TYPE character(1),
	ALTER COLUMN solopereqprotflg TYPE character(1);

	INSERT INTO {tabla} 
	(solopeoricenasicod,solopecenasicod,solopenum,solopefec,solopeactmednum,solopemedtipdocidenpercod,solopemedperasisdocidennum,solopesolfec,solopeprofec,solopeprohor,estfiscod,estsopcod,solopeestregcod,solopeusucrecod,solopecrefec,solopeusumodcod,solopemodfec,solopecenquicod,solopesalopecod,solopeesttpo,solopearehoscod,solopeservhoscod,solopeordnum,solopeemecod,solopesolarehoscod,solopesolservhoscod,conopecod,solopeactmedopenum,priopecod,riequicod,solopediashosprecan,solopediashosposcan,motsopcod,solopetipanecod,soloperesexalabflg,soloperiequiflg,soloperieneuflg,solopeconinfflg,solopeordtraflg,solopeevalpqxflg,solopeevalpqxfec,solopeevalpqxoricenasicod,solopeevalpqxcenasicod,solopeevalpqxactmednum,solopetopemecod,solopeatesecnum,solopebuspacsecnum,solopesolexafec,soloperesexalabfec,soloperiequifec,soloperieneufec,solopeevalpqxmedtipdoc,solopeevalpqxmeddocnum,solopediashospreflg,solopediashosposflg,solopereqprotflg) 

	SELECT 
	solopeoricenasicod,solopecenasicod,solopenum,solopefec,solopeactmednum,solopemedtipdocidenpercod,solopemedperasisdocidennum,solopesolfec,solopeprofec,solopeprohor,estfiscod,estsopcod,solopeestregcod,solopeusucrecod,solopecrefec,solopeusumodcod,solopemodfec,solopecenquicod,solopesalopecod,solopeesttpo,solopearehoscod,solopeservhoscod,solopeordnum,solopeemecod,solopesolarehoscod,solopesolservhoscod,conopecod,solopeactmedopenum,priopecod,riequicod,solopediashosprecan,solopediashosposcan,motsopcod,solopetipanecod,soloperesexalabflg,soloperiequiflg,soloperieneuflg,solopeconinfflg,solopeordtraflg,solopeevalpqxflg,solopeevalpqxfec,solopeevalpqxoricenasicod,solopeevalpqxcenasicod,solopeevalpqxactmednum,solopetopemecod,solopeatesecnum,solopebuspacsecnum,solopesolexafec,soloperesexalabfec,soloperiequifec,soloperieneufec,solopeevalpqxmedtipdoc,solopeevalpqxmeddocnum,solopediashospreflg,solopediashosposflg,solopereqprotflg



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
		solopeoricenasicod character(1) COLLATE pg_catalog."default",
		solopecenasicod character(3) COLLATE pg_catalog."default",
		solopenum numeric(10,0),
		solopefec date,
		solopeactmednum numeric(10,0),
		solopemedtipdocidenpercod character(1) COLLATE pg_catalog."default",
		solopemedperasisdocidennum character(10) COLLATE pg_catalog."default",
		solopesolfec date,
		solopeprofec date,
		solopeprohor timestamp with time zone,
		estfiscod character(1) COLLATE pg_catalog."default",
		estsopcod character(1) COLLATE pg_catalog."default",
		solopeestregcod character(1) COLLATE pg_catalog."default",
		solopeusucrecod character(10) COLLATE pg_catalog."default",
		solopecrefec timestamp with time zone,
		solopeusumodcod character(10) COLLATE pg_catalog."default",
		solopemodfec timestamp with time zone,
		solopecenquicod character(2) COLLATE pg_catalog."default",
		solopesalopecod character(2) COLLATE pg_catalog."default",
		solopeesttpo timestamp with time zone,
		solopearehoscod character(2) COLLATE pg_catalog."default",
		solopeservhoscod character(3) COLLATE pg_catalog."default",
		solopeordnum numeric(2,0),
		solopeemecod character(2) COLLATE pg_catalog."default",
		solopesolarehoscod character(2) COLLATE pg_catalog."default",
		solopesolservhoscod character(3) COLLATE pg_catalog."default",
		conopecod character(1) COLLATE pg_catalog."default",
		solopeactmedopenum numeric(10,0),
		priopecod character(1) COLLATE pg_catalog."default",
		riequicod character(1) COLLATE pg_catalog."default",
		solopediashosprecan numeric(2,0),
		solopediashosposcan numeric(2,0),
		motsopcod character(2) COLLATE pg_catalog."default",
		solopetipanecod character(1) COLLATE pg_catalog."default",
		soloperesexalabflg character(1) COLLATE pg_catalog."default",
		soloperiequiflg character(1) COLLATE pg_catalog."default",
		soloperieneuflg character(1) COLLATE pg_catalog."default",
		solopeconinfflg character(1) COLLATE pg_catalog."default",
		solopeordtraflg character(1) COLLATE pg_catalog."default",
		solopeevalpqxflg character(1) COLLATE pg_catalog."default",
		solopeevalpqxfec date,
		solopeevalpqxoricenasicod character(1) COLLATE pg_catalog."default",
		solopeevalpqxcenasicod character(3) COLLATE pg_catalog."default",
		solopeevalpqxactmednum numeric(10,0),
		solopetopemecod character(2) COLLATE pg_catalog."default",
		solopeatesecnum numeric(4,0),
		solopebuspacsecnum numeric(10,0),
		solopesolexafec date,
		soloperesexalabfec date,
		soloperiequifec date,
		soloperieneufec date,
		solopeevalpqxmedtipdoc character(1) COLLATE pg_catalog."default",
		solopeevalpqxmeddocnum character(15) COLLATE pg_catalog."default",
		solopediashospreflg character(1) COLLATE pg_catalog."default",
		solopediashosposflg character(1) COLLATE pg_catalog."default",
		solopereqprotflg character(1) COLLATE pg_catalog."default"
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



	
	tabla='qtsop10'
	col_tabla = "solopefec"
	dat= "dat_ceqx001_essi"
	col_essi='fec_sol'
	essi='essi_dat_cqx001_etl'


	#PARA QUE CONTINUE EL ESSI
	base1=base2
	
	
	base1 = base1.rename(columns={
		'solopeoricenasicod': 'ori_cas',
		'solopecenasicod': 'cod_cas',
		'solopenum': 'num_sol',
		'solopefec': 'fec_sol',
		'solopeactmednum': 'act_med',
		'solopemedtipdocidenpercod': 'cod_tdi',
		'solopemedperasisdocidennum': 'num_doc',
		'solopesolfec': 'fec_sop',
		'solopeprofec': 'fec_pro',
		'solopeprohor': 'hor_pro',
		'estfiscod': 'est_fis',
		'estsopcod': 'est_sop',
		'solopeestregcod': 'est_reg',
		'solopeusucrecod': 'usu_cre',
		'solopecrefec': 'fec_cre',
		'solopeusumodcod': 'usu_mod',
		'solopemodfec': 'fec_mod',
		'solopecenquicod': 'cod_cqx',
		'solopesalopecod': 'cod_sal',
		'solopeesttpo': 'est_ocu',
		'solopearehoscod': 'cod_are',
		'solopeservhoscod': 'cod_ser',
		'solopeordnum': 'ord_ope',
		'solopeemecod': 'eme_sol',
		'solopesolarehoscod': 'are_sol',
		'solopesolservhoscod': 'ser_sol',
		'conopecod': 'tip_ope',
		'solopeactmedopenum': 'act_med_ope',
		'priopecod': 'pri_ope',
		'riequicod': 'rie_qx',
		'solopediashosprecan': 'dia_hos_pre',
		'solopediashosposcan': 'dia_hos_pos',
		'motsopcod': 'mot_sus',
		'solopetipanecod': 'tip_ane',
		'soloperesexalabflg': 'res_lab',
		'soloperiequiflg': 'res_rie_qx',
		'soloperieneuflg': 'res_rie_neu',
		'solopeconinfflg': 'con_inf',
		'solopeordtraflg': 'ord_tra',
		'solopeevalpqxflg': 'res_eva',
		'solopeevalpqxfec': 'fec_eva',
		'solopeevalpqxoricenasicod': 'ori_cas_eva',
		'solopeevalpqxcenasicod': 'cod_cas_eva',
		'solopeevalpqxactmednum': 'act_med_eva',
		'solopeatesecnum': 'num_sec',
		'solopebuspacsecnum': 'pac_sec',
		'solopesolexafec': 'fec_sol_exa',
		'soloperesexalabfec': 'fec_res_exa',
		'soloperiequifec': 'fec_rie_car',
		'soloperieneufec': 'fec_rie_neu',
		'solopeevalpqxmedtipdoc': 'eva_tip_doc',
		'solopeevalpqxmeddocnum': 'eva_num_doc',
		'solopediashospreflg': 'sdp_hos_pre',
		'solopediashosposflg': 'sdp_hos_pos',
		'solopereqprotflg': 'req_pro_flg',
		'solopetopemecod': 'ser_eme_sol'
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

	cqxestfis= pd.read_sql_query(f"SELECT cod_efi,des_efi FROM dim_cqxestfis", con=connection2)
	cqxestfis['cod_efi']=cqxestfis['cod_efi'].str.strip()

	cqxestsolope= pd.read_sql_query(f"SELECT cod_eso,des_eso FROM dim_cqxestsolope", con=connection2)
	cqxestsolope['cod_eso']=cqxestsolope['cod_eso'].str.strip()

	cqxestreg= pd.read_sql_query(f"SELECT cod_est,des_est FROM dim_cqxestreg", con=connection2)
	cqxestreg['cod_est']=cqxestreg['cod_est'].str.strip()

	cqxcenqx= pd.read_sql_query(f"SELECT ori_cas,cod_cas,cod_cqx,des_cqx FROM dim_cqxcenqx", con=connection2)
	cqxcenqx['cod_cqx']=cqxcenqx['cod_cqx'].str.strip()
	cqxcenqx['cod_cas']=cqxcenqx['cod_cas'].str.strip()

	cqxsalas= pd.read_sql_query(f"SELECT cod_ori,cod_cas,cod_cqx,cod_sal,des_sal FROM dim_cqxsalas", con=connection2)
	cqxsalas['cod_sal']=cqxsalas['cod_sal'].str.strip()

	areas = pd.read_sql_query(f"SELECT cod_are,des_are FROM dim_areas", con=connection2)
	areas['cod_are']=areas['cod_are'].str.strip()

	servicios = pd.read_sql_query(f"SELECT cod_ser,des_ser FROM dim_servicios", con=connection2)
	servicios['cod_ser']=servicios['cod_ser'].str.strip()

	emecod= pd.read_sql_query(f"SELECT cod_eme,des_eme FROM dim_emecod", con=connection2)
	emecod['cod_eme']=emecod['cod_eme'].str.strip()

	cqxtipope= pd.read_sql_query(f"SELECT cod_ope,des_ope FROM dim_cqxtipope", con=connection2)
	cqxtipope['cod_ope']=cqxtipope['cod_ope'].str.strip()

	cqxrieqx= pd.read_sql_query(f"SELECT cod_rqx,des_rqx FROM dim_cqxrieqx", con=connection2)
	cqxrieqx['cod_rqx']=cqxrieqx['cod_rqx'].str.strip()

	cqxmotsus= pd.read_sql_query(f"SELECT cod_msu,des_msu FROM dim_cqxmotsus", con=connection2)
	cqxmotsus['cod_msu']=cqxmotsus['cod_msu'].str.strip()

	cqxaneste= pd.read_sql_query(f"SELECT cod_ane,des_ane FROM dim_cqxaneste", con=connection2)
	cqxaneste['cod_ane']=cqxaneste['cod_ane'].str.strip()

	cqxmopreslab= pd.read_sql_query(f"SELECT cod_res,des_lab FROM dim_cqxmopreslab", con=connection2)
	cqxmopreslab['cod_res']=cqxmopreslab['cod_res'].str.strip()

	cqxmoprieqx= pd.read_sql_query(f"SELECT cod_rie,des_rie FROM dim_cqxmoprieqx", con=connection2)
	cqxmoprieqx['cod_rie']=cqxmoprieqx['cod_rie'].str.strip()

	cqxmoprieneu= pd.read_sql_query(f"SELECT cod_rieneu,des_rieneu FROM dim_cqxmoprieneu", con=connection2)
	cqxmoprieneu['cod_rieneu']=cqxmoprieneu['cod_rieneu'].str.strip()

	cqxmopconinf= pd.read_sql_query(f"SELECT cod_coninf,des_coninf FROM dim_cqxmopconinf", con=connection2)
	cqxmopconinf['cod_coninf']=cqxmopconinf['cod_coninf'].str.strip()

	cqxmopordtra= pd.read_sql_query(f"SELECT cod_ordtra,des_ordtra FROM dim_cqxmopordtra", con=connection2)
	cqxmopordtra['cod_ordtra']=cqxmopordtra['cod_ordtra'].str.strip()

	cqxresevapreqx= pd.read_sql_query(f"SELECT cod_reseva,des_reseva FROM dim_cqxresevapreqx", con=connection2)
	cqxresevapreqx['cod_reseva']=cqxresevapreqx['cod_reseva'].str.strip()

	
	a=base1.copy()

	
	# base1=a

	
	base1=pd.merge(base1,cas_red,how='left',on='cod_cas')
	base1=base1.drop("id_red", axis=1)
	base1.shape

	
	base1['est_fis']=base1['est_fis'].str.strip()
	base1=pd.merge(base1,cqxestfis,how='left',left_on='est_fis',right_on='cod_efi')
	base1=base1.rename(columns={"des_efi":"des_fis"})
	base1 = base1.drop("cod_efi", axis=1)
	base1.shape

	
	base1['est_sop']=base1['est_sop'].str.strip()
	base1=pd.merge(base1,cqxestsolope,how='left',left_on='est_sop',right_on='cod_eso')
	base1=base1.rename(columns={"des_eso":"des_sop"})
	base1 = base1.drop("cod_eso", axis=1)
	base1.shape

	
	base1['est_reg']=base1['est_reg'].str.strip()
	base1=pd.merge(base1,cqxestreg,how='left',left_on='est_reg',right_on='cod_est')
	base1=base1.rename(columns={"des_est":"des_reg"})
	base1 = base1.drop("cod_est", axis=1)
	base1.shape

	
	cqxcenqx["KEY"]=cqxcenqx["ori_cas"].str.strip()+cqxcenqx["cod_cas"].str.strip()+cqxcenqx["cod_cqx"].str.strip()
	cqxcenqx=cqxcenqx.drop(["ori_cas",'cod_cas','cod_cqx'], axis=1)
	base1["KEY"]=base1["ori_cas"].str.strip()+base1["cod_cas"].astype(str).str.strip()+base1['cod_cqx'].astype(str).str.strip()
	base1['cod_sal']=base1['cod_sal'].str.strip()
	base1=pd.merge(base1,cqxcenqx,how='left',on='KEY')
	base1 = base1.drop("KEY", axis=1)
	cqxcenqx = cqxcenqx.drop("KEY", axis=1)
	base1.shape

	
	

	
	cqxsalas["KEY"]=cqxsalas["cod_ori"].str.strip()+cqxsalas["cod_cas"].str.strip()+cqxsalas["cod_cqx"].str.strip()+cqxsalas["cod_sal"].str.strip()
	cqxsalas=cqxsalas.drop(["cod_ori",'cod_cas','cod_cqx','cod_sal'], axis=1)
	base1["KEY"]=base1["ori_cas"].str.strip()+base1["cod_cas"].astype(str).str.strip()+base1['cod_cqx'].astype(str).str.strip()+base1["cod_sal"].str.strip()
	base1=pd.merge(base1,cqxsalas,how='left',on='KEY')
	base1 = base1.drop("KEY", axis=1)
	cqxsalas = cqxsalas.drop("KEY", axis=1)
	base1.shape

	
	

	
	base1=pd.merge(base1,areas,how='left',on='cod_are')
	base1.shape

	
	base1=pd.merge(base1,servicios,how='left',on='cod_ser')
	base1.shape

	
	

	
	base1['eme_sol']=base1['eme_sol'].str.strip()
	base1=pd.merge(base1,emecod,how='left',left_on='eme_sol',right_on='cod_eme')
	base1=base1.rename(columns={"des_eme":"des_eme_sol"})
	base1 = base1.drop("cod_eme", axis=1)
	base1.shape

	
	base1['are_sol']=base1['are_sol'].str.strip()
	areas=areas.rename(columns={"des_are":"des_are_sol"})
	areas=areas.rename(columns={"cod_are":"are_sol"})
	base1=pd.merge(base1,areas,how='left',on='are_sol')
	base1.shape

	
	

	
	base1['ser_sol']=base1['ser_sol'].str.strip()
	servicios=servicios.rename(columns={"des_ser":"des_ser_sol"})
	servicios=servicios.rename(columns={"cod_ser":"ser_sol"})

	base1=pd.merge(base1,servicios,how='left',on='ser_sol')
	base1.shape

	
	base1.shape

	
	base1=pd.merge(base1,cqxtipope,how='left',left_on='tip_ope',right_on='cod_ope')
	base1=base1.rename(columns={"des_ope":"des_tip_ope"})
	base1 = base1.drop( "cod_ope", axis=1)
	base1.shape

	
	

	
	base1=pd.merge(base1,cqxrieqx,how='left',left_on='rie_qx',right_on='cod_rqx')
	base1 = base1.drop("cod_rqx", axis=1)
	base1.shape

	
	

	
	base1=pd.merge(base1,cqxmotsus,how='left',left_on='mot_sus',right_on='cod_msu')
	base1=base1.rename(columns={"des_msu":"des_mot_sus"})
	base1 = base1.drop("cod_msu", axis=1)
	base1.shape

	
	

	
	base1=pd.merge(base1,cqxaneste,how='left',left_on='tip_ane',right_on='cod_ane')
	base1=base1.rename(columns={"des_ane":"des_tip_ane"})
	base1 = base1.drop( "cod_ane", axis=1)
	base1.shape

	
	

	
	base1=pd.merge(base1,cqxmopreslab,how='left',left_on='res_lab',right_on='cod_res')
	base1=base1.rename(columns={"des_lab":"des_res_lab"})
	base1 = base1.drop( "cod_res", axis=1)
	base1.shape

	
	

	
	base1=pd.merge(base1,cqxmoprieqx,how='left',left_on='res_rie_qx',right_on='cod_rie')
	base1=base1.rename(columns={"des_rie":"des_res_rieqx"})
	base1 = base1.drop( "cod_rie", axis=1)
	base1.shape

	
	

	
	base1=pd.merge(base1,cqxmoprieneu,how='left',left_on='res_rie_neu',right_on='cod_rieneu')
	base1=base1.rename(columns={"des_rieneu":"des_res_rieneu"})
	base1 = base1.drop("cod_rieneu", axis=1)
	base1.shape

	
	

	
	base1=pd.merge(base1,cqxmopconinf,how='left',left_on='con_inf',right_on='cod_coninf')
	base1=base1.rename(columns={"des_coninf":"des_con_inf"})
	base1 = base1.drop("cod_coninf", axis=1)
	base1.shape

	
	

	
	base1=pd.merge(base1,cqxmopordtra,how='left',left_on='ord_tra',right_on='cod_ordtra')
	base1=base1.rename(columns={"des_ordtra":"des_ord_tra"})
	base1 = base1.drop("cod_ordtra", axis=1)
	base1.shape

	
	

	
	base1=pd.merge(base1,cqxresevapreqx,how='left',left_on='res_eva',right_on='cod_reseva')
	base1=base1.rename(columns={"des_reseva":"des_res_eva"})
	base1 = base1.drop("cod_reseva", axis=1)
	base1.shape

	
	

	
	base2.columns

	
	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df2_columns - df1_columns
	different_columns

	


	
	comunes = set(base1.columns).intersection(set(base2.columns)) 
	base = base1[list(comunes)]

	
	base.head()

	
	base.columns



	
	borrado = f"DELETE FROM {essi} WHERE {col_essi} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_essi} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection1.execute(borrado)

	
	base.to_sql(name=f'{essi}', con=connection1, if_exists='append', index=False,chunksize=10000)

	
	#para que continue su camino al dat
	base1=base

	
	tabla='qtsop10'
	col_tabla = "solopefec"
	dat= "dat_ceqx001_essi"
	col_essi='fec_sol'
	col_dat='fec_sol'
	essi='essi_dat_cqx001_etl'



	
	cas = pd.read_sql_query(f"SELECT id_cas,cod_cas FROM dim_cas where id_cas is not null", con=connection2)
	cas = cas.drop_duplicates(subset=['cod_cas'])
	cas=cas.dropna()
	red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)

	cqxestfis= pd.read_sql_query(f"SELECT id_estfis,cod_efi,des_efi FROM dim_cqxestfis", con=connection2)
	cqxestfis['cod_efi']=cqxestfis['cod_efi'].str.strip()

	cqxestsolope= pd.read_sql_query(f"SELECT id_estsolope,cod_eso,des_eso FROM dim_cqxestsolope", con=connection2)
	cqxestsolope['cod_eso']=cqxestsolope['cod_eso'].str.strip()

	cqxestreg= pd.read_sql_query(f"SELECT id_estreg,cod_est,des_est FROM dim_cqxestreg", con=connection2)
	cqxestreg['cod_est']=cqxestreg['cod_est'].str.strip()

	cqxcenqx= pd.read_sql_query(f"SELECT id_cenqx,ori_cas,cod_cas,cod_cqx FROM dim_cqxcenqx", con=connection2)
	cqxcenqx['cod_cqx']=cqxcenqx['cod_cqx'].str.strip()
	cqxcenqx['cod_cas']=cqxcenqx['cod_cas'].str.strip()

	cqxsalas= pd.read_sql_query(f"SELECT id_sala,cod_ori,cod_cas,cod_cqx,cod_sal FROM dim_cqxsalas", con=connection2)
	cqxsalas['cod_sal']=cqxsalas['cod_sal'].str.strip()

	areas = pd.read_sql_query(f"SELECT id_area,cod_are FROM dim_areas", con=connection2)
	areas['cod_are']=areas['cod_are'].str.strip()

	servicios = pd.read_sql_query(f"SELECT id_serv,cod_ser,des_ser FROM dim_servicios", con=connection2)
	servicios['cod_ser']=servicios['cod_ser'].str.strip()

	emecod= pd.read_sql_query(f"SELECT id_emecod,cod_eme,des_eme FROM dim_emecod", con=connection2)
	emecod['cod_eme']=emecod['cod_eme'].str.strip()

	cqxtipope= pd.read_sql_query(f"SELECT id_tipope,cod_ope,des_ope FROM dim_cqxtipope", con=connection2)
	cqxtipope['cod_ope']=cqxtipope['cod_ope'].str.strip()

	cqxrieqx= pd.read_sql_query(f"SELECT id_rieqx,cod_rqx,des_rqx FROM dim_cqxrieqx", con=connection2)
	cqxrieqx['cod_rqx']=cqxrieqx['cod_rqx'].str.strip()

	cqxmotsus= pd.read_sql_query(f"SELECT id_motsus,cod_msu,des_msu FROM dim_cqxmotsus", con=connection2)
	cqxmotsus['cod_msu']=cqxmotsus['cod_msu'].str.strip()

	cqxaneste= pd.read_sql_query(f"SELECT id_anestesia,cod_ane,des_ane FROM dim_cqxaneste", con=connection2)
	cqxaneste['cod_ane']=cqxaneste['cod_ane'].str.strip()

	cqxmopreslab= pd.read_sql_query(f"SELECT id_reslab,cod_res,des_lab FROM dim_cqxmopreslab", con=connection2)
	cqxmopreslab['cod_res']=cqxmopreslab['cod_res'].str.strip()

	cqxmoprieqx= pd.read_sql_query(f"SELECT id_rieqx,cod_rie,des_rie FROM dim_cqxmoprieqx", con=connection2)
	cqxmoprieqx['cod_rie']=cqxmoprieqx['cod_rie'].str.strip()

	cqxmoprieneu= pd.read_sql_query(f"SELECT id_rieneu,cod_rieneu,des_rieneu FROM dim_cqxmoprieneu", con=connection2)
	cqxmoprieneu['cod_rieneu']=cqxmoprieneu['cod_rieneu'].str.strip()

	cqxmopconinf= pd.read_sql_query(f"SELECT id_coninf,cod_coninf,des_coninf FROM dim_cqxmopconinf", con=connection2)
	cqxmopconinf['cod_coninf']=cqxmopconinf['cod_coninf'].str.strip()

	cqxmopordtra= pd.read_sql_query(f"SELECT id_ordtra,cod_ordtra,des_ordtra FROM dim_cqxmopordtra", con=connection2)
	cqxmopordtra['cod_ordtra']=cqxmopordtra['cod_ordtra'].str.strip()

	cqxresevapreqx= pd.read_sql_query(f"SELECT id_reseva,cod_reseva,des_reseva FROM dim_cqxresevapreqx", con=connection2)
	cqxresevapreqx['cod_reseva']=cqxresevapreqx['cod_reseva'].str.strip()

	cqxpriope= pd.read_sql_query(f"SELECT id_priope,cod_pop FROM dim_cqxpriope", con=connection2)
	cqxpriope['cod_pop']=cqxpriope['cod_pop'].str.strip()

	oricas = pd.read_sql_query(f"SELECT id_oricas,ori_cod FROM dim_oricas", con=connection2)
	oricas["ori_cod"]=oricas["ori_cod"].str.strip()

	tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
	tipdoc["cod_tdo"]=tipdoc["cod_tdo"].str.strip()

	numdoc = pd.read_sql_query(f"SELECT id_person,num_doc FROM dim_personal", con=connection2)
	numdoc["num_doc"]=numdoc["num_doc"].str.strip()
	numdoc["num_doc"]=numdoc["num_doc"].str.replace(' ', '', regex=True)
	numdoc=numdoc.drop_duplicates(subset="num_doc")

	tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)
	tiempo=tiempo.rename(columns={"id_tiempo":"id_time_pro","dt_fecha":"fec_pro","dt_mes":"mes_pro","dt_dia":"dia_pro","dt_dia_sem":"dia_sem_pro","dt_sem":"sem_pro","dt_ano":"ano_pro"})

	

	

	
	base2=pd.read_sql_query(f"SELECT * FROM {dat} LIMIT 10", con=connection2)

	


	

	
	#Eliminamos las columnas que no se usarán aquí: las descripciones y otras 4 más, previa evaluación

	# Lista de columnas a eliminar
	columnas_eliminar = ['des_cas', 'des_red', 'des_fis', 'des_sop', 'des_reg', 'des_cqx', 'des_sal',
						'des_are', 'des_ser', 'des_eme_sol', 'des_are_sol', 'des_ser_sol',
						'des_tip_ope', 'des_rqx', 'des_mot_sus', 'des_tip_ane', 'des_res_lab',
						'des_res_rieqx', 'des_res_rieneu', 'des_con_inf', 'des_ord_tra', 'des_res_eva',
						'sdp_hos_pre', 'sdp_hos_pos', 'req_pro_flg']

	# Eliminar las columnas
	base1 = base1.drop(columns=columnas_eliminar)


	
	base1.shape

	
	control_a.append(base1.shape[0])

	
	cqxcenqx["KEY"]=cqxcenqx["ori_cas"].str.strip()+cqxcenqx["cod_cas"].str.strip()+cqxcenqx["cod_cqx"].str.strip()
	cqxcenqx=cqxcenqx.drop(["ori_cas",'cod_cas','cod_cqx'], axis=1)
	cqxcenqx = cqxcenqx.rename(columns={"id_cenqx": "id_cqx"})
	base1["KEY"]=base1["ori_cas"].str.strip()+base1["cod_cas"].astype(str).str.strip()+base1['cod_cqx'].astype(str).str.strip()
	merge=pd.merge(base1,cqxcenqx,how='inner',on='KEY')
	base1=pd.merge(base1,cqxcenqx,how='left',on='KEY')
	base1.shape

	
	log_falla('id_cqx', 'KEY', True)
	log_control('dim_cqxcenqx')
	base1 = base1.drop("KEY",axis=1)

	
	cqxsalas["KEY"]=cqxsalas["cod_ori"].str.strip()+cqxsalas["cod_cas"].str.strip()+cqxsalas["cod_cqx"].str.strip()+cqxsalas["cod_sal"].str.strip()
	cqxsalas=cqxsalas.drop(["cod_ori",'cod_cas','cod_cqx','cod_sal'], axis=1)
	base1["KEY"]=base1["ori_cas"].str.strip()+base1["cod_cas"].astype(str).str.strip()+base1['cod_cqx'].astype(str).str.strip()+base1["cod_sal"].str.strip()
	merge=pd.merge(base1,cqxsalas,how='left',on='KEY')
	base1=pd.merge(base1,cqxsalas,how='left',on='KEY') #left para no perder datos
	base1.shape

	
	log_falla('id_sala', 'KEY', True)
	log_control('dim_cqxsalas')
	base1 = base1.drop(["cod_sal","cod_cqx","KEY"],axis=1)

	
	oricas=oricas.rename(columns={"ori_cod":"ori_cas"})
	base1['ori_cas']=base1['ori_cas'].str.strip()
	base1["ori_cas"]=base1["ori_cas"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,oricas,how='inner',on='ori_cas')
	base1=pd.merge(base1,oricas,how='left',on='ori_cas')
	base1.shape

	
	log_falla('id_oricas', 'ori_cas', True)
	log_control('dim_oricas')
	base1=base1.drop('ori_cas',axis=1)

	
	oricas=oricas.rename(columns={"id_oricas":"id_oricaseva","ori_cas":"ori_cas_eva"})
	base1['ori_cas_eva']=base1['ori_cas_eva'].str.strip()
	base1["ori_cas_eva"]=base1["ori_cas_eva"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,oricas,how='inner',on='ori_cas_eva')
	base1=pd.merge(base1,oricas,how='left',on='ori_cas_eva') #Tiene que ser left o se pierden datos
	base1.shape

	
	merge.shape

	
	log_falla('id_oricaseva', 'ori_cas_eva', True)
	log_control('dim_oricas')
	base1=base1.drop('ori_cas_eva',axis=1)

	
	base1['cod_cas']=base1['cod_cas'].str.strip()
	base1["cod_cas"]=base1["cod_cas"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,cas,how='inner',on='cod_cas')
	base1=pd.merge(base1,cas,how='left',on='cod_cas')
	base1.shape

	
	log_falla('id_cas', 'cod_cas', True)
	log_control('dim_cas')
	base1=base1.drop('cod_cas',axis=1)

	
	cas=cas.rename(columns={"id_cas":"id_caseva","cod_cas":"cod_cas_eva"})
	base1['cod_cas_eva']=base1['cod_cas_eva'].str.strip()
	base1["cod_cas_eva"]=base1["cod_cas_eva"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,cas,how='inner',on='cod_cas_eva')
	base1=pd.merge(base1,cas,how='left',on='cod_cas_eva') #left para no perder datos
	base1.shape

	
	log_falla('id_caseva', 'cod_cas_eva', True)
	log_control('dim_cas')
	base1=base1.drop('cod_cas_eva',axis=1)

	
	base1['cod_red']=base1['cod_red'].str.strip()
	base1["cod_red"]=base1["cod_red"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,red,how='inner',on='cod_red')
	base1=pd.merge(base1,red,how='left',on='cod_red')
	base1.shape

	
	log_falla('id_red', 'cod_red', True)
	log_control('dim_red')
	base1=base1.drop('cod_red',axis=1)

	
	base1['cod_tdi']=base1['cod_tdi'].str.strip()
	base1["cod_tdi"]=base1["cod_tdi"].str.replace(' ', '', regex=True)
	tipdoc=tipdoc.rename(columns={"id_tipdoc": "id_tdi","cod_tdo":"cod_tdi"})
	merge=pd.merge(base1,tipdoc,how='inner',on='cod_tdi')
	base1=pd.merge(base1,tipdoc,how='left',on='cod_tdi')
	base1.shape

	
	log_falla('id_tdi', 'cod_tdi', True)
	log_control('dim_tipdoc')
	base1=base1.drop('cod_tdi',axis=1)

	
	base1['eva_tip_doc']=base1['eva_tip_doc'].str.strip()
	base1["eva_tip_doc"]=base1["eva_tip_doc"].str.replace(' ', '', regex=True)
	tipdoc=tipdoc.rename(columns={"id_tdi": "id_evatipdoc","cod_tdi":"eva_tip_doc"})
	merge=pd.merge(base1,tipdoc,how='left',on='eva_tip_doc')
	base1=pd.merge(base1,tipdoc,how='left',on='eva_tip_doc') #left para no perder datos
	base1.shape

	
	base1.shape

	
	log_falla('id_evatipdoc', 'eva_tip_doc', True)
	log_control('dim_tipdoc')
	base1=base1.drop('eva_tip_doc',axis=1)

	
	

	
	numdoc=numdoc.rename(columns={"num_doc": "usu_cre","id_person": "id_usucre"})
	base1['usu_cre']=base1['usu_cre'].str.strip()
	base1["usu_cre"]=base1["usu_cre"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,numdoc,how='left',on='usu_cre')
	base1=pd.merge(base1,numdoc,how='left',on='usu_cre') #Se perdieron unos datos
	base1.shape

	
	log_falla('id_usucre', 'usu_cre', True)
	log_control('dim_personal')
	base1=base1.drop('usu_cre',axis=1)

	
	numdoc=numdoc.rename(columns={"usu_cre": "num_doc","id_usucre":"id_numdoc"})
	base1['num_doc']=base1['num_doc'].str.strip()
	base1["num_doc"]=base1["num_doc"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,numdoc,how='inner',on='num_doc')
	base1=pd.merge(base1,numdoc,how='left',on='num_doc')
	base1.shape

	
	log_falla('id_numdoc', 'num_doc', True)
	log_control('dim_personal')
	base1=base1.drop('num_doc',axis=1)

	


	
	numdoc=numdoc.rename(columns={"num_doc": "usu_mod","id_numdoc": "id_usumod"})
	base1['usu_mod']=base1['usu_mod'].str.strip()
	base1["usu_mod"]=base1["usu_mod"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,numdoc,how='inner',on='usu_mod')
	base1=pd.merge(base1,numdoc,how='left',on='usu_mod')
	base1.shape

	
	log_falla('id_usumod', 'usu_mod', True)
	log_control('dim_personal')
	base1=base1.drop('usu_mod',axis=1)

	
	numdoc=numdoc.rename(columns={"usu_mod": "eva_num_doc","id_usumod": "id_evanumdoc"})
	base1['eva_num_doc']=base1['eva_num_doc'].str.strip()
	base1["eva_num_doc"]=base1["eva_num_doc"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,numdoc,how='inner',on='eva_num_doc')
	base1=pd.merge(base1,numdoc,how='left',on='eva_num_doc')
	base1.shape

	
	log_falla('id_evanumdoc', 'eva_num_doc', True)
	log_control('dim_personal')
	base1=base1.drop('eva_num_doc',axis=1)

	
	

	
	cqxestfis=cqxestfis.rename(columns={"cod_efi": "est_fis"})
	base1['est_fis']=base1['est_fis'].str.strip()
	base1["est_fis"]=base1["est_fis"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,cqxestfis,how='inner',on='est_fis')
	base1=pd.merge(base1,cqxestfis,how='left',on='est_fis') #left, pasó de 68K a 45k
	base1.shape

	
	log_falla('id_estfis', 'est_fis', True)
	log_control('dim_cqxestfis')
	base1 = base1.drop(["des_efi","est_fis"],axis=1)

	
	cqxestsolope=cqxestsolope.rename(columns={"cod_eso": "est_sop","id_estsolope": "id_estsop"})
	base1['est_sop']=base1['est_sop'].str.strip()
	base1["est_sop"]=base1["est_sop"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,cqxestsolope,how='inner',on='est_sop')
	base1=pd.merge(base1,cqxestsolope,how='left',on='est_sop')
	base1.shape

	
	log_falla('id_estsop', 'est_sop', True)
	log_control('dim_cqxestsolope')
	base1 = base1.drop(["des_eso","est_sop"],axis=1)

	
	cqxestreg=cqxestreg.rename(columns={"cod_est": "est_reg"})
	base1['est_reg']=base1['est_reg'].str.strip()
	base1["est_reg"]=base1["est_reg"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,cqxestreg,how='inner',on='est_reg')
	base1=pd.merge(base1,cqxestreg,how='left',on='est_reg')
	base1.shape

	
	log_falla('id_estreg', 'est_reg', True)
	log_control('dim_cqxestreg')
	base1 = base1.drop(["des_est","est_reg"],axis=1)

	
	base1['cod_are']=base1['cod_are'].str.strip()
	base1["cod_are"]=base1["cod_are"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,areas,how='left',on='cod_are')
	base1=pd.merge(base1,areas,how='left',on='cod_are')
	base1.shape

	
	log_falla('id_area', 'cod_are', True)
	log_control('dim_areas')
	base1 = base1.drop("cod_are",axis=1)

	
	base1['are_sol']=base1['are_sol'].str.strip()
	base1["are_sol"]=base1["are_sol"].str.replace(' ', '', regex=True)
	areas=areas.rename(columns={"cod_are": "are_sol","id_area":"id_aresol"})
	merge=pd.merge(base1,areas,how='left',on='are_sol')
	base1=pd.merge(base1,areas,how='left',on='are_sol')
	base1.shape

	
	log_falla('id_aresol', 'are_sol', True)
	log_control('dim_areas')
	base1 = base1.drop("are_sol",axis=1)

	
	servicios = pd.read_sql_query(f"SELECT id_serv,cod_ser FROM dim_servicios", con=connection2)
	servicios['cod_ser']=servicios['cod_ser'].str.strip()
	base1['cod_ser']=base1['cod_ser'].str.strip()
	base1["cod_ser"]=base1["cod_ser"].str.replace(' ', '', regex=True)
	merge=pd.merge(base1,servicios,how='left',on='cod_ser')
	base1=pd.merge(base1,servicios,how='left',on='cod_ser')
	base1.shape

	
	log_falla('id_serv','cod_ser', True)
	log_control('dim_servicios')
	base1 = base1.drop("cod_ser",axis=1)

	
	base1['ser_sol']=base1['ser_sol'].str.strip()
	base1["ser_sol"]=base1["ser_sol"].str.replace(' ', '', regex=True)
	servicios=servicios.rename(columns={"id_serv": "id_sersol","cod_ser":"ser_sol"})
	merge=pd.merge(base1,servicios,how='left',on='ser_sol')
	base1=pd.merge(base1,servicios,how='left',on='ser_sol')
	base1.shape

	
	log_falla('id_sersol', 'ser_sol', True)
	log_control('dim_servicios')
	base1 = base1.drop("ser_sol",axis=1)

	

	
	base1['eme_sol']=base1['eme_sol'].str.strip()
	base1["eme_sol"]=base1["eme_sol"].str.replace(' ', '', regex=True)
	emecod=emecod.rename(columns={"id_emecod": "id_emesol","cod_eme":"eme_sol"})
	merge=pd.merge(base1,emecod,how='inner',on='eme_sol')
	base1=pd.merge(base1,emecod,how='left',on='eme_sol') #Aquí usamos left porque no hay datos en eme_sol 
	base1.shape

	
	log_falla('id_emesol', 'eme_sol', True)
	log_control('dim_emecod')
	base1 = base1.drop(["des_eme","eme_sol"],axis=1)

	
	base1['ser_eme_sol']=base1['ser_eme_sol'].str.strip()
	base1["ser_eme_sol"]=base1["ser_eme_sol"].str.replace(' ', '', regex=True)
	emecod=emecod.rename(columns={"id_emesol": "id_seremesol","eme_sol":"ser_eme_sol"})
	merge=pd.merge(base1,emecod,how='inner',on='ser_eme_sol')
	base1=pd.merge(base1,emecod,how='left',on='ser_eme_sol')#Aquí usamos left porque no hay datos en ser_eme_sol 
	base1.shape

	
	log_falla('id_seremesol', 'ser_eme_sol', True)
	log_control('dim_emecod')
	base1 = base1.drop(["ser_eme_sol","des_eme"],axis=1)

	
	base1['tip_ope']=base1['tip_ope'].str.strip()
	base1["tip_ope"]=base1["tip_ope"].str.replace(' ', '', regex=True)
	cqxtipope=cqxtipope.rename(columns={"cod_ope":"tip_ope"})
	merge=pd.merge(base1,cqxtipope,how='inner',on='tip_ope')
	base1=pd.merge(base1,cqxtipope,how='left',on='tip_ope') #Se cambió a left porque baja de 68k a 59
	base1.shape

	
	log_falla('id_tipope', 'tip_ope', True)
	log_control('dim_cqxtipope')
	base1 = base1.drop(["des_ope","tip_ope"],axis=1)

	
	base1['pri_ope']=base1['pri_ope'].str.strip()
	base1["pri_ope"]=base1["pri_ope"].str.replace(' ', '', regex=True)
	cqxpriope=cqxpriope.rename(columns={"cod_pop":"pri_ope"})
	merge=pd.merge(base1,cqxpriope,how='inner',on='pri_ope')
	base1=pd.merge(base1,cqxpriope,how='left',on='pri_ope') #Se cambió a left, porque bajan los datos
	base1.shape

	
	log_falla('id_priope', 'pri_ope', True)
	log_control('dim_cqxpriope')
	base1 = base1.drop("pri_ope",axis=1)

	
	base1['rie_qx']=base1['rie_qx'].str.strip()
	base1["rie_qx"]=base1["rie_qx"].str.replace(' ', '', regex=True)
	cqxrieqx=cqxrieqx.rename(columns={"cod_rqx":"rie_qx"})
	merge=pd.merge(base1,cqxrieqx,how='inner',on='rie_qx')
	base1=pd.merge(base1,cqxrieqx,how='left',on='rie_qx') #Se cambió a left, porque bajan los datos
	base1.shape

	
	merge.shape

	
	log_falla('id_rieqx', 'rie_qx', True)
	log_control('dim_cqxrieqx')
	base1 = base1.drop(["rie_qx","des_rqx"],axis=1)

	
	base1['mot_sus']=base1['mot_sus'].str.strip()
	base1["mot_sus"]=base1["mot_sus"].str.replace(' ', '', regex=True)
	cqxmotsus=cqxmotsus.rename(columns={"cod_msu":"mot_sus"})
	merge=pd.merge(base1,cqxmotsus,how='inner',on='mot_sus')
	base1=pd.merge(base1,cqxmotsus,how='left',on='mot_sus') #Cambiar a left, se bajan todos los datos
	base1.shape

	
	log_falla('id_motsus', 'mot_sus', True)
	log_control('dim_cqxmotsus')
	base1 = base1.drop(["des_msu","mot_sus"],axis=1)

	
	base1['tip_ane']=base1['tip_ane'].str.strip()
	base1["tip_ane"]=base1["tip_ane"].str.replace(' ', '', regex=True)
	cqxaneste=cqxaneste.rename(columns={"id_anestesia":"id_tipane","cod_ane":"tip_ane"})
	merge=pd.merge(base1,cqxaneste,how='inner',on='tip_ane')
	base1=pd.merge(base1,cqxaneste,how='left',on='tip_ane') #Tiene que ser left porque no hay datos
	base1.shape

	
	log_falla('id_tipane', 'tip_ane', True)
	log_control('dim_cqxaneste')
	base1 = base1.drop(["des_ane","tip_ane"],axis=1)

	
	base1['res_lab']=base1['res_lab'].str.strip()
	base1["res_lab"]=base1["res_lab"].str.replace(' ', '', regex=True)
	cqxmopreslab=cqxmopreslab.rename(columns={"cod_res":"res_lab"})
	merge=pd.merge(base1,cqxmopreslab,how='inner',on='res_lab')
	base1=pd.merge(base1,cqxmopreslab,how='left',on='res_lab') #Tiene que ser left porque no hay datos
	base1.shape

	
	merge.shape

	
	log_falla('id_reslab', 'res_lab', True)
	log_control('dim_cqxmopreslab')
	base1 = base1.drop(["des_lab","res_lab"],axis=1)

	
	base1['res_rie_qx']=base1['res_rie_qx'].str.strip()
	base1["res_rie_qx"]=base1["res_rie_qx"].str.replace(' ', '', regex=True)
	cqxmoprieqx=cqxmoprieqx.rename(columns={"id_rieqx":"id_resrieqx","cod_rie":"res_rie_qx"})
	merge=pd.merge(base1,cqxmoprieqx,how='inner',on='res_rie_qx')
	base1=pd.merge(base1,cqxmoprieqx,how='left',on='res_rie_qx') #left porque no hay datos
	base1.shape

	
	log_falla('id_resrieqx', 'res_rie_qx', True)
	log_control('dim_cqxmoprieqx')
	base1 = base1.drop(["des_rie","res_rie_qx"],axis=1)

	
	base1['res_rie_neu']=base1['res_rie_neu'].str.strip()
	base1["res_rie_neu"]=base1["res_rie_neu"].str.replace(' ', '', regex=True)
	cqxmoprieneu=cqxmoprieneu.rename(columns={"id_rieneu":"id_resrieneu","cod_rieneu":"res_rie_neu"})
	merge=pd.merge(base1,cqxmoprieneu,how='inner',on='res_rie_neu')
	base1=pd.merge(base1,cqxmoprieneu,how='left',on='res_rie_neu') #Left porque no hay datos
	base1.shape

	
	log_falla('id_resrieneu', 'res_rie_neu', True)
	log_control('dim_cqxmoprieneu')
	base1 = base1.drop(["des_rieneu","res_rie_neu"],axis=1)

	
	base1['con_inf']=base1['con_inf'].str.strip()
	base1["con_inf"]=base1["con_inf"].str.replace(' ', '', regex=True)
	cqxmopconinf=cqxmopconinf.rename(columns={"cod_coninf":"con_inf"})
	merge=pd.merge(base1,cqxmopconinf,how='inner',on='con_inf')
	base1=pd.merge(base1,cqxmopconinf,how='left',on='con_inf') #Left porque no hay datos
	base1.shape

	
	log_falla('con_inf', 'con_inf', True)
	log_control('dim_cqxmopconinf')
	base1 = base1.drop(["des_coninf","con_inf"],axis=1)

	
	base1['ord_tra']=base1['ord_tra'].str.strip()
	base1["ord_tra"]=base1["ord_tra"].str.replace(' ', '', regex=True)
	cqxmopordtra=cqxmopordtra.rename(columns={"cod_ordtra":"ord_tra"})
	merge=pd.merge(base1,cqxmopordtra,how='inner',on='ord_tra') 
	base1=pd.merge(base1,cqxmopordtra,how='left',on='ord_tra') #Left porque no hay datos
	base1.shape

	
	log_falla('id_ordtra', 'ord_tra', True)
	log_control('dim_cqxmopordtra')
	base1 = base1.drop(["des_ordtra","ord_tra"],axis=1)

	
	base1['res_eva']=base1['res_eva'].str.strip()
	base1["res_eva"]=base1["res_eva"].str.replace(' ', '', regex=True)
	cqxresevapreqx=cqxresevapreqx.rename(columns={"cod_reseva":"res_eva"})
	merge=pd.merge(base1,cqxresevapreqx,how='inner',on='res_eva')
	base1=pd.merge(base1,cqxresevapreqx,how='left',on='res_eva') #Left porque no hay muchos datos
	base1.shape

	
	merge.shape

	
	log_falla('id_reseva', 'res_eva', True)
	base1 = base1.drop(["des_reseva","res_eva"],axis=1)
	dim.append('dim_cqxresevapreqx')
	control_d.append(base1.shape[0])

	
	base1['fec_sol'] = pd.to_datetime(base1['fec_sol']).dt.date
	tiempo=tiempo.rename(columns={"fec_pro":"fec_sol"})
	merge = pd.merge(base1, tiempo, how='inner', on='fec_sol')
	base1 = pd.merge(base1, tiempo, how='left', on='fec_sol') #Puede ser inner
	base1=base1.rename(columns={"id_time_pro":"id_time_sol","ano_pro":"ano_sol","mes_pro":"mes_sol",
								"dia_pro":"dia_sol","dia_sem_pro":"dia_sem_sol","sem_pro":"sem_sol"})

	
	base1.shape

	
	base1['fec_sop_temp'] = base1['fec_sop'].astype(str).str.split().str[0]
	tiempo=tiempo.rename(columns={"fec_sol":"fec_sop_temp"})
	tiempo["fec_sop_temp"] = tiempo['fec_sop_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='inner', on='fec_sop_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='fec_sop_temp')
	base1=base1.rename(columns={"id_time_pro":"id_time_sop","ano_pro":"ano_sop","mes_pro":"mes_sop",
								"dia_pro":"dia_sop","dia_sem_pro":"dia_sem_sop","sem_pro":"sem_sop"})
	base1=base1.drop("fec_sop_temp",axis=1)
	base1.shape

	
	base1['fec_cre_temp'] = base1['fec_cre'].astype(str).str.split().str[0]
	tiempo=tiempo.rename(columns={"fec_sop_temp":"fec_cre_temp"})
	tiempo["fec_cre_temp"] = tiempo['fec_cre_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='inner', on='fec_cre_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='fec_cre_temp')
	base1=base1.rename(columns={"id_time_pro":"id_time_cre","ano_pro":"ano_cre","mes_pro":"mes_cre",
								"dia_pro":"dia_cre","dia_sem_pro":"dia_sem_cre","sem_pro":"sem_cre"})
	base1=base1.drop("fec_cre_temp",axis=1)
	base1.shape

	
	base1['fec_mod_temp'] = base1['fec_mod'].astype(str).str.split().str[0]
	tiempo = tiempo.rename(columns={"fec_cre_temp": "fec_mod_temp"})
	tiempo["fec_mod_temp"] = tiempo['fec_mod_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='inner', on='fec_mod_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='fec_mod_temp')
	base1=base1.rename(columns={"ano_pro":"ano_mod","mes_pro":"mes_mod",
								"dia_pro":"dia_mod","dia_sem_pro":"dia_sem_mod","sem_pro":"sem_mod"})
	base1=base1.drop(["fec_mod_temp","id_time_pro"], axis=1)
	base1.shape

	
	base1['fec_eva_temp'] = base1['fec_eva'].astype(str)
	tiempo = tiempo.rename(columns={"fec_mod_temp": "fec_eva_temp"})
	tiempo["fec_eva_temp"] = tiempo['fec_eva_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='inner', on='fec_eva_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='fec_eva_temp')
	base1=base1.rename(columns={"id_time_pro":"id_time_eva","ano_pro":"ano_eva","mes_pro":"mes_eva",
								"dia_pro":"dia_eva","dia_sem_pro":"dia_sem_eva","sem_pro":"sem_eva"})
	base1=base1.drop("fec_eva_temp", axis=1)
	base1.shape

	
	base1['fec_sol_temp'] = base1['fec_sol_exa'].astype(str)
	tiempo = tiempo.rename(columns={"fec_eva_temp": "fec_sol_temp"})
	tiempo["fec_sol_temp"] = tiempo['fec_sol_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='inner', on='fec_sol_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='fec_sol_temp')
	base1 = base1.rename(columns={"id_time_pro": "id_time_solexa", "ano_pro": "ano_solexa", "mes_pro": "mes_solexa", 
								"dia_pro": "dia_solexa", "dia_sem_pro": "dia_sem_solexa", "sem_pro": "sem_solexa"})
	base1=base1.drop("fec_sol_temp", axis=1)
	base1.shape

	
	base1['fec_res_exa_temp'] = base1['fec_res_exa'].astype(str)
	tiempo = tiempo.rename(columns={"fec_sol_temp": "fec_res_exa_temp"})
	tiempo["fec_res_exa_temp"] = tiempo['fec_res_exa_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='inner', on='fec_res_exa_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='fec_res_exa_temp')
	base1 = base1.rename(columns={"id_time_pro": "id_timeresexa", "ano_pro": "ano_resexa", "mes_pro": "mes_resexa", 
								"dia_pro": "dia_resexa", "dia_sem_pro": "dia_sem_resexa", "sem_pro": "sem_resexa"})
	base1=base1.drop("fec_res_exa_temp", axis=1)
	base1.shape

	
	base1['fec_rie_car_temp'] = base1['fec_rie_car'].astype(str)
	tiempo = tiempo.rename(columns={"fec_res_exa_temp": "fec_rie_car_temp"})
	tiempo["fec_rie_car_temp"] = tiempo['fec_rie_car_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='inner', on='fec_rie_car_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='fec_rie_car_temp')
	base1 = base1.rename(columns={"id_time_pro": "id_time_riecar", "ano_pro": "ano_riecar", "mes_pro": "mes_riecar", 
								"dia_pro": "dia_riecar", "dia_sem_pro": "dia_sem_riecar", "sem_pro": "sem_riecar"})
	base1=base1.drop("fec_rie_car_temp", axis=1)
	base1.shape

	
	base1['fec_rie_neu_temp'] = base1['fec_rie_neu'].astype(str)
	tiempo = tiempo.rename(columns={"fec_rie_car_temp": "fec_rie_neu_temp"})
	tiempo["fec_rie_neu_temp"] = tiempo['fec_rie_neu_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='inner', on='fec_rie_neu_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='fec_rie_neu_temp')
	base1 = base1.rename(columns={"id_time_pro": "id_time_rieneu", "ano_pro": "ano_rieneu", "mes_pro": "mes_rieneu",
								"dia_pro": "dia_rieneu", "dia_sem_pro": "dia_sem_rieneu", "sem_pro": "sem_rieneu"})
	base1=base1.drop("fec_rie_neu_temp", axis=1)
	base1.shape

	
	base1['fec_pro_temp'] = base1['fec_pro'].astype(str)
	tiempo = tiempo.rename(columns={"fec_rie_neu_temp": "fec_pro_temp"})
	tiempo["fec_pro_temp"] = tiempo['fec_pro_temp'].astype(str)
	merge = pd.merge(base1, tiempo, how='inner', on='fec_pro_temp')
	base1 = pd.merge(base1, tiempo, how='left', on='fec_pro_temp')
	base1=base1.drop("fec_pro_temp", axis=1)
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


