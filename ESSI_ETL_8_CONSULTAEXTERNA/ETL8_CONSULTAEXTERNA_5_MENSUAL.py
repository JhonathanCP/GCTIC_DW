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




fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=20", con=connection2)
fecha_ini= fecha_ini.iloc[0, 0]

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=20", con=connection2)
fecha_fin= fecha_fin.iloc[0, 0]


# Definir el número total de meses desde la fecha de inicio hasta la fecha actual
#total_meses = (fecha_fin.year - fecha_ini.year) * 12 + (fecha_fin.month - fecha_ini.month)

# Define el número de días en cada intervalo (10 días)
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

	print(f"Procesando 2.1 de {fecha_ini_str} al {fecha_fin_str}")

	now1 = datetime.now()
	now2 = datetime.now().strftime('%Y-%m-%d')

	query=f"UPDATE etl_act SET fec_act ='{now1}' WHERE id_mod=20"

	c1= text(query)
	connection2.execute(c1)


	######################FUNCIONES DE LOG###########################
	tabla1='ctanm10'
	tabla2='ctdan10'
	col_tabla='atenomfec'
	dat = 'dat_cext005_essi'
	col_dat = 'ate_fec'

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


	query=f"""SELECT 
		A.*, 
		D.ATENMDCONDDIAGCOD,
		D.ATENMDDIAGCOD,
		D.ATENMDDIAGORD,
		D.ATENMDTIPODIAGCOD,
		D.ATENMDCASODIAGCOD,
		D.ATENMDALTAFLG,
		per.PERTIPDOCIDENCOD,
		per.PERDOCIDENNUM,
		per.PERNACFEC,
		per.PERSEXOCOD FROM {tabla1} A LEFT OUTER JOIN {tabla2} D
		ON D.ATENOMORICENASICOD = A.ATENOMORICENASICOD
		AND D.ATENOMCENASICOD = A.ATENOMCENASICOD
		AND D.ATENOMACTMEDNUM = A.ATENOMACTMEDNUM 
		LEFT OUTER JOIN CMPER10 per ON A.ATENOMPACSECNUM = per.PERSECNUM
		WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"""

	base1 = pd.read_sql_query(query, con=connection0)

	#base1 = base1.replace('\x00', '', regex=True)

	connection0.close()


	base1.to_sql(name=f'tmp_{tabla1}', con=engine3, if_exists='replace', index=False)



	#borrado = f"DELETE FROM {tabla1} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	#borrado = connection3.execute(borrado)



	query=f"""

	ALTER TABLE tmp_{tabla1} 
	ALTER COLUMN ATENOMORICENASICOD TYPE character(1),
	ALTER COLUMN ATENOMCENASICOD TYPE character(3),
	ALTER COLUMN ATENOMACTMEDNUM TYPE numeric(10,0) USING atenomactmednum::numeric(10,0),
	ALTER COLUMN ATENOMFEC TYPE date USING atenomfec::date,
	ALTER COLUMN ATENOMHOR TYPE date USING atenomhor::date,
	ALTER COLUMN ATENOMEVAL TYPE text,
	ALTER COLUMN ATENOMPLANTRA TYPE text,
	ALTER COLUMN ATENOMTRAT TYPE text,
	ALTER COLUMN ATENOMCSECOD TYPE character(2),
	ALTER COLUMN ATENOMCPSCOD TYPE character(10),
	ALTER COLUMN RESATENOMEDCOD TYPE character(2),
	ALTER COLUMN ATENOMESTREGCOD TYPE character(1),
	ALTER COLUMN ATENOMUSUCRECOD TYPE character(10),
	ALTER COLUMN ATENOMCREFEC TYPE date USING atenomcrefec::date,
	ALTER COLUMN ATENOMUSUMODCOD TYPE character(10),
	ALTER COLUMN ATENOMMODFEC TYPE date USING atenommodfec::date,
	ALTER COLUMN ATENOMPROORICENASICOD TYPE character(1),
	ALTER COLUMN ATENOMPROCENASICOD TYPE character(3),
	ALTER COLUMN ATENOMPROAREHOSCOD TYPE character(2),
	ALTER COLUMN ATENOMPROSERVHOSCOD TYPE character(3),
	ALTER COLUMN ATENOMPROACTCOD TYPE character(2),
	ALTER COLUMN ATENOMPROACTESPCOD TYPE character(3),
	ALTER COLUMN ATENOMPROTIPDOCIDENPERCOD TYPE character(1),
	ALTER COLUMN ATENOMPROPERASISDOCIDENNUM TYPE character(10),
	ALTER COLUMN ATENOMTURHORINI TYPE date USING atenomturhorini::date,
	ALTER COLUMN ATENOMTURHORFIN TYPE date USING atenomturhorfin::date,
	ALTER COLUMN ATENOMNUMATECOD TYPE character(2),
	ALTER COLUMN ATENOMULTREGFEC TYPE date USING atenomultregfec::date,
	ALTER COLUMN ATENOMPACSECNUM TYPE numeric(10,0) USING atenompacsecnum::numeric(10,0),
	ALTER COLUMN ATENMDCONDDIAGCOD TYPE character(1),
	ALTER COLUMN ATENMDDIAGCOD TYPE character(7),
	ALTER COLUMN ATENMDDIAGORD TYPE numeric(2,0) USING atenmddiagord::numeric(2,0),
	ALTER COLUMN ATENMDTIPODIAGCOD TYPE numeric(1,0) USING ATENMDTIPODIAGCOD::numeric(1,0),
	ALTER COLUMN ATENMDCASODIAGCOD TYPE numeric(1,0) USING ATENMDCASODIAGCOD::numeric(1,0),
	ALTER COLUMN ATENMDALTAFLG TYPE numeric(1,0) USING ATENMDALTAFLG::numeric(1,0),
	ALTER COLUMN pertipdocidencod type character(2),
	ALTER COLUMN perdocidennum type character(20),
	ALTER COLUMN pernacfec type date USING pernacfec::date,
	ALTER COLUMN persexocod type numeric(1,0) USING persexocod::numeric(1,0);


	INSERT INTO {tabla1} 
	(atenomoricenasicod, atenomcenasicod, atenomactmednum, atenomfec, atenomhor, atenomeval, atenomplantra, atenomtrat, atenomcsecod, atenomcpscod, resatenomedcod, atenomestregcod, atenomusucrecod, atenomcrefec, atenomusumodcod, atenommodfec, atenomprooricenasicod, atenomprocenasicod, atenomproarehoscod, atenomproservhoscod, atenomproactcod, atenomproactespcod, atenomprotipdocidenpercod, atenomproperasisdocidennum, atenomturhorini, atenomturhorfin, atenomnumatecod, atenomultregfec, atenompacsecnum, atenmdconddiagcod, atenmddiagcod, atenmddiagord, atenmdtipodiagcod, atenmdcasodiagcod, atenmdaltaflg, pertipdocidencod, perdocidennum, pernacfec, persexocod)
	SELECT 
	atenomoricenasicod, atenomcenasicod, atenomactmednum, atenomfec, atenomhor, atenomeval, atenomplantra, atenomtrat, atenomcsecod, atenomcpscod, resatenomedcod, atenomestregcod, atenomusucrecod, atenomcrefec, atenomusumodcod, atenommodfec, atenomprooricenasicod, atenomprocenasicod, atenomproarehoscod, atenomproservhoscod, atenomproactcod, atenomproactespcod, atenomprotipdocidenpercod, atenomproperasisdocidennum, atenomturhorini, atenomturhorfin, atenomnumatecod, atenomultregfec, atenompacsecnum, atenmdconddiagcod, atenmddiagcod, atenmddiagord, atenmdtipodiagcod, atenmdcasodiagcod, atenmdaltaflg, pertipdocidencod, perdocidennum, pernacfec, persexocod

	FROM tmp_{tabla1};
	"""

	c1= text(query)
	connection3.execute(c1)

	print('lectura base lista')

	#BORRAMOS LAS TABLAS
	query2=f"""
	DROP TABLE tmp_{tabla1};
	"""
	c2= text(query2)
	cursor=connection3.execute(c2)


	base1 = base1.rename(columns={
		'atenomoricenasicod': 'ori_cas', 
		'atenomcenasicod': 'cod_cas', 
		'atenomactmednum': 'ate_num', 
		'atenomfec': 'ate_fec', 
		'atenomhor': 'ate_hor', 
		'atenomcsecod': 'cod_cse', 
		'atenomcpscod': 'cod_cps', 
		'resatenomedcod': 'res_cod', 
		'atenomestregcod': 'est_reg', 
		'atenomusucrecod': 'usu_cre', 
		'atenomcrefec': 'fec_cre', 
		'atenomusumodcod': 'usu_mod', 
		'atenommodfec': 'fec_mod', 
		'atenomproarehoscod': 'cod_are', 
		'atenomproservhoscod': 'cod_serv', 
		'atenomproactcod': 'cod_act', 
		'atenomproactespcod': 'cod_ace', 
		'atenomprotipdocidenpercod': 'cod_tdi_med', 
		'atenomproperasisdocidennum': 'num_doc_med', 
		'atenomturhorini': 'hor_ini', 
		'atenomturhorfin': 'hor_fim', 
		'atenomnumatecod': 'ate_cod', 
		'atenomultregfec': 'fec_ult_reg', 
		'atenompacsecnum': 'pac_sec', 
		'pertipdocidencod': 'cod_tdi_pac',
		'perdocidennum': 'num_doc_pac',
		'atenmdconddiagcod': 'cond_diagcod', 
		'atenmddiagcod': 'diag_cod', 
		'atenmddiagord': 'diag_ord', 
		'atenmdtipodiagcod': 'tip_diag', 
		'atenmdcasodiagcod': 'caso_diag', 
		'atenmdaltaflg': 'alta_diag',
		'pernacfec': 'fec_nac_pac',
		'persexocod': 'sexo_pac'
	})

	base1=base1.drop('atenomeval', axis=1)
	base1=base1.drop('atenomplantra', axis=1)
	base1=base1.drop('atenomtrat', axis=1)
	#base1=base1.drop('atenmdpeas', axis=1)	
	base1=base1.drop('atenomprooricenasicod', axis=1)
	base1=base1.drop('atenomprocenasicod', axis=1)

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

	csep = pd.read_sql_query(f"SELECT id_csep, cod_cse FROM dim_csep", con=connection2)
	csep['cod_cse']=csep['cod_cse'].str.strip()
	base1['cod_cse']=base1['cod_cse'].str.strip()
	base1 = pd.merge(base1, csep, on='cod_cse', how="left")
	base1 = base1.drop('cod_cse', axis=1)


	cps = pd.read_sql_query(f"SELECT id_cps,cod_cps FROM dim_cps", con=connection2)
	cps['cod_cps']=cps['cod_cps'].str.strip()
	base1['cod_cps']=base1['cod_cps'].str.strip()
	base1 = pd.merge(base1, cps, on='cod_cps', how="left")
	base1 = base1.drop('cod_cps', axis=1)

	resaten = pd.read_sql_query(f"SELECT id_resaten, cod_resaten FROM dim_resaten", con=connection2)
	resaten = resaten.rename(columns={"cod_resaten": "res_cod"})
	resaten['res_cod']=resaten['res_cod'].str.strip()
	base1['res_cod']=base1['res_cod'].str.strip()
	base1 = pd.merge(base1, resaten, on='res_cod', how="left")
	base1 = base1.drop('res_cod', axis=1)
	
	estreg = pd.read_sql_query(f"SELECT id_estreg, cod_est FROM dim_estreg", con=connection2)
	estreg = estreg.rename(columns={"cod_est": "est_reg"})
	estreg['est_reg']=estreg['est_reg'].str.strip()
	base1['est_reg']=base1['est_reg'].str.strip()
	base1 = pd.merge(base1, estreg, on='est_reg', how="left")
	base1 = base1.drop('est_reg', axis=1)

	condiag = pd.read_sql_query(f"SELECT id_condia,cod_con FROM dim_condiag", con=connection2)
	base1 = base1.rename(columns={"cond_diagcod": "cod_con"})
	condiag['cod_con']=condiag['cod_con'].str.strip()
	base1['cod_con']=base1['cod_con'].str.strip()
	base1 = pd.merge(base1, condiag, on='cod_con', how="left")
	base1 = base1.drop('cod_con', axis=1)


	cie10 = pd.read_sql_query(f"SELECT id_cie,cod_cie FROM dim_cie10", con=connection2)
	base1 = base1.rename(columns={"diag_cod": "cod_cie"})
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

	casdiag = pd.read_sql_query(f"SELECT id_casdiag,cod_casdiag FROM dim_casdiag", con=connection2)
	casdiag = casdiag.rename(columns={"cod_casdiag": "caso_diag"})
	casdiag['caso_diag']=casdiag['caso_diag'].str.strip()
	base1['caso_diag']=base1['caso_diag'].str.strip()
	base1 = pd.merge(base1, casdiag, on='caso_diag', how="left")
	base1 = base1.drop('caso_diag', axis=1)

	tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
	tipdoc=tipdoc.rename(columns={"id_tipdoc":"id_tdi_pac"})
	tipdoc=tipdoc.rename(columns={"cod_tdo":"cod_tdi_pac"})
	base1=pd.merge(base1,tipdoc,how='inner',on='cod_tdi_pac')

	tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
	tipdoc=tipdoc.rename(columns={"id_tipdoc":"id_tdi_med"})
	tipdoc=tipdoc.rename(columns={"cod_tdo":"cod_tdi_med"})
	base1=pd.merge(base1,tipdoc,how='left',on='cod_tdi_med')

	base1=base1.drop('cod_tdi_med', axis=1)

	#base2=pd.read_sql_query(f"SELECT * FROM {dat} LIMIT 10", con=connection2)
	
	#borrando=f"DELETE FROM {dat} WHERE {col_dat} >='{fecha_ini_str}' and {col_dat} <'{fecha_fin_str}'"
	#borrado = connection2.execute(borrando)

	#comunes = set(base1.columns).intersection(set(base2.columns)) 
	#base = base1[list(comunes)]
	print('subiendo bloque')
	base1.to_sql(name=f'{dat}', con=engine2, if_exists='append', index=False,chunksize=50000)

	fecha_actual = fecha_fin_intervalo

	finproceso=time.time()
	tiempoproceso=finproceso - inicioTiempo
	tiempoproceso=round(tiempoproceso,3)
	print("Proceso 1.1 completado satisfactoriamente en " + str(tiempoproceso)+" segundos")


query2=f"UPDATE etl_act SET fec_ini ='{now2}' WHERE id_mod=20"
c2= text(query2)
connection2.execute(c2)

connection1.close()
connection2.close()
connection3.close()
engine1.dispose()
engine2.dispose()
engine3.dispose()