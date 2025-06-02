# Default strategy testing
### No index

#### Query 1: no additional filter
 Hash Join  (cost=67980.32..200318.26 rows=3095201 width=82) (actual time=268.436..1256.236 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57784.01 rows=3095201 width=38) (actual time=0.015..128.833 rows=3095201 loops=1)
   ->  Hash  (cost=34500.14..34500.14 rows=1233214 width=89) (actual time=267.856..267.856 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34500.14 rows=1233214 width=89) (actual time=4.506..93.769 rows=1233214 loops=1)
 Planning Time: 0.645 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.336 ms (Deform 0.193 ms), Inlining 0.000 ms, Optimization 0.193 ms, Emission 4.314 ms, Total 4.843 ms
 Execution Time: 1342.606 ms
(12 řádek)

**10 runs, 1352.0 ms/run → 0 runs/s**
#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44039.69 rows=24 width=67) (actual time=8.717..65.604 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43037.29 rows=10 width=67) (actual time=2.740..55.269 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42952.84 rows=10 width=23) (actual time=2.474..49.591 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using uc_publ on publ p  (cost=0.43..8.45 rows=1 width=89) (actual time=0.092..0.092 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.559 ms
 Execution Time: 65.646 ms
(11 řádek)

**10 runs, 46.5 ms/run → 21 runs/s**
### Unique index

#### Query 1: no additional filter
 Hash Join  (cost=67980.32..200318.26 rows=3095201 width=83) (actual time=288.412..1282.322 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57784.01 rows=3095201 width=38) (actual time=0.016..130.529 rows=3095201 loops=1)
   ->  Hash  (cost=34500.14..34500.14 rows=1233214 width=90) (actual time=287.270..287.270 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34500.14 rows=1233214 width=90) (actual time=5.976..110.506 rows=1233214 loops=1)
 Planning Time: 0.708 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.374 ms (Deform 0.216 ms), Inlining 0.000 ms, Optimization 0.271 ms, Emission 5.712 ms, Total 6.357 ms
 Execution Time: 1370.417 ms
(12 řádek)

**10 runs, 1369.0 ms/run → 0 runs/s**
#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44039.69 rows=24 width=68) (actual time=1.213..48.375 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43037.29 rows=10 width=68) (actual time=1.909..45.399 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42952.84 rows=10 width=23) (actual time=1.879..44.250 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.43..8.45 rows=1 width=90) (actual time=0.018..0.018 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.703 ms
 Execution Time: 48.423 ms
(11 řádek)

**10 runs, 46.7 ms/run → 21 runs/s**
### Clustering index on both tables

#### Query 1: no additional filter
 Hash Join  (cost=68023.32..200338.26 rows=3095201 width=82) (actual time=298.481..1312.751 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.008..144.214 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=89) (actual time=298.199..298.200 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=89) (actual time=3.966..114.534 rows=1233214 loops=1)
 Planning Time: 0.612 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.244 ms (Deform 0.138 ms), Inlining 0.000 ms, Optimization 0.212 ms, Emission 3.770 ms, Total 4.226 ms
 Execution Time: 1398.729 ms
(12 řádek)

**10 runs, 1382.2 ms/run → 0 runs/s**
#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.69 rows=24 width=67) (actual time=5.345..53.740 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.29 rows=10 width=67) (actual time=5.078..51.243 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=5.043..50.573 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.43..8.45 rows=1 width=89) (actual time=0.010..0.010 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.550 ms
 Execution Time: 53.777 ms
(11 řádek)

**10 runs, 50.1 ms/run → 19 runs/s**
# Strategy performance testing
## Indexed nested loop

### Non-clustering index on Publ

#### Query 1: no additional filter
 Hash Join  (cost=68023.32..200338.26 rows=3095201 width=82) (actual time=303.380..1307.567 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.011..141.152 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=89) (actual time=302.736..302.737 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=89) (actual time=4.533..110.987 rows=1233214 loops=1)
 Planning Time: 0.780 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.258 ms (Deform 0.149 ms), Inlining 0.000 ms, Optimization 0.219 ms, Emission 4.329 ms, Total 4.807 ms
 Execution Time: 1396.241 ms
(12 řádek)

