#!/bin/bash
echo "Executing entrypoint.sh"
# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Wait for a bit to ensure SQL Server is up
sleep 30s

# Run the initialization script from the correct location
SQL_SCRIPTS_PATH="/tmp/app/SQLScripts"
for sql_file in $SQL_SCRIPTS_PATH/*.sql; do
    echo "Executing $sql_file"
    /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "<YourStrong!Passw0rd>" -i "$sql_file"
done

# Keep the container running
tail -f /dev/null
