------------------------------------------------------------------------------
------------------------Lecture : Varrays--------------------------------------                                        *
 In PL/SQL, you can work with records to store and manipulate related pieces of data. 
  Records are essentially custom composite data types that allow you to group multiple 
  variables together under a single name. Each element in the record is accessed using
  dot notation. PL/SQL records can be useful for structuring data, especially when dealing
  with complex data structures.

Here's how you can define and use records in PL/SQL:

Declare a Record Type:
To create a record type, you use the TYPE keyword. For example:

  DECLARE
   TYPE EmployeeRecord IS RECORD (
      employee_id NUMBER,
      first_name VARCHAR2(50),
      last_name VARCHAR2(50)
   );
Declare a Record Variable:
After defining a record type, you can declare a record variable based on that type:
  
  DECLARE
   emp_info EmployeeRecord;
  
Assign Values to Record Elements:
You can assign values to the elements of the record using the dot notation:

emp_info.employee_id := 101;
emp_info.first_name := 'John';
emp_info.last_name := 'Doe';

Access Record Elements:
You can access the values of the record elements using the dot notation:
  
DBMS_OUTPUT.PUT_LINE('Employee ID: ' || emp_info.employee_id);
DBMS_OUTPUT.PUT_LINE('First Name: ' || emp_info.first_name);
DBMS_OUTPUT.PUT_LINE('Last Name: ' || emp_info.last_name);

  Use Records in SQL Queries:
You can use record types in SQL queries to fetch and manipulate data. For example:

  SELECT employee_id, first_name, last_name INTO emp_info
FROM employees
WHERE employee_id = 101;

  Record Arrays:
You can also create arrays of records in PL/SQL, allowing you to work with multiple records in a collection.

Here's a complete example using records in PL/SQL:

  DECLARE
   TYPE EmployeeRecord IS RECORD (
      employee_id NUMBER,
      first_name VARCHAR2(50),
      last_name VARCHAR2(50)
   );

   emp_info EmployeeRecord;
BEGIN
   emp_info.employee_id := 101;
   emp_info.first_name := 'John';
   emp_info.last_name := 'Doe';

   DBMS_OUTPUT.PUT_LINE('Employee ID: ' || emp_info.employee_id);
   DBMS_OUTPUT.PUT_LINE('First Name: ' || emp_info.first_name);
   DBMS_OUTPUT.PUT_LINE('Last Name: ' || emp_info.last_name);
END;


----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

/**************** A Simple Working Example ******************/
DECLARE
  TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
  employees e_list;
BEGIN
  employees := e_list('Alex','Bruce','John','Bob','Richard');
  FOR i IN 1..5 LOOP
    dbms_output.put_line(employees(i));
  END LOOP;
END;
 
/************** Limit Exceeding Error Example ***************/
DECLARE
  TYPE e_list IS VARRAY(4) OF VARCHAR2(50);
  employees e_list;
BEGIN
  employees := e_list('Alex','Bruce','John','Bob','Richard');
  FOR i IN 1..5 LOOP
    dbms_output.put_line(employees(i));
  END LOOP;
END;
 
/*********** Subscript Beyond Count Error Example ***********/
DECLARE
  TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
  employees e_list;
BEGIN
  employees := e_list('Alex','Bruce','John','Bob');
  FOR i IN 1..5 LOOP
    dbms_output.put_line(employees(i));
  end loop;
END;
 
/**************** A Working count() Example *****************/
DECLARE
  TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
  employees e_list;
BEGIN
  employees := e_list('Alex','Bruce','John','Bob');
  for i IN 1..employees.count() LOOP
    dbms_output.put_line(employees(i));
  END LOOP;
END;
 
/************ A Working first() last() Example **************/
DECLARE
  TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
  employees e_list;
BEGIN
  employees := e_list('Alex','Bruce','John','Bob');
  FOR i IN employees.first()..employees.last() LOOP
    dbms_output.put_line(employees(i));
  END LOOP;
END;
 
/*************** A Working exists() Example *****************/
DECLARE
  TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
  employees e_list;
BEGIN
  employees := e_list('Alex','Bruce','John','Bob');
  FOR i IN 1..5 LOOP
    IF employees.exists(i) THEN
      dbms_output.put_line(employees(i));
    END IF;
  END LOOP;
END;
 
/**************** A Working limit() Example *****************/
DECLARE
  TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
  employees e_list;
BEGIN
  employees := e_list('Alex','Bruce','John','Bob');
  dbms_output.put_line(employees.limit());
END;
 
/****** A Create-Declare at the Same Time Error Example *****/
DECLARE
  TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
  employees e_list('Alex','Bruce','John','Bob');
BEGIN
  --employees := e_list('Alex','Bruce','John','Bob');
  FOR i IN 1..5 LOOP
    IF employees.exists(i) THEN
       dbms_output.put_line(employees(i));
    END IF;
  END LOOP;
END;
 
/************** A Post Insert Varray Example ****************/
DECLARE
  TYPE e_list IS VARRAY(15) OF VARCHAR2(50);
  employees e_list := e_list();
  idx NUMBER := 1;
BEGIN
  FOR i IN 100..110 LOOP
    employees.extend;
    SELECT first_name 
    INTO   employees(idx) 
    FROM   employees 
    WHERE  employee_id = i;
    idx := idx + 1;
  END LOOP;
  FOR x IN 1..employees.count() LOOP
    dbms_output.put_line(employees(x));
  END LOOP;
END;
 
/******* An Example for the Schema-Level Varray Types *******/
CREATE TYPE e_list IS VARRAY(15) OF VARCHAR2(50);
/
CREATE OR REPLACE TYPE e_list AS VARRAY(20) OF VARCHAR2(100);
/
DECLARE
  employees e_list := e_list();
  idx       NUMBER := 1;
BEGIN
 
  FOR i IN 100..110 LOOP
    employees.extend;
    SELECT first_name 
    INTO employees(idx) 
    FROM employees 
    WHERE employee_id = i;
    idx := idx + 1;
  END LOOP;
  
  FOR x IN 1..employees.count() LOOP
    dbms_output.put_line(employees(x));
  END LOOP;
 
END;
/
DROP TYPE E_LIST;
