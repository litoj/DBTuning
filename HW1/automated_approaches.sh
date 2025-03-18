#!/bin/bash

cleanup() {
	dropdb dblp
	createdb dblp
}

format_md_result() {
	echo '```'
	time "$@"
	echo '```'
}

run_test() {
	echo "## Approach _${1//_/ → }_"

	cleanup

	if [[ $DETAILED ]]; then
		echo "### Individual"
		while read -r cmd; do # time each command separately
			echo "- $cmd"
			eval "args=(${cmd%;})"
			format_md_result "${args[@]}"
		done < <(declare -f "$1" | tail -n +3 | head -n -1) # extract the commands inside the function

		cleanup
	fi

	echo "### Summary"
	format_md_result "$1" # time the entire procedure as a single unit of work
}

structure=$(sed '/ALTER/d' create.sql)
constraints=$(grep 'ALTER' create.sql)
sql_copy_publ="\copy publ from 'publ.tsv' delimiter E'\\t'"
sql_copy_auth="\copy auth from 'auth.tsv' delimiter E'\\t'"

create_populate() {
	psql -d dblp -f 'create.sql'
	psql -d dblp -c "$sql_copy_publ"
	psql -d dblp -c "$sql_copy_auth"
}

structure_data_constraints() {
	psql -d dblp -c "$structure"
	psql -d dblp -c "$sql_copy_publ"
	psql -d dblp -c "$sql_copy_auth"
	psql -d dblp -c "$constraints"
}

run_test create_populate

run_test structure_data_constraints
