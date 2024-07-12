import colorama
from colorama import Fore, Style

colorama.init()

print(f"{Fore.YELLOW}\n==> Ejecutando ETL8_CONSULTAEXTERNA_1_MENSUAL{Style.RESET_ALL}\n")
import ETL8_CONSULTAEXTERNA_1_MENSUAL
print(f"{Fore.GREEN}\n==> Ejecución de ETL8_CONSULTAEXTERNA_1_MENSUAL finalizada.{Style.RESET_ALL}\n")

print(f"{Fore.YELLOW}\n==> Ejecutando ETL8_CONSULTAEXTERNA_3_MENSUAL{Style.RESET_ALL}\n")
import ETL8_CONSULTAEXTERNA_3_MENSUAL
print(f"{Fore.GREEN}\n==> Ejecución de ETL8_CONSULTAEXTERNA_3_MENSUAL finalizada.{Style.RESET_ALL}\n")

print(f"{Fore.YELLOW}\n==> Ejecutando ETL8_CONSULTAEXTERNA_4_MENSUAL{Style.RESET_ALL}\n")
import ETL8_CONSULTAEXTERNA_4_MENSUAL
print(f"{Fore.GREEN}\n==> Ejecución de ETL8_CONSULTAEXTERNA_4_MENSUAL finalizada.{Style.RESET_ALL}\n")


