#!/usr/bin/env python3

import os
import argparse
import time
import random
import psycopg2
from concurrent.futures import ThreadPoolExecutor, wait

def get_conn(isolation):
    conn = psycopg2.connect(
        dbname=os.getenv("PGDATABASE", "payroll"),
        user=os.getenv("PGUSER", "postgres"),
        password=os.getenv("PGPASSWORD", ""),
        host=os.getenv("PGHOST", "localhost"),
        port=os.getenv("PGPORT", "5432")
    )
    conn.set_session(isolation_level=isolation)
    return conn

def pay_a(emp_id, conn):
    with conn.cursor() as cur:
        cur.execute("SELECT balance FROM Accounts WHERE account=%s", (emp_id,))
        e = cur.fetchone()[0]
        cur.execute("UPDATE Accounts SET balance=%s WHERE account=%s", (e+1, emp_id))
        cur.execute("SELECT balance FROM Accounts WHERE account=0")
        c = cur.fetchone()[0]
        cur.execute("UPDATE Accounts SET balance=%s WHERE account=0", (c-1,))
    conn.commit()

def pay_b(emp_id, conn):
    with conn.cursor() as cur:
        cur.execute("UPDATE Accounts SET balance=balance+1 WHERE account=%s", (emp_id,))
        cur.execute("UPDATE Accounts SET balance=balance-1 WHERE account=0")
    conn.commit()

def transaction(i, variant, isolation):
    conn = get_conn(isolation)
    emp_id = (i % 100) + 1
    if variant == "a":
        pay_a(emp_id, conn)
    else:
        pay_b(emp_id, conn)
    conn.close()

def main():
    p = argparse.ArgumentParser()
    p.add_argument('-t', '--numthreads',    type=int, choices=range(1,1001), required=True,
                   help="Total transactions (e.g. 100)")
    p.add_argument('-c', '--maxconcurrent', type=int, default=1,
                   help="Max parallel threads")
    p.add_argument('--variant', choices=['a','b'], required=True,
                   help="Solution: a (read-then-update) or b (in-place)")
    p.add_argument('--isolation', choices=['READ COMMITTED','SERIALIZABLE'], required=True)
    args = p.parse_args()

    start = time.time()
    with ThreadPoolExecutor(max_workers=args.maxconcurrent) as exe:
        futures = [exe.submit(transaction, i, args.variant, args.isolation)
                   for i in range(args.numthreads)]
        wait(futures)
    duration = time.time() - start
    

    conn = get_conn(args.isolation)
    with conn.cursor() as cur:
        cur.execute("SELECT balance FROM Accounts WHERE account=0")
        row = cur.fetchone()
        if row is None:
            raise RuntimeError("No row returned for company account!")
        final = row[0]
    conn.close()


    print(f"variant={args.variant}  isolation={args.isolation}  threads={args.maxconcurrent}")
    print(f"duration={duration:.2f}s  final_balance={final}")

if __name__ == "__main__":
    main()
