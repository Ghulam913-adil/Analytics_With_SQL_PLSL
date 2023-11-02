DECLARE
  r_emp employees%rowtype;
BEGIN
  SELECT * INTO r_emp 
  FROM   employees 
  WHERE  employee_id = '101';
  --r_emp.salary := 2000;
  dbms_output.put_line(r_emp.first_name || ' '                ||
                       r_emp.last_name  || ' earns '          ||
                       r_emp.salary     || ' and hired at : ' || 
                       r_emp.hire_date);
END;

--------------------------------------------------------------------------------
----------------------<<<<<<<<<<<<.>>>>>>>>>>>>>>>>-----------------------------
DECLARE
  --r_emp employees%rowtype;
  type t_emp IS RECORD (first_name VARCHAR2(50),
                        last_name  employees.last_name%TYPE,
                        salary     employees.salary%TYPE,
                        hire_date  DATE);
  r_emp t_emp;
BEGIN
  SELECT first_name,last_name,salary,hire_date 
  INTO   r_emp 
  FROM   employees 
  WHERE  employee_id = '101';
 
 /* r_emp.first_name := 'Alex';
    r_emp.salary     := 2000;
    r_emp.hire_date  := '01-JAN-20'; */
 
  dbms_output.put_line(r_emp.first_name || ' '                || 
                       r_emp.last_name  || ' earns '          || 
                       r_emp.salary     || ' and hired at : ' || 
                       r_emp.hire_date);
END;
 
--------------------------------------------------------------------------------
----------------------<<<<<<<<<<<<.>>>>>>>>>>>>>>>>----------------------------- 
DECLARE
  TYPE t_edu is RECORD(primary_school    VARCHAR2(100),
                       high_school       VARCHAR2(100),
                       university        VARCHAR2(100),
                       uni_graduate_date DATE
                       );
  
  TYPE t_emp IS RECORD(first_name       VARCHAR2(50),
                       last_name        employees.last_name%type,
                       salary           employees.salary%type  NOT NULL DEFAULT 1000,
                       hire_date        DATE,
                       dept_id          employees.department_id%type,
                       department       departments%rowtype,
                       education        t_edu
                       );
  r_emp t_emp;
BEGIN
  SELECT first_name, last_name, salary, hire_date, department_id 
    INTO r_emp.first_name, r_emp.last_name, r_emp.salary, r_emp.hire_date, r_emp.dept_id 
    FROM employees where employee_id = '146';
  
  SELECT * 
  INTO   r_emp.department 
  FROM   departments 
  WHERE  department_id = r_emp.dept_id;
  
  r_emp.education.high_school       := 'Beverly Hills';
  r_emp.education.university        := 'Oxford';
  r_emp.education.uni_graduate_date := '01-JAN-13'; 
  
  dbms_output.put_line(r_emp.first_name || ' '                || 
                       r_emp.last_name  || ' earns '          || 
                       r_emp.salary     || ' and hired at : ' ||
                       r_emp.hire_date);
  dbms_output.put_line('She graduated from '       || 
                       r_emp.education.university  || 
                       ' at '                      ||  
                       r_emp.education.uni_graduate_date);
  dbms_output.put_line('Her Department Name is : '|| r_emp.department.department_name);
END;

--------------------------------------------------------------------------------
----------------------<<<<<<<<<<<<.>>>>>>>>>>>>>>>>-----------------------------
