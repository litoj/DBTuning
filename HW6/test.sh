#!/usr/bin/env bash
set -euo pipefail

# Name of the database (override with DATABASE=…)
DATABASE=${DATABASE:-payroll}

# Move to the script’s directory so relative paths work
cd "${0%/*}"

# Path to psql (if psql isn’t on your $PATH, uncomment & adjust)
# PG_BIN="/c/Program Files/PostgreSQL/17/bin"
# psql() { "$PG_BIN/psql.exe" "$@"; }

# Ensure the DB exists; if not, create it
ensure_db() {
  if ! psql -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$DATABASE'" | grep -q 1; then
    echo ">>> creating database '$DATABASE'…" >&2
    createdb "$DATABASE"
  fi
}

# Reset schema: drop & recreate Accounts table + load data
reset_schema() {
  echo ">>> resetting schema on '$DATABASE'…" >&2
  psql -d "$DATABASE" -f create.sql
  echo ">>> done." >&2
}

# Experiment configuration
VARIANTS=(a b)
ISOLATIONS=("READ COMMITTED" "SERIALIZABLE")
THREADS=(1 5)
NUMTX=100

# Main loop
for var in "${VARIANTS[@]}"; do
  for iso in "${ISOLATIONS[@]}"; do
    for t in "${THREADS[@]}"; do

      ensure_db
      reset_schema

      echo "=== variant=$var   isolation=$iso   threads=$t ==="
      python concurrenttransactions.py \
        --numthreads  $NUMTX \
        --maxconcurrent $t \
        --variant     $var \
        --isolation   "$iso"
      echo
    done
  done
done
