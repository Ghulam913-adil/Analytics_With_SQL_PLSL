--------------------------------------------------------------------------------
--------------------Procedures To Increase Salary Of Employee-------------------
set serveroutput ON;
/
create or replace procedure increase_salary as
    cursor c_emps is select * from employees_copy for update;
    v_salary_increase pls_integer := 1.10;
    v_old_salary pls_integer;
    
    begin
        for i in c_emps 
        loop
            v_old_salary := i.salary;
            i.salary := i.salary * v_salary_increase + i.salary * nvl(i.commission_pct,0);
            update employees_copy set row=i where current of c_emps;
            dbms_output.put_line(' The salary of '|| i.first_name || 
                                ' With EMP_ID >: '|| i.employee_id||
                                ' is increased from :>-- '|| v_old_salary||' to :>--- ' || i.salary);
        end loop;
end;
/
---------------------Calling The Procedure: increase_salary
execute increase_salary;
/
begin
    dbms_output.put_line(' Procedure Starts Execution ......');
    increase_salary;
    dbms_output.put_line(' Procedure Execution Ends ........');
end;
/



            