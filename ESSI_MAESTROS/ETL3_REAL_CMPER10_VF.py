
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


tabla = 'cmper10'
col_tabla = 'perinsfec'
dim = 'dim_pacsec'
col_dim = 'fec_ins'

fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=8", con=connection2)
fecha_ini= fecha_ini.iloc[0, 0]

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=8", con=connection2)
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

    print(f"Procesando DIM_PACSEC de {fecha_ini_str} al {fecha_fin_str}")


    now = datetime.datetime.now()

    query=f"UPDATE etl_act SET fec_act ='{now}' WHERE id_mod=8"

    c1= text(query)
    connection2.execute(c1)

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

    base1 = pd.read_sql_query(f"SELECT * FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')", con=connection0)

    connection0.close()

    # Reemplaza caracteres nulos con valores vacíos en el DataFrame
    base1 = base1.replace('\x00', '', regex=True)

    base1.to_sql(name=f'tmp_{tabla}', con=engine3, if_exists='replace', index=False, chunksize=200000)

    borrado = f"DELETE FROM {tabla} WHERE {col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
    borrado = connection3.execute(borrado)

    # ACTUALIZAMOS EL cmper10 FALSO CON LO OBTENIDO DEL ORACLE

    query = f"""
    ALTER TABLE tmp_cmper10 
    ALTER COLUMN persecnum TYPE numeric(10,0) USING persecnum::numeric(10,0),
    ALTER COLUMN pertipdocidencod TYPE character(1),
    ALTER COLUMN perdocidennum TYPE character(15),
    ALTER COLUMN perapepatdes TYPE character(20),
    ALTER COLUMN perapematdes TYPE character(20),
    ALTER COLUMN perprinomdes TYPE character(10),
    ALTER COLUMN persegnomdes TYPE character(10),
    ALTER COLUMN pernacfec TYPE date USING pernacfec::date,
    ALTER COLUMN persexocod TYPE character(1),
    ALTER COLUMN perestcivcod TYPE character(1),
    ALTER COLUMN pertipsegcod TYPE character(2),
    ALTER COLUMN perautcod TYPE character(15),
    ALTER COLUMN perubigeonacnom TYPE character(60),
    ALTER COLUMN perempasecod TYPE character(1),
    ALTER COLUMN peroricenasiadscod TYPE character(1),
    ALTER COLUMN percenasiadscod TYPE character(3),
    ALTER COLUMN perinsfec TYPE  date USING perinsfec::date,
    ALTER COLUMN pervigfec TYPE  date USING pervigfec::date,
    ALTER COLUMN perfalfec TYPE date USING perfalfec::date,
    ALTER COLUMN percaldomnom TYPE character(20),
    ALTER COLUMN pernmkdomnum TYPE character(4),
    ALTER COLUMN perinldomnum TYPE character(4),
    ALTER COLUMN perurbdomnom TYPE character(15),
    ALTER COLUMN perubigeodomnom TYPE character(60),
    ALTER COLUMN persectitnum TYPE numeric(10,0) USING persectitnum::numeric(10,0),
    ALTER COLUMN percittflg TYPE character(1),
    ALTER COLUMN perafesctrflg TYPE character(1),
    ALTER COLUMN perafeessvidflg TYPE character(1),
    ALTER COLUMN perlatflg TYPE character(1),
    ALTER COLUMN perfacflg TYPE character(1),
    ALTER COLUMN percertmednum TYPE character(10),
    ALTER COLUMN perplansalucod TYPE character(2),
    ALTER COLUMN pertipoparecod TYPE character(2),
    ALTER COLUMN perestregcod TYPE character(1),
    ALTER COLUMN perusucrecod TYPE character(10),
    ALTER COLUMN percrefec TYPE date USING percrefec::date,
    ALTER COLUMN perusumodcod TYPE character(10),
    ALTER COLUMN permodfec TYPE date USING permodfec::date,
    ALTER COLUMN peracrcomtipcod TYPE character(2),
    ALTER COLUMN peracrcomnum TYPE numeric(15,0) USING peracrcomnum::numeric(15,0),
    ALTER COLUMN peracrcommotcod TYPE character(2),
    ALTER COLUMN perintpreautcod TYPE character(18),
    ALTER COLUMN perubigeonac TYPE character(6),
    ALTER COLUMN perrucempnum TYPE character(11),
    ALTER COLUMN perubigeodom TYPE character(6),
    ALTER COLUMN perauttitcod TYPE character(15),
    ALTER COLUMN peraporperio TYPE date USING perfalfec::date,
    ALTER COLUMN perrazanegraflg TYPE character(1),
    ALTER COLUMN perindate TYPE character(1);


    INSERT INTO cmper10 (persecnum, pertipdocidencod, perdocidennum, perapepatdes, perapematdes, perprinomdes, persegnomdes, pernacfec, persexocod, perestcivcod, pertipsegcod, perautcod, perubigeonacnom, perempasecod, peroricenasiadscod, percenasiadscod, perinsfec, pervigfec, perfalfec, percaldomnom, pernmkdomnum, perinldomnum, perurbdomnom, perubigeodomnom, persectitnum, percittflg, perafesctrflg, perafeessvidflg, perlatflg, perfacflg, percertmednum, perplansalucod, pertipoparecod, perestregcod, perusucrecod, percrefec, perusumodcod, permodfec, peracrcomtipcod, peracrcomnum, peracrcommotcod, perintpreautcod, perubigeonac, perrucempnum, perubigeodom, perauttitcod, peraporperio, perrazanegraflg, perindate) 

    SELECT persecnum, pertipdocidencod, perdocidennum, perapepatdes, perapematdes, perprinomdes, persegnomdes, pernacfec, persexocod, perestcivcod, pertipsegcod, perautcod, perubigeonacnom, perempasecod, peroricenasiadscod, percenasiadscod, perinsfec, pervigfec, perfalfec, percaldomnom, pernmkdomnum, perinldomnum, perurbdomnom, perubigeodomnom, persectitnum, percittflg, perafesctrflg, perafeessvidflg, perlatflg, perfacflg, percertmednum, perplansalucod, pertipoparecod, perestregcod, perusucrecod, percrefec, perusumodcod, permodfec, peracrcomtipcod, peracrcomnum, peracrcommotcod, perintpreautcod, perubigeonac, perrucempnum, perubigeodom, perauttitcod, peraporperio, perrazanegraflg, perindate

    FROM tmp_{tabla}
    ;
    """
    #SE OMITIO CPDURMIN POR SER TOTALMENTE NULO 

    c1= text(query)
    connection3.execute(c1)



    #BORRAMOS LAS TABLAS
    query2=f"""
    DROP TABLE tmp_{tabla};
    """
    c2= text(query2)
    cursor=connection3.execute(c2)


    borrado = f"DELETE FROM {dim} WHERE {col_dim} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and {col_dim} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
    borrado = connection2.execute(borrado)

    query=f"""
    INSERT INTO dim_pacsec (per_sec, id_tipdoc, num_doc, nom_pac, fec_nac, sexo,ori_ads,cas_ads,est_civ,tip_seg,fec_ins,fec_cre,fec_mod,tip_par,emp_ase,ubi_dom) 
    SELECT 
        tmp_tbl.persecnum AS per_sec,
        tmp_tbl.pertipdocidencod AS id_tipdoc,
        TRIM(tmp_tbl.perdocidennum) AS num_doc,
        CONCAT(TRIM(tmp_tbl.perprinomdes), ' ', TRIM(tmp_tbl.persegnomdes), ' ', TRIM(tmp_tbl.perapepatdes), ' ', TRIM(tmp_tbl.perapematdes)) AS nom_pac,
        tmp_tbl.pernacfec AS fec_nac,
        dim_sexo.id_sexo AS sexo,
        dim_oricas.id_oricas AS ori_ads,
        dim_cas.id_cas AS cas_ads,
        dim_estciv.id_estciv AS est_civ,
        dim_tipseg.id_tipseg AS tip_seg,
        tmp_tbl.perinsfec AS fec_ins,
        tmp_tbl.percrefec AS fec_cre,
        tmp_tbl.permodfec AS fec_mod,
        dim_paren.id_paren AS tip_par,
        dim_tipemp.id_tipemp AS emp_ase,
        dim_ubigeo.id_ubigeo AS ubi_dom

    FROM 
        dblink('dbname=dl_essi user=ugaddba001ir password=U64dING23', 
            'SELECT persecnum, pertipdocidencod, TRIM(perdocidennum), persexocod, pernacfec, perprinomdes, persegnomdes, perapepatdes, perapematdes,peroricenasiadscod,percenasiadscod,perestcivcod,pertipsegcod,perinsfec,percrefec,permodfec,pertipoparecod,perempasecod,perubigeodom
            FROM cmper10 WHERE cmper10.{col_tabla} >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and cmper10.{col_tabla} < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')'
        ) 
        AS tmp_tbl (
            persecnum NUMERIC(10),
            pertipdocidencod NUMERIC(1,0),
            perdocidennum CHARACTER(15),
            persexocod CHARACTER(1),
            pernacfec DATE,
            perprinomdes CHARACTER(10),
            persegnomdes CHARACTER(10),
            perapepatdes CHARACTER(20),
            perapematdes CHARACTER(20),
            peroricenasiadscod CHARACTER(1),
            percenasiadscod CHARACTER (3),
            perestcivcod CHARACTER(1),
            pertipsegcod CHARACTER(2),
            perinsfec DATE,
            percrefec DATE,
            permodfec DATE,
            pertipoparecod CHARACTER(2),
            perempasecod character(1),
            perubigeodom character(6)
        )
    LEFT JOIN 
        dim_sexo ON tmp_tbl.persexocod = dim_sexo.cod_sex
        
    LEFT JOIN 
        dim_oricas ON tmp_tbl.peroricenasiadscod = dim_oricas.ori_cod
        
    LEFT JOIN 
        dim_cas ON tmp_tbl.percenasiadscod = dim_cas.cod_cas AND dim_cas.id_red IS NOT NULL

    LEFT JOIN 
        dim_estciv ON tmp_tbl.perestcivcod = dim_estciv.cod_eci

    LEFT JOIN 
        dim_tipseg ON tmp_tbl.pertipsegcod = dim_tipseg.cod_tse

    LEFT JOIN 
        dim_paren ON tmp_tbl.pertipoparecod = dim_paren.cod_tpa

    LEFT JOIN 
        dim_tipemp ON tmp_tbl.perempasecod = dim_tipemp.cod_tem

    LEFT JOIN 
        dim_ubigeo ON tmp_tbl.perubigeodom = dim_ubigeo.ubi_ine

    ;

    """

    c1= text(query)
    connection2.execute(c1)

    fecha_ini = fecha_fin_mes

    finproceso=time.time()
    tiempoproceso=finproceso - inicioTiempo
    tiempoproceso=round(tiempoproceso,3)
    print("Proceso DIM_PACSEC completado satisfactoriamente en " + str(tiempoproceso)+" segundos")

connection1.close()
connection2.close()
connection3.close()