FROM postgres:16

ENV POSTGRES_DB=moviesdb
ENV POSTGRES_USER=postgres

COPY providers/postgres/scripts/*.sql /docker-entrypoint-initdb.d/
COPY providers/postgres/smoke-query.sql /usr/local/share/sqldockerdeploykit/smoke-query.sql

HEALTHCHECK --interval=10s --timeout=5s --start-period=10s --retries=12 \
    CMD pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB" || exit 1
