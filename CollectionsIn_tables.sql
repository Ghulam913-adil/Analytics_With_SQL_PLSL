set SERVEROUTPUT ON;
/
create or replace type t_phone as object ( p_type varchar2(50), p_number varchar2(50));
/
create or replace type v_phone as varray(3) of t_phone;
/
create table employes_phone_details( empoyee_id number,
                                    first_name varchar2(10),
                                    last_name varchar2(10),
                                    phone_number v_phone);
/
insert into employes_phone_details values(913,'Ghulam','Mujtaba',v_phone
                                                                        (t_phone('Personal','0342-8638436'),
                                                                         t_phone('Home','0943-413674'),
                                                                         t_phone('Father','0342-9790336')
                                                                        ));
/
insert into employes_phone_details values(913,'Ghulam','Mujtaba',v_phone
                                                                        (t_phone('Personal','0342-8638436'),
                                                                         t_phone('Home','0943-413674'),
                                                                         t_phone('Father','0342-9790336')
                                                                        ));
/
insert into employes_phone_details values(913,'Ghulam','Mujtaba',v_phone
                                                                        (t_phone('Personal','0342-8638436'),
                                                                         t_phone('Home','0943-413674'),
                                                                         t_phone('Father','0342-9790336')
                                                                        ));
/
select * from employes_phone_details;
/
select e.first_name, e.last_name, p.p_type,p.p_number from employes_phone_details e, table(e.phone_number) p;
---------------------------------------------------------------------------------------------------------------------
-------------------------------<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

set SERVEROUTPUT ON;
/
create or replace type t_phone_table as object ( p_type varchar2(50), p_number varchar2(50));
/
create or replace type v_phone_table as table of t_phone_table;
/
create table employes_phone_details_table( empoyee_id number,
                                           first_name varchar2(10),
                                           last_name varchar2(10),
                                           phone_number v_phone_table)
                                           nested table phone_number store as phone_number_table;
/
insert into employes_phone_details_table values(913,'Adil','Khan',v_phone_table
                                                                        (t_phone_table('Personal','0342-8638436'),
                                                                         t_phone_table('Home','0943-413674'),
                                                                         t_phone_table('Father','0342-9790336'),
                                                                         t_phone_table('Brother','0301-5974226')
                                                                        ));
/
insert into employes_phone_details_table values(914,'Ghulam','Mujtaba',v_phone_table
                                                                        (t_phone_table('Personal','0342-8638436'),
                                                                         t_phone_table('Home','0943-413674'),
                                                                         t_phone_table('Father','0342-9790336'),
                                                                         t_phone_table('Brother','0301-5974226')
                                                                        ));
/
insert into employes_phone_details_table values(915,'Rumi','Danishmand',v_phone_table
                                                                        (t_phone_table('Personal','0342-8638436'),
                                                                         t_phone_table('Home','0943-413674'),
                                                                         t_phone_table('Father','0342-9790336'),
                                                                         t_phone_table('Brother','0301-5974226')
                                                                        ));
/
select * from employes_phone_details_table;
/
select e.empoyee_id,e.first_name, e.last_name, p.p_type,p.p_number from employes_phone_details_table e, table(e.phone_number) p;
/
update employes_phone_details_table set phone_number =v_phone_table
                                                                    (t_phone_table('Mobile','0342-8638436'),
                                                                     t_phone_table('Home','0943-413674'),
                                                                     t_phone_table('Abu Jan','0342-9790336'),
                                                                     t_phone_table('gardesh','0301-5974226')
                                                                     ) where empoyee_id =914;
/
select e.empoyee_id,e.first_name, e.last_name, p.p_type,p.p_number from employes_phone_details_table e, table(e.phone_number) p;







