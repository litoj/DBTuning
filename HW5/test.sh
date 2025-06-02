#!/bin/bash

DATABASE=${DATABASE:-trdb}

[[ $0 == */* ]] && cd "${0%/*}"

pg() {
	psql -d $DATABASE -c "$@"
}

cleanup() {
	echo "Cleanup and prep started" >&2
	dropdb $DATABASE
	createdb $DATABASE
	psql -d $DATABASE -f create.sql
	echo "Prep done" >&2
}

SRC=${SRC:-queries.sql}
QUERIES=()

while read line; do
	[[ $line == '-- '* ]] && QUERIES+=("") # start a new query when a comment line is found
	QUERIES[${#QUERIES[@]} - 1]+="${line/;*/;}
" # can be multiple queries per block
done <"$SRC"

mapfile IDXS <idxs.sql

measure() {
	LANG=C pg "EXPLAIN ANALYZE $1" | sed -n 's/.* Time: \(.*\) ms/\1/p' | awk 'BEGIN{x=0};{x+=$1};END{print x*1000}'
}

mapfile STRATEGIES <./strategizer.sql

run_test() {
	for q in "${QUERIES[@]}"; do
		echo "$q" | sed -n 's/^--/####/p'
		q="$(echo "$q" | sed '1d')"

		pg "EXPLAIN ANALYZE $q" | tail -n +3

		declare -i i=$SAMPLE+1 total=0
		while ((--i)); do
			measured=$(measure "$q")
			[[ $measured == .* ]] && measured=0
			((total += measured))
		done

		((perRun = total / SAMPLE)) # µs
		((perS = SAMPLE * 1000000 / total))
		echo "**$SAMPLE runs, $((perRun / 1000)).$(((perRun % 1000) / 100)) ms/run → $perS runs/s**"
	done
}

[[ $CLEAN ]] && cleanup

if [[ $1 ]]; then
	"$@"
else
	SAMPLE=${SAMPLE:-100}

	# Part 1
	echo "# Default strategy testing"
	pg "${STRATEGIES[0]//false/true}"
	for idx in "${IDXS[@]::3}"; do # first 3 lines are for default strat testing
		pg "DROP INDEX IF EXISTS idx_publ; DROP INDEX IF EXISTS idx_auth;" &>/dev/null
		echo "### ${idx##*-- }"
		pg "RESET ALL; ${idx%;*}; ANALYZE publ; ANALYZE auth;" >/dev/null

		run_test
	done

	# Part 2
	echo "# Strategy performance testing"
	for strat in "${STRATEGIES[@]}"; do
		echo "## ${strat##*-- }"
		pg "$strat"

		for idx in "${IDXS[@]:4}"; do # skip empty line separating part 1 indices and part 2 indices
			pg "DROP INDEX IF EXISTS idx_publ; DROP INDEX IF EXISTS idx_auth;" &>/dev/null
			echo "### ${idx##*-- }"
			[[ $strat == *'hashjoin TO true'* ]] && idx=${idx//btree/hash}
			pg "RESET ALL; ${idx%;*}; ANALYZE publ; ANALYZE auth;" >/dev/null

			run_test
		done
	done
fi
