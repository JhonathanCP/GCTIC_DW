--------------------------
-- ORACLE
--------------------------
/*
cita:
  driverClassName: oracle.jdbc.OracleDriver
  jdbc-url: jdbc:oracle:thin:@10.56.1.127:1521/wnetqa
  password: sgss_c4l1d4d
  url: jdbc:oracle:thin:@10.56.1.127:1521/wnetqa
  username: sgss
*/
--------------------------

-- 1. solicitud.listResumenByRed
SELECT DISTINCT r.REDASISCOD as redAsisCod, r.REDASISDES as redAsisDes
FROM CMRAS10 r INNER JOIN CMCAS10 cas ON cas.redasiscod = r.redasiscod
WHERE r.REDASISESTREGCOD ='1'
ORDER BY r.REDASISCOD

-- 2. solicitud.resumenByRed
SELECT 
    r.REDASISCOD AS redAsisCod,
    r.REDASISDES AS redAsisDes,
    COUNT(
        CASE
            WHEN TRUNC(t.solcitafecpref) > TRUNC(SYSDATE) THEN 1
        END
    ) AS futuras,
    COUNT(
        CASE
            WHEN TRUNC(t.solcitafecpref) BETWEEN TRUNC(SYSDATE - INTERVAL '15' DAY) AND TRUNC(SYSDATE) THEN 1
        END
    ) AS rango15,
    COUNT(
        CASE
            WHEN TRUNC(t.solcitafecpref) BETWEEN TRUNC(SYSDATE - INTERVAL '30' DAY) AND TRUNC(SYSDATE - INTERVAL '16' DAY) THEN 1
        END
    ) AS rango30,
    COUNT(
        CASE
            WHEN TRUNC(t.solcitafecpref) < TRUNC(SYSDATE - INTERVAL '30' DAY) THEN 1
        END
    ) AS rango31
FROM 
    CMRAS10 r
    INNER JOIN CMCAS10 cas ON cas.REDASISCOD = r.REDASISCOD
    INNER JOIN CTSCI10 t ON t.SOLCITAORICENASICOD = cas.ORICENASICOD AND t.SOLCITACENASICOD = cas.CENASICOD
    INNER JOIN CMASE10 ser ON ser.ORICENASICOD = cas.ORICENASICOD AND ser.CENASICOD = cas.CENASICOD AND ser.AREHOSCOD = t.SOLCITAAREHOSCOD AND ser.SERVHOSCOD = t.SOLCITASERVHOSCOD
    INNER JOIN CMSAS10 act ON act.ORICENASICOD = ser.ORICENASICOD AND act.CENASICOD = ser.CENASICOD AND act.AREHOSCOD = ser.AREHOSCOD AND act.SERVHOSCOD = ser.SERVHOSCOD AND act.ACTCOD = t.SOLCITAACTCOD AND act.ACTESPCOD = t.SOLCITAACTESPCOD
    INNER JOIN CMSHO10 d ON t.SOLCITASERVHOSCOD = d.SERVHOSCOD
WHERE 
    cas.REDASISCOD = #{redAsisCod}
    AND t.ESTATENSOLCITACOD = '0'
    AND ser.AREHOSCOD = '01'
    AND t.SOLCITAESTREGCOD = '1'
    AND t.SOLCITANUM > 48250000
    AND TRUNC(t.SOLCITAFEC) BETWEEN TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -3))) AND TRUNC(SYSDATE)
GROUP BY 
    r.REDASISCOD, 
    r.REDASISDES
	
