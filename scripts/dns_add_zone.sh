#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 1"
    exit 1
fi

# Get the old serial number
oldSerial=$(awk '/Serial/ {print $1}' /etc/bind/zones/db.rune-vanbouwelbrams.sasm.uclllabs.be)
newSerial=$((oldSerial + 1)) 

# Add NS record for the subzone to the main zone
echo "$1    IN    NS    ns.rune-vanbouwelbrams.sasm.uclllabs.be." >> /etc/bind/zones/db.rune-vanbouwelbrams.sasm.uclllabs.be

# Adjust the serial in the subzone file
sed -i "s/\(^[[:space:]]*${oldSerial}[[:space:]]*;\sSerial\)/\t\t\t${newSerial} ; Serial/" /etc/bind/zones/db.rune-vanbouwelbrams.sasm.uclllabs.be

# Create the subzone file
cat <<EOF > /etc/bind/zones/db.$1.rune-vanbouwelbrams.sasm.uclllabs.be
\$TTL 300
@       IN      SOA     ns.$1.rune-vanbouwelbrams.sasm.uclllabs.be. admin.rune-vanbouwelbrams.sasm.uclllabs.be. (
                        1         ; Serial
                        300              ; Refresh
                        300              ; Retry
                        300              ; Expire
                        300              ; Minimum TTL
)
                IN      NS      ns.rune-vanbouwelbrams.sasm.uclllabs.be.
                IN      A       193.191.176.138
ns              IN      A       193.191.176.138
mx		IN	A	193.191.176.138
		IN	MX	mx.rune-vanbouwelbrams.sasm.uclllabs.be.
EOF


# Include the subzone file in named.conf.local
echo "zone \"$1.rune-vanbouwelbrams.sasm.uclllabs.be\" {" >> /etc/bind/named.conf.local
echo "    type master;" >> /etc/bind/named.conf.local
echo "    file \"/etc/bind/zones/db.$1.rune-vanbouwelbrams.sasm.uclllabs.be\";" >> /etc/bind/named.conf.local
echo "};" >> /etc/bind/named.conf.local

# Restart BIND to apply changes
systemctl restart bind9

echo "Subzone $1.rune-vanbouwelbrams.sasm.uclllabs.be has been added successfully."
