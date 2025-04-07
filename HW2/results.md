# Test of postgres
**Running queries...**

```sql
-- QUERY 1 ORIGINAL
SELECT e.name
FROM employee e
WHERE e.salary = (
  SELECT MAX(salary)
  FROM employee
  WHERE dept = e.dept
);
```
                                                                    QUERY PLAN                                                                    
--------------------------------------------------------------------------------------------------------------------------------------------------
 Seq Scan on employee e  (cost=0.00..97315650.79 rows=500 width=14) (actual time=319.835..3587.334 rows=10 loops=1)
   Filter: (salary = (SubPlan 1))
   Rows Removed by Filter: 99990
   SubPlan 1
     ->  Aggregate  (cost=973.12..973.13 rows=1 width=32) (actual time=0.034..0.034 rows=1 loops=100000)
           ->  Bitmap Heap Scan on employee  (cost=12.10..970.61 rows=1007 width=8) (actual time=0.007..0.028 rows=99 loops=100000)
                 Recheck Cond: ((dept)::text = (e.dept)::text)
                 Heap Blocks: exact=5929368
                 ->  Bitmap Index Scan on employee_dept_idx  (cost=0.00..11.84 rows=1007 width=0) (actual time=0.003..0.003 rows=99 loops=100000)
                       Index Cond: ((dept)::text = (e.dept)::text)
 Planning Time: 5.236 ms
 JIT:
   Functions: 12
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 1.072 ms (Deform 0.524 ms), Inlining 66.564 ms, Optimization 38.611 ms, Emission 25.780 ms, Total 132.027 ms
 Execution Time: 3612.880 ms
(16 řádek)

real    0m3,659s
user    0m0,001s
sys     0m0,003s

```sql
-- QUERY 1 REWRITTEN
SELECT e.name
FROM employee e
JOIN (
  SELECT dept, MAX(salary) AS salary
  FROM employee
  GROUP BY dept
) dms USING (dept, salary);
```
                                                            QUERY PLAN                                                            
