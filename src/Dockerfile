# Use the official Microsoft SQL Server 2019 image as the base image
FROM mcr.microsoft.com/mssql/server:2019-latest

# Set the required environment variables for SQL Server
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=<YourStrong!Passw0rd>


# Temporarily switch to root for package installation
USER root

# Update package lists and install required tools
RUN apt-get update && apt-get install -y \
    mssql-tools unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# Add mssql-tools to the PATH variable
ENV PATH=${PATH}:/opt/mssql-tools/bin

# Create needed directories
RUN mkdir -p /tmp/app/SQLScripts

# Set working directory
WORKDIR /tmp/app

# Copy scripts into container - didn't work so currently attempting the whole src folder
COPY src /tmp/app/src/

# Grant execute permissions on the entrypoint script
RUN chmod +x /tmp/app/src/entrypoint.sh && chown -R mssql /tmp/app

# Switch back to the SQL Server user
USER mssql

# Set the entrypoint to the entrypoint script
ENTRYPOINT ["/tmp/app/src/entrypoint.sh"]
