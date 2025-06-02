

# Test of clustering B+-tree idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using idx_publ on publ  (cost=0.43..8.45 rows=1 width=130) (actual time=0.036..0.036 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.409 ms
 Execution Time: 0.066 ms
(4 řádky)

**1000 runs, 0.3 ms/run → 2576 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Index Scan using idx_publ on publ  (cost=0.43..14.46 rows=173 width=128) (actual time=0.041..0.043 rows=8 loops=1)
   Index Cond: ((booktitle)::text = 'TWOMD'::text)
 Planning Time: 0.464 ms
 Execution Time: 0.096 ms
(4 řádky)

**1000 runs, 0.3 ms/run → 2514 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Index Scan using idx_publ on publ  (cost=0.43..17.34 rows=3 width=129) (actual time=0.032..0.079 rows=3 loops=1)
   Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 0.516 ms
 Execution Time: 0.094 ms
(4 řádky)

**1000 runs, 0.6 ms/run → 1533 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```
 Index Scan using idx_publ on publ  (cost=0.43..4742.49 rows=121718 width=129) (actual time=0.045..27.260 rows=123190 loops=1)
   Index Cond: ((year)::text = '2007'::text)
 Planning Time: 0.466 ms
 Execution Time: 32.874 ms
(4 řádky)

**1000 runs, 20.6 ms/run → 48 runs/s**


# Test of B+-tree idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using idx_publ on publ  (cost=0.43..8.45 rows=1 width=130) (actual time=0.035..0.036 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.395 ms
 Execution Time: 0.065 ms
(4 řádky)

**1000 runs, 0.3 ms/run → 2602 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Bitmap Heap Scan on publ  (cost=5.79..664.99 rows=176 width=132) (actual time=0.037..0.078 rows=8 loops=1)
   Recheck Cond: ((booktitle)::text = 'TWOMD'::text)
   Heap Blocks: exact=8
   ->  Bitmap Index Scan on idx_publ  (cost=0.00..5.75 rows=176 width=0) (actual time=0.026..0.026 rows=8 loops=1)
         Index Cond: ((booktitle)::text = 'TWOMD'::text)
 Planning Time: 0.379 ms
 Execution Time: 0.116 ms
(7 řádek)

**1000 runs, 0.4 ms/run → 2448 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Index Scan using idx_publ on publ  (cost=0.43..25.33 rows=3 width=129) (actual time=0.040..0.088 rows=3 loops=1)
   Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 0.544 ms
 Execution Time: 0.105 ms
(4 řádky)

**1000 runs, 0.6 ms/run → 1536 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```
 Bitmap Heap Scan on publ  (cost=1400.42..25178.14 rows=125418 width=130) (actual time=10.127..120.728 rows=123190 loops=1)
   Recheck Cond: ((year)::text = '2007'::text)
   Heap Blocks: exact=21749
   ->  Bitmap Index Scan on idx_publ  (cost=0.00..1369.06 rows=125418 width=0) (actual time=5.710..5.711 rows=123190 loops=1)
         Index Cond: ((year)::text = '2007'::text)
 Planning Time: 0.379 ms
 Execution Time: 126.709 ms
(7 řádek)

**1000 runs, 126.8 ms/run → 7 runs/s**


# Test of hash idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using idx_publ on publ  (cost=0.00..8.02 rows=1 width=131) (actual time=0.023..0.024 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.408 ms
 Execution Time: 0.061 ms
(4 řádky)

**1000 runs, 0.3 ms/run → 2686 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Bitmap Heap Scan on publ  (cost=5.36..660.94 rows=175 width=129) (actual time=0.035..0.073 rows=8 loops=1)
   Recheck Cond: ((booktitle)::text = 'TWOMD'::text)
   Heap Blocks: exact=8
   ->  Bitmap Index Scan on idx_publ  (cost=0.00..5.31 rows=175 width=0) (actual time=0.017..0.017 rows=8 loops=1)
         Index Cond: ((booktitle)::text = 'TWOMD'::text)
 Planning Time: 0.380 ms
 Execution Time: 0.105 ms
(7 řádek)

**1000 runs, 0.4 ms/run → 2319 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Bitmap Heap Scan on publ  (cost=12.02..23.96 rows=3 width=131) (actual time=0.045..0.057 rows=3 loops=1)
   Recheck Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
   Heap Blocks: exact=3
   ->  Bitmap Index Scan on idx_publ  (cost=0.00..12.02 rows=3 width=0) (actual time=0.029..0.029 rows=3 loops=1)
         Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 0.484 ms
 Execution Time: 0.076 ms
(7 řádek)

**1000 runs, 0.6 ms/run → 1610 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```
 Bitmap Heap Scan on publ  (cost=3698.39..27415.48 rows=120567 width=130) (actual time=11.226..127.128 rows=123190 loops=1)
   Recheck Cond: ((year)::text = '2007'::text)
   Heap Blocks: exact=21749
   ->  Bitmap Index Scan on idx_publ  (cost=0.00..3668.25 rows=120567 width=0) (actual time=6.802..6.802 rows=123190 loops=1)
         Index Cond: ((year)::text = '2007'::text)
 Planning Time: 0.382 ms
 Execution Time: 133.312 ms
(7 řádek)

**1000 runs, 139.6 ms/run → 7 runs/s**


# Test of no idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Gather  (cost=1000.00..29633.09 rows=1 width=131) (actual time=6.020..42.533 rows=1 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..28632.99 rows=1 width=131) (actual time=26.812..38.040 rows=0 loops=3)
         Filter: ((pubid)::text = 'conf/aaai/Val99'::text)
         Rows Removed by Filter: 411071
 Planning Time: 0.346 ms
 Execution Time: 42.566 ms
(8 řádek)

**1000 runs, 42.7 ms/run → 23 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Gather  (cost=1000.00..29650.49 rows=175 width=132) (actual time=27.828..50.706 rows=8 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..28632.99 rows=73 width=132) (actual time=16.787..46.248 rows=3 loops=3)
         Filter: ((booktitle)::text = 'TWOMD'::text)
         Rows Removed by Filter: 411069
 Planning Time: 0.333 ms
 Execution Time: 50.741 ms
(8 řádek)

**1000 runs, 49.9 ms/run → 20 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Gather  (cost=1000.00..30275.59 rows=3 width=130) (actual time=60.201..63.019 rows=3 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..29275.29 rows=1 width=130) (actual time=45.336..58.483 rows=1 loops=3)
         Filter: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
         Rows Removed by Filter: 411070
 Planning Time: 0.485 ms
 Execution Time: 63.039 ms
(8 řádek)

**1000 runs, 72.7 ms/run → 13 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```
 Seq Scan on publ  (cost=0.00..37625.18 rows=119786 width=130) (actual time=0.018..166.884 rows=123190 loops=1)
   Filter: ((year)::text = '2007'::text)
   Rows Removed by Filter: 1110024
 Planning Time: 0.428 ms
 Execution Time: 172.519 ms
(5 řádek)

**1000 runs, 169.7 ms/run → 5 runs/s**
