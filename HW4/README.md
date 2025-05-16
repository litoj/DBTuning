

# Test of clustering B+-tree idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using idx_publ on publ  (cost=0.43..8.45 rows=1 width=130) (actual time=0.028..0.028 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.303 ms
 Execution Time: 0.057 ms
(4 rows)

**100 runs, 6 ms/run → 152 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Gather  (cost=1000.00..29502.69 rows=177 width=130) (actual time=25.896..41.616 rows=8 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..28484.99 rows=74 width=130) (actual time=33.104..37.988 rows=3 loops=3)
         Filter: ((booktitle)::text = 'TWOMD'::text)
         Rows Removed by Filter: 411069
 Planning Time: 0.637 ms
 Execution Time: 41.673 ms
(8 rows)

**100 runs, 9 ms/run → 108 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Index Scan using idx_publ on publ  (cost=0.43..18.17 rows=3 width=130) (actual time=0.075..0.169 rows=3 loops=1)
   Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 0.973 ms
 Execution Time: 0.198 ms
(4 rows)

**100 runs, 10 ms/run → 95 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = 2007
```
 Seq Scan on publ  (cost=0.00..37477.18 rows=121595 width=130) (actual time=1.180..95.471 rows=123190 loops=1)
   Filter: (year = 2007)
   Rows Removed by Filter: 1110024
 Planning Time: 1.355 ms
 Execution Time: 99.800 ms
(5 rows)

**100 runs, 8 ms/run → 120 runs/s**


# Test of B+-tree idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using idx_publ on publ  (cost=0.43..8.45 rows=1 width=130) (actual time=0.031..0.032 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.440 ms
 Execution Time: 0.060 ms
(4 rows)

**100 runs, 11 ms/run → 88 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Gather  (cost=1000.00..29502.69 rows=177 width=130) (actual time=34.917..55.019 rows=8 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..28484.99 rows=74 width=130) (actual time=43.381..49.681 rows=3 loops=3)
         Filter: ((booktitle)::text = 'TWOMD'::text)
         Rows Removed by Filter: 411069
 Planning Time: 0.889 ms
 Execution Time: 55.093 ms
(8 rows)

**100 runs, 11 ms/run → 86 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Index Scan using idx_publ on publ  (cost=0.43..18.17 rows=3 width=130) (actual time=0.242..0.388 rows=3 loops=1)
   Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 1.504 ms
 Execution Time: 0.429 ms
(4 rows)

**100 runs, 12 ms/run → 78 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = 2007
```
 Seq Scan on publ  (cost=0.00..37477.18 rows=121595 width=130) (actual time=0.608..95.114 rows=123190 loops=1)
   Filter: (year = 2007)
   Rows Removed by Filter: 1110024
 Planning Time: 0.633 ms
 Execution Time: 99.391 ms
(5 rows)

**100 runs, 11 ms/run → 87 runs/s**


# Test of hash idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using idx_publ on publ  (cost=0.00..8.02 rows=1 width=130) (actual time=0.019..0.020 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.450 ms
 Execution Time: 0.051 ms
(4 rows)

**100 runs, 10 ms/run → 99 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Gather  (cost=1000.00..29502.69 rows=177 width=130) (actual time=50.200..51.175 rows=8 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..28484.99 rows=74 width=130) (actual time=40.330..46.061 rows=3 loops=3)
         Filter: ((booktitle)::text = 'TWOMD'::text)
         Rows Removed by Filter: 411069
 Planning Time: 1.029 ms
 Execution Time: 51.256 ms
(8 rows)

**100 runs, 9 ms/run → 105 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Index Scan using pk_publ on publ  (cost=0.43..18.17 rows=3 width=130) (actual time=0.084..0.155 rows=3 loops=1)
   Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 0.967 ms
 Execution Time: 0.181 ms
(4 rows)

**100 runs, 13 ms/run → 76 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = 2007
```
 Seq Scan on publ  (cost=0.00..37477.18 rows=121595 width=130) (actual time=0.824..128.093 rows=123190 loops=1)
   Filter: (year = 2007)
   Rows Removed by Filter: 1110024
 Planning Time: 0.937 ms
 Execution Time: 133.716 ms
(5 rows)

**100 runs, 11 ms/run → 86 runs/s**


# Test of no idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using pk_publ on publ  (cost=0.43..8.45 rows=1 width=130) (actual time=0.129..0.131 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 1.063 ms
 Execution Time: 0.291 ms
(4 rows)

**100 runs, 10 ms/run → 92 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Gather  (cost=1000.00..29502.69 rows=177 width=130) (actual time=44.461..45.916 rows=8 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..28484.99 rows=74 width=130) (actual time=35.396..40.697 rows=3 loops=3)
         Filter: ((booktitle)::text = 'TWOMD'::text)
         Rows Removed by Filter: 411069
 Planning Time: 0.890 ms
 Execution Time: 46.003 ms
(8 rows)

**100 runs, 10 ms/run → 96 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Index Scan using pk_publ on publ  (cost=0.43..18.17 rows=3 width=130) (actual time=0.084..0.180 rows=3 loops=1)
   Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 1.703 ms
 Execution Time: 0.234 ms
(4 rows)

**100 runs, 12 ms/run → 81 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = 2007
```
 Seq Scan on publ  (cost=0.00..37477.18 rows=121595 width=130) (actual time=0.885..111.017 rows=123190 loops=1)
   Filter: (year = 2007)
   Rows Removed by Filter: 1110024
 Planning Time: 0.875 ms
 Execution Time: 115.943 ms
(5 rows)

**100 runs, 11 ms/run → 83 runs/s**
