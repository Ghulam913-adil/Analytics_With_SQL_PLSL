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

---------------------------------------------------------------------------------------------------------------------
-------------------- Record with Package Employee Education---------------------------------------------
create or replace PACKAGE employee_info_pkg2 IS
  -- Define the record types
  TYPE t_edu IS RECORD (
    primary_school    VARCHAR2(100),
    high_school       VARCHAR2(100),
    university        VARCHAR2(100),
    uni_graduate_date DATE
  );

  TYPE t_emp IS RECORD (
    first_name       VARCHAR2(50),
    last_name        employees.last_name%TYPE,
    salary           employees.salary%TYPE NOT NULL DEFAULT 1000,
    hire_date        DATE,
    dept_id          employees.department_id%TYPE,
    department       departments%ROWTYPE,
    education        t_edu
  );

  -- Declare the procedure to fetch and display employee information
  PROCEDURE get_employee_info(employee_id_param IN employees.employee_id%TYPE);
END employee_info_pkg2;
/
CREATE OR REPLACE PACKAGE BODY employee_info_pkg2 IS
  -- Implement the procedure
  PROCEDURE get_employee_info(employee_id_param IN employees.employee_id%TYPE) IS
    r_emp t_emp; -- Declare the record variable

  BEGIN
    SELECT first_name, last_name, salary, hire_date, department_id 
    INTO r_emp.first_name, r_emp.last_name, r_emp.salary, r_emp.hire_date, r_emp.dept_id 
    FROM employees 
    WHERE employee_id = employee_id_param;
  
    SELECT * 
    INTO r_emp.department 
    FROM departments 
    WHERE department_id = r_emp.dept_id;
  
    r_emp.education.high_school       := 'Beverly Hills';
    r_emp.education.university        := 'Oxford';
    r_emp.education.uni_graduate_date := TO_DATE('01-JAN-13', 'DD-MON-RR');
  
    dbms_output.put_line(r_emp.first_name || ' ' || 
                         r_emp.last_name || ' earns ' || 
                         r_emp.salary || ' and was hired on: ' || 
                         TO_CHAR(r_emp.hire_date, 'DD-MON-YY'));
    dbms_output.put_line('She graduated from ' || 
                         r_emp.education.university || 
                         ' at ' ||  
                         TO_CHAR(r_emp.education.uni_graduate_date, 'DD-MON-YY'));
    dbms_output.put_line('Her Department Name is: ' || r_emp.department.department_name);
  END get_employee_info;

END employee_info_pkg2;
/

set serveroutput ON;
/
create table retired_employees as select * from employees where 1=2;
/

create or replace package retired_emp as
    c_emps employees%rowtype;
    function retired_function(emp_id employees.employee_id%TYPE)RETURN employees%rowtype;
    procedure retired( emp_id in employees.employee_id%type);
    procedure logic_emp;
end retired_emp;
/
create or replace package body retired_emp as

      
---- Create a function inside a procedure
        FUNCTION retired_function( emp_id employees.employee_id%TYPE)return employees%rowtype IS 
        v_emps employees%rowtype;
          begin
                select * into v_emps from employees where employee_id=emp_id;
                return v_emps;
          end retired_function;
          
---- Create a Procedure
        procedure retired(emp_id in employees.employee_id%type) AS
      v_emps employees%rowtype;
    begin
        v_emps:=retired_function(emp_id);
        insert into retired_employees values v_emps;
    end retired;

---- Create logic for the retuired empeloyees having commission_pct is null....
    procedure logic_emp IS
        begin
            for i in (select * from employees) loop
                if i.commission_pct is null then 
                    retired(i.employee_id);
                end if;
            end loop;
        end logic_emp;

end retired_emp;/

execute retired_emp.logic_emp;
/
select * from employees;
/
select * from retired_employees;




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
    commit;
/
select * from high_salary_emp;
----------------------------------------------------------------------------------------------------------------------
