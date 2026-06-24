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
| SQL Server | `src/Dockerfile` or `providers/sqlserver/Dockerfile` | `1433` | `sa` / `SA_PASSWORD` | `src/SQLScripts/*.sql` | `providers/sqlserver/smoke-query.sql` |
| PostgreSQL | `providers/postgres/Dockerfile` | `5432` | `postgres` / `POSTGRES_PASSWORD` | `providers/postgres/scripts/*.sql` | `providers/postgres/smoke-query.sql` |

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

CI runs `scripts/smoke-test-provider.sh` for every provider image before
publishing. The smoke test starts the image, runs the provider's smoke query,
and asserts the expected `5:5:5` Movies demo row counts.

## Adding Another Provider

Add a new folder under `providers/<engine>` with the provider's Dockerfile,
bootstrap scripts, smoke query, and README. Keep the SQL dialect native to that
engine, and update this document plus the CI image matrix when the provider is
ready to build.

Avoid adding a cross-provider SQL abstraction unless the project has a real
consumer need for it. The first portability goal is repeatable container setup,
not identical SQL commands.
