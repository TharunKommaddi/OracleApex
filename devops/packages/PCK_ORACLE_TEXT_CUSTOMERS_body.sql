--
-- Package_Body "PCK_ORACLE_TEXT_CUSTOMERS"
--
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."PCK_ORACLE_TEXT_CUSTOMERS" IS
    PROCEDURE execute_sql(p_sql IN VARCHAR2, p_throw_error IN BOOLEAN DEFAULT TRUE) IS 
    BEGIN 
        EXECUTE IMMEDIATE p_sql; 
    EXCEPTION 
        WHEN OTHERS THEN  
            IF p_throw_error THEN 
                RAISE; 
            END IF;
    END execute_sql; 

    FUNCTION text_is_available RETURN BOOLEAN IS 
        l_dummy NUMBER; 
    BEGIN 
        SELECT 1 INTO l_dummy FROM sys.all_objects 
         WHERE owner = 'CTXSYS' AND object_name = 'CTX_DDL' AND ROWNUM = 1; 
        RETURN TRUE; 
    EXCEPTION  
        WHEN NO_DATA_FOUND THEN 
            RETURN FALSE; 
    END text_is_available; 

    PROCEDURE create_text_preferences(p_pref_name IN VARCHAR2, p_object_name IN VARCHAR2, p_columns IN VARCHAR2, p_section_group IN VARCHAR2, p_tag IN VARCHAR2, p_lexer_name IN VARCHAR2, p_mixed_case IN VARCHAR2, p_base_letter IN VARCHAR2, p_base_letter_type IN VARCHAR2) IS
    BEGIN 
        execute_sql('BEGIN ' ||
                    'ctx_ddl.create_preference(''' || p_pref_name || ''', ''' || p_object_name || '''); ' ||
                    'ctx_ddl.set_attribute(''' || p_pref_name || ''', ''COLUMNS'', ''' || p_columns || '''); ' ||
                    'ctx_ddl.create_section_group(''' || p_section_group || ''', ''XML_SECTION_GROUP''); ' ||
                    'ctx_ddl.add_field_section(''' || p_section_group || ''', ''' || p_tag || ''', ''' || p_tag || ''', TRUE); ' ||
                    'ctx_ddl.create_preference(''' || p_lexer_name || ''', ''BASIC_LEXER''); ' ||
                    'ctx_ddl.set_attribute(''' || p_lexer_name || ''', ''MIXED_CASE'', ''' || p_mixed_case || '''); ' ||
                    'ctx_ddl.set_attribute(''' || p_lexer_name || ''', ''BASE_LETTER'', ''' || p_base_letter || '''); ' ||
                    'ctx_ddl.set_attribute(''' || p_lexer_name || ''', ''BASE_LETTER_TYPE'', ''' || p_base_letter_type || '''); ' ||
                    'END;');
    END create_text_preferences;

    PROCEDURE drop_text_preferences(p_pref_name IN VARCHAR2) IS 
    BEGIN 
        execute_sql('BEGIN ctx_ddl.drop_preference(''' || p_pref_name || '''); END;', FALSE);
        execute_sql('BEGIN ctx_ddl.drop_section_group(''' || p_pref_name || '''); END;', FALSE);
    END drop_text_preferences;

    PROCEDURE create_text_index(p_index_name IN VARCHAR2, p_table_name IN VARCHAR2, p_column_name IN VARCHAR2, p_sg_pref IN VARCHAR2, p_ds_pref IN VARCHAR2, p_lx_pref IN VARCHAR2) IS 
    BEGIN 
        execute_sql('CREATE INDEX ' || p_index_name || ' ON ' || p_table_name || '(' || p_column_name || ') ' ||
                    'INDEXTYPE IS ctxsys.context PARAMETERS (''section group ' || p_sg_pref || ' datastore ' || p_ds_pref || ' lexer ' || p_lx_pref || ' stoplist ctxsys.empty_stoplist memory 10M sync (on commit)'')');
    END create_text_index;

    PROCEDURE drop_text_index(p_index_name IN VARCHAR2) IS 
    BEGIN 
        execute_sql('DROP INDEX ' || p_index_name || ' FORCE');
    END drop_text_index;
    

  
    procedure init_oracle_text is 
    begin 
        if text_is_available then 
            -- Specific setup for T_CUSTOMERS
            create_text_preferences('CUSTOMERS_DS_PREF', 'MULTI_COLUMN_DATASTORE', 'NAME,ADDRESS', 'CUSTOMERS_SG_PREF', 'ADDRESS', 'CUSTOMERS_LX_PREF', 'NO', 'YES', 'GENERIC');
            create_text_index('CUSTOMERS_TEXT_FTX', 'T_CUSTOMERS', 'NAME', 'CUSTOMERS_SG_PREF', 'CUSTOMERS_DS_PREF', 'CUSTOMERS_LX_PREF');
            -- -- Specific setup for T_CUSTOMERS_1
            -- create_text_preferences('CUSTOMERS_DS_PREF_1', 'MULTI_COLUMN_DATASTORE', 'NAME,ADDRESS', 'CUSTOMERS_SG_PREF_1', 'ADDRESS', 'CUSTOMERS_LX_PREF_1', 'NO', 'YES', 'GENERIC');
            -- create_text_index('CUSTOMERS_TEXT_FTX_1', 'T_CUSTOMERS_1', 'NAME', 'CUSTOMERS_SG_PREF_1', 'CUSTOMERS_DS_PREF_1', 'CUSTOMERS_LX_PREF_1');
            -- -- Specific setup for T_NORM
            -- create_text_preferences('CUSTOMERS_DS_PREF_NORM', 'MULTI_COLUMN_DATASTORE', 'BEZEICHNUNG', 'CUSTOMERS_SG_PREF_NORM', 'BEZEICHNUNG', 'CUSTOMERS_LX_PREF_NORM', 'NO', 'YES', 'GENERIC');
            -- create_text_index('CUSTOMERS_TEXT_FTX_NORM', 'T_NORM', 'BEZEICHNUNG', 'CUSTOMERS_SG_PREF_NORM', 'CUSTOMERS_DS_PREF_NORM', 'CUSTOMERS_LX_PREF_NORM');

            -- Specific setup for T_ORACLE_TEXT_CUSTOMERS_ADDRESSES for materialize view
            PCK_ORACLE_TEXT_CUSTOMERS.create_text_preferences('MV_CUSTOMERS_DS_PREF', 
                            'MULTI_COLUMN_DATASTORE', 
                            'FIRST_NAME,LAST_NAME,STREET,CITY', 
                            'MV_CUSTOMERS_SG_PREF', 
                            'CITY', 
                            'MV_CUSTOMERS_LX_PREF', 
                            'NO', 
                            'YES', 
                            'GENERIC');
    
    PCK_ORACLE_TEXT_CUSTOMERS.create_text_index('MV_CUSTOMERS_TEXT_FTX', 
                      'MV_CUSTOMERS', 
                      'DUMMY', 
                      'MV_CUSTOMERS_SG_PREF', 
                      'MV_CUSTOMERS_DS_PREF', 
                      'MV_CUSTOMERS_LX_PREF');
        end if; 
    end init_oracle_text;
    



    FUNCTION convert_text_query(p_enduser_query IN VARCHAR2) RETURN VARCHAR2 IS  
        l_tokens       apex_t_varchar2 := apex_t_varchar2();
        c_xml CONSTANT VARCHAR2(32767) := '<query><textquery><progression>' || 
                                            '<seq>#NORMAL#</seq>' || 
                                            '<seq>#FUZZY#</seq>' || 
                                          '</progression></textquery></query>'; 
        l_textquery    VARCHAR2(32767);

        PROCEDURE tokenize IS
            c_len CONSTANT PLS_INTEGER := LENGTH(p_enduser_query);
            l_pos PLS_INTEGER := 1;
            l_char VARCHAR2(1 CHAR);
            l_quoted BOOLEAN := FALSE;
            l_token  VARCHAR2(32767);
        BEGIN
            <<char_reader_loop>>
            WHILE l_pos <= c_len LOOP
                l_char := SUBSTR(p_enduser_query, l_pos, 1);
                IF l_char = '"' THEN
                    IF SUBSTR(p_enduser_query, l_pos + 1) = '"' THEN
                         l_token := l_token || l_char;
                         l_pos := l_pos + 2;
                         CONTINUE char_reader_loop;
                    END IF;
                    l_token := TRIM(BOTH FROM l_token);
                    IF l_token IS NOT NULL THEN
                        IF l_quoted THEN
                            apex_string.push(l_tokens, l_token);
                        ELSE
                            l_tokens := l_tokens MULTISET UNION apex_string.split(l_token, ' ');
                        END IF;
                        l_token := '';
                    END IF;
                    l_quoted := NOT l_quoted;
                ELSE
                    l_token := l_token || l_char;
                END IF;
                l_pos := l_pos + 1;
            END LOOP char_reader_loop;
            l_token := TRIM(BOTH FROM l_token);
            IF l_token IS NOT NULL THEN
                l_tokens := l_tokens MULTISET UNION (apex_string.split(l_token, ' '));
            END IF;
        END tokenize;

        FUNCTION generate_query(p_feature IN VARCHAR2) RETURN VARCHAR2 IS 
            l_query       VARCHAR2(32767); 
            l_clean_token VARCHAR2(32767); 
            l_not         BOOLEAN;
        BEGIN 
            FOR i IN 1..l_tokens.COUNT LOOP 
                l_clean_token := LOWER(REGEXP_REPLACE(l_tokens(i), '[<>{}/()*%&!$?.:,;\+#]', '')); 
                l_not := FALSE;
                IF LTRIM(RTRIM(l_clean_token)) IS NOT NULL THEN 
                    l_not := l_clean_token LIKE '-%' AND l_clean_token NOT LIKE '-';
                    IF l_query IS NOT NULL AND NOT l_not THEN
                        l_query := l_query || ' AND '; 
                    END IF; 
                    IF l_not THEN
                        l_query := l_query || 'NOT ';
                        l_clean_token := SUBSTR(l_clean_token, 2);
                    END IF;
                    IF p_feature = 'FUZZY' THEN
                        IF l_clean_token LIKE '%"%' THEN
                            l_query := l_query || 'FUZZY("' || TRIM(BOTH '"' FROM l_clean_token) || '", 50, 500) ';
                        ELSE
                            l_query := l_query || 'FUZZY({' || l_clean_token || '}, 50, 500) ';
                        END IF;
                    ELSE
                        IF l_clean_token LIKE '%"%' THEN
                            l_query := l_query || '"' || TRIM(BOTH '"' FROM l_clean_token) || '"';
                        ELSE
                            l_query := l_query || '{' || l_clean_token || '}';
                        END IF;
                    END IF;
                END IF; 
            END LOOP; 
            RETURN LTRIM(RTRIM(l_query));  
        END generate_query; 

    BEGIN 
        IF SUBSTR(p_enduser_query, 1, 8) = 'ORATEXT:' THEN 
            RETURN SUBSTR(p_enduser_query, 9); 
        ELSE  
            l_textquery := c_xml; 
            
            IF SUBSTR(p_enduser_query, 1, 1) = '"' AND SUBSTR(p_enduser_query, -1) = '"' THEN
                l_textquery := REPLACE(l_textquery, '#NORMAL#', '"' || TRIM(BOTH '"' FROM p_enduser_query) || '"');
                l_textquery := REPLACE(l_textquery, '#FUZZY#', 'FUZZY("' || TRIM(BOTH '"' FROM p_enduser_query) || '", 50, 500)');
            ELSE
                tokenize;
                l_textquery := REPLACE(l_textquery, '#NORMAL#', generate_query('NORMAL'));
                l_textquery := REPLACE(l_textquery, '#FUZZY#', generate_query('FUZZY'));
            END IF;
            
            apex_debug.info('#### Oracle TEXT Query is: %s', l_textquery);
            RETURN l_textquery; 
        END IF; 
    END convert_text_query;

END PCK_ORACLE_TEXT_CUSTOMERS;
/