#!/bin/bash

function ctrl_c (){
    echo -e "\n\n\t[!] Saliendo...\n"
    tput cnorm;exit 1
}

trap ctrl_c SIGINT
tput civis

for i in $(seq 1 254);do
    for port in 21 22 23 25 80 139 443 445 8080;do
        timeout 1 bash -c "echo '' > /dev/tcp/192.168.1.$i/$port" 2>/dev/null && echo "[+] Host 192.168.1.$i - Port $port (Open)" &
    done
done

wait
tput cnorm