/*=========================================================================================================
|  Title:         NESTED_TABLE Practice 
|  Description:   Practicing different scenarios with NESTED_TABLE, including DML operations like insert, delete, and update.
|  Author:        Adil Khan Rumi
|  Date Created:  20-DEC-2024
|  Last Updated:  24-DEC-2024
|  Version:       19.0
|
|  Notes:         
|  - Ensure compatibility with Oracle 19c.
|  - The EMPLOYEES and DEPARTMENTS tables must exist in the schema.
===========================================================================================================
*/

SET SERVEROUTPUT ON;
/*********** The Simple Usage of Nested Tables **************/
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
/

CREATE OR REPLACE TYPE V_ARRAY2 IS VARRAY(20) OF VARCHAR2(100);
CREATE TABLE NESTED_TABLE AS SELECT FIRST_NAME FROM EMPLOYEES WHERE 1=2;
/

DECLARE
    TYPE V_RECORD IS RECORD (FIRST_NAME EMPLOYEES.FIRST_NAME%TYPE);
    
    V_EMPS V_ARRAY2 := V_ARRAY2();
    V_EMPS2 V_RECORD;
    V_INDEX PLS_INTEGER :=1;
BEGIN
    FOR I IN 100 .. 110
    LOOP
        SELECT FIRST_NAME INTO V_EMPS(V_INDEX) FROM EMPLOYEES WHERE EMPLOYEE_ID = I;
        V_INDEX := V_INDEX +1;
    END LOOP;
    
    FOR J IN  1 .. V_EMPS.COUNT()
    LOOP
        V_EMPS2.FIRST_NAME := V_EMPS(J);
        INSERT INTO NESTED_TABLE(FIRST_NAME)
        VALUES (V_EMPS2.FIRST_NAME);
    END LOOP;
END;
/


    




























































