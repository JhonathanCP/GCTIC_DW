import subprocess

# Parámetros de la base de datos original
original_user = "postgres"
original_host = "10.0.1.229"
original_port = "5432"
original_db = "pbi_gctic_v1.1"
backup_file = "backup.sql"

# Comando para crear el volcado
dump_cmd = f"pg_dump -U {original_user} -h {original_host} -p {original_port} -d {original_db} > {backup_file}"

# Ejecutar el comando de volcado
subprocess.run(dump_cmd, shell=True, check=True)

# Parámetros de la nueva base de datos
new_user = "postgres"
new_host = "10.0.1.229"
new_port = "5432"
new_db = "explora_datos"

# Comando para crear la nueva base de datos
create_db_cmd = f"createdb -U {new_user} -h {new_host} -p {new_port} {new_db}"

# Ejecutar el comando para crear la nueva base de datos
subprocess.run(create_db_cmd, shell=True, check=True)

# Comando para restaurar el volcado
restore_cmd = f"psql -U {new_user} -h {new_host} -p {new_port} -d {new_db} < {backup_file}"

# Ejecutar el comando de restauración
subprocess.run(restore_cmd, shell=True, check=True)
