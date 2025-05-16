#!/bin/bash

DATABASE=${DATABASE:-trdb}

pg() {
	psql -d $DATABASE -c "$1" || exit 1
}

cleanup() {
	echo "Cleanup and prep started" >&2
	# psql -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity
	# 			WHERE datname = '$DATABASE' AND pid <> pg_backend_pid();"
	dropdb $DATABASE
	createdb $DATABASE
	psql -d $DATABASE -f create.sql
	echo "Prep done" >&2
}

SRC=${SRC:-queries.sql}
TESTS=()

while read line; do
	[[ $line == '-- '* ]] && TESTS+=("") # start a new query when a comment line is found
	TESTS[${#TESTS[@]} - 1]+="${line/;*/;}
" # should be multiple queries
done <"$SRC"

mapfile IDXS <idxs.sql

run_test() {
	[[ $CLEAN ]] && cleanup
	echo "

# Test of $1 idx"
	psql -d $DATABASE -c "DROP INDEX IF EXISTS idx_publ;" &>/dev/null
	pg "$2" >/dev/null

	for q in "${TESTS[@]}"; do
		q=${q%;*}
		printf '\n```sql%s\n```\n' "${q##*;}"
		pg "EXPLAIN ANALYZE ${q##*;}" | tail -n +3

		declare -i i=${SAMPLE:=100}+1
		IFS=';' read -ra queries <<<"$q"

		start=$(date +%s%N)
		while ((--i)); do
			pg "${queries[i % ${#queries[@]}]};" >/dev/null
		done
		((took = ($(date +%s%N) - start) / 1000000))

		echo "**$SAMPLE runs, $((took / SAMPLE)) ms/run → $((SAMPLE * 1000 / took)) runs/s**"
	done
}

if [[ $1 ]]; then
	[[ $CLEAN ]] && cleanup "$1"
	"$@"
else
	run_test 'clustering B+-tree' "${IDXS[0]}"
	run_test 'B+-tree' "${IDXS[1]}"
	run_test 'hash' "${IDXS[2]}"
	run_test 'no' "${IDXS[3]}"
fi
