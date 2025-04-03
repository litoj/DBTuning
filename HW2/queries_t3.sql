-- === Query 1: Full table scan vs index on salary ===

-- QUERY 1 ORIGINAL
EXPLAIN ANALYZE
SELECT name, salary
FROM employee
ORDER BY salary DESC;

-- QUERY 1 REWRITTEN
CREATE INDEX IF NOT EXISTS emp_salary_desc_idx ON employee(salary DESC);

EXPLAIN ANALYZE
SELECT name, salary
FROM employee
ORDER BY salary DESC;

-- === Query 2: Anti join NOT IN vs LEFT JOIN IS NULL ===

-- QUERY 2 ORIGINAL
EXPLAIN ANALYZE
SELECT e.name
FROM employee e
WHERE dept NOT IN (
  SELECT dept FROM techdept
);

-- QUERY 2 REWRITTEN
EXPLAIN ANALYZE
SELECT e.name
FROM employee e
LEFT JOIN techdept t ON e.dept = t.dept
WHERE t.dept IS NULL;
