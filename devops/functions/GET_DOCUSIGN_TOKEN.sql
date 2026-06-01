--
-- Function "GET_DOCUSIGN_TOKEN"
--
CREATE OR REPLACE EDITIONABLE FUNCTION "WKSP_THARUN"."GET_DOCUSIGN_TOKEN" RETURN VARCHAR2 IS
    l_token VARCHAR2(4000);
BEGIN
    -- Try Application Item first
    BEGIN
        l_token := apex_util.get_session_state('G_DOCUSIGN_TOKEN');
    EXCEPTION
        WHEN OTHERS THEN
            l_token := NULL;
    END;
    
    -- If not found in app item, try database
    IF l_token IS NULL THEN
        BEGIN
            SELECT config_value INTO l_token
            FROM docusign_config
            WHERE config_key = 'ACCESS_TOKEN'
            AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_token := NULL;
            WHEN OTHERS THEN
                l_token := NULL;
        END;
    END IF;
    
    RETURN l_token;
END;
/