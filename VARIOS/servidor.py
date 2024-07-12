import socket

# Dirección IP del servidor
host = '10.0.1.228'

# Lista de puertos a probar
puertos = [
    21,    # FTP
    22,    # SSHLINUX
    23,    # Telnet
    25,    # SMTP
    53,    # DNS
    80,    # HTTP
    110,   # POP3
    115,   # SFTP
    119,   # NNTP
    123,   # NTP
    139,   # SSHWIN
    143,   # IMAP
    161,   # SNMP
    194,   # IRC
    443,   # HTTPS
    465,   # SMTPS
    587,   # SMTP (submission)
    993,   # IMAPS
    995,   # POP3S
    1080,  # SOCKS Proxy
    3306,  # MySQL
    5432,  # PostgreSQL
    8080,  # HTTP alternativo
    8443   # HTTPS alternativo
]

def probar_puertos(host, puertos):
    for puerto in puertos:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(1)  # Establece un tiempo de espera de 1 segundo
        resultado = sock.connect_ex((host, puerto))
        if resultado == 0:
            print(f"El puerto {puerto} está abierto en {host}")
        else:
            print(f"El puerto {puerto} está cerrado en {host}")
        sock.close()

probar_puertos(host, puertos)
