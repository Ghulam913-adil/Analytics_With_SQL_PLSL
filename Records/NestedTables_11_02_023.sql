---------------------------------------------------------------------------------------------------------------------
-----------------------------------------<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>-------------------------------------

/*********** The Simple Usage of Nested Tables **************/

/*
Nested tables are a type of collection in PL/SQL that can store multiple elements, 
where each element is itself a collection. In other words, a nested table can contain multiple 
rows and columns of data, making it a versatile data structure for handling complex data.

Here's how to work with nested tables in PL/SQL:

Declare a Nested Table Type:
You define a nested table type using the TYPE keyword, specifying the data type it will contain.
 For example:
 DECLARE
   TYPE NameList IS TABLE OF VARCHAR2(50);
---------------------------------------------------------------------------------------------------
In this example, NameList is a nested table that can store a list of names (strings).

Declare a Nested Table Variable:
After defining the nested table type, you can declare a variable of that type:

DECLARE
   names NameList;
----------------------------------------------------------------------------------------------------------
names is now an empty nested table.

Populate the Nested Table:
You can populate the nested table by using the EXTEND method, which increases its size, and then assign values to individual elements:
names.EXTEND(3); -- Extend the table by 3 elements
names(1) := 'Alice';
names(2) := 'Bob';
names(3) := 'Charlie';
-------------------------------------------------------------------------------------------
Access Elements in a Nested Table:
You can access elements of the nested table using the indexing notation:
DBMS_OUTPUT.PUT_LINE('First Name: ' || names(1));
DBMS_OUTPUT.PUT_LINE('Second Name: ' || names(2));
-------------------------------------------------------------------------------------------------
Iterate Through the Nested Table:
You can use a FOR loop to iterate through the elements in a nested table:
FOR i IN 1..names.COUNT LOOP
   DBMS_OUTPUT.PUT_LINE('Name ' || i || ': ' || names(i));
END LOOP;
------------------------------------------------------------------------------------------------
Use Nested Tables in SQL Queries:
Nested tables can be used in SQL queries to pass collections of data to and from the database.
SELECT column_value BULK COLLECT INTO names
FROM TABLE(CAST(name_table AS NameList));
-----------------------------------------------------------------------------------------------------
Nested Tables of Records:
You can create nested tables of records, allowing you to store and manipulate structured data. For example, you can define a record type and then create a nested table of that record type.

Here's an example of a nested table containing names:
DECLARE
   TYPE NameList IS TABLE OF VARCHAR2(50);
   names NameList;
BEGIN
   names.EXTEND(3);
   names(1) := 'Alice';
   names(2) := 'Bob';
   names(3) := 'Charlie';

   FOR i IN 1..names.COUNT LOOP
      DBMS_OUTPUT.PUT_LINE('Name ' || i || ': ' || names(i));
   END LOOP;
END;
-------------------------------------------------------------------------------------------------------------------------


*/

-----------------------------------------------------------------------------------------
-----------------------------<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>------------------------------
DECLARE
  TYPE e_list IS TABLE OF VARCHAR2(50);
  emps e_list;
BEGIN
  emps := e_list('Alex','Bruce','John');
  FOR i IN 1..emps.count() LOOP
    dbms_output.put_line(emps(i));
  END LOOP;
END;
 
/************************************************************
Adding a New Value to a Nested Table After the Initialization
*************************************************************/
DECLARE
  TYPE e_list IS TABLE OF VARCHAR2(50);
  emps e_list;
BEGIN
  emps := e_list('Alex','Bruce','John');
  emps.extend;
  emps(4) := 'Bob';
  FOR i IN 1..emps.count() LOOP
    dbms_output.put_line(emps(i));
  END LOOP;
END;
 
/*************** Adding Values From a Table *****************/
DECLARE
  TYPE e_list IS TABLE OF employees.first_name%type;
  emps e_list := e_list();
  idx  PLS_INTEGER:= 1;
BEGIN
  FOR x IN 100 .. 110 LOOP
    emps.extend;
    SELECT first_name INTO emps(idx) 
    FROM   employees 
    WHERE  employee_id = x;
    idx := idx + 1;
  END LOOP;
  FOR i IN 1..emps.count() LOOP
    dbms_output.put_line(emps(i));
  END LOOP;
END;
 
/********************* Delete Example ***********************/
DECLARE
  TYPE e_list IS TABLE OF employees.first_name%type;
  emps e_list := e_list();
  idx  PLS_INTEGER := 1;
BEGIN
  FOR x IN 100 .. 110 LOOP
    emps.extend;
    SELECT first_name INTO emps(idx) 
    FROM   employees 
    WHERE  employee_id = x;
    idx := idx + 1;
  END LOOP;
  emps.delete(3);
  FOR i IN 1..emps.count() LOOP
    IF emps.exists(i) THEN 
       dbms_output.put_line(emps(i));
    END IF;
  END LOOP;
END;
