#!/bin/bash

DB_HOST="localhost"
DB_USER="root"
DB_PASSWORD="7MkoYlYr0px1AUxz"
DB_NAME="check"

# Check the current row count in the 'log' table
row_count=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "SELECT COUNT(*) FROM log;" -s)

if [ $row_count -gt 81 ]; then
    # Determine how many rows to remove to get back to the range (80-100)
    rows_to_remove=$((row_count - 81))

    # Use a valid column for ordering, e.g., assuming you have an 'id' column
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "DELETE FROM log ORDER BY date ASC LIMIT $rows_to_remove;"

    if [ $? -eq 0 ]; then
        echo "Removed $rows_to_remove rows to maintain the range (80-100)."
    else
        echo "Error deleting rows from the database."
    fi
else
    echo "Row count is within the acceptable range (80-100): $row_count"
fi
sudo systemctl restart mysql