**10 runs, 1396.5 ms/run → 0 runs/s**
#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.69 rows=24 width=67) (actual time=6.086..53.738 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.29 rows=10 width=67) (actual time=4.634..51.125 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=4.608..50.557 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.43..8.45 rows=1 width=89) (actual time=0.009..0.009 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.669 ms
 Execution Time: 53.795 ms
(11 řádek)

**10 runs, 51.8 ms/run → 19 runs/s**
### Non-clustering index on Auth

#### Query 1: no additional filter
 Hash Join  (cost=68023.32..200338.26 rows=3095201 width=82) (actual time=299.470..1320.262 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.010..143.210 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=89) (actual time=298.946..298.947 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=89) (actual time=3.824..110.505 rows=1233214 loops=1)
 Planning Time: 0.806 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.240 ms (Deform 0.137 ms), Inlining 0.000 ms, Optimization 0.184 ms, Emission 3.658 ms, Total 4.081 ms
 Execution Time: 1406.785 ms
(12 řádek)

**10 runs, 1415.9 ms/run → 0 runs/s**
#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.69 rows=24 width=67) (actual time=7.441..54.654 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.29 rows=10 width=67) (actual time=5.273..51.295 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=4.969..50.470 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using uc_publ on publ p  (cost=0.43..8.45 rows=1 width=89) (actual time=0.013..0.013 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.729 ms
 Execution Time: 54.702 ms
(11 řádek)

**10 runs, 51.4 ms/run → 19 runs/s**
### Non-clustering index on both tables

#### Query 1: no additional filter
 Hash Join  (cost=68023.32..200338.26 rows=3095201 width=82) (actual time=276.759..1294.978 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.009..143.658 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=89) (actual time=276.121..276.122 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=89) (actual time=4.161..97.797 rows=1233214 loops=1)
 Planning Time: 0.651 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.265 ms (Deform 0.152 ms), Inlining 0.000 ms, Optimization 0.178 ms, Emission 4.000 ms, Total 4.443 ms
 Execution Time: 1383.700 ms
(12 řádek)

**10 runs, 1396.6 ms/run → 0 runs/s**
#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.79 rows=25 width=67) (actual time=6.930..55.845 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.29 rows=10 width=67) (actual time=5.518..52.724 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=5.483..52.145 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.43..8.45 rows=1 width=89) (actual time=0.009..0.009 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.696 ms
 Execution Time: 55.893 ms
(11 řádek)

**10 runs, 51.2 ms/run → 19 runs/s**
## Sort-merge join

### Non-clustering index on Publ

#### Query 1: no additional filter
 Hash Join  (cost=68023.32..200338.26 rows=3095201 width=82) (actual time=280.851..1286.608 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.009..141.338 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=89) (actual time=280.191..280.192 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=89) (actual time=3.819..100.971 rows=1233214 loops=1)
 Planning Time: 0.705 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.237 ms (Deform 0.135 ms), Inlining 0.000 ms, Optimization 0.219 ms, Emission 3.618 ms, Total 4.074 ms
 Execution Time: 1372.528 ms
(12 řádek)

**10 runs, 1389.0 ms/run → 0 runs/s**
#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.69 rows=24 width=67) (actual time=5.331..51.947 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.29 rows=10 width=67) (actual time=4.111..49.083 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=4.084..48.533 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.43..8.45 rows=1 width=89) (actual time=0.008..0.008 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.465 ms
 Execution Time: 52.001 ms
(11 řádek)

**10 runs, 51.6 ms/run → 19 runs/s**
### Non-clustering index on Auth

#### Query 1: no additional filter
 Hash Join  (cost=68023.32..200338.26 rows=3095201 width=82) (actual time=278.729..1286.986 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.010..141.396 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=89) (actual time=278.081..278.082 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=89) (actual time=4.370..100.128 rows=1233214 loops=1)
 Planning Time: 0.819 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.241 ms (Deform 0.143 ms), Inlining 0.000 ms, Optimization 0.179 ms, Emission 4.208 ms, Total 4.627 ms
 Execution Time: 1372.320 ms
(12 řádek)

**10 runs, 1390.7 ms/run → 0 runs/s**
#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.79 rows=25 width=67) (actual time=5.288..53.693 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.29 rows=10 width=67) (actual time=4.101..50.710 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=4.075..50.233 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using uc_publ on publ p  (cost=0.43..8.45 rows=1 width=89) (actual time=0.007..0.007 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.598 ms
 Execution Time: 53.728 ms
