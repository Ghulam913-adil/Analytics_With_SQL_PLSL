--------------<<<<<<<<<<<<---------------->>>>>>>>>>>>--------------------------
-----------------------Creating a procedure-------------------------------------
--------------<<<<<<<<--------------------->>>>>>>>>>>>>>>>---------------------
set SERVEROUTPUT on;
/
create procedure increase_salaries as
    cursor c_emps is select * from employees_copy for update;
    v_salary_increase number := 1.10;
    v_old_salary number;
begin
    for r_emp in c_emps loop
      v_old_salary := r_emp.salary;
      r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct,0);
      update employees_copy set row = r_emp where current of c_emps;
      dbms_output.put_line('The salary of : '|| r_emp.employee_id 
                            || ' is increased from '||v_old_salary||' to '||r_emp.salary);
    end loop;
end;
/
----------------- Multiple procedure usage
begin
  dbms_output.put_line('Increasing the salaries!...');
  INCREASE_SALARIES;
  INCREASE_SALARIES;
  INCREASE_SALARIES;
  INCREASE_SALARIES;
  dbms_output.put_line('All the salaries are successfully increased!...');
end;
/
----------------- Different procedures in one block
begin
  dbms_output.put_line('Increasing the salaries!...');
  INCREASE_SALARIES;
  new_line;
  INCREASE_SALARIES;
  new_line;
  INCREASE_SALARIES;
  new_line;
  INCREASE_SALARIES;
  dbms_output.put_line('All the salaries are successfully increased!...');
end;
/
-----------------Creating a procedure to ease the dbms_output.put_line procedure 
create procedure new_line as
begin
  dbms_output.put_line('------------------------------------------');
end;
/
-----------------Modifying the procedure with using the OR REPLACE command.
create or replace procedure increase_salaries as
    cursor c_emps is select * from employees_copy for update;
    v_salary_increase number := 1.10;
    v_old_salary number;
begin
    for r_emp in c_emps loop
      v_old_salary := r_emp.salary;
      r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct,0);
      update employees_copy set row = r_emp where current of c_emps;
      dbms_output.put_line('The salary of : '|| r_emp.employee_id 
                            || ' is increased from '||v_old_salary||' to '||r_emp.salary);
    end loop;
    dbms_output.put_line('Procedure finished executing!');
end
/
--------------<<<<<<<<<<<<---------------->>>>>>>>>>>>--------------------------
----------------------Procedure with parameters---------------------------------
create or replace procedure Procedure_parameter( v_increase_salary in number, v_depth_id pls_integer) as
    cursor c_emps is select * from employees_copy where department_id=v_depth_id for update;
    
    v_old_salary pls_integer;
    begin
        for i in c_emps
        loop
            v_old_salary := i.salary;
            i.salary := i.salary * v_increase_salary + i.salary * nvl(i.commission_pct,0);
            update employees_copy set row=i where current of c_emps;
            dbms_output.put_line('The salary of : '|| i.employee_id 
                            || ' is increased from '||v_old_salary||' to '||i.salary);
    end loop;
    dbms_output.put_line('-----------------Procedure finished executing---------------!');
end;
/
------------- creating print procedure--
create or replace procedure print(text in varchar2) as
    begin
        dbms_output.put_line(text);
    end;
/
----------- calling the procedure : Procedure_parameter
begin
    print(' The salary Increased Procedure Execute Starts.....');
    new_line;
    Procedure_parameter(1.2,60); 
end;
/
--------------<<<<<<<<<<<<---------------->>>>>>>>>>>>--------------------------
------Average salary increase and Employees Effected Count Procedure------------
create or replace procedure Average_Salary_Count_Effect 
    (v_salary_increase in out number, v_department_id pls_integer, v_affected_employee_count out number) as
    cursor c_emps is select * from employees_copy where department_id = v_department_id for update;
    v_old_salary number;
    v_sal_inc number := 0;
begin
    v_affected_employee_count := 0;
    for r_emp in c_emps loop
      v_old_salary := r_emp.salary;
      r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct,0);
      update employees_copy set row = r_emp where current of c_emps;
      dbms_output.put_line('The salary of : '|| r_emp.employee_id 
                            || ' is increased from '||v_old_salary||' to '||r_emp.salary);
      v_affected_employee_count := v_affected_employee_count + 1;
      v_sal_inc := v_sal_inc + v_salary_increase + nvl(r_emp.commission_pct,0);
    end loop;
    v_salary_increase := v_sal_inc / v_affected_employee_count;
    dbms_output.put_line('Procedure finished executing!');
end;
/
------- calling the procedure Average_Salary_Count_Effect
begin
 PRINT('SALARY INCREASE STARTED!..');
 Average_Salary_Count_Effect(1.15,90);
 PRINT('SALARY INCREASE FINISHED!..');
end;
/
-----------------Using the procedure that has OUT parameters 
declare
  v_sal_inc number := 1.2;
  v_aff_emp_count number;
begin
 PRINT('SALARY INCREASE STARTED!..');
 Average_Salary_Count_Effect(v_sal_inc,80,v_aff_emp_count);
 PRINT('The affected employee count is : '|| v_aff_emp_count);
 PRINT('The average salary increase is : '|| v_sal_inc || ' percent!..');
 PRINT('SALARY INCREASE FINISHED!..');
end;                                                     
/
--------------<<<<<<<<<<<<---------------->>>>>>>>>>>>--------------------------
---------------------- Default Procedure ---------------------------------------

-----------------Procedure creation of a default value usage
create or replace procedure add_job(job_id pls_integer, job_title varchar2, 
                                    min_salary number default 1000, max_salary number default null) is
begin
  insert into jobs values (job_id,job_title,min_salary,max_salary);
  print('The job : '|| job_title || ' is inserted!..');
end;
/
----------- calling the procedure add_job
begin
    print(' Adding New Job started .....');
    add_job(913,'Data Analyst');
        print(' Adding New Job Ended .....');
end;
/
DELETE FROM jobs WHERE job_id='913';
/
--------------------------------------------------------------------------------