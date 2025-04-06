-- === Query 1: Full table scan vs index on salary ===

-- QUERY 1 ORIGINAL
SELECT e.name
FROM employee e
WHERE e.salary = (
  SELECT MAX(salary)
  FROM employee
  WHERE dept = e.dept
);

-- QUERY 1 REWRITTEN
SELECT e.name
FROM employee e
JOIN (
  SELECT dept, MAX(salary) AS salary
  FROM employee
  GROUP BY dept
) dms USING (dept, salary);

-- === Query 2: Anti join NOT IN vs LEFT JOIN IS NULL ===

-- QUERY 2 ORIGINAL
SELECT e.name
FROM employee e
WHERE COALESCE(dept, '') NOT IN (
  SELECT dept FROM techdept
);

-- QUERY 2 REWRITTEN
SELECT e.name
FROM employee e
LEFT JOIN techdept t ON e.dept = t.dept
WHERE t.dept IS NULL;
