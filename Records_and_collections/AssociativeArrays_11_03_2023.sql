--------------------------------------------------------------------------------
--------------------->>>>>>>>>>>>>,<<<<<<<<<<<----------------------------------
-------------------- Associative Arrays ----------------------------------------
/*
In SQL, there isn't a built-in data structure called an "associative array."
However, you can achieve similar functionality by using tables, which can be 
thought of as key-value pairs. The choice of SQL database system may affect the 
specific syntax and features available, but the fundamental idea remains the same. 
Here's how you can simulate an associative array in SQL:

Using a Table:
You can create a table with two columns, one for the key and another for the associated value. For example:
*/
CREATE TABLE associative_array (
    key_column VARCHAR(255),
    value_column VARCHAR(255)
);
/
INSERT INTO associative_array (key_column, value_column) VALUES ('name', 'John');
/
UPDATE associative_array SET value_column = 'Doe' WHERE key_column = 'last_name';
/
DELETE FROM associative_array WHERE key_column = 'name';

-----------------------------------------------------------------------------------------------------------------------
--------------------------------<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>-----------------------------------------
-----------------------------------------------------------------------------------------------------------------------

set serveroutput ON;
/

declare
    type v_associative is table of employees.first_name%type index by pls_integer;
    v_array v_associative;
    begin
    for i in 100 .. 110
    loop
        select first_name into v_array(i) from employees where employee_id=i;
    end loop;
    for j in v_array.first .. v_array.last
    loop
        dbms_output.put_line(v_array(j));
    end loop;
end;
/

declare
    type v_associative is table of employees.first_name%type index by pls_integer;
    v_array v_associative;
    idx pls_integer;
    begin
    while idx is not null
    loop
        select first_name into v_array(idx) from employees where employee_id=i and department_id=60;
        idx :=idx.next(idx);
    end loop;
/

declare
    type v_assocaitive is table of employees%rowtype index by employees.email%type;
    
    v_array v_assocaitive;
    idx employees.email%type;
    v_email employees.email%type;
    v_first_name employees.first_name%type;
    
begin
    for i in 100 .. 110
    loop
        select * into v_array(i) from employees where employee_id=i;
    end loop;
    idx := v_array.first;
    while idx is not null
    loop
        dbms_output.put_line( ' The Email of '|| v_array(idx).first_name||' '|| v_array(idx).last_name||' is : '|| v_array(idx).email);
        idx := v_array.next(idx);
    end loop;
end;
/
-----------------------------<<<<<<<<<<<<<>>.>>>>>>>>>>>>>----------------------
-----------------------------Using Records With Collection----------------------

declare
    type v_record is record (   first_name employees.first_name%type,
                                last_name employees.last_name%type,
                                email employees.email%type);
                              
    type v_assocaitive is table of v_record index by pls_integer;
    
    v_array v_assocaitive;
    idx pls_integer;
    --v_email employees.email%type;
    --v_first_name employees.first_name%type;
    
begin
    for i in 100 .. 110
    loop
        select first_name,last_name,email into v_array(i) from employees where employee_id=i;
    end loop;
    idx := v_array.first;
    while idx is not null
    loop
        dbms_output.put_line( ' The Email of '|| v_array(idx).first_name||' '|| v_array(idx).last_name||' is : '|| v_array(idx).email);
        idx := v_array.next(idx);
    end loop;
end;
/
declare
    type v_record is record (   first_name employees.first_name%type,
                                last_name employees.last_name%type,
                                email employees.email%type);
                              
    type v_assocaitive is table of v_record index by pls_integer;
    
    v_array v_assocaitive;
    idx pls_integer;
    --v_email employees.email%type;
    --v_first_name employees.first_name%type;
    
begin
    for i in 100 .. 110
    loop
        select first_name,last_name,email into v_array(i) from employees where employee_id=i;
    end loop;
    v_array.delete(100,104);
    idx := v_array.first;
    while idx is not null
    loop
        dbms_output.put_line( ' The Email of '|| v_array(idx).first_name||' '|| v_array(idx).last_name||' is : '|| v_array(idx).email);
        idx := v_array.next(idx);
    end loop;
end;
/
DECLARE
    TYPE v_record IS RECORD (
        first_name employees.first_name%TYPE,
        last_name employees.last_name%TYPE,
        email employees.email%TYPE
    );

    TYPE v_associative IS TABLE OF v_record INDEX BY PLS_INTEGER;

    v_array v_associative;
    idx PLS_INTEGER;

