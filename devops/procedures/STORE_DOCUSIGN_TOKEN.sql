--
-- Procedure "STORE_DOCUSIGN_TOKEN"
--
CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_THARUN"."STORE_DOCUSIGN_TOKEN" (p_token VARCHAR2) IS
BEGIN
    -- Store in database
    MERGE INTO docusign_config
    USING (SELECT 'ACCESS_TOKEN' as key, p_token as value FROM dual) src
    ON (config_key = src.key)
    WHEN MATCHED THEN
        UPDATE SET config_value = src.value, updated_date = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (config_key, config_value) VALUES (src.key, src.value);
    
    COMMIT;
    
    -- Also try to store in application item (if available)
    BEGIN
        apex_util.set_session_state('G_DOCUSIGN_TOKEN', p_token);
    EXCEPTION
        WHEN OTHERS THEN
            NULL; -- Ignore if app item doesn't exist
    END;
    
    debug('Token Storage', 'Token stored in database and application item');
END;
/