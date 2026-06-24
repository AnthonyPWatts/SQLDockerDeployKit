# SQL Server Provider

The SQL Server provider is the existing/default provider. The original `src`
layout remains supported for backwards compatibility, including `src/Dockerfile`
and `src/SQLScripts`.

The provider currently uses SQL Server 2022 through
`mcr.microsoft.com/mssql/server:2022-latest`.

New provider-oriented work can build the same SQL Server path through this
folder:

```shell
docker build -t sqldockerdeploykit-sqlserver -f providers/sqlserver/Dockerfile .
docker run --name sqldockerdeploykit-sqlserver -d -p 1433:1433 -e "MSSQL_SA_PASSWORD=YourStrong!Passw0rd" sqldockerdeploykit-sqlserver
```

Run the provider smoke query from inside the container:

```shell
docker exec sqldockerdeploykit-sqlserver bash -lc 'sqlcmd -C -S localhost -U SA -P "YourStrong!Passw0rd" -i /tmp/app/provider/smoke-query.sql'
```

Connection details:

- Host: `localhost`
- Port: `1433`
- Database: `MoviesDB`
- Username: `sa`
- Password environment variable: `MSSQL_SA_PASSWORD` (`SA_PASSWORD` is still accepted as a backwards-compatible alias)
- Bootstrap scripts: `src/SQLScripts/*.sql`, executed in filename order by `src/entrypoint.sh`

Cleanup:

```shell
docker rm -f sqldockerdeploykit-sqlserver
```
