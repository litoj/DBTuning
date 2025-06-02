## Default strategy

### No index

#### Query 1: no additional filter
 Hash Join  (cost=68023.32..234772.34 rows=3095201 width=83) (actual time=498.144..2370.618 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.231..254.791 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=90) (actual time=497.472..497.473 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=90) (actual time=6.299..176.094 rows=1233214 loops=1)
 Planning Time: 0.590 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.399 ms (Deform 0.238 ms), Inlining 0.000 ms, Optimization 0.268 ms, Emission 6.044 ms, Total 6.712 ms
 Execution Time: 2521.709 ms
**50 runs, 2532.3 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=43929.96..73208.69 rows=24 width=68) (actual time=84.346..168.652 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Hash Join  (cost=42929.96..72206.29 rows=10 width=68) (actual time=83.807..163.556 rows=61 loops=3)
         Hash Cond: ((p.pubid)::text = (a.pubid)::text)
         ->  Parallel Seq Scan on publ p  (cost=0.00..27349.39 rows=513839 width=90) (actual time=0.024..40.763 rows=411071 loops=3)
         ->  Parallel Hash  (cost=42929.84..42929.84 rows=10 width=23) (actual time=75.437..75.438 rows=61 loops=3)
               Buckets: 1024  Batches: 1  Memory Usage: 104kB
               ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=6.351..75.367 rows=61 loops=3)
                     Filter: ((name)::text = 'Divesh Srivastava'::text)
                     Rows Removed by Filter: 1031673
 Planning Time: 0.594 ms
 Execution Time: 168.712 ms
**50 runs, 168.9 ms/run**

### Unique index

#### Query 1: no additional filter
 Hash Join  (cost=68023.32..200338.26 rows=3095201 width=82) (actual time=503.750..2302.419 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.037..253.769 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=89) (actual time=503.281..503.282 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=89) (actual time=6.306..183.317 rows=1233214 loops=1)
 Planning Time: 0.729 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.400 ms (Deform 0.227 ms), Inlining 0.000 ms, Optimization 0.262 ms, Emission 6.066 ms, Total 6.727 ms
 Execution Time: 2454.323 ms
**50 runs, 2478.4 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.69 rows=24 width=67) (actual time=8.138..80.327 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.29 rows=10 width=67) (actual time=6.306..76.222 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=6.266..75.313 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.43..8.45 rows=1 width=89) (actual time=0.014..0.014 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.696 ms
 Execution Time: 80.379 ms
**50 runs, 80.6 ms/run**

### Clustering index on both tables

#### Query 1: no additional filter
 Merge Join  (cost=0.86..218718.13 rows=3095201 width=82) (actual time=4.761..2223.383 rows=3095201 loops=1)
   Merge Cond: ((p.pubid)::text = (a.pubid)::text)
   ->  Index Scan using idx_publ on publ p  (cost=0.43..66792.64 rows=1233214 width=89) (actual time=0.008..256.151 rows=1233208 loops=1)
   ->  Index Scan using idx_auth on auth a  (cost=0.43..110152.45 rows=3095201 width=38) (actual time=0.013..496.768 rows=3095201 loops=1)
 Planning Time: 0.951 ms
 JIT:
   Functions: 7
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.277 ms (Deform 0.182 ms), Inlining 0.000 ms, Optimization 0.224 ms, Emission 4.504 ms, Total 5.006 ms
 Execution Time: 2374.382 ms
**50 runs, 2376.1 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.69 rows=23 width=67) (actual time=8.045..80.783 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.39 rows=10 width=67) (actual time=6.233..76.335 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=6.195..75.471 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.43..8.45 rows=1 width=89) (actual time=0.013..0.013 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.989 ms
 Execution Time: 80.834 ms
**50 runs, 81.0 ms/run**

## Indexed nested loop join

### Non-clustering index on Publ

#### Query 1: no additional filter
 Gather  (cost=1000.43..984909.25 rows=3095201 width=82) (actual time=100.399..7289.111 rows=3095201 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..674389.15 rows=1289667 width=82) (actual time=98.950..7158.489 rows=1031734 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..39705.67 rows=1289667 width=38) (actual time=0.028..90.087 rows=1031734 loops=3)
         ->  Index Scan using idx_publ on publ p  (cost=0.43..0.48 rows=1 width=89) (actual time=0.006..0.006 rows=1 loops=3095201)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.557 ms
 JIT:
   Functions: 18
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 0.931 ms (Deform 0.389 ms), Inlining 169.090 ms, Optimization 74.145 ms, Emission 53.321 ms, Total 297.486 ms
 Execution Time: 7444.450 ms
**50 runs, 7465.7 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.79 rows=24 width=67) (actual time=8.089..79.195 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.39 rows=10 width=67) (actual time=6.299..75.678 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=6.249..74.744 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.43..8.45 rows=1 width=89) (actual time=0.014..0.015 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.726 ms
 Execution Time: 79.252 ms
**50 runs, 80.5 ms/run**

### Non-clustering index on Auth

#### Query 1: no additional filter
 Gather  (cost=1000.43..661273.63 rows=3095201 width=82) (actual time=107.044..3275.159 rows=3095201 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..350753.53 rows=1289667 width=82) (actual time=106.996..3148.883 rows=1031734 loops=3)
         ->  Parallel Seq Scan on publ p  (cost=0.00..27349.39 rows=513839 width=89) (actual time=0.028..47.767 rows=411071 loops=3)
         ->  Index Scan using idx_auth on auth a  (cost=0.43..0.60 rows=3 width=38) (actual time=0.006..0.007 rows=3 loops=1233214)
               Index Cond: ((pubid)::text = (p.pubid)::text)
 Planning Time: 0.599 ms
 JIT:
   Functions: 18
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 0.917 ms (Deform 0.431 ms), Inlining 176.963 ms, Optimization 84.054 ms, Emission 59.632 ms, Total 321.566 ms
 Execution Time: 3429.478 ms
**50 runs, 3421.4 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..345332.94 rows=24 width=67) (actual time=216.150..2929.567 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..344330.54 rows=10 width=67) (actual time=245.647..2916.121 rows=61 loops=3)
         ->  Parallel Seq Scan on publ p  (cost=0.00..27349.39 rows=513839 width=89) (actual time=0.023..45.767 rows=411071 loops=3)
         ->  Index Scan using idx_auth on auth a  (cost=0.43..0.61 rows=1 width=23) (actual time=0.007..0.007 rows=0 loops=1233214)
               Index Cond: ((pubid)::text = (p.pubid)::text)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 3
 Planning Time: 0.728 ms
 JIT:
   Functions: 21
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.958 ms (Deform 0.409 ms), Inlining 0.000 ms, Optimization 0.625 ms, Emission 12.739 ms, Total 14.322 ms
 Execution Time: 2940.884 ms
