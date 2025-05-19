CREATE TABLE Publ (
  pubID VARCHAR(129) NOT NULL,
	type VARCHAR(13) NOT NULL,
	title VARCHAR(700) NOT NULL,
	booktitle VARCHAR(132),
	year VARCHAR(4),
	publisher VARCHAR(196)
);
\copy publ FROM '../HW1/publ.tsv' delimiter E'\t' csv NULL AS '';
ALTER TABLE Publ ADD CONSTRAINT pk_publ PRIMARY KEY (pubID);
