
tabla='ctpco10'
col_tabla='proconfec'


from decouple import config
from sqlalchemy import create_engine
import pandas as pd
from datetime import datetime, timedelta
import time 
import datetime
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


fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=6", con=connection2)
fecha_ini= fecha_ini.iloc[0, 0]

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=6", con=connection2)
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

	query=f"UPDATE etl_act SET fec_act ='{now}' WHERE id_mod=6"

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


	oracledb.init_oracle_client()
	oracledb.version = "8.3.0"
	sys.modules["cx_Oracle"] = oracledb
	un = config("USER4_BDI_POSTGRES")
	pw = config("PASS4_BDI_POSTGRES")
	hostname = config("HOST4_BDI_POSTGRES")
	service_name = "WNET"
	port = 1527

	engine0 = create_engine(f'oracle://{un}:{pw}@', connect_args={
		"host": hostname,
		"port": port,
		"service_name": service_name
	})

	connection0 = engine0.connect()

	query = f"SELECT * FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') AND {col_tabla} <= TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	base2 = pd.read_sql_query(query, con=connection0)




	connection0.close()






	base2.to_sql(name=f'tmp_{tabla}', con=engine3, if_exists='replace', index=False)



	borrado = f"DELETE FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} <= TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection3.execute(borrado)



	query=f"""

	ALTER TABLE tmp_{tabla} 
	ALTER COLUMN proconoricenasicod TYPE character(1),
	ALTER COLUMN proconcenasicod TYPE character(3),
	ALTER COLUMN proconarehoscod TYPE character(2),
	ALTER COLUMN proconservhoscod TYPE character(3),
	ALTER COLUMN proconactcod TYPE character(2),
	ALTER COLUMN proconactespcod TYPE character(3),
	ALTER COLUMN procontipdocidenpercod TYPE character(1),
	ALTER COLUMN proconperasisdocidennum TYPE character(10),
	ALTER COLUMN proconfec TYPE date USING proconfec::date,
	ALTER COLUMN proconturhorini TYPE timestamp USING proconturhorini::timestamp without time zone,
	ALTER COLUMN proconturhorfin TYPE timestamp USING proconturhorfin::timestamp without time zone,
	ALTER COLUMN concod TYPE character(5),
	ALTER COLUMN proconcancupcitvol TYPE numeric(3,0) USING proconcancupcitvol::numeric(3,0),
	ALTER COLUMN proconcancupreci TYPE numeric(3,0) USING proconcancupreci::numeric(3,0),
	ALTER COLUMN proconcancupinte TYPE numeric(3,0) USING proconcancupinte::numeric(3,0),
	ALTER COLUMN proconcancupcitdia TYPE numeric(3,0) USING proconcancupcitdia::numeric(3,0),
	ALTER COLUMN proconcancuptopnuev TYPE numeric(3,0) USING proconcancuptopnuev::numeric(3,0),
	ALTER COLUMN proconcancuptopadic TYPE numeric(3,0) USING proconcancuptopadic::numeric(3,0),
	ALTER COLUMN proconcancuptoprefe TYPE numeric(3,0) USING proconcancuptoprefe::numeric(3,0),
	ALTER COLUMN proconcancuptopterc TYPE numeric(3,0) USING proconcancuptopterc::numeric(3,0),
	ALTER COLUMN proconcanotorcitvol TYPE numeric(3,0) USING proconcanotorcitvol::numeric(3,0),
	ALTER COLUMN proconcanotorreci TYPE numeric(3,0) USING proconcanotorreci::numeric(3,0),
	ALTER COLUMN proconcanotorinte TYPE numeric(3,0) USING proconcanotorinte::numeric(3,0),
	ALTER COLUMN proconcanotortopnuev TYPE numeric(3,0) USING proconcanotortopnuev::numeric(3,0),
	ALTER COLUMN proconcanotortopadic TYPE numeric(3,0) USING proconcanotortopadic::numeric(3,0),
	ALTER COLUMN proconcanotortoprefe TYPE numeric(3,0) USING proconcanotortoprefe::numeric(3,0),
	ALTER COLUMN proconcanotortopterc TYPE numeric(3,0) USING proconcanotortopterc::numeric(3,0), 
	ALTER COLUMN proconcanciteli TYPE numeric(3,0) USING proconcanciteli::numeric(3,0),
	ALTER COLUMN proconcancitate TYPE numeric(3,0) USING proconcancitate::numeric(3,0),
	ALTER COLUMN proconcancitrep TYPE numeric(3,0) USING proconcancitrep::numeric(3,0),
	ALTER COLUMN proconcandemins TYPE numeric(3,0) USING proconcandemins::numeric(3,0),
	ALTER COLUMN proconestcom TYPE character(1),
	ALTER COLUMN proconestregcod TYPE character(1),
	ALTER COLUMN proconcancupcitref TYPE numeric(3,0) USING proconcancupcitref::numeric(3,0),
	ALTER COLUMN proconcanotorcitref TYPE numeric(3,0) USING proconcanotorcitref::numeric(3,0),
	ALTER COLUMN proconcanpachor TYPE numeric(2,0) USING proconcanpachor::numeric(2,0);




	INSERT INTO {tabla} 
	(proconoricenasicod,proconcenasicod,proconarehoscod,proconservhoscod,proconactcod,proconactespcod,procontipdocidenpercod,proconperasisdocidennum,proconfec,proconturhorini,proconturhorfin,concod,proconcancupcitvol,proconcancupreci,proconcancupinte,proconcancupcitdia,proconcancuptopnuev,proconcancuptopadic,proconcancuptoprefe,proconcancuptopterc,proconcanotorcitvol,proconcanotorreci,proconcanotorinte,proconcanotortopnuev,proconcanotortopadic,proconcanotortoprefe,proconcanotortopterc,proconcanciteli,proconcancitate,proconcancitrep,proconcandemins,proconestcom,proconestregcod,proconcancupcitref,proconcanotorcitref,proconcanpachor) 

	SELECT 
	proconoricenasicod,proconcenasicod,proconarehoscod,proconservhoscod,proconactcod,proconactespcod,procontipdocidenpercod,proconperasisdocidennum,proconfec,proconturhorini,proconturhorfin,concod,proconcancupcitvol,proconcancupreci,proconcancupinte,proconcancupcitdia,proconcancuptopnuev,proconcancuptopadic,proconcancuptoprefe,proconcancuptopterc,proconcanotorcitvol,proconcanotorreci,proconcanotorinte,proconcanotortopnuev,proconcanotortopadic,proconcanotortoprefe,proconcanotortopterc,proconcanciteli,proconcancitate,proconcancitrep,proconcandemins,proconestcom,proconestregcod,proconcancupcitref,proconcanotorcitref,proconcanpachor



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






	#PLUS


	tabla='ctpco10'
	col_essi='fec_pro'
	col_tabla='proconfec'
	essi='essi_dat_cex004_etl'

	#TRAEMOS MAESTROS

	cas = pd.read_sql_query(f"SELECT id_red,cod_cas,des_cas FROM dim_cas where id_red is not null", con=connection2)
	cas = cas.drop_duplicates(subset=['cod_cas'])
	cas=cas.dropna()
	red = pd.read_sql_query(f"SELECT id_red,cod_red,des_red FROM dim_red", con=connection2)
	cas_red=pd.merge(cas,red,how='left',on='id_red')
	servicios = pd.read_sql_query(f"SELECT cod_ser,des_ser FROM dim_servicios", con=connection2)

	areas = pd.read_sql_query(f"SELECT cod_are,des_are FROM dim_areas", con=connection2)

	subacti = pd.read_sql_query(f"SELECT cod_act,cod_sub,des_sub FROM dim_subacti", con=connection2)
	subacti = subacti.drop_duplicates(subset=['cod_sub'])

	activi = pd.read_sql_query(f"SELECT cod_act,des_act FROM dim_activi", con=connection2)

	tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)
	tiempo=tiempo.rename(columns={"id_tiempo":"id_time_pro","dt_fecha":"fec_pro","dt_mes":"mes_pro","dt_dia":"dia_pro",	"dt_dia_sem":"dia_sem_pro","dt_sem":"sem_pro","dt_ano":"ano_pro"})

	base1=base2

		
	#RENOMBRAMOS COLUMNAS PARA EL ESSI
	new_columns = {
		'concod': 'cod_con',
		'proconactcod': 'cod_act',
		'proconactespcod': 'cod_sub',
		'proconarehoscod': 'cod_are',
		'proconcancitate': 'cit_ate',
		'proconcanciteli': 'cit_eli',
		'proconcancitrep': 'cit_rep',
		'proconcancupcitdia': 'cup_dia',
		'proconcancupcitref': 'cup_ref',
		'proconcancupcitvol': 'cup_vol',
		'proconcancupinte': 'cup_int',
		'proconcancupreci': 'cup_rec',
		'proconcancuptopadic': 'top_adi',
		'proconcancuptopnuev': 'top_nue',
		'proconcancuptoprefe': 'top_ref',
		'proconcancuptopterc': 'top_ter',
		'proconcandemins': 'dem_ins',
		'proconcanotorcitref': 'oto_ref',
		'proconcanotorcitvol': 'oto_vol',
		'proconcanotorinte': 'oto_int',
		'proconcanotorreci': 'oto_rec',
		'proconcanotortopadic': 'oto_top_adi',
		'proconcanotortopnuev': 'oto_top_nue',
		'proconcanotortoprefe': 'oto_top_ref',
		'proconcanotortopterc': 'oto_top_ter',
		'proconcanpachor': 'pac_hor',
		'proconcenasicod': 'cod_cas',
		'proconestcom': 'est_com',
		'proconestregcod': 'reg_cod',
		'proconfec': 'fec_pro',
		'proconoricenasicod': 'ori_cas',
		'proconperasisdocidennum': 'num_doc',
		'proconservhoscod': 'cod_ser',
		'procontipdocidenpercod': 'tip_doc',
		'proconturhorfin': 'hor_fin',
		'proconturhorini': 'hor_ini'
	}
	base1 = base1.rename(columns=new_columns)


	
	#Traemos las descripciones

	base1['cod_act']=base1['cod_act'].str.strip()
	base1 = pd.merge(base1,activi,how='left', on='cod_act') #Trae des_act


	
	base1.shape

	

	base1['cod_are']=base1['cod_are'].str.strip()
	base1 = pd.merge(base1,areas, how='left', on='cod_are') #Trae des_are
	base1.shape


	
	base1.columns

	
	base1['cod_cas']=base1['cod_cas'].str.strip()
	base1 = pd.merge(base1,cas_red, how='left', on='cod_cas') #Trae 'id_red', 'cod_red', 'des_cas', 'des_red'
	base1.shape

	
	base1 = base1.drop("id_red",axis=1) #Esta columna no la necesitamos en el ESSI
	base1.shape

	
	base1['cod_ser']=base1['cod_ser'].str.strip()
	base1 = pd.merge(base1,servicios,how='left', on='cod_ser') #Trae des_ser
	base1.shape

	
	base1.columns

	
	baseres=base1

	

	base1['cod_sub']=base1['cod_sub'].str.strip()
	base1['cod_act']=base1['cod_act'].str.strip()
	base1 = pd.merge(base1,subacti, how= 'left', on =['cod_act','cod_sub']) #Trae des_sub


	
	base1.shape

	
	tiempo['fec_pro'] = pd.to_datetime(tiempo['fec_pro']) #Convierte fec_pro en un objeto de tipo dato
	base1.shape

	base2=pd.read_sql_query(f"SELECT * FROM {essi} LIMIT 10", con=connection1)

	
	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df2_columns - df1_columns
	different_columns

	borrado = f"DELETE FROM {essi} WHERE {col_essi} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_essi} <= TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection1.execute(borrado)
	
	comunes = set(base1.columns).intersection(set(base2.columns))
	base = base1[list(comunes)]

	
	base.to_sql(name=f'{essi}', con=connection1, if_exists='append', index=False,chunksize=10000)




	tabla='ctpco10'
	col_essi='fec_pro'
	col_tabla='proconfec'
	col_dat='fec_pro'
	dat='dat_cext004_essi'
	essi='essi_dat_cex004_etl'



	base1=base





	base2=pd.read_sql_query(f"SELECT * FROM {dat} LIMIT 10", con=connection2)


	tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)
	tiempo=tiempo.rename(columns={"id_tiempo":"id_time_pro","dt_fecha":"fec_pro","dt_mes":"mes_pro","dt_dia":"dia_pro","dt_dia_sem":"dia_sem_pro","dt_sem":"sem_pro","dt_ano":"ano_pro"})
	base1['fec_pro'] = pd.to_datetime(base1['fec_pro']).dt.date

	base1=pd.merge(base1,tiempo,how='left',on='fec_pro')



	control_a.append(base1.shape[0])


	are = pd.read_sql_query(f"SELECT id_area,cod_are FROM dim_areas", con=connection2)
	merge=pd.merge(base1,are,how='left',on='cod_are')
	base1=pd.merge(base1,are,how='inner',on='cod_are')
	base1.shape


	log_falla('id_area', 'cod_are', True)
	log_control('dim_areas')
	base1=base1.drop('cod_are',axis=1)


	red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)
	merge=pd.merge(base1,red,how='left',on='cod_red')
	base1=pd.merge(base1,red,how='inner',on='cod_red')
	base1.shape


	log_falla('id_red', 'cod_red', True)
	log_control('dim_red')
	base1=base1.drop('cod_red',axis=1)


	consult = pd.read_sql_query(f"SELECT id_consult,cod_cas,cod_con FROM dim_consult", con=connection2)
	consult["KEY"]=consult["cod_con"].str.strip()+consult["cod_cas"].str.strip()
	consult=consult.drop(["cod_con",'cod_cas'], axis=1)
	base1["KEY"]=base1["cod_con"].astype(str).str.strip()+base1['cod_cas'].astype(str).str.strip()
	merge = pd.merge(base1,consult,how='left',on='KEY')
	base1 = pd.merge(base1,consult,how='inner',on='KEY')
	base1=base1.rename(columns={"id_consult":"id_consul"})
	base1.shape


	log_falla('id_consult', 'KEY', True)
	log_control('dim_consult')
	base1=base1.drop('KEY', axis=1)


	cas = pd.read_sql_query(f"SELECT id_cas,cod_cas FROM dim_cas where id_red is not null", con=connection2)
	merge=pd.merge(base1,cas,how='left',on='cod_cas')
	base1=pd.merge(base1,cas,how='inner',on='cod_cas')
	base1.shape


	log_falla('id_cas', 'cod_cas', True)
	log_control('dim_cas')
	base1=base1.drop('cod_cas',axis=1)


	serv= pd.read_sql_query(f"SELECT id_serv,cod_ser FROM dim_servicios", con=connection2)
	merge=pd.merge(base1,serv,how='left',on='cod_ser')
	base1=pd.merge(base1,serv,how='inner',on='cod_ser')
	base1.shape


	log_falla('id_serv', 'cod_ser', True)
	log_control('dim_servicios')
	base1=base1.drop('cod_ser',axis=1)


	oricas = pd.read_sql_query(f"SELECT id_oricas,ori_cod FROM dim_oricas", con=connection2)
	oricas=oricas.rename(columns={"ori_cod":"ori_cas"})
	oricas=oricas.rename(columns={"id_oricas":"id_ori"})
	merge=pd.merge(base1,oricas,how='left',on='ori_cas')
	base1=pd.merge(base1,oricas,how='inner',on='ori_cas')
	base1.shape


	log_falla('id_ori', 'ori_cas', True)
	log_control('dim_oricas')
	base1=base1.drop('ori_cas',axis=1)


	tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
	tipdoc=tipdoc.rename(columns={"cod_tdo":"tip_doc"})
	merge=pd.merge(base1,tipdoc,how='left',on='tip_doc')
	base1=pd.merge(base1,tipdoc,how='inner',on='tip_doc')
	base1.shape


	log_falla('id_tipdoc', 'tip_doc', True)
	log_control('dim_tipdoc')
	base1=base1.drop('tip_doc',axis=1)


	numdoc = pd.read_sql_query(f"SELECT id_person,num_doc FROM dim_personal", con=connection2)
	numdoc=numdoc.drop_duplicates(subset="num_doc")
	numdoc=numdoc.rename(columns={"id_person":"id_persona"})
	merge=pd.merge(base1,numdoc,how='left',on='num_doc')
	base1=pd.merge(base1,numdoc,how='inner',on='num_doc')
	base1.shape


	log_falla('id_persona', 'num_doc', True)
	log_control('dim_personal')
	base1=base1.drop('num_doc',axis=1)


	base1.columns



	subacti = pd.read_sql_query(f"SELECT id_subacti,cod_sub,cod_act FROM dim_subacti", con=connection2)
	subacti["KEY"]=subacti["cod_sub"]+subacti["cod_act"]
	subacti=subacti.drop(["cod_sub",'cod_act'], axis=1)
	base1["KEY"]=base1["cod_sub"].astype(str)+base1['cod_act'].astype(str)
	base1["KEY"]=base1["KEY"].str.replace(' ', '', regex=True)
	subacti["KEY"]=subacti["KEY"].str.replace(' ', '', regex=True)
	merge = pd.merge(base1,subacti,how='left',on='KEY')
	base1 = pd.merge(base1,subacti,how='inner',on='KEY')
	base1.shape


	log_falla('id_subacti', 'KEY', True)
	log_control('dim_subacti')
	base1=base1.drop('KEY', axis=1)


	activi = pd.read_sql_query(f"SELECT id_activi,cod_act FROM dim_activi", con=connection2)
	activi=activi.rename(columns={"id_activi":"id_acti"})
	merge=pd.merge(base1,activi,how='left',on='cod_act')
	base1=pd.merge(base1,activi,how='inner',on='cod_act')
	base1.shape


	log_falla('id_acti', 'cod_act', True)
	log_control('dim_activi')
	base1=base1.drop('cod_act', axis=1)


	base1.columns


	base1['reg_cod']


	estreg = pd.read_sql_query(f"SELECT id_estreg,cod_reg FROM dim_cexestreg", con=connection2)
	estreg=estreg.rename(columns={"cod_reg":"reg_cod"})
	estreg['reg_cod'] = estreg['reg_cod'].str.strip()
	base1['reg_cod']=base1['reg_cod'].str.strip()
	merge=pd.merge(base1,estreg,how='left',on='reg_cod')
	base1=pd.merge(base1,estreg,how='inner',on='reg_cod')
	base1.shape


	log_falla('id_estreg', 'reg_cod', True)
	log_control('dim_cexestreg')
	base1=base1.drop('reg_cod', axis=1)


	id_atecup = pd.read_sql_query(f"SELECT id_atecup,est_com FROM dim_cexatecup", con=connection2)
	merge=pd.merge(base1,id_atecup,how='left',on='est_com')
	base1=pd.merge(base1,id_atecup,how='inner',on='est_com')
	base1.shape


	log_falla('id_atecup', 'est_com', True)
	base1=base1.drop('est_com',axis=1)
	dim.append('dim_cexatecup')
	control_d.append(base1.shape[0])


	base1['horfin']=base1['hor_fin'].astype(str).str[10:16]
	base1['horini']=base1['hor_ini'].astype(str).str[10:16]
	base1['horfin'] = base1['horfin'].str.strip()
	base1['horfin'] = pd.to_datetime(base1['horfin'], format='%H:%M')
	base1['horini'] = base1['horini'].str.strip()
	base1['horini'] = pd.to_datetime(base1['horini'], format='%H:%M')
	base1['diferencia_horas'] = base1['horfin'] - base1['horini']
	base1['horas']=base1['diferencia_horas'].astype(str).str[-9:-6]


	base1.columns






	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df2_columns - df1_columns
	different_columns



	borrando=f"DELETE FROM {dat} WHERE {col_dat} >='{fecha_ini_str}' and {col_dat} <='{fecha_fin_str}'"
	borrado = connection2.execute(borrando)




	comunes = set(base1.columns).intersection(set(base2.columns)) 
	base = base1[list(comunes)]
	base.to_sql(name=f'{dat}', con=engine2, if_exists='append', index=False,chunksize=5000)







	proceso = pd.read_sql_query("SELECT des_mod FROM etl_act where id_mod=6", con=connection2)
	proceso = proceso.iloc[0, 0]
	cod_proceso = pd.read_sql_query("SELECT id_mod FROM etl_act where id_mod=6", con=connection2)
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


	base1


	tabla_logs


	tabla_logs.to_sql(name=f'logs', con=connection4, if_exists='append', index=False,chunksize=10000)


	
	fecha_ini = fecha_fin_mes + datetime.timedelta(days=1)




	finproceso=time.time()
	tiempoproceso=finproceso - inicioTiempo
	tiempoproceso=round(tiempoproceso,3)
	print("Proceso completado satisfactoriamente en " + str(tiempoproceso)+" segundos")




# Cerrar las conexiones cuando hayas terminado
connection1.close()
connection2.close()
connection3.close()

# Liberar los recursos del motor de base de datos
engine1.dispose()
engine2.dispose()
engine3.dispose()