(11 řádek)

**10 runs, 51.7 ms/run → 19 runs/s**
### Non-clustering index on both tables

#### Query 1: no additional filter
 Hash Join  (cost=68023.32..200338.26 rows=3095201 width=83) (actual time=274.757..1288.249 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.011..143.108 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=90) (actual time=274.409..274.409 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=90) (actual time=3.829..98.743 rows=1233214 loops=1)
 Planning Time: 0.756 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.239 ms (Deform 0.138 ms), Inlining 0.000 ms, Optimization 0.187 ms, Emission 3.659 ms, Total 4.085 ms
 Execution Time: 1376.103 ms
(12 řádek)

**10 runs, 1376.9 ms/run → 0 runs/s**
#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.69 rows=24 width=68) (actual time=5.477..56.483 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.29 rows=10 width=68) (actual time=4.163..53.268 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=4.137..52.690 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.43..8.45 rows=1 width=90) (actual time=0.009..0.009 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.752 ms
 Execution Time: 56.569 ms
(11 řádek)

**10 runs, 51.9 ms/run → 19 runs/s**
## Hash join

### Non-clustering index on Publ

#### Query 1: no additional filter
 Hash Join  (cost=68023.32..200338.26 rows=3095201 width=82) (actual time=289.472..1297.949 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.067..143.480 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=89) (actual time=289.076..289.077 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=89) (actual time=4.443..108.022 rows=1233214 loops=1)
 Planning Time: 0.525 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.275 ms (Deform 0.158 ms), Inlining 0.000 ms, Optimization 0.225 ms, Emission 4.242 ms, Total 4.742 ms
 Execution Time: 1385.368 ms
(12 řádek)

**10 runs, 1391.7 ms/run → 0 runs/s**
#### Query 2: extra filter on Auth
 Gather  (cost=1000.00..44012.41 rows=24 width=67) (actual time=5.365..53.597 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.00..43010.01 rows=10 width=67) (actual time=4.143..50.391 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=4.119..50.018 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.00..8.02 rows=1 width=89) (actual time=0.006..0.006 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.478 ms
 Execution Time: 53.643 ms
(11 řádek)

**10 runs, 52.6 ms/run → 19 runs/s**
### Non-clustering index on Auth

#### Query 1: no additional filter
 Hash Join  (cost=68023.32..200338.26 rows=3095201 width=82) (actual time=295.521..1312.443 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.058..151.832 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=89) (actual time=294.982..294.983 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=89) (actual time=4.063..114.579 rows=1233214 loops=1)
 Planning Time: 0.686 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.272 ms (Deform 0.163 ms), Inlining 0.000 ms, Optimization 0.177 ms, Emission 3.903 ms, Total 4.352 ms
 Execution Time: 1398.171 ms
(12 řádek)

**10 runs, 1385.3 ms/run → 0 runs/s**
#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.69 rows=24 width=67) (actual time=5.325..53.301 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.29 rows=10 width=67) (actual time=4.799..50.438 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=4.764..49.859 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using uc_publ on publ p  (cost=0.43..8.45 rows=1 width=89) (actual time=0.009..0.009 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.483 ms
 Execution Time: 53.335 ms
(11 řádek)

**10 runs, 52.5 ms/run → 19 runs/s**
### Non-clustering index on both tables

#### Query 1: no additional filter
 Hash Join  (cost=68023.32..200338.26 rows=3095201 width=82) (actual time=283.118..1291.211 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.029..142.387 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=89) (actual time=282.448..282.448 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=89) (actual time=5.914..101.392 rows=1233214 loops=1)
 Planning Time: 0.721 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.374 ms (Deform 0.220 ms), Inlining 0.000 ms, Optimization 0.254 ms, Emission 5.675 ms, Total 6.304 ms
 Execution Time: 1379.729 ms
(12 řádek)

**10 runs, 1401.7 ms/run → 0 runs/s**
#### Query 2: extra filter on Auth
 Gather  (cost=1000.00..44012.51 rows=25 width=67) (actual time=5.812..53.142 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.00..43010.01 rows=10 width=67) (actual time=4.410..50.492 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=4.385..50.180 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.00..8.02 rows=1 width=89) (actual time=0.005..0.005 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.598 ms
 Execution Time: 53.181 ms
(11 řádek)

**10 runs, 51.0 ms/run → 19 runs/s**
