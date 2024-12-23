/*=========================================================================================================
|  Title:         Record Practice 
|  Description:   Practicing different scenarios with records, including DML operations like insert, delete, and update.
|  Author:        Adil Khan Rumi
|  Date Created:  13-DEC-2024
|  Last Updated:  17-DEC-2024
|  Version:       19.0
|
|  Notes:         
|  - Ensure compatibility with Oracle 19c.
|  - The EMPLOYEES and DEPARTMENTS tables must exist in the schema.
=========================================================================================================*/

SET SERVEROUTPUT ON;
/ 

-- DECLARE section to retrieve an employee's data using %ROWTYPE.
DECLARE
    V_EMPS EMPLOYEES%ROWTYPE; -- Declares a variable `V_EMPS` to hold an entire row of the EMPLOYEES table.
BEGIN
    -- Fetch the record for EMPLOYEE_ID = '101' into `V_EMPS`.
    SELECT * INTO V_EMPS FROM EMPLOYEES WHERE EMPLOYEE_ID = '101';
    -- Print the employee's first name using DBMS_OUTPUT.
    DBMS_OUTPUT.PUT_LINE(V_EMPS.FIRST_NAME);
END;
/

-- Create a sequence for generating unique employee IDs.
CREATE SEQUENCE V_EMPS2 START WITH 1 INCREMENT BY 2;
/ 

-- Create a new table `V_EMPS_REC` to store employee data with constraints.
CREATE TABLE V_EMPS_REC ( 
    EMPS_ID NUMBER,
    FIRST_NAME VARCHAR2(20) NOT NULL,
    LAST_NAME VARCHAR2(20) NOT NULL,
    HIRE_DATE DATE NOT NULL,
    SALARY NUMBER NOT NULL,
    CONSTRAINT V_EMPS2_PK PRIMARY KEY (EMPS_ID), -- Primary key constraint on EMPS_ID.
    CONSTRAINT SALARY_CK CHECK (SALARY > 1000)   -- Check constraint to ensure salary > 1000.
);
/ 

-- Add a new column `DEPT_ID` to the `V_EMPS_REC` table.
ALTER TABLE V_EMPS_REC ADD DEPT_ID NUMBER;
/ 

-- Add a foreign key constraint linking `DEPT_ID` to the `DEPARTMENT_ID` column of the DEPARTMENTS table.
ALTER TABLE V_EMPS_REC 
ADD CONSTRAINT V_EMPS_REC_FK 
FOREIGN KEY (DEPT_ID) 
REFERENCES DEPARTMENTS(DEPARTMENT_ID);
/ 

-- DECLARE section to define a custom record type and manipulate employee records.
DECLARE
    -- Define a custom record type `V_EMPS` to structure employee data.
    TYPE V_EMPS IS RECORD (    
        EMPS_ID NUMBER, -- Employee ID.
        FIRST_NAME EMPLOYEES.FIRST_NAME%TYPE, -- Employee's first name.
        LAST_NAME EMPLOYEES.LAST_NAME%TYPE, -- Employee's last name.
        HIRE_DATE DATE, -- Hire date.
        SALARY EMPLOYEES.SALARY%TYPE -- Salary.
    );
    R_EMPS V_EMPS; -- Declare a variable `R_EMPS` of type `V_EMPS`.

BEGIN
    -- Assign the current value of the sequence to `EMPS_ID` in `R_EMPS`.
r_emps.emps_id := v_emps2.currval;
    -- Uncomment the following lines to populate the custom record with employee data:
    -- R_EMPS.FIRST_NAME := 'GHULAM';
    -- R_EMPS.LAST_NAME := 'MUSTAFA';
    -- R_EMPS.HIRE_DATE := '25-JAN-2005';
r_emps.salary := 4000; -- Assign a salary value to the custom record.

    -- Update the `V_EMPS_REC` table to increase salary for employees in department 90.
UPDATE v_emps_rec
SET
    salary = salary + r_emps.salary
WHERE
    dept_id = 90;

    -- Output a message indicating the salary update operation.
dbms_output.put_line('THE SALARY HAS BEEN UPDATED FOR THE EMPS_ID ' || r_emps.emps_id);

end;
/

-- Query to retrieve all records from the `V_EMPS_REC` table.
SELECT
    *
FROM
    v_emps_rec;
/

-- Query to use a record inside anoter record and then insert into the table: v_emps_rec.

