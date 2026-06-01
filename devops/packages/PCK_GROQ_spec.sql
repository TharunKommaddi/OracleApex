--
-- Package "PCK_GROQ"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_THARUN"."PCK_GROQ" AS
    FUNCTION F_ASK_GROQ(
        p_question IN VARCHAR2,
        p_api_key  IN VARCHAR2
    ) RETURN VARCHAR2;
END PCK_GROQ;
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."PCK_GROQ" AS

    FUNCTION F_ASK_GROQ(
        p_question IN VARCHAR2,
        p_api_key  IN VARCHAR2
    ) RETURN VARCHAR2 IS
        l_url      VARCHAR2(500);
        l_body     CLOB;
        l_response CLOB;
        l_answer   VARCHAR2(32767);
    BEGIN
        l_url := 'https://api.groq.com/openai/v1/chat/completions';

        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('model', 'llama-3.3-70b-versatile');
            APEX_JSON.WRITE('max_tokens', 1024);
            APEX_JSON.OPEN_ARRAY('messages');
                APEX_JSON.OPEN_OBJECT;
                    APEX_JSON.WRITE('role', 'user');
                    APEX_JSON.WRITE('content', p_question);
                APEX_JSON.CLOSE_OBJECT;
            APEX_JSON.CLOSE_ARRAY;
        APEX_JSON.CLOSE_OBJECT;
        l_body := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        APEX_WEB_SERVICE.CLEAR_REQUEST_HEADERS;
        APEX_WEB_SERVICE.SET_REQUEST_HEADERS(
            p_name_01  => 'Content-Type',
            p_value_01 => 'application/json',
            p_name_02  => 'Authorization',
            p_value_02 => 'Bearer ' || p_api_key
        );

        l_response := APEX_WEB_SERVICE.MAKE_REST_REQUEST(
            p_url         => l_url,
            p_http_method => 'POST',
            p_body        => l_body
        );

        APEX_JSON.PARSE(l_response);
        l_answer := APEX_JSON.GET_VARCHAR2(
            p_path => 'choices[1].message.content'
        );

        RETURN NVL(l_answer, 'No response — HTTP: ' || APEX_WEB_SERVICE.G_STATUS_CODE);

    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Error: ' || SQLERRM;
    END F_ASK_GROQ;

END PCK_GROQ;
/