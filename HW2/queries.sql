-- Query 1: Employees earning above the average salary in their department

-- Original Query 1 (Correlated Subquery)
EXPLAIN (ANALYZE, BUFFERS)
SELECT e.name
FROM employee e
WHERE e.salary > (
  SELECT AVG(e2.salary)
  FROM employee e2
  WHERE e2.dept = e.dept
);

-- Rewritten Query 1 (WITH + JOIN)
EXPLAIN (ANALYZE, BUFFERS)
WITH dept_avg AS (
  SELECT dept, AVG(salary) AS avg_salary
  FROM employee
  GROUP BY dept
)
SELECT e.name
FROM employee e
JOIN dept_avg d ON e.dept = d.dept
WHERE e.salary > d.avg_salary;


-- Query 2: Students who are also employees with more than 50 friends

-- Original Query 2 (IN)
EXPLAIN (ANALYZE, BUFFERS)
SELECT s.name
FROM student s
WHERE s.ssnum IN (
  SELECT e.ssnum
  FROM employee e
  WHERE e.numfriends > 50
);

-- Rewritten Query 2 (JOIN)
EXPLAIN (ANALYZE, BUFFERS)
SELECT s.name
FROM student s
JOIN employee e ON s.ssnum = e.ssnum
WHERE e.numfriends > 50;
