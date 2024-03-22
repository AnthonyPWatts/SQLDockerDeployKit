#!/bin/bash
echo "Executing entrypoint.sh"
# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Wait for a bit to ensure SQL Server is up
sleep 30s

# Run the initialization script from the correct location
SQL_SCRIPTS_PATH="/tmp/app/src/SQLScripts"
for sql_file in $SQL_SCRIPTS_PATH/*.sql; do

    # Execute SQL initialization script and capture output
    echo "Executing $sql_file"
    OUTPUT=$( /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "<YourStrong!Passw0rd>" -i "$sql_file")

    # Log output of script execution
    echo "Output of $sql_file:"
    echo "$OUTPUT"

    # Check if any errors occurred during script execution
    if [[ "$OUTPUT" == *"Error"* ]]; then
        echo "Error: An error occurred during script execution."
        # TODO: Exit the loop or handle the error as needed
    else
        echo "Script execution successful."
    fi

done


# Keep the container running
tail -f /dev/null
