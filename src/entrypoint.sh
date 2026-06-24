#!/bin/bash
set -euo pipefail

echo "Executing entrypoint.sh"

if [ -z "${SA_PASSWORD:-}" ]; then
    echo "Error: SA_PASSWORD environment variable is required."
    echo "Set it with Docker, ARM, or Terraform before starting the container."
    exit 1
fi

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Wait for a bit to ensure SQL Server is up
sleep 30s

# Run the initialization script from the correct location
SQL_SCRIPTS_PATH="/tmp/app/src/SQLScripts"
for sql_file in "$SQL_SCRIPTS_PATH"/*.sql; do

    # Execute SQL initialization script and capture output
    echo "Executing $sql_file"
    if OUTPUT=$( /opt/mssql-tools/bin/sqlcmd -b -S localhost -U SA -P "$SA_PASSWORD" -i "$sql_file" 2>&1); then

        # Log output of script execution
        echo "Output of $sql_file:"
        echo "$OUTPUT"
        echo "Script execution successful."

    else
        SQLCMD_EXIT_CODE=$?
        echo "Output of $sql_file:"
        echo "$OUTPUT"
        echo "Error: SQL initialization script failed: $sql_file"
        exit "$SQLCMD_EXIT_CODE"
    fi

done


# Keep the container running
tail -f /dev/null
