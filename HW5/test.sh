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
	LANG=C pg "EXPLAIN ANALYZE $1" | sed -n 's/.* Time: \(.*\) ms/\1/p' | awk 'BEGIN{x=0};{x+=$1};END{print int(x*1000)}'
}

mapfile STRATEGIES <./strategizer.sql

run_test() {
	for q in "${QUERIES[@]}"; do
		echo "$q" | sed -n 's/^--/\n####/p'
		q="$(echo "$q" | sed '1d')"

		LANG=C pg "EXPLAIN ANALYZE $q" | tail -n +3 | head -n -2

		declare -i i=$SAMPLE+1 total=0
		while ((--i)); do
			((total += $(measure "$q")))
		done

		((perRun = total / SAMPLE)) # µs
		((perS = SAMPLE * 1000000 / total))
		echo "**$SAMPLE runs, $((perRun / 1000)).$(((perRun % 1000) / 100)) ms/run**"
	done
}

[[ $CLEAN ]] && cleanup

if [[ $1 ]]; then
	"$@"
else
	SAMPLE=${SAMPLE:-50}

	for strat in "${STRATEGIES[@]}"; do
		echo "## ${strat##*-- }"
		pg "${strat//SET/ALTER DATABASE $DATABASE SET}" >/dev/null || exit 1
		strat=${strat#*-- }

		for i in ${strat%--*}; do # use indexes selected in the strategy comments as a list of numbers
			idx=${IDXS[$i]}
			pg "DROP INDEX IF EXISTS idx_publ; DROP INDEX IF EXISTS idx_auth;" &>/dev/null
			echo "### ${idx##*-- }"
			[[ $strat == 'SET enable_hashjoin TO true'* ]] && idx=${idx//btree/hash}
			pg "RESET ALL; ${idx%;*}; ANALYZE publ; ANALYZE auth;" >/dev/null || exit 1

			run_test
		done
	done
fi
