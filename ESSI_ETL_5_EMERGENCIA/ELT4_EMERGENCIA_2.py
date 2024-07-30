
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


fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=9", con=connection2)
fecha_ini= fecha_ini.iloc[0, 0]
#ACTIVAR PARA ACTUALIZAR
fecha_ini = date(fecha_ini.year, fecha_ini.month, fecha_ini.day) - timedelta(days=32)

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=9", con=connection2)
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

	print(f"Procesando 2.1 de {fecha_ini_str} al {fecha_fin_str}")


	now = datetime.now()

	query=f"UPDATE etl_act SET fec_act ='{now}' WHERE id_mod=9"

	c1= text(query)
	connection2.execute(c1)
	
	tabla='mtade10'
	col_tabla='admemeadmfec'
	col_dat='fec_adm'
	dat='dat_emer002_essi'

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

	query = f"""SELECT c.*, c2.PERTIPDOCIDENCOD, c2.PERDOCIDENNUM, c2.PERNACFEC, c2.PERSEXOCOD FROM {tabla} c LEFT JOIN (
    SELECT PERSECNUM, PERTIPDOCIDENCOD, PERDOCIDENNUM, PERNACFEC, PERSEXOCOD
    FROM CMPER10
    GROUP BY PERSECNUM, PERTIPDOCIDENCOD, PERDOCIDENNUM, PERNACFEC, PERSEXOCOD 
	) c2 ON c.ADMEMEPACSECNUM = c2.PERSECNUM WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') AND {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"""
	base1 = pd.read_sql_query(query, con=connection0)


	connection0.close()


	base1.to_sql(name=f'tmp_{tabla}', con=engine3, if_exists='replace', index=False)



	borrado = f"DELETE FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
	borrado = connection3.execute(borrado)



	query=f"""
	ALTER TABLE tmp_{tabla} 
	ALTER COLUMN admemeoricenasicod TYPE character(1) USING admemeoricenasicod::character(1),
	ALTER COLUMN admemecenasicod TYPE character(3) USING admemecenasicod::character(3),
	ALTER COLUMN admemeactmednum TYPE numeric(10,0) USING admemeactmednum::numeric(10,0),
	ALTER COLUMN admemearehoscod TYPE character(2) USING admemearehoscod::character(2),
	ALTER COLUMN admemeemecod TYPE character(2) USING admemeemecod::character(2),
	ALTER COLUMN {col_tabla} TYPE date USING {col_tabla}::date,
	ALTER COLUMN admemeadmhor TYPE timestamp with time zone USING admemeadmhor::timestamp with time zone,
	ALTER COLUMN estgepcod TYPE character(1) USING estgepcod::character(1),
	ALTER COLUMN tipacccod TYPE character(2) USING tipacccod::character(2),
	ALTER COLUMN acopaccod TYPE character(1) USING acopaccod::character(1),
	ALTER COLUMN admemeacopacnom TYPE character(35) USING admemeacopacnom::character(35),
	ALTER COLUMN admemeobs TYPE character(200) USING admemeobs::character(200),
	ALTER COLUMN admemeegrflg TYPE character(1) USING admemeegrflg::character(1),
	ALTER COLUMN admemealtmedfec TYPE date USING admemealtmedfec::date,
	ALTER COLUMN admemealtmedhor TYPE timestamp with time zone USING admemealtmedhor::timestamp with time zone,
	ALTER COLUMN admemeestregcod TYPE character(1) USING admemeestregcod::character(1),
	ALTER COLUMN admemeusucrecod TYPE character(10) USING admemeusucrecod::character(10),
	ALTER COLUMN admemecrefec TYPE date USING admemecrefec::date,
	ALTER COLUMN admemeusumodcod TYPE character(10) USING admemeusumodcod::character(10),
	ALTER COLUMN admememodfec TYPE date USING admememodfec::date,
	ALTER COLUMN admemetopemecod TYPE character(2) USING admemetopemecod::character(2),
	ALTER COLUMN admemepagnum TYPE character(10) USING admemepagnum::character(10),
	ALTER COLUMN admemealtadmfec TYPE date USING admemealtadmfec::date,
	ALTER COLUMN admemealtadmhor TYPE timestamp with time zone USING admemealtadmhor::timestamp with time zone,
	ALTER COLUMN admemealtadmobs TYPE text USING admemealtadmobs::text,
	ALTER COLUMN admemeatetrioricenasicod TYPE character(1) USING admemeatetrioricenasicod::character(1),
	ALTER COLUMN admemeatetricenasicod TYPE character(3) USING admemeatetricenasicod::character(3),
	ALTER COLUMN admemeatetriarehoscod TYPE character(2) USING admemeatetriarehoscod::character(2),
	ALTER COLUMN admemeatetriemecod TYPE character(2) USING admemeatetriemecod::character(2),
	ALTER COLUMN admemeatetriano TYPE character(4) USING admemeatetriano::character(4),
	ALTER COLUMN admemeatetrinum TYPE numeric(10,0) USING admemeatetrinum::numeric(10,0),
	ALTER COLUMN admememotegrcod TYPE character(2) USING admememotegrcod::character(2),
	ALTER COLUMN admemeultpriatecod TYPE character(1) USING admemeultpriatecod::character(1),
	ALTER COLUMN admemeresatenintecod TYPE character(2) USING admemeresatenintecod::character(2),
	ALTER COLUMN admemeresegrflg TYPE character(1) USING admemeresegrflg::character(1),
	ALTER COLUMN admemeegrdiagcod TYPE character(7) USING admemeegrdiagcod::character(7),
	ALTER COLUMN admemeegrtipodiagcod TYPE character(1) USING admemeegrtipodiagcod::character(1),
	ALTER COLUMN admemepacsecnum TYPE numeric(10,0) USING admemepacsecnum::numeric(10,0),
	ALTER COLUMN admemesoscovid TYPE numeric(1,0) USING admemesoscovid::numeric(1,0),
	ALTER COLUMN pertipdocidencod type character(2),
	ALTER COLUMN perdocidennum type character(15),
	ALTER COLUMN pernacfec TYPE date USING pernacfec::date,
	ALTER COLUMN persexocod type character(2);


	INSERT INTO {tabla} 
	(admemeoricenasicod,admemecenasicod ,admemeactmednum ,admemearehoscod ,admemeemecod ,{col_tabla} ,admemeadmhor,estgepcod ,tipacccod ,acopaccod,admemeacopacnom ,admemeobs ,admemeegrflg,admemealtmedfec ,admemealtmedhor,admemeestregcod,admemeusucrecod ,admemecrefec ,admemeusumodcod ,admememodfec ,admemetopemecod ,admemepagnum ,admemealtadmfec ,admemealtadmhor ,admemealtadmobs ,admemeatetrioricenasicod ,admemeatetricenasicod,admemeatetriarehoscod ,admemeatetriemecod ,admemeatetriano ,admemeatetrinum ,admememotegrcod ,admemeultpriatecod ,admemeresatenintecod ,admemeresegrflg ,admemeegrdiagcod ,admemeegrtipodiagcod ,admemepacsecnum ,admemesoscovid, pertipdocidencod, perdocidennum, pernacfec, persexocod ) 

	SELECT 
	admemeoricenasicod,admemecenasicod ,admemeactmednum ,admemearehoscod ,admemeemecod ,{col_tabla} ,admemeadmhor,estgepcod ,tipacccod ,acopaccod,admemeacopacnom ,admemeobs ,admemeegrflg,admemealtmedfec ,admemealtmedhor,admemeestregcod,admemeusucrecod ,admemecrefec ,admemeusumodcod ,admememodfec ,admemetopemecod ,admemepagnum ,admemealtadmfec ,admemealtadmhor ,admemealtadmobs ,admemeatetrioricenasicod ,admemeatetricenasicod,admemeatetriarehoscod ,admemeatetriemecod ,admemeatetriano ,admemeatetrinum ,admememotegrcod ,admemeultpriatecod ,admemeresatenintecod ,admemeresegrflg ,admemeegrdiagcod ,admemeegrtipodiagcod ,admemepacsecnum ,admemesoscovid, pertipdocidencod, perdocidennum, pernacfec, persexocod

	FROM tmp_{tabla} 
	;
	"""

	c1= text(query)
	connection3.execute(c1)



	#BORRAMOS LAS TABLAS
	query2=f"""
	DROP TABLE tmp_{tabla};
	"""
	c2= text(query2)
	cursor=connection3.execute(c2)


	base1.rename(columns={
		'acopaccod': 'acopaco',
		'admemeactmednum': 'act_med',
		'admemeadmfec': 'fec_adm',
		'admemeadmhor': 'hor_adm',
		'admemealtadmfec': 'fec_aad',
		'admemealtadmhor': 'hor_aad',
		'admemealtadmobs': 'obs_aad',
		'admemealtmedfec': 'fec_alt',
		'admemealtmedhor': 'hor_alt',
		'admemearehoscod': 'cod_are',
		'admemeatetriano': 'tri_ano',
		'admemeatetriarehoscod': 'tri_are',
		'admemeatetricenasicod': 'tri_cas',
		'admemeatetriemecod': 'tri_eme',
		'admemeatetrinum': 'tri_num',
		'admemeatetrioricenasicod': 'tri_ori',
		'admemecenasicod': 'cod_cas',
		'admemecrefec': 'fec_cre',
		'admemeegrdiagcod': 'egr_dx',
		'admemeegrflg': 'egr_flg',
		'admemeegrtipodiagcod': 'egr_tdx',
		'admemeemecod': 'cod_eme',
		'admemeestregcod': 'est_reg',
		'admememodfec': 'fec_mod',
		'admememotegrcod': 'mot_egr',
		'admemeobs': 'adm_obs',
		'admemeoricenasicod': 'ori_cas',
		'admemepacsecnum': 'pac_sec',
		'admemepagnum': 'num_pag',
		'admemeresatenintecod': 'res_int',
		'admemeresegrflg': 'res_flg',
		'admemesoscovid': 'covid',
		'admemetopemecod': 'top_eme',
		'admemeultpriatecod': 'ult_pri',
		'admemeusucrecod': 'usu_cre',
		'admemeusumodcod': 'usu_mod',
		'estgepcod': 'est_gep',
		'tipacccod': 'tip_acc',
		'pertipdocidencod': 'cod_tdi_pac', 
		'perdocidennum': 'num_doc_pac',
		'pernacfec': 'pac_fec_nac',
		'persexocod': 'pac_sexo'
	}, inplace=True)

	
	base1 = base1.drop('admemeacopacnom', axis=1)

	
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

	
	are = pd.read_sql_query(f"SELECT id_area,cod_are FROM dim_areas", con=connection2)
	base1=pd.merge(base1,are,how='left',on='cod_are')
	base1=base1.drop('cod_are',axis=1)

	
	eme = pd.read_sql_query(f"SELECT id_emecod, cod_eme FROM dim_emecod", con=connection2)
	eme['cod_eme']=eme['cod_eme'].str.strip()
	base1['cod_eme']=base1['cod_eme'].str.strip()
	base1=pd.merge(base1,eme,how='left',on='cod_eme')
	base1=base1.drop('cod_eme',axis=1)

	
	emeacc = pd.read_sql_query(f"SELECT id_emeacc, cod_acc FROM dim_emeacc", con=connection2)
	emeacc=emeacc.rename(columns={"cod_acc":"tip_acc"})
	emeacc['tip_acc']=emeacc['tip_acc'].str.strip()
	base1['tip_acc']=base1['tip_acc'].str.strip()
	base1=pd.merge(base1,emeacc,how='left',on='tip_acc')
	base1=base1.drop('tip_acc',axis=1)

	
	emeaco = pd.read_sql_query(f"SELECT id_emeaco, cod_aco FROM dim_emeaco", con=connection2)
	emeaco=emeaco.rename(columns={"cod_aco":"acopaco"})
	emeaco['acopaco']=emeaco['acopaco'].str.strip()
	base1['acopaco']=base1['acopaco'].str.strip()
	base1=pd.merge(base1,emeaco,how='left',on='acopaco')
	base1=base1.drop('acopaco',axis=1)

	
	egrflg = pd.read_sql_query(f"SELECT id_emeegr,cod_egr FROM dim_emeegr", con=connection2)
	egrflg=egrflg.rename(columns={"cod_egr":"egr_flg"})
	egrflg=egrflg.rename(columns={"id_emeegr":"id_egrflg"})
	egrflg['egr_flg']=egrflg['egr_flg'].str.strip()
	base1['egr_flg']=base1['egr_flg'].str.strip()
	base1=pd.merge(base1,egrflg,how='left',on="egr_flg")
	base1=base1.drop('egr_flg',axis=1)

	
	estreg = pd.read_sql_query(f"SELECT id_estreg,cod_est FROM dim_estreg", con=connection2)
	estreg=estreg.rename(columns={"cod_est":"est_reg"})
	estreg['est_reg']=estreg['est_reg'].str.strip()
	base1['est_reg']=base1['est_reg'].str.strip()
	base1=pd.merge(base1,estreg,how='left',on="est_reg")
	base1=base1.drop('est_reg',axis=1)

	
	topeme = pd.read_sql_query(f"SELECT id_emetop,cod_top FROM dim_emetop", con=connection2)
	topeme=topeme.rename(columns={"cod_top":"top_eme"})
	topeme=topeme.rename(columns={"id_emetop":"id_topeme"})
	topeme['top_eme']=topeme['top_eme'].str.strip()
	base1['top_eme']=base1['top_eme'].str.strip()
	base1=pd.merge(base1,topeme,how='left',on='top_eme')
	base1=base1.drop('top_eme',axis=1)

	
	oricas = pd.read_sql_query(f"SELECT id_oricas, ori_cod FROM dim_oricas", con=connection2)
	oricas = oricas.rename(columns={"ori_cod": "tri_ori"})
	oricas = oricas.rename(columns={"id_oricas": "id_oritri"})
	oricas['tri_ori']=oricas['tri_ori'].str.strip()
	base1['tri_ori']=base1['tri_ori'].str.strip()
	base1 = pd.merge(base1, oricas, on='tri_ori', how="left")
	base1 = base1.drop('tri_ori', axis=1)

	
	cas = pd.read_sql_query(f"SELECT id_cas,cod_cas, cod_red FROM dim_cas where id_cas is not null", con=connection2)
	cas = cas.drop_duplicates(subset=['cod_cas'])
	cas=cas.dropna()
	red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)
	cas_red = pd.merge(cas, red, how="left", on="cod_red")
	cas_red = cas_red.rename(columns={"cod_cas": "tri_cas"})
	cas_red = cas_red.rename(columns={"id_cas": "id_castri"})
	cas_red = cas_red.rename(columns={"id_red": "id_redtri"})
	base1 = pd.merge(base1, cas_red, on='tri_cas', how="left")
	base1 = base1.drop('cod_red', axis=1)
	base1 = base1.drop('tri_cas', axis=1)

	
	triare = pd.read_sql_query(f"SELECT id_area,cod_are FROM dim_areas", con=connection2)
	triare=triare.rename(columns={"cod_are":"tri_are"})
	triare=triare.rename(columns={"id_area":"id_triare"})
	triare['tri_are']=triare['tri_are'].str.strip()
	base1['tri_are']=base1['tri_are'].str.strip()
	base1=pd.merge(base1,triare,how='left',on='tri_are')
	base1 = base1.drop('tri_are', axis=1)

	
	trieme = pd.read_sql_query(f"SELECT id_emecod,cod_eme FROM dim_emecod", con=connection2)
	trieme=trieme.rename(columns={"id_emecod":"id_trieme"})
	trieme=trieme.rename(columns={"cod_eme":"tri_eme"})
	trieme['tri_eme']=trieme['tri_eme'].str.strip()
	base1['tri_eme']=base1['tri_eme'].str.strip()
	base1=pd.merge(base1,trieme,how='left',on='tri_eme')
	base1 = base1.drop('tri_eme', axis=1)

	
	motegr = pd.read_sql_query(f"SELECT id_motegr,cod_mot FROM dim_motegr", con=connection2)
	motegr=motegr.rename(columns={"cod_mot":"mot_egr"})
	motegr['mot_egr']=motegr['mot_egr'].str.strip()
	base1['mot_egr']=base1['mot_egr'].str.strip()
	base1=pd.merge(base1,motegr,how='left',on='mot_egr')
	base1 = base1.drop('mot_egr', axis=1)

	
	ultpri = pd.read_sql_query(f"SELECT id_emepri,cod_pri FROM dim_emepri", con=connection2)
	ultpri=ultpri.rename(columns={"id_emepri":"id_ultpri"})
	ultpri=ultpri.rename(columns={"cod_pri":"ult_pri"})
	ultpri['ult_pri']=ultpri['ult_pri'].str.strip()
	base1['ult_pri']=base1['ult_pri'].str.strip()
	base1=pd.merge(base1,ultpri,how='left',on='ult_pri')
	base1 = base1.drop('ult_pri', axis=1)

	
	cie10 = pd.read_sql_query(f"SELECT id_cie,cod_cie FROM dim_cie10", con=connection2)
	cie10 = cie10.rename(columns={"id_cie": "id_cie_egr"})
	cie10 = cie10.rename(columns={"cod_cie": "egr_dx"})
	cie10['egr_dx']=cie10['egr_dx'].str.strip()
	base1['egr_dx']=base1['egr_dx'].str.strip()
	base1 = pd.merge(base1, cie10, on='egr_dx', how="left")
	base1 = base1.drop('egr_dx', axis=1)

	
	tipdx = pd.read_sql_query(f"SELECT id_tipdx,cod_tdx FROM dim_tipdx", con=connection2)
	tipdx = tipdx.rename(columns={"id_tipdx": "id_tipcie_egr"})
	tipdx = tipdx.rename(columns={"cod_tdx": "egr_tdx"})
	tipdx['egr_tdx']=tipdx['egr_tdx'].str.strip()
	base1['egr_tdx']=base1['egr_tdx'].str.strip()
	base1 = pd.merge(base1, tipdx, on='egr_tdx', how="left")
	base1 = base1.drop('egr_tdx', axis=1)

	
	tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
	tipdoc=tipdoc.rename(columns={"id_tipdoc":"id_tdi_pac"})
	tipdoc=tipdoc.rename(columns={"cod_tdo":"cod_tdi_pac"})
	base1=pd.merge(base1,tipdoc,how='left',on='cod_tdi_pac')
	base1 = base1.drop('cod_tdi_pac', axis=1)

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

	
	fecha_ini = fecha_fin_mes

	finproceso=time.time()
	tiempoproceso=finproceso - inicioTiempo
	tiempoproceso=round(tiempoproceso,3)
	print("Proceso completado satisfactoriamente en " + str(tiempoproceso)+" segundos")


now2 = datetime.now().strftime('%Y-%m-%d')
query2=f"UPDATE etl_act SET fec_ini ='{now2}' WHERE id_mod=9"
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