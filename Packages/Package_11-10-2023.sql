---------------------<<<<<<<<<<<>>>>>>>>>>>>>>>>>-------------------------------
-------------------- Packages and package Body ---------------------------------
--------------------<<<<<<<<<<<<>>>>>>>>>>>>>>>>>-------------------------------

create or replace PACKAGE employee_info_pkg IS
  -- Define the record type
  TYPE t_emp IS RECORD (
    first_name VARCHAR2(50),
    last_name employees.last_name%TYPE,
    salary employees.salary%TYPE,
    hire_date DATE
  );
  -- Declare the procedure to fetch and display employee information
  PROCEDURE get_employee_info(employee_id_param IN employees.employee_id%TYPE);

END employee_info_pkg;
---- package Body-----
CREATE OR REPLACE PACKAGE BODY employee_info_pkg IS
  -- Implement the procedure
  PROCEDURE get_employee_info(employee_id_param IN employees.employee_id%TYPE) IS
    r_emp t_emp; -- Declare the record variable

  BEGIN
    SELECT first_name, last_name, salary, hire_date 
    INTO r_emp 
    FROM employees 
    WHERE employee_id = employee_id_param;

    -- Output the fetched employee information
    dbms_output.put_line(r_emp.first_name || ' ' || 
                         r_emp.last_name || ' earns ' || 
                         r_emp.salary || ' and was hired on: ' || 
                         TO_CHAR(r_emp.hire_date, 'DD-MON-YY'));
                         
  END get_employee_info;

END employee_info_pkg;







-------------create a package
create or replace package High_Sal_Emp AS

    procedure insert_high_salary_emp(p_id employees.employee_id%type);

    function get_employees (p_id employees.employee_id%type) return employees%rowtype;

    procedure process_high_salary_emp;

end High_Sal_Emp;
------------------------------<<<<<<<<<<<>>>>>>>>>>>>>>-------------------------
-------------create a package body
create or replace package BODY High_Sal_Emp AS

    ---- Create a function
    function get_employees (p_id employees.employee_id%type) return employees%rowtype is
        emps employees%rowtype;
    begin
        select * into emps from employees where employee_id = p_id;
        return emps;
    end get_employees;
    
    ---- Create a procedure
    procedure insert_high_salary_emp(p_id employees.employee_id%type) is
        emps employees%rowtype;
    begin
        emps := get_employees(p_id);
        insert into high_salary_emp values emps;
    end insert_high_salary_emp;

    -- Procedure to process high salary employees
    procedure process_high_salary_emp is
    begin
        for i in (select * from employees) loop
            if i.salary > 15000 then
                insert_high_salary_emp(i.employee_id);
            end if;
        end loop;
    end process_high_salary_emp;

end High_Sal_Emp;
/
--------------------------calling the procedure---------------------------------

BEGIN
    High_Sal_Emp.process_high_salary_emp;
END;
/
select * from high_salary_emp;
----------------------------------------------------------------------------------------------------------------------