BEGIN
    FOR i IN 100 .. 110
    LOOP
        SELECT first_name, last_name, email
        INTO v_array(i)
        FROM employees
        WHERE employee_id = i;
    END LOOP;

    -- Delete employees 100 to 104
    FOR i IN 100 .. 104
    LOOP
        v_array.DELETE(i);
    END LOOP;

    idx := v_array.FIRST;
    WHILE idx IS NOT NULL
    LOOP
        DBMS_OUTPUT.PUT_LINE('The Email of ' || v_array(idx).first_name || ' ' || v_array(idx).last_name || ' is: ' || v_array(idx).email);
        idx := v_array.NEXT(idx);
    END LOOP;
END;

/
DECLARE
    TYPE v_record IS RECORD (
        first_name employees.first_name%TYPE,
        last_name employees.last_name%TYPE,
        email employees.email%TYPE
    );

    TYPE v_associative IS TABLE OF v_record INDEX BY PLS_INTEGER;

    v_array v_associative;
    v_deleted_array v_associative; -- Add a new associative array for deleted employees
    idx PLS_INTEGER;

BEGIN
    FOR i IN 100 .. 110
    LOOP
        SELECT first_name, last_name, email
        INTO v_array(i)
        FROM employees
        WHERE employee_id = i;
    END LOOP;

    -- Store the records of deleted employees in a separate array
    FOR i IN  100 .. 104
    LOOP
        v_deleted_array(i) := v_array(i);
        v_array.DELETE(i);
    END LOOP;

    -- Display the information of the deleted employees
    idx := v_deleted_array.FIRST;
    WHILE idx IS NOT NULL
    LOOP
        DBMS_OUTPUT.PUT_LINE('Deleted: The Email of ' || v_deleted_array(idx).first_name || ' ' ||
                                                         v_deleted_array(idx).last_name || ' is: ' || v_deleted_array(idx).email);
        idx := v_deleted_array.NEXT(idx);
    END LOOP;

    -- Display the information of the remaining employees
    dbms_output.put_line('------------------------------------------------------');
    idx := v_array.FIRST;
    WHILE idx IS NOT NULL
    LOOP
        DBMS_OUTPUT.PUT_LINE('Remaining: The Email of ' || v_array(idx).first_name || ' ' ||
                                                           v_array(idx).last_name || ' is: ' || v_array(idx).email);
        idx := v_array.NEXT(idx);
    END LOOP;
END;

/
-----------------------------<<<<<<<<<<<<<>>.>>>>>>>>>>>>>----------------------
-----------------------------Printing from last to first------------------------
DECLARE
    TYPE v_record IS RECORD (
        first_name employees.first_name%TYPE,
        last_name employees.last_name%TYPE,
        email employees.email%TYPE
    );

    TYPE v_associative IS TABLE OF v_record INDEX BY PLS_INTEGER;

    v_array v_associative;
    idx PLS_INTEGER;

BEGIN
    FOR i IN 100 .. 110
    LOOP
        SELECT first_name, last_name, email
        INTO v_array(i)
        FROM employees
        WHERE employee_id = i;
    END LOOP;

    idx := v_array.last;
    WHILE idx IS NOT NULL
    LOOP
        DBMS_OUTPUT.PUT_LINE('The Email of ' || v_array(idx).first_name || ' ' ||
                                                v_array(idx).last_name || ' is: ' || v_array(idx).email);
        idx := v_array.prior(idx);
    END LOOP;
END;
/
----------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------<<<<<<<<<<<<<<<<<<.>>>>>>>>>>>>>>>>>>-------------------------------------------------------------------
-------------------------------------- Add New Data using Associated Array -------------------------------------------------------------------
create table insert_new_employee as select * from employees where 1=2;
/
----- Add a new insert_date column 
alter table insert_new_employee add insert_date date;
/
select * from insert_new_employee;
/
--------------------------- Create Associative Arrays---------------------------
declare
    type v_associative is table of insert_new_employee%rowtype index by pls_integer;
    v_array v_associative;
    idx pls_integer;
begin
    for i in 100 .. 110
    loop
        select e.*,'11-Nov-2023' into v_array(i) from employees e where employee_id=i;
        
        end loop;
    idx := v_array.first;
    while idx is not null
    loop
        v_array(idx).salary := v_array(idx).salary + v_array(idx).salary * 0.2;
        insert into insert_new_employee values v_array(idx);
        dbms_output.put_line(' The Data of : ' || v_array(idx).first_name|| ' ' || 
                                                  v_array(idx).last_name|| ' is inserted in to the new table: insert_new_employee' ); 
        idx := v_array.next(idx);
    end loop;
end;
/
select * from insert_new_employee;
/


                    