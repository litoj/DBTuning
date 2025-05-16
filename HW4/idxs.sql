CREATE INDEX idx_publ ON publ(pubID); CLUSTER publ USING idx_publ;
CREATE INDEX idx_publ ON publ(pubID);
CREATE INDEX idx_publ ON publ USING HASH (pubID);
SELECT true;