-- 3.- cupos.resumenByRed
SELECT 
    r.REDASISCOD AS redAsisCod,
    r.REDASISDES AS redAsisDes,
    COUNT(
        CASE
            WHEN TRUNC(T.ProPerFec) BETWEEN TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1)) AND TRUNC(LAST_DAY(SYSDATE)) THEN 
                NVL(c.ProConCanCupCitVol, 0) + NVL(c.ProConCanCupReci, 0) +
                NVL(c.ProConCanCupInte, 0) + NVL(c.ProConCanCupCitRef, 0) +
                NVL(c.ProConCanCupCitDia, 0) - NVL(c.ProConCanOtorCitVol, 0) -
                NVL(c.ProConCanOtorReci, 0) - NVL(c.ProConCanOtorInte, 0) -
                NVL(c.ProConCanOtorCitRef, 0)
        END
    ) AS cuposMes1,
    COUNT(
        CASE
            WHEN TRUNC(T.ProPerFec) BETWEEN TRUNC(LAST_DAY(SYSDATE) + 1) AND TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, 1))) THEN 
                NVL(c.ProConCanCupCitVol, 0) + NVL(c.ProConCanCupReci, 0) +
                NVL(c.ProConCanCupInte, 0) + NVL(c.ProConCanCupCitRef, 0) +
                NVL(c.ProConCanCupCitDia, 0) - NVL(c.ProConCanOtorCitVol, 0) -
                NVL(c.ProConCanOtorReci, 0) - NVL(c.ProConCanOtorInte, 0) -
                NVL(c.ProConCanOtorCitRef, 0)
        END
    ) AS cuposMes2,
    COUNT(
        CASE
            WHEN TRUNC(T.ProPerFec) BETWEEN TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, 1)) + 1) AND TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, 2))) THEN 
                NVL(c.ProConCanCupCitVol, 0) + NVL(c.ProConCanCupReci, 0) +
                NVL(c.ProConCanCupInte, 0) + NVL(c.ProConCanCupCitRef, 0) +
                NVL(c.ProConCanCupCitDia, 0) - NVL(c.ProConCanOtorCitVol, 0) -
                NVL(c.ProConCanOtorReci, 0) - NVL(c.ProConCanOtorInte, 0) -
                NVL(c.ProConCanOtorCitRef, 0)
        END
    ) AS cuposMes3,
    COUNT(
        CASE
            WHEN TRUNC(T.ProPerFec) BETWEEN TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, 2)) + 1) AND TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, 3))) THEN 
                NVL(c.ProConCanCupCitVol, 0) + NVL(c.ProConCanCupReci, 0) +
                NVL(c.ProConCanCupInte, 0) + NVL(c.ProConCanCupCitRef, 0) +
                NVL(c.ProConCanCupCitDia, 0) - NVL(c.ProConCanOtorCitVol, 0) -
                NVL(c.ProConCanOtorReci, 0) - NVL(c.ProConCanOtorInte, 0) -
                NVL(c.ProConCanOtorCitRef, 0)
        END
    ) AS cuposMes4
FROM 
    CMRAS10 r
    INNER JOIN CMCAS10 cas ON cas.REDASISCOD = r.REDASISCOD
    INNER JOIN CTPPE10 t ON t.ORICENASICOD = cas.ORICENASICOD AND t.CENASICOD = cas.CENASICOD
    INNER JOIN CMASE10 ser ON ser.ORICENASICOD = cas.ORICENASICOD AND ser.CENASICOD = cas.CENASICOD AND ser.AREHOSCOD = t.AREHOSCOD AND ser.SERVHOSCOD = t.SERVHOSCOD
    INNER JOIN CMSAS10 act ON act.ORICENASICOD = ser.ORICENASICOD AND act.CENASICOD = ser.CENASICOD AND act.AREHOSCOD = ser.AREHOSCOD AND act.SERVHOSCOD = ser.SERVHOSCOD AND act.ACTCOD = t.ACTCOD AND act.ACTESPCOD = t.ACTESPCOD
    INNER JOIN CTPCO10 c ON c.PROCONORICENASICOD = t.ORICENASICOD AND c.PROCONCENASICOD = t.CENASICOD AND c.PROCONAREHOSCOD = t.AREHOSCOD AND c.PROCONSERVHOSCOD = t.SERVHOSCOD AND c.PROCONACTCOD = t.ACTCOD AND c.PROCONACTESPCOD = t.ACTESPCOD AND c.PROCONTIPDOCIDENPERCOD = t.TIPDOCIDENPERCOD AND c.PROCONPERASISDOCIDENNUM = t.PERASISDOCIDENNUM AND c.PROCONFEC = t.PROPERFEC AND c.PROCONTURHORINI = t.PROPERTURHORINI AND c.PROCONTURHORFIN = t.PROPERTURHORFIN
    INNER JOIN CMSHO10 s ON s.SERVHOSCOD = t.SERVHOSCOD
WHERE 
    t.ORICENASICOD = cas.ORICENASICOD
    AND t.CENASICOD = cas.CENASICOD
    AND cas.REDASISCOD = #{redAsisCod}
    AND ser.AREHOSCOD = '01'
    AND t.TIPDOCIDENPERCOD = '1'
    AND TRUNC(t.PROPERFEC) BETWEEN TRUNC(SYSDATE) AND TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, 3)))
    AND t.PROPERESTREGCOD = '1'
