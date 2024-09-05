tabla='ctdef10'
col_tabla='defhorfec'
dat='dat_fac_essi'
col_dat='def_fec'

from decouple import config
from sqlalchemy import create_engine
import pandas as pd
from datetime import datetime, timedelta
import time 
from datetime import datetime
from sqlalchemy import text
import oracledb
import sys
import numpy as np
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


fec_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=23", con=connection2)
fec_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=23", con=connection2)
fec_ini= fec_ini.iloc[0, 0]
fec_fin= fec_fin.iloc[0, 0]
print(fec_ini)
print(fec_fin)
now1 = datetime.now()

query1=f"UPDATE etl_act SET fec_act ='{now1}' WHERE id_mod=23"
c1= text(query1)
connection2.execute(c1)



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


query = f"""SELECT 
    b.redasiscod,
    a.cenasicod,
    t.deforicenasicod,
    c.pertipdocidencod,
    c.perdocidennum,
    c.persexocod,
    c.perapepatdes,
    c.perapematdes,
    c.perprinomdes,
    c.persegnomdes,
    t.defanoedad,
    t.defactmednum ,
    t.defhorfec,
    d.arehoscod,
    t.deftipdocidenpercod,
    t.defperasisdocidennum,
    t.defcrefec,
    t.defmodfec,
(
    SELECT u.defdxdiagcod
    FROM SGSS.CTDEX10 u
    WHERE u.defpacsecnum = t.defpacsecnum
      AND u.defregsecnum = t.defregsecnum
      AND u.defdxdiagpriflg = '1'
      AND ROWNUM = 1
) AS defdiagpri,
(
    SELECT REGEXP_SUBSTR(
        RTRIM(XMLAGG(XMLELEMENT(E, u.defdxdiagcod || '; ') ORDER BY u.defdxdiagcod).EXTRACT('//text()'), '; '),
        '[^;]+',
        1,
        1
    )
    FROM SGSS.CTDEX10 u
    WHERE u.defpacsecnum = t.defpacsecnum
      AND u.defregsecnum = t.defregsecnum
      AND u.defdxdiagpriflg = '0'
) AS defdiagsec1,
(
    SELECT REGEXP_SUBSTR(
        RTRIM(XMLAGG(XMLELEMENT(E, u.defdxdiagcod || '; ') ORDER BY u.defdxdiagcod).EXTRACT('//text()'), '; '),
        '[^;]+',
        1,
        2
    )
    FROM SGSS.CTDEX10 u
    WHERE u.defpacsecnum = t.defpacsecnum
      AND u.defregsecnum = t.defregsecnum
      AND u.defdxdiagpriflg = '0'
) AS defdiagsec2,
(
    SELECT REGEXP_SUBSTR(
        RTRIM(XMLAGG(XMLELEMENT(E, u.defdxdiagcod || '; ') ORDER BY u.defdxdiagcod).EXTRACT('//text()'), '; '),
        '[^;]+',
        1,
        3
    )
    FROM SGSS.CTDEX10 u
    WHERE u.defpacsecnum = t.defpacsecnum
      AND u.defregsecnum = t.defregsecnum
      AND u.defdxdiagpriflg = '0'
) AS defdiagsec3,
(
    SELECT REGEXP_SUBSTR(
        RTRIM(XMLAGG(XMLELEMENT(E, u.defdxdiagcod || '; ') ORDER BY u.defdxdiagcod).EXTRACT('//text()'), '; '),
        '[^;]+',
        1,
        4
    )
    FROM SGSS.CTDEX10 u
    WHERE u.defpacsecnum = t.defpacsecnum
      AND u.defregsecnum = t.defregsecnum
      AND u.defdxdiagpriflg = '0'
) AS defdiagsec4,
(
    SELECT REGEXP_SUBSTR(
        RTRIM(XMLAGG(XMLELEMENT(E, u.defdxdiagcod || '; ') ORDER BY u.defdxdiagcod).EXTRACT('//text()'), '; '),
        '[^;]+',
        1,
        5
    )
    FROM SGSS.CTDEX10 u
    WHERE u.defpacsecnum = t.defpacsecnum
      AND u.defregsecnum = t.defregsecnum
      AND u.defdxdiagpriflg = '0'
) AS defdiagsec5,
(
    SELECT REGEXP_SUBSTR(
        RTRIM(XMLAGG(XMLELEMENT(E, u.defdxdiagcod || '; ') ORDER BY u.defdxdiagcod).EXTRACT('//text()'), '; '),
        '[^;]+',
        1,
        6
    )
    FROM SGSS.CTDEX10 u
    WHERE u.defpacsecnum = t.defpacsecnum
      AND u.defregsecnum = t.defregsecnum
      AND u.defdxdiagpriflg = '0'
) AS defdiagsec6,
(
    SELECT REGEXP_SUBSTR(
        RTRIM(XMLAGG(XMLELEMENT(E, u.defdxdiagcod || '; ') ORDER BY u.defdxdiagcod).EXTRACT('//text()'), '; '),
        '[^;]+',
        1,
        7
    )
    FROM SGSS.CTDEX10 u
    WHERE u.defpacsecnum = t.defpacsecnum
      AND u.defregsecnum = t.defregsecnum
      AND u.defdxdiagpriflg = '0'
) AS defdiagsec7,
(
    SELECT REGEXP_SUBSTR(
        RTRIM(XMLAGG(XMLELEMENT(E, u.defdxdiagcod || '; ') ORDER BY u.defdxdiagcod).EXTRACT('//text()'), '; '),
        '[^;]+',
        1,
        8
    )
    FROM SGSS.CTDEX10 u
    WHERE u.defpacsecnum = t.defpacsecnum
      AND u.defregsecnum = t.defregsecnum
      AND u.defdxdiagpriflg = '0'
) AS defdiagsec8,
(
    SELECT REGEXP_SUBSTR(
        RTRIM(XMLAGG(XMLELEMENT(E, u.defdxdiagcod || '; ') ORDER BY u.defdxdiagcod).EXTRACT('//text()'), '; '),
        '[^;]+',
        1,
        9
    )
    FROM SGSS.CTDEX10 u
    WHERE u.defpacsecnum = t.defpacsecnum
      AND u.defregsecnum = t.defregsecnum
      AND u.defdxdiagpriflg = '0'
) AS defdiagsec9,
(
    SELECT REGEXP_SUBSTR(
        RTRIM(XMLAGG(XMLELEMENT(E, u.defdxdiagcod || '; ') ORDER BY u.defdxdiagcod).EXTRACT('//text()'), '; '),
        '[^;]+',
        1,
        10
    )
    FROM SGSS.CTDEX10 u
    WHERE u.defpacsecnum = t.defpacsecnum
      AND u.defregsecnum = t.defregsecnum
      AND u.defdxdiagpriflg = '0'
) AS defdiagsec10,
    t.defcertnum,
    t.defconfregflg,
    t.defconfregfec
FROM 
    SGSS.CTDEF10 t
LEFT OUTER JOIN 
    cmcas10 a ON t.deforicenasicod = a.oricenasicod AND t.defcenasicod = a.cenasicod
LEFT OUTER JOIN 
    cmras10 b ON a.redasiscod = b.redasiscod
LEFT OUTER JOIN 
    cmper10 c ON t.defpacsecnum = c.persecnum
LEFT OUTER JOIN 
    cmaho10 d ON t.defarehoscod = d.arehoscod
LEFT OUTER JOIN 
    cmprs10 e ON t.deftipdocidenpercod = e.tipdocidenpercod AND t.defperasisdocidennum = e.perasisdocidennum
WHERE 
    t.{col_tabla} >= TO_DATE('{fec_ini}', 'yyyy-mm-dd') AND  t.{col_tabla} < TO_DATE('{fec_fin}', 'yyyy-mm-dd')
    AND t.defestregcod = '1'"""


