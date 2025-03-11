dropdb dblp
createdb dblp
psql -d dblp -f create.sql
time psql -d dblp -c "\copy publ from 'publ.tsv' delimiter E'\\t'"
time psql -d dblp -c "\copy auth from 'auth.tsv' delimiter E'\\t'"
