SET enable_nestloop TO true; SET enable_mergejoin TO false; SET enable_hashjoin TO false; -- Indexed nested loop
SET enable_mergejoin TO true; SET enable_nestloop TO false; SET enable_hashjoin TO false; -- Sort-merge join
SET enable_hashjoin TO true; SET enable_nestloop TO false; SET enable_mergejoin TO false; -- Hash join
