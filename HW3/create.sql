CREATE TABLE employee (
    ssnum INTEGER NOT NULL,
    name VARCHAR(16) NOT NULL,
    dept VARCHAR(16),
    salary NUMERIC(10,2)
);
\copy employee FROM 'employee.csv' DELIMITER ',' CSV HEADER;
ALTER TABLE employee ADD CONSTRAINT pk_emp_ssnum PRIMARY KEY (ssnum);
