CREATE TABLE employee (
    ssnum SERIAL,
    name VARCHAR(16) NOT NULL,
    manager INTEGER, -- Self-referencing to another employee
    dept VARCHAR(16),
    salary NUMERIC(10,2),
    numfriends INTEGER
);
ALTER TABLE employee ADD CONSTRAINT u_emp_name UNIQUE (name);
ALTER TABLE employee ADD CONSTRAINT pk_emp_ssnum PRIMARY KEY (ssnum);
ALTER TABLE employee ADD CONSTRAINT fk_emp_manager FOREIGN KEY (manager) REFERENCES employee(ssnum);

CREATE UNIQUE INDEX employee_ssnum_idx ON employee(ssnum);
CREATE UNIQUE INDEX employee_name_idx ON employee(name);
CREATE INDEX employee_dept_idx ON employee(dept);

CREATE TABLE student (
    ssnum SERIAL,
    name VARCHAR(16) NOT NULL,
    course VARCHAR(16) NOT NULL,
    grade NUMERIC(3,2) -- between 1.0 and 4.0
);
ALTER TABLE student ADD CONSTRAINT u_stud_name UNIQUE (name);
ALTER TABLE student ADD CONSTRAINT pk_stud_ssnum PRIMARY KEY (ssnum);

-- Indexes for student
CREATE UNIQUE INDEX student_ssnum_idx ON student(ssnum);
CREATE UNIQUE INDEX student_name_idx ON student(name);

CREATE TABLE techdept (
    dept VARCHAR(16),
    manager INTEGER NOT NULL,
    location VARCHAR(16) NOT NULL
);
ALTER TABLE techdept ADD CONSTRAINT pk_emp_name PRIMARY KEY (dept);
ALTER TABLE techdept ADD CONSTRAINT fk_td_manager FOREIGN KEY (manager) REFERENCES employee(ssnum);

-- Indexes for techdept
CREATE UNIQUE INDEX techdept_dept_idx ON techdept(dept);
CREATE INDEX techdept_manager_idx ON techdept(manager);
CREATE INDEX techdept_location_idx ON techdept(location);

