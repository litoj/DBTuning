## Sort-merge join

### No index


#### Query 1: no additional filter
 Gather  (cost=527871.98..866262.76 rows=3095201 width=82) (actual time=6277.072..7669.212 rows=3095201 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Merge Join  (cost=526871.98..555742.66 rows=1289667 width=82) (actual time=6156.100..7141.282 rows=1031734 loops=3)
         Merge Cond: ((a.pubid)::text = (p.pubid)::text)
         ->  Sort  (cost=241152.63..244376.80 rows=1289667 width=38) (actual time=2165.420..2263.083 rows=1031734 loops=3)
               Sort Key: a.pubid
               Sort Method: external merge  Disk: 44736kB
               Worker 0:  Sort Method: external merge  Disk: 57400kB
               Worker 1:  Sort Method: external merge  Disk: 46288kB
               ->  Parallel Seq Scan on auth a  (cost=0.00..39728.67 rows=1289667 width=38) (actual time=0.021..61.982 rows=1031734 loops=3)
         ->  Materialize  (cost=285719.35..291885.42 rows=1233214 width=89) (actual time=3914.511..4325.330 rows=1860195 loops=3)
               ->  Sort  (cost=285719.35..288802.38 rows=1233214 width=89) (actual time=3914.505..4209.916 rows=1232985 loops=3)
                     Sort Key: p.pubid
                     Sort Method: external merge  Disk: 121608kB
                     Worker 0:  Sort Method: external merge  Disk: 121592kB
                     Worker 1:  Sort Method: external merge  Disk: 121592kB
                     ->  Seq Scan on publ p  (cost=0.00..34500.14 rows=1233214 width=89) (actual time=0.045..110.273 rows=1233214 loops=3)
 Planning Time: 0.450 ms
 JIT:
   Functions: 27
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 0.683 ms (Deform 0.439 ms), Inlining 91.656 ms, Optimization 75.714 ms, Emission 52.513 ms, Total 220.566 ms
 Execution Time: 7783.377 ms
**10 runs, 8222.8 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=168913.57..171483.91 rows=25 width=67) (actual time=1332.552..1541.898 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Merge Join  (cost=167913.57..170481.41 rows=10 width=67) (actual time=1316.216..1500.892 rows=61 loops=3)
         Merge Cond: ((p.pubid)::text = (a.pubid)::text)
         ->  Sort  (cost=102390.98..103675.58 rows=513839 width=89) (actual time=1166.974..1298.728 rows=409985 loops=3)
               Sort Key: p.pubid
               Sort Method: external merge  Disk: 44200kB
               Worker 0:  Sort Method: external merge  Disk: 44704kB
               Worker 1:  Sort Method: external merge  Disk: 32784kB
               ->  Parallel Seq Scan on publ p  (cost=0.00..27306.39 rows=513839 width=89) (actual time=4.297..40.177 rows=411071 loops=3)
         ->  Sort  (cost=65522.59..65522.66 rows=25 width=23) (actual time=132.853..132.864 rows=183 loops=3)
               Sort Key: a.pubid
               Sort Method: quicksort  Memory: 25kB
               Worker 0:  Sort Method: quicksort  Memory: 25kB
               Worker 1:  Sort Method: quicksort  Memory: 25kB
               ->  Seq Scan on auth a  (cost=0.00..65522.01 rows=25 width=23) (actual time=8.273..132.628 rows=183 loops=3)
                     Filter: ((name)::text = 'Divesh Srivastava'::text)
                     Rows Removed by Filter: 3095018
 Planning Time: 0.505 ms
 JIT:
   Functions: 36
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.974 ms (Deform 0.508 ms), Inlining 0.000 ms, Optimization 0.652 ms, Emission 12.271 ms, Total 13.896 ms
 Execution Time: 1555.207 ms
**10 runs, 1620.7 ms/run**
### Non-clustering index on both tables


#### Query 1: no additional filter
 Merge Join  (cost=0.86..234989.63 rows=3095201 width=82) (actual time=2.964..1501.408 rows=3095201 loops=1)
   Merge Cond: ((p.pubid)::text = (a.pubid)::text)
   ->  Index Scan using idx_publ on publ p  (cost=0.43..73755.18 rows=1233214 width=89) (actual time=0.013..236.410 rows=1233208 loops=1)
   ->  Index Scan using idx_auth on auth a  (cost=0.43..119508.76 rows=3095201 width=38) (actual time=0.015..384.190 rows=3095201 loops=1)
 Planning Time: 0.806 ms
 JIT:
   Functions: 7
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.165 ms (Deform 0.102 ms), Inlining 0.000 ms, Optimization 0.150 ms, Emission 2.778 ms, Total 3.093 ms
 Execution Time: 1590.769 ms
**10 runs, 1751.7 ms/run**

#### Query 2: extra filter on Auth
 Merge Join  (cost=43956.35..120747.16 rows=25 width=67) (actual time=84.404..432.487 rows=183 loops=1)
   Merge Cond: ((p.pubid)::text = (a.pubid)::text)
   ->  Index Scan using idx_publ on publ p  (cost=0.43..73755.18 rows=1233214 width=89) (actual time=0.016..205.544 rows=1229956 loops=1)
   ->  Sort  (cost=43955.92..43955.98 rows=25 width=23) (actual time=52.140..52.220 rows=183 loops=1)
         Sort Key: a.pubid
         Sort Method: quicksort  Memory: 25kB
         ->  Gather  (cost=1000.00..43955.34 rows=25 width=23) (actual time=0.355..52.016 rows=183 loops=1)
               Workers Planned: 2
               Workers Launched: 2
               ->  Parallel Seq Scan on auth a  (cost=0.00..42952.84 rows=10 width=23) (actual time=2.912..44.884 rows=61 loops=3)
                     Filter: ((name)::text = 'Divesh Srivastava'::text)
                     Rows Removed by Filter: 1031673
 Planning Time: 0.915 ms
 JIT:
   Functions: 18
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.630 ms (Deform 0.269 ms), Inlining 0.000 ms, Optimization 0.447 ms, Emission 7.863 ms, Total 8.940 ms
 Execution Time: 442.464 ms
**10 runs, 522.3 ms/run**
### Clustering index on both tables


#### Query 1: no additional filter
 Merge Join  (cost=0.86..218718.13 rows=3095201 width=82) (actual time=4.208..2270.720 rows=3095201 loops=1)
   Merge Cond: ((p.pubid)::text = (a.pubid)::text)
   ->  Index Scan using idx_publ on publ p  (cost=0.43..66792.64 rows=1233214 width=89) (actual time=0.008..251.363 rows=1233208 loops=1)
   ->  Index Scan using idx_auth on auth a  (cost=0.43..110152.45 rows=3095201 width=38) (actual time=0.014..499.206 rows=3095201 loops=1)
 Planning Time: 0.816 ms
 JIT:
   Functions: 7
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.205 ms (Deform 0.127 ms), Inlining 0.000 ms, Optimization 0.180 ms, Emission 3.993 ms, Total 4.378 ms
 Execution Time: 2424.345 ms
**10 runs, 1867.7 ms/run**

#### Query 2: extra filter on Auth
 Merge Join  (cost=43933.22..113808.82 rows=24 width=67) (actual time=99.223..561.750 rows=183 loops=1)
   Merge Cond: ((p.pubid)::text = (a.pubid)::text)
   ->  Index Scan using idx_publ on publ p  (cost=0.43..66792.64 rows=1233214 width=89) (actual time=0.006..233.520 rows=1229956 loops=1)
   ->  Sort  (cost=43932.79..43932.85 rows=24 width=23) (actual time=57.851..57.947 rows=183 loops=1)
         Sort Key: a.pubid
         Sort Method: quicksort  Memory: 25kB
         ->  Gather  (cost=1000.00..43932.24 rows=24 width=23) (actual time=12.276..57.652 rows=183 loops=1)
               Workers Planned: 2
               Workers Launched: 2
               ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=5.644..50.810 rows=61 loops=3)
                     Filter: ((name)::text = 'Divesh Srivastava'::text)
                     Rows Removed by Filter: 1031673
 Planning Time: 0.856 ms
 JIT:
   Functions: 18
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.575 ms (Deform 0.256 ms), Inlining 0.000 ms, Optimization 0.400 ms, Emission 7.738 ms, Total 8.713 ms
 Execution Time: 571.839 ms
