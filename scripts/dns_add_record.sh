#!/bin/bash
echo $1

# Check if it's executed as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

# Function to increment the serial number in the zone file
increment_serial() {
    zone_file="/etc/bind/zones/db.$1"
    oldSerial=$(awk '/Serial/ {print $1}' "$zone_file" | tr -d ';')
    newSerial=$((oldSerial + 1))
    sed -i "s/\(^[[:space:]]*${oldSerial}[[:space:]]*;\sSerial\)/\t\t\t${newSerial} ; Serial/" "$zone_file"
}

# Parse options and arguments
while getopts "t:" opt; do
    case $opt in
        t)
            record_type="$OPTARG"
            if [[ "$record_type" != "A" && "$record_type" != "MX" && "$record_type" != "CNAME" ]]; then
                echo "Error: Invalid record type. Supported types are A, MX, and CNAME."
                print_usage
            fi
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            print_usage
            ;;
    esac
done

# Shift the processed options
shift $((OPTIND - 1))

# Ensure exactly 3 arguments are provided
if [ "$#" -ne 3 ]; then
    print_usage
fi

type=A

# Get the arguments
record_name="$1"
record_value="$2"
zone="$3"

zone_file="/etc/bind/zones/db.$zone"

# Handle different types of records
case "$record_type" in
    A)
        echo "$record_name.$zone. IN A $record_value" >> "$zone_file"
        ;;
    MX)
        echo "$record_name IN MX 10 $record_value." >> "$zone_file"
        echo "$record_value. IN A $record_value" >> "$zone_file"
        ;;
    CNAME)
        echo "$record_name.$zone. IN CNAME $record_value" >> "$zone_file"
        ;;
    *)
        echo "Unsupported record type: $record_type"
        exit 1
        ;;
esac

# Increment the serial number
increment_serial "$zone"

echo "$record_name.$zone. IN A $record_value"
echo "$record_name IN MX 10 $record_value."
echo "$record_value. IN A $record_value"
echo "$record_name.$zone. IN CNAME $record_value"

systemctl restart bind9

echo "Record added: $record_name.$zone IN $record_type $record_value"
