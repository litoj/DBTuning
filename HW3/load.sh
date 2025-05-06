dropdb trdb && createdb trdb &&
psql -d trdb -f create.sql &&
psql -d trdb -f queries.sql