**10 runs, 415.1 ms/run**
## Hash join

### No index


#### Query 1: no additional filter
 Hash Join  (cost=68023.32..234772.34 rows=3095201 width=82) (actual time=309.343..1484.444 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.035..152.836 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=89) (actual time=308.990..308.992 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=89) (actual time=4.216..121.832 rows=1233214 loops=1)
 Planning Time: 0.342 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.323 ms (Deform 0.179 ms), Inlining 0.000 ms, Optimization 0.310 ms, Emission 3.908 ms, Total 4.541 ms
 Execution Time: 1574.622 ms
**10 runs, 1988.0 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=43929.96..73208.69 rows=24 width=67) (actual time=57.687..111.879 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Hash Join  (cost=42929.96..72206.29 rows=10 width=67) (actual time=54.527..108.368 rows=61 loops=3)
         Hash Cond: ((p.pubid)::text = (a.pubid)::text)
         ->  Parallel Seq Scan on publ p  (cost=0.00..27349.39 rows=513839 width=89) (actual time=0.018..28.584 rows=411071 loops=3)
         ->  Parallel Hash  (cost=42929.84..42929.84 rows=10 width=23) (actual time=49.074..49.075 rows=61 loops=3)
               Buckets: 1024  Batches: 1  Memory Usage: 104kB
               ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=4.131..49.027 rows=61 loops=3)
                     Filter: ((name)::text = 'Divesh Srivastava'::text)
                     Rows Removed by Filter: 1031673
 Planning Time: 0.455 ms
 Execution Time: 111.922 ms
