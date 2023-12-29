#!/bin/bash

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Wait for a bit to ensure SQL Server is up
sleep 30s

# Run the initialization script from the correct location
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "<YourStrong!Passw0rd>" -i /tmp/app/CombinedInit.sql

# Keep the container running
tail -f /dev/null
