DECLARE
    V_NUMBER NUMBER := &V_NUMBER;
    V_TABLE NUMBER;
    V_COUNTER NUMBER := 1;
BEGIN
    LOOP
        V_TABLE := V_NUMBER * V_COUNTER;
        DBMS_OUTPUT.PUT_LINE(V_NUMBER || ' * ' || V_COUNTER || ' = ' || V_TABLE);
        V_COUNTER := V_COUNTER +1;
        
    EXIT WHEN V_COUNTER > 10;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('THE MAXIMUM RANGE REACHED : ' || V_COUNTER);
END;

/

DECLARE
    V_NUMBER NUMBER := &V_NUMBER;
    V_TABLE NUMBER;
    V_COUNTER NUMBER := 1;
BEGIN
    FOR I IN 1 .. 10 
    LOOP
        V_TABLE := V_NUMBER * V_COUNTER;
        DBMS_OUTPUT.PUT_LINE(V_NUMBER || ' * ' || V_COUNTER || ' = ' || V_TABLE);
        --V_COUNTER := V_COUNTER +1;
        
    --EXIT WHEN V_COUNTER > 10;
    END LOOP;
    --DBMS_OUTPUT.PUT_LINE('THE MAXIMUM RANGE REACHED : ' || V_COUNTER);
END;   

/

DECLARE
    V_NUMBER NUMBER := &V_NUMBER;
    V_TABLE NUMBER;
    V_COUNTER NUMBER := 1;
BEGIN
    WHILE V_COUNTER <= 10 
    LOOP
        V_TABLE := V_NUMBER * V_COUNTER;
        DBMS_OUTPUT.PUT_LINE(V_NUMBER || ' * ' || V_COUNTER || ' = ' || V_TABLE);
        V_COUNTER := V_COUNTER +1;
        
    --EXIT WHEN V_COUNTER > 10;
    END LOOP;
    --DBMS_OUTPUT.PUT_LINE('THE MAXIMUM RANGE REACHED : ' || V_COUNTER);
END;

/   

