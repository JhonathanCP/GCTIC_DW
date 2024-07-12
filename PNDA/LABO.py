from decouple import config
from sqlalchemy import create_engine
import pandas as pd
from datetime import datetime, timedelta, date
import time 
from sqlalchemy import text
import oracledb
import sys

# Definir las fechas de inicio y fin
fecha_ini = datetime(2023, 3, 10)
fecha_fin = datetime(2024, 4, 11)
DB_USER = config("USER2_BDI_POSTGRES")
DB_PASSWORD = config("PASS2_BDI_POSTGRES")
DB_NAME = "dw_essalud"
DB_PORT = "5432"
DB_HOST = config("HOST2_BDI_POSTGRES")
cadena2 = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine2 = create_engine(cadena2)
connection2 = engine2.connect()

# Calcular el número total de días
total_dias = (fecha_fin - fecha_ini).days
dias_por_intervalo = 10
# Recorrer cada intervalo de 10 días
for i in range(0, (fecha_fin - fecha_ini).days + 1, dias_por_intervalo):

	inicioTiempo = time.time()
	now_inicio = datetime.now()

	fecha_ini_intervalo = fecha_ini

	fecha_fin_intervalo = fecha_ini + timedelta(days=dias_por_intervalo - 1)

	fecha_ini_str = fecha_ini_intervalo.strftime('%Y-%m-%d')	
	fecha_fin_str = fecha_fin_intervalo.strftime('%Y-%m-%d')

	print(f"Procesando de {fecha_ini_str} al {fecha_fin_str}")
	
	# Ejecutar la consulta en la base de datos Oracle
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

	query = f"""SELECT DISTINCT
		RAS.REDASISDES AS RED_ASISTENCIAL,
		CAS.CENASIDES AS IPRESS,
		G.PERDOCIDENNUM AS ID_PACIENTE,
		CASE 
			WHEN G.PERSEXOCOD = 0 THEN 'FEMENINO'
			WHEN G.PERSEXOCOD = 1 THEN 'MASCULINO'
			ELSE 'OTRO'
		END AS SEXO,
		G.PERNACFEC AS FECHA_NAC,
		TSE.TIPSEGDES AS TIPO_SEGURO,
		CP.CPSDES,
		B.SOLEXAFEC AS FECHA_SOLICITUD,
		E.SOLEXDFECCITA AS FECHA_MUESTRA,
		A.RESEXAFEC AS FECHA_RESULTADO,
		ACE.DIAGCOD,
		D.RESEXDEXADES AS RESULTADO,
		D.RESEXDEXAUND AS UNIDADES,
		D.RESEXDEXAPRUDES AS DESCRIPCION_PRUEBA
	FROM CTDAA10 ACE
	LEFT OUTER JOIN 
		ETSEA10 B ON
			ACE.ATENAMBORICENASICOD = B.SOLEXAORICENASIORICOD
			AND ACE.ATENAMBCENASICOD = B.SOLEXACENASIORICOD
			AND ACE.ATENAMBNUM = B.SOLEXAACTMEDORINUM
	LEFT OUTER JOIN
		ETSED10 E ON
			E.SOLEXAORICENASICOD = B.SOLEXAORICENASICOD
			AND E.SOLEXACENASICOD = B.SOLEXACENASICOD
			AND E.SOLEXATIPEXACOD = B.SOLEXATIPEXACOD 
			AND E.SOLEXANUM = B.SOLEXANUM
	LEFT OUTER JOIN 
		ETREA10 A ON 
			B.SOLEXAORICENASICOD = A.RESEXAORICENASICOD
			AND B.SOLEXACENASICOD = A.RESEXACENASICOD
			AND B.SOLEXATIPEXACOD = A.RESEXATIPEXACOD
			AND B.SOLEXANUM = A.RESEXASOLEXANUM
	LEFT OUTER JOIN 
		ETRED10 D ON 
			D.RESEXAORICENASICOD = A.RESEXAORICENASICOD
			AND D.RESEXACENASICOD = A.RESEXACENASICOD
			AND D.RESEXATIPEXACOD = A.RESEXATIPEXACOD
			AND D.RESEXASOLEXANUM = A.RESEXASOLEXANUM
			AND D.RESEXACPSCOD = A.RESEXACPSCOD
	LEFT OUTER JOIN 
		CMPER10 G ON 
			G.PERSECNUM = B.SOLEXAPACSECNUM
	LEFT OUTER JOIN
		CMTSE10 TSE ON
			G.PERTIPSEGCOD = TSE.TIPSEGCOD
	LEFT OUTER JOIN
		CMCAS10 CAS ON
			CAS.CENASICOD = ACE.ATENAMBCENASICOD
	LEFT OUTER JOIN
		CMRAS10 RAS ON
			CAS.REDASISCOD = RAS.REDASISCOD
	LEFT OUTER JOIN
		CMCPP10 CP ON
			CP.CPSCOD = A.RESEXACPSCOD		
	WHERE 
	B.SOLEXAFEC >= TO_DATE('{fecha_ini_str}', 'YYYY-MM-DD') 
	AND B.SOLEXAFEC < TO_DATE('{fecha_fin_str}', 'YYYY-MM-DD')
	AND B.SOLEXATIPEXACOD = '2'"""

	base2 = pd.read_sql_query(query, con=connection0)

	print('lectura lista, subiendo...')

	connection0.close()

	borrando=f"DELETE FROM pnda_labo_cext WHERE fecha_solicitud >='{fecha_ini_str}' and fecha_solicitud <'{fecha_fin_str}'"
	borrado = connection2.execute(borrando)

	base2.to_sql(name=f'pnda_labo_cext', con=engine2, if_exists='append', index=False)
	finproceso = time.time()
	tiempoproceso = finproceso - inicioTiempo
	tiempoproceso = round(tiempoproceso, 3)
	print("Proceso completado satisfactoriamente en " + str(tiempoproceso) + " segundos")

	fecha_ini = fecha_fin_intervalo

connection2.close()
engine2.dispose()