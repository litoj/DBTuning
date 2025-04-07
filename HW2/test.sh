#!/bin/bash

DATABASE=${DATABASE:-trdb}

pg() {
	psql -d $DATABASE ${1+-c "$@"} || exit 1
}

md() {
	mariadb -t $DATABASE ${1+-e "$@"} || exit 1
}

structure=$(sed '/ALTER/d;/CREATE.*INDEX/d' create.sql)
constraints=$(grep -e 'CREATE.*INDEX' -e 'ALTER' create.sql)

cleanup() {
	echo "Cleanup and prep of $1" >&2
	case $1 in
		p*)
			psql -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity
				WHERE datname = '$DATABASE' AND pid <> pg_backend_pid();"
			dropdb $DATABASE
			createdb $DATABASE
			pg "$structure"

			psql_copy_template="\\copy name FROM 'name.csv' DELIMITER ',' CSV HEADER"
			for f in *.csv; do
				pg "${psql_copy_template//name/${f%.csv}}"
			done

			pg "$constraints"
			;;
		m*)
			mariadb -e "DROP DATABASE IF EXISTS $DATABASE; CREATE DATABASE $DATABASE;"
			md "$structure"

			maria_copy_template="LOAD DATA LOCAL INFILE '$PWD/name.csv' INTO TABLE name FIELDS TERMINATED BY ',' IGNORE 1 LINES"
			for f in *.csv; do
				md "${maria_copy_template//name/${f%.csv}}"
			done
			# mariadb loads empty fields as default type value instead of default column value (NULL)
			md "UPDATE employee SET manager=NULL WHERE manager=0"
			md "UPDATE employee SET dept=NULL WHERE dept=''"

			md "$constraints"
			;;
	esac
	echo "Prep of $1 done" >&2
}

TEST=${TEST:-queries.sql}
qOrig1=$(sed -n '/-- QUERY 1 ORIGINAL/,/^$/ p' "$TEST")
qPerf1=$(sed -n '/-- QUERY 1 REWRITTEN/,/^$/ p' "$TEST")
qOrig2=$(sed -n '/-- QUERY 2 ORIGINAL/,/^$/ p' "$TEST")
qPerf2=$(sed -n '/-- QUERY 2 REWRITTEN/,$ p' "$TEST")

[[ $QUERIES ]] || QUERIES=(
	"$qOrig1"
	"$qPerf1"
	"$qOrig2"
	"$qPerf2"
)

run_test() {
	echo "# Test of $1"
	[[ $NO_CLEAN ]] || cleanup "$1"
	echo "**Running queries...**"
	for q in "${QUERIES[@]}"; do
		printf '\n```sql\n%s\n```\n' "$q"
		if [[ $1 == maria* ]]; then
			time md "EXPLAIN $q"
		else
			time pg "EXPLAIN ANALYZE $q"
		fi
	done
}

if [[ $@ ]]; then
	if [[ $* =~ ^(maria|postgres)( maria| postgres)?$ ]]; then
		for arg in "$@"; do run_test "$arg"; done
	else
		[[ $CLEAN ]] && cleanup "$1"
		"$@"
	fi
else
	run_test postgres
	run_test maria
fi
