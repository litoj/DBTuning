CREATE TABLE
COPY 1233214


# Test of clustering B+-tree idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using idx_publ on publ  (cost=0.43..8.45 rows=1 width=129) (actual time=0.048..0.049 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.453 ms
 Execution Time: 0.083 ms
(4 řádky)

**1000 runs, 0.1 ms/run → 7189 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Index Scan using idx_publ on publ  (cost=0.43..14.49 rows=175 width=129) (actual time=0.047..0.049 rows=8 loops=1)
   Index Cond: ((booktitle)::text = 'TWOMD'::text)
 Planning Time: 0.461 ms
 Execution Time: 0.084 ms
(4 řádky)

**1000 runs, 0.1 ms/run → 7131 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Index Scan using idx_publ on publ  (cost=0.43..17.34 rows=3 width=128) (actual time=0.050..0.108 rows=3 loops=1)
   Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 0.624 ms
 Execution Time: 0.127 ms
(4 řádky)

**1000 runs, 0.1 ms/run → 7141 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```
 Index Scan using idx_publ on publ  (cost=0.43..4939.71 rows=126816 width=127) (actual time=0.042..25.949 rows=123190 loops=1)
   Index Cond: ((year)::text = '2007'::text)
 Planning Time: 0.441 ms
 Execution Time: 31.607 ms
(4 řádky)

**1000 runs, 0.1 ms/run → 7161 runs/s**
CREATE TABLE
COPY 1233214


# Test of B+-tree idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using idx_publ on publ  (cost=0.43..8.45 rows=1 width=129) (actual time=0.046..0.047 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.463 ms
 Execution Time: 0.080 ms
(4 řádky)

**1000 runs, 0.1 ms/run → 7152 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Bitmap Heap Scan on publ  (cost=5.79..664.99 rows=176 width=131) (actual time=0.048..0.103 rows=8 loops=1)
   Recheck Cond: ((booktitle)::text = 'TWOMD'::text)
   Heap Blocks: exact=8
   ->  Bitmap Index Scan on idx_publ  (cost=0.00..5.75 rows=176 width=0) (actual time=0.033..0.034 rows=8 loops=1)
         Index Cond: ((booktitle)::text = 'TWOMD'::text)
 Planning Time: 0.513 ms
 Execution Time: 0.145 ms
(7 řádek)

**1000 runs, 0.1 ms/run → 7176 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Index Scan using idx_publ on publ  (cost=0.43..25.33 rows=3 width=130) (actual time=0.048..0.117 rows=3 loops=1)
   Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 0.598 ms
 Execution Time: 0.136 ms
(4 řádky)

**1000 runs, 0.1 ms/run → 7139 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```
 Bitmap Heap Scan on publ  (cost=1415.25..25210.45 rows=126816 width=129) (actual time=10.247..160.838 rows=123190 loops=1)
   Recheck Cond: ((year)::text = '2007'::text)
   Heap Blocks: exact=21772
   ->  Bitmap Index Scan on idx_publ  (cost=0.00..1383.55 rows=126816 width=0) (actual time=5.915..5.916 rows=123190 loops=1)
         Index Cond: ((year)::text = '2007'::text)
 Planning Time: 0.475 ms
 Execution Time: 166.826 ms
(7 řádek)

**1000 runs, 0.1 ms/run → 7266 runs/s**
CREATE TABLE
COPY 1233214


# Test of hash idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Index Scan using idx_publ on publ  (cost=0.00..8.02 rows=1 width=130) (actual time=0.040..0.041 rows=1 loops=1)
   Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text)
 Planning Time: 0.409 ms
 Execution Time: 0.072 ms
(4 řádky)

