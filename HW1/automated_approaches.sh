#!/bin/bash

cleanup() {
	dropdb dblp
	createdb dblp
}

format_md_result() {
	echo time "$@"
}

run_test() {
	echo "Approach ${1//_/ → }"

	cleanup

	if [[ $DETAILED ]]; then
		echo "Individual:"
		while read -r cmd; do # time each command separately
			echo "- $cmd"
			eval "args=(${cmd%;})"
			time "${args[@]}"
		done < <(declare -f "$1" | tail -n +3 | head -n -1) # extract the commands inside the function

		cleanup
	fi

	echo "Summary:"
	time "$1" # time the entire procedure as a single unit of work
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

minimal_preparation() {
	psql -d dblp -c "${structure//NOT NULL/}"
	psql -d dblp -c "$sql_copy_publ"
	psql -d dblp -c "$sql_copy_auth"
	psql -d dblp -c "$(echo "$structure" | sed -n 's/CREATE \(TABLE .*\) (/ALTER \1/p;s/\s*\(\S\+\) .* \(NOT NULL\)/ALTER COLUMN \1 SET \2/p;s/);/;/p' )"
	psql -d dblp -c "$constraints"
}

run_test create_populate

run_test structure_data_constraints

# run_test minimal_preparation # no difference - sometimes actually slower
