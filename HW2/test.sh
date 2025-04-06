#!/bin/bash

pg() {
	psql -d trdb ${1+-c "$@"} || exit 1
}

md() {
	mariadb -t trdb ${1+-e "$@"} || exit 1
}

structure=$(sed '/ALTER/d;/CREATE.*INDEX/d' create.sql)
constraints=$(grep -e 'CREATE.*INDEX' -e 'ALTER' create.sql)

cleanup() {
	echo "Cleanup and prep of $1" >&2
	case $1 in
		p*)
			psql -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'trdb' AND pid <> pg_backend_pid();"
			dropdb trdb
			createdb trdb
			pg "$structure"

			psql_copy_template="\\copy name FROM 'name.csv' DELIMITER ',' CSV HEADER"
			for f in *.csv; do
				pg "${psql_copy_template//name/${f%.csv}}"
			done

			pg "$constraints"
			;;
		m*)
			mariadb -e 'DROP DATABASE IF EXISTS trdb; CREATE DATABASE trdb;'
			md "$structure"
			md "$constraints"

			maria_copy_template="LOAD DATA LOCAL INFILE '$PWD/name.csv' INTO TABLE name FIELDS TERMINATED BY ','"
			for f in *.csv; do
				md "${maria_copy_template//name/${f%.csv}}"
			done
			;;
	esac
	echo "Prep of $1 done" >&2
}

TEST=${TEST:-queries.sql}
qOrig1=$(sed -n '/-- QUERY 1 ORIGINAL/,/^$/ p' "$TEST")
qPerf1=$(sed -n '/-- QUERY 1 REWRITTEN/,/^$/ p' "$TEST")
qOrig2=$(sed -n '/-- QUERY 2 ORIGINAL/,/^$/ p' "$TEST")
qPerf2=$(sed -n '/-- QUERY 2 REWRITTEN/,$ p' "$TEST")

queries=(
	"$qOrig1"
	"$qPerf1"
	"$qOrig2"
	"$qPerf2"
)

run_test() {
	echo "# Test of $1"
	[[ $NO_CLEAN ]] || cleanup "$1"
	echo "**Running queries...**"
	for q in "${queries[@]}"; do
		printf '\n```sql\n%s\n```\n' "$q"
		if [[ $1 == maria* ]]; then
			md "ANALYZE $q"
		else
			pg "EXPLAIN ANALYZE $q"
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