base = pd.read_sql_query(query, con=connection0)
connection0.close()


#CREAMOS LA TABLA TEMPORAL
base.to_sql(name=f'tmp_{tabla}', con=engine3, if_exists='replace', index=False)


#SUBIMOS LA TABLA TEMPORAL AL POSTGRES SQL

query_count_before = f"SELECT COUNT(*) FROM {tabla}"
cant_antes = connection3.execute(query_count_before).fetchone()[0]
print(f"Cantidad de filas en la tabla {tabla} antes de la inserción: {cant_antes}")


#Borramos en caso el ETL se ejecute una segunda vez
borrando=f"DELETE FROM {tabla} WHERE {col_tabla} >='{fec_ini}'"
borrado = connection3.execute(borrando)


query=f"""

ALTER TABLE tmp_{tabla} 
ALTER COLUMN redasiscod TYPE character(5),
ALTER COLUMN cenasicod TYPE character(5),
ALTER COLUMN deforicenasicod TYPE character(2),
ALTER COLUMN pertipdocidencod TYPE character(2),
ALTER COLUMN perdocidennum TYPE character(15),
ALTER COLUMN persexocod TYPE character(2),
ALTER COLUMN perapepatdes TYPE character(50),
ALTER COLUMN perapematdes TYPE character(50),
ALTER COLUMN perprinomdes TYPE character(50),
ALTER COLUMN persegnomdes TYPE character(50),
ALTER COLUMN defanoedad TYPE numeric(4,0) USING defanoedad::numeric(4,0),
ALTER COLUMN defactmednum TYPE character(20),
ALTER COLUMN defhorfec TYPE date USING defhorfec::date,
ALTER COLUMN arehoscod TYPE character(5),
ALTER COLUMN deftipdocidenpercod TYPE character(2),
ALTER COLUMN defperasisdocidennum TYPE character(15),
ALTER COLUMN defdiagpri TYPE character(10),
ALTER COLUMN defdiagsec1 TYPE character(10),
ALTER COLUMN defdiagsec2 TYPE character(10),
ALTER COLUMN defdiagsec3 TYPE character(10),
ALTER COLUMN defdiagsec4 TYPE character(10),
ALTER COLUMN defdiagsec5 TYPE character(10),
ALTER COLUMN defdiagsec6 TYPE character(10),
ALTER COLUMN defdiagsec7 TYPE character(10),
ALTER COLUMN defdiagsec8 TYPE character(10),
ALTER COLUMN defdiagsec9 TYPE character(10),
ALTER COLUMN defdiagsec10 TYPE character(10),
ALTER COLUMN defcertnum TYPE numeric(20,0) USING defcertnum::numeric(20,0),
ALTER COLUMN defconfregflg TYPE character(2),
ALTER COLUMN defconfregfec TYPE date USING defconfregfec::date;

INSERT INTO {tabla} 
(redasiscod,cenasicod,deforicenasicod,pertipdocidencod,perdocidennum,persexocod,perapepatdes,perapematdes,perprinomdes,persegnomdes,defanoedad,defactmednum,defhorfec,arehoscod,deftipdocidenpercod,defperasisdocidennum,defdiagpri,defdiagsec1,defdiagsec2,defdiagsec3,defdiagsec4,defdiagsec5,defdiagsec6,defdiagsec7,defdiagsec8,defdiagsec9,defdiagsec10,defcertnum,defconfregflg,defconfregfec) 

SELECT 
redasiscod,cenasicod,deforicenasicod,pertipdocidencod,perdocidennum,persexocod,perapepatdes,perapematdes,perprinomdes,persegnomdes,defanoedad,defactmednum,defhorfec,arehoscod,deftipdocidenpercod,defperasisdocidennum,defdiagpri,defdiagsec1,defdiagsec2,defdiagsec3,defdiagsec4,defdiagsec5,defdiagsec6,defdiagsec7,defdiagsec8,defdiagsec9,defdiagsec10,defcertnum,defconfregflg,defconfregfec



FROM tmp_{tabla};
"""

