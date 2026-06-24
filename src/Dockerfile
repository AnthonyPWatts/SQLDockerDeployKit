# Use the official Microsoft SQL Server 2022 image as the base image
FROM mcr.microsoft.com/mssql/server:2022-latest

# Set the required environment variables for SQL Server
ENV ACCEPT_EULA=Y

# Make sqlcmd available whether the base image exposes mssql-tools18 or the older tools path.
ENV PATH=${PATH}:/opt/mssql-tools18/bin:/opt/mssql-tools/bin

# Temporarily switch to root for filesystem setup
USER root

# Create needed directories
RUN mkdir -p /tmp/app/SQLScripts /tmp/app/provider

# Set working directory
WORKDIR /tmp/app

# Copy scripts into container - didn't work so currently attempting the whole src folder
COPY src /tmp/app/src/
COPY providers/sqlserver/smoke-query.sql /tmp/app/provider/smoke-query.sql

# Grant execute permissions on the entrypoint script
RUN chmod +x /tmp/app/src/entrypoint.sh && chown -R mssql /tmp/app

# Switch back to the SQL Server user
USER mssql

# Set the entrypoint to the entrypoint script
ENTRYPOINT ["/tmp/app/src/entrypoint.sh"]
