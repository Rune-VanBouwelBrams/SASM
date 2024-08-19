#!/bin/bash
echo $1
# Check if it's executed as root
if [ "$EUID" -ne 0 ]
    then echo "Please run as root."
    exit
fi

increment_serial() {
	zone_file="/etc/bind/zones/db.$1"
	oldSerial=$(awk '/Serial/ {print $1}' "$zone_file" | tr -d ';')
	newSerial=$((oldSerial + 1))
	sed -i "s/\(^[[:space:]]*${oldSerial}[[:space:]]*;\sSerial\)/\t\t\t${newSerial}; Serial/" "$zone_file"
}

if [ "$1" == "-t" ] && [ "$2" ] && [ "$3" ] && [ "$4" ]; 
then
        case "$2" in
        CNAME)
		echo "$3        IN         CNAME   $4." >> "/etc/bind/zones/db.$4"
		increment_serial "$4"
        ;;

        MX)
                echo "  IN         MX      10      $3" >> "/etc/bind/zones/db.$5"
                echo "$3        IN      A       $4" >> "/etc/bind/zones/db.$5"    
                increment_serial "$5"
        ;;

        *)
                echo "$3        IN      A       $4" >> "/etc/bind/zones/db.$5"
                increment_serial "$5"
        ;;
       esac
    	systemctl restart bind9
elif [ "$1" ] && [ "$2" ] && [ "$3" ];
then
	echo "$1        IN      A       $2" >> "/etc/bind/zones/db.$3"
	increment_serial "$3"
	systemctl restart bind9
else
    	echo "dns_add_record -t <A | MX | CNAME> <name> <value> <zone>: options cannot be empty"
fi

systemctl restart bind9
