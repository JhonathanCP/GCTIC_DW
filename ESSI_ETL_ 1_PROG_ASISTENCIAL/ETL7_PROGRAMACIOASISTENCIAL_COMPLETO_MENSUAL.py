tabla='ctppe10'
col_tabla='properfec'
col_essi='fec_pro'
essi='essi_dat_pro001_etl_vf'
col_dat='fec_pro'
#TABLA FINAL
dat='dat_progasis_essi_vf'


from decouple import config
from sqlalchemy import create_engine
import pandas as pd
from datetime import datetime, timedelta
import time 
from datetime import datetime
from sqlalchemy import text
import oracledb
import sys
import psycopg2


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



fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=1", con=connection2)
fecha_ini= fecha_ini.iloc[0, 0]

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=1", con=connection2)
fecha_fin= fecha_fin.iloc[0, 0]


dias_por_intervalo = 10

# Inicializa la fecha actual
fecha_actual = fecha_ini


#MAESTROS PESADOS

personal = pd.read_sql_query(f"SELECT id_person,num_doc FROM dim_personal", con=connection2)
personal = personal.sort_values(by='id_person',ascending=False)
personal["num_doc"]=personal["num_doc"].str.replace(' ', '', regex=True)
personal=personal.drop_duplicates(subset="num_doc")
personal=personal.rename(columns={"id_person":"id_profesional"})
personal=personal.rename(columns={"num_doc":"dni_pro"})

