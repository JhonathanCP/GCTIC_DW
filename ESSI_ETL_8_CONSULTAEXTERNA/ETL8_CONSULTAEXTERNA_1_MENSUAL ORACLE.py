from decouple import config
import pandas as pd
from datetime import datetime, timedelta, date
import time 
from sqlalchemy import text, create_engine
import oracledb
import sys
import numpy as np

DB_USER=config("USER2_BDI_POSTGRES")
DB_PASSWORD=config("PASS2_BDI_POSTGRES")
DB_NAME="dw_essalud"
DB_PORT="5432"
DB_HOST=config("HOST2_BDI_POSTGRES")
cadena2  = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine2 = create_engine(cadena2)
connection2 = engine2.connect()

oracledb.init_oracle_client()
oracledb.version = "11.2.0.4"
sys.modules["cx_Oracle"] = oracledb
un = 'DW_ESSALUD'
pw = 'Dw_Essalud24'
hostname='10.0.1.228'
service_name="devugad"
port = 1521

engine1 = create_engine(f'oracle://{un}:{pw}@',connect_args={
		"host": hostname,
		"port": port,
		"service_name": service_name
	}
)

connection1 = engine1.connect()

fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=3", con=connection1)
fecha_ini= fecha_ini.iloc[0, 0]

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=3", con=connection1)
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

	print(f"Procesando de {fecha_ini_str} al {fecha_fin_str}")


	now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
	query = f"UPDATE etl_act SET fec_act = TO_DATE('{now}', 'YYYY-MM-DD HH24:MI:SS') WHERE id_mod = 3"


	c1= text(query)
	connection1.execute(c1)

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

	query = f"""SELECT c.*, c2.PERTIPDOCIDENCOD, c2.PERDOCIDENNUM FROM {tabla} c LEFT JOIN (
	SELECT PERSECNUM, PERTIPDOCIDENCOD, PERDOCIDENNUM 
	FROM CMPER10
	GROUP BY PERSECNUM, PERTIPDOCIDENCOD, PERDOCIDENNUM 
	) c2 ON c.CITAMBPACSECNUM = c2.PERSECNUM WHERE c.{col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') AND c.{col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"""
	base2 = pd.read_sql_query(query, con=connection0)

	connection0.close()

	print('LECTURA LISTA')

	tabla='ctcam10'
	col_essi='fec_cit'
	col_tabla='citambproconfec'
	essi='essi_dat_cex001_etl'


	base2 = base2.rename(columns={
		'citambactcod': 'cod_act',
		'citambactespcod': 'cod_sub',
		'citambanufec': 'fec_anu',
		'citambarehoscod': 'cod_are',
		'citambcenasicod': 'cod_cas',
		'citambcnvespcod': 'cnv_esp',
		'citambcrefec': 'fec_cre',
		'citambestctrlseg': 'ctr_seg',
		'citambhorcit': 'hor_cit',
		'citambipanucod': 'ip_anu',
		'citambipcrecod': 'ip_cre',
		'citambipmodcod': 'ip_mod',
		'citambmodanucod': 'mod_anu',
		'citambmodfec': 'fec_mod',
		'citambnum': 'cit_num',
		'citambnumord': 'ord_cit',
		'citamboricenasicod': 'ori_cas',
		'citambpacsecnum': 'pac_sec',
		'citambperasisdocidennum': 'num_doc_med',
		'citambproconcenasicod': 'cas_pro',
		'citambproconfec': 'fec_cit',
		'citambproconoricenasicod': 'ori_pro',
		'citambproconturhorfin': 'hor_fin',
		'citambproconturhorini': 'hor_ini',
		'citambrep': 'cit_rep',
		'citambservhoscod': 'cod_ser',
		'citambsolfec': 'fec_sol',
		'citambtipdocidenpercod': 'cod_tdi_med',
		'citambusuanucod': 'usu_anu',
		'citambusucrecod': 'usu_cre',
		'citambusumodcod': 'usu_mod',
		'condcitacod': 'cod_cci',
		'estcitcod': 'cod_eci',
		'estcitotocod': 'cod_enco',
		'modotorcitacod': 'cod_oto',
		'motelicitcod': 'cod_mec',
		'motinacitdes': 'mot_cit',
		'tipocitacod': 'cod_tci',
		'pertipdocidencod': 'cod_tdi_pac',
		'perdocidennum': 'num_doc_pac'
	})


	base1=base2

	tabla='ctcam10'
	col_dat='fec_cit'
	dat='dat_cext001_essi'


	base2=pd.read_sql_query(f"SELECT * FROM {dat} WHERE ROWNUM <= 10", con=connection1)

	base1['hor_ini'] = base1['hor_ini'].astype(str)
	base1['hor_ini'] = np.where(base1['hor_ini'].str.startswith('0001-01-01'), '1999-01-01 ' + base1['hor_ini'].str[-8:], base1['hor_ini'])
	base1['hor_ini'] = pd.to_datetime(base1['hor_ini'], errors='coerce')
	base1['hor_fin'] = base1['hor_fin'].astype(str)
	base1['hor_fin'] = np.where(base1['hor_fin'].str.startswith('0001-01-01'), '1999-01-01 ' + base1['hor_fin'].str[-8:], base1['hor_fin'])
	base1['hor_fin'] = pd.to_datetime(base1['hor_fin'], errors='coerce')
	base1['hor_cit'] = base1['hor_cit'].astype(str)
	base1['hor_cit'] = np.where(base1['hor_cit'].str.startswith('0001-01-01'), '1999-01-01 ' + base1['hor_cit'].str[-8:], base1['hor_cit'])
	base1['hor_cit'] = pd.to_datetime(base1['hor_cit'], errors='coerce')
	base1['fec_cit'] = base1['fec_cit'].astype(str)
	base1['fec_cit'] = np.where(base1['fec_cit'].str.startswith('0001-01-01'), '1999-01-01 ' + base1['fec_cit'].str[-8:], base1['fec_cit'])
	base1['fec_cit'] = pd.to_datetime(base1['fec_cit'], errors='coerce')
	base1['fec_cre'] = base1['fec_cre'].astype(str)
	base1['fec_cre'] = np.where(base1['fec_cre'].str.startswith('0001-01-01'), '1999-01-01 ' + base1['fec_cre'].str[-8:], base1['fec_cre'])
	base1['fec_cre'] = pd.to_datetime(base1['fec_cre'], errors='coerce')
	base1['fec_mod'] = base1['fec_mod'].astype(str)
	base1['fec_mod'] = np.where(base1['fec_mod'].str.startswith('0001-01-01'), '1999-01-01 ' + base1['fec_mod'].str[-8:], base1['fec_mod'])
	base1['fec_mod'] = pd.to_datetime(base1['fec_mod'], errors='coerce')
	base1['fec_sol'] = base1['fec_sol'].astype(str)
	base1['fec_sol'] = np.where(base1['fec_sol'].str.startswith('0001-01-01'), '1999-01-01 ' + base1['fec_sol'].str[-8:], base1['fec_sol'])
	base1['fec_sol'] = pd.to_datetime(base1['fec_sol'], errors='coerce')
	base1['fec_anu'] = base1['fec_anu'].astype(str)
	base1['fec_anu'] = np.where(base1['fec_anu'].str.startswith('0001-01-01'), '1999-01-01 ' + base1['fec_anu'].str[-8:], base1['fec_anu'])
	base1['fec_anu'] = pd.to_datetime(base1['fec_anu'], errors='coerce')
		
	oricas = pd.read_sql_query(f"SELECT id_oricas,ori_cod FROM dim_oricas", con=connection2)
	oricas=oricas.rename(columns={"ori_cod":"ori_cas"})
	base1=pd.merge(base1,oricas,how='left',on='ori_cas')

	base1=base1.drop('ori_cas',axis=1)


	cas = pd.read_sql_query(f"SELECT id_cas,cod_cas, cod_red FROM dim_cas where id_red is not null", con=connection2)
	cas = cas.dropna()
	base1=pd.merge(base1,cas,how='left',on='cod_cas')

	base1=base1.drop('cod_cas',axis=1)


	red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)
	base1=pd.merge(base1,red,how='left',on='cod_red')

	base1=base1.drop('cod_red',axis=1)


	oripro = pd.read_sql_query(f"SELECT id_oricas,ori_cod FROM dim_oricas", con=connection2)
	oripro=oripro.rename(columns={"ori_cod":"ori_pro"})
	oripro=oripro.rename(columns={"id_oricas":"id_oripro"})
	base1=pd.merge(base1,oripro,how='left',on='ori_pro')

	base1=base1.drop('ori_pro',axis=1)


	caspro = pd.read_sql_query(f"SELECT id_cas,cod_cas FROM dim_cas where id_red is not null", con=connection2)
	caspro = caspro.dropna()
	caspro=caspro.rename(columns={"id_cas":"id_caspro"})
	caspro=caspro.rename(columns={"cod_cas":"cas_pro"})
	base1=pd.merge(base1,caspro,how='left',on='cas_pro')

	base1=base1.drop('cas_pro',axis=1)

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


	tipdoc_med = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
	tipdoc_med = tipdoc_med.rename(columns={"id_tipdoc": "id_tdi_med", "cod_tdo": "cod_tdi_med"})
	tipdoc_med['cod_tdi_med']=tipdoc_med['cod_tdi_med'].str.strip()
	base1['cod_tdi_med']=base1['cod_tdi_med'].str.strip()
	base1 = pd.merge(base1, tipdoc_med, how='left', on='cod_tdi_med')

	tipdoc_pac = tipdoc_med.rename(columns={"id_tdi_med": "id_tdi_pac", "cod_tdi_med": "cod_tdi_pac"})
	base1['cod_tdi_pac']=base1['cod_tdi_pac'].str.strip()
	base1 = pd.merge(base1, tipdoc_pac[['id_tdi_pac', 'cod_tdi_pac']], how='left', on='cod_tdi_pac')
	base1['id_tdi_pac'] = base1['id_tdi_pac'].apply(lambda x: int(x) if not pd.isna(x) else x)

	estsolcit = pd.read_sql_query(f"SELECT id_estsolcit,cod_esc FROM dim_cexestsolcit", con=connection2)
	estsolcit = estsolcit.rename(columns={'id_estsolcit':'id_tci'})
	estsolcit = estsolcit.rename(columns={'cod_esc':'cod_tci'})
	base1=pd.merge(base1,estsolcit,how='left',on='cod_tci')

	base1=base1.drop('cod_tci', axis=1)


	tipcita = pd.read_sql_query(f"SELECT id_tipocit,cod_tci FROM dim_tipcita", con=connection2)
	tipcita = tipcita.rename(columns={'id_tipocit':'id_cci'})
	tipcita = tipcita.rename(columns={'cod_tci':'cod_cci'})
	base1=pd.merge(base1,tipcita,how='left',on='cod_cci')

	base1=base1.drop('cod_cci', axis=1)


	tipemi = pd.read_sql_query(f"SELECT id_tipemi,cod_emi FROM dim_tipemi", con=connection2)
	tipemi = tipemi.rename(columns={'id_tipemi':'id_otorga'})
	tipemi = tipemi.rename(columns={'cod_emi':'cod_oto'})
	base1=pd.merge(base1,tipemi,how='left',on='cod_oto')

	base1=base1.drop('cod_oto', axis=1)


	base1=base1.rename(columns={'cit_rep':'id_citrep'})


	mec = pd.read_sql_query(f"SELECT id_moteli,cod_eli FROM dim_cexmotelicit", con=connection2)
	mec = mec.rename(columns={'id_moteli':'id_mec'})
	mec = mec.rename(columns={'cod_eli':'cod_mec'})
	base1=pd.merge(base1,mec,how='left',on='cod_mec')

	base1=base1.drop('cod_mec', axis=1)


	eci = pd.read_sql_query(f"SELECT id_estcit,cod_eci FROM dim_estcit", con=connection2)
	eci = eci.rename(columns={'id_estcit':'id_eci'})
	base1=pd.merge(base1,eci,how='left',on='cod_eci')

	base1=base1.drop('cod_eci', axis=1)

	enco = pd.read_sql_query(f"SELECT id_esteco,cod_eco FROM dim_cexcitoto", con=connection2)
	enco = enco.rename(columns={'id_esteco':'id_enco'})
	enco = enco.rename(columns={'cod_eco':'cod_enco'})
	base1=pd.merge(base1,enco,how='left',on='cod_enco')
	
	base1=base1.drop('cod_enco', axis=1)

	print('EMPAREJAMIENTOS LISTOS')

	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df2_columns - df1_columns
	different_columns

	borrando=f"DELETE FROM {dat} WHERE {col_dat} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') AND {col_dat} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection1.execute(borrando)

	print('BORRADO LISTO, SUBIENDO...')

	comunes = set(base1.columns).intersection(set(base2.columns)) 
	base = base1[list(comunes)]
	base.to_sql(name=f'{dat}', con=engine1, if_exists='append', index=False,chunksize=200000)


	fecha_ini = fecha_fin_mes

	finproceso=time.time()
	tiempoproceso=finproceso - inicioTiempo
	tiempoproceso=round(tiempoproceso,3)
	print("Proceso completado satisfactoriamente en " + str(tiempoproceso)+" segundos")

now2 = datetime.now().strftime('%Y-%m-%d')
query2 = text(f"UPDATE etl_act SET fec_ini = TO_DATE('{now2}','YYYY-MM-DD') WHERE id_mod = 3")

# Ejecutar la consulta
connection1.execute(query2)

connection1.close()
connection2.close()


engine1.dispose()
engine2.dispose()
