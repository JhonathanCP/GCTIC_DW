--atemed -- para Ana SubGerenta de Análisis ... 

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
and to_char(trunc(a.atenambatenfec), 'yyyymmdd') >= &p_fechainicio
and to_char(trunc(a.atenambatenfec), 'yyyymmdd') <= &p_fechafin
AND f.diagcod IN ('F00','F10','F20','F30','F40','F50','F60','F70','F80','F90',
'F99','F09','F19','F29','F39','F48','F59','F69','F79','F89','F98')

