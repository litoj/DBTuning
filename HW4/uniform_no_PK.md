

# Test of clustering B+-tree idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using idx_publ on publ  (cost=0.43..8.45 rows=1 width=128) (actual time=0.040..0.041 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.476 ms
 Execution Time: 0.075 ms
(4 řádky)

**100 runs, 0.4 ms/run → 2425 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Index Scan using idx_publ on publ  (cost=0.43..14.51 rows=176 width=130) (actual time=0.042..0.044 rows=8 loops=1)
   Index Cond: ((booktitle)::text = 'TWOMD'::text)
 Planning Time: 0.493 ms
 Execution Time: 0.078 ms
(4 řádky)

**100 runs, 0.4 ms/run → 2450 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Index Scan using idx_publ on publ  (cost=0.43..17.34 rows=3 width=130) (actual time=0.044..0.102 rows=3 loops=1)
   Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 0.612 ms
 Execution Time: 0.123 ms
(4 řádky)

**100 runs, 0.6 ms/run → 1479 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```
 Index Scan using idx_publ on publ  (cost=0.43..4916.91 rows=126199 width=130) (actual time=0.047..27.114 rows=123190 loops=1)
   Index Cond: ((year)::text = '2007'::text)
 Planning Time: 0.467 ms
 Execution Time: 32.734 ms
(4 řádky)

**100 runs, 21.4 ms/run → 46 runs/s**


# Test of B+-tree idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using idx_publ on publ  (cost=0.43..8.45 rows=1 width=130) (actual time=0.036..0.037 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.435 ms
 Execution Time: 0.066 ms
(4 řádky)

**100 runs, 0.3 ms/run → 2629 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Bitmap Heap Scan on publ  (cost=5.79..664.99 rows=176 width=130) (actual time=0.032..0.058 rows=8 loops=1)
   Recheck Cond: ((booktitle)::text = 'TWOMD'::text)
   Heap Blocks: exact=8
   ->  Bitmap Index Scan on idx_publ  (cost=0.00..5.75 rows=176 width=0) (actual time=0.021..0.021 rows=8 loops=1)
         Index Cond: ((booktitle)::text = 'TWOMD'::text)
 Planning Time: 0.399 ms
 Execution Time: 0.093 ms
(7 řádek)

**100 runs, 0.4 ms/run → 2228 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Index Scan using idx_publ on publ  (cost=0.43..25.33 rows=3 width=130) (actual time=0.041..0.084 rows=3 loops=1)
   Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 0.654 ms
 Execution Time: 0.107 ms
(4 řádky)

**100 runs, 0.6 ms/run → 1487 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```
 Bitmap Heap Scan on publ  (cost=1360.38..25092.88 rows=121800 width=131) (actual time=9.836..120.312 rows=123190 loops=1)
   Recheck Cond: ((year)::text = '2007'::text)
   Heap Blocks: exact=21749
   ->  Bitmap Index Scan on idx_publ  (cost=0.00..1329.93 rows=121800 width=0) (actual time=5.571..5.572 rows=123190 loops=1)
         Index Cond: ((year)::text = '2007'::text)
 Planning Time: 0.392 ms
 Execution Time: 126.346 ms
(7 řádek)

**100 runs, 125.3 ms/run → 7 runs/s**


# Test of hash idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using idx_publ on publ  (cost=0.00..8.02 rows=1 width=128) (actual time=0.050..0.051 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.460 ms
 Execution Time: 0.083 ms
(4 řádky)

**100 runs, 0.3 ms/run → 2640 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Bitmap Heap Scan on publ  (cost=5.39..675.42 rows=179 width=129) (actual time=0.033..0.087 rows=8 loops=1)
   Recheck Cond: ((booktitle)::text = 'TWOMD'::text)
   Heap Blocks: exact=8
   ->  Bitmap Index Scan on idx_publ  (cost=0.00..5.34 rows=179 width=0) (actual time=0.012..0.012 rows=8 loops=1)
         Index Cond: ((booktitle)::text = 'TWOMD'::text)
 Planning Time: 0.461 ms
 Execution Time: 0.124 ms
(7 řádek)

**100 runs, 0.4 ms/run → 2411 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Bitmap Heap Scan on publ  (cost=12.02..23.96 rows=3 width=131) (actual time=0.047..0.064 rows=3 loops=1)
   Recheck Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
   Heap Blocks: exact=3
   ->  Bitmap Index Scan on idx_publ  (cost=0.00..12.02 rows=3 width=0) (actual time=0.032..0.032 rows=3 loops=1)
         Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 0.578 ms
 Execution Time: 0.087 ms
(7 řádek)

**100 runs, 0.6 ms/run → 1514 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```
 Bitmap Heap Scan on publ  (cost=3762.00..27504.27 rows=122581 width=129) (actual time=11.725..174.540 rows=123190 loops=1)
   Recheck Cond: ((year)::text = '2007'::text)
   Heap Blocks: exact=21749
   ->  Bitmap Index Scan on idx_publ  (cost=0.00..3731.36 rows=122581 width=0) (actual time=7.387..7.389 rows=123190 loops=1)
         Index Cond: ((year)::text = '2007'::text)
 Planning Time: 0.459 ms
 Execution Time: 180.536 ms
(7 řádek)

**100 runs, 137.4 ms/run → 7 runs/s**


# Test of no idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Gather  (cost=1000.00..29633.09 rows=1 width=130) (actual time=7.165..55.712 rows=1 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..28632.99 rows=1 width=130) (actual time=35.227..50.259 rows=0 loops=3)
         Filter: ((pubid)::text = 'conf/aaai/Val99'::text)
         Rows Removed by Filter: 411071
 Planning Time: 0.406 ms
 Execution Time: 55.752 ms
(8 řádek)

**100 runs, 41.7 ms/run → 23 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Gather  (cost=1000.00..29650.39 rows=174 width=129) (actual time=11.544..48.798 rows=8 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..28632.99 rows=72 width=129) (actual time=22.353..44.505 rows=3 loops=3)
         Filter: ((booktitle)::text = 'TWOMD'::text)
         Rows Removed by Filter: 411069
 Planning Time: 0.377 ms
 Execution Time: 48.836 ms
(8 řádek)

**100 runs, 48.3 ms/run → 20 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Gather  (cost=1000.00..30275.59 rows=3 width=129) (actual time=23.602..79.645 rows=3 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..29275.29 rows=1 width=129) (actual time=43.948..74.199 rows=1 loops=3)
         Filter: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
         Rows Removed by Filter: 411070
 Planning Time: 0.560 ms
 Execution Time: 79.675 ms
(8 řádek)

**100 runs, 71.3 ms/run → 14 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```
 Seq Scan on publ  (cost=0.00..37625.18 rows=123856 width=131) (actual time=0.021..162.127 rows=123190 loops=1)
   Filter: ((year)::text = '2007'::text)
   Rows Removed by Filter: 1110024
 Planning Time: 0.310 ms
 Execution Time: 167.700 ms
(5 řádek)

**100 runs, 169.9 ms/run → 5 runs/s**
