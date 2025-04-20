CREATE TABLE employee (
    ssnum INTEGER NOT NULL,
    name VARCHAR(16) NOT NULL,
    dept VARCHAR(16),
    salary NUMERIC(10,2),
);
\copy employee FROM 'employee.csv' DELIMITER ',' CSV HEADER;
ALTER TABLE employee ADD CONSTRAINT pk_emp_ssnum PRIMARY KEY (ssnum);

CREATE INDEX idx_ssnum ON employee(ssnum);
CLUSTER employee USING idx_ssnum;

CREATE INDEX idx_name ON employee(name);
CLUSTER employee USING idx_name;

CREATE INDEX idx_dept_salary ON employee (dept, salary); -- USING HASH (dept, salary);