print('dim_personal leido')

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


    query1=f"UPDATE etl_act SET fec_act ='{now1}' WHERE id_mod=1"
    
    c1= text(query1)
    
    connection2.execute(c1)
    

    cas = pd.read_sql_query(f"SELECT id_red,cod_cas,des_cas FROM dim_cas where id_red is not null", con=connection2)
    red = pd.read_sql_query(f"SELECT id_red,cod_red,des_red FROM dim_red", con=connection2)
    cas_red=pd.merge(cas,red,how='left',on='id_red')


    serv = pd.read_sql_query(f"SELECT cod_ser,des_ser FROM dim_servicios", con=connection2)

    tipcuphor = pd.read_sql_query(f"SELECT cod_tch,des_tch FROM dim_tipcuphor", con=connection2)

    tiphor = pd.read_sql_query(f"SELECT cod_thp,des_thp FROM dim_tiphor", con=connection2)

    activi = pd.read_sql_query(f"SELECT cod_act,des_act FROM dim_activi", con=connection2)

    areas = pd.read_sql_query(f"SELECT cod_are,des_are FROM dim_areas", con=connection2)

    estpro = pd.read_sql_query(f"SELECT cod_est,des_est FROM dim_estpro", con=connection2)

    personas = pd.read_sql_query('SELECT tip_doc,num_doc,nombre,gru_ocu,cod_pla,colegio,id_person FROM dim_personal', con=connection2)

    motsuspro = pd.read_sql_query(f"SELECT * FROM dim_motsuspro", con=connection2)

    subacti = pd.read_sql_query(f"SELECT cod_sub,des_sub,cod_act FROM dim_subacti", con=connection2)

    gruocu = pd.read_sql_query(f"SELECT cod_gru,des_gru FROM dim_gruocu", con=connection2)

    tiempo = pd.read_sql_query(f"SELECT dt_fecha,dt_ano,dt_mes FROM dim_tiempo", con=connection2)
    tiempo=tiempo.rename(columns={"dt_fecha":"fec","dt_ano":"ano","dt_mes":"mes"})


    print('maestros listos')

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

    query=f"""select * from ctppe10 WHERE properfec >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and properfec < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"""

    base1 = pd.read_sql_query(query, con=connection0)

    ##COLUMNA NUEVA, SIN RELEVANCIA JEJE

    base1 = base1.drop('propertipohordet',axis=1)

    connection0.close()

    print('lectura lista')


    borrando = f"DELETE FROM ctppe10 WHERE properfec >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and properfec < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
    borrado = connection3.execute(borrando)
    print('borrado listo')

    base1.to_sql(name=f'ctppe10', con=connection3, if_exists='append', index=False,chunksize=10000)


    base2=pd.read_sql_query(f"SELECT * FROM {essi} LIMIT 10", con=connection1)



    base1.shape


    personas["KEY"]=personas["tip_doc"]+personas["num_doc"]
    personas["KEY"]=personas["KEY"].str.replace(' ', '', regex=True)
    personas = personas.drop_duplicates(subset='KEY')
    personas=personas.drop(["tip_doc",'num_doc'], axis=1)
    base1["KEY"]=base1["tipdocidenpercod"].astype(str)+base1['perasisdocidennum'].astype(str)
    base1["KEY"]=base1["KEY"].str.replace(' ', '', regex=True)
    base1 = pd.merge(base1,personas,how='left',on='KEY')
    base1=base1.drop('KEY', axis=1)


    base1.shape


    base1=base1.rename(columns={"gru_ocu":"cod_ocu"})
    base1=base1.rename(columns={"nombre":"nom_pro"})


    base1=base1.rename(columns={"cenasicod":"cod_cas"})
    base1 = pd.merge(base1,cas_red,how='left',on='cod_cas')


    base1.shape


    base1=base1.rename(columns={"servhoscod":"cod_ser"})
    base1 = pd.merge(base1,serv,how='left',on='cod_ser')


    base1.shape


    base1=base1.rename(columns={"propertipoprogperscod":"cod_pro"})
    tipcuphor=tipcuphor.rename(columns={"cod_tch":"cod_pro"})
    base1 = pd.merge(base1,tipcuphor,how='left',on='cod_pro')
    base1=base1.rename(columns={"des_tch":"des_pro"})


    base1.shape


    base1=base1.rename(columns={"arehoscod":"cod_are"})
    base1 = pd.merge(base1,areas,how='left',on='cod_are')



    base1.shape


    base1=base1.rename(columns={"estprogcitcod":"cod_est"})
    base1 = pd.merge(base1,estpro,how='left',on='cod_est')



    base1.shape


    gruocu=gruocu.rename(columns={"cod_gru":"cod_ocu"})
    base1 = pd.merge(base1,gruocu,how='left',on='cod_ocu')
    base1=base1.rename(columns={"des_gru":"des_ocu"})


    base1.shape


    base1=base1.rename(columns={"actcod":"cod_act"})
    base1 = pd.merge(base1,activi,how='left',on='cod_act')



    base1.shape


    base1=base1.rename(columns={"actespcod":"cod_sub"})
    subacti["KEY"]=subacti["cod_sub"]+subacti["cod_act"]
    subacti=subacti.drop(["cod_sub",'cod_act'], axis=1)
    base1["KEY"]=base1["cod_sub"].astype(str)+base1['cod_act'].astype(str)
    base1["KEY"]=base1["KEY"].str.replace(' ', '', regex=True)
    subacti["KEY"]=subacti["KEY"].str.replace(' ', '', regex=True)
    base1 = pd.merge(base1,subacti,how='left',on='KEY')
    base1=base1.drop('KEY', axis=1)




    base1.shape


    base1=base1.rename(columns={"tipohorprogcod":"cod_tho"})
    tiphor=tiphor.rename(columns={"cod_thp":"cod_tho"})
    base1 = pd.merge(base1,tiphor,how='left',on='cod_tho')



    base1.shape


    base1=base1.rename(columns={"motsusprogcod":"cod_sus"})
    motsuspro=motsuspro.rename(columns={"cod_mot":"cod_sus"})
    base1 = pd.merge(base1,motsuspro,how='left',on='cod_sus')
    base1=base1.rename(columns={"des_mot":"mot_sus"})


    base1.shape


    tiempo1=tiempo.rename(columns={"fec":"fec_pro"})
    tiempo1['fec_pro'] = pd.to_datetime(tiempo1['fec_pro'])
    base1 = base1.rename(columns={"properfec":"fec_pro"})
    base1 = pd.merge(base1, tiempo1, how='left', on='fec_pro')
    base1['ano']=base1['ano'].astype(int)
    base1['mes']=base1['mes'].astype(int)
    base1['ano_mes'] = base1['ano'].astype(str) + base1['mes'].astype(str)



    base1.shape


    base1['mes'] = base1['mes'].astype(str).str.zfill(2)



    base1['ano_mes'] = base1['ano'].astype(str) + base1['mes'].astype(str)



    base1=base1.rename(columns={"oricenasicod":"cod_ori"})
    base1=base1.rename(columns={"propermodfec":"fec_mod"})
    base1=base1.rename(columns={"propercrefec":"fec_reg"})
    base1=base1.rename(columns={"propersusfec":"fec_sus"})



    base1=base1.rename(columns={"perasisdocidennum":"dni_pro"})
    base1=base1.rename(columns={"properestregcod":"est_reg"})
    base1=base1.rename(columns={"tipdocidenpercod":"tdo_pro"})
    base1=base1.rename(columns={"properprohortot":"tot_hor"})
    base1=base1.rename(columns={"properusumodcod":"usu_mod"})
    base1=base1.rename(columns={"properusucrecod":"usu_reg"})



    base1=base1.rename(columns={"properturhorfin":"hor_fin"})
    base1=base1.rename(columns={"properturhorini":"hor_ini"})


    base1['hor_ini']=base1['hor_ini'].astype(str).str[10:30]
    base1['hor_fin']=base1['hor_fin'].astype(str).str[10:30]


    base1['cod_pla'].fillna(-1, inplace=True)
    base1['cod_pla'] = base1['cod_pla'].astype(int)
    base1['cod_pla'] = base1['cod_pla'].replace(-1, None)
    base1['cod_pla'] = base1['cod_pla'].astype(str)


    base1['hor_ini'] = base1['hor_ini'].str[0:6]


    base1['hor_fin'] = base1['hor_fin'].str[0:6]


    base1['hor_fin']=base1["hor_fin"].str.replace(' ', '', regex=True)
    base1['hor_ini']=base1["hor_ini"].str.replace(' ', '', regex=True)
    base1['hor_fin']=base1["hor_fin"].str.replace(',', '', regex=True)
    base1['hor_ini']=base1["hor_ini"].str.replace(',', '', regex=True)


    base1['turno']=base1['hor_ini'].astype(str)+"-"+base1['hor_fin'].astype(str)
    
    print('emparejamientos essi listos')

    borrando = f"DELETE FROM {essi} WHERE {col_essi} >= '{fecha_ini_str}' and {col_essi} < '{fecha_fin_str}'"
    borrado = connection1.execute(borrando)

    print('limpieza essi lista')

    df1_columns = set(base1.columns)
    df2_columns = set(base2.columns) 
    different_columns = df2_columns - df1_columns
    different_columns


    comunes = set(base1.columns).intersection(set(base2.columns)) 
    base = base1[list(comunes)]



    base.to_sql(name=f'{essi}', con=connection1, if_exists='append', index=False,chunksize=10000)


    print('subida essi lista')

    base2=pd.read_sql_query(f"SELECT * FROM {dat} LIMIT 10", con=connection2)


    base1=base


    proceso = pd.read_sql_query("SELECT des_mod FROM etl_act where id_mod=1", con=connection2)
    proceso= proceso.iloc[0, 0]
    cod_proceso = pd.read_sql_query("SELECT id_mod FROM etl_act where id_mod=1", con=connection2)
    cod_proceso= cod_proceso.iloc[0, 0]
    control_a=[]
    control_d=[]
    dim=[]
    falla=[]


    control_a.append(base1.shape[0])


    base1_orig = base1.copy()


    cas = pd.read_sql_query(f"SELECT id_cas,cod_cas FROM dim_cas where id_red is not null", con=connection2)
    cas = cas.drop_duplicates(subset=['id_cas', 'cod_cas'])
    cas=cas.dropna()
    merge=pd.merge(base1,cas,how='left',on='cod_cas')
    base1=pd.merge(base1,cas,how='left',on='cod_cas')
    base1=base1.drop('cod_cas',axis=1)


    filas_perdidas = merge.loc[pd.isnull(merge['id_cas'])]
    filas_perdidas = filas_perdidas.drop_duplicates(subset=['cod_cas'])
    filas_perdidas=filas_perdidas[['cod_cas']]
    if filas_perdidas.empty:
        filas_perdidas_string = 0
    else:
        filas_perdidas_string = filas_perdidas.to_string(index=False, header=False)
        filas_perdidas_string = filas_perdidas_string.replace('\n', ',')
    falla.append(filas_perdidas_string)


    base1.shape


    dim.append('dim_cas')
    control_d.append(base1.shape[0])
    control_a.append(base1.shape[0])


    red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)
    base1=pd.merge(base1,red,how='left',on='cod_red')
    base1=base1.drop('cod_red',axis=1)


    filas_perdidas_string = 0
    falla.append(filas_perdidas_string)


    base1.shape


    dim.append('dim_red')
    control_d.append(base1.shape[0])
    control_a.append(base1.shape[0])


    are = pd.read_sql_query(f"SELECT id_area,cod_are FROM dim_areas", con=connection2)
    merge=pd.merge(base1,are,how='left',on='cod_are')
    base1=pd.merge(base1,are,how='left',on='cod_are')
    base1=base1.drop('cod_are',axis=1)


    filas_perdidas = merge.loc[pd.isnull(merge['id_area'])]
    filas_perdidas = filas_perdidas.drop_duplicates(subset=['cod_are'])
    filas_perdidas=filas_perdidas[['cod_are']]
    if filas_perdidas.empty:
        filas_perdidas_string = 0
    else:
        filas_perdidas_string = filas_perdidas.to_string(index=False, header=False)
        filas_perdidas_string = filas_perdidas_string.replace('\n', ',')
    falla.append(filas_perdidas_string)


    base1.shape


    dim.append('dim_areas')
    control_d.append(base1.shape[0])
    control_a.append(base1.shape[0])


    base1['fec_mod']=base1['fec_mod'].astype(str)
    base1['fec_pro']=base1['fec_pro'].astype(str)
    base1['fec_reg']=base1['fec_reg'].astype(str)
    base1['fec_sus']=base1['fec_sus'].astype(str)



    base1['fe_mod'] = base1['fec_mod'].str[:10]
    base1['fe_sus'] = base1['fec_sus'].str[:10]
    base1['fe_pro'] = base1['fec_pro'].str[:10]
    base1['fe_reg'] = base1['fec_reg'].str[:10]



    tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)
    tiempo=tiempo.rename(columns={"id_tiempo":"id_time_mod","dt_fecha":"fe_mod","dt_mes":"mes_mod","dt_dia":"dia_mod","dt_dia_sem":"dia_sem_mod","dt_sem":"sem_mod","dt_ano":"ano_mod"})
    tiempo['fe_mod']=tiempo['fe_mod'].astype(str).str.replace(' ', '', regex=True)
    base1=pd.merge(base1,tiempo,how='left',on='fe_mod')

    tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)
    tiempo=tiempo.rename(columns={"id_tiempo":"id_time_sus","dt_fecha":"fe_sus","dt_mes":"mes_sus","dt_dia":"dia_sus","dt_dia_sem":"dia_sem_sus","dt_sem":"sem_sus","dt_ano":"ano_sus"})
    tiempo['fe_sus']=tiempo['fe_sus'].astype(str).str.replace(' ', '', regex=True)
    base1=pd.merge(base1,tiempo,how='left',on='fe_sus')

    tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)
    tiempo=tiempo.rename(columns={"id_tiempo":"id_time_reg","dt_fecha":"fe_reg","dt_mes":"mes_reg","dt_dia":"dia_reg","dt_dia_sem":"dia_sem_reg","dt_sem":"sem_reg","dt_ano":"ano_reg"})
    tiempo['fe_reg']=tiempo['fe_reg'].astype(str).str.replace(' ', '', regex=True)
    base1=pd.merge(base1,tiempo,how='left',on='fe_reg')

    tiempo = pd.read_sql_query(f"SELECT id_tiempo,dt_fecha,dt_mes,dt_dia,dt_dia_sem,dt_sem,dt_ano FROM dim_tiempo", con=connection2)
    tiempo=tiempo.rename(columns={"id_tiempo":"id_time_pro","dt_fecha":"fe_pro","dt_mes":"mes_pro","dt_dia":"dia_pro","dt_dia_sem":"dia_sem_pro","dt_sem":"sem_pro","dt_ano":"ano_pro"})
    tiempo['fe_pro']=tiempo['fe_pro'].astype(str).str.replace(' ', '', regex=True)
    base1=pd.merge(base1,tiempo,how='left',on='fe_pro')




    base1.shape


    serv= pd.read_sql_query(f"SELECT id_serv,cod_ser FROM dim_servicios", con=connection2)
    serv=serv.rename(columns={"id_serv":"id_servic"})
    merge=pd.merge(base1,serv,how='left',on='cod_ser')
    base1=pd.merge(base1,serv,how='left',on='cod_ser')
    base1=base1.drop('cod_ser',axis=1)



    filas_perdidas = merge.loc[pd.isnull(merge['id_servic'])]
    filas_perdidas = filas_perdidas.drop_duplicates(subset=['cod_ser'])
    filas_perdidas=filas_perdidas[['cod_ser']]
    if filas_perdidas.empty:
        filas_perdidas_string = 0
    else:
        filas_perdidas_string = filas_perdidas.to_string(index=False, header=False)
        filas_perdidas_string = filas_perdidas_string.replace('\n', ',')
    falla.append(filas_perdidas_string)


    base1.shape


    dim.append('dim_servicios')
    control_d.append(base1.shape[0])
    control_a.append(base1.shape[0])


    origen = pd.read_sql_query(f"SELECT id_oricas,ori_cod FROM dim_oricas", con=connection2)
    origen=origen.rename(columns={"ori_cod":"cod_ori"})
    origen=origen.rename(columns={"id_oricas":"id_origen"})
    merge=pd.merge(base1,origen,how='left',on='cod_ori')
    base1=pd.merge(base1,origen,how='left',on='cod_ori')
    base1=base1.drop('cod_ori',axis=1)


    filas_perdidas = merge.loc[pd.isnull(merge['id_origen'])]
    filas_perdidas = filas_perdidas.drop_duplicates(subset=['cod_ori'])
    filas_perdidas=filas_perdidas[['cod_ori']]
    if filas_perdidas.empty:
        filas_perdidas_string = 0
    else:
        filas_perdidas_string = filas_perdidas.to_string(index=False, header=False)
        filas_perdidas_string = filas_perdidas_string.replace('\n', ',')
    falla.append(filas_perdidas_string)


    base1.shape


    dim.append('dim_oricas')
    control_d.append(base1.shape[0])
    control_a.append(base1.shape[0])


    tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
    tipdoc=tipdoc.rename(columns={"cod_tdo":"tdo_pro"})
    merge=pd.merge(base1,tipdoc,how='left',on='tdo_pro')
    base1=pd.merge(base1,tipdoc,how='left',on='tdo_pro')
    base1=base1.drop('tdo_pro',axis=1)


    filas_perdidas = merge.loc[pd.isnull(merge['id_tipdoc'])]
    filas_perdidas = filas_perdidas.drop_duplicates(subset=['tdo_pro'])
    filas_perdidas=filas_perdidas[['tdo_pro']]
    if filas_perdidas.empty:
        filas_perdidas_string = 0
    else:
        filas_perdidas_string = filas_perdidas.to_string(index=False, header=False)
        filas_perdidas_string = filas_perdidas_string.replace('\n', ',')
    falla.append(filas_perdidas_string)


    base1.shape


    dim.append('dim_tipdoc')
    control_d.append(base1.shape[0])
    control_a.append(base1.shape[0])


    activi = pd.read_sql_query(f"SELECT id_activi,cod_act FROM dim_activi", con=connection2)
    activi=activi.rename(columns={"id_activi":"id_acti"})
    merge=pd.merge(base1,activi,how='left',on='cod_act')
    base1=pd.merge(base1,activi,how='left',on='cod_act')



    filas_perdidas = merge.loc[pd.isnull(merge['id_acti'])]
    filas_perdidas = filas_perdidas.drop_duplicates(subset=['cod_act'])
    filas_perdidas=filas_perdidas[['cod_act']]
    if filas_perdidas.empty:
        filas_perdidas_string = 0
    else:
        filas_perdidas_string = filas_perdidas.to_string(index=False, header=False)
        filas_perdidas_string = filas_perdidas_string.replace('\n', ',')
    falla.append(filas_perdidas_string)


    base1.shape


    dim.append('dim_activi')
    control_d.append(base1.shape[0])
    control_a.append(base1.shape[0])


    subacti = pd.read_sql_query(f"SELECT id_subacti,cod_sub,cod_act FROM dim_subacti", con=connection2)
    base1=base1.rename(columns={"actespcod":"cod_sub"})
    subacti["KEY"]=subacti["cod_sub"]+subacti["cod_act"]
    subacti=subacti.drop(["cod_sub",'cod_act'], axis=1)
    base1["KEY"]=base1["cod_sub"].astype(str)+base1['cod_act'].astype(str)
    base1["KEY"]=base1["KEY"].str.replace(' ', '', regex=True)
    subacti["KEY"]=subacti["KEY"].str.replace(' ', '', regex=True)
    merge=pd.merge(base1,subacti,how='left',on='KEY')
    base1 = pd.merge(base1,subacti,how='left',on='KEY')
    base1=base1.drop('KEY', axis=1)


    filas_perdidas = merge.loc[pd.isnull(merge['id_subacti'])]
    filas_perdidas = filas_perdidas.drop_duplicates(subset=['KEY'])
    filas_perdidas=filas_perdidas[['KEY']]
    if filas_perdidas.empty:
        filas_perdidas_string = 0
    else:
        filas_perdidas_string = filas_perdidas.to_string(index=False, header=False)
        filas_perdidas_string = filas_perdidas_string.replace('\n', ',')
    falla.append(filas_perdidas_string)


    base1.shape


    dim.append('dim_subacti')
    control_d.append(base1.shape[0])
    control_a.append(base1.shape[0])


    gruocu = pd.read_sql_query(f"SELECT id_gruocu,cod_gru FROM dim_gruocu", con=connection2)
    gruocu=gruocu.rename(columns={"cod_gru":"cod_ocu"})
    base1=pd.merge(base1,gruocu,how='left',on='cod_ocu')
    base1=base1.drop('cod_ocu',axis=1)


    filas_perdidas_string = 0
    falla.append(filas_perdidas_string)


    base1.shape


    dim.append('dim_gruocu')
    control_d.append(base1.shape[0])
    control_a.append(base1.shape[0])


    tiphor = pd.read_sql_query(f"SELECT id_tiphor,cod_thp FROM dim_tiphor", con=connection2)
    tiphor=tiphor.rename(columns={"cod_thp":"cod_tho"})
    merge=pd.merge(base1,tiphor,how='left',on='cod_tho')
    base1=pd.merge(base1,tiphor,how='left',on='cod_tho')
    base1=base1.drop('cod_tho',axis=1)



    filas_perdidas = merge.loc[pd.isnull(merge['id_tiphor'])]
    filas_perdidas = filas_perdidas.drop_duplicates(subset=['cod_tho'])
    filas_perdidas=filas_perdidas[['cod_tho']]
    if filas_perdidas.empty:
        filas_perdidas_string = 0
    else:
        filas_perdidas_string = filas_perdidas.to_string(index=False, header=False)
        filas_perdidas_string = filas_perdidas_string.replace('\n', ',')
    falla.append(filas_perdidas_string)


    base1.shape


    dim.append('dim_tiphor')
    control_d.append(base1.shape[0])
    control_a.append(base1.shape[0])



    base1["dni_pro"]=base1["dni_pro"].str.replace(' ', '', regex=True)
    merge=pd.merge(base1,personal,how='left',on='dni_pro')
    base1=pd.merge(base1,personal,how='left',on='dni_pro')
    base1=base1.drop('dni_pro',axis=1)



    filas_perdidas = merge.loc[pd.isnull(merge['id_profesional'])]
    filas_perdidas = filas_perdidas.drop_duplicates(subset=['dni_pro'])
    filas_perdidas=filas_perdidas[['dni_pro']]
    if filas_perdidas.empty:
        filas_perdidas_string = 0
    else:
        filas_perdidas_string = filas_perdidas.to_string(index=False, header=False)
        filas_perdidas_string = filas_perdidas_string.replace('\n', ',')
    falla.append(filas_perdidas_string)


    base1.shape


    dim.append('dim_personal')
    control_d.append(base1.shape[0])
    control_a.append(base1.shape[0])


    estpro = pd.read_sql_query(f"SELECT id_estpro,cod_est FROM dim_estpro", con=connection2)
    estpro=estpro.rename(columns={"id_estpro":"id_estado"})
    merge=pd.merge(base1,estpro,how='left',on='cod_est')
    base1=pd.merge(base1,estpro,how='left',on='cod_est')
    base1=base1.drop('cod_est',axis=1)


    filas_perdidas = merge.loc[pd.isnull(merge['id_estado'])]
    filas_perdidas = filas_perdidas.drop_duplicates(subset=['cod_est'])
    filas_perdidas=filas_perdidas[['cod_est']]
    if filas_perdidas.empty:
        filas_perdidas_string = 0
    else:
        filas_perdidas_string = filas_perdidas.to_string(index=False, header=False)
        filas_perdidas_string = filas_perdidas_string.replace('\n', ',')
    falla.append(filas_perdidas_string)


    base1.shape


    dim.append('dim_estpro')
    control_d.append(base1.shape[0])
    control_a.append(base1.shape[0])


    motsuspro = pd.read_sql_query(f"SELECT id_motsus,cod_mot FROM dim_motsuspro", con=connection2)
    motsuspro=motsuspro.rename(columns={"cod_mot":"cod_sus"})
    base1=pd.merge(base1,motsuspro,how='left',on='cod_sus')
    base1=base1.drop('cod_sus',axis=1)



    filas_perdidas_string = 0
    falla.append(filas_perdidas_string)


    base1.shape


    dim.append('dim_motsuspro')
    control_d.append(base1.shape[0])
    control_a.append(base1.shape[0])


    turnos = pd.read_sql_query(f"SELECT id_turno,horas,minutos,destur FROM dim_turnos", con=connection2)
    turnos=turnos.rename(columns={"minutos":"minut"})
    turnos=turnos.rename(columns={"destur":"turno"})
    turnos["turno"]=turnos["turno"].str.replace(' ', '', regex=True)
    base1["turno"]=base1["turno"].str.replace(' ', '', regex=True)
    merge=pd.merge(base1,turnos,how='left',on='turno')
    base1=pd.merge(base1,turnos,how='left',on='turno')
    base1=base1.drop('turno',axis=1)


    filas_perdidas = merge.loc[pd.isnull(merge['id_turno'])]
    filas_perdidas = filas_perdidas.drop_duplicates(subset=['turno'])
    filas_perdidas=filas_perdidas[['turno']]
    if filas_perdidas.empty:
        filas_perdidas_string = 0
    else:
        filas_perdidas_string = filas_perdidas.to_string(index=False, header=False)
        filas_perdidas_string = filas_perdidas_string.replace('\n', ',')
    falla.append(filas_perdidas_string)


    base1.shape


    dim.append('dim_turnos')
    control_d.append(base1.shape[0])
    control_a.append(base1.shape[0])


    tipcuphor = pd.read_sql_query(f"SELECT id_tipcuphor,cod_tch FROM dim_tipcuphor", con=connection2)
    tipcuphor=tipcuphor.rename(columns={"cod_tch":"cod_pro"})
    tipcuphor=tipcuphor.rename(columns={"id_tipcuphor":"id_tippro"})
    merge=pd.merge(base1,tipcuphor,how='left',on='cod_pro')
    base1=pd.merge(base1,tipcuphor,how='left',on='cod_pro')
    base1=base1.drop('cod_pro',axis=1)


    filas_perdidas = merge.loc[pd.isnull(merge['id_tippro'])]
    filas_perdidas = filas_perdidas.drop_duplicates(subset=['cod_pro'])
    filas_perdidas=filas_perdidas[['cod_pro']]
    if filas_perdidas.empty:
        filas_perdidas_string = 0
    else:
        filas_perdidas_string = filas_perdidas.to_string(index=False, header=False)
        filas_perdidas_string = filas_perdidas_string.replace('\n', ',')
    falla.append(filas_perdidas_string)


    base1.shape


    dim.append('dim_tipcuphor')
    control_d.append(base1.shape[0])

    print('emparejamientos dat listos')

    df1_columns = set(base1.columns)
    df2_columns = set(base2.columns) 
    different_columns = df2_columns - df1_columns
    different_columns


    borrando = f"DELETE FROM {dat} WHERE {col_dat} >= '{fecha_ini_str}' and {col_dat} < '{fecha_fin_str}'"
    borrado = connection2.execute(borrando)

    print('limpieza dat lista')

    base1['fec_sus'] = pd.to_datetime(base1['fec_sus'], errors='coerce')
    base1['fec_mod'] = pd.to_datetime(base1['fec_mod'], errors='coerce')
    base1['fec_reg'] = pd.to_datetime(base1['fec_reg'], errors='coerce')

    base1['id_tipdoc'] = base1['id_tipdoc'].replace(10, 1)

    comunes = set(base1.columns).intersection(set(base2.columns)) 
    base = base1[list(comunes)]


    base.to_sql(name=f'{dat}', con=connection2, if_exists='append', index=False,chunksize=10000)


    print('subida dat lista')

    now_fin = datetime.now()
    fecha_log = now1.strftime("%Y-%m-%d")
    hora_log_inicio = now_inicio.strftime("%H:%M")
    hora_log_fin = now_fin.strftime("%H:%M")
    tabla_logs = pd.DataFrame({'esperado':control_a,'obtenido':control_d,'dim':dim,'falla':falla})
    tabla_logs['proceso']=proceso
    tabla_logs['dat']=dat
    tabla_logs['fecha_ejecucion']=fecha_log
    tabla_logs['hora_inicio']=hora_log_inicio
    tabla_logs['hora_fin']=hora_log_fin
    tabla_logs['faltante']=tabla_logs['esperado']-tabla_logs['obtenido']
    tabla_logs['codigo']=1
    tabla_logs['fecha_ini']=fecha_ini_str
    tabla_logs['fecha_ter']=fecha_fin_str

    nuevas_columnas = ['codigo', 'proceso', 'dat', 'fecha_ejecucion', 'hora_inicio','hora_fin', 'dim', 'fecha_ini','fecha_ter','esperado', 'obtenido', 'faltante','falla']

    tabla_logs = tabla_logs.reindex(columns=nuevas_columnas)



    tabla_logs.to_sql(name=f'logs', con=connection4, if_exists='append', index=False,chunksize=10000)


    fecha_actual = fecha_fin_intervalo

    finproceso=time.time()
    tiempoproceso=finproceso - inicioTiempo
    tiempoproceso=round(tiempoproceso,3)
    print("Proceso completado satisfactoriamente en " + str(tiempoproceso)+" segundos")

query2=f"UPDATE etl_act SET fec_ini ='{now2}' WHERE id_mod=1"
c2= text(query2)
connection2.execute(c2)

connection1.close()
connection2.close()
connection3.close()

engine1.dispose()
engine2.dispose()
engine3.dispose()