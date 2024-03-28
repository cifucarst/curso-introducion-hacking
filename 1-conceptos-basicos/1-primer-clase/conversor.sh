#!/bin/bash

# Colores para la salida en pantalla
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
purpleColour="\e[0;33m\033[1m"
grayColour="\e[0;37m\033[1m"

# Función para manejar la señal SIGINT (Ctrl+C)
function ctrl_c (){
    echo -e "\n\n\t${redColour}[!] Saliendo...${endColour}\n"  # Mensaje de salida
    tput cnorm; exit 1  # Restablece el cursor y sale del script con código de error 1
}

trap ctrl_c INT  # Captura la señal SIGINT (Ctrl+C) y ejecuta la función ctrl_c

# Función para mostrar el panel de ayuda
function helpPanel(){
    echo -e "\n[+] Uso: ./$0"  # Mensaje de uso del script
    echo -e "\t${purpleColour}[b]${endColour}${grayColour} Convertir de binario a decimal${endColour}"  # Opción para convertir de binario a decimal
    echo -e "\t${purpleColour}[d]${endColour}${grayColour} Convertir de decimal a binario${endColour}"  # Opción para convertir de decimal a binario
    echo -e "\t${purpleColour}[h]${endColour}${grayColour} Mostrar este panel de ayuda${endColour}"  # Opción para mostrar el panel de ayuda
}

# Función para convertir una dirección IP de binario a decimal
function convertirBinario() {
    local ip="$1"  # Obtiene la dirección IP binaria como argumento

    # Verifica si la dirección IP binaria es válida
    if [[ ! "$ip" =~ ^[01]{1,8}\.[01]{1,8}\.[01]{1,8}\.[01]{1,8}$ ]]; then
        echo -e "\n${redColour}[!] No has ingresado una dirección IP válida ${endColour}"  # Muestra un mensaje de error si la dirección IP no es válida
        exit 1  # Sale del script con código de error 1
    else
        OLD_IFS=$IFS  # Guarda el separador de campo interno actual
        IFS='.'  # Establece el separador de campo interno como punto
        read -ra bytes <<< "$ip"  # Divide la dirección IP en octetos binarios
        printf "\n${blueColour}[+]${endColour} %s.%s.%s.%s\n" "$(echo "obase=2;${bytes[0]}" | bc)" "$(echo "obase=2;${bytes[1]}" | bc)" "$(echo "obase=2;${bytes[2]}" | bc)" "$(echo "obase=2;${bytes[3]}" | bc)"  # Convierte y muestra cada octeto binario como decimal
        IFS=$OLD_IFS  # Restablece el separador de campo interno
    fi
}

# Función para convertir una dirección IP binaria a decimal
function convertirDecimal() {
    local ipEnBinario="$1"  # Obtiene la dirección IP binaria como argumento

    # Verifica si la dirección IP binaria es válida
    if [[ ! "$ipEnBinario" =~ ^[01]{1,8}\.[01]{1,8}\.[01]{1,8}\.[01]{1,8}$ ]];then
        echo -e "${redColour}Error: La dirección IP ingresada no es binaria válida.${endColour}"  # Muestra un mensaje de error si la dirección IP no es válida
        exit 1  # Sale del script con código de error 1
    else
        OLD_IFS=$IFS  # Guarda el separador de campo interno actual
        IFS='.'  # Establece el separador de campo interno como punto
        read -ra bytes <<< "$ipEnBinario"  # Divide la dirección IP binaria en octetos
        printf "\n${blueColour}[+]${endColour} %s.%s.%s.%s\n" "$(echo "ibase=2;${bytes[0]}" | bc)" "$(echo "ibase=2;${bytes[1]}" | bc)" "$(echo "ibase=2;${bytes[2]}" | bc)" "$(echo "ibase=2;${bytes[3]}" | bc)"  # Convierte y muestra cada octeto binario como decimal
        IFS=$OLD_IFS  # Restablece el separador de campo interno
    fi
}

# Inicializa el contador de parámetros como entero
declare -i parameter_counter=0

# Bucle para procesar los argumentos de línea de comandos
while getopts "b:d:h" args; do
    case $args in
        b) ip="$OPTARG"; let parameter_counter+=1;;  # Opción para convertir de binario a decimal
        d) ipEnBinario="$OPTARG"; let parameter_counter+=2;;  # Opción para convertir de decimal a binario
        h) ;;  # Opción para mostrar el panel de ayuda
    esac
done

# Evalúa el contador de parámetros para determinar la acción a realizar
if [ $parameter_counter -eq 1 ]; then
    convertirBinario "$ip"  # Llama a la función para convertir de binario a decimal
elif [ $parameter_counter -eq 2 ]; then
    convertirDecimal "$ipEnBinario"  # Llama a la función para convertir de decimal a binario
else
    helpPanel  # Muestra el panel de ayuda si no se proporcionan parámetros adecuados
fi