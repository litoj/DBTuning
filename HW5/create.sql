CREATE TABLE Publ (
  pubID VARCHAR(129) NOT NULL,
	type VARCHAR(13) NOT NULL,
	title VARCHAR(700) NOT NULL,
	booktitle VARCHAR(132),
	year VARCHAR(4),
	publisher VARCHAR(196)
);
\copy publ FROM '../HW1/publ.tsv' delimiter E'\t' csv NULL AS '';

CREATE TABLE Auth (
	name VARCHAR(49) NOT NULL,
  pubID VARCHAR(129) NOT NULL
);
\copy auth FROM '../HW1/auth.tsv' delimiter E'\t' csv;

-- ALTER TABLE Auth ADD CONSTRAINT fk_auth_publ FOREIGN KEY (pubID) REFERENCES Publ (pubID) ON DELETE CASCADE;