GROUP BY 
    r.REDASISCOD, 
    r.REDASISDES
	
-- 4. solicitud.resumenByCentro
SELECT 
    cas.oricenasicod AS oriCenAsiCod,
    cas.cenAsiCod AS cenAsiCod,
    cas.cenasides AS descripcion,
    d.ServHosCod AS servHosCod,
    d.SERVHOSDES AS servHosDes,
    COUNT(
        CASE
            WHEN TRUNC(t.solcitafecpref) > TRUNC(SYSDATE) THEN 1
        END
    ) AS futuras,
    COUNT(
        CASE
            WHEN TRUNC(t.solcitafecpref) BETWEEN TRUNC(SYSDATE - INTERVAL '15' DAY) AND TRUNC(SYSDATE) THEN 1
        END
    ) AS rango15,
    COUNT(
        CASE
            WHEN TRUNC(t.solcitafecpref) BETWEEN TRUNC(SYSDATE - INTERVAL '30' DAY) AND TRUNC(SYSDATE - INTERVAL '16' DAY) THEN 1
        END
    ) AS rango30,
    COUNT(
        CASE
            WHEN TRUNC(t.solcitafecpref) < TRUNC(SYSDATE - INTERVAL '30' DAY) THEN 1
        END
    ) AS rango31
FROM 
    CMRAS10 r
    INNER JOIN CMCAS10 cas ON cas.redasiscod = r.redasiscod
    INNER JOIN CTSCI10 t ON t.solcitaoricenasicod = cas.oricenasicod AND t.solcitacenasicod = cas.cenasicod
    INNER JOIN CMASE10 ser ON ser.oricenasicod = cas.oricenasicod AND ser.cenasicod = cas.cenasicod AND ser.arehoscod = t.solcitaarehoscod AND ser.servhoscod = t.solcitaservhoscod
    INNER JOIN CMSAS10 act ON act.oricenasicod = ser.oricenasicod AND act.cenasicod = ser.cenasicod AND act.arehoscod = ser.arehoscod AND act.servhoscod = ser.servhoscod AND act.actcod = t.solcitaactcod AND act.actespcod = t.solcitaactespcod
    INNER JOIN CMSHO10 d ON t.solcitaservhoscod = d.servhoscod
WHERE 
    t.ESTATENSOLCITACOD = '0'
    AND cas.REDASISCOD = #{redAsisCod}
    AND ser.arehoscod = '01'
    AND t.solcitaestregcod = '1'
    AND t.solcitanum > 48250000
    AND TRUNC(t.solcitafec) BETWEEN TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -3))) AND TRUNC(SYSDATE)
GROUP BY 
    cas.oricenasicod, 
    cas.cenAsiCod, 
    cas.cenasides, 
    d.ServHosCod, 
    d.SERVHOSDES, 
    r.REDASISCOD, 
    r.REDASISDES
	
