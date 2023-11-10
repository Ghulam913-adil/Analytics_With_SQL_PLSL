---------------------<<<<<<<<<<<>>>>>>>>>>>>>>>>>-------------------------------
-------------------- Packages and package Body ---------------------------------
--------------------<<<<<<<<<<<<>>>>>>>>>>>>>>>>>-------------------------------

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
