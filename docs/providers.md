# Database Provider Model

SQLDockerDeployKit standardises a database container lifecycle. It does not try
to hide database dialect differences behind generic SQL.

Each provider should document and implement:

- image build command;
- container run command;
- credentials and environment variables;
- public port;
- readiness behaviour;
- bootstrap script location;
- smoke-query command;
- cleanup command;
- provider-specific caveats.

## Current Providers

| Provider | Image path | Port | Credentials | Bootstrap scripts | Smoke query |
| --- | --- | --- | --- | --- | --- |
| SQL Server | `src/Dockerfile` or `providers/sqlserver/Dockerfile` | `1433` | `sa` / `MSSQL_SA_PASSWORD` | `src/SQLScripts/*.sql` | `providers/sqlserver/smoke-query.sql` |
| PostgreSQL | `providers/postgres/Dockerfile` | `5432` | `postgres` / `POSTGRES_PASSWORD` | `providers/postgres/scripts/*.sql` | `providers/postgres/smoke-query.sql` |

## SQL Server Baseline

The default SQL Server provider uses `mcr.microsoft.com/mssql/server:2022-latest`.
This keeps the default image on a supported, established major version without
moving consumers to the newer SQL Server 2025 line by surprise.

Use `MSSQL_SA_PASSWORD` for new SQL Server container runs. `SA_PASSWORD` remains
accepted as a backwards-compatible alias for existing local, ARM, or Terraform
usage.

## Cloud Deployment Templates

The ARM and Terraform templates both support the current providers. SQL Server
remains the default to preserve the original Azure deployment path. PostgreSQL
is selected explicitly with `databaseProvider=postgres` in ARM or
`database_provider=postgres` in Terraform.

| Provider | Cloud image | Public port | Secure password variable | Username | Database |
| --- | --- | --- | --- | --- | --- |
| SQL Server | `ghcr.io/anthonypwatts/sqldockerdeploykit/database-container:main` | `1433` | `MSSQL_SA_PASSWORD` | `sa` | `MoviesDB` |
| PostgreSQL | `ghcr.io/anthonypwatts/sqldockerdeploykit/database-container-postgres:main` | `5432` | `POSTGRES_PASSWORD` | `postgres` | `moviesdb` |

The Terraform variable remains named `sa_password` so existing SQL Server
automation does not break. When PostgreSQL is selected, that value is mapped to
`POSTGRES_PASSWORD`.

The Azure Container Instances templates are intended for demonstrations,
development, and smoke testing. They expose the database port publicly and do
not configure persistent storage, private networking, TLS, firewall rules, or
backup policy. Treat container group recreation as database recreation unless
you add an explicit persistence design.

## Dialect Boundary

Provider SQL is intentionally separate. SQL Server scripts use T-SQL features
such as `GO`, `USE`, `PRINT`, `IDENTITY`, `NVARCHAR`, and `MERGE`. PostgreSQL
uses its own database creation flow, identity syntax, lowercase object names,
and `ON CONFLICT`.

The shared contract is observable setup behaviour, not byte-for-byte SQL
compatibility:

- the container starts;
- readiness can be checked;
- bootstrap scripts run in deterministic order;
- the Movies demo data is present;
- a smoke query returns row counts for the expected tables.

CI runs `scripts/smoke-test-provider.sh` before publishing. The smoke test starts
the image, runs the provider's smoke query, and asserts the expected `5:5:5`
Movies demo row counts. The workflow covers the legacy `src/Dockerfile`, the
provider-layout SQL Server Dockerfile, and the PostgreSQL provider Dockerfile.

## Adding Another Provider

Add a new folder under `providers/<engine>` with the provider's Dockerfile,
bootstrap scripts, smoke query, and README. Keep the SQL dialect native to that
engine, and update this document plus the CI image matrix when the provider is
ready to build.

Avoid adding a cross-provider SQL abstraction unless the project has a real
consumer need for it. The first portability goal is repeatable container setup,
not identical SQL commands.
