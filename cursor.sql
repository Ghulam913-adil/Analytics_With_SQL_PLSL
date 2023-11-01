set serveroutput on;
/

declare

CURSOR c_emps is select * from employees_copy for UPDATE;

v_salary_increment number := &v_salary_increment;
v_old_salary NUMBER;

begin
for v_emps in c_emps 
loop
v_old_salary := v_emps.salary;
v_emps.salary := v_emps.salary * v_salary_increment + v_emps.salary * nvl(v_emps.commission_pct,0);
dbms_output.put_line(' The salary of '|| v_emps.first_name|| ' with the employee_id : ' || v_emps.employee_id||
                                                             ' is increased from : ' || v_old_salary || ' to :'|| v_emps.salary);
end loop;
end;
/
---------<<<<<<<<<<<<<<< condition ifelse >>>>>>>>>>>>>>>>>---------------------
declare
cursor c_emps is select * from employees for update;

v_salary_increment number :=1.10;
v_max_salary_limit number:=20000;
v_old_salary number;
v_new_salary number;

begin
for v_emps in c_emps
loop
v_old_salary:=v_emps.salary;
v_new_salary:=v_emps.salary*v_salary_increment+v_emps.salary*nvl(v_emps.commission_pct,0);
    if v_new_salary > v_max_salary_limit 
        then
            RAISE_APPICATION_ERROR(-20000, 'The new salary of '||v_emps.first_name|| ' cannot be higher than '|| v_max_salary_limit);
      end if;
v_emps.salary := v_emps.salary*v_salary_increment+v_emps.salary*
    nvl(v_emps.commission_pct, 0);
    UPDATE employees_copy
    SET
        row = v_emps
    WHERE
        CURRENT OF c_emps;

    dbms_output.put_line('The salary of : '
                         || v_emps.employee_id
                         || ' is increased from '
                         || v_old_salary
                         || ' to '
                         || v_emps.salary);
    end loop;
end;
/

select salary from employees_copy where employee_id=100;