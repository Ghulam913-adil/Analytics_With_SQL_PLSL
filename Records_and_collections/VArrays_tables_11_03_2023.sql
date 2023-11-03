--------------- Create an Object ----------------------------------------------
CREATE OR REPLACE TYPE phone_number_address AS OBJECT (
        phone         VARCHAR2(50),
        phone_address VARCHAR2(50)
);
/
----------------Create and Array to store the objects with other variables-----------------------------
CREATE OR REPLACE TYPE phone_list_array AS
    VARRAY(3) OF phone_number_address;
/
---------------- Create a table to insert and store the Data-------------------------------------------
CREATE TABLE employee_phone_address_book (
    employee_id   NUMBER,
    first_name    VARCHAR2(50),
    last_name     VARCHAR2(50),
    phone_address phone_list_array
);
/

SELECT
    *
FROM
    employee_phone_address_book;
/
--------------- Insert data into the table : Employee_Phone_Address_Book---------------------------------------
INSERT INTO employee_phone_address_book VALUES (
    2021,
    'Ghulam Mujtaba',
    'Adil',
    phone_list_array(phone_number_address('Home', '0943-413674'),
                     phone_number_address('Mobile', '0342-8638436'),
                     phone_number_address('Father', '0342-9790336'))
);
/
INSERT INTO employee_phone_address_book VALUES (
    2022,
    'Adil Khan',
    'Rumi',
    phone_list_array(phone_number_address('Home', '0943-413674'),
                     phone_number_address('Mobile', '0342-8638436'),
                     phone_number_address('Father', '0342-9790336'))
);
/

-------------------Now Formate in the Correct Table Format-------------------------------------------
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    p.phone,
    p.phone_address
FROM
    employee_phone_address_book e,
    TABLE ( e.phone_address ) p;
/
--------------------------------------------------------------------------------------------------------------------
----------------------- Nested  Tables--------------------------------------------------------------
------------------------------------------------------------------------------------------------------

--------------- Create an Object ----------------------------------------------
CREATE OR REPLACE TYPE phone_number_address2 AS OBJECT (
        phone         VARCHAR2(50),
        phone_address VARCHAR2(50)
);
/
-----------Create a table------------------------------------------------------
CREATE OR REPLACE TYPE phone_list_array2 AS
    TABLE OF phone_number_address2;
/
---------------- Create a table to insert and store the Data-------------------------------------------
CREATE TABLE employee_phone_address_book2 (
    employee_id   NUMBER,
    first_name    VARCHAR2(50),
    last_name     VARCHAR2(50),
    phone_address phone_list_array2) nested table phone_address store as phone_numbers_table ;
/
-------------------------------------Insert data -----------------------------------------------------
INSERT INTO employee_phone_address_book2 VALUES (
    2021,
    'Ghulam Mujtaba',
    'Adil',
    phone_list_array2(phone_number_address2('Home', '0943-413674'),
                     phone_number_address2('Mobile', '0342-8638436'),
                     phone_number_address2('Father', '0342-9790336')
                     ));
/
INSERT INTO employee_phone_address_book2 VALUES (
    2022,
    'Adil Khan',
    'Rumi',
    phone_list_array2(phone_number_address2('Home', '0943-413674'),
                     phone_number_address2('Mobile', '0342-8638436'),
                     phone_number_address2('Father', '0342-9790336')
                     ));
/
-------------------------- Show the output----------------------------------------

SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    p.phone,
    p.phone_address
FROM
    employee_phone_address_book2 e,
    TABLE ( e.phone_address ) p;
/










