
tabla = 'ctsci10'
col_tabla = 'solcitafec'



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




fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=3", con=connection2)
fecha_ini= fecha_ini.iloc[0, 0]

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=3", con=connection2)
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

	query=f"UPDATE etl_act SET fec_act ='{now}' WHERE id_mod=3"

	c1= text(query)
	connection2.execute(c1)


	#CONEXION A DB ORACLE
	oracledb.init_oracle_client()
	oracledb.version = "8.3.0"
	sys.modules["cx_Oracle"] = oracledb
	un = config("USER4_BDI_POSTGRES")
	pw = config("PASS4_BDI_POSTGRES")
	hostname = config("HOST4_BDI_POSTGRES")
	service_name="WNET"
	port = 1527

	engine0 = create_engine(f'oracle://{un}:{pw}@',connect_args={
			"host": hostname,
			"port": port,
			"service_name": service_name
		}
	)

	connection0 = engine0.connect()

	query = f"SELECT * FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') AND {col_tabla} <= TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	base2 = pd.read_sql_query(query, con=connection0)


	connection0.close()
	engine0.dispose()


	base2.shape


	


	base2.to_sql(name=f'tmp_{tabla}', con=engine3, if_exists='replace', index=False)




	borrado = f"DELETE FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} <= TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection3.execute(borrado)



	query = f"""
	ALTER TABLE tmp_{tabla}
	ALTER COLUMN solcitanum TYPE numeric(10,0) USING solcitanum::numeric(10,0),
	ALTER COLUMN solcitafec TYPE date USING solcitafec::date,
	ALTER COLUMN solcitaoricenasicod TYPE character(1),
	ALTER COLUMN solcitacenasicod TYPE character(3),
	ALTER COLUMN solcitapacsecnum TYPE numeric(10,0)  USING solcitapacsecnum::numeric(10,0),
	ALTER COLUMN solcitaarehoscod TYPE character(2),
	ALTER COLUMN solcitaservhoscod TYPE character(3),
	ALTER COLUMN solcitaactcod TYPE character(2),
	ALTER COLUMN solcitaactespcod TYPE character(3),
	ALTER COLUMN solcitatipocitacod TYPE character(1),
	ALTER COLUMN solcitafecpref TYPE date USING solcitafecpref::date,
	ALTER COLUMN diaprefsolcitcod TYPE character(1),
	ALTER COLUMN turprefsolcitacod TYPE character(1),
	ALTER COLUMN estatensolcitacod TYPE character(1),
	ALTER COLUMN solcitaoricenasioricod TYPE character(1),
	ALTER COLUMN solcitacenasioricod TYPE character(3),
	ALTER COLUMN solcitaactmedorinum TYPE numeric(10,0) USING solcitaactmedorinum::numeric(10,0),
	ALTER COLUMN solcitaoricenasicitcod TYPE character(1),
	ALTER COLUMN solcitacenasicitcod TYPE character(3),
	ALTER COLUMN solcitaactmedcitnum TYPE numeric(10,0) USING solcitaactmedcitnum::numeric(10,0),
	ALTER COLUMN solcitaestregcod TYPE character(1),
	ALTER COLUMN solcitausucrecod TYPE character(10),
	ALTER COLUMN solcitacrefec TYPE timestamp USING solcitacrefec::timestamp without time zone,
	ALTER COLUMN solcitausumodcod TYPE character(10),
	ALTER COLUMN solcitamodfec TYPE timestamp USING solcitamodfec::timestamp without time zone,
	ALTER COLUMN solcitapricod TYPE numeric(1,0) USING solcitapricod::numeric(1,0),
	ALTER COLUMN solcitaipcrecod TYPE character(15),
	ALTER COLUMN solcitausuanucod TYPE character(10),
	ALTER COLUMN solcitaipanucod TYPE character(15),
	ALTER COLUMN solcitafecanu TYPE timestamp USING solcitafecanu::timestamp without time zone,
	ALTER COLUMN solcitaipmodcod TYPE character(15),
	ALTER COLUMN solcitamodcrecod TYPE character(1),
	ALTER COLUMN solcitamodanucod TYPE character(1),
	ALTER COLUMN solcitamodmodcod TYPE character(1),
	ALTER COLUMN solcitasecnum TYPE numeric(4,0) USING solcitasecnum::numeric(4,0),
	ALTER COLUMN solcitacpscod TYPE character(10),
	ALTER COLUMN solcitatramedfissolnum TYPE numeric(10,0) USING solcitatramedfissolnum::numeric(10,0),
	ALTER COLUMN solcitatiptercod TYPE character(2);

	INSERT INTO {tabla} 
	(solcitanum,solcitafec,solcitaoricenasicod,solcitacenasicod,solcitapacsecnum,solcitaarehoscod,solcitaservhoscod,solcitaactcod,solcitaactespcod,solcitatipocitacod,solcitafecpref,diaprefsolcitcod,turprefsolcitacod,estatensolcitacod,solcitaoricenasioricod,solcitacenasioricod,solcitaactmedorinum,solcitaoricenasicitcod,solcitacenasicitcod,solcitaactmedcitnum,solcitaestregcod,solcitausucrecod,solcitacrefec,solcitausumodcod,solcitamodfec,solcitapricod,solcitaipcrecod,solcitausuanucod,solcitaipanucod,solcitafecanu,solcitaipmodcod,solcitamodcrecod,solcitamodanucod,solcitamodmodcod,solcitasecnum,solcitacpscod,solcitatramedfissolnum,solcitatiptercod)

	SELECT 
	solcitanum,solcitafec,solcitaoricenasicod,solcitacenasicod,solcitapacsecnum,solcitaarehoscod,solcitaservhoscod,solcitaactcod,solcitaactespcod,solcitatipocitacod,solcitafecpref,diaprefsolcitcod,turprefsolcitacod,estatensolcitacod,solcitaoricenasioricod,solcitacenasioricod,solcitaactmedorinum,solcitaoricenasicitcod,solcitacenasicitcod,solcitaactmedcitnum,solcitaestregcod,solcitausucrecod,solcitacrefec,solcitausumodcod,solcitamodfec,solcitapricod,solcitaipcrecod,solcitausuanucod,solcitaipanucod,solcitafecanu,solcitaipmodcod,solcitamodcrecod,solcitamodanucod,solcitamodmodcod,solcitasecnum,solcitacpscod,solcitatramedfissolnum,solcitatiptercod


	FROM tmp_{tabla};
	"""

	c1= text(query)
	connection3.execute(c1)




	query2=f"""
	DROP TABLE tmp_{tabla};
	"""
	c2= text(query2)
	cursor=connection3.execute(c2)


	finproceso=time.time()
	tiempoproceso=finproceso - inicioTiempo
	tiempoproceso=round(tiempoproceso,3)
	print("Proceso completado satisfactoriamente en " + str(tiempoproceso)+" segundos")



	tabla='ctsci10'
	col_essi='fec_sol'
	col_tabla='solcitafec'
	essi='essi_dat_cex003_etl'

	base1=base2
	
	base1 = base1.rename(columns={
		'estatensolcitacod': 'cod_est',
		'solcitaactcod': 'cod_act',
		'solcitaactespcod': 'cod_sub',
		'solcitaactmedcitnum': 'act_med',
		'solcitaactmedorinum': 'act_med_ori',
		'solcitaarehoscod': 'cod_are',
		'solcitacenasicitcod': 'cas_sol',
		'solcitacenasicod': 'cod_cas',
		'solcitacenasioricod': 'cas_sol_ori',
		'solcitacpscod': 'cod_cps',
		'solcitacrefec': 'fec_cre',
		'solcitaestregcod': 'est_reg',
		'solcitafec': 'fec_sol',
		'solcitafecanu': 'fec_anu',
		'solcitafecpref': 'fec_pre',
		'solcitaipanucod': 'ip_anu',
		'solcitaipcrecod': 'ip_cre',
		'solcitaipmodcod': 'ip_mod',
		'solcitamodanucod': 'mod_anu',
		'solcitamodcrecod': 'mod_cre',
		'solcitamodfec': 'fec_mod',
		'solcitamodmodcod': 'mod_mod',
		'solcitanum': 'num_sol',
		'solcitaoricenasicitcod': 'ori_sol',
		'solcitaoricenasicod': 'ori_cas',
		'solcitaoricenasioricod': 'ori_sol_ori',
		'solcitapacsecnum': 'pac_sec',
		'solcitapricod': 'cod_pri',
		'solcitasecnum': 'sec_num',
		'solcitaservhoscod': 'cod_ser',
		'solcitatipocitacod': 'cod_tci',
		'solcitatiptercod': 'tip_ter',
		'solcitatramedfissolnum': 'med_fis',
		'solcitausuanucod': 'usu_anu',
		'solcitausucrecod': 'usu_cre',
		'solcitausumodcod': 'usu_mod',
		'turprefsolcitacod': 'cod_tpc',
		'diaprefsolcitcod': 'cod_dpc'
	})

	
	base2=pd.read_sql_query(f"SELECT * FROM {essi} LIMIT 10", con=connection1)

	
	# Cargar los DataFrames en las tablas temporales usando pd.to_sql
	cas = pd.read_sql_query(f"SELECT id_red,cod_cas,des_cas FROM dim_cas where id_red is not null", con=connection2)
	red = pd.read_sql_query(f"SELECT id_red,cod_red,des_red FROM dim_red", con=connection2)
	cas_red=pd.merge(cas,red,how='left',on='id_red')
	base1 = pd.merge(base1, cas_red, how='inner', on='cod_cas')

	
	servicios = pd.read_sql_query(f"SELECT cod_ser,des_ser FROM dim_servicios", con=connection2)
	base1 = pd.merge(base1, servicios, how='inner', on='cod_ser')


	
	areas = pd.read_sql_query(f"SELECT cod_are,des_are FROM dim_areas", con=connection2)
	base1 = pd.merge(base1, areas, how='inner', on='cod_are')


	
	subacti = pd.read_sql_query(f"SELECT des_sub,cod_sub,cod_act FROM dim_subacti", con=connection2)
	subacti["KEY"]=subacti["cod_sub"]+subacti["cod_act"]
	subacti=subacti.drop(["cod_sub",'cod_act'], axis=1)
	base1["KEY"]=base1["cod_sub"].astype(str)+base1['cod_act'].astype(str)
	base1["KEY"]=base1["KEY"].str.replace(' ', '', regex=True)
	subacti["KEY"]=subacti["KEY"].str.replace(' ', '', regex=True)
	base1 = pd.merge(base1,subacti,how='inner',on='KEY')
	base1=base1.drop('KEY', axis=1)


	
	activi = pd.read_sql_query(f"SELECT cod_act,des_act FROM dim_activi", con=connection2)
	base1 = pd.merge(base1, activi, how='inner', on='cod_act')

	
	tipcit = pd.read_sql_query(f"SELECT cod_tci,des_tci FROM dim_tipcit", con=connection2)
	base1 = pd.merge(base1, tipcit, how='inner', on='cod_tci')


	
	cexdiapresol = pd.read_sql_query(f"SELECT cod_dps,des_dps FROM dim_cexdiapresol", con=connection2)
	cexdiapresol = cexdiapresol.rename(columns={'cod_dps':'cod_dpc'})
	cexdiapresol = cexdiapresol.rename(columns={'des_dps':'des_dpc'})
	base1 = pd.merge(base1, cexdiapresol, how='inner', on='cod_dpc')


	cexestreg = pd.read_sql_query(f"SELECT cod_reg,des_reg FROM dim_cexestreg", con=connection2)
	cexestreg = cexestreg.rename(columns={'cod_reg':'est_reg'})
	base1 = pd.merge(base1, cexestreg, how='inner', on='est_reg')

	
	cexestsolcit = pd.read_sql_query(f"SELECT cod_esc,des_esc FROM dim_cexestsolcit", con=connection2)
	cexestsolcit = cexestsolcit.rename(columns={'cod_esc':'cod_est'})
	cexestsolcit = cexestsolcit.rename(columns={'des_esc':'des_est'})
	base1 = pd.merge(base1, cexestsolcit, how='inner', on='cod_est')


	cexprisol = pd.read_sql_query(f"SELECT cod_pri,des_pr1 FROM dim_cexprisol", con=connection2)
	cexprisol = cexprisol.rename(columns={'des_pr1':'des_pri'})
	cexprisol['cod_pri']= cexprisol['cod_pri'].astype(int)
	base1 = pd.merge(base1, cexprisol, how='inner', on='cod_pri')
	
	cexturprecit = pd.read_sql_query(f"SELECT cod_tpc,des_tpc FROM dim_cexturprecit", con=connection2)
	base1 = pd.merge(base1, cexturprecit, how='inner', on='cod_tpc')

	
	cas = cas.rename(columns={'cod_cas':'cas_sol'})
	cas = cas.rename(columns={'des_cas':'des_cso'})
	cas = cas.dropna()
	base1 = pd.merge(base1, cas, how='left', on='cas_sol')

	
	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df2_columns - df1_columns
	different_columns

	borrado = f"DELETE FROM {essi} WHERE {col_essi} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_essi} <= TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection1.execute(borrado)
	
	comunes = set(base1.columns).intersection(set(base2.columns)) 
	base = base1[list(comunes)]
	

	base.to_sql(name=f'{essi}', con=connection1, if_exists='append', index=False,chunksize=5000)

	base1 = base

	
	finproceso=time.time()
	tiempoproceso=finproceso - inicioTiempo
	tiempoproceso=round(tiempoproceso,3)
	print("Proceso completado satisfactoriamente en " + str(tiempoproceso)+" segundos")



	tabla='ctsci10'
	col_essi='fec_sol'
	col_tabla='solcitafec'
	essi='essi_dat_cex003_etl'
	col_dat='fec_sol'
	dat='dat_cext003_essi'



	base2=pd.read_sql_query(f"SELECT * FROM {dat} LIMIT 10", con=connection2)




	tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)
	tiempo = tiempo.rename(columns={"id_tiempo":"id_time_sol","dt_fecha":"fec_sol","dt_mes":"mes_sol","dt_dia":"dia_sol","dt_dia_sem":"dia_sem_sol","dt_sem":"sem_sol","dt_ano":"ano_sol"})
	base1['fec_sol'] = pd.to_datetime(base1['fec_sol'], errors='coerce').dt.date
	base1 = pd.merge(base1, tiempo, how='left', on='fec_sol')

	tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)
	tiempo = tiempo.rename(columns={"id_tiempo":"id_time_pre","dt_fecha":"fec_pre","dt_mes":"mes_pre","dt_dia":"dia_pre","dt_dia_sem":"dia_sem_pre","dt_sem":"sem_pre","dt_ano":"ano_pre"})
	base1['fec_pre'] = pd.to_datetime(base1['fec_pre'], errors='coerce').fillna(base1['fec_sol']).dt.date


	base1=pd.merge(base1,tiempo,how='left',on='fec_pre')




	base1['fec_cre_temp']=base1['fec_cre']
	base1['fec_mod_temp']=base1['fec_mod']
	base1['fec_anu_temp']=base1['fec_anu']

	tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)
	tiempo=tiempo.rename(columns={"id_tiempo":"id_time_cre","dt_fecha":"fec_cre","dt_mes":"mes_cre","dt_dia":"dia_cre","dt_dia_sem":"dia_sem_cre","dt_sem":"sem_cre","dt_ano":"ano_cre"})
	base1['fec_cre'] = pd.to_datetime(base1['fec_cre'], errors='coerce').dt.date.astype(str)
	base1=pd.merge(base1,tiempo,how='left',on='fec_cre')


	tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)
	tiempo=tiempo.rename(columns={"id_tiempo":"id_time_mod","dt_fecha":"fec_mod","dt_mes":"mes_mod","dt_dia":"dia_mod","dt_dia_sem":"dia_sem_mod","dt_sem":"sem_mod","dt_ano":"ano_mod"})
	base1['fec_mod'] = pd.to_datetime(base1['fec_mod'], errors='coerce').dt.date.astype(str)
	base1=pd.merge(base1,tiempo,how='left',on='fec_mod')


	tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)
	tiempo=tiempo.rename(columns={"id_tiempo":"id_time_anu","dt_fecha":"fec_anu","dt_mes":"mes_anu","dt_dia":"dia_anu","dt_dia_sem":"dia_sem_anu","dt_sem":"sem_anu","dt_ano":"ano_anu"})
	base1['fec_anu'] = pd.to_datetime(base1['fec_anu'], errors='coerce').dt.date.astype(str)
	base1=pd.merge(base1,tiempo,how='left',on='fec_anu')

	base1['fec_cre'] = base1['fec_cre_temp']
	base1['fec_mod'] = base1['fec_mod_temp']
	base1['fec_anu'] = base1['fec_anu_temp']

	base1['fec_cre'] = pd.to_datetime(base1['fec_cre'], errors='coerce')
	base1['fec_mod'] = pd.to_datetime(base1['fec_mod'], errors='coerce')
	base1['fec_anu'] = pd.to_datetime(base1['fec_anu'], errors='coerce')

	base1 = base1.drop('fec_cre_temp', axis=1)
	base1 = base1.drop('fec_mod_temp', axis=1)
	base1 = base1.drop('fec_anu_temp', axis=1)


	oricas = pd.read_sql_query(f"SELECT id_oricas,ori_cod FROM dim_oricas", con=connection2)
	oricas=oricas.rename(columns={"ori_cod":"ori_cas"})
	merge=pd.merge(base1,oricas,how='left',on='ori_cas')
	base1=pd.merge(base1,oricas,how='inner',on='ori_cas')


	base1=base1.drop('ori_cas',axis=1)


	cas = pd.read_sql_query(f"SELECT id_cas,cod_cas FROM dim_cas where id_red is not null", con=connection2)
	cas = cas.dropna()
	merge=pd.merge(base1,cas,how='left',on='cod_cas')
	base1=pd.merge(base1,cas,how='inner',on='cod_cas')

	base1=base1.drop('cod_cas',axis=1)


	red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)
	merge=pd.merge(base1,red,how='left',on='cod_red')
	base1=pd.merge(base1,red,how='inner',on='cod_red')

	base1=base1.drop('cod_red',axis=1)


	base1 = base1.rename(columns={'pac_sec':'id_pacsec'})

	are = pd.read_sql_query(f"SELECT id_area,cod_are FROM dim_areas", con=connection2)
	merge=pd.merge(base1,are,how='left',on='cod_are')
	base1=pd.merge(base1,are,how='inner',on='cod_are')

	base1=base1.drop('cod_are',axis=1)


	serv= pd.read_sql_query(f"SELECT id_serv,cod_ser FROM dim_servicios", con=connection2)
	merge=pd.merge(base1,serv,how='left',on='cod_ser')
	base1=pd.merge(base1,serv,how='inner',on='cod_ser')


	base1=base1.drop('cod_ser',axis=1)


	activi = pd.read_sql_query(f"SELECT id_activi,cod_act FROM dim_activi", con=connection2)
	merge=pd.merge(base1,activi,how='left',on='cod_act')
	base1=pd.merge(base1,activi,how='inner',on='cod_act')

	subacti = pd.read_sql_query(f"SELECT id_subacti,cod_sub,cod_act FROM dim_subacti", con=connection2)
	subacti["KEY"]=subacti["cod_sub"]+subacti["cod_act"]
	subacti=subacti.drop(["cod_sub",'cod_act'], axis=1)
	base1["KEY"]=base1["cod_sub"].astype(str)+base1['cod_act'].astype(str)
	base1["KEY"]=base1["KEY"].str.replace(' ', '', regex=True)
	subacti["KEY"]=subacti["KEY"].str.replace(' ', '', regex=True)
	merge = pd.merge(base1,subacti,how='left',on='KEY')
	base1 = pd.merge(base1,subacti,how='inner',on='KEY')

	base1=base1.drop('KEY', axis=1)
	base1=base1.drop('cod_act', axis=1)


	tipcit = pd.read_sql_query(f"SELECT id_tipcit,cod_tci FROM dim_tipcit", con=connection2)
	tipcit = tipcit.rename(columns={'id_tipcit':'id_tci'})
	merge=pd.merge(base1,tipcit,how='left',on='cod_tci')
	base1=pd.merge(base1,tipcit,how='inner',on='cod_tci')

	base1=base1.drop('cod_tci', axis=1)


	diapresol = pd.read_sql_query(f"SELECT id_diapre,cod_dps FROM dim_cexdiapresol", con=connection2)
	diapresol = diapresol.rename(columns={'cod_dps':'cod_dpc'})
	diapresol = diapresol.rename(columns={'id_diapre':'id_dpc'})
	merge=pd.merge(base1,diapresol,how='left',on='cod_dpc')
	base1=pd.merge(base1,diapresol,how='inner',on='cod_dpc')

	base1=base1.drop('cod_dpc', axis=1)


	turprecit = pd.read_sql_query(f"SELECT id_turpre,cod_tpc FROM dim_cexturprecit", con=connection2)
	turprecit = turprecit.rename(columns={'id_turpre':'id_tpc'})
	merge=pd.merge(base1,turprecit,how='left',on='cod_tpc')
	base1=pd.merge(base1,turprecit,how='inner',on='cod_tpc')

	base1=base1.drop('cod_tpc', axis=1)


	estsolcit = pd.read_sql_query(f"SELECT id_estsolcit,cod_esc FROM dim_cexestsolcit", con=connection2)
	estsolcit = estsolcit.rename(columns={'id_estsolcit':'id_estado'})
	estsolcit = estsolcit.rename(columns={'cod_esc':'cod_est'})
	merge=pd.merge(base1,estsolcit,how='left',on='cod_est')
	base1=pd.merge(base1,estsolcit,how='inner',on='cod_est')

	base1=base1.drop('cod_est', axis=1)


	orisol = pd.read_sql_query(f"SELECT id_oricas,ori_cod FROM dim_oricas", con=connection2)
	orisol=orisol.rename(columns={"id_oricas":"id_orisol"})
	orisol=orisol.rename(columns={"ori_cod":"ori_sol"})
	merge=pd.merge(base1,orisol,how='left',on='ori_sol')
	base1=pd.merge(base1,orisol,how='left',on='ori_sol')

	base1=base1.drop('ori_sol',axis=1)


	cassol = pd.read_sql_query(f"SELECT id_cas,cod_cas FROM dim_cas where id_red is not null", con=connection2)
	cassol = cassol.dropna()
	cassol=cassol.rename(columns={"id_cas":"id_cassol"})
	cassol=cassol.rename(columns={"cod_cas":"cas_sol"})
	merge=pd.merge(base1,cassol,how='left',on='cas_sol')
	base1=pd.merge(base1,cassol,how='left',on='cas_sol')

	base1=base1.drop('cas_sol',axis=1)


	estreg = pd.read_sql_query(f"SELECT id_estreg,cod_reg FROM dim_cexestreg", con=connection2)
	estreg = estreg.rename(columns={"cod_reg":"est_reg"})
	merge=pd.merge(base1,estreg,how='left',on='est_reg')
	base1=pd.merge(base1,estreg,how='inner',on='est_reg')
	base1.shape

	base1=base1.drop('est_reg', axis=1)


	numdoc = pd.read_sql_query(f"SELECT id_person, num_doc FROM dim_personal", con=connection2)
	numdoc=numdoc.drop_duplicates(subset="num_doc")
	numdoc=numdoc.rename(columns={"num_doc":"usu_cre"})
	numdoc=numdoc.rename(columns={"id_person":"id_usucre"})
	merge=pd.merge(base1,numdoc,how='left',on='usu_cre')
	base1=pd.merge(base1,numdoc,how='left',on='usu_cre')
	base1.shape

	base1=base1.drop('usu_cre',axis=1)


	numdoc = pd.read_sql_query(f"SELECT id_person, num_doc FROM dim_personal", con=connection2)
	numdoc=numdoc.drop_duplicates(subset="num_doc")
	numdoc=numdoc.rename(columns={"num_doc":"usu_mod"})
	numdoc=numdoc.rename(columns={"id_person":"id_usumod"})
	merge=pd.merge(base1,numdoc,how='left',on='usu_mod')
	base1=pd.merge(base1,numdoc,how='left',on='usu_mod')
	base1.shape

	base1=base1.drop('usu_mod',axis=1)


	numdoc = pd.read_sql_query(f"SELECT id_person, num_doc FROM dim_personal", con=connection2)
	numdoc=numdoc.drop_duplicates(subset="num_doc")
	numdoc=numdoc.rename(columns={"num_doc":"usu_anu"})
	numdoc=numdoc.rename(columns={"id_person":"id_asuanu"})
	merge=pd.merge(base1,numdoc,how='left',on='usu_anu')
	base1=pd.merge(base1,numdoc,how='left',on='usu_anu')
	base1.shape

	base1=base1.drop('usu_anu',axis=1)


	prisol = pd.read_sql_query(f"SELECT id_prisol,cod_pri FROM dim_cexprisol", con=connection2)
	prisol=prisol.rename(columns={"id_prisol":"id_priori"})
	prisol['cod_pri'] = prisol['cod_pri'].astype(int)

	merge=pd.merge(base1,prisol,how='left',on='cod_pri')
	base1=pd.merge(base1,prisol,how='inner',on='cod_pri')
	base1.shape

	base1=base1.drop('cod_pri', axis=1)


	base1=base1.rename(columns={"mod_cre":"id_crea"})
	base1=base1.rename(columns={"mod_anu":"id_anula"})
	base1=base1.rename(columns={"mod_mod":"id_modif"})


	cps = pd.read_sql_query(f"SELECT id_cps,cod_cps FROM dim_cps", con=connection2)
	cps=cps.rename(columns={"id_prisol":"id_priori"})
	merge=pd.merge(base1,cps,how='left',on='cod_cps')
	base1=pd.merge(base1,cps,how='left',on='cod_cps')

	base1=base1.drop('cod_cps',axis=1)



	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df2_columns - df1_columns
	different_columns

	borrando=f"DELETE FROM {dat} WHERE {col_dat} >='{fecha_ini_str}' and {col_dat} <='{fecha_fin_str}'"
	borrado = connection2.execute(borrando)



	comunes = set(base1.columns).intersection(set(base2.columns)) 
	base = base1[list(comunes)]
	base.to_sql(name=f'{dat}', con=engine2, if_exists='append', index=False,chunksize=5000)

	proceso = pd.read_sql_query("SELECT des_mod FROM etl_act where id_mod=3", con=connection2)
	proceso = proceso.iloc[0, 0]
	cod_proceso = pd.read_sql_query("SELECT id_mod FROM etl_act where id_mod=3", con=connection2)
	cod_proceso = cod_proceso.iloc[0, 0]

	now_fin = datetime.datetime.now()

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