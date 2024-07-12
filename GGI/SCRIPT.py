from decouple import config
from sqlalchemy import create_engine
import pandas as pd
from datetime import datetime, timedelta
import time 
from datetime import datetime
from sqlalchemy import text
import oracledb
import sys

DB_USER=config("USER2_BDI_POSTGRES")
DB_PASSWORD=config("PASS2_BDI_POSTGRES")
DB_NAME="dw_essalud"
DB_PORT="5432"
DB_HOST=config("HOST2_BDI_POSTGRES")
cadena2  = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine2 = create_engine(cadena2)
connection2 = engine2.connect()

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


fecha_ini = pd.read_sql_query("SELECT fec_ini FROM etl_act where id_mod=26", con=connection2)
fecha_ini= fecha_ini.iloc[0, 0]

fecha_fin = pd.read_sql_query("SELECT fec_ter FROM etl_act where id_mod=26", con=connection2)
fecha_fin= fecha_fin.iloc[0, 0]


dias_por_intervalo = 6

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


  query1=f"UPDATE etl_act SET fec_act ='{now1}' WHERE id_mod=26"
  
  c1= text(query1)
  
  connection2.execute(c1)
  query = f"""
SELECT distinct
(SELECT ca.cenasides
FROM cmcas10 ca 
WHERE  ca.oricenasicod = a.atenamboricenasicod
AND ca.cenasicod =  a.atenambcenasicod)                                      as CENTRO,
t.citambservhoscod                                                           AS COD_SERVICIO,
(select x.servhosdes from cmsho10 x where t.citambservhoscod = x.servhoscod) as SERVICIO,
t.citambactcod                                                               AS COD_ACTIVIDAD,
(select d.actdes from cmact10 d where t.citambactcod = d.actcod)             as ACTIVIDAD,
t.citambactespcod                                                            AS COD_SUBACTIVIDAD,
(select e.actespnom from cmace10 e where t.citambactcod = e.actcod
 and t.citambactespcod = e.actespcod)                                        AS SUBACTIVIDAD,
s.perdocidennum                                                              AS DOC_PACIENTE,
(FLOOR(MONTHS_BETWEEN(a.atenambatenfec, s.pernacfec) / 12))                  AS ANNOS,
(FLOOR(MOD(MONTHS_BETWEEN(a.atenambatenfec, s.pernacfec), 12)))              AS MESES,
(TO_DATE(a.atenambatenfec, 'DD/MM/YYYY') - ADD_MONTHS(s.pernacfec,
FLOOR(MONTHS_BETWEEN(TO_DATE(a.atenambatenfec,'DD/MM/YYYY'),s.pernacfec))))  AS DIAS,
decode(s.persexocod, '1', 'M', '0', 'F', '')                                 AS SEXO,
k.actmedtipsegcod                                                            AS CODTIP_SEGURO,
(select m.tipsegdes from cmtse10 m where m.tipsegcod = k.actmedtipsegcod)        AS TIPO_SEGURO,
to_char(a.atenambatenfec,'dd/mm/yyyy')                                           AS FECHA_ATENCION,
(select h.tipcondes from cmtco10 h where a.atenambtipconcod = h.tipconcod)       AS TIPO_CONSULTA,
f.diagcod                                                                        AS DIAGNOSTICO,
(select j.diagdes from cmdia10 j where j.diagcod = f.diagcod)                    AS DES_DIAGNOSTICO,
decode(f.atenambtipodiagcod, '1', 'P', '2', 'D', '')                             AS TIPODIAG,
decode(f.atenambcasodiagcod,'1','N','2','R','')                                  AS CASODIAG,
    s.perubigeodomnom                                                            as UBIGEO,
(select g.resatenambunom from cbraa10 g where a.resatenambucod = g.resatenambucod) AS RESULT_ATENCION,
s.percenasiadscod                                                                   AS CAS_ADSCRIPCION
FROM ctaam10 a
LEFT OUTER JOIN cmame10 k ON k.oricenasicod = a.atenamboricenasicod
                         AND k.cenasicod    = a.atenambcenasicod
                         AND k.actmednum    = a.atenambnum
LEFT OUTER JOIN cmper10 s ON k.actmedpacsecnum    = s.persecnum
LEFT OUTER JOIN ctcam10 t ON t.citamboricenasicod = a.atenamboricenasicod
                         AND t.citambcenasicod    = a.atenambcenasicod
                         AND t.citambnum          = a.atenambnum
LEFT OUTER JOIN ctdaa10 f ON a.atenamboricenasicod     = f.atenamboricenasicod
                         AND a.atenambcenasicod        = f.atenambcenasicod
                         AND a.atenambnum              = f.atenambnum                  
WHERE
    a.atenambestregcod = '1'
AND a.atenambatenfec >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and a.atenambatenfec < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')
AND f.diagcod IN ('I15.0','I15.1','I15.2','I15.8','I15.9')        
  """
  base1 = pd.read_sql_query(query, con=connection0)

  #borrando = f"DELETE FROM farmacia WHERE solmatdocfec >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and solmatdocfec < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
  #borrado = connection3.execute(borrando)
  #print('borrado listo')

  base1.to_sql(name=f'atenciones_hipertension', con=connection2, if_exists='append', index=False,chunksize=10000)

  query = f"""
  SELECT distinct
(SELECT ca.cenasides
FROM cmcas10 ca 
WHERE  ca.oricenasicod = a.atenamboricenasicod
AND ca.cenasicod =  a.atenambcenasicod)                                      as CENTRO,
(FLOOR(MONTHS_BETWEEN(a.atenambatenfec, s.pernacfec) / 12))                  AS ANNOS,
(FLOOR(MOD(MONTHS_BETWEEN(a.atenambatenfec, s.pernacfec), 12)))              AS MESES,
(TO_DATE(a.atenambatenfec, 'DD/MM/YYYY') - ADD_MONTHS(s.pernacfec,
FLOOR(MONTHS_BETWEEN(TO_DATE(a.atenambatenfec,'DD/MM/YYYY'),s.pernacfec))))  AS DIAS,
decode(s.persexocod, '1', 'M', '0', 'F', '')                                 AS SEXO,
f.diagcod                                                                        AS DIAGNOSTICO,
(select j.diagdes from cmdia10 j where j.diagcod = f.diagcod)                    AS DES_DIAGNOSTICO
FROM ctaam10 a
LEFT OUTER JOIN cmame10 k ON k.oricenasicod = a.atenamboricenasicod
                         AND k.cenasicod    = a.atenambcenasicod
                         AND k.actmednum    = a.atenambnum
LEFT OUTER JOIN cmper10 s ON k.actmedpacsecnum    = s.persecnum
LEFT OUTER JOIN ctdaa10 f ON a.atenamboricenasicod     = f.atenamboricenasicod
                         AND a.atenambcenasicod        = f.atenambcenasicod
                         AND a.atenambnum              = f.atenambnum                  
WHERE
    a.atenambestregcod = '1'
AND a.atenambatenfec >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and a.atenambatenfec < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')
AND f.diagcod IN ('F00','F10','F20','F30','F40','F50','F60','F70','F80','F90',
'F99','F09','F19','F29','F39','F48','F59','F69','F79','F89','F98')
        
  """
  base1 = pd.read_sql_query(query, con=connection0)

  #borrando = f"DELETE FROM farmacia WHERE solmatdocfec >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and solmatdocfec < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
  #borrado = connection3.execute(borrando)
  #print('borrado listo')

  base1.to_sql(name=f'atenciones_salud_mental', con=connection2, if_exists='append', index=False,chunksize=10000)

  query = f"""
  SELECT
T.SOLOPECENASICOD                         AS CENTRO,
T.SOLOPESERVHOSCOD                        AS CODSERVPROCED,
(SELECT X.SERVHOSDES  FROM CMSHO10 X
 WHERE X.SERVHOSCOD = T.SOLOPESERVHOSCOD) AS SERV_PROCEDENCIA,
D.ACTMEDEDADATEN                          AS EDAD,
M.TIPSEGDES                               AS TIPO_SEGURO,
N.TIPOPACINOM                             AS TIPO_PACIENTE,
T.SOLOPENUM                               AS NUM_SOLICITUD,
TO_CHAR(T.SOLOPEFEC, 'dd/mm/yyyy')        AS FECHA_SOLICITUD,
TO_CHAR(T.SOLOPESOLFEC, 'dd/mm/yyyy')     AS FECHA_PROGRAMACION,
O.SOLOPEDIAGCOD                           AS COD_DIAG,
(SELECT Z.DIAGDES FROM CMDIA10 Z
 WHERE Z.DIAGCOD = O.SOLOPEDIAGCOD)       AS DIAGNOSTICO,
       F.CPSCOD AS CPT_OPERACION,
 REPLACE(REPLACE(TRIM(F.CPSDES),
 CHR(10), ''), CHR(13), '')               AS DESCRIPCION, -- se upd
G.GRDCMCCOD                               AS COD_COMPLEJIDAD,
G.GRDCMCDES                               AS COMPLEJIDAD,
T.MOTSOPCOD                                                AS CODMOTSUSPENSION,
(SELECT R.MOTSOPDES FROM SGSS.QBMSO10 R
 WHERE R.MOTSOPCOD = T.MOTSOPCOD)                          AS MOTIVO_SUSPENSION,
TO_CHAR(T.SOLOPEMODFEC, 'dd/mm/yyyy')                      AS FECMODIF,
T.SOLOPECENQUICOD                                          AS COD_QUIROF,
T.SOLOPESOLSERVHOSCOD                                      AS SERVQUI_SOLICITADA,
(SELECT X.SERVHOSDES FROM CMSHO10 X
 WHERE X.SERVHOSCOD = T.SOLOPESOLSERVHOSCOD)               AS DESSERVQUI_SOLIC,
(SELECT SQ.SALOPEDES FROM QMCQS10 SQ
        WHERE T.SOLOPESALOPECOD = SQ.SALOPECOD
        AND ROWNUM = 1)                                    AS DESC_SALA
FROM QTSOP10 T
LEFT OUTER JOIN QTSOD10 O ON T.SOLOPEORICENASICOD = O.SOLOPEORICENASICOD
                         AND T.SOLOPECENASICOD = O.SOLOPECENASICOD
                         AND T.SOLOPENUM = O.SOLOPENUM
LEFT OUTER JOIN QTSOO10 C ON T.SOLOPEORICENASICOD = C.SOLOPEORICENASICOD
                         AND T.SOLOPECENASICOD = C.SOLOPECENASICOD
                         AND T.SOLOPENUM = C.SOLOPENUM
LEFT OUTER JOIN CMAME10 D ON T.SOLOPEORICENASICOD = D.ORICENASICOD
                         AND T.SOLOPECENASICOD = D.CENASICOD
                         AND T.SOLOPEACTMEDNUM = D.ACTMEDNUM
LEFT OUTER JOIN CMPER10 E ON D.ACTMEDPACSECNUM = E.PERSECNUM
LEFT OUTER JOIN CBTPC10 N ON D.ACTMEDTIPOPACICOD = N.TIPOPACICOD
LEFT OUTER JOIN CMTSE10 M ON D.ACTMEDTIPSEGCOD = M.TIPSEGCOD
LEFT OUTER JOIN CMCPP10 F ON C.SOLOPECPSCOD = F.CPSCOD
LEFT OUTER JOIN QBGCC10 G ON F.GRDCMCCOD = G.GRDCMCCOD
WHERE T.Solopeprofec >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') AND T.Solopeprofec < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')
  AND T.ESTSOPCOD = '3'
        
  """
  base1 = pd.read_sql_query(query, con=connection0)

  #borrando = f"DELETE FROM farmacia WHERE solmatdocfec >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and solmatdocfec < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
  #borrado = connection3.execute(borrando)
  #print('borrado listo')

  base1.to_sql(name=f'intervenciones_qx_suspendidas', con=connection2, if_exists='append', index=False,chunksize=10000)

  query = f"""
  select
(SELECT ca.cenasides
FROM cmcas10 ca WHERE ca.oricenasicod = t.infopeoricenasicod
AND ca.cenasicod      = t.infopecenasicod)              AS CENTRO,
c.solopeactmedopenum                                     AS ACTMEDQX,
e.perautcod                                              AS AUTOGENERADO,
e.perdocidennum                                          AS DOC_PACIENTE,
c.solopesalopecod                                        AS COD_SALA,
(SELECT qs.salopedes
FROM qmcqs10 qs WHERE qs.oricenasicod = c.solopeoricenasicod
AND qs.cenasicod = c.solopecenasicod 
AND qs.cenquicod = c.solopecenquicod
AND qs.salopecod = c.solopesalopecod)                    AS DESCSALA,
e.perapepatdes||' '||e.perapematdes||' '||e.perprinomdes AS PACIENTE,
d.actmededadaten                                         AS EDAD,
m.tipsegcod                                              AS COD_TIPSEGURO,
m.tipsegdes                                              AS TIPO_SEGURO,
n.tipopacinom                                            AS TIPO_PACIENTE,
to_char(a.infopefec, 'dd/mm/yyyy')                       AS FEC_OPER,
to_char(an.infopedursali,'HH24:MI')                      AS HOR_INI_SALA,
to_char(an.infopedursalf,'HH24:MI')                      AS HOR_FIN_SALA,
nvl(to_char(an.infopedursal,'HH24:MI'),to_char(a.infopeopetpo,'HH24:MI'))     AS DURACION_SALA,
to_char(an.infopeduranei,'HH24:MI')                                           AS HOR_INI_ANEST,
to_char(an.infopeduranef,'HH24:MI')                                           AS HOR_FIN_ANEST,
nvl(to_char(an.infopedurane,'HH24:MI'),to_char(a.infopeanetpo,'HH24:MI'))     AS DURACION_ANEST,
nvl(to_char(an.infopehiniope,'HH24:MI'),to_char(a.infopeingsophor,'HH24:MI')) AS HOR_INI_OPERAC,
nvl(to_char(an.infopehfinope,'HH24:MI'),to_char(a.infopesoptpo,'HH24:MI'))    AS HOR_FIN_OPERAC,
nvl(to_char(an.infopehdurope,'HH24:MI'), to_char(an.infopehdurope,'HH24:MI')) AS DURACION_OPERAC,
t.infopecpscod                                                                AS COD_OPERACION,
replace(replace(trim(f.cpsdes), CHR(10), ''), CHR(13), '')                    AS DESC_OPERACION,
g.grdcmccod                                                                   AS COD_COMPLEJIDAD,
DECODE(g.grdcmcdes,'','SIN CLASIFICACION',g.grdcmcdes)                        AS DESC_COMPLEJIDAD,
anes.infopeaneanecod                                                             AS COD_ANEST,
(SELECT an2.anedes FROM qmane10 an2 WHERE an2.anecod = anes.infopeaneanecod)     AS ANESTESIA,
(SELECT tp.conopedes FROM QBCEP10 tp WHERE tp.conopecod = c.conopecod)           AS TIPO_PROGRAMACION,
(SELECT ho.arehosdescor FROM cmaho10 ho  WHERE ho.arehoscod = c.solopearehoscod) AS AREA_SOLICITA,
c.solopenum                                                                      AS NUM_SOLICITUD,
c.solopecenquicod                                                                AS COD_QUIROF,
c.solopesolservhoscod                                                            AS SERVQUI_SOLICITADA,
(select x.servhosdes from cmsho10 x where x.servhoscod = c.solopesolservhoscod)  AS DES_SERVQUI_SOLIC,
to_char(c.solopefec, 'dd/mm/yyyy')                                               AS FECSOLICSALAOPERAC,
to_CHAR(c.solopesolfec,'dd/mm/yyyy')                                             AS FECSOLICITADAOPERAC,--07082019
to_CHAR(c.solopeprofec,'dd/mm/yyyy')                                             AS FECPROGRAM,  --07082019
e.percenasiadscod                                                                AS CAS_ADSCRIPCION
FROM sgss.qtioo10 t
left outer join qtiop10 a on a.infopeoricenasicod = t.infopeoricenasicod
                         and a.infopecenasicod    = t.infopecenasicod
                         and a.infopesolopenum    = t.infopesolopenum
                         and a.infopesecnum       = t.infopesecnum
left outer join qtioc10 k on k.infopeoricenasicod = a.infopeoricenasicod
                         and k.infopecenasicod    = a.infopecenasicod
                         and k.infopesolopenum    = a.infopesolopenum
                         and k.infopesecnum       = a.infopesecnum
left outer JOIN qtioa10 ioa ON ioa.infopeoricenasicod = a.infopeoricenasicod
                           AND ioa.infopecenasicod = a.infopecenasicod
                           AND ioa.infopesolopenum = a.infopesolopenum
                           AND ioa.infopesecnum    = a.infopesecnum
left outer join qtsop10 c on c.solopeoricenasicod  = a.infopeoricenasicod
                         and c.solopecenasicod     = a.infopecenasicod
                         and c.solopenum           = a.infopesolopenum
left outer JOIN sgss.qtian10 an ON an.infopeoricenasicod = c.solopeoricenasicod
                               AND an.infopecenasicod = c.solopecenasicod
                               AND an.infopesolopenum = c.solopenum
                               AND an.infopeanedesope <> '00'
LEFT OUTER JOIN sgss.qtiaa10 anes ON anes.infopeoricenasicod = an.infopeoricenasicod
                                 AND anes.infopecenasicod    = an.infopecenasicod
                                 AND anes.infopesolopenum    = an.infopesolopenum
left outer join cmame10 d on d.oricenasicod = c.solopeoricenasicod
                         and d.cenasicod    = c.solopecenasicod
                         and d.actmednum    = c.solopeactmednum
left outer join cmper10 e on e.persecnum    = d.actmedpacsecnum
left outer join cbtpc10 n on n.tipopacicod  = d.actmedtipopacicod
left outer join cmtse10 m on m.tipsegcod    = d.actmedtipsegcod
left outer join cmcpp10 f on f.cpscod       = t.infopecpscod
left outer join qbgcc10 g on g.grdcmccod    = f.grdcmccod
WHERE
a.infopefec >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and a.infopefec < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')
ORDER BY e.perapepatdes||' '||e.perapematdes||' '||e.perprinomdes,t.infopecpscod,anes.infopeaneanecod        
  """
  base1 = pd.read_sql_query(query, con=connection0)

  #borrando = f"DELETE FROM farmacia WHERE solmatdocfec >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and solmatdocfec < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
  #borrado = connection3.execute(borrando)
  #print('borrado listo')

  base1.to_sql(name=f'intervenciones_qx', con=connection2, if_exists='append', index=False,chunksize=10000)

  query = f"""
  select 
t.solopeoricenasicod||'-'||t.solopecenasicod||' '||a.cenasidescor as "CENT.ASIS",
to_char(t.solopeprofec,'dd/mm/yyyy')            AS FECPROGRAMADA,
decode(b.persexocod, '1','M','0','F','')          as "SEXO",
(floor(months_between(sysdate,b.pernacfec)/12))   as "EDAD",
to_char(t.solopefec,'dd/mm/yyyy')                 as "FEC.SOL",
to_char(t.SolOpeProtFec,'dd/mm/yyyy')             as "FEC.DISPOS",                                     
replace(REPLACE
(trim(to_char
(substr(t.SolOpeReqProtDes,0,4000))),
CHR(10), ''), CHR(13), '')                        as "DESCRIPCION" 
from QTSOP10 t
left outer join CMCAS10 a on t.solopeoricenasicod = a.oricenasicod
                         and t.solopecenasicod    = a.cenasicod
left outer join CMPER10 b on t.solopebuspacsecnum = b.persecnum
where t.solopefec >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and t.solopefec < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')
 and t.SolOpeReqProtFlg = '1'
 and t.SolOpeTieProtFlg = '0'
 and t.EstSOpCod in ('0','4','1')
 and t.SolOpeEstRegCod  = '1'

order by t.solopeoricenasicod,t.solopecenasicod,t.solopenum
  """
  base1 = pd.read_sql_query(query, con=connection0)

  #borrando = f"DELETE FROM farmacia WHERE solmatdocfec >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') and solmatdocfec < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')"
  #borrado = connection3.execute(borrando)
  #print('borrado listo')

  base1.to_sql(name=f'protesis', con=connection2, if_exists='append', index=False,chunksize=10000)


  fecha_actual = fecha_fin_intervalo

  finproceso=time.time()
  tiempoproceso=finproceso - inicioTiempo
  tiempoproceso=round(tiempoproceso,3)
  print("Proceso completado satisfactoriamente en " + str(tiempoproceso)+" segundos")
connection0.close()
#query2=f"UPDATE etl_act SET fec_ini ='{now2}' WHERE id_mod=26"
#c2= text(query2)
#connection2.execute(c2)
#connection0.close()