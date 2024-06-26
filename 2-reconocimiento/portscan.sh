#!/bin/bash

function ctrl_c(){
    echo -e "\n\n\t[!] Saliendo...\n"
    tput cnorm; exit 1
}

trap ctrl_c SIGINT

declare -a ports=( $(seq 1 65535) )

function checkPort(){
    (exec 3<> /dev/tcp/$1/$2) 2>/dev/null

    if [ $? -eq 0 ];then
        echo "[+] Host $1 - Port $2 (Open)"
    fi
    exec 3<&-
    exec 3>&-
}

tput civis

if [ $1 ];then
    for port in ${ports[@]};do
        checkPort $1 $port &
    done
else
    echo -e "\n[!] Uso: <ip_address>"
fi
wait
tput cnorm