**50 runs, 2950.7 ms/run**

### Non-clustering index on both tables

#### Query 1: no additional filter
 Gather  (cost=1000.43..661273.63 rows=3095201 width=82) (actual time=106.108..3261.928 rows=3095201 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..350753.53 rows=1289667 width=82) (actual time=103.366..3138.301 rows=1031734 loops=3)
         ->  Parallel Seq Scan on publ p  (cost=0.00..27349.39 rows=513839 width=89) (actual time=0.021..45.631 rows=411071 loops=3)
         ->  Index Scan using idx_auth on auth a  (cost=0.43..0.60 rows=3 width=38) (actual time=0.006..0.007 rows=3 loops=1233214)
               Index Cond: ((pubid)::text = (p.pubid)::text)
 Planning Time: 0.680 ms
 JIT:
   Functions: 18
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 0.894 ms (Deform 0.415 ms), Inlining 170.292 ms, Optimization 81.834 ms, Emission 57.698 ms, Total 310.718 ms
 Execution Time: 3417.031 ms
**50 runs, 3426.0 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.79 rows=24 width=67) (actual time=8.418..85.260 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.39 rows=10 width=67) (actual time=6.279..79.194 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=6.233..78.171 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.43..8.45 rows=1 width=89) (actual time=0.016..0.016 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.825 ms
 Execution Time: 85.321 ms
**50 runs, 84.2 ms/run**

## Sort-merge join

### No index

#### Query 1: no additional filter
 Gather  (cost=527871.98..866262.76 rows=3095201 width=82) (actual time=8903.908..10926.669 rows=3095201 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Merge Join  (cost=526871.98..555742.66 rows=1289667 width=82) (actual time=8878.997..10452.770 rows=1031734 loops=3)
         Merge Cond: ((a.pubid)::text = (p.pubid)::text)
         ->  Sort  (cost=241152.63..244376.80 rows=1289667 width=38) (actual time=3137.959..3296.908 rows=1031734 loops=3)
               Sort Key: a.pubid
               Sort Method: external merge  Disk: 49320kB
               Worker 0:  Sort Method: external merge  Disk: 48736kB
               Worker 1:  Sort Method: external merge  Disk: 50400kB
               ->  Parallel Seq Scan on auth a  (cost=0.00..39728.67 rows=1289667 width=38) (actual time=0.031..87.435 rows=1031734 loops=3)
         ->  Materialize  (cost=285719.35..291885.42 rows=1233214 width=89) (actual time=5632.210..6282.711 rows=1860177 loops=3)
               ->  Sort  (cost=285719.35..288802.38 rows=1233214 width=89) (actual time=5632.203..6098.537 rows=1232987 loops=3)
                     Sort Key: p.pubid
                     Sort Method: external merge  Disk: 121592kB
                     Worker 0:  Sort Method: external merge  Disk: 121608kB
                     Worker 1:  Sort Method: external merge  Disk: 121592kB
                     ->  Seq Scan on publ p  (cost=0.00..34500.14 rows=1233214 width=89) (actual time=0.041..146.475 rows=1233214 loops=3)
 Planning Time: 0.561 ms
 JIT:
   Functions: 27
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 0.940 ms (Deform 0.594 ms), Inlining 132.285 ms, Optimization 109.959 ms, Emission 76.132 ms, Total 319.315 ms
 Execution Time: 11098.809 ms
**50 runs, 11142.9 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=168913.57..171483.91 rows=25 width=67) (actual time=1961.484..2235.423 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Merge Join  (cost=167913.57..170481.41 rows=10 width=67) (actual time=1900.951..2162.856 rows=61 loops=3)
         Merge Cond: ((p.pubid)::text = (a.pubid)::text)
         ->  Sort  (cost=102390.98..103675.58 rows=513839 width=89) (actual time=1683.941..1873.347 rows=409985 loops=3)
               Sort Key: p.pubid
               Sort Method: external merge  Disk: 41464kB
               Worker 0:  Sort Method: external merge  Disk: 38648kB
               Worker 1:  Sort Method: external merge  Disk: 41592kB
               ->  Parallel Seq Scan on publ p  (cost=0.00..27306.39 rows=513839 width=89) (actual time=5.968..56.465 rows=411071 loops=3)
         ->  Sort  (cost=65522.59..65522.66 rows=25 width=23) (actual time=191.563..191.580 rows=182 loops=3)
               Sort Key: a.pubid
               Sort Method: quicksort  Memory: 25kB
               Worker 0:  Sort Method: quicksort  Memory: 25kB
               Worker 1:  Sort Method: quicksort  Memory: 25kB
               ->  Seq Scan on auth a  (cost=0.00..65522.01 rows=25 width=23) (actual time=13.807..191.201 rows=183 loops=3)
                     Filter: ((name)::text = 'Divesh Srivastava'::text)
                     Rows Removed by Filter: 3095018
 Planning Time: 0.572 ms
 JIT:
   Functions: 36
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 1.283 ms (Deform 0.676 ms), Inlining 0.000 ms, Optimization 0.836 ms, Emission 17.120 ms, Total 19.239 ms
 Execution Time: 2251.223 ms
**50 runs, 2225.5 ms/run**

### Non-clustering index on both tables

#### Query 1: no additional filter
 Merge Join  (cost=0.86..234895.05 rows=3095201 width=83) (actual time=4.655..2538.639 rows=3095201 loops=1)
   Merge Cond: ((p.pubid)::text = (a.pubid)::text)
   ->  Index Scan using idx_publ on publ p  (cost=0.43..73722.61 rows=1233214 width=90) (actual time=0.017..387.454 rows=1233208 loops=1)
   ->  Index Scan using idx_auth on auth a  (cost=0.43..119446.72 rows=3095201 width=38) (actual time=0.029..619.388 rows=3095201 loops=1)
 Planning Time: 1.363 ms
 JIT:
   Functions: 7
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.273 ms (Deform 0.175 ms), Inlining 0.000 ms, Optimization 0.221 ms, Emission 4.376 ms, Total 4.870 ms
 Execution Time: 2690.349 ms
**50 runs, 2685.6 ms/run**

#### Query 2: extra filter on Auth
 Merge Join  (cost=43956.22..120714.46 rows=24 width=68) (actual time=131.510..732.951 rows=183 loops=1)
   Merge Cond: ((p.pubid)::text = (a.pubid)::text)
   ->  Index Scan using idx_publ on publ p  (cost=0.43..73722.61 rows=1233214 width=90) (actual time=0.024..349.205 rows=1229956 loops=1)
   ->  Sort  (cost=43955.79..43955.85 rows=24 width=23) (actual time=78.288..78.387 rows=183 loops=1)
         Sort Key: a.pubid
         Sort Method: quicksort  Memory: 25kB
         ->  Gather  (cost=1000.00..43955.24 rows=24 width=23) (actual time=14.603..78.037 rows=183 loops=1)
               Workers Planned: 2
               Workers Launched: 2
               ->  Parallel Seq Scan on auth a  (cost=0.00..42952.84 rows=10 width=23) (actual time=8.056..68.112 rows=61 loops=3)
                     Filter: ((name)::text = 'Divesh Srivastava'::text)
                     Rows Removed by Filter: 1031673
 Planning Time: 0.968 ms
 JIT:
   Functions: 18
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.861 ms (Deform 0.359 ms), Inlining 0.000 ms, Optimization 0.563 ms, Emission 10.499 ms, Total 11.923 ms
 Execution Time: 744.733 ms
**50 runs, 758.8 ms/run**

### Clustering index on both tables

#### Query 1: no additional filter
 Merge Join  (cost=0.86..218675.07 rows=3095201 width=82) (actual time=4.945..2219.743 rows=3095201 loops=1)
   Merge Cond: ((p.pubid)::text = (a.pubid)::text)
   ->  Index Scan using idx_publ on publ p  (cost=0.43..66792.64 rows=1233214 width=89) (actual time=0.009..248.213 rows=1233208 loops=1)
   ->  Index Scan using idx_auth on auth a  (cost=0.43..110152.45 rows=3095201 width=38) (actual time=0.014..491.207 rows=3095201 loops=1)
 Planning Time: 0.907 ms
 JIT:
   Functions: 7
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.274 ms (Deform 0.178 ms), Inlining 0.000 ms, Optimization 0.225 ms, Emission 4.684 ms, Total 5.183 ms
 Execution Time: 2370.298 ms
**50 runs, 2370.9 ms/run**

#### Query 2: extra filter on Auth
 Merge Join  (cost=43933.22..113765.76 rows=24 width=67) (actual time=128.945..633.613 rows=183 loops=1)
   Merge Cond: ((p.pubid)::text = (a.pubid)::text)
   ->  Index Scan using idx_publ on publ p  (cost=0.43..66792.64 rows=1233214 width=89) (actual time=0.010..255.055 rows=1229956 loops=1)
   ->  Sort  (cost=43932.79..43932.85 rows=24 width=23) (actual time=82.585..82.685 rows=183 loops=1)
         Sort Key: a.pubid
         Sort Method: quicksort  Memory: 25kB
         ->  Gather  (cost=1000.00..43932.24 rows=24 width=23) (actual time=16.961..82.322 rows=183 loops=1)
               Workers Planned: 2
               Workers Launched: 2
               ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=8.715..72.776 rows=61 loops=3)
                     Filter: ((name)::text = 'Divesh Srivastava'::text)
                     Rows Removed by Filter: 1031673
 Planning Time: 0.965 ms
 JIT:
   Functions: 18
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.813 ms (Deform 0.355 ms), Inlining 0.000 ms, Optimization 0.580 ms, Emission 10.486 ms, Total 11.879 ms
 Execution Time: 645.886 ms
**50 runs, 656.9 ms/run**

## Hash join

### No index

#### Query 1: no additional filter
 Hash Join  (cost=68023.32..234772.34 rows=3095201 width=82) (actual time=507.943..2400.677 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.036..267.586 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=89) (actual time=507.505..507.506 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=89) (actual time=6.540..179.781 rows=1233214 loops=1)
 Planning Time: 0.484 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.410 ms (Deform 0.239 ms), Inlining 0.000 ms, Optimization 0.363 ms, Emission 6.187 ms, Total 6.959 ms
 Execution Time: 2553.976 ms
**50 runs, 2529.9 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=43929.96..73208.69 rows=24 width=67) (actual time=95.080..190.990 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Hash Join  (cost=42929.96..72206.29 rows=10 width=67) (actual time=91.844..184.566 rows=61 loops=3)
         Hash Cond: ((p.pubid)::text = (a.pubid)::text)
         ->  Parallel Seq Scan on publ p  (cost=0.00..27349.39 rows=513839 width=89) (actual time=0.029..49.287 rows=411071 loops=3)
         ->  Parallel Hash  (cost=42929.84..42929.84 rows=10 width=23) (actual time=84.214..84.215 rows=61 loops=3)
               Buckets: 1024  Batches: 1  Memory Usage: 104kB
               ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=6.800..84.111 rows=61 loops=3)
                     Filter: ((name)::text = 'Divesh Srivastava'::text)
                     Rows Removed by Filter: 1031673
 Planning Time: 0.541 ms
 Execution Time: 191.084 ms
**50 runs, 170.8 ms/run**

