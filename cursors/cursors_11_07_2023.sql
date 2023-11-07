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
/

declare
  cursor c_emps (p_dept_id number) is select first_name,last_name,department_name 
                    from employees join departments using (department_id)
                    where department_id = p_dept_id;
  v_emps c_emps%rowtype;
begin
  open c_emps(20);
  fetch c_emps into v_emps;
    dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
    close c_emps;
  open c_emps(20);
    loop
      fetch c_emps into v_emps;
      exit when c_emps%notfound;
      dbms_output.put_line(v_emps.first_name|| ' ' ||v_emps.last_name);
    end loop;
  close c_emps;
end;
/
--------------- bind variables as parameters
declare
  cursor c_emps (p_dept_id number) is select first_name,last_name,department_name 
                    from employees join departments using (department_id)
                    where department_id = p_dept_id;
  v_emps c_emps%rowtype;
begin
  open c_emps(:b_emp);
  fetch c_emps into v_emps;
    dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
    close c_emps;
  open c_emps(:b_emp);
    loop
      fetch c_emps into v_emps;
      exit when c_emps%notfound;
      dbms_output.put_line(v_emps.first_name|| ' ' ||v_emps.last_name);
    end loop;
  close c_emps;
end;
/
---------------cursors with two different parameters
declare
  cursor c_emps (p_dept_id number) is select first_name,last_name,department_name 
                    from employees join departments using (department_id)
                    where department_id = p_dept_id;
  v_emps c_emps%rowtype;
begin
  open c_emps(:b_dept_id);
  fetch c_emps into v_emps;
    dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
    close c_emps;
  open c_emps(:b_dept_id);
    loop
      fetch c_emps into v_emps;
      exit when c_emps%notfound;
      dbms_output.put_line(v_emps.first_name|| ' ' ||v_emps.last_name);
    end loop;
  close c_emps;
  
  open c_emps(:b_dept_id2);
  fetch c_emps into v_emps;
    dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
    close c_emps;
  open c_emps(:b_dept_id2);
    loop
      fetch c_emps into v_emps;
      exit when c_emps%notfound;
      dbms_output.put_line(v_emps.first_name|| ' ' ||v_emps.last_name);
    end loop;
  close c_emps;
end;
/
--------------- cursor with parameters - for in loops
declare
  cursor c_emps (p_dept_id number) is select first_name,last_name,department_name 
                    from employees join departments using (department_id)
                    where department_id = p_dept_id;
  v_emps c_emps%rowtype;
begin
  open c_emps(:b_dept_id);
  fetch c_emps into v_emps;
    dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
    close c_emps;
  open c_emps(:b_dept_id);
    loop
      fetch c_emps into v_emps;
      exit when c_emps%notfound;
      dbms_output.put_line(v_emps.first_name|| ' ' ||v_emps.last_name);
    end loop;
  close c_emps;
  
  open c_emps(:b_dept_id2);
  fetch c_emps into v_emps;
    dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
    close c_emps;
    
    for i in c_emps(:b_dept_id2) loop
      dbms_output.put_line(i.first_name|| ' ' ||i.last_name);
    end loop;
end;
/
---------------cursors with multiple parameters
declare
  cursor c_emps (p_dept_id number , p_job_id varchar2) is select first_name,last_name,job_id,department_name 
                    from employees join departments using (department_id)
                    where department_id = p_dept_id
                    and job_id = p_job_id;
  v_emps c_emps%rowtype;
begin
    for i in c_emps(50,'ST_MAN') loop
      dbms_output.put_line(i.first_name|| ' ' ||i.last_name|| ' - ' || i.job_id);
    end loop;
    dbms_output.put_line(' - ');
    for i in c_emps(80,'SA_MAN') loop
      dbms_output.put_line(i.first_name|| ' ' ||i.last_name|| ' - ' || i.job_id);
    end loop;
end;
/
--------------- An error example of using parameter name with the column name
declare
  cursor c_emps (p_dept_id number , job_id varchar2) is select first_name,last_name,job_id,department_name 
                    from employees join departments using (department_id)
                    where department_id = p_dept_id
                    and job_id = job_id;
  v_emps c_emps%rowtype;
begin
    for i in c_emps(50,'ST_MAN') loop
      dbms_output.put_line(i.first_name|| ' ' ||i.last_name|| ' - ' || i.job_id);
    end loop;
    dbms_output.put_line(' - ');
    for i in c_emps(80,'SA_MAN') loop
      dbms_output.put_line(i.first_name|| ' ' ||i.last_name|| ' - ' || i.job_id);
    end loop;
end;
/
------------------ Cursor Attributes
declare
  cursor c_emps is select * from employees where department_id = 50;
  v_emps c_emps%rowtype;
begin
  if not c_emps%isopen then
    open c_emps;
    dbms_output.put_line('hello');
  end if;
  dbms_output.put_line(c_emps%rowcount);
  fetch c_emps into v_emps;
  dbms_output.put_line(c_emps%rowcount);
  dbms_output.put_line(c_emps%rowcount);
  fetch c_emps into v_emps;
  dbms_output.put_line(c_emps%rowcount);
  close c_emps;
  
  open c_emps;
    loop
      fetch c_emps into v_emps;
      exit when c_emps%notfound or c_emps%rowcount>5;
      dbms_output.put_line(c_emps%rowcount|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
    end loop;
  close c_emps;
end;
----------------------------- Going back in cursor -------------------------------------------------------

set serveroutput on;
/
declare

c_id employees.employee_id%type;
v_first_name employees.first_name%type;

cursor c_emps is select employee_id, first_name from employees where department_id=30;
begin
    open c_emps;
    loop
        fetch c_emps into c_id, v_first_name;
        exit when c_emps%notfound;
        dbms_output.put_line(c_id || ': '|| v_first_name);
        end loop;
        close c_emps;
end;

/

select * from employees;
/
------------- Where of clause --------------------------------------

declare
  cursor c_emps is select * from employees 
                    where department_id = 30 for update;
begin
  for r_emps in c_emps loop
    update employees set salary = salary + 60
          where current of c_emps;
  end loop;  
end;
---------------Wrong example of using where current of clause
declare
  cursor c_emps is select e.* from employees e, departments d
                    where 
                    e.department_id = d.department_id
                    and e.department_id = 30 for update;
begin
  for r_emps in c_emps loop
    update employees set salary = salary + 60
          where current of c_emps;
  end loop;  
end;
---------------An example of using rowid like where current of clause
declare
  cursor c_emps is select e.rowid,e.salary from employees e, departments d
                    where 
                    e.department_id = d.department_id
                    and e.department_id = 30 for update;
begin
  for r_emps in c_emps loop
    update employees set salary = salary + 60
          where rowid = r_emps.rowid;
  end loop;  
end;
