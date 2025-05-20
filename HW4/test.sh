#!/bin/bash

DATABASE=${DATABASE:-trdb}

pg() {
	psql -d $DATABASE -c "$@" || exit 1
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

measure() {
	bc <<<"$(LANG=C pg "\timing on" -c "$@" | sed -n 's/^Time: \(.*\) ms/\1/p')*1000" | cut -d. -f1
}

run_test() {
	[[ $CLEAN ]] && cleanup
	echo "

# Test of $1 idx"

	for q in "${TESTS[@]}"; do
		q=${q%;*}
		attr=${q#*WHERE }
		attr=${attr/ */}

		psql -d $DATABASE -c "DROP INDEX IF EXISTS idx_publ" &>/dev/null
		pg "${2/attr/$attr}" >/dev/null
		pg "ANALYZE publ" >/dev/null

		printf '\n%s\n\n```sql%s\n```\n' "$(echo "$q" | sed -n 's/^--/##/p')" "${q##*;}"
		pg "EXPLAIN ANALYZE ${q##*;}" | tail -n +3

		declare -i i=$SAMPLE+1 total=0
		IFS=';' read -ra queries <<<"$q"

		while ((--i)); do
			((total += $(measure "${queries[i % ${#queries[@]}]}")))
		done

		((perRun = total / SAMPLE)) # µs
		((perS = SAMPLE * 1000000 / total))
		echo "**$SAMPLE runs, $((perRun / 1000)).$(((perRun % 1000) / 100)) ms/run → $perS runs/s**"
	done
}

if [[ $1 ]]; then
	"$@"
else
	SAMPLE=${SAMPLE:-100}
	run_test 'clustering B+-tree' "${IDXS[0]}"
	run_test 'B+-tree' "${IDXS[1]}"
	run_test 'hash' "${IDXS[2]}"
	run_test 'no' "${IDXS[3]}"
fi
