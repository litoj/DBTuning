#!/bin/bash

pg() {
  psql -d trdb -c "$@"
}

maria() {
  mariadb -D trdb -e "$@"
}

structure=$(sed '/ALTER/d;/CREATE.*INDEX/d' create.sql)
constraints=$(grep -e 'CREATE.*INDEX' -e 'ALTER' create.sql)

cleanup() {
  case $1 in
    p*)
      psql -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'trdb' AND pid <> pg_backend_pid();"
      dropdb trdb
      createdb trdb
      pg "$structure"

      psql_copy_template="\\copy name FROM 'name.csv' DELIMITER ',' CSV HEADER"
      for f in *.csv; do
        pg "${psql_copy_template//name/${f%.csv}}"
      done

      pg "$constraints"
      ;;
    m*)
      mariadb -e 'DROP DATABASE IF EXISTS trdb; CREATE DATABASE trdb;'
      maria "$structure"

      maria_copy_template="LOAD DATA LOCAL INFILE '$PWD/name.csv' INTO TABLE name FIELDS TERMINATED BY ',' CSV HEADER"
      for f in *.csv; do
        maria "${maria_copy_template//name/${f%.csv}}"
      done

      maria "$constraints"
      ;;
  esac
}

postgresql() {
  pg "$(sed -n '/-- QUERY 1 ORIGINAL/,/-- QUERY 1 REWRITTEN/ p' queries_t3.sql | grep -v '^--')"
  pg "$(sed -n '/-- QUERY 1 REWRITTEN/,/-- QUERY 2 ORIGINAL/ p' queries_t3.sql | grep -v '^--')"
  pg "$(sed -n '/-- QUERY 2 ORIGINAL/,/-- QUERY 2 REWRITTEN/ p' queries_t3.sql | grep -v '^--')"
  pg "$(sed -n '/-- QUERY 2 REWRITTEN/,$ p' queries_t3.sql | grep -v '^--')"
}

mariadb() {
  # TODO: joseph pc :)
  maria "$(sed -n '/-- QUERY 1 ORIGINAL/,/-- QUERY 1 REWRITTEN/ p' queries_t3.sql | grep -v '^--')"
  maria "$(sed -n '/-- QUERY 1 REWRITTEN/,/-- QUERY 2 ORIGINAL/ p' queries_t3.sql | grep -v '^--')"
  maria "$(sed -n '/-- QUERY 2 ORIGINAL/,/-- QUERY 2 REWRITTEN/ p' queries_t3.sql | grep -v '^--')"
  maria "$(sed -n '/-- QUERY 2 REWRITTEN/,$ p' queries_t3.sql | grep -v '^--')"
}

run_test() {
  echo "Approach $1"
  cleanup "$1"
  echo "Running queries..."
  time "$1"
}

run_test postgresql
# run_test mariadb
