#!/bin/bash
set -euo pipefail

echo "Executing entrypoint.sh"

if [ -z "${SA_PASSWORD:-}" ]; then
    echo "Error: SA_PASSWORD environment variable is required."
    echo "Set it with Docker, ARM, or Terraform before starting the container."
    exit 1
fi

SQLCMD="/opt/mssql-tools/bin/sqlcmd"
SQL_READY_TIMEOUT_SECONDS="${SQL_READY_TIMEOUT_SECONDS:-120}"
SQL_READY_POLL_SECONDS="${SQL_READY_POLL_SECONDS:-2}"
SQLSERVR_PID=""

stop_sql_server() {
    if [ -n "$SQLSERVR_PID" ] && kill -0 "$SQLSERVR_PID" 2>/dev/null; then
        echo "Stopping SQL Server."
        kill "$SQLSERVR_PID"
        wait "$SQLSERVR_PID" || true
    fi
}

wait_for_sql_server() {
    local elapsed_seconds=0

    echo "Waiting up to ${SQL_READY_TIMEOUT_SECONDS}s for SQL Server readiness."
    while [ "$elapsed_seconds" -lt "$SQL_READY_TIMEOUT_SECONDS" ]; do
        if ! kill -0 "$SQLSERVR_PID" 2>/dev/null; then
            echo "Error: SQL Server exited before it became ready."
            set +e
            wait "$SQLSERVR_PID"
            sqlservr_exit_code=$?
            set -e

            if [ "$sqlservr_exit_code" -eq 0 ]; then
                exit 1
            fi

            exit "$sqlservr_exit_code"
        fi

        if "$SQLCMD" -b -S localhost -U SA -P "$SA_PASSWORD" -Q "SELECT 1" >/dev/null 2>&1; then
            echo "SQL Server is ready."
            return 0
        fi

        sleep "$SQL_READY_POLL_SECONDS"
        elapsed_seconds=$((elapsed_seconds + SQL_READY_POLL_SECONDS))
    done

    echo "Error: SQL Server did not become ready within ${SQL_READY_TIMEOUT_SECONDS}s."
    stop_sql_server
    exit 1
}

trap stop_sql_server SIGINT SIGTERM

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &
SQLSERVR_PID=$!

# Wait until SQL Server accepts connections before running initialization scripts
wait_for_sql_server

# Run the initialization script from the correct location
SQL_SCRIPTS_PATH="/tmp/app/src/SQLScripts"
for sql_file in "$SQL_SCRIPTS_PATH"/*.sql; do

    # Execute SQL initialization script and capture output
    echo "Executing $sql_file"
    if OUTPUT=$( "$SQLCMD" -b -S localhost -U SA -P "$SA_PASSWORD" -i "$sql_file" 2>&1); then

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

# Keep the container lifecycle tied to the SQL Server process
echo "SQL initialization complete. Waiting on SQL Server process."
wait "$SQLSERVR_PID"
