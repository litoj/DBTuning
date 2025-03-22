#!/bin/bash

cleanup() {
	case $1 in
		postgresql_*)
			dropdb dblp
			createdb dblp
			;;
		mariadb_*)
			mariadb -e 'drop database if exists trdb; create database trdb'
			;;
	esac
}

run_test() {
	echo "Approach ${1}"

	cleanup "$1"

	if [[ $DETAILED ]]; then
		echo "Individual:"
		while read -r cmd; do # time each command separately
			echo "- $cmd"
			time eval $cmd &>/dev/null
		done < <(declare -f "$1" | tail -n +3 | head -n -1) # extract the commands inside the function

		cleanup "$1"
	fi

	echo "Summary:"
	time "$1" # time the entire procedure as a single unit of work
}

structure=$(sed '/ALTER/d' create.sql)
constraints=$(grep 'ALTER' create.sql)

sql_copy_publ="\copy publ from 'publ.tsv' delimiter E'\\t'"
sql_copy_auth="\copy auth from 'auth.tsv' delimiter E'\\t'"

maria_copy_publ="LOAD DATA LOCAL INFILE '$PWD/publ.tsv' INTO TABLE Publ FIELDS TERMINATED BY '\t'"
maria_copy_auth="LOAD DATA LOCAL INFILE '$PWD/auth.tsv' INTO TABLE Auth FIELDS TERMINATED BY '\t'"

postgresql_create_populate() {
	psql -d dblp -f 'create.sql'
	psql -d dblp -c "$sql_copy_publ"
	psql -d dblp -c "$sql_copy_auth"
}

postgresql_defer_constraints() {
	psql -d dblp -c "$structure"
	psql -d dblp -c "$sql_copy_publ"
	psql -d dblp -c "$sql_copy_auth"
	psql -d dblp -c "$constraints"
}

mariadb_create_populate() {
	mariadb -D trdb <'create.sql'
	mariadb -D trdb -e "$maria_copy_publ"
	mariadb -D trdb -e "$maria_copy_auth"
}

mariadb_defer_constraints() {
	mariadb -D trdb -e "$structure"
	mariadb -D trdb -e "$maria_copy_publ"
	mariadb -D trdb -e "$maria_copy_auth"
	mariadb -D trdb -e "$constraints"
}

run_test postgresql_create_populate
run_test mariadb_create_populate
run_test postgresql_defer_constraints
run_test mariadb_defer_constraints
