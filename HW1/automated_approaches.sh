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

sql_copy_publ="\copy publ from 'dblp/publ.tsv' delimiter E'\\t'"
sql_copy_auth="\copy auth from 'dblp/auth.tsv' delimiter E'\\t'"

# Approach 1: Constraints First
constraints_first() {
	psql -d dblp -f 'create2.sql'
	psql -d dblp -c "$sql_copy_publ"
	psql -d dblp -c "$sql_copy_auth"
}

# Approach 2: Constraints Last (Structure → Data → Constraints)
structure_data_constraints() {
	structure=$(sed '/ALTER/d' create1.sql)
	constraints=$(grep 'ALTER' create1.sql)

	psql -d dblp -c "$structure"
	psql -d dblp -c "$sql_copy_publ"
	psql -d dblp -c "$sql_copy_auth"
	psql -d dblp -c "$constraints"
}


# Additional approaches we didn't try:

create_populate() {
	psql -d dblp -f 'create.sql'
	psql -d dblp -c "$sql_copy_publ"
	psql -d dblp -c "$sql_copy_auth"
}

minimal_preparation() {
	psql -d dblp -c "${structure//NOT NULL/}"
	psql -d dblp -c "$sql_copy_publ"
	psql -d dblp -c "$sql_copy_auth"
	psql -d dblp -c "$(echo "$structure" | sed -n 's/CREATE \(TABLE .*\) (/ALTER \1/p;s/\s*\(\S\+\) .* \(NOT NULL\)/ALTER COLUMN \1 SET \2/p;s/);/;/p' )"
	psql -d dblp -c "$constraints"
}


# Run both approaches for comparison
run_test constraints_first
run_test structure_data_constraints

