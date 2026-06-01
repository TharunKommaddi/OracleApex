--
-- Trigger "TR_T_CUSTOMERS"
--
CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_THARUN"."TR_T_CUSTOMERS" 
AFTER INSERT OR UPDATE OR DELETE ON T_CUSTOMERS 
FOR EACH ROW 
DECLARE
    v_action_type NUMBER(2);
BEGIN
    -- Set action type based on operation
    v_action_type := 
        CASE 
            WHEN INSERTING THEN 10
            WHEN UPDATING THEN 20
            WHEN DELETING THEN 30
        END;

    IF INSERTING OR UPDATING THEN 
        INSERT INTO T_H_CUSTOMERS (
            ACTION_TYPE,
            ACTION_DATE,
            ACTION_BY,
            CUSTOMER_ID,
            NAME,
            ADDRESS,
            CITY,
            STATE,
            ZIPCODE,
            EMAIL,
            PHONE,
            COUNTRY,
            COMMENTS_1,
            COMMENTS_2,
            CREATED_DATE,
            CREATED_BY,
            UPDATED_DATE,
            UPDATED_BY
        ) 
        VALUES (
            v_action_type,
            SYSTIMESTAMP,
            COALESCE(SYS_CONTEXT('USERENV', 'OS_USER'), USER),
            :NEW.CUSTOMER_ID,
            :NEW.NAME,
            :NEW.ADDRESS,
            :NEW.CITY,
            :NEW.STATE,
            :NEW.ZIPCODE,
            :NEW.EMAIL,
            :NEW.PHONE,
            :NEW.COUNTRY,
            :NEW.COMMENTS_1,
            :NEW.COMMENTS_2,
            :NEW.CREATED_DATE,
            :NEW.CREATED_BY,
            :NEW.UPDATED_DATE,
            :NEW.UPDATED_BY
        );
    ELSIF DELETING THEN
        INSERT INTO T_H_CUSTOMERS (
            ACTION_TYPE,
            ACTION_DATE,
            ACTION_BY,
            CUSTOMER_ID,
            NAME,
            ADDRESS,
            CITY,
            STATE,
            ZIPCODE,
            EMAIL,
            PHONE,
            COUNTRY,
            COMMENTS_1,
            COMMENTS_2,
            CREATED_DATE,
            CREATED_BY,
            UPDATED_DATE,
            UPDATED_BY
        ) 
        VALUES (
            v_action_type,
            SYSTIMESTAMP,
            COALESCE(SYS_CONTEXT('USERENV', 'OS_USER'), USER),
            :OLD.CUSTOMER_ID,
            :OLD.NAME,
            :OLD.ADDRESS,
            :OLD.CITY,
            :OLD.STATE,
            :OLD.ZIPCODE,
            :OLD.EMAIL,
            :OLD.PHONE,
            :OLD.COUNTRY,
            :OLD.COMMENTS_1,
            :OLD.COMMENTS_2,
            :OLD.CREATED_DATE,
            :OLD.CREATED_BY,
            :OLD.UPDATED_DATE,
            :OLD.UPDATED_BY
        );
    END IF;
END;
ALTER TRIGGER "WKSP_THARUN"."TR_T_CUSTOMERS" ENABLE
/