c1= text(query)
connection3.execute(c1)


query_count_after = f"SELECT COUNT(*) FROM {tabla}"
cant_despues = connection3.execute(query_count_after).fetchone()[0]
print(f"Cantidad de filas en la tabla {tabla} después de la inserción: {cant_despues}")
print(f"La cantidad de filas insertadas fue de: {cant_despues-cant_antes}")


#BORRAMOS LAS TABLAS
query2=f"""
DROP TABLE tmp_{tabla};
"""
c2= text(query2)
cursor=connection3.execute(c2)


cas = pd.read_sql_query(f"SELECT id_cas,cod_cas FROM dim_cas where id_cas is not null", con=connection2)
cas = cas.drop_duplicates(subset=['cod_cas'])
cas=cas.dropna()
red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)
oricas = pd.read_sql_query(f"SELECT id_oricas,ori_cod FROM dim_oricas", con=connection2)
tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
tipdoc["cod_tdo"]=tipdoc["cod_tdo"].str.strip()
areas = pd.read_sql_query(f"SELECT id_area,cod_are FROM dim_areas", con=connection2)
areas['cod_are']=areas['cod_are'].str.strip()
cie = pd.read_sql_query(f"SELECT id_cie,cod_cie FROM dim_cie10", con=connection2)
cie['cod_cie']=cie['cod_cie'].str.strip()


