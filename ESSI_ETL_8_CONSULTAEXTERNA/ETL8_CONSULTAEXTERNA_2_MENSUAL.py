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


fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=16", con=connection2)
fecha_ini= fecha_ini.iloc[0, 0]

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=16", con=connection2)
fecha_fin= fecha_fin.iloc[0, 0]


dias_por_intervalo = 5

# Inicializa la fecha actual
fecha_actual = fecha_ini

for i in range(0, (fecha_fin - fecha_ini).days + 1, dias_por_intervalo):

	inicioTiempo = time.time()
	now_inicio = datetime.now()

	fecha_ini_intervalo = fecha_actual

	fecha_fin_intervalo = fecha_actual + timedelta(days = dias_por_intervalo - 1)

	fecha_ini_str = fecha_ini_intervalo.strftime('%Y-%m-%d')	
	fecha_fin_str = fecha_fin_intervalo.strftime('%Y-%m-%d')

	print(f"Procesando de {fecha_ini_str} al {fecha_fin_str}")

	now1 = datetime.now()
	now2 = datetime.now().strftime('%Y-%m-%d')

	query=f"UPDATE etl_act SET fec_act ='{now1}' WHERE id_mod=16"

	c1= text(query)
	connection2.execute(c1)

	tabla='ctaam10'
	col_tabla = "atenambatenfec"
	dat= "dat_cext002_essi"
	col_dat='ate_fec'


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
	SELECT
		to_char(d1.ATENAMBATENFEC, 'YYYY-MM-DD HH24:MI:SS') as ATENAMBATENFEC,
		d1.ATENAMBTIPCONCOD,
		d1.ATENAMBCSECOD,
		d1.CPSCOD,
		d1.ATENAMBNUMATECOD,
		d1.TIPCONTLEYCOD,
		d1.RESATENAMBUCOD,
		d1.ORICENASIREFCOD,
		d1.CENASIREFCOD,
		d1.ATENAMBESTREGCOD,
		d1.ATENAMBUSUCRECOD,
		to_char(d1.ATENAMBCREFEC, 'YYYY-MM-DD HH24:MI:SS') as ATENAMBCREFEC,
		d1.ATENAMBUSUMODCOD,
		to_char(d1.ATENAMBMODFEC, 'YYYY-MM-DD HH24:MI:SS') as ATENAMBMODFEC,
		d1.ATENAMBULTREGFEC,
		d1.ATENAMBPACSECNUM,
		per.PERTIPDOCIDENCOD,
		per.PERDOCIDENNUM,
		per.PERNACFEC,
		per.PERSEXOCOD,
		a1.*
	FROM ctaam10 d1 
	LEFT OUTER JOIN CTDAA10 a1 ON a1.ATENAMBORICENASICOD = d1.ATENAMBORICENASICOD
		AND a1.ATENAMBCENASICOD    = d1.ATENAMBCENASICOD
		AND a1.ATENAMBNUM    = d1.ATENAMBNUM
	LEFT OUTER JOIN CMPER10 per ON d1.ATENAMBPACSECNUM = per.PERSECNUM
	WHERE d1.{col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') AND d1.{col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')
	"""

	base1 = pd.read_sql_query(query0, con=connection0)
	connection0.close()
	base1.to_sql(name=f'tmp_{tabla}', con=engine3, if_exists='replace', index=False)

	borrado = f"DELETE FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection3.execute(borrado)

	query=f"""

	ALTER TABLE tmp_{tabla} 
	ALTER COLUMN atenamboricenasicod TYPE character(1),
	ALTER COLUMN atenambcenasicod TYPE character(3),
	ALTER COLUMN atenambnum TYPE numeric(10,0) USING atenambnum::numeric(10,0),
	ALTER COLUMN atenambatenfec TYPE date USING atenambatenfec::date,
	ALTER COLUMN atenambtipconcod TYPE character(1),
	ALTER COLUMN atenambcsecod TYPE character(2),
	ALTER COLUMN cpscod TYPE character(10),
	ALTER COLUMN atenambnumatecod TYPE character(2),
	ALTER COLUMN tipcontleycod TYPE character(2),
	ALTER COLUMN resatenambucod TYPE character(2),
	ALTER COLUMN oricenasirefcod TYPE character(1),
	ALTER COLUMN cenasirefcod TYPE character(3),
	ALTER COLUMN atenambestregcod TYPE character(1),
	ALTER COLUMN atenambusucrecod TYPE character(10),
	ALTER COLUMN atenambcrefec TYPE date USING atenambcrefec::date,
	ALTER COLUMN atenambusumodcod TYPE character(10),
	ALTER COLUMN atenambmodfec TYPE date USING atenambmodfec::date,
	ALTER COLUMN atenambultregfec TYPE date USING atenambultregfec::date,
	ALTER COLUMN atenambpacsecnum TYPE numeric(15,0) USING atenambpacsecnum::numeric(15,0),
	ALTER COLUMN conddiagcod TYPE character(1),
	ALTER COLUMN diagcod TYPE character(7),
	ALTER COLUMN atenambdiagord TYPE numeric(2,0) USING atenambdiagord::numeric(2,0),
	ALTER COLUMN atenambtipodiagcod TYPE numeric(1,0) USING atenambtipodiagcod::numeric(1,0),
	ALTER COLUMN atenambcasodiagcod TYPE numeric(1,0) USING atenambcasodiagcod::numeric(1,0),
	ALTER COLUMN diagatenambaltaflag TYPE numeric(1,0) USING diagatenambaltaflag::numeric(1,0),
	ALTER COLUMN pertipdocidencod type character(2),
	ALTER COLUMN perdocidennum type character(20),
	ALTER COLUMN pernacfec type date USING pernacfec::date,
	ALTER COLUMN persexocod type numeric(1,0) USING persexocod::numeric(1,0);


	INSERT INTO {tabla} 
	(atenamboricenasicod,atenambcenasicod,atenambnum,atenambatenfec,atenambtipconcod,atenambcsecod,cpscod,atenambnumatecod,tipcontleycod,resatenambucod,oricenasirefcod,cenasirefcod,atenambestregcod,atenambusucrecod,atenambcrefec,atenambusumodcod,atenambmodfec,atenambultregfec,atenambpacsecnum,conddiagcod,diagcod,atenambdiagord,atenambtipodiagcod,atenambcasodiagcod,diagatenambaltaflag,pertipdocidencod,perdocidennum,pernacfec,persexocod)
	SELECT 
	atenamboricenasicod,atenambcenasicod,atenambnum,atenambatenfec,atenambtipconcod,atenambcsecod,cpscod,atenambnumatecod,tipcontleycod,resatenambucod,oricenasirefcod,cenasirefcod,atenambestregcod,atenambusucrecod,atenambcrefec,atenambusumodcod,atenambmodfec,atenambultregfec,atenambpacsecnum,conddiagcod,diagcod,atenambdiagord,atenambtipodiagcod,atenambcasodiagcod,diagatenambaltaflag,pertipdocidencod,perdocidennum,pernacfec,persexocod


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

	# Lista de columnas a eliminar
	columnas_eliminar = ['oricenasirefcod','cenasirefcod']

	# Eliminar las columnas
	base1 = base1.drop(columns=columnas_eliminar)


	base1 = base1.rename(columns={
		'atenamboricenasicod': 'ori_cas',
		'atenambcenasicod': 'cod_cas',
		'atenambnum': 'ate_num',
		'atenambatenfec': 'ate_fec',
		'atenambtipconcod': 'tip_con',
		'atenambcsecod': 'cod_cse',
		'cpscod': 'cod_cps',
		'atenambnumatecod': 'ate_cod',
		'tipcontleycod': 'ley_cod',
		'resatenambucod': 'res_cod',
		'atenambestregcod': 'est_reg',
		'atenambusucrecod': 'usu_cre',
		'atenambcrefec': 'fec_cre',
		'atenambusumodcod': 'usu_mod',
		'atenambmodfec': 'fec_mod',
		'atenambultregfec': 'fec_ult_reg',
		'atenambpacsecnum': 'pac_sec',
		'pertipdocidencod': 'cod_tdi_pac',
		'perdocidennum': 'num_doc_pac',
		'conddiagcod': 'cond_diagcod',
		'diagcod': 'diag_cod',
		'atenambdiagord': 'diag_ord',
		'atenambtipodiagcod': 'tip_diag',
		'atenambcasodiagcod': 'caso_diag',
		'diagatenambaltaflag': 'alta_diag',
		'pernacfec': 'fec_nac_pac',
		'persexocod': 'sexo_pac'
	})
	base1=base1.drop('diagatenambpeas', axis=1)
	
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


	tipcon = pd.read_sql_query(f"SELECT id_tipcon, cod_tipcon FROM dim_tipcon", con=connection2)
	tipcon = tipcon.rename(columns={"cod_tipcon": "tip_con"})
	tipcon['tip_con']=tipcon['tip_con'].str.strip()
	base1['tip_con']=base1['tip_con'].str.strip()
	base1 = pd.merge(base1, tipcon, on='tip_con', how="left")
	base1 = base1.drop('tip_con', axis=1)


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


	numaten = pd.read_sql_query(f"SELECT id_numaten, cod_numaten FROM dim_numaten", con=connection2)
	numaten = numaten.rename(columns={"cod_numaten": "ate_cod"})
	numaten['ate_cod']=numaten['ate_cod'].str.strip()
	base1['ate_cod']=base1['ate_cod'].str.strip()
	base1 = pd.merge(base1, numaten, on='ate_cod', how="left")
	base1 = base1.drop('ate_cod', axis=1)


	ley = pd.read_sql_query(f"SELECT id_tipleycont, cod_tipleycont FROM dim_tipleycont", con=connection2)
	ley = ley.rename(columns={"cod_tipleycont": "ley_cod"})
	ley['ley_cod']=ley['ley_cod'].str.strip()
	base1['ley_cod']=base1['ley_cod'].str.strip()
	base1 = pd.merge(base1, ley, on='ley_cod', how="left")
	base1 = base1.drop('ley_cod', axis=1)


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


	base1.columns


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

	base2=pd.read_sql_query(f"SELECT * FROM {dat} LIMIT 10", con=connection2)

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

query2=f"UPDATE etl_act SET fec_ini ='{now2}' WHERE id_mod=16"
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