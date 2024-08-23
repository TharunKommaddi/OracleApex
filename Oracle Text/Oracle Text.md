
<h1>Oracle Text Package Implementation and Usage Guide</h1>

<h2>Table of Contents</h2>
<ul>
  <li><a href="#introduction">Introduction</a></li>
  <li><a href="#prerequisites">Prerequisites</a></li>
  <li><a href="#required-privileges">Required Privileges</a></li>
  <li><a href="#package-specification">Package Specification</a></li>
  <li><a href="#package-body-implementation">Package Body Implementation</a></li>
  <li><a href="#using-the-package">Using the Package</a></li>
  <li><a href="#maintenance-and-optimization">Maintenance and Optimization</a></li>
  <li><a href="#troubleshooting">Troubleshooting</a></li>
</ul>

<h2 id="introduction">Introduction</h2>
<p>This guide details the implementation and usage of the PL/SQL package named <code>pck_ri_vorschrift_oracle_text_pkg</code> which offers functionality to work with Oracle Text, a powerful full-text search and retrieval technology. Here's a breakdown of the package's components:</p>

<h2 id="prerequisites">Prerequisites</h2>
<ul>
  <li>Oracle Database with Oracle Text option enabled</li>
  <li>CTXAPP role and necessary system privileges (see Required Privileges section)</li>
  <li>Execute privileges on CTXSYS packages (CTX_DDL, CTX_DOC, CTX_QUERY)</li>
</ul>

<h2 id="required-privileges">Required Privileges</h2>
<p>Before using the <code>pck_ri_vorschrift_oracle_text_pkg</code> package and Oracle Text features, ensure the following privileges are granted:</p>

<h3>CTXAPP Role:</h3>
<pre data-line="1" class="language-sql line-numbers"><code class="language-sql">GRANT CTXAPP TO username;
</code></pre>

<h3>System Privileges:</h3>
<pre data-line="1" class="language-sql line-numbers"><code class="language-sql">GRANT CREATE INDEX, CREATE TABLE, CREATE PROCEDURE, ALTER SESSION TO username;
</code></pre>

<h3>Execute Privileges on CTXSYS Packages:</h3>
<pre data-line="1,2,3,4,5,6,7" class="language-sql line-numbers"><code class="language-sql">GRANT EXECUTE ON CTXSYS.CTX_DDL TO username;
GRANT EXECUTE ON CTXSYS.CTX_DOC TO username;
GRANT EXECUTE ON CTXSYS.CTX_OUTPUT TO username;
GRANT EXECUTE ON CTXSYS.CTX_QUERY TO username;
GRANT EXECUTE ON CTXSYS.CTX_REPORT TO username;
GRANT EXECUTE ON CTXSYS.CTX_THES TO username;
GRANT EXECUTE ON CTXSYS.CTX_ULEXER TO username;
</code></pre>
<p><strong>NOTE:</strong> Replace <code>username</code> with the actual database username in all commands.</p>

<h2 id="package-specification">Package Specification</h2>
<pre data-line="1,6,12,24" class="language-sql line-numbers"><code class="language-sql">CREATE OR REPLACE PACKAGE pck_ri_vorschrift_oracle_text_pkg AUTHID CURRENT_USER IS 
    FUNCTION text_is_available RETURN BOOLEAN; 
    
    PROCEDURE create_text_preferences(
        p_pref_name         IN VARCHAR2, 
        p_object_name       IN VARCHAR2, 
        p_columns           IN VARCHAR2, 
        p_section_group     IN VARCHAR2, 
        p_tag               IN VARCHAR2, 
        p_lexer_name        IN VARCHAR2, 
        p_mixed_case        IN VARCHAR2, 
        p_base_letter       IN VARCHAR2, 
        p_base_letter_type  IN VARCHAR2
    );
    
    PROCEDURE drop_text_preferences(p_pref_name IN VARCHAR2);
    
    PROCEDURE create_text_index(
        p_index_name    IN VARCHAR2, 
        p_table_name    IN VARCHAR2, 
        p_column_name   IN VARCHAR2, 
        p_sg_pref       IN VARCHAR2, 
        p_ds_pref       IN VARCHAR2, 
        p_lx_pref       IN VARCHAR2
    );
    
    PROCEDURE drop_text_index(p_index_name IN VARCHAR2);
    
    FUNCTION convert_text_query(p_enduser_query IN VARCHAR2) RETURN VARCHAR2;
