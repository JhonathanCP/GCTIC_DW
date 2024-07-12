select red.des_red, te.des_emi, ec.des_eci, cantidad, fecha from citas_medicas cm 
left outer join dim_red red on cm.id_red = red.id_red 
left outer join dim_cas cas on cm.id_cas = cas.id_cas 
left outer join dim_tipemi te on cm.id_tipemi = te.id_tipemi
left outer join dim_estcit ec on cm.id_estcit = ec.id_estcit
where te.id_tipemi = 6

SELECT 
    EXTRACT(YEAR FROM cm.fecha) AS año,
    EXTRACT(MONTH FROM cm.fecha) AS mes,
    red.des_red,
    SUM(cantidad) AS total_cantidad
FROM 
    citas_medicas cm 
    LEFT OUTER JOIN dim_red red ON cm.id_red = red.id_red 
    LEFT OUTER JOIN dim_cas cas ON cm.id_cas = cas.id_cas 
    LEFT OUTER JOIN dim_tipemi te ON cm.id_tipemi = te.id_tipemi
    LEFT OUTER JOIN dim_estcit ec ON cm.id_estcit = ec.id_estcit
WHERE 
	cm.fecha >= '2024-01-01'
AND
	te.id_tipemi = 6
GROUP BY 
    año, mes, red.des_red
ORDER BY 
    año, mes, red.des_red;
   
SELECT 
    EXTRACT(YEAR FROM cm.fecha) AS año,
    EXTRACT(MONTH FROM cm.fecha) AS mes,
    red.des_red,
    SUM(cantidad) AS total_cantidad
FROM 
    citas_medicas cm 
    LEFT OUTER JOIN dim_red red ON cm.id_red = red.id_red 
    LEFT OUTER JOIN dim_cas cas ON cm.id_cas = cas.id_cas 
    LEFT OUTER JOIN dim_tipemi te ON cm.id_tipemi = te.id_tipemi
    LEFT OUTER JOIN dim_estcit ec ON cm.id_estcit = ec.id_estcit
WHERE 
	cm.fecha >= '2024-01-01'
AND
	te.id_tipemi = 6
AND
	ec.id_estcit in ()
GROUP BY 
    año, mes, red.des_red
ORDER BY 
    año, mes, red.des_red;
   
   
SELECT 
    years.año,
    months.mes,
    redes.des_red,
    COALESCE(SUM(citas_medicas.cantidad), 0) AS total_cantidad
FROM 
    (SELECT EXTRACT(YEAR FROM fecha) AS año FROM citas_medicas WHERE fecha >= '2024-01-01' GROUP BY año) AS years
    CROSS JOIN (SELECT EXTRACT(MONTH FROM fecha) AS mes FROM citas_medicas WHERE fecha >= '2024-01-01' GROUP BY mes) AS months
    CROSS JOIN (SELECT DISTINCT id_red, des_red FROM dim_red) AS redes
    LEFT JOIN citas_medicas ON EXTRACT(YEAR FROM citas_medicas.fecha) = years.año 
                             AND EXTRACT(MONTH FROM citas_medicas.fecha) = months.mes 
                             AND citas_medicas.id_red = redes.id_red
                             AND citas_medicas.id_tipemi = 6
    LEFT JOIN dim_red ON citas_medicas.id_red = dim_red.id_red
    LEFT JOIN dim_cas ON citas_medicas.id_cas = dim_cas.id_cas 
    LEFT JOIN dim_tipemi ON citas_medicas.id_tipemi = dim_tipemi.id_tipemi
    LEFT JOIN dim_estcit ON citas_medicas.id_estcit = dim_estcit.id_estcit
GROUP BY 
    years.año, months.mes, redes.des_red
ORDER BY 
    years.año, months.mes, redes.des_red;
   
   
   
SELECT 
    years.año,
    months.mes,
    redes.des_red,
    COALESCE(SUM(citas_medicas.cantidad), 0) AS total_cantidad
FROM 
    (SELECT EXTRACT(YEAR FROM fecha) AS año FROM citas_medicas WHERE fecha >= '2024-01-01' AND id_estcit IN (4) GROUP BY año) AS years
    CROSS JOIN (SELECT EXTRACT(MONTH FROM fecha) AS mes FROM citas_medicas WHERE fecha >= '2024-01-01' AND id_estcit IN (4) GROUP BY mes) AS months
    CROSS JOIN (SELECT DISTINCT id_red, des_red FROM dim_red) AS redes
    LEFT JOIN citas_medicas ON EXTRACT(YEAR FROM citas_medicas.fecha) = years.año 
                             AND EXTRACT(MONTH FROM citas_medicas.fecha) = months.mes 
                             AND citas_medicas.id_red = redes.id_red
                             AND citas_medicas.id_tipemi = 6
                             AND citas_medicas.id_estcit IN (4)
    LEFT JOIN dim_red ON citas_medicas.id_red = dim_red.id_red
    LEFT JOIN dim_cas ON citas_medicas.id_cas = dim_cas.id_cas 
    LEFT JOIN dim_tipemi ON citas_medicas.id_tipemi = dim_tipemi.id_tipemi
    LEFT JOIN dim_estcit ON citas_medicas.id_estcit = dim_estcit.id_estcit
GROUP BY 
    years.año, months.mes, redes.des_red
ORDER BY 
    years.año, months.mes, redes.des_red;
   
   
select red.des_red, usc.año, usc.mes, sum(usc.cantidad_personas)  from usuarios_solcita usc 
left outer join dim_cas dc on dc.cod_cas = usc.centro 
left outer join dim_red red on dc.cod_red = red.cod_red
where usc.año = 2024
and usc.mes = 3
group by
	red.des_red, usc.año, usc.mes
order by
	red.des_red, usc.año, usc.mes
	
	
select red.des_red, um.año, um.mes, um.cantidad_acumulada from usuarios_miconsulta um
left outer join dim_red red on um.cod_red = red.cod_red
where um.año = 2024
and um.mes = 2
group by
	red.des_red, um.año, um.mes, um.cantidad_acumulada
order by
	red.des_red, um.año, um.mes, um.cantidad_acumulada