**1000 runs, 0.1 ms/run → 7177 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Bitmap Heap Scan on publ  (cost=5.38..671.75 rows=178 width=131) (actual time=0.045..0.055 rows=8 loops=1)
   Recheck Cond: ((booktitle)::text = 'TWOMD'::text)
   Heap Blocks: exact=2
   ->  Bitmap Index Scan on idx_publ  (cost=0.00..5.33 rows=178 width=0) (actual time=0.026..0.027 rows=8 loops=1)
         Index Cond: ((booktitle)::text = 'TWOMD'::text)
 Planning Time: 0.470 ms
 Execution Time: 0.092 ms
(7 řádek)

**1000 runs, 0.1 ms/run → 7136 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Bitmap Heap Scan on publ  (cost=12.02..23.96 rows=3 width=131) (actual time=0.062..0.078 rows=3 loops=1)
   Recheck Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
   Heap Blocks: exact=3
   ->  Bitmap Index Scan on idx_publ  (cost=0.00..12.02 rows=3 width=0) (actual time=0.043..0.043 rows=3 loops=1)
         Index Cond: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
 Planning Time: 0.583 ms
 Execution Time: 0.102 ms
(7 řádek)

**1000 runs, 0.1 ms/run → 7162 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```
 Bitmap Heap Scan on publ  (cost=3767.92..27471.27 rows=122828 width=131) (actual time=6.106..66.380 rows=123190 loops=1)
   Recheck Cond: ((year)::text = '2007'::text)
   Heap Blocks: exact=6051
   ->  Bitmap Index Scan on idx_publ  (cost=0.00..3737.21 rows=122828 width=0) (actual time=5.047..5.048 rows=123190 loops=1)
         Index Cond: ((year)::text = '2007'::text)
 Planning Time: 0.539 ms
 Execution Time: 72.095 ms
(7 řádek)

**1000 runs, 0.1 ms/run → 7166 runs/s**
CREATE TABLE
COPY 1233214


# Test of no idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```
 Gather  (cost=1000.00..29591.09 rows=1 width=129) (actual time=2.230..48.733 rows=1 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..28590.99 rows=1 width=129) (actual time=29.907..44.662 rows=0 loops=3)
         Filter: ((pubid)::text = 'conf/aaai/Val99'::text)
         Rows Removed by Filter: 411071
 Planning Time: 0.374 ms
 Execution Time: 48.786 ms
(8 řádek)

**1000 runs, 0.1 ms/run → 7143 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```
 Gather  (cost=1000.00..29608.29 rows=173 width=130) (actual time=49.990..52.309 rows=8 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..28590.99 rows=72 width=130) (actual time=39.361..48.093 rows=3 loops=3)
         Filter: ((booktitle)::text = 'TWOMD'::text)
         Rows Removed by Filter: 411069
 Planning Time: 0.396 ms
 Execution Time: 52.350 ms
(8 řádek)

**1000 runs, 0.1 ms/run → 7132 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```
 Gather  (cost=1000.00..30233.59 rows=3 width=129) (actual time=20.443..72.287 rows=3 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on publ  (cost=0.00..29233.29 rows=1 width=129) (actual time=30.790..68.014 rows=1 loops=3)
         Filter: ((pubid)::text = ANY ('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[]))
         Rows Removed by Filter: 411070
 Planning Time: 0.531 ms
 Execution Time: 72.315 ms
(8 řádek)

**1000 runs, 0.1 ms/run → 7174 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```
 Seq Scan on publ  (cost=0.00..37583.18 rows=121595 width=128) (actual time=0.387..149.284 rows=123190 loops=1)
   Filter: ((year)::text = '2007'::text)
   Rows Removed by Filter: 1110024
 Planning Time: 0.405 ms
 Execution Time: 154.868 ms
(5 řádek)

**1000 runs, 0.1 ms/run → 7119 runs/s**


in 100x:

| Q type | Cl  | Bt  | H   | -   |
| ------ | --- | --- | --- | --- |
| Point  | 72  | 72  | 72  | 71  |
| MP-bt  | 71  | 72  | 71  | 71  |
| MP-IN  | 71  | 71  | 72  | 72  |
| MP-yr  | 72  | 73  | 72  | 71  |