END pck_ri_vorschrift_oracle_text_pkg;
/
</code></pre>

<h2 id="package-body-implementation">Package Body Implementation</h2>
<pre data-line="1,7,15,25,34,52" class="language-sql line-numbers"><code class="language-sql">CREATE OR REPLACE PACKAGE BODY pck_ri_vorschrift_oracle_text_pkg IS
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
            WHILE l_pos <= c_len LOOP
                l_char := SUBSTR(p_enduser_query, l_pos, 1);
                IF l_char = '"' THEN
                    IF SUBSTR(p_enduser_query, l_pos + 1) = '"' THEN
                         l_token := l_token || l_char;
                         l_pos := l_pos + 2;
                         CONTINUE;
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
            END LOOP;
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
END pck_ri_vorschrift_oracle_text_pkg;
/
</code></pre>

<h2 id="using-the-package">Using the Package</h2>

<h3>Check if Oracle Text is available:</h3>
<pre data-line="1,5,7" class="language-sql line-numbers"><code class="language-sql">DECLARE
  v_available BOOLEAN;
BEGIN
  v_available := pck_ri_vorschrift_oracle_text_pkg.text_is_available;
  DBMS_OUTPUT.PUT_LINE('Oracle Text available: ' || CASE WHEN v_available THEN 'Yes' ELSE 'No' END);
END;
/
</code></pre>

<h3>Create text preferences:</h3>
<pre data-line="1,3,5,7,9,11" class="language-sql line-numbers"><code class="language-sql">BEGIN
  pck_ri_vorschrift_oracle_text_pkg.create_text_preferences(
    p_pref_name => 'RI_VORSCHRIFT_DS_PREF',
    p_object_name => 'MULTI_COLUMN_DATASTORE',
    p_columns => 'VORSCHRIFT_NUMMER,VORSCHRIFT_BEZEICHNUNG_DEUTSCH',
    p_section_group => 'RI_VORSCHRIFT_SG_PREF',
    p_tag => 'VORSCHRIFT_BEZEICHNUNG_DEUTSCH',
    p_lexer_name => 'RI_VORSCHRIFT_LX_PREF',
    p_mixed_case => 'NO',
    p_base_letter => 'YES',
    p_base_letter_type => 'GENERIC'
  );
END;
/
</code></pre>

<h3>Create a text index:</h3>
<pre data-line="1,3,5,7,9" class="language-sql line-numbers"><code class="language-sql">BEGIN
  pck_ri_vorschrift_oracle_text_pkg.create_text_index(
    p_index_name => 'RI_VORSCHRIFT_TEXT_FTX',
    p_table_name => 'T_VORSCHRIFT_SYNTHETIC',
    p_column_name => 'VORSCHRIFT_NUMMER',
    p_sg_pref => 'RI_VORSCHRIFT_SG_PREF',
    p_ds_pref => 'RI_VORSCHRIFT_DS_PREF',
    p_lx_pref => 'RI_VORSCHRIFT_LX_PREF'
  );
END;
/
</code></pre>

<h3>Convert a user query to Oracle Text format:</h3>
<pre data-line="1,3,5,7" class="language-sql line-numbers"><code class="language-sql">DECLARE
  v_text_query VARCHAR2(4000);
BEGIN
  v_text_query := pck_ri_vorschrift_oracle_text_pkg.convert_text_query('user search terms');
  DBMS_OUTPUT.PUT_LINE('Oracle Text query: ' || v_text_query);
END;
/
</code></pre>

<h3>Use the converted query in a SELECT statement:</h3>
<pre data-line="1,3,5" class="language-sql line-numbers"><code class="language-sql">SELECT *
FROM T_VORSCHRIFT_SYNTHETIC
WHERE CONTAINS(VORSCHRIFT_NUMMER, pck_ri_vorschrift_oracle_text_pkg.convert_text_query('user search terms')) > 0;
</code></pre>

<h2 id="troubleshooting">Troubleshooting</h2>
<p>If you encounter issues with text preferences or indexes, ensure that:</p>
<ul>
  <li>The user has the CTXAPP role and necessary system privileges.</li>
  <li>The specified tables and columns exist and are accessible.</li>
  <li>There are no naming conflicts with existing preferences or indexes.</li>
</ul>
<p>For query conversion issues, check the input format and ensure it doesn't contain any unsupported characters or syntax.</p>
<p>Use the <code>apex_debug.info</code> calls in the <code>convert_text_query</code> function to log the generated Oracle Text queries.</p>
