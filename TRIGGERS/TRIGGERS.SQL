----------------------------------------------------------------------------------------------------------------------
---------------------------------<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>--------------------------------------------------

create or replace trigger before_statement_trigger
before update or insert or delete ON employees_copy

begin
dbms_output.put_line('Before Trigger Fired....');
end;
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------


reate or replace trigger after_row__trigger
after update or insert or delete ON employees_copy
for each row
begin
dbms_output.put_line('Before Each Trigger Fired....');
end;
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
create or replace trigger before_row__trigger
before update or insert or delete ON employees_copy
for each row
begin
dbms_output.put_line('Before Each Row Trigger Fired....');
end;
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
create or replace trigger after_statement_trigger
after update or insert or delete ON employees_copy

begin
dbms_output.put_line('After Trigger Fired....');
end;
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
create or replace TRIGGER before_referencing_row_emp_cpy BEFORE
    INSERT OR UPDATE OR DELETE ON employees_copy
    REFERENCING
            OLD AS o
            NEW AS n
    FOR EACH ROW
BEGIN
    dbms_output.put_line('Before Row Trigger is Fired!.');
    dbms_output.put_line('The Salary of Employee '
                         || :o.employee_id
                         || ' -> Before:'
                         || :o.salary
                         || ' After:'
                         || :n.salary);
    if inserting 
    then
        dbms_output.put_line('An inserting Trigger is Fired!.');
    ELSIF updating
    THEN
        dbms_output.put_line('An updating Trigger is Fired!.');
    ELSIF deleting 
    THEN
        dbms_output.put_line('A deleting Trigger is Fired!.');
    end if;           
END;
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
create or replace trigger before_row_conditional_predicates
before insert or update or delete on employees_copy 
referencing old as O new as N
for each row
begin
  dbms_output.put_line('Before Row Trigger is Fired!.');
  dbms_output.put_line('The Salary of Employee '||:o.employee_id
    ||' -> Before:'|| :o.salary||' After:'||:n.salary);
  if inserting then
    dbms_output.put_line('An INSERT occurred on employees_copy table');
  elsif deleting then
    dbms_output.put_line('A DELETE occurred on employees_copy table');
  elsif updating ('salary') then
    dbms_output.put_line('A DELETE occurred on the salary column');
  elsif updating then
    dbms_output.put_line('An UPDATE occurred on employees_copy table');
  end if;
end;
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
create or replace trigger before_row_Raise_Application_Error
before insert or update or delete on employees_copy 
referencing old as O new as N
for each row
begin
  dbms_output.put_line('Before Row Trigger is Fired!.');
  dbms_output.put_line('The Salary of Employee '||:o.employee_id
    ||' -> Before:'|| :o.salary||' After:'||:n.salary);
  if inserting then
    dbms_output.put_line('An INSERT occurred on employees_copy table');
    IF :n.hire_date > sysdate
    then
        RAISE_APPLICATION_ERROR(-20000,' Hire_Date is greater than SYSDATE...');
    end IF;   
  elsif updating ('salary') then
    dbms_output.put_line('A DELETE occurred on the salary column');
    if :n.salary > 50000
    THEN
        RAISE_APPLICATION_ERROR(-20001,' Salary Cannot be higher than 50000..');
    end IF;
  elsif updating then
    dbms_output.put_line('An UPDATE occurred on employees_copy table');  
  elsif deleting then
    RAISE_APPLICATION_ERROR(-20002,' You cannot delete data from the table: employees_copy...');
    dbms_output.put_line('A DELETE occurred on employees_copy table');
  end if;
end;
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
create or replace TRIGGER INSTEAD_OF_TRIGGER
  INSTEAD OF INSERT OR UPDATE OR DELETE ON new_emp_info
  FOR EACH ROW
  DECLARE
    V_DEPT_ID PLS_INTEGER;
  BEGIN

  IF INSERTING THEN
    SELECT MAX(DEPARTMENT_ID) + 10 INTO V_DEPT_ID FROM DEPARTMENTS_COPY;
    INSERT INTO DEPARTMENTS_COPY VALUES (V_DEPT_ID, :NEW.D_NAME,NULL,NULL);
  ELSIF DELETING THEN
    DELETE FROM DEPARTMENTS_COPY WHERE UPPER(DEPARTMENT_NAME) = UPPER(:OLD.D_NAME);
  ELSIF UPDATING('D_NAME') THEN
    UPDATE DEPARTMENTS_COPY SET DEPARTMENT_NAME = :NEW.D_NAME
      WHERE UPPER(DEPARTMENT_NAME) = UPPER(:OLD.D_NAME);
  ELSE
    RAISE_APPLICATION_ERROR(-20007,'You cannot update any data other than department name!.');
  END IF;
END;
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
create or replace trigger update_of_columns
    before update of hire_date on employees_copy
for each ROW
begin
RAISE_APPLICATION_ERROR(-20003,'you are not allowed to update the Hire_date...');
end;
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
create or replace trigger When_Clause
before insert or update of salary on employees_copy 
for each row
when (new.salary > 50000)
begin
  raise_application_error(-20006,'A salary cannot be higher than 50000!.');
end;
-----------------------------------<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>------------------------------------
------------------------------------------------------------------------------------------------------------------------

-----------------------------------<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>------------------------------------
------------------------------------------------------------------------------------------------------------------------

-----------------------------------<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>------------------------------------
------------------------------------------------------------------------------------------------------------------------
