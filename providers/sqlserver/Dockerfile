# SQL Server provider Dockerfile.
#
# This intentionally keeps using the original src layout so existing SQL Server
# customisation and the legacy src/Dockerfile path do not drift.
FROM mcr.microsoft.com/mssql/server:2019-latest

ENV ACCEPT_EULA=Y

USER root

RUN apt-get update && apt-get install -y \
    mssql-tools unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

ENV PATH=${PATH}:/opt/mssql-tools/bin

WORKDIR /tmp/app

RUN mkdir -p /tmp/app/provider

COPY src /tmp/app/src/
COPY providers/sqlserver/smoke-query.sql /tmp/app/provider/smoke-query.sql

RUN chmod +x /tmp/app/src/entrypoint.sh && chown -R mssql /tmp/app

USER mssql

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=12 \
    CMD /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -Q "SELECT 1" >/dev/null || exit 1

ENTRYPOINT ["/tmp/app/src/entrypoint.sh"]
