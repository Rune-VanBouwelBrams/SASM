#!/bin/bash

# Check if it's executed as root
if [ "$EUID" -ne 0 ]
    then echo "Please run as root."
    exit
fi

if [ "$1" == "-t" ] && [ "$2" ] && [ "$3" ] && [ "$4" ]; 
then
        case "$2" in
        CNAME)
                echo "$3        IN         CNAME   $4." >> "/etc/bind/zones/db.$4"
                oldSerial=$(awk '/Serial/ {print $1}' /etc/bind/zones/db.$4)
                newSerial=$((oldSerial + 1))
                sed -i "s/\(^[[:space:]]*${oldSerial}[[:space:]]*;\sSerial\)/\t\t\t${newSerial}; Serial/" /etc/bind/zones/db.$4
        ;;

        MX)
                echo "  IN         MX      10      $3" >> "/etc/bind/zones/db.$5"
                echo "$3        IN      A       $4" >> "/etc/bind/zones/db.$5"    
            oldSerial=$(awk '/Serial/ {print $1}' /etc/bind/zones/db.$5)
                newSerial=$((oldSerial + 1))
                sed -i "s/\(^[[:space:]]*${oldSerial}[[:space:]]*;\sSerial\)/\t\t\t${newSerial}; Serial/" /etc/bind/zones/db.$5
        ;;

        *)
                echo "$3        IN      A       $4" >> "/etc/bind/zones/db.$5"
                oldSerial=$(awk '/Serial/ {print $1}' /etc/bind/zones/db.$5)
                newSerial=$((oldSerial + 1))
                sed -i "s/\(^[[:space:]]*${oldSerial}[[:space:]]*;\sSerial\)/\t\t\t${newSerial}; Serial/" /etc/bind/zones/db.$5
        ;;
       esac
 
    systemctl restart bind9
else
    echo "dns_add_record -t <A | MX | CNAME> <name> <value> <zone>: options cannot be empty"
fi