**10 runs, 113.2 ms/run**
## Default strategy

### No index


#### Query 1: no additional filter
 Hash Join  (cost=68023.32..234772.34 rows=3095201 width=82) (actual time=302.418..1387.724 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.020..154.446 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=89) (actual time=302.082..302.083 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=89) (actual time=3.822..116.327 rows=1233214 loops=1)
 Planning Time: 0.552 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.250 ms (Deform 0.138 ms), Inlining 0.000 ms, Optimization 0.172 ms, Emission 3.659 ms, Total 4.081 ms
 Execution Time: 1478.135 ms
**10 runs, 1712.9 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=43929.96..73208.69 rows=24 width=67) (actual time=61.976..120.986 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Hash Join  (cost=42929.96..72206.29 rows=10 width=67) (actual time=60.599..116.786 rows=61 loops=3)
         Hash Cond: ((p.pubid)::text = (a.pubid)::text)
         ->  Parallel Seq Scan on publ p  (cost=0.00..27349.39 rows=513839 width=89) (actual time=0.018..28.947 rows=411071 loops=3)
         ->  Parallel Hash  (cost=42929.84..42929.84 rows=10 width=23) (actual time=55.682..55.682 rows=61 loops=3)
               Buckets: 1024  Batches: 1  Memory Usage: 104kB
               ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=5.609..55.625 rows=61 loops=3)
                     Filter: ((name)::text = 'Divesh Srivastava'::text)
                     Rows Removed by Filter: 1031673
 Planning Time: 0.469 ms
 Execution Time: 121.037 ms
**10 runs, 113.1 ms/run**
### Unique index


#### Query 1: no additional filter
 Hash Join  (cost=68023.32..200338.26 rows=3095201 width=83) (actual time=306.989..1943.717 rows=3095201 loops=1)
   Hash Cond: ((a.pubid)::text = (p.pubid)::text)
   ->  Seq Scan on auth a  (cost=0.00..57761.01 rows=3095201 width=38) (actual time=0.015..227.198 rows=3095201 loops=1)
   ->  Hash  (cost=34543.14..34543.14 rows=1233214 width=90) (actual time=306.598..306.599 rows=1233214 loops=1)
         Buckets: 65536  Batches: 32  Memory Usage: 5111kB
         ->  Seq Scan on publ p  (cost=0.00..34543.14 rows=1233214 width=90) (actual time=3.893..118.171 rows=1233214 loops=1)
 Planning Time: 0.522 ms
 JIT:
   Functions: 11
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.543 ms (Deform 0.418 ms), Inlining 0.000 ms, Optimization 0.211 ms, Emission 3.696 ms, Total 4.449 ms
 Execution Time: 2082.733 ms
**10 runs, 1955.4 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.69 rows=24 width=68) (actual time=6.693..59.127 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.29 rows=10 width=68) (actual time=5.002..55.766 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=4.943..54.914 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.43..8.45 rows=1 width=90) (actual time=0.013..0.013 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.741 ms
 Execution Time: 59.173 ms
**10 runs, 54.9 ms/run**
### Clustering index on both tables


#### Query 1: no additional filter
 Merge Join  (cost=0.86..218718.13 rows=3095201 width=82) (actual time=4.288..2007.943 rows=3095201 loops=1)
   Merge Cond: ((p.pubid)::text = (a.pubid)::text)
   ->  Index Scan using idx_publ on publ p  (cost=0.43..66792.64 rows=1233214 width=89) (actual time=0.008..229.422 rows=1233208 loops=1)
   ->  Index Scan using idx_auth on auth a  (cost=0.43..110152.45 rows=3095201 width=38) (actual time=0.013..444.470 rows=3095201 loops=1)
 Planning Time: 0.717 ms
 JIT:
   Functions: 7
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.245 ms (Deform 0.157 ms), Inlining 0.000 ms, Optimization 0.222 ms, Emission 4.034 ms, Total 4.501 ms
 Execution Time: 2142.199 ms
**10 runs, 1761.0 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.79 rows=24 width=67) (actual time=5.779..57.710 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.39 rows=10 width=67) (actual time=4.303..53.974 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=4.276..53.347 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.43..8.45 rows=1 width=89) (actual time=0.010..0.010 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.855 ms
 Execution Time: 57.763 ms
**10 runs, 53.5 ms/run**
## Indexed nested loop join

### Non-clustering index on Publ


#### Query 1: no additional filter
 Gather  (cost=1000.43..984909.25 rows=3095201 width=82) (actual time=77.433..4970.177 rows=3095201 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..674389.15 rows=1289667 width=82) (actual time=70.304..4881.436 rows=1031734 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..39705.67 rows=1289667 width=38) (actual time=0.018..65.043 rows=1031734 loops=3)
         ->  Index Scan using idx_publ on publ p  (cost=0.43..0.48 rows=1 width=89) (actual time=0.004..0.004 rows=1 loops=3095201)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.396 ms
 JIT:
   Functions: 18
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 0.607 ms (Deform 0.277 ms), Inlining 121.729 ms, Optimization 50.338 ms, Emission 38.586 ms, Total 211.260 ms
 Execution Time: 5084.583 ms
**10 runs, 5358.0 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.79 rows=24 width=67) (actual time=5.687..52.973 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.39 rows=10 width=67) (actual time=4.322..50.385 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=4.294..49.761 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.43..8.45 rows=1 width=89) (actual time=0.010..0.010 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.656 ms
 Execution Time: 53.019 ms
**10 runs, 51.7 ms/run**
### Non-clustering index on Auth


#### Query 1: no additional filter
 Gather  (cost=1000.43..675404.20 rows=3095201 width=83) (actual time=63.124..2149.477 rows=3095201 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..364884.10 rows=1289667 width=83) (actual time=69.434..2065.337 rows=1031734 loops=3)
         ->  Parallel Seq Scan on publ p  (cost=0.00..27349.39 rows=513839 width=90) (actual time=0.019..33.682 rows=411071 loops=3)
         ->  Index Scan using idx_auth on auth a  (cost=0.43..0.62 rows=4 width=38) (actual time=0.004..0.004 rows=3 loops=1233214)
               Index Cond: ((pubid)::text = (p.pubid)::text)
 Planning Time: 0.502 ms
 JIT:
   Functions: 18
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 0.649 ms (Deform 0.296 ms), Inlining 117.748 ms, Optimization 51.702 ms, Emission 38.613 ms, Total 208.713 ms
 Execution Time: 2242.854 ms
**10 runs, 2438.9 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..355609.72 rows=24 width=68) (actual time=153.791..2049.930 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..354607.32 rows=10 width=68) (actual time=148.325..2037.934 rows=61 loops=3)
         ->  Parallel Seq Scan on publ p  (cost=0.00..27349.39 rows=513839 width=90) (actual time=0.020..32.542 rows=411071 loops=3)
         ->  Index Scan using idx_auth on auth a  (cost=0.43..0.63 rows=1 width=23) (actual time=0.005..0.005 rows=0 loops=1233214)
               Index Cond: ((pubid)::text = (p.pubid)::text)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 3
 Planning Time: 0.695 ms
 JIT:
   Functions: 21
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 0.880 ms (Deform 0.390 ms), Inlining 0.000 ms, Optimization 0.568 ms, Emission 11.338 ms, Total 12.787 ms
 Execution Time: 2060.787 ms
**10 runs, 1965.2 ms/run**
### Non-clustering index on both tables


#### Query 1: no additional filter
 Gather  (cost=1000.43..661273.63 rows=3095201 width=83) (actual time=80.945..2187.415 rows=3095201 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..350753.53 rows=1289667 width=83) (actual time=71.995..2098.600 rows=1031734 loops=3)
         ->  Parallel Seq Scan on publ p  (cost=0.00..27349.39 rows=513839 width=90) (actual time=0.022..30.931 rows=411071 loops=3)
         ->  Index Scan using idx_auth on auth a  (cost=0.43..0.60 rows=3 width=38) (actual time=0.004..0.005 rows=3 loops=1233214)
               Index Cond: ((pubid)::text = (p.pubid)::text)
 Planning Time: 0.580 ms
 JIT:
   Functions: 18
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 0.865 ms (Deform 0.415 ms), Inlining 126.908 ms, Optimization 51.713 ms, Emission 37.118 ms, Total 216.603 ms
 Execution Time: 2306.844 ms
**10 runs, 2435.9 ms/run**

#### Query 2: extra filter on Auth
 Gather  (cost=1000.43..44016.79 rows=24 width=68) (actual time=5.717..61.940 rows=183 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Nested Loop  (cost=0.43..43014.39 rows=10 width=68) (actual time=4.489..57.905 rows=61 loops=3)
         ->  Parallel Seq Scan on auth a  (cost=0.00..42929.84 rows=10 width=23) (actual time=4.441..57.181 rows=61 loops=3)
               Filter: ((name)::text = 'Divesh Srivastava'::text)
               Rows Removed by Filter: 1031673
         ->  Index Scan using idx_publ on publ p  (cost=0.43..8.45 rows=1 width=90) (actual time=0.011..0.011 rows=1 loops=183)
               Index Cond: ((pubid)::text = (a.pubid)::text)
 Planning Time: 0.497 ms
 Execution Time: 61.991 ms
**10 runs, 60.8 ms/run**
