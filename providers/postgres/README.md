# PostgreSQL Provider

The PostgreSQL provider uses the official PostgreSQL image and keeps PostgreSQL
SQL separate from the SQL Server scripts. The provider shares the kit's
bootstrap lifecycle, but not the SQL dialect.

Build and run from the repository root:

```shell
docker build -t sqldockerdeploykit-postgres -f providers/postgres/Dockerfile .
docker run --name sqldockerdeploykit-postgres -d -p 5432:5432 -e "POSTGRES_PASSWORD=YourStrong!Passw0rd" sqldockerdeploykit-postgres
```

Run the provider smoke query from inside the container:

```shell
docker exec sqldockerdeploykit-postgres psql -U postgres -d moviesdb -f /usr/local/share/sqldockerdeploykit/smoke-query.sql
```

Deploy the published PostgreSQL image to Azure Container Instances by selecting
the PostgreSQL provider in the shared templates:

```shell
terraform plan -var "database_provider=postgres" -var "sa_password=YourStrong!Passw0rd"
terraform apply -var "database_provider=postgres" -var "sa_password=YourStrong!Passw0rd"
```

For ARM deployments, set `databaseProvider` to `postgres`. The shared password
parameter is mapped to `POSTGRES_PASSWORD`.

Connection details:

- Host: `localhost`
- Port: `5432`
- Database: `moviesdb`
- Username: `postgres`
- Password environment variable: `POSTGRES_PASSWORD`
- Bootstrap scripts: `providers/postgres/scripts/*.sql`, executed by the official PostgreSQL entrypoint on first database initialisation

PostgreSQL only runs files in `/docker-entrypoint-initdb.d` when the data
directory is empty. If you mount a persistent volume, remove or recreate that
volume before expecting bootstrap scripts to run again.

Cleanup:

```shell
docker rm -f sqldockerdeploykit-postgres
```
