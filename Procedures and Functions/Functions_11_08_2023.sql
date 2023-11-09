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
            
    
    
