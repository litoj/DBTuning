CREATE INDEX idx_publ ON publ(attr); CLUSTER publ USING idx_publ;
CREATE INDEX idx_publ ON publ(title); CLUSTER publ USING idx_publ; DROP INDEX idx_publ; CREATE INDEX idx_publ ON publ(attr);
CREATE INDEX idx_publ ON publ USING HASH (attr);
SELECT true;
