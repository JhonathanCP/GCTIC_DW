import os
import PyPDF2
import pandas as pd
from datetime import datetime

# Ruta de la carpeta que contiene los archivos PDF
carpeta_principal = 'X:\\documentos'

def obtener_cantidad_de_hojas(pdf_path):
    try:
        with open(pdf_path, 'rb') as pdf_file:
            pdf_reader = PyPDF2.PdfReader(pdf_file)
            return len(pdf_reader.pages)
    except PyPDF2.utils.PdfReadError:
        # Captura la excepción de EOF y regresa -1 como indicador de error
        print(f'Error al leer {pdf_path}. Archivo PDF mal formateado o dañado.')
        return -1

def obtener_fecha_modificacion(archivo_path):
    # Obtener la fecha de modificación del archivo en formato datetime
    fecha_modificacion = os.path.getmtime(archivo_path)
    return datetime.fromtimestamp(fecha_modificacion).date()

def escribir_resultados_en_lotes(output_file, data):
    # Escribir los resultados en el archivo de salida en lotes
    output_file.write(data.to_string())
    output_file.write('\n\n')  # Separador entre lotes

def barrido_carpeta_pdf(carpeta, archivo_salida, tamano_lote=1000):
    data = {'Fecha': [], 'Cantidad de Hojas': []}
    lote_actual = 0

    for directorio_actual, subdirectorios, archivos in os.walk(carpeta):
        for archivo in archivos:
            if archivo.endswith('.pdf'):
                pdf_path = os.path.join(directorio_actual, archivo)
                
                # Manejar el error EOF al obtener la cantidad de hojas
                cantidad_hojas = obtener_cantidad_de_hojas(pdf_path)
                if cantidad_hojas != -1:
                    fecha_modificacion = obtener_fecha_modificacion(pdf_path)

                    data['Fecha'].append(fecha_modificacion)
                    data['Cantidad de Hojas'].append(cantidad_hojas)

                    print(f'{pdf_path}: {fecha_modificacion} - {cantidad_hojas} páginas')

                    # Escribir en lotes
                    if len(data['Fecha']) >= tamano_lote:
                        with open(archivo_salida, 'a') as output_file:
                            escribir_resultados_en_lotes(output_file, pd.DataFrame(data))
                        data = {'Fecha': [], 'Cantidad de Hojas': []}
                        lote_actual += 1

    # Escribir los resultados finales
    if data['Fecha']:
        with open(archivo_salida, 'a') as output_file:
            escribir_resultados_en_lotes(output_file, pd.DataFrame(data))

# Llamada a la función de barrido con archivo de salida 'output.txt' y tamaño de lote 100
barrido_carpeta_pdf(carpeta_principal, 'output.txt', tamano_lote=1000)
