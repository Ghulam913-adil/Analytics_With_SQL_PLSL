 -------------------------------------------------------------------------------------------------------
 ------------------- Easy DML with PL/SQL Records----------------------------------------------                   *

CREATE TABLE retired_employees 
AS SELECT * FROM employees WHERE 1=2;
 
SELECT * FROM retired_employees;
/
 
DECLARE
    r_emp employees%rowtype;
BEGIN
    SELECT * 
    INTO   r_emp 
    FROM   employees 
    WHERE  employee_id = 104;
    
    r_emp.salary         := 0;
    r_emp.commission_pct := 0;
    
    INSERT INTO retired_employees VALUES r_emp;
END;
 
/************************************************************/
DECLARE
    r_emp employees%rowtype;
BEGIN
    SELECT * 
    INTO   r_emp 
    FROM   employees 
    WHERE  employee_id = 104;
 
    r_emp.salary         := 10;
    r_emp.commission_pct := 0;
 
    --insert into retired_employees values r_emp;
    UPDATE retired_employees 
    SET    row = r_emp 
    WHERE  employee_id = 104;
end;
/
DELETE FROM retired_employees;
/************************************************************/