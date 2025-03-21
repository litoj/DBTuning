-- Create the "publ" table with constraints in place before data import
CREATE TABLE publ (
    pubID VARCHAR(129) PRIMARY KEY,
    type VARCHAR(13),
    title VARCHAR(700),
    booktitle VARCHAR(132),
    year VARCHAR(4),
    publisher VARCHAR(196)
);

-- Create the "auth" table with constraints in place before data import
CREATE TABLE auth (
    name VARCHAR(49),
    pubID VARCHAR(129) REFERENCES publ(pubID) ON DELETE CASCADE
);
