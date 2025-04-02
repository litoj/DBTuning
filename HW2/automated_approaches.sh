#!/bin/bash

pg() {
	psql -d trdb -c "$@"
}
maria() {
	mariadb -D trdb -e "$@"
}

structure=$(sed '/ALTER/d;/CREATE.*INDEX/d' create.sql)
constraints=$(grep -e 'CREATE.*INDEX' -e 'ALTER' create.sql)

cleanup() {
	case $1 in
		p*)
			dropdb trdb
			createdb trdb
			pg "$structure"

			psql_copy_template="\copy name FROM 'name.csv' DELIMITER ',' CSV HEADER"
			for f in *.csv; do
				pg "${psql_copy_template//name/${f%.csv}}"
			done

			pg "$constraints"
			;;
		m*)
			mariadb -e 'drop database if exists trdb; create database trdb'
			maria -e "$structure"

			maria_copy_template="LOAD DATA LOCAL INFILE '$PWD/name.csv' INTO TABLE name FIELDS TERMINATED BY ',' HEADER"
			for f in *.csv; do
				maria "${maria_copy_template//name/${f%.csv}}"
			done

			maria "$constraints"
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

postgresql() {
:	# pg "cmd"
}

mariadb() {
:	# maria "cmd"
}

run_test postgresql
run_test mariadb
