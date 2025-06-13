#!/bin/bash

DATABASE=${DATABASE:-payroll}

[[ $0 == */* ]] && cd "${0%/*}"

pg() {
	echo "$1" >&2
	psql -d $DATABASE -c "$@"
}

QUERIES=(a b)
STRATEGIES=("READ COMMITTED" "SERIALIZABLE")
SAMPLE=${SAMPLE:-10}
MAX_THREADS=${MAX_THREADS:-5}
export EMPLOYEES=${EMPLOYEES:-100}

resetSQL=$(<reset.sql)
resetSQL="${resetSQL//100/$EMPLOYEES}"
createSQL=$(<create.sql)
createSQL="${createSQL//100/$EMPLOYEES}"
cleanup() {
	{
		echo "Cleanup and prep started"
		dropdb $DATABASE
		createdb $DATABASE
		pg "$createSQL"
		echo "Prep done"
	} >&2
}

run_test() {
	declare -i i=$SAMPLE+1 total_time=0 total_balance=0
	while ((--i)); do
		pg "$resetSQL" &>/dev/null

		data=($(python concurrenttransactions.py)) # time; final balance
		((total_time += data[0]))
		((total_balance += data[1]))
	done

	((perRun = total_time / SAMPLE)) # avg µs
	((trPerS = EMPLOYEES * SAMPLE * 1000000 / total_time))
	((avgBalance = total_balance / SAMPLE))
	((avgBalanceErr = (EMPLOYEES - avgBalance) * 100 / EMPLOYEES))
	echo "I=${strat}; T=${t}; V=${q}: ${trPerS} tr/s, $((perRun / 1000)).$(((perRun % 1000) / 100)) ms/run, correct=${avgBalanceErr}%"
}

cleanup &>/dev/null

if [[ $1 ]]; then
	pg "$@"
else
	echo "Runs per test: $SAMPLE"
	for q in "${QUERIES[@]}"; do
		export VARIANT="$q"
		for strat in "${STRATEGIES[@]}"; do
			export STRATEGY="$strat"
			strat=${strat#* }
			strat=${strat::6}
			declare -i t=$MAX_THREADS+1
			while ((--t)); do
				export THREADS="$t"
				run_test
			done
		done
	done
fi
