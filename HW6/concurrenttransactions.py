#!/usr/bin/env python3

import os
import sys
import time
import psycopg2
from concurrent.futures import ThreadPoolExecutor, wait


def get_conn(isolation):
    conn = psycopg2.connect(
        dbname="payroll", user="postgres", password="", host="localhost", port="5432"
    )
    conn.set_session(isolation_level=isolation)
    return conn


def pay_a(emp_id, conn):
    with conn.cursor() as cur:
        cur.execute("SELECT balance FROM Accounts WHERE account=%s", (emp_id,))
        e = cur.fetchone()[0]
        cur.execute("UPDATE Accounts SET balance=%s WHERE account=%s", (e + 1, emp_id))
        cur.execute("SELECT balance FROM Accounts WHERE account=0")
        c = cur.fetchone()[0]
        cur.execute("UPDATE Accounts SET balance=%s WHERE account=0", (c - 1,))
    conn.commit()


def pay_b(emp_id, conn):
    with conn.cursor() as cur:
        cur.execute("UPDATE Accounts SET balance=balance+1 WHERE account=%s", (emp_id,))
        cur.execute("UPDATE Accounts SET balance=balance-1 WHERE account=0")
    conn.commit()


def transaction(i, variant, isolation):
    conn = get_conn(isolation)
    err = True
    while err:
        try:
            variant(i, conn)
            err = False
        except Exception:
            conn.rollback()
            err = True
    conn.close()


def main():
    STRATEGY = os.getenv("STRATEGY")
    THREADS = int(os.getenv("THREADS") or "-1")
    EMPLOYEES = int(os.getenv("EMPLOYEES") or "-1")
    VARIANT = pay_a if os.getenv("VARIANT") == "a" else pay_b

    duration = 0
    with ThreadPoolExecutor(max_workers=THREADS) as exe:
        futures = [
            exe.submit(transaction, i, VARIANT, STRATEGY)
            for i in range(1, EMPLOYEES + 1)
        ]
        start = time.time()
        wait(futures)
        duration = time.time() - start

    conn = get_conn(STRATEGY)
    with conn.cursor() as cur:
        cur.execute("SELECT balance FROM Accounts WHERE account=0")
        row = cur.fetchone()
        if row is None:
            raise RuntimeError("No row returned for company account!")
        final = row[0]
    conn.close()

    print(f"""{int(duration*1000000)}\n{final}""")


if __name__ == "__main__":
    main()
