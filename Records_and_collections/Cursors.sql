--------------------------------------------------------------------------------
-----------------------------Cursors -------------------------------------------
---------------------<<<<<<<<<<<>>>>>>>>>>--------------------------------------
set serveroutput ON;
/

-----------------------Explicit Cursors-----------------------------------------
declare
  cursor c_emps is select first_name,last_name from employees;
  v_first_name employees.first_name%type;
  v_last_name employees.last_name%type;
begin
  open c_emps;
  fetch c_emps into v_first_name,v_last_name;
  fetch c_emps into v_first_name,v_last_name;
  fetch c_emps into v_first_name,v_last_name;
  dbms_output.put_line(v_first_name|| ' ' || v_last_name);
  fetch c_emps into v_first_name,v_last_name;
  dbms_output.put_line(v_first_name|| ' ' || v_last_name);
  close c_emps;
end;
/
--------------- cursor with join example
declare
  cursor c_emps is select first_name,last_name, department_name from employees
                      join departments using (department_id)
                      where department_id between 30 and 60;
  v_first_name employees.first_name%type;
  v_last_name employees.last_name%type;
  v_department_name departments.department_name%type;
begin
  open c_emps;
  fetch c_emps into v_first_name, v_last_name,v_department_name;
  dbms_output.put_line(v_first_name|| ' ' || v_last_name|| ' in the department of '|| v_department_name);
  close c_emps;
end;
/
---------------- Cursors With Records-------------------------------------------
declare
  type r_emp is record (  v_first_name employees.first_name%type,
                           v_last_name employees.last_name%type);
  v_emp r_emp;
  cursor c_emps is select first_name,last_name from employees;
begin
  open c_emps;
  fetch c_emps into v_emp;
  dbms_output.put_line(v_emp.v_first_name|| ' ' || v_emp.v_last_name);
  close c_emps;
end;
/
--------------- An example for using cursors table rowtype
declare
  v_emp employees%rowtype;
  cursor c_emps is select first_name,last_name from employees;
begin
  open c_emps;
  fetch c_emps into v_emp.first_name,v_emp.last_name;
  dbms_output.put_line(v_emp.first_name|| ' ' || v_emp.last_name);
  close c_emps;
end;
/
--------------- An example for using cursors with cursor%rowtype.
declare
  cursor c_emps is select first_name,last_name from employees;
  v_emp c_emps%rowtype;
begin
  open c_emps;
  fetch c_emps into v_emp.first_name,v_emp.last_name;
  dbms_output.put_line(v_emp.first_name|| ' ' || v_emp.last_name);
  close c_emps;
end;
-------------Cursor With loops--------------------------------------------------
/

declare
  cursor c_emps is select * from employees where department_id = 30;
  v_emps c_emps%rowtype;
begin
  open c_emps;
  loop
    fetch c_emps into v_emps;
    dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
  end loop;
  close c_emps;
end; 
/
---------------%notfound example
declare
  cursor c_emps is select * from employees where department_id = 30;
  v_emps c_emps%rowtype;
begin
  open c_emps;
  loop
    fetch c_emps into v_emps;
    exit when c_emps%notfound;
    dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
  end loop;
  close c_emps;
end;
/
---------------while loop example
declare
  cursor c_emps is select * from employees where department_id = 30;
  v_emps c_emps%rowtype;
begin
  open c_emps;
  fetch c_emps into v_emps;
  while c_emps%found loop
    dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
    fetch c_emps into v_emps;
    --exit when c_emps%notfound;
  end loop;
  close c_emps;
end;
/
---------------for loop with cursor example
declare
  cursor c_emps is select * from employees where department_id = 30;
  v_emps c_emps%rowtype;
begin
  open c_emps;
  for i in 1..6 loop
    fetch c_emps into v_emps;
    dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
  end loop;
  close c_emps;
end;
/
---------------FOR..IN clause example
declare
  cursor c_emps is select * from employees where department_id = 30;
begin
  for i in c_emps loop
    dbms_output.put_line(i.employee_id|| ' ' ||i.first_name|| ' ' ||i.last_name);
  end loop;
end;
/
---------------FOR..IN with select example
begin
  for i in (select * from employees where department_id = 30) loop
    dbms_output.put_line(i.employee_id|| ' ' ||i.first_name|| ' ' ||i.last_name);
  end loop;
end;
/


        
        

