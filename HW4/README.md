# Test of clustering B+-tree idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```

Index Scan using idx_publ on publ (cost=0.43..8.45 rows=1 width=129) (actual time=0.037..0.037
rows=1 loops=1) Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text) Planning Time: 0.392 ms
Execution Time: 0.063 ms (4 rows)

**1000 runs, 0.1 ms/run → 7170 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```

Index Scan using idx_publ on publ (cost=0.43..14.44 rows=172 width=131) (actual time=0.028..0.029
rows=8 loops=1) Index Cond: ((booktitle)::text = 'TWOMD'::text) Planning Time: 0.399 ms Execution
Time: 0.058 ms (4 rows)

**1000 runs, 0.1 ms/run → 7649 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```

Index Scan using idx_publ on publ (cost=0.43..17.34 rows=3 width=128) (actual time=0.029..0.063
rows=3 loops=1) Index Cond: ((pubid)::text = ANY
('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[])) Planning Time:
0.375 ms Execution Time: 0.073 ms (4 rows)

**1000 runs, 0.1 ms/run → 6505 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```

Index Scan using idx_publ on publ (cost=0.43..4829.34 rows=123938 width=129) (actual
time=0.030..23.886 rows=123190 loops=1) Index Cond: ((year)::text = '2007'::text) Planning Time:
0.328 ms Execution Time: 29.480 ms (4 rows)

**1000 runs, 0.1 ms/run → 6698 runs/s**

# Test of B+-tree idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```

Index Scan using idx_publ on publ (cost=0.43..8.45 rows=1 width=130) (actual time=0.030..0.030
rows=1 loops=1) Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text) Planning Time: 0.326 ms
Execution Time: 0.051 ms (4 rows)

**1000 runs, 0.1 ms/run → 7353 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```

Bitmap Heap Scan on publ (cost=5.81..675.84 rows=179 width=129) (actual time=0.026..0.054 rows=8
loops=1) Recheck Cond: ((booktitle)::text = 'TWOMD'::text) Heap Blocks: exact=8 -> Bitmap Index Scan
on idx_publ (cost=0.00..5.77 rows=179 width=0) (actual time=0.018..0.018 rows=8 loops=1) Index Cond:
((booktitle)::text = 'TWOMD'::text) Planning Time: 0.297 ms Execution Time: 0.079 ms (7 rows)

**1000 runs, 0.1 ms/run → 6930 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```

Index Scan using idx_publ on publ (cost=0.43..25.33 rows=3 width=129) (actual time=0.030..0.067
rows=3 loops=1) Index Cond: ((pubid)::text = ANY
('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[])) Planning Time:
0.470 ms Execution Time: 0.080 ms (4 rows)

**1000 runs, 0.1 ms/run → 7599 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```

Bitmap Heap Scan on publ (cost=1336.45..25043.26 rows=119745 width=129) (actual time=6.225..85.458
rows=123190 loops=1) Recheck Cond: ((year)::text = '2007'::text) Heap Blocks: exact=21749 -> Bitmap
Index Scan on idx_publ (cost=0.00..1306.52 rows=119745 width=0) (actual time=3.743..3.744
rows=123190 loops=1) Index Cond: ((year)::text = '2007'::text) Planning Time: 0.341 ms Execution
Time: 88.973 ms (7 rows)

**1000 runs, 0.1 ms/run → 6362 runs/s**

# Test of hash idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```

Index Scan using idx_publ on publ (cost=0.00..8.02 rows=1 width=130) (actual time=0.028..0.029
rows=1 loops=1) Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text) Planning Time: 0.431 ms
Execution Time: 0.056 ms (4 rows)

**1000 runs, 0.1 ms/run → 6082 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```

Bitmap Heap Scan on publ (cost=5.37..668.18 rows=177 width=130) (actual time=0.025..0.075 rows=8
loops=1) Recheck Cond: ((booktitle)::text = 'TWOMD'::text) Heap Blocks: exact=8 -> Bitmap Index Scan
on idx_publ (cost=0.00..5.33 rows=177 width=0) (actual time=0.015..0.015 rows=8 loops=1) Index Cond:
((booktitle)::text = 'TWOMD'::text) Planning Time: 0.313 ms Execution Time: 0.103 ms (7 rows)

**1000 runs, 0.1 ms/run → 5733 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```

Bitmap Heap Scan on publ (cost=12.02..23.96 rows=3 width=129) (actual time=0.039..0.054 rows=3
loops=1) Recheck Cond: ((pubid)::text = ANY
('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[])) Heap Blocks:
exact=3 -> Bitmap Index Scan on idx_publ (cost=0.00..12.02 rows=3 width=0) (actual time=0.024..0.024
rows=3 loops=1) Index Cond: ((pubid)::text = ANY
('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[])) Planning Time:
0.509 ms Execution Time: 0.072 ms (7 rows)

**1000 runs, 0.1 ms/run → 7458 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```

Bitmap Heap Scan on publ (cost=3875.00..27664.02 rows=126322 width=130) (actual time=6.983..73.701
rows=123190 loops=1) Recheck Cond: ((year)::text = '2007'::text) Heap Blocks: exact=21749 -> Bitmap
Index Scan on idx_publ (cost=0.00..3843.41 rows=126322 width=0) (actual time=4.510..4.510
rows=123190 loops=1) Index Cond: ((year)::text = '2007'::text) Planning Time: 0.392 ms Execution
Time: 77.206 ms (7 rows)

**1000 runs, 0.1 ms/run → 6081 runs/s**

# Test of no idx

## Point queries

```sql
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99'
```

Index Scan using pk_publ on publ (cost=0.43..8.45 rows=1 width=131) (actual time=0.034..0.034 rows=1
loops=1) Index Cond: ((pubid)::text = 'conf/aaai/Val99'::text) Planning Time: 0.301 ms Execution
Time: 0.059 ms (4 rows)

**1000 runs, 0.1 ms/run → 5728 runs/s**

## Multipoint low selectivity

```sql
SELECT * FROM Publ WHERE booktitle = 'TWOMD'
```

Gather (cost=1000.00..29650.19 rows=172 width=131) (actual time=17.829..50.503 rows=8 loops=1)
Workers Planned: 2 Workers Launched: 2 -> Parallel Seq Scan on publ (cost=0.00..28632.99 rows=72
width=131) (actual time=33.038..46.564 rows=3 loops=3) Filter: ((booktitle)::text = 'TWOMD'::text)
Rows Removed by Filter: 411069 Planning Time: 0.411 ms Execution Time: 50.543 ms (8 rows)

**1000 runs, 0.1 ms/run → 5944 runs/s**

## Multipoint low selectivity using IN

```sql
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90')
```

Index Scan using pk_publ on publ (cost=0.43..25.33 rows=3 width=129) (actual time=0.032..0.071
rows=3 loops=1) Index Cond: ((pubid)::text = ANY
('{journals/tcs/EsikK04,conf/icra/KobayashiH04,conf/coling/KerpedjievN90}'::text[])) Planning Time:
0.418 ms Execution Time: 0.085 ms (4 rows)

**1000 runs, 0.1 ms/run → 7227 runs/s**

## Multipoint high selectivity

```sql
SELECT * FROM Publ WHERE year = '2007'
```

Seq Scan on publ (cost=0.00..37625.18 rows=124925 width=128) (actual time=0.019..122.180 rows=123190
loops=1) Filter: ((year)::text = '2007'::text) Rows Removed by Filter: 1110024 Planning Time: 0.369
ms Execution Time: 126.232 ms (5 rows)

**1000 runs, 0.1 ms/run → 6938 runs/s**

in 100x:

| Q type | Cl  | Bt  | H   | -   |
| ------ | --- | --- | --- | --- |
| Point  | 71  | 73  | 61  | 57  |
| MP-bt  | 76  | 69  | 57  | 59  |
| MP-IN  | 65  | 76  | 74  | 72  |
| MP-yr  | 67  | 63  | 61  | 69  |
