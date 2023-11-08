----------------- Creating a procedure
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
--------------------------------------------------------------------------------
