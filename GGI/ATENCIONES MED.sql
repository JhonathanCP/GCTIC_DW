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
and to_char(trunc(a.atenambatenfec), 'yyyymmdd') >= &p_fechainicio
and to_char(trunc(a.atenambatenfec), 'yyyymmdd') <= &p_fechafin
AND f.diagcod IN ('I15.0','I15.1','I15.2','I15.8','I15.9')