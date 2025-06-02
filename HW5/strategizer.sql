SET enable_mergejoin TO true; SET enable_nestloop TO false; SET enable_hashjoin TO false; -- 0 5 2 -- Sort-merge join
SET enable_hashjoin TO true; SET enable_nestloop TO false; SET enable_mergejoin TO false; -- 0 -- Hash join
SET enable_nestloop TO true; SET enable_mergejoin TO true; SET enable_hashjoin TO true; -- 0 1 2 -- Default strategy
SET enable_nestloop TO true; SET enable_mergejoin TO false; SET enable_hashjoin TO false; -- 3 4 5 -- Indexed nested loop join
