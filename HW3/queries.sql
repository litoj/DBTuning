-- Covering index beneficial for low row count
EXPLAIN ANALYZE SELECT name FROM employee
	WHERE dept IS NULL AND salary > 149000 OR dept IS NOT NULL AND salary > 149000;
EXPLAIN ANALYZE SELECT name FROM employee WHERE salary > 149000;

EXPLAIN ANALYZE SELECT name FROM employee
	WHERE dept IS NULL AND salary > 6000 OR dept IS NOT NULL AND salary > 6000;
EXPLAIN ANALYZE SELECT name FROM employee WHERE salary > 60000;

-- Covering index on multi-column prefix queries
DROP INDEX idx_dept_salary; -- extreme difference for low #results
EXPLAIN ANALYZE SELECT name FROM employee WHERE dept = 'TechDept1' AND salary > 149000;
CREATE INDEX idx_dept_salary ON employee (dept, salary);
EXPLAIN ANALYZE SELECT name FROM employee WHERE dept = 'TechDept1' AND salary > 149000;

DROP INDEX idx_dept_salary; -- at minimum 2x faster than no index
EXPLAIN ANALYZE SELECT name FROM employee WHERE dept IS NULL AND salary > 80000;
CREATE INDEX idx_dept_salary ON employee (dept, salary);
EXPLAIN ANALYZE SELECT name FROM employee WHERE dept IS NULL AND salary > 80000;

DROP INDEX idx_dept_salary; -- performance degradation with higher #results is lower than no idx
EXPLAIN ANALYZE SELECT name FROM employee WHERE dept IS NULL AND salary > 50000;
CREATE INDEX idx_dept_salary ON employee (dept, salary);
EXPLAIN ANALYZE SELECT name FROM employee WHERE dept IS NULL AND salary > 50000;


-- (drop and recreate idx_name to avoid duplicate error)
DROP INDEX IF EXISTS idx_name;
CREATE INDEX idx_name ON employee(name);
-- recreate ssnum index before re-clustering
CREATE INDEX IF NOT EXISTS idx_ssnum ON employee(ssnum);

-- clustering on non-key attribute (name)
CREATE INDEX idx_name ON employee(name);
CLUSTER employee USING idx_name;

-- performance of LIKE prefix scan after clustering
EXPLAIN ANALYZE SELECT * FROM employee WHERE name LIKE 'A%';