# SQL Server Provider

The SQL Server provider is the existing/default provider. The original `src`
layout remains supported for backwards compatibility, including `src/Dockerfile`
and `src/SQLScripts`.

New provider-oriented work can build the same SQL Server path through this
folder:

```shell
docker build -t sqldockerdeploykit-sqlserver -f providers/sqlserver/Dockerfile .
docker run --name sqldockerdeploykit-sqlserver -d -p 1433:1433 -e "SA_PASSWORD=YourStrong!Passw0rd" sqldockerdeploykit-sqlserver
```

Run the provider smoke query from inside the container:

```shell
docker exec sqldockerdeploykit-sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "YourStrong!Passw0rd" -i /tmp/app/provider/smoke-query.sql
```

Connection details:

- Host: `localhost`
- Port: `1433`
- Database: `MoviesDB`
- Username: `sa`
- Password environment variable: `SA_PASSWORD`
- Bootstrap scripts: `src/SQLScripts/*.sql`, executed in filename order by `src/entrypoint.sh`

Cleanup:

```shell
docker rm -f sqldockerdeploykit-sqlserver
```
