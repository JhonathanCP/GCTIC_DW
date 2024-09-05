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

fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=2", con=connection2)
fecha_ini= fecha_ini.iloc[0, 0]

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=2", con=connection2)
fecha_fin= fecha_fin.iloc[0, 0]

dias_por_intervalo = 5

# Inicializa la fecha actual
fecha_actual = fecha_ini

for i in range(0, (fecha_fin - fecha_ini).days + 1, dias_por_intervalo):
	inicioTiempo = time.time()
	now_inicio = datetime.now()

	fecha_ini_intervalo = fecha_actual

	fecha_fin_intervalo = fecha_actual + timedelta(days=dias_por_intervalo - 1)

	fecha_ini_str = fecha_ini_intervalo.strftime('%Y-%m-%d')	
	fecha_fin_str = fecha_fin_intervalo.strftime('%Y-%m-%d')

	print(f"Procesando de {fecha_ini_str} al {fecha_fin_str}")

	now1 = datetime.now()
	now2 = datetime.now().strftime('%Y-%m-%d')

	query=f"UPDATE etl_act SET fec_act ='{now1}' WHERE id_mod=2"

	c1= text(query)
	connection2.execute(c1)

	tabla='ctcam10'
	col_tabla='citambproconfec'

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

	query = f"""SELECT c.* FROM {tabla} c WHERE c.{col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') AND c.{col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"""
	base2 = pd.read_sql_query(query, con=connection0)

	connection0.close()
	
	base2.to_sql(name=f'tmp_{tabla}', con=engine3, if_exists='replace', index=False)

	borrado = f"DELETE FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection3.execute(borrado)

	query=f"""

	ALTER TABLE tmp_{tabla} 
	ALTER COLUMN citamboricenasicod TYPE character(1),
	ALTER COLUMN citambcenasicod TYPE character(3),
	ALTER COLUMN citambnum TYPE numeric(10,0) USING citambnum::numeric(10,0),
	ALTER COLUMN citambproconoricenasicod TYPE character(1),
	ALTER COLUMN citambproconcenasicod TYPE character(3),
	ALTER COLUMN citambarehoscod TYPE character(2),
	ALTER COLUMN citambservhoscod TYPE character(3),
	ALTER COLUMN citambactcod TYPE character(2),
	ALTER COLUMN citambactespcod TYPE character(3),
	ALTER COLUMN citambtipdocidenpercod TYPE character(1),
	ALTER COLUMN citambperasisdocidennum TYPE character(10),
	ALTER COLUMN citambproconfec TYPE timestamp USING citambproconfec::timestamp without time zone,
	ALTER COLUMN citambproconturhorini TYPE timestamp USING citambproconturhorini::timestamp without time zone,
	ALTER COLUMN citambproconturhorfin TYPE timestamp USING citambproconturhorfin::timestamp without time zone,
	ALTER COLUMN tipocitacod TYPE character(1),
	ALTER COLUMN condcitacod TYPE character(1),
	ALTER COLUMN modotorcitacod TYPE character(1),
	ALTER COLUMN citambnumord TYPE numeric(3,0) USING citambnumord::numeric(3,0),
	ALTER COLUMN citambhorcit TYPE timestamp USING citambhorcit::timestamp without time zone,
	ALTER COLUMN citambrep TYPE character(1),
	ALTER COLUMN motelicitcod TYPE character(2),
	ALTER COLUMN estcitcod TYPE character(1),
	ALTER COLUMN estcitotocod TYPE character(1),
	ALTER COLUMN citambusucrecod TYPE character(10),
	ALTER COLUMN citambcrefec TYPE timestamp USING citambcrefec::timestamp without time zone,
	ALTER COLUMN citambusumodcod TYPE character(10),
	ALTER COLUMN citambmodfec TYPE timestamp USING citambmodfec::timestamp without time zone, 
	ALTER COLUMN citambsolfec TYPE timestamp USING citambsolfec::timestamp without time zone,
	ALTER COLUMN citambipcrecod TYPE character(15),
	ALTER COLUMN citambipmodcod TYPE character(15),
	ALTER COLUMN motinacitdes TYPE character(110),
	ALTER COLUMN citambpacsecnum TYPE numeric(10,0) USING citambpacsecnum::numeric(10,0),
	ALTER COLUMN citambusuanucod TYPE character(10),
	ALTER COLUMN citambanufec TYPE date USING citambanufec::date,
	ALTER COLUMN citambipanucod TYPE character(15),
	ALTER COLUMN citambmodanucod TYPE character(1),
	ALTER COLUMN citambestctrlseg TYPE character(1),
	ALTER COLUMN citambcnvespcod TYPE numeric(3,0) USING citambcnvespcod::numeric(3,0);

	INSERT INTO {tabla} 
	(citamboricenasicod,citambcenasicod,citambnum,citambproconoricenasicod,citambproconcenasicod,citambarehoscod,citambservhoscod,citambactcod,citambactespcod,citambtipdocidenpercod,citambperasisdocidennum,citambproconfec,citambproconturhorini,citambproconturhorfin,tipocitacod,condcitacod,modotorcitacod,citambnumord,citambhorcit,citambrep,motelicitcod,estcitcod,estcitotocod,citambusucrecod,citambcrefec,citambusumodcod,citambmodfec,citambsolfec,citambipcrecod,citambipmodcod,motinacitdes,citambpacsecnum,citambusuanucod,citambanufec,citambipanucod,citambmodanucod,citambestctrlseg,citambcnvespcod) 

	SELECT 
	citamboricenasicod,citambcenasicod,citambnum,citambproconoricenasicod,citambproconcenasicod,citambarehoscod,citambservhoscod,citambactcod,citambactespcod,citambtipdocidenpercod,citambperasisdocidennum,citambproconfec,citambproconturhorini,citambproconturhorfin,tipocitacod,condcitacod,modotorcitacod,citambnumord,citambhorcit,citambrep,motelicitcod,estcitcod,estcitotocod,citambusucrecod,citambcrefec,citambusumodcod,citambmodfec,citambsolfec,citambipcrecod,citambipmodcod,motinacitdes,citambpacsecnum,citambusuanucod,citambanufec,citambipanucod,citambmodanucod,citambestctrlseg,citambcnvespcod

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

	finproceso=time.time()
	tiempoproceso=finproceso - inicioTiempo
	tiempoproceso=round(tiempoproceso,3)
	print("Proceso completado satisfactoriamente en " + str(tiempoproceso)+" segundos")

	tabla='ctcam10'
	col_essi='fec_cit'
	col_tabla='citambproconfec'
	essi='essi_dat_cex001_etl'
	
	base2 = base2.rename(columns={
		'citamboricenasicod': 'cod_ori',
		'citambcenasicod': 'cod_cas',
		'citambnum': 'cit_num',
		'citambproconoricenasicod': 'cod_ori_pro',
		'citambproconcenasicod': 'cod_cas_pro',
		'citambarehoscod': 'cod_are',
		'citambservhoscod': 'cod_ser',
		'citambactcod': 'cod_act',
		'citambactespcod': 'cod_sub',
		'citambtipdocidenpercod': 'cod_tdo',
		'citambperasisdocidennum': 'num_doc_med',
		'citambproconfec': 'fec_cit',
		'citambproconturhorini': 'hor_ini',
		'citambproconturhorfin': 'hor_fin',
		'tipocitacod': 'cod_tci',
		'condcitacod': 'cod_cci',
		'modotorcitacod': 'cod_mot',
		'citambnumord': 'ord_cit',
		'citambhorcit': 'hor_cit',
		'citambrep': 'cit_rep',
		'motelicitcod': 'cod_moteli',
		'estcitcod': 'cod_eci',
		'estcitotocod': 'cod_enco',
		'citambusucrecod': 'usu_cre',
		'citambcrefec': 'fec_cre',
		'citambusumodcod': 'usu_mod',
		'citambmodfec': 'fec_mod',
		'citambsolfec': 'fec_sol',
		'citambipcrecod': 'ip_cre',
		'citambipmodcod': 'ip_mod',
		'motinacitdes': 'mot_cit',
		'citambpacsecnum': 'pac_sec',
		'citambusuanucod': 'usu_anu',
		'citambanufec': 'fec_anu',
		'citambipanucod': 'ip_anu',
		'citambmodanucod': 'mod_anu',
		'citambestctrlseg': 'ctr_seg',
		'citambcnvespcod': 'cnv_esp'

	})
	
	base1=base2

	tabla='ctcam10'
	col_essi='fec_cit'
	essi='essi_dat_cex001_etl'
	col_dat='fec_cit'
	dat='dat_cext001_essi'
	
	base2=pd.read_sql_query(f"SELECT * FROM {dat} LIMIT 10", con=connection2)
	
	oricas = pd.read_sql_query(f"SELECT id_oricas,ori_cod FROM dim_oricas", con=connection2)
	oricas=oricas.rename(columns={"ori_cod":"cod_ori"})
	base1=pd.merge(base1,oricas,how='left',on='cod_ori')

	base1=base1.drop('cod_ori',axis=1)
	
	cas = pd.read_sql_query(f"SELECT id_cas,cod_cas, cod_red FROM dim_cas where id_red is not null", con=connection2)
	cas = cas.dropna()
	base1=pd.merge(base1,cas,how='left',on='cod_cas')

	base1=base1.drop('cod_cas',axis=1)
	
	red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)
	base1=pd.merge(base1,red,how='left',on='cod_red')

	base1=base1.drop('cod_red',axis=1)
	
	oripro = pd.read_sql_query(f"SELECT id_oricas,ori_cod FROM dim_oricas", con=connection2)
	oripro=oripro.rename(columns={"ori_cod":"cod_ori_pro"})
	oripro=oripro.rename(columns={"id_oricas":"id_oripro"})
	base1=pd.merge(base1,oripro,how='left',on='cod_ori_pro')

	base1=base1.drop('cod_ori_pro',axis=1)
	
	caspro = pd.read_sql_query(f"SELECT id_cas,cod_cas FROM dim_cas where id_red is not null", con=connection2)
	caspro = caspro.dropna()
	caspro=caspro.rename(columns={"id_cas":"id_caspro"})
	caspro=caspro.rename(columns={"cod_cas":"cod_cas_pro"})
	base1=pd.merge(base1,caspro,how='left',on='cod_cas_pro')

	base1=base1.drop('cod_cas_pro',axis=1)
	
	are = pd.read_sql_query(f"SELECT id_area,cod_are FROM dim_areas", con=connection2)
	base1=pd.merge(base1,are,how='left',on='cod_are')

	base1=base1.drop('cod_are',axis=1)
	
	serv= pd.read_sql_query(f"SELECT id_serv,cod_ser FROM dim_servicios", con=connection2)
	base1=pd.merge(base1,serv,how='left',on='cod_ser')

	base1=base1.drop('cod_ser',axis=1)
	
	activi = pd.read_sql_query(f"SELECT id_activi,cod_act FROM dim_activi", con=connection2)
	activi=activi.rename(columns={"id_activi":"id_acti"})
	base1=pd.merge(base1,activi,how='left',on='cod_act')
	
	subacti = pd.read_sql_query(f"SELECT id_subacti,cod_sub,cod_act FROM dim_subacti", con=connection2)
	subacti["KEY"]=subacti["cod_sub"]+subacti["cod_act"]
	subacti=subacti.drop(["cod_sub",'cod_act'], axis=1)
	base1["KEY"]=base1["cod_sub"].astype(str)+base1['cod_act'].astype(str)
	base1["KEY"]=base1["KEY"].str.replace(' ', '', regex=True)
	subacti["KEY"]=subacti["KEY"].str.replace(' ', '', regex=True)
	base1 = pd.merge(base1,subacti,how='left',on='KEY')

	base1=base1.drop('KEY', axis=1)
	base1=base1.drop('cod_act',axis=1)
	
	tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
	tipdoc=tipdoc.rename(columns={"id_tipdoc":"id_tdi_med"})
	base1=pd.merge(base1,tipdoc,how='left',on='cod_tdo')

	base1=base1.drop('cod_tdo', axis=1)

	tipcit = pd.read_sql_query(f"SELECT id_tipcit,cod_tci FROM dim_tipcit", con=connection2)
	tipcit = tipcit.rename(columns={'id_tipcit':'id_tci'})
	tipcit = tipcit.rename(columns={'cod_tci':'cod_tci'})
	base1=pd.merge(base1,tipcit,how='left',on='cod_tci')

	base1=base1.drop('cod_tci', axis=1)
	
	tipcita = pd.read_sql_query(f"SELECT id_tipocit,cod_tci FROM dim_tipcita", con=connection2)
	tipcita = tipcita.rename(columns={'id_tipocit':'id_cci'})
	tipcita = tipcita.rename(columns={'cod_tci':'cod_cci'})
	base1=pd.merge(base1,tipcita,how='left',on='cod_cci')

	base1=base1.drop('cod_cci', axis=1)
	
	tipemi = pd.read_sql_query(f"SELECT id_tipemi,cod_emi FROM dim_tipemi", con=connection2)
	tipemi = tipemi.rename(columns={'id_tipemi':'id_otorga'})
	tipemi = tipemi.rename(columns={'cod_emi':'cod_mot'})
	base1=pd.merge(base1,tipemi,how='left',on='cod_mot')

	base1=base1.drop('cod_mot', axis=1)
	
	mec = pd.read_sql_query(f"SELECT id_moteli,cod_eli FROM dim_cexmotelicit", con=connection2)
	mec = mec.rename(columns={'id_moteli':'id_mec'})
	mec = mec.rename(columns={'cod_eli':'cod_moteli'})
	base1=pd.merge(base1,mec,how='left',on='cod_moteli')

	base1=base1.drop('cod_moteli', axis=1)
	
	eci = pd.read_sql_query(f"SELECT id_estcit,cod_eci FROM dim_estcit", con=connection2)
	eci = eci.rename(columns={'id_estcit':'id_eci'})
	base1=pd.merge(base1,eci,how='left',on='cod_eci')

	base1=base1.drop('cod_eci', axis=1)

	enco = pd.read_sql_query(f"SELECT id_esteco,cod_eco FROM dim_cexcitoto", con=connection2)
	enco = enco.rename(columns={'id_esteco':'id_enco'})
	enco = enco.rename(columns={'cod_eco':'cod_enco'})
	base1=pd.merge(base1,enco,how='left',on='cod_enco')

	base1=base1.drop('cod_enco', axis=1)
		
	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df2_columns - df1_columns
	different_columns

	borrando=f"DELETE FROM {dat} WHERE {col_dat} >='{fecha_ini_str}' and {col_dat} <'{fecha_fin_str}'"
	borrado = connection2.execute(borrando)

	comunes = set(base1.columns).intersection(set(base2.columns)) 
	base = base1[list(comunes)]
	base.to_sql(name=f'{dat}', con=engine2, if_exists='append', index=False,chunksize=5000)
	
	fecha_actual = fecha_fin_intervalo

	finproceso=time.time()
	tiempoproceso=finproceso - inicioTiempo
	tiempoproceso=round(tiempoproceso,3)
	print("Proceso completado satisfactoriamente en " + str(tiempoproceso)+" segundos")

query2=f"UPDATE etl_act SET fec_ini ='{now2}' WHERE id_mod=2"
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