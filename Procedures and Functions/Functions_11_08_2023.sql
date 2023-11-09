--------------------------------------------------------------------------------
----------------<<<<<<< Functions >>>>>>>>>>>-----------------------------------
set SERVEROUTPUT ON;
/
------ create a function to retun the average salary of employee
create or replace function get_avg_sal( depth_id employees.department_id%type) 
    return number as
    v_avg_sal number;
    begin
        select avg(salary) into v_avg_sal from employees where department_id=depth_id;
        return v_avg_sal;
        dbms_output.put_line(v_avg_sal);
    end;
/
--------- calling the function
begin
    dbms_output.put_line(' The Average salary is : '|| get_avg_sal(50));
end;
/
----------------- using a function in begin-end block
declare
  v_avg_salary number;
begin
  v_avg_salary := get_avg_sal(50);
  dbms_output.put_line(v_avg_salary);
end;
----------------- using functions in a select clause
select employee_id,first_name,salary,department_id,get_avg_sal(department_id) avg_sal from employees;
/
----------------- using functions in group by, order by, where clauses 
select get_avg_sal(department_id) from employees
where salary > get_avg_sal(department_id)
group by get_avg_sal(department_id) 
order by get_avg_sal(department_id);
/
----------------- dropping a function
drop function get_avg_sal;
/
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
----------------<<<<<<< Local SubPrograms >>>>>>>>>>>---------------------------
------ create a subprogram to get the employees with high salary
create table high_salary_emp as select * from employees where 1=2;
/
----- create a function to get the data
declare
  function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
    emp employees%rowtype;
    begin
      select * into emp from employees where employee_id = emp_num;
      return emp;
    end;
----create a procedure to insert the data 
    procedure insert_high_paid_emp(emp_id employees.employee_id%type) is 
    emp employees%rowtype;
    begin
      emp := get_emp(emp_id);
      insert into high_salary_emp values emp;
    end;
------ Now the logic to get the highest paid salary employees
begin
    for i in ( select * from employees)
    loop
        if i.salary > 15000
        then 
            insert_high_paid_emp(i.employee_id);
        end if;
    end loop;
end;
/
select * from high_salary_emp;
/
--------------------------------------------------------------------------------
    ----- Create a function inside procedure block.........
declare
----create a procedure to insert the data 
    procedure insert_high_paid_emp(emp_id employees.employee_id%type) is 
    emp employees%rowtype; ---- this is global 
    ----- using Function inside a procedure
    function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
    ----emp employees%rowtype; --- no need, this is already defined globaly
        begin
          select * into emp from employees where employee_id = emp_num;
          return emp;
        end;
    begin
      emp := get_emp(emp_id);
      insert into high_salary_emp values emp;
    end;
------ Now the logic to get the highest paid salary employees
begin
    for i in ( select * from employees)
    loop
        if i.salary > 15000
        then 
            insert_high_paid_emp(i.employee_id);
        end if;
    end loop;
end;
/
select * from high_salary_emp;
/
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
----------------<<<<<<< OverLoading >>>>>>>>>>>---------------------------------
declare
    procedure insert_employees( p_emps employees%rowtype) is
        c_emps employees%rowtype;
    function get_employees ( emp_id employees.employee_id%type) return employees%rowtype is
        begin
            select * into c_emps from employees where employee_id=emp_id;
            return c_emps;
        end;
    ----- get the employee based on the email..
    function get_employees ( emp_email employees.email%type) return employees%rowtype is
        begin
            select * into c_emps from employees where email=emp_email;
            return c_emps;
        end;
    ----Procedure begin Block
    begin
        c_emps := get_employees(p_emps.email);
        insert into high_salary_emp values c_emps;
    end;
begin
    for i in (select * from employees)
    loop
        if i.salary > 15000
        then
            insert_employees(i);
        end if;
    end loop;
end;
/
select * from high_salary_emp;
/
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
----------------<<<<<<< Handling Exceptions >>>>>>>>>>>-------------------------
create or replace function get_emp( emp_id employees.employee_id%type) 
    return employees%rowtype is
    emp employees%rowtype;
    begin
        select * into emp from employees where employee_id = emp_id;
        return emp;
        exception
            when no_data_found
            then
                dbms_output.put_line(' No Employee exist having an Employee_id: '|| emp_id);
                raise no_data_found;
            when OTHERS
                then 
                    dbms_output.put_line('Unexpected Error Occured...');
                    return null;
    end;
/
set serveroutput on;
declare
    c_emps employees%rowtype;
begin
    dbms_output.put_line(' Information of the Employee are .......');
    c_emps := get_emp(10);
    dbms_output.put_line('First Name: ' || c_emps.first_name);
    dbms_output.put_line('last Name: ' || c_emps.last_name);
    dbms_output.put_line('Salary : ' || c_emps.salary);
    dbms_output.put_line('First Hire Date: ' || c_emps.hire_date);
end;
/
 





        
            
    
    
