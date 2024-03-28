def validar_ip_decimal(ip_decimal):
  """
  Valida si la dirección IP decimal es válida.

  Parámetros:
    ip_decimal (str): La dirección IP decimal a validar.

  Retorno:
    bool: True si la dirección IP es válida, False si no lo es.
  """
  try:
    octetos = ip_decimal.split(".")
    if len(octetos) != 4:
      return False
    for octeto in octetos:
      if not 0 <= int(octeto) <= 255:
        return False
  except ValueError:
    return False
  return True

def convertir_decimal_a_binario(ip_decimal):
  """
  Convierte la dirección IP decimal a binario.

  Parámetros:
    ip_decimal (str): La dirección IP decimal a convertir.

  Retorno:
    str: La dirección IP binaria.
  """
  octetos = ip_decimal.split(".")
  ip_binario = ""
  for octeto in octetos:
    binario = bin(int(octeto))[2:]
    binario = "0" * (8 - len(binario)) + binario
    ip_binario += binario + "."
  return ip_binario[:-1]

def convertir_binario_a_decimal(ip_binario):
  """
  Convierte la dirección IP binario a decimal.

  Parámetros:
    ip_binario (str): La dirección IP binario a convertir.

  Retorno:
    str: La dirección IP decimal.
  """
  octetos = ip_binario.split(".")
  ip_decimal = ""
  for octeto in octetos:
    decimal = int(octeto, 2)
    ip_decimal += str(decimal) + "."
  return ip_decimal[:-1]

def main():
  """
  Función principal que ejecuta el programa.
  """
  while True:
    opcion = input("¿Qué desea hacer? (1: Decimal a binario, 2: Binario a decimal): ")
    if opcion not in ("1", "2"):
      print("Opción no válida.")
      continue

    if opcion == "1":
      ip_decimal = input("Introduzca la dirección IP decimal: ")
      if not validar_ip_decimal(ip_decimal):
        print("Dirección IP decimal no válida.")
        continue
      ip_binario = convertir_decimal_a_binario(ip_decimal)
      print(f"La dirección IP en binario es: {ip_binario}")

    elif opcion == "2":
      ip_binario = input("Introduzca la dirección IP binario: ")
      try:
        octetos = ip_binario.split(".")
        for octeto in octetos:
          if not 0 <= int(octeto, 2) <= 255:
            raise ValueError
      except ValueError:
        print("Dirección IP binaria no válida.")
        continue
      ip_decimal = convertir_binario_a_decimal(ip_binario)
      print(f"La dirección IP en decimal es: {ip_decimal}")

    print()

if __name__ == "__main__":
  main()