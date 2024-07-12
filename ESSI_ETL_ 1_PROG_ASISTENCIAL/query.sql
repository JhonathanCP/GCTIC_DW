SELECT *
FROM public.dat_progasis_essi_vf
WHERE
	(ano_pro =  EXTRACT(YEAR FROM CURRENT_DATE - interval '1 month') AND mes_pro =  EXTRACT(MONTH FROM CURRENT_DATE - interval '1 month'))
	OR
	(ano_pro =  EXTRACT(YEAR FROM CURRENT_DATE) AND mes_pro =  EXTRACT(MONTH FROM CURRENT_DATE))
	OR
	(ano_pro =  EXTRACT(YEAR FROM CURRENT_DATE + interval '1 month') AND mes_pro =  EXTRACT(MONTH FROM CURRENT_DATE + interval '1 month'))
	OR
	(ano_pro =  EXTRACT(YEAR FROM CURRENT_DATE + interval '2 month') AND mes_pro =  EXTRACT(MONTH FROM CURRENT_DATE + interval '2 month'))
	OR
	(ano_pro =  EXTRACT(YEAR FROM CURRENT_DATE + interval '3 month') AND mes_pro =  EXTRACT(MONTH FROM CURRENT_DATE + interval '3 month'))
	OR
	(ano_pro =  EXTRACT(YEAR FROM CURRENT_DATE + interval '4 month') AND mes_pro =  EXTRACT(MONTH FROM CURRENT_DATE + interval '4 month'))
