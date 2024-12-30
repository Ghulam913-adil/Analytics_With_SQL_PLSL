/*=========================================================================================================
|  Title:         VARRAY Practice 
|  Description:   Practicing different scenarios with VARRAY, including DML operations like insert, delete, and update.
|  Author:        Adil Khan Rumi
|  Date Created:  18-DEC-2024
|  Last Updated:  19-DEC-2024
|  Version:       19.0
|
|  Notes:         
|  - Ensure compatibility with Oracle 19c.
|  - The EMPLOYEES and DEPARTMENTS tables must exist in the schema.
=========================================================================================================*/
/

set serveroutput on;
/

DECLARE
    TYPE V_ARRAY IS VARRAY(5) OF VARCHAR2(50);
    V_OUT V_ARRAY := V_ARRAY('GHULAM','MUJTABA','ADIL','KHAN','RUMI');
    
    BEGIN
    
    FOR I IN V_OUT.FIRST() .. V_OUT.LAST()
    LOOP
        DBMS_OUTPUT.PUT_LINE(V_OUT(I));
    END LOOP;
END;
/

DECLARE

    TYPE e_list IS VARRAY(15) OF VARCHAR2(50);
    employees e_list := e_list();
    idx NUMBER := 1;
    
BEGIN
    FOR i IN 100..110 
    LOOP
        employees.extend;
        SELECT first_name INTO employees(idx) FROM employees WHERE employee_id = i;
        idx := idx + 1;
        
    END LOOP;

    FOR x IN 1..employees.count() LOOP
        dbms_output.put_line(employees(x));
    END LOOP;

END;
/
create or replace type v_array is varray(15) of VARCHAR2(50);
/
create table t_emps as select first_name from employees where 1=2;
/
declare
    --type v_array is varray(15) of varchar2(50);
    type v_record is record(first_name varchar2(50));
    v_emps v_array := v_array();
    v_emps2 v_record;
    idx number :=1;
begin
    for i in 110 .. 115
    loop
        v_emps.extend();
        select last_name into v_emps(idx) from employees where employee_id = i;
        idx := idx + 1;
    end loop;
    
    for j in 1 .. v_emps.count()
    loop
        v_emps2.first_name := v_emps(j);
        dbms_output.put_line('Employees Records: ' || v_emps2.first_name);
    end loop;
    
    for k in 1 .. v_emps.count()
    loop
        v_emps2.first_name := v_emps(k);
        --dbms_output.put_line('Employees Records: ' || v_emps2.first_name);
        dbms_output.put_line('The Employees ' || v_emps(k) || ' has been inserted into the table t_emps');
        insert into t_emps (first_name)
        VALUES('#'||k|| v_emps2.first_name);
    end loop;
end;
/

select * from t_emps;