-- 5. cupos.resumenByCentro
SELECT 
    cas.oricenasicod AS oriCenAsiCod,
    cas.cenAsiCod AS cenAsiCod,
    T.ServHosCod AS servHosCod,
    s.SERVHOSDES AS servHosDes,
    COUNT(
        CASE
            WHEN TRUNC(T.ProPerFec) BETWEEN TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1)) AND TRUNC(LAST_DAY(SYSDATE))
                THEN NVL(c.ProConCanCupCitVol, 0) + NVL(c.ProConCanCupReci, 0) +
                     NVL(c.ProConCanCupInte, 0) + NVL(c.ProConCanCupCitRef, 0) +
                     NVL(c.ProConCanCupCitDia, 0) - NVL(c.ProConCanOtorCitVol, 0) -
                     NVL(c.ProConCanOtorReci, 0) - NVL(c.ProConCanOtorInte, 0) -
                     NVL(c.ProConCanOtorCitRef, 0)
        END
    ) AS cuposMes1,
    COUNT(
        CASE
            WHEN TRUNC(T.ProPerFec) BETWEEN TRUNC(LAST_DAY(SYSDATE) + 1) AND TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, 1)))
                THEN NVL(c.ProConCanCupCitVol, 0) + NVL(c.ProConCanCupReci, 0) +
                     NVL(c.ProConCanCupInte, 0) + NVL(c.ProConCanCupCitRef, 0) +
                     NVL(c.ProConCanCupCitDia, 0) - NVL(c.ProConCanOtorCitVol, 0) -
                     NVL(c.ProConCanOtorReci, 0) - NVL(c.ProConCanOtorInte, 0) -
                     NVL(c.ProConCanOtorCitRef, 0)
        END
    ) AS cuposMes2,
    COUNT(
        CASE
            WHEN TRUNC(T.ProPerFec) BETWEEN TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, 1)) + 1) AND TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, 2)))
                THEN NVL(c.ProConCanCupCitVol, 0) + NVL(c.ProConCanCupReci, 0) +
                     NVL(c.ProConCanCupInte, 0) + NVL(c.ProConCanCupCitRef, 0) +
                     NVL(c.ProConCanCupCitDia, 0) - NVL(c.ProConCanOtorCitVol, 0) -
                     NVL(c.ProConCanOtorReci, 0) - NVL(c.ProConCanOtorInte, 0) -
                     NVL(c.ProConCanOtorCitRef, 0)
        END
    ) AS cuposMes3,
    COUNT(
        CASE
            WHEN TRUNC(T.ProPerFec) BETWEEN TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, 2)) + 1) AND TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, 3)))
                THEN NVL(c.ProConCanCupCitVol, 0) + NVL(c.ProConCanCupReci, 0) +
                     NVL(c.ProConCanCupInte, 0) + NVL(c.ProConCanCupCitRef, 0) +
                     NVL(c.ProConCanCupCitDia, 0) - NVL(c.ProConCanOtorCitVol, 0) -
                     NVL(c.ProConCanOtorReci, 0) - NVL(c.ProConCanOtorInte, 0) -
                     NVL(c.ProConCanOtorCitRef, 0)
        END
    ) AS cuposMes4
FROM 
    CMRAS10 r
    INNER JOIN CMCAS10 cas ON cas.redasiscod = r.redasiscod
    INNER JOIN CTPPE10 t ON t.oricenasicod = cas.oricenasicod AND t.cenasicod = cas.cenasicod
    INNER JOIN CMASE10 ser ON ser.oricenasicod = cas.oricenasicod AND ser.cenasicod = cas.cenasicod AND ser.arehoscod = t.arehoscod AND ser.servhoscod = t.servhoscod
    INNER JOIN CMSAS10 act ON act.oricenasicod = ser.oricenasicod AND act.cenasicod = ser.cenasicod AND act.arehoscod = ser.arehoscod AND act.servhoscod = ser.servhoscod AND act.actcod = t.actcod AND act.actespcod = t.actespcod
    INNER JOIN ctpco10 c ON c.PROCONORICENASICOD = t.ORICENASICOD
        AND c.PROCONCENASICOD = t.CENASICOD
        AND c.PROCONAREHOSCOD = t.AREHOSCOD
        AND c.PROCONSERVHOSCOD = t.SERVHOSCOD
        AND c.PROCONACTCOD = t.ACTCOD
        AND c.PROCONACTESPCOD = t.ACTESPCOD
        AND c.PROCONTIPDOCIDENPERCOD = t.TIPDOCIDENPERCOD
        AND c.PROCONPERASISDOCIDENNUM = t.PERASISDOCIDENNUM
        AND c.PROCONFEC = t.PROPERFEC
        AND c.PROCONTURHORINI = t.PROPERTURHORINI
        AND c.PROCONTURHORFIN = t.PROPERTURHORFIN
    INNER JOIN CMSHO10 s ON s.SERVHOSCOD = T.ServHosCod
WHERE 
    t.OriCenAsiCod = cas.ORICENASICOD
    AND t.CenAsiCod = cas.CENASICOD
    AND cas.oricenasicod = #{oriCenAsiCod}
    AND cas.cenAsiCod = #{cenAsiCod}
    AND t.ServHosCod = #{servHosCod}
    AND ser.arehoscod = '01'
    AND t.TipDocIdenPerCod = '1'
    AND TRUNC(t.ProPerFec) BETWEEN TRUNC(SYSDATE) AND TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, 3)))
    AND t.ProPerEstRegCod = '1'
GROUP BY 
    cas.oricenasicod, 
    cas.cenAsiCod, 
    T.ServHosCod, 
    s.SERVHOSDES
	
--------------------------
-- POSTGRES
--------------------------
/*
resumen:
  driver-class-name: org.postgresql.Driver
  jdbc-url: jdbc:postgresql://192.168.0.51:5432/essi_backoffice_db
  password: Essalud2020
  username: usr_essalud
*/
--------------------------

