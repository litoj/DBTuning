

# Test of clustering B+-tree idx

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using idx_publ on publ  (cost=0.43..8.45 rows=1 width=130) (actual time=0.031..0.032 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.543 ms
 Execution Time: 0.056 ms
(4 řádky)

**100 runs, 9 ms/run → 110 runs/s**

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Gather  (cost=1000.00..29502.69 rows=177 width=130) (actual time=52.214..53.523 rows=8 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..28484.99 rows=74 width=130) (actual time=42.265..49.150 rows=3 loops=3)
         Filter: ((booktitle)::text = 'TWOMD'::text)
         Rows Removed by Filter: 411069
 Planning Time: 0.744 ms
 Execution Time: 53.583 ms
(8 řádek)

**100 runs, 7 ms/run → 133 runs/s**

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Index Scan using idx_publ on publ  (cost=0.43..18.17 rows=3 width=130) (actual time=0.062..0.118 rows=3 loops=1)
   Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 0.655 ms
 Execution Time: 0.148 ms
(4 řádky)

**100 runs, 10 ms/run → 91 runs/s**

```sql
SELECT * FROM Publ WHERE year = 2007
```
 Seq Scan on publ  (cost=0.00..37477.18 rows=121595 width=130) (actual time=0.949..140.931 rows=123190 loops=1)
   Filter: (year = 2007)
   Rows Removed by Filter: 1110024
 Planning Time: 1.058 ms
 Execution Time: 146.704 ms
(5 řádek)

**100 runs, 9 ms/run → 101 runs/s**


# Test of B+-tree idx

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using idx_publ on publ  (cost=0.43..8.45 rows=1 width=130) (actual time=0.032..0.033 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.363 ms
 Execution Time: 0.061 ms
(4 řádky)

**100 runs, 10 ms/run → 97 runs/s**

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Gather  (cost=1000.00..29502.69 rows=177 width=130) (actual time=55.404..56.557 rows=8 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..28484.99 rows=74 width=130) (actual time=45.657..52.227 rows=3 loops=3)
         Filter: ((booktitle)::text = 'TWOMD'::text)
         Rows Removed by Filter: 411069
 Planning Time: 0.700 ms
 Execution Time: 56.620 ms
(8 řádek)

**100 runs, 7 ms/run → 127 runs/s**

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Index Scan using idx_publ on publ  (cost=0.43..18.17 rows=3 width=130) (actual time=0.132..0.276 rows=3 loops=1)
   Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 1.436 ms
 Execution Time: 0.320 ms
(4 řádky)

**100 runs, 9 ms/run → 107 runs/s**

```sql
SELECT * FROM Publ WHERE year = 2007
```
 Seq Scan on publ  (cost=0.00..37477.18 rows=121595 width=130) (actual time=0.848..96.097 rows=123190 loops=1)
   Filter: (year = 2007)
   Rows Removed by Filter: 1110024
 Planning Time: 0.849 ms
 Execution Time: 100.307 ms
(5 řádek)

**100 runs, 11 ms/run → 89 runs/s**


# Test of hash idx

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using idx_publ on publ  (cost=0.00..8.02 rows=1 width=130) (actual time=0.017..0.018 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.348 ms
 Execution Time: 0.042 ms
(4 řádky)

**100 runs, 10 ms/run → 91 runs/s**

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Gather  (cost=1000.00..29502.69 rows=177 width=130) (actual time=51.213..52.331 rows=8 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..28484.99 rows=74 width=130) (actual time=42.326..48.253 rows=3 loops=3)
         Filter: ((booktitle)::text = 'TWOMD'::text)
         Rows Removed by Filter: 411069
 Planning Time: 0.882 ms
 Execution Time: 52.392 ms
(8 řádek)

**100 runs, 9 ms/run → 102 runs/s**

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Index Scan using pk_publ on publ  (cost=0.43..18.17 rows=3 width=130) (actual time=0.133..0.217 rows=3 loops=1)
   Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 1.317 ms
 Execution Time: 0.248 ms
(4 řádky)

**100 runs, 13 ms/run → 75 runs/s**

```sql
SELECT * FROM Publ WHERE year = 2007
```
 Seq Scan on publ  (cost=0.00..37477.18 rows=121595 width=130) (actual time=1.245..144.826 rows=123190 loops=1)
   Filter: (year = 2007)
   Rows Removed by Filter: 1110024
 Planning Time: 1.450 ms
 Execution Time: 151.217 ms
(5 řádek)

**100 runs, 9 ms/run → 109 runs/s**


# Test of no idx

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using pk_publ on publ  (cost=0.43..8.45 rows=1 width=130) (actual time=0.070..0.071 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.543 ms
 Execution Time: 0.132 ms
(4 řádky)

**100 runs, 11 ms/run → 89 runs/s**

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Gather  (cost=1000.00..29502.69 rows=177 width=130) (actual time=40.378..59.611 rows=8 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..28484.99 rows=74 width=130) (actual time=48.463..54.446 rows=3 loops=3)
         Filter: ((booktitle)::text = 'TWOMD'::text)
         Rows Removed by Filter: 411069
 Planning Time: 0.819 ms
 Execution Time: 59.687 ms
(8 řádek)

**100 runs, 10 ms/run → 96 runs/s**

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Index Scan using pk_publ on publ  (cost=0.43..18.17 rows=3 width=130) (actual time=0.049..0.167 rows=3 loops=1)
   Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 0.955 ms
 Execution Time: 0.201 ms
(4 řádky)

**100 runs, 10 ms/run → 92 runs/s**

```sql
SELECT * FROM Publ WHERE year = 2007
```
 Seq Scan on publ  (cost=0.00..37477.18 rows=121595 width=130) (actual time=1.120..123.982 rows=123190 loops=1)
   Filter: (year = 2007)
   Rows Removed by Filter: 1110024
 Planning Time: 1.199 ms
 Execution Time: 129.516 ms
(5 řádek)

**100 runs, 10 ms/run → 94 runs/s**