----------------------------------------------------------------------------------------------------------------------------------
 Hash Join  (cost=2404.25..4833.25 rows=1 width=14) (actual time=22.236..32.427 rows=10 loops=1)
   Hash Cond: (((e.dept)::text = (employee.dept)::text) AND (e.salary = (max(employee.salary))))
   ->  Seq Scan on employee e  (cost=0.00..1904.00 rows=100000 width=32) (actual time=0.004..4.720 rows=100000 loops=1)
   ->  Hash  (cost=2404.10..2404.10 rows=10 width=42) (actual time=21.932..21.933 rows=10 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 9kB
         ->  HashAggregate  (cost=2404.00..2404.10 rows=10 width=42) (actual time=21.919..21.921 rows=11 loops=1)
               Group Key: employee.dept
               Batches: 1  Memory Usage: 24kB
               ->  Seq Scan on employee  (cost=0.00..1904.00 rows=100000 width=18) (actual time=0.001..5.541 rows=100000 loops=1)
 Planning Time: 0.974 ms
 Execution Time: 32.510 ms
(11 řádek)

real    0m0,039s
user    0m0,001s
sys     0m0,002s

```sql
-- QUERY 2 ORIGINAL
SELECT e.name
FROM employee e
WHERE COALESCE(dept, '') NOT IN (
  SELECT dept FROM techdept
);
```
                                                   QUERY PLAN                                                    
-----------------------------------------------------------------------------------------------------------------
 Seq Scan on employee e  (cost=1.12..2155.12 rows=50000 width=14) (actual time=0.154..19.393 rows=90031 loops=1)
   Filter: (NOT (ANY ((COALESCE(dept, ''::character varying))::text = ((hashed SubPlan 1).col1)::text)))
   Rows Removed by Filter: 9969
   SubPlan 1
     ->  Seq Scan on techdept  (cost=0.00..1.10 rows=10 width=50) (actual time=0.136..0.138 rows=10 loops=1)
 Planning Time: 0.953 ms
 Execution Time: 23.289 ms
(7 řádek)

real    0m0,030s
user    0m0,001s
sys     0m0,002s

```sql
-- QUERY 2 REWRITTEN
SELECT e.name
FROM employee e
LEFT JOIN techdept t ON e.dept = t.dept
WHERE t.dept IS NULL;
```
                                                       QUERY PLAN                                                       
------------------------------------------------------------------------------------------------------------------------
 Hash Anti Join  (cost=1.23..3078.35 rows=1 width=14) (actual time=0.040..15.751 rows=90031 loops=1)
   Hash Cond: ((e.dept)::text = (t.dept)::text)
   ->  Seq Scan on employee e  (cost=0.00..1904.00 rows=100000 width=24) (actual time=0.004..5.302 rows=100000 loops=1)
   ->  Hash  (cost=1.10..1.10 rows=10 width=50) (actual time=0.008..0.009 rows=10 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 9kB
         ->  Seq Scan on techdept t  (cost=0.00..1.10 rows=10 width=50) (actual time=0.003..0.004 rows=10 loops=1)
 Planning Time: 0.477 ms
 Execution Time: 18.479 ms
(8 řádek)

real    0m0,024s
user    0m0,000s
sys     0m0,003s

# Test of maria
**Running queries...**

```sql
-- QUERY 1 ORIGINAL
SELECT e.name
FROM employee e
WHERE e.salary = (
  SELECT MAX(salary)
  FROM employee
  WHERE dept = e.dept
);
```
+------+--------------------+----------+------+-------------------+-------------------+---------+-------------+-------+-----------+----------+------------+-------------+
| id   | select_type        | table    | type | possible_keys     | key               | key_len | ref         | rows  | r_rows    | filtered | r_filtered | Extra       |
+------+--------------------+----------+------+-------------------+-------------------+---------+-------------+-------+-----------+----------+------------+-------------+
|    1 | PRIMARY            | e        | ALL  | NULL              | NULL              | NULL    | NULL        | 99640 | 100000.00 |   100.00 |       0.01 | Using where |
|    2 | DEPENDENT SUBQUERY | employee | ref  | employee_dept_idx | employee_dept_idx | 67      | trdb.e.dept | 9964  | 997.65    |   100.00 |     100.00 |             |
+------+--------------------+----------+------+-------------------+-------------------+---------+-------------+-------+-----------+----------+------------+-------------+

real    0m7,239s
user    0m0,050s
sys     0m0,024s
```sql
-- QUERY 1 REWRITTEN
SELECT e.name
FROM employee e
JOIN (
  SELECT dept, MAX(salary) AS salary
  FROM employee
  GROUP BY dept
) dms USING (dept, salary);
```
+------+-------------+------------+------+-------------------+------+---------+---------------------------+-------+-----------+----------+------------+---------------------------------+
| id   | select_type | table      | type | possible_keys     | key  | key_len | ref                       | rows  | r_rows    | filtered | r_filtered | Extra                           |
+------+-------------+------------+------+-------------------+------+---------+---------------------------+-------+-----------+----------+------------+---------------------------------+
|    1 | PRIMARY     | e          | ALL  | employee_dept_idx | NULL | NULL    | NULL                      | 99640 | 100000.00 |   100.00 |       9.97 | Using where                     |
|    1 | PRIMARY     | <derived2> | ref  | key0              | key0 | 73      | trdb.e.dept,trdb.e.salary | 10    | 0.00      |   100.00 |     100.00 |                                 |
|    2 | DERIVED     | employee   | ALL  | employee_dept_idx | NULL | NULL    | NULL                      | 99640 | 100000.00 |   100.00 |     100.00 | Using temporary; Using filesort |
+------+-------------+------------+------+-------------------+------+---------+---------------------------+-------+-----------+----------+------------+---------------------------------+

real    0m0,135s
user    0m0,033s
sys     0m0,026s
```sql
-- QUERY 2 ORIGINAL
SELECT e.name
FROM employee e
WHERE COALESCE(dept, '') NOT IN (
  SELECT dept FROM techdept
);
```
+------+--------------+----------+-------+---------------------------+----------------------+---------+------+-------+-----------+----------+------------+-------------+
| id   | select_type  | table    | type  | possible_keys             | key                  | key_len | ref  | rows  | r_rows    | filtered | r_filtered | Extra       |
+------+--------------+----------+-------+---------------------------+----------------------+---------+------+-------+-----------+----------+------------+-------------+
|    1 | PRIMARY      | e        | ALL   | NULL                      | NULL                 | NULL    | NULL | 99640 | 100000.00 |   100.00 |      90.03 | Using where |
|    2 | MATERIALIZED | techdept | index | PRIMARY,techdept_dept_idx | techdept_manager_idx | 4       | NULL | 10    | 10.00     |   100.00 |     100.00 | Using index |
+------+--------------+----------+-------+---------------------------+----------------------+---------+------+-------+-----------+----------+------------+-------------+

real    0m0,096s
user    0m0,043s
sys     0m0,023s
```sql
-- QUERY 2 REWRITTEN
SELECT e.name
FROM employee e
LEFT JOIN techdept t ON e.dept = t.dept
WHERE t.dept IS NULL;
```
+------+-------------+-------+--------+---------------------------+-------------------+---------+-------------+-------+-----------+----------+------------+--------------------------------------+
| id   | select_type | table | type   | possible_keys             | key               | key_len | ref         | rows  | r_rows    | filtered | r_filtered | Extra                                |
+------+-------------+-------+--------+---------------------------+-------------------+---------+-------------+-------+-----------+----------+------------+--------------------------------------+
|    1 | SIMPLE      | e     | ALL    | NULL                      | NULL              | NULL    | NULL        | 99640 | 100000.00 |   100.00 |     100.00 |                                      |
|    1 | SIMPLE      | t     | eq_ref | PRIMARY,techdept_dept_idx | techdept_dept_idx | 66      | trdb.e.dept | 1     | 0.10      |   100.00 |     100.00 | Using where; Using index; Not exists |
+------+-------------+-------+--------+---------------------------+-------------------+---------+-------------+-------+-----------+----------+------------+--------------------------------------+

real    0m0,085s
user    0m0,034s
sys     0m0,027s
