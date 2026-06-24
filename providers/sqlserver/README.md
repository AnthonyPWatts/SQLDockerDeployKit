# SQL Server Provider

The SQL Server provider is the existing/default provider. The original `src`
layout remains supported for backwards compatibility, including `src/Dockerfile`
and `src/SQLScripts`.

The provider currently uses SQL Server 2022 through
`mcr.microsoft.com/mssql/server:2022-latest`.

## At a Glance

| Item | Value |
| --- | --- |
| Base image | `mcr.microsoft.com/mssql/server:2022-latest` |
| Published image | `ghcr.io/anthonypwatts/sqldockerdeploykit/database-container:main` |
| Local port | `1433` |
| Database | `MoviesDB` |
| Username | `sa` |
| Password environment variable | `MSSQL_SA_PASSWORD` (`SA_PASSWORD` is accepted as a backwards-compatible alias) |
| Bootstrap scripts | `src/SQLScripts/*.sql` |
| Smoke query | `providers/sqlserver/smoke-query.sql` |

## Run the Published Image

The published SQL Server image is built from the legacy `src/Dockerfile` path:

```shell
docker pull ghcr.io/anthonypwatts/sqldockerdeploykit/database-container:main
docker run --name sqldockerdeploykit-sqlserver -d -p 1433:1433 -e "MSSQL_SA_PASSWORD=YourStrong!Passw0rd" ghcr.io/anthonypwatts/sqldockerdeploykit/database-container:main
```

## Build the Provider-Layout Image

New provider-oriented work can build the equivalent SQL Server path through this
folder. This provider-layout image is smoke-tested by CI, but is not currently
published to GHCR:

```shell
docker build -t sqldockerdeploykit-sqlserver-provider -f providers/sqlserver/Dockerfile .
docker run --name sqldockerdeploykit-sqlserver-provider -d -p 1433:1433 -e "MSSQL_SA_PASSWORD=YourStrong!Passw0rd" sqldockerdeploykit-sqlserver-provider
```

## Smoke Query

Run the smoke query from inside the published container:

```shell
docker exec sqldockerdeploykit-sqlserver bash -lc 'sqlcmd -C -S localhost -U SA -P "YourStrong!Passw0rd" -i /tmp/app/provider/smoke-query.sql'
```

For the provider-layout container, replace the container name with
`sqldockerdeploykit-sqlserver-provider`.

## Connection Details

- Host: `localhost`
- Port: `1433`
- Database: `MoviesDB`
- Username: `sa`
- Password environment variable: `MSSQL_SA_PASSWORD` (`SA_PASSWORD` is still accepted as a backwards-compatible alias)
- Bootstrap scripts: `src/SQLScripts/*.sql`, executed in filename order by `src/entrypoint.sh`

## Readiness

- `src/entrypoint.sh` starts SQL Server, waits for `SELECT 1`, and fails the container if SQL Server exits early or does not become ready.
- `SQL_READY_TIMEOUT_SECONDS` and `SQL_READY_POLL_SECONDS` can adjust that startup wait.
- the bootstrap scripts run on container start. The included demo scripts are intended for fresh containers; use idempotent scripts or add a first-run guard before combining this path with persistent storage.
- `providers/sqlserver/Dockerfile` adds a Docker `HEALTHCHECK` using `sqlcmd`; the legacy published `src/Dockerfile` relies on the entrypoint readiness check and CI smoke test.

Run the CI-style smoke helper against a locally built image:

```shell
bash scripts/smoke-test-provider.sh sqlserver sqldockerdeploykit-sqlserver-provider
```

## Cleanup

```shell
docker rm -f sqldockerdeploykit-sqlserver
docker rm -f sqldockerdeploykit-sqlserver-provider
```
