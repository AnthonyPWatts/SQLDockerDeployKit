# Use the official Microsoft SQL Server 2019 image as the base image
FROM mcr.microsoft.com/mssql/server:2019-latest

# Set the required environment variables for SQL Server
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=<YourStrong!Passw0rd>


# Temporarily switch to root user to change file permissions
USER root

# Create a directory in /tmp for scripts (to avoid permission issues)
RUN mkdir -p /tmp/app/SQLScripts
WORKDIR /tmp/app

# Copy the initialization script and entrypoint script into the container
COPY ./src/SQLScripts /tmp/app/src/SQLScripts/

COPY ./src/entrypoint.sh /tmp/app/src


# Grant execute permissions on the entrypoint script
RUN chmod +x /tmp/app/src/entrypoint.sh

# Switch back to the mssql user
USER mssql

# Set the entrypoint to the entrypoint script
ENTRYPOINT ["/tmp/app/src/entrypoint.sh"]
