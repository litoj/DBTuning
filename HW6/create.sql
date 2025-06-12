DROP TABLE IF EXISTS Accounts;

CREATE TABLE Accounts (
  account INT PRIMARY KEY,
  balance INT
);

INSERT INTO Accounts VALUES (0,100);
INSERT INTO Accounts
  SELECT i, 0 FROM generate_series(1,100) AS i;
