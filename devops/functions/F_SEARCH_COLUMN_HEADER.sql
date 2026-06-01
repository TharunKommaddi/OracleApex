--
-- Function "F_SEARCH_COLUMN_HEADER"
--
CREATE OR REPLACE EDITIONABLE FUNCTION "WKSP_THARUN"."F_SEARCH_COLUMN_HEADER" 
(
    P_APP_ID IN NUMBER,
    P_REPORT_ID IN NUMBER,
    P_CATEGORIES IN VARCHAR2,
    P_NUMBERS IN VARCHAR2,
    P_ET_G_STATUS_HF_ET IN VARCHAR2,
    P_ET_A_STATUS_HF_ET IN VARCHAR2,
    P_ET_C_STATUS_HF_ET IN VARCHAR2
) 
RETURN CLOB
IS
    l_sql CLOB;
BEGIN
    l_sql := q'[
    SELECT 
        CASE WHEN LABEL IS NOT NULL THEN LABEL ELSE HEADING END AS D, 
        NAME AS R 
    FROM APEX_APPL_PAGE_IG_RPT_COLUMNS r 
    JOIN APEX_APPL_PAGE_IG_COLUMNS c ON r.COLUMN_ID = c.COLUMN_ID 
    WHERE r.application_id = ]' || P_APP_ID || q'[
    AND r.Page_ID = 48 
    AND r.REPORT_ID = ]' || P_REPORT_ID || q'[
    AND r.IS_VISIBLE = 'Yes' 
    AND c.ITEM_TYPE NOT IN ('NATIVE_ROW_SELECTOR', 'NATIVE_ROW_ACTION', 'NATIVE_HIDDEN', 'NATIVE_LINK') 
    AND (
        c.CONDITION_TYPE IS NULL 
        OR (
            -- Number category (1)
            ( c.NAME IN ('NUMBER_1', 'NUMBER_2', 'NUMBER_5') AND 1 MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_CATEGORIES || q'[', ':') )
            -- Special cases for NUMBER_3 and NUMBER_4
            OR ( c.NAME = 'NUMBER_3' AND 1 MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_CATEGORIES || q'[', ':') AND 1 MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_NUMBERS || q'[', ':') )
            OR ( c.NAME = 'NUMBER_4' AND 1 MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_CATEGORIES || q'[', ':') AND 2 MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_NUMBERS || q'[', ':') )
            -- Text category (2)
            OR ( c.NAME IN ('TEXT_1', 'TEXT_2', 'TEXT_3', 'TEXT_4', 'TEXT_5') AND 2 MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_CATEGORIES || q'[', ':') )
            -- Mixed category (3)
            OR ( c.NAME IN ('MIXED_1', 'MIXED_2', 'MIXED_3', 'MIXED_4', 'MIXED_5') AND 3 MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_CATEGORIES || q'[', ':') )
            -- Date category (4)
            OR ( c.NAME IN ('DATE_1', 'DATE_2', 'DATE_3') AND 4 MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_CATEGORIES || q'[', ':') )
            -- ET-G HF category (5)
            OR ( c.NAME IN ('ET_G_HF', 'ET_G1_HF', 'ET_G2_HF', 'ET_G3_HF', 'ET_G4_HF', 'ET_G5_HF') 
                AND 5 MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_CATEGORIES || q'[', ':')
                AND (']' || P_ET_G_STATUS_HF_ET || q'[' IS NULL OR
                    CASE c.NAME
                        WHEN 'ET_G_HF' THEN 1
                        WHEN 'ET_G1_HF' THEN 2
                        WHEN 'ET_G2_HF' THEN 3
                        WHEN 'ET_G3_HF' THEN 4
                        WHEN 'ET_G4_HF' THEN 5
                        WHEN 'ET_G5_HF' THEN 6
                    END MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_ET_G_STATUS_HF_ET || q'[', ':'))
            )
            -- ET-C HF category (5)
            OR ( c.NAME IN ('ET_C2_HF', 'ET_C3_HF') 
                AND 5 MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_CATEGORIES || q'[', ':')
                AND (']' || P_ET_C_STATUS_HF_ET || q'[' IS NULL OR
                    CASE c.NAME
                        WHEN 'ET_C2_HF' THEN 1
                        WHEN 'ET_C3_HF' THEN 2
                    END MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_ET_C_STATUS_HF_ET || q'[', ':'))
            )
            -- ET-A HF category (5)
            OR ( c.NAME IN ('ET_A_HF', 'ET_A11_HF', 'ET_A12_HF', 'ET_A21_HF', 'ET_A22_HF', 'ET_A5_HF') 
                AND 5 MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_CATEGORIES || q'[', ':')
                AND (']' || P_ET_A_STATUS_HF_ET || q'[' IS NULL OR
                    CASE c.NAME
                        WHEN 'ET_A_HF' THEN 1
                        WHEN 'ET_A11_HF' THEN 2
                        WHEN 'ET_A12_HF' THEN 3
                        WHEN 'ET_A21_HF' THEN 4
                        WHEN 'ET_A22_HF' THEN 5
                        WHEN 'ET_A5_HF' THEN 6
                    END MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_ET_A_STATUS_HF_ET || q'[', ':'))
            )
            -- ET-G ET category (6)
            OR ( c.NAME IN ('ET_G_ET', 'ET_G1_ET', 'ET_G2_ET', 'ET_G3_ET', 'ET_G4_ET', 'ET_G5_ET') 
                AND 6 MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_CATEGORIES || q'[', ':')
                AND (']' || P_ET_G_STATUS_HF_ET || q'[' IS NULL OR
                    CASE c.NAME
                        WHEN 'ET_G_ET' THEN 1
                        WHEN 'ET_G1_ET' THEN 2
                        WHEN 'ET_G2_ET' THEN 3
                        WHEN 'ET_G3_ET' THEN 4
                        WHEN 'ET_G4_ET' THEN 5
                        WHEN 'ET_G5_ET' THEN 6
                    END MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_ET_G_STATUS_HF_ET || q'[', ':'))
            )
            -- ET-C ET category (6)
            OR ( c.NAME IN ('ET_C2_ET', 'ET_C3_ET') 
                AND 6 MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_CATEGORIES || q'[', ':')
                AND (']' || P_ET_C_STATUS_HF_ET || q'[' IS NULL OR
                    CASE c.NAME
                        WHEN 'ET_C2_ET' THEN 1
                        WHEN 'ET_C3_ET' THEN 2
                    END MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_ET_C_STATUS_HF_ET || q'[', ':'))
            )
            -- ET-A ET category (6)
            OR ( c.NAME IN ('ET_A_ET', 'ET_A11_ET', 'ET_A12_ET', 'ET_A21_ET', 'ET_A22_ET', 'ET_A5_ET') 
                AND 6 MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_CATEGORIES || q'[', ':')
                AND (']' || P_ET_A_STATUS_HF_ET || q'[' IS NULL OR
                    CASE c.NAME
                        WHEN 'ET_A_ET' THEN 1
                        WHEN 'ET_A11_ET' THEN 2
                        WHEN 'ET_A12_ET' THEN 3
                        WHEN 'ET_A21_ET' THEN 4
                        WHEN 'ET_A22_ET' THEN 5
                        WHEN 'ET_A5_ET' THEN 6
                    END MEMBER OF APEX_STRING.SPLIT_NUMBERS(']' || P_ET_A_STATUS_HF_ET || q'[', ':'))
            )
            -- Columns without conditions
            OR c.NAME IN ('TABLE_1_ID', 'CREATED_DATE', 'CREATED_BY', 'UPDATED_DATE', 'UPDATED_BY', 'STATUS_TAILOR', 'EDL_ET_G', 'EDL_ET_A')
        )
    )
    ORDER BY r.DISPLAY_SEQ
    ]';

    RETURN l_sql;
END F_SEARCH_COLUMN_HEADER;
/