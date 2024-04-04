#!/usr/bin/env python3
import subprocess
import sys
import re

# Function to check if script is run as root or with sudo privileges
def check_root():
    if not subprocess.getoutput("id -u") == "0":
        print("This script must be run as root or with sudo privileges.")
        sys.exit(1)

# Function to check if correct number of arguments is provided
def check_arguments():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <new_MAC_address>")
        sys.exit(2)

# Function to check if MAC address provided is in correct format
def check_mac_format(mac_address):
    if not re.match("^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$", mac_address):
        print("Invalid MAC address format. The format should be like this: 00-11-22-33-44-55")
        sys.exit(3)

# Function to get current MAC address
def get_current_mac():
    output = subprocess.getoutput("ip link show eth0")
    mac_address = re.search(r"ether ([0-9a-fA-F:]+)", output)
    if mac_address:
        return mac_address.group(1)
    else:
        return None

# Function to change MAC address
def change_mac_address(new_mac_address):
    subprocess.run(["sudo", "ip", "link", "set", "eth0", "down"], stderr=subprocess.DEVNULL)
    subprocess.run(["sudo", "ifconfig", "eth0", "down"], stderr=subprocess.DEVNULL)

    new_mac_address = new_mac_address.strip("-").replace("-", ":")
    subprocess.run(["sudo", "ifconfig", "eth0", "hw", "ether", new_mac_address], stderr=subprocess.DEVNULL)

    subprocess.run(["sudo", "ip", "link", "set", "eth0", "up"], stderr=subprocess.DEVNULL)
    subprocess.run(["sudo", "ifconfig", "eth0", "up"], stderr=subprocess.DEVNULL)

# Main function
def main():
    # Check if script is run as root
    check_root()
    # Check if correct number of arguments is provided
    check_arguments()

    # Get new MAC address from command line argument
    new_mac_address = sys.argv[1]
    # Check if provided MAC address is in correct format
    check_mac_format(new_mac_address)

    # Get current MAC address
    current_mac_address = get_current_mac()
    # Check if provided MAC address is different from current one
    if current_mac_address == new_mac_address:
        print("The provided MAC address is the same as the current one.")
        sys.exit(4)

    # Change MAC address
    change_mac_address(new_mac_address)

    # Check if MAC address was successfully changed
    if subprocess.run(["sudo", "ifconfig", "eth0"]).returncode != 0:
        print("Failed to change the MAC address. Check if the provided MAC address is valid and try again.")
        sys.exit(5)
    else:
        print("MAC address changed successfully.")

if __name__ == "__main__":
    main()