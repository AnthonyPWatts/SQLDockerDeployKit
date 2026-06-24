#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <sqlserver|postgres> <image>"
    exit 2
fi

PROVIDER="$1"
IMAGE="$2"
PASSWORD="${SQLDDK_SMOKE_PASSWORD:-YourStrong!Passw0rd}"
TIMEOUT_SECONDS="${SQLDDK_SMOKE_TIMEOUT_SECONDS:-180}"
POLL_SECONDS="${SQLDDK_SMOKE_POLL_SECONDS:-3}"
CONTAINER="sqlddk-smoke-${PROVIDER}-${GITHUB_RUN_ID:-local}-$$"

cleanup() {
    docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
}

print_logs() {
    echo "Container logs for $CONTAINER:"
    docker logs "$CONTAINER" 2>&1 || true
}

trim_last_non_empty_line() {
    awk 'NF { line = $0 } END { gsub(/^[ \t]+|[ \t]+$/, "", line); print line }'
}

sqlserver_exec() {
    docker exec -e "SQLDDK_SMOKE_PASSWORD=$PASSWORD" "$CONTAINER" bash -lc '
        set -euo pipefail

        if command -v sqlcmd >/dev/null 2>&1; then
            SQLCMD="$(command -v sqlcmd)"
        elif [ -x /opt/mssql-tools18/bin/sqlcmd ]; then
            SQLCMD=/opt/mssql-tools18/bin/sqlcmd
        elif [ -x /opt/mssql-tools/bin/sqlcmd ]; then
            SQLCMD=/opt/mssql-tools/bin/sqlcmd
        else
            echo "sqlcmd was not found in the SQL Server image." >&2
            exit 1
        fi

        "$SQLCMD" -b -C -S localhost -U SA -P "$SQLDDK_SMOKE_PASSWORD" "$@"
    ' bash "$@"
}

assert_sqlserver_counts() {
    local result

    sqlserver_exec \
        -i /tmp/app/provider/smoke-query.sql >/dev/null 2>&1

    result="$(
        sqlserver_exec \
            -h -1 -W \
            -Q "SET NOCOUNT ON; USE MoviesDB; SELECT CAST((SELECT COUNT(*) FROM Movies) AS varchar(10)) + ':' + CAST((SELECT COUNT(*) FROM Actors) AS varchar(10)) + ':' + CAST((SELECT COUNT(*) FROM MoviesActors) AS varchar(10));" 2>/dev/null |
            tr -d '\r' |
            trim_last_non_empty_line
    )"

    [ "$result" = "5:5:5" ]
}

assert_postgres_counts() {
    local result

    docker exec "$CONTAINER" \
        psql -U postgres -d moviesdb -v ON_ERROR_STOP=1 \
        -f /usr/local/share/sqldockerdeploykit/smoke-query.sql >/dev/null 2>&1

    result="$(
        docker exec "$CONTAINER" \
            psql -U postgres -d moviesdb -v ON_ERROR_STOP=1 -t -A \
            -c "SELECT (SELECT COUNT(*) FROM movies)::text || ':' || (SELECT COUNT(*) FROM actors)::text || ':' || (SELECT COUNT(*) FROM movie_actors)::text;" 2>/dev/null |
            tr -d '\r' |
            trim_last_non_empty_line
    )"

    [ "$result" = "5:5:5" ]
}

wait_for_smoke() {
    local elapsed=0

    while [ "$elapsed" -lt "$TIMEOUT_SECONDS" ]; do
        if "$@"; then
            echo "$PROVIDER smoke test passed for $IMAGE."
            return 0
        fi

        local state
        state="$(docker inspect -f '{{.State.Status}}' "$CONTAINER" 2>/dev/null || echo missing)"
        if [ "$state" = "exited" ] || [ "$state" = "dead" ] || [ "$state" = "missing" ]; then
            echo "Container $CONTAINER stopped before smoke test passed."
            print_logs
            return 1
        fi

        sleep "$POLL_SECONDS"
        elapsed=$((elapsed + POLL_SECONDS))
    done

    echo "$PROVIDER smoke test did not pass within ${TIMEOUT_SECONDS}s."
    print_logs
    return 1
}

trap cleanup EXIT

case "$PROVIDER" in
    sqlserver)
        docker run --name "$CONTAINER" -d -e "MSSQL_SA_PASSWORD=$PASSWORD" "$IMAGE" >/dev/null
        wait_for_smoke assert_sqlserver_counts
        ;;
    postgres)
        docker run --name "$CONTAINER" -d -e "POSTGRES_PASSWORD=$PASSWORD" "$IMAGE" >/dev/null
        wait_for_smoke assert_postgres_counts
        ;;
    *)
        echo "Unknown provider: $PROVIDER"
        exit 2
        ;;
esac