base1 = base.rename(columns={
    'redasiscod': 'cod_red',
    'cenasicod': 'cod_cas',
    'deforicenasicod': 'ori_cod',
    'pertipdocidencod': 'pac_cod_tdo',
    'perdocidennum': 'pac_dni',
    'persexocod': 'pac_sexo',
    'perapepatdes': 'pac_apat',
    'perapematdes': 'pac_amat',
    'perprinomdes': 'pac_npri',
    'persegnomdes': 'pac_nseg',
    'defanoedad': 'pac_edad',
    'defactmednum': 'act_med',
    'defhorfec': 'def_fec',
    'arehoscod': 'cod_are',
    'deftipdocidenpercod': 'med_cod_tdo',
    'defperasisdocidennum': 'med_dni',
    'defdiagpri': 'cod_cie_p',
    'defdiagsec1': 'cod_cie_s1',
    'defdiagsec2': 'cod_cie_s2',
    'defdiagsec3': 'cod_cie_s3',
    'defdiagsec4': 'cod_cie_s4',
    'defdiagsec5': 'cod_cie_s5',
    'defdiagsec6': 'cod_cie_s6',
    'defdiagsec7': 'cod_cie_s7',
    'defdiagsec8': 'cod_cie_s8',
    'defdiagsec9': 'cod_cie_s9',
    'defdiagsec10': 'cod_cie_s10',
    'defcertnum': 'cert_num',
    'defconfregflg': 'reg_flg',
    'defconfregfec': 'reg_fec',
    'defcrefec': 'fec_cre',
    'defmodfec': 'fec_mod'
})


base1.info()


cas = pd.read_sql_query(f"SELECT id_cas,cod_cas FROM dim_cas where id_cas is not null", con=connection2)
cas = cas.drop_duplicates(subset=['cod_cas'])
cas=cas.dropna()
red = pd.read_sql_query(f"SELECT id_red,cod_red FROM dim_red", con=connection2)
oricas = pd.read_sql_query(f"SELECT id_oricas,ori_cod FROM dim_oricas", con=connection2)
tipdoc = pd.read_sql_query(f"SELECT id_tipdoc,cod_tdo FROM dim_tipdoc", con=connection2)
tipdoc["cod_tdo"]=tipdoc["cod_tdo"].str.strip()
areas = pd.read_sql_query(f"SELECT id_area,cod_are FROM dim_areas", con=connection2)
areas['cod_are']=areas['cod_are'].str.strip()
cie = pd.read_sql_query(f"SELECT id_cie,cod_cie FROM dim_cie10", con=connection2)
cie['cod_cie']=cie['cod_cie'].str.strip()


