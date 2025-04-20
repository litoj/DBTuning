CREATE INDEX idx_ssnum ON employee(ssnum);
CLUSTER employee USING idx_ssnum;

CREATE INDEX idx_name ON employee(name);
CLUSTER employee USING idx_name;

CREATE INDEX idx_dept_salary ON employee (dept, salary);

