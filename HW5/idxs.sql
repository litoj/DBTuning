SELECT true; -- No index
CREATE UNIQUE INDEX idx_publ ON publ(pubID); -- Unique index
CREATE INDEX idx_publ ON publ(pubID); CLUSTER publ USING idx_publ; CREATE INDEX idx_auth ON auth(pubID); CLUSTER auth USING idx_auth; -- Clustering index on both tables
CREATE INDEX idx_publ ON publ USING btree (pubID); -- Non-clustering index on Publ
CREATE INDEX idx_auth ON auth USING btree (pubID); -- Non-clustering index on Auth
CREATE INDEX idx_publ ON publ USING btree (pubID); CREATE INDEX idx_auth ON auth USING btree (pubID);  -- Non-clustering index on both tables