-- 1. red.getRed
SELECT cod_red     as codRed,
	   descripcion as descripcion
FROM red
WHERE cod_red = #{redAsisCod}

 -- 2. resumen.getResumenByRed
 SELECT sol_futura   AS futuras,
	   sol_rango_15 AS rango15,
	   sol_rango_30 AS rango30,
	   sol_rango_31 AS rango31,
	   cupos_mes_1  AS cuposMes1,
	   cupos_mes_2  AS cuposMes2,
	   cupos_mes_3  AS cuposMes3,
	   cupos_mes_4  AS cuposMes4
FROM resumen_red
where cod_red = #{redAsisCod}

-- 3. resumen.updResumenRed
update resumen_red
set sol_futura  = #{futuras},
	sol_rango_15= #{rango15},
	sol_rango_30= #{rango30},
	sol_rango_31= #{rango31},
	cupos_mes_1 = #{cuposMes1},
	cupos_mes_2 = #{cuposMes2},
	cupos_mes_3 = #{cuposMes3},
	cupos_mes_4 = #{cuposMes4},
	date_modify = now()
where cod_red = #{redAsisCod}

-- 4. resumen.insResumenRed
INSERT INTO resumen_red(cod_red, cupos_mes_1, cupos_mes_2, cupos_mes_3, cupos_mes_4, sol_futura, sol_rango_15,
						sol_rango_30, sol_rango_31, date_modify)
VALUES (#{redAsisCod}, #{cuposMes1}, #{cuposMes2}, #{cuposMes3}, #{cuposMes4}, #{futuras}, #{rango15},
		#{rango30}, #{rango31}, now())
		
-- 5. centro.getCentro
SELECT ori_cen_asi AS oriCenAsi,
	   cen_asi_cod AS cenAsiCod,
	   descripcion AS descripcion,
	   cod_red     AS codRed
FROM centro
WHERE ori_cen_asi = #{oriCenAsiCod}
  AND cen_asi_cod = #{cenAsiCod}
  
-- 6. centro.insCentro
INSERT INTO centro(ori_cen_asi, cen_asi_cod, descripcion, cod_red, user_create, date_create)
VALUES (#{oriCenAsi}, #{cenAsiCod}, #{descripcion}, #{codRed}, #{user}, now())

-- 7. resumen.getResumenByCentro
SELECT serv_hos_des AS servHosDes,
	   sol_futura   AS futuras,
	   sol_rango_15 AS rango15,
	   sol_rango_30 AS rango30,
	   sol_rango_31 AS rango31,
	   cupos_mes_1  AS cuposMes1,
	   cupos_mes_2  AS cuposMes2,
	   cupos_mes_3  AS cuposMes3,
	   cupos_mes_4  AS cuposMes4
FROM resumen_centro
WHERE ori_cen_asi = #{oriCenAsiCod}
  AND cen_asi_cod = #{cenAsiCod}
  AND serv_hos_cod = #{servHosCod}
  
-- 8. resumen.updResumenCentro
UPDATE resumen_centro
SET serv_hos_des = #{servHosDes},
	sol_futura   = #{futuras},
	sol_rango_15= #{rango15},
	sol_rango_30= #{rango30},
	sol_rango_31= #{rango31},
	cupos_mes_1  = #{cuposMes1},
	cupos_mes_2  = #{cuposMes2},
	cupos_mes_3  = #{cuposMes3},
	cupos_mes_4  = #{cuposMes4},
	date_modify  = now()
WHERE ori_cen_asi = #{oriCenAsiCod}
  AND cen_asi_cod = #{cenAsiCod}
  AND serv_hos_cod = #{servHosCod}
  
-- 9. resumen.insResumenCentro
INSERT INTO resumen_centro(ori_cen_asi, cen_asi_cod, serv_hos_cod, serv_hos_des, cupos_mes_1, cupos_mes_2,
						   cupos_mes_3, cupos_mes_4, sol_futura, sol_rango_15, sol_rango_30, sol_rango_31,
						   date_modify)
VALUES (#{oriCenAsiCod}, #{cenAsiCod}, #{servHosCod}, #{servHosDes}, #{cuposMes1}, #{cuposMes2}, #{cuposMes3},
		#{cuposMes4}, #{futuras}, #{rango15}, #{rango30}, #{rango31}, now())