-- DEFINE THE EMPLOYEES_EDUCATION TABLE
CREATE TABLE EMPLOYEES_EDUCATION (
    R_ID NUMBER,
    FIRST_NAME VARCHAR2(100),
    LAST_NAME VARCHAR2(100),
    GENDER CHAR(1),
    PUBLIC_SCHOOL VARCHAR2(100),
    UNIVERSITY VARCHAR2(100),
    GRADUATION_DATE DATE,
    HIRE_DATE DATE,
    SALARY NUMBER,
    DEPARTMENT_ID NUMBER,
    CONSTRAINT R_ID_PK PRIMARY KEY(R_ID),
    CONSTRAINT GENDER_CK CHECK (GENDER IN ('M', 'F')),
    CONSTRAINT DEPARTMENT_ID_FK FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENTS(DEPARTMENT_ID)
);


/

DECLARE
    TYPE R_EDUCATION IS RECORD (
        PUBLIC_SCHOOL VARCHAR2(100),
        UNIVERSITY VARCHAR2(100),
        GRADUATION_DATE DATE
    );

    TYPE R_RECORDS IS RECORD (
        EMPS_ID NUMBER,
        FIRST_NAME EMPLOYEES.FIRST_NAME%TYPE,
        LAST_NAME EMPLOYEES.LAST_NAME%TYPE,
        GENDER CHAR(1),
        HIRE_DATE DATE,
        SALARY NUMBER,
        DEPT_ID EMPLOYEES.DEPARTMENT_ID%TYPE,
        R_EDU R_EDUCATION,
        DEPARTMENT DEPARTMENTS%ROWTYPE
    );

    R_EMPS R_RECORDS;

BEGIN
    -- Fetch Employee Details
    SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE, SALARY
    INTO R_EMPS.EMPS_ID, R_EMPS.FIRST_NAME, R_EMPS.LAST_NAME, R_EMPS.HIRE_DATE, R_EMPS.SALARY
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 102;

    -- Assign Additional Details
    R_EMPS.GENDER := 'F';
    R_EMPS.DEPT_ID := 90;
    R_EMPS.R_EDU.PUBLIC_SCHOOL := 'THE LANGLANDS SCHOOL AND COLLEGE CHITRAL';
    R_EMPS.R_EDU.UNIVERSITY := 'INSTITUTE OF MANAGEMENT SCIENCES';
    R_EMPS.R_EDU.GRADUATION_DATE := TO_DATE('15-JUL-2023', 'DD-MON-YYYY');

    -- Insert into EMPLOYEES_EDUCATION Table
    INSERT INTO EMPLOYEES_EDUCATION (
        R_ID,
        FIRST_NAME,
        LAST_NAME,
        GENDER,
        PUBLIC_SCHOOL,
        UNIVERSITY,
        GRADUATION_DATE,
        HIRE_DATE,
        SALARY,
        DEPARTMENT_ID -- Uncomment if needed
    ) VALUES (
        R_EMPS.EMPS_ID,
        R_EMPS.FIRST_NAME,
        R_EMPS.LAST_NAME,
        R_EMPS.GENDER,
        R_EMPS.R_EDU.PUBLIC_SCHOOL,
        R_EMPS.R_EDU.UNIVERSITY,
        R_EMPS.R_EDU.GRADUATION_DATE,
        R_EMPS.HIRE_DATE,
        R_EMPS.SALARY,
        R_EMPS.DEPT_ID 
    );

    DBMS_OUTPUT.PUT_LINE('Record inserted successfully!');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
SELECT * FROM EMPLOYEES_EDUCATION;
/

UPDATE EMPLOYEES_EDUCATION
SET GENDER = 'M' WHERE R_ID  =102;
/
SET SERVEROUTPUT ON;
/

DECLARE
    V_EMPS EMPLOYEES_EDUCATION%ROWTYPE;
BEGIN
    FOR I IN 101 .. 102
    LOOP
    
        SELECT * INTO V_EMPS FROM EMPLOYEES_EDUCATION WHERE R_ID = I;
        DBMS_OUTPUT.PUT_LINE(V_EMPS.FIRST_NAME);
    END LOOP;
--    V_EMPS.SALARY := 20000;
--    FOR I IN 101 .. 102
--    LOOP
--    update EMPLOYEES_EDUCATION
--    set row = V_EMPS where R_ID = I;
--    END LOOP;
    
END;