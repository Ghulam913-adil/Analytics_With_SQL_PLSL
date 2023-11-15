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
--------<<<<<< VArray in Packages >>>>>>>>>>>>>>>>>>------------------------------------------------------------------

create or replace package v_array1 as 
    type e_list is VARRAY(5) of varchar2(50);
    employees e_list;
    
    type list_empty is varray(20) OF varchar2(50);
    employees2 list_empty := list_empty();
    
    PROCEDURE varray_procedure;
    PROCEDURE varray_count;    
    PROCEDURE varray_first_last;
    PROCEDURE varray_exist;
    PROCEDURE varray_limit;
    PROCEDURE initialize;
    PROCEDURE empty_constructor_varray;

end v_array1;
/

create or replace
package body v_array1 as  
    procedure varray_procedure as
        begin
        employees := e_list('Ghulam','Mujtaba','Adil','Khan','Rumi');
        for i in 1 ..5 loop
            dbms_output.put_line(employees(i));
        end loop;
    end varray_procedure;
    
    PROCEDURE varray_count as 
        begin
            dbms_output.put_line('This is the Count, when the array values are less then no error would be given but only the values ');
            employees := e_list('Ghulam','Mujtaba','Adil','Khan');
        for i in 1 .. employees.count() loop
            dbms_output.put_line(employees(i));
        end loop;
    end varray_count;
    
    PROCEDURE varray_first_last as
         begin
            dbms_output.put_line('This is the first() and last() commands in varrays... ');
            employees := e_list('Ghulam','Mujtaba','Adil','Khan');
        for i in employees.first() .. employees.last() loop
            dbms_output.put_line(employees(i));
        end loop;
    end varray_first_last;
    
    PROCEDURE varray_exist as
        begin
            dbms_output.put_line('This is the exit command...');
            employees := e_list('Ghulam','Mujtaba','Adil','Khan');
        for i in 1 .. 5 loop
            if employees.exists(i) THEN
                dbms_output.put_line(employees(i));
            end if;
        end loop;
    end varray_exist;
    
     PROCEDURE varray_limit as
        begin
            employees := e_list('Ghulam','Mujtaba','Adil','Khan','Rumi');
            dbms_output.put_line('Limit gives the size of the varray..');
            dbms_output.put_line('The size of the varray e_list is: ' || employees.limit());
        end varray_limit;
        
    PROCEDURE initialize as
        employees e_list := e_list('Ghulam','Mujtaba','Adil','Khan','Rumi');
        begin
            dbms_output.put_line('Initialization and Declaration of the varray at the same time');
            dbms_output.put_line('The size of the varray e_list is: ' || employees.limit());
        end initialize;
    
    PROCEDURE empty_constructor_varray as
        idx NUMBER :=1;
        begin
            dbms_output.put_line('Initialization and Declaration of Empty varray at the same time');
            for i in 100 .. 110 loop
                employees2.extend;
                select first_name into employees2(idx) from employees where employee_id=i;
                idx := idx+1;
            end loop;
            for j in 1 ..employees2.count() loop
                dbms_output.put_line(employees2(j));
            end loop;
        end empty_constructor_varray;
             
end v_array1;
/
set SERVEROUTPUT ON;
/
execute v_array1.varray_procedure;
execute v_array1.varray_count;
execute v_array1.varray_first_last;
execute v_array1.varray_exist;
execute v_array1.varray_limit;
execute v_array1.initialize;
execute v_array1.empty_constructor_varray;

/

---------------------------------------------------------------------------------------------------------------------
------------------------- Associative Nested tables with packages ----------------------------------------------------

create or replace PACKAGE nested_table as 
    type e_list is table of varchar2(50);
    employees e_list;
    procedure nested1;
end nested_table;
/
create or replace package body nested_table as

  procedure nested1 as
  begin
        employees := e_list('Ghulam', 'Mujtaba');
        for i in 1.. employees.count() loop
            dbms_output.put_line(employees(i));
        end loop;
  end nested1;

end nested_table;
/

create or replace PACKAGE nested_table3 as
    type e_list is table of varchar(50);
    employees e_list;
    procedure e_list_empty;
END nested_table3;
/
create or replace package body nested_table3 as

  procedure e_list_empty as
    employees e_list := e_list();
    idx pls_integer := 1;
  begin
        for i in 100 .. 110 loop
            employees.extend;
            select first_name into employees(idx) from employees where employee_id=i;
            idx := idx+1;
        end loop;
        for j in 1 .. employees.count() loop
            dbms_output.put_line(employees(j));
        end loop;
  end e_list_empty;

end nested_table3;
/

create or replace PACKAGE nested_table4 as
    type e_list is table of VARCHAR2(50);
    employees e_list;
    procedure delete_employee;
end nested_table4;
/
create or replace package body nested_table4 as

  procedure delete_employee as
  employees e_list := e_list();
  idx PLS_INTEGER := 1;
  begin
    for i in 100 .. 110 loop
        employees.extend;
        select first_name into employees(idx) from employees where employee_id=i;
        idx := idx+1;
    end loop;
    employees.delete(2);
    for j in 1 .. employees.count() loop
        if employees.exists(j) THEN 
            dbms_output.put_line(employees(j));
        end if;
    end loop;

  end delete_employee;

end nested_table4;
/

----------------------------------------------------------------------------------------------------------------------
-------------------------- Associative Arrays with packages-------------------------------------------------------
create or replace PACKAGE associative_array1 as
    type e_list is table of employees.first_name%type INDEX BY pls_integer;
    emps e_list;
    procedure associative1;
end associative_array1;
/
create or replace package body associative_array1 as

  procedure associative1 as
  begin
        for i in 100 .. 110 loop
            select first_name into emps(i) from employees where employee_id=i;
        end loop;
        for j in emps.first() .. emps.last() loop
            dbms_output.put_line(emps(j));
        end LOOP;
  end associative1;

end associative_array1;
/

create or replace PACKAGE associative_array2 as
    type e_list is table of employees.first_name%type index by VARCHAR2(50);
    emps e_list;
    PROCEDURE associative2;
end associative_array2;
/
create or replace package body associative_array2 as

  procedure associative2 as
  idx employees.email%type;
  v_email employees.email%type;
  v_first_name employees.first_name%type;
  begin
        for i in 100 .. 110 loop
            select first_name, email into v_first_name, v_email from employees where employee_id = i;
            emps(v_email) := v_first_name;
        end loop;
        
        idx := emps.first;
        while idx is not null loop
            dbms_output.put_line(' the email of ' || emps(idx)||' is : ' || idx);
            idx := emps.next(idx);
        end loop;
  end associative2;

end associative_array2;
/
-----------------------------------------------------------------------------------------------------------------
---------------------------<<<<<<<<<<<<>>>>>>>>>>>>>>>>------------------------------------------------------

/

create or replace PACKAGE associative_array1 as
    type e_list is table of employees.first_name%type INDEX BY pls_integer;
    emps e_list;
    procedure associative1;
end associative_array1;
/
create or replace package body associative_array1 as

  procedure associative1 as
  begin
        for i in 100 .. 110 loop
            select first_name into emps(i) from employees where employee_id=i;
        end loop;
        for j in emps.first() .. emps.last() loop
            dbms_output.put_line(emps(j));
        end LOOP;
  end associative1;

end associative_array1;
/
-------------------------------------------------------------------------------------
create or replace PACKAGE associative_array2 as
    type e_list is table of employees.first_name%type index by VARCHAR2(50);
    emps e_list;
    PROCEDURE associative2;
end associative_array2;
/
create or replace package body associative_array2 as

  procedure associative2 as
  idx employees.email%type;
  v_email employees.email%type;
  v_first_name employees.first_name%type;
  begin
        for i in 100 .. 110 loop
            select first_name, email into v_first_name, v_email from employees where employee_id = i;
            emps(v_email) := v_first_name;
        end loop;
        
        idx := emps.first;
        while idx is not null loop
            dbms_output.put_line(' the email of ' || emps(idx)||' is : ' || idx);
            idx := emps.next(idx);
        end loop;
  end associative2;

end associative_array2;
/
----------------------------------------------------------------------------------------

create or replace PACKAGE associative_array_records as
    type e_list is table of employees%rowtype index by employees.email%type;
    emps e_list;
    procedure associative_records;
end associative_array_records;
/
create or replace package body associative_array_records as

  procedure associative_records as
  idx employees.email%type;
  v_email employees.email%type;
  v_first_name employees.first_name%type;
  begin
    for i in 100 .. 110 loop
        select * into emps(i) from employees where employee_id=i;
    end loop;

    idx := emps.first;
    while idx is not null loop
        dbms_output.put_line('The Email of ' || emps(idx).first_name ||' '|| emps(idx).last_name || ' is :> ' || emps(idx).email);
        idx := emps.next(idx);
    end loop;
    
  end associative_records;

end associative_array_records;
/
------------------------------------------------------------------------------------------------

create or replace PACKAGE associative_array_withRecords as

    type e_record is record( employee_id employees.employee_id%type,
                             first_name employees.first_name%type, 
                             last_name employees.last_name%type, 
                             email employees.email%type);
    type e_list is table of e_record index by pls_integer;
    emps e_list;

    procedure associative_with_Records;
end associative_array_withRecords;
/
create or replace package body associative_array_withrecords as

  procedure associative_with_records as
  
  idx employees.email%type;
  v_employee_id employees.employee_id%type;
  v_email employees.email%type;
  v_first_name employees.first_name%type;
  v_last_name employees.last_name%TYPE;
  begin
    for i in 100 .. 110 loop
        select employee_id,first_name, last_name, email into emps(i) from employees where employee_id=i;
    end loop;
    
    idx := emps.first;
    while idx is not NULL LOOP
        dbms_output.put_line(emps(idx).employee_id||''||
                                      ' The Email of '|| emps(idx).first_name || ' ' 
                                      || emps(idx).last_name || ' is :> ' || emps(idx).email);
        idx := emps.next(idx);
    end loop;
        
  end associative_with_records;

end associative_array_withrecords;
/
---------------------------------------------------------------------------------------------
create or replace PACKAGE associative_array_printfromlast as

    type e_record is record( employee_id employees.employee_id%type,
                             first_name employees.first_name%type, 
                             last_name employees.last_name%type, 
                             email employees.email%type);
    type e_list is table of e_record index by pls_integer;
    emps e_list;

    procedure associative_printfromlast;
end associative_array_printfromlast;
/
create or replace package body associative_array_printfromlast as

  procedure associative_printfromlast as
  
  idx employees.email%type;
  v_employee_id employees.employee_id%type;
  v_email employees.email%type;
  v_first_name employees.first_name%type;
  v_last_name employees.last_name%TYPE;
  begin
    for i in 100 .. 110 loop
        select employee_id,first_name, last_name, email into emps(i) from employees where employee_id=i;
    end loop;
    
    --emps.delete(100,104);
    idx := emps.last;
    while idx is not NULL LOOP
        dbms_output.put_line(emps(idx).employee_id||''||
                                      ' The Email of '|| emps(idx).first_name || ' ' 
                                      || emps(idx).last_name || ' is :> ' || emps(idx).email);
        idx := emps.prior(idx);
    end loop;
        
  end associative_printfromlast;

end associative_array_printfromlast;
-----------------------------------------------------------------------------------------------------------------

