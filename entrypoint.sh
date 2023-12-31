#!/bin/bash

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Wait for a bit to ensure SQL Server is up
sleep 30s

# Run the initialization script from the correct location, using the SA_PASSWORD and DB_NAME parameters
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -i /tmp/app/CombinedInit.sql -v DBName=$DB_NAME

# Keep the container running
tail -f /dev/null
