#!/bin/bash

# Check if the script is run as root or with sudo privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root or with sudo privileges."
    exit 1
fi

# Check if the MAC address is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <new_MAC_address>"
    exit 2
fi

# Ensure that the new MAC address has the correct format (six groups of two hexadecimal digits, separated by hyphens)
if ! [[ $1 =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
    echo "Invalid MAC address format. The format should be like this: 00-11-22-33-44-55"
    exit 3
fi

# Save the current MAC address
CURRENT_MAC=$(ip link show eth0 | grep ether | awk '{print $2}')

# Check if the new MAC address is different from the current one
if [ "$CURRENT_MAC" == "$1" ]; then
    echo "The provided MAC address is the same as the current one."
    exit 4
fi

# Change the MAC address
sudo ip link set eth0 down 2> /dev/null
sudo ifconfig eth0 down 2> /dev/null

# Remove the leading and trailing hyphens
NEW_MAC=$(echo $1 | sed 's/^[-]+//' | sed 's/[-]+$//')

# Replace the hyphens with colons
NEW_MAC=$(echo $NEW_MAC | sed 's/[-]/:/g')

# Set the new MAC address
sudo ifconfig eth0 hw ether $NEW_MAC 2> /dev/null

# Bring the interface back up
sudo ip link set eth0 up 2> /dev/null
sudo ifconfig eth0 up 2> /dev/null

if [ $? -ne 0 ]; then
    echo "Failed to change the MAC address. Check if the provided MAC address is valid and try again."
    exit 5
else
    echo "MAC address changed successfully."
fi