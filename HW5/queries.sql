-- Q1: Default join choices, no Auth index
DROP INDEX IF EXISTS idx_auth_pubid;
ANALYZE Auth;
ANALYZE Publ;

-- Baseline join (no filter)
EXPLAIN ANALYZE
SELECT a.name, p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID;

-- Baseline join (with filter)
EXPLAIN ANALYZE
SELECT p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID
 WHERE a.name = 'Divesh Srivastava';


-- Q1: Unique index on Publ.pubID (already PK)
ANALYZE Auth;
ANALYZE Publ;

-- Join using Publ PK
EXPLAIN ANALYZE
SELECT a.name, p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID;

-- Join with filter using Publ PK
EXPLAIN ANALYZE
SELECT p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID
 WHERE a.name = 'Divesh Srivastava';


-- Q1: Clustering both tables on pubID
DROP INDEX IF EXISTS idx_auth_pubid;
CREATE INDEX idx_auth_pubid ON Auth(pubID);
ANALYZE Auth;

CLUSTER Publ USING Publ_pkey;
CLUSTER Auth USING idx_auth_pubid;
ANALYZE Publ;
ANALYZE Auth;

-- Join after clustering
EXPLAIN ANALYZE
SELECT a.name, p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID;

-- Join with filter after clustering
EXPLAIN ANALYZE
SELECT p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID
 WHERE a.name = 'Divesh Srivastava';

-- Q2a: Indexed NL, only Publ indexed
DROP INDEX IF EXISTS idx_auth_pubid;
ANALYZE Auth;
ANALYZE Publ;

SET enable_hashjoin  = false;
SET enable_mergejoin = false;
SET enable_nestloop  = true;

-- Nested loop (Publ indexed)
EXPLAIN ANALYZE
SELECT a.name, p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID;

-- Nested loop with filter (Publ indexed)
EXPLAIN ANALYZE
SELECT p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID
 WHERE a.name = 'Divesh Srivastava';

RESET ALL;


-- Q2b: Indexed NL, only Auth indexed
CREATE INDEX IF NOT EXISTS idx_auth_pubid ON Auth(pubID);
ANALYZE Auth;
ANALYZE Publ;

SET enable_hashjoin  = false;
SET enable_mergejoin = false;
SET enable_nestloop  = true;

-- Nested loop (Auth indexed)
EXPLAIN ANALYZE
SELECT a.name, p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID;

-- Nested loop with filter (Auth indexed)
EXPLAIN ANALYZE
SELECT p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID
 WHERE a.name = 'Divesh Srivastava';

RESET ALL;


-- Q2c: Indexed NL, both sides indexed
ANALYZE Auth;
ANALYZE Publ;

SET enable_hashjoin  = false;
SET enable_mergejoin = false;
SET enable_nestloop  = true;

-- Nested loop (both indexed)
EXPLAIN ANALYZE
SELECT a.name, p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID;

-- Nested loop with filter (both indexed)
EXPLAIN ANALYZE
SELECT p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID
 WHERE a.name = 'Divesh Srivastava';

RESET ALL;


-- Q3a: Merge join, no Auth index
DROP INDEX IF EXISTS idx_auth_pubid;
ANALYZE Auth;
ANALYZE Publ;

SET enable_hashjoin  = false;
SET enable_nestloop  = false;
SET enable_mergejoin = true;

-- Merge join (no indexes)
EXPLAIN ANALYZE
SELECT a.name, p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID;

-- Merge join with filter (no indexes)
EXPLAIN ANALYZE
SELECT p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID
 WHERE a.name = 'Divesh Srivastava';

RESET ALL;


-- Q3b: Merge join, two non-clustering indexes
CREATE INDEX IF NOT EXISTS idx_auth_pubid ON Auth(pubID);
ANALYZE Auth;
ANALYZE Publ;

SET enable_hashjoin  = false;
SET enable_nestloop  = false;
SET enable_mergejoin = true;

-- Merge join (two non-clustered)
EXPLAIN ANALYZE
SELECT a.name, p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID;

-- Merge join with filter (two non-clustered)
EXPLAIN ANALYZE
SELECT p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID
 WHERE a.name = 'Divesh Srivastava';

RESET ALL;


-- Q3c: Merge join, two clustering indexes
CLUSTER Auth USING idx_auth_pubid;
CLUSTER Publ USING Publ_pkey;
ANALYZE Auth;
ANALYZE Publ;

SET enable_hashjoin  = false;
SET enable_nestloop  = false;
SET enable_mergejoin = true;

-- Merge join (clustered)
EXPLAIN ANALYZE
SELECT a.name, p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID;

-- Merge join with filter (clustered)
EXPLAIN ANALYZE
SELECT p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID
 WHERE a.name = 'Divesh Srivastava';

RESET ALL;


-- Q4: Hash join (no Auth index)
DROP INDEX IF EXISTS idx_auth_pubid;
ANALYZE Auth;
ANALYZE Publ;

SET enable_mergejoin = false;
SET enable_nestloop  = false;
SET enable_hashjoin  = true;

-- Hash join (no indexes)
EXPLAIN ANALYZE
SELECT a.name, p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID;

-- Hash join with filter (no indexes)
EXPLAIN ANALYZE
SELECT p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID
 WHERE a.name = 'Divesh Srivastava';

RESET ALL;
