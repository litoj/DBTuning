DROP TABLE IF EXISTS Auth;
DROP TABLE IF EXISTS Publ;

CREATE TABLE Auth (
  name   VARCHAR(100),
  pubID  VARCHAR(129)
);

CREATE TABLE Publ (
  pubID     VARCHAR(129) PRIMARY KEY,
  type      VARCHAR(13),
  title     VARCHAR(700),
  booktitle VARCHAR(132),
  year      CHAR(4),
  publisher VARCHAR(196)
);
