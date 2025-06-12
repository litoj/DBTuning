\c payroll
UPDATE Accounts SET balance = 0 WHERE account <> 0;
UPDATE Accounts SET balance = 100 WHERE account = 0;