base1=pd.merge(base1,red,how='left',on='cod_red')
base1=base1.drop('cod_red',axis=1)


base1=pd.merge(base1,cas,how='left',on='cod_cas')
base1=base1.drop('cod_cas',axis=1)


base1=pd.merge(base1,oricas,how='left',on='ori_cod')
base1=base1.drop('ori_cod',axis=1)


base1 = pd.merge(base1, tipdoc, how='left', left_on='pac_cod_tdo', right_on='cod_tdo')
base1.rename(columns={'id_tipdoc': 'id_pac_tipdoc'}, inplace=True)
base1=base1.drop('cod_tdo',axis=1)
base1=base1.drop('pac_cod_tdo',axis=1)


base1 = pd.merge(base1, tipdoc, how='left', left_on='med_cod_tdo', right_on='cod_tdo')
base1.rename(columns={'id_tipdoc': 'id_med_tipdoc'}, inplace=True)
base1=base1.drop('cod_tdo',axis=1)
base1=base1.drop('med_cod_tdo',axis=1)


base1 = pd.merge(base1, areas, how='left', on='cod_are')
base1=base1.drop('cod_are',axis=1)


base1 = pd.merge(base1, cie, how='left', left_on='cod_cie_p', right_on='cod_cie')
base1.rename(columns={'id_cie': 'id_cie_p'}, inplace=True)
base1=base1.drop('cod_cie',axis=1)
base1=base1.drop('cod_cie_p',axis=1)


base1['cod_cie_s1']=base1['cod_cie_s1'].str.strip()
columnas_s = ['s1', 's2', 's3', 's4', 's5', 's6', 's7', 's8', 's9', 's10']

# Itera sobre las columnas y realiza la fusión y el renombrado
for col_s in columnas_s:
    # Realiza la fusión
    base1[f'cod_cie_{col_s}']=base1[f'cod_cie_{col_s}'].str.strip()
    base1 = pd.merge(base1, cie, how='left', left_on=f'cod_cie_{col_s}', right_on='cod_cie')
    
    # Renombra la columna resultante
    nuevo_nombre_col = f'id_cie_{col_s}'
    base1.rename(columns={'id_cie': nuevo_nombre_col}, inplace=True)
    
    # Elimina la columna 'cod_cie'
    base1 = base1.drop('cod_cie', axis=1)
    base1 = base1.drop(f'cod_cie_{col_s}', axis=1)

base1['validado'] = '1'

def verificar_dengue(row):
    codigos_dengue = {452, 453, 454, 455}
    columnas_cie = ['id_cie_p', 'id_cie_s1', 'id_cie_s2', 'id_cie_s3', 'id_cie_s4', 'id_cie_s5', 'id_cie_s6', 'id_cie_s7', 'id_cie_s8', 'id_cie_s9', 'id_cie_s10']

    for col in columnas_cie:
        valor_actual = row[col]
        if pd.notna(valor_actual) and int(valor_actual) in codigos_dengue:
            return '1'
    return '0'

# Aplica la función a la columna 'dengue' utilizando apply
base1['dengue'] = base1.apply(verificar_dengue, axis=1)

# Convierte la columna 'dengue' a tipo numérico
base1['dengue'] = pd.to_numeric(base1['dengue'])

borrando=f"DELETE FROM {dat} WHERE {col_dat} >='{fec_ini}'"
borrado = connection2.execute(borrando)

base1.to_sql(name=f'{dat}', con=connection2, if_exists='append', index=False,chunksize=10000)

now2 = datetime.now().strftime('%Y-%m-%d')
query2=f"UPDATE etl_act SET fec_ini ='{now2}' WHERE id_mod=23"
c2= text(query2)
connection2.execute(c2)

connection1.close()
connection2.close()
connection3.close()
engine1.dispose()
engine2.dispose()
engine3.dispose()