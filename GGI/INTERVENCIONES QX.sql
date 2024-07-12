-- Interve Qx - para Ana SubGerenta de Análisis ... 
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
a.infopefec >= to_date(&p_fechainicio,'yyyymmdd')
  and a.infopefec < to_date(&p_fechafin,'yyyymmdd')+1

ORDER BY e.perapepatdes||' '||e.perapematdes||' '||e.perprinomdes,t.infopecpscod,anes.infopeaneanecod;