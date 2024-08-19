#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 1"
    exit 1
fi

# Add NS record for the subzone to the main zone
#echo "$1    IN    NS    ns.rune-vanbouwelbrams.sasm.uclllabs.be." >> /etc/bind/zones/db.rune-vanbouwelbrams.sasm.uclllabs.be

# Adjust the serial in the subzone file
#sed -i "s/\(^[[:space:]]*${oldSerial}[[:space:]]*;\sSerial\)/\t\t\t${newSerial} ; Serial/" /etc/bind/zones/db.rune-vanbouwelbrams.sasm.uclllabs.be

subzone="$1"
main_zone="rune-vanbouwelbrams.sasm.uclllabs.be"
zonefile="/etc/bind/zones/db.$subzone.$main_zone"
 
echo "\$TTL    300
@       IN      SOA     ns.$main_zone. admin.$main_zone. (
                  1	; serial
                  300	; refresh
                  300	; retry
                  300	; expire
                  300 )	; minimum TTL
;
@       IN      NS      ns.$main_zone.
@       IN      A       193.191.176.171" > "$zonefile"
 
named_conf_local="/etc/bind/named.conf.local"
echo "zone \"$subzone.$main_zone\" {
    type master;
    file \"$zonefile\";
};" >> "$named_conf_local"
 
subzone_ns="ns.rune-vanbouwelbrams.sasm.uclllabs.be."
main_zonefile="/etc/bind/zones/db.rune-vanbouwelbrams.sasm.uclllabs.be"
 
echo "$SUBZONE  IN  NS  $subzone_ns" >> "$main_zonefile"
 
#oldserial=$(awk -F';' '/Serial/ {print $1}' "$main_zonefile" | awk '{print $1}')
#echo "$oldserial"
#echo "Old Serial: $oldserial" 
#newserial=$((oldserial + 1))
#echo "$newserial" 

# Extract the old serial number
oldserial=$(awk -F';' '/serial/ {print $1}' "$main_zonefile" | awk '{print $1}')

# Debugging output
echo "Old Serial: $oldserial"

# Increment the serial number
if [ -n "$oldserial" ]; then
    newserial=$((oldserial + 1))
    echo "New Serial: $newserial"
    sed -i "s/$oldserial/$newserial/" "$main_zonefile"
else
    echo "Error: Could not extract a valid serial number from $main_zonefile"
    exit 1
fi

sed -i "s/$oldserial/$newserial/" "$main_zonefile"
echo "Subzone $1.rune-vanbouwelbrams.sasm.uclllabs.be has been added successfully."

systemctl restart bind9
