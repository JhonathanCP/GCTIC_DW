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

fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=4", con=connection1)
fecha_ini= fecha_ini.iloc[0, 0]

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=4", con=connection1)
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
	query = f"UPDATE etl_act SET fec_act = TO_DATE('{now}', 'YYYY-MM-DD HH24:MI:SS') WHERE id_mod=4"


	c1= text(query)
	connection1.execute(c1)

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

	print('LECTURA LISTA')
	print(base1.size)

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

	casdiag = pd.read_sql_query(f"SELECT id_casdiag,cod_casdiag FROM dim_casdiag", con=connection2)
	casdiag = casdiag.rename(columns={"cod_casdiag": "caso_diag"})
	casdiag['caso_diag']=casdiag['caso_diag'].str.strip()
	base1['caso_diag']=base1['caso_diag'].str.strip()
	base1 = pd.merge(base1, casdiag, on='caso_diag', how="left")
	base1 = base1.drop('caso_diag', axis=1)

	tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
	tipdoc=tipdoc.rename(columns={"id_tipdoc":"id_tdi_pac"})
	tipdoc=tipdoc.rename(columns={"cod_tdo":"cod_tdi_pac"})
	base1=pd.merge(base1,tipdoc,how='left',on='cod_tdi_pac')

	base1['ate_fec'] = base1['ate_fec'].astype(str)
	base1['ate_fec'] = np.where(base1['ate_fec'].str.startswith('0001-01-01'), '1999-01-01 ' + base1['ate_fec'].str[-8:], base1['ate_fec'])
	base1['ate_fec'] = pd.to_datetime(base1['ate_fec'], errors='coerce')
	base1['fec_cre'] = base1['fec_cre'].astype(str)
	base1['fec_cre'] = np.where(base1['fec_cre'].str.startswith('0001-01-01'), '1999-01-01 ' + base1['fec_cre'].str[-8:], base1['fec_cre'])
	base1['fec_cre'] = pd.to_datetime(base1['fec_cre'], errors='coerce')
	base1['fec_mod'] = base1['fec_mod'].astype(str)
	base1['fec_mod'] = np.where(base1['fec_mod'].str.startswith('0001-01-01'), '1999-01-01 ' + base1['fec_mod'].str[-8:], base1['fec_mod'])
	base1['fec_mod'] = pd.to_datetime(base1['fec_mod'], errors='coerce')
	base1['fec_ult_reg'] = base1['fec_ult_reg'].astype(str)
	base1['fec_ult_reg'] = np.where(base1['fec_ult_reg'].str.startswith('0001-01-01'), '1999-01-01 ' + base1['fec_ult_reg'].str[-8:], base1['fec_ult_reg'])
	base1['fec_ult_reg'] = pd.to_datetime(base1['fec_ult_reg'], errors='coerce')
	base1['fec_nac_pac'] = base1['fec_nac_pac'].astype(str)
	base1['fec_nac_pac'] = np.where(base1['fec_nac_pac'].str.startswith('0001-01-01'), '1999-01-01 ' + base1['fec_nac_pac'].str[-8:], base1['fec_nac_pac'])
	base1['fec_nac_pac'] = pd.to_datetime(base1['fec_nac_pac'], errors='coerce')

	print('EMPAREJAMIENTOS LISTOS')

	base2=pd.read_sql_query(f"SELECT * FROM {dat} WHERE ROWNUM <= 10", con=connection1)

	df1_columns = set(base1.columns)
	df2_columns = set(base2.columns) 
	different_columns = df2_columns - df1_columns
	different_columns

	borrando=f"DELETE FROM {dat} WHERE {col_dat} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') AND {col_dat} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection1.execute(borrando)
	print('BORRADO LISTO, SUBIENDO...')

	comunes = set(base1.columns).intersection(set(base2.columns))
	base = base1[list(comunes)]
	base.to_sql(name=f'{dat}', con=engine1, if_exists='append', index=False,chunksize=250000)

	fecha_ini = fecha_fin_mes

	finproceso=time.time()
	tiempoproceso=finproceso - inicioTiempo
	tiempoproceso=round(tiempoproceso,3)
	print("Proceso completado satisfactoriamente en " + str(tiempoproceso)+" segundos")

now2 = datetime.now().strftime('%Y-%m-%d')
query2 = text(f"UPDATE etl_act SET fec_ini = TO_DATE('{now2}','YYYY-MM-DD') WHERE id_mod=4")

# Ejecutar la consulta
connection1.execute(query2)

connection1.close()
connection2.close()


engine1.dispose()
engine2.dispose()
