--
-- Package_Body "PCK_RAG_CHATBOT"
--
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."PCK_RAG_CHATBOT" AS

  -- ============================================================
  -- FUNCTION: GET_DB_CONTEXT
  -- Searches DB and builds context string for Groq
  -- ============================================================
  FUNCTION GET_DB_CONTEXT(p_question IN VARCHAR2) RETURN CLOB IS
    l_context  CLOB := '';
    l_question VARCHAR2(500) := UPPER(p_question);
  BEGIN
    -- Always include summary counts
    FOR rec IN (SELECT COUNT(*) AS cnt FROM T_CUSTOMERS) LOOP
      l_context := l_context || 'Total customers = ' || rec.cnt || CHR(10);
    END LOOP;
    FOR rec IN (SELECT COUNT(*) AS cnt FROM T_PRODUCTS) LOOP
      l_context := l_context || 'Total products = ' || rec.cnt || CHR(10);
    END LOOP;
    FOR rec IN (SELECT COUNT(*) AS cnt FROM T_ORDERS) LOOP
      l_context := l_context || 'Total orders = ' || rec.cnt || CHR(10);
    END LOOP;

    -- Customer context
    IF INSTR(l_question,'CUSTOMER') > 0 
    OR INSTR(l_question,'WHO')      > 0
    OR INSTR(l_question,'CLIENT')   > 0 THEN
      l_context := l_context || CHR(10) || '=== CUSTOMERS ===' || CHR(10);
      FOR rec IN (
        SELECT NAME, EMAIL, CITY, COUNTRY
        FROM T_CUSTOMERS
        ORDER BY NAME
      ) LOOP
        l_context := l_context ||
          'Customer: '  || rec.NAME ||
          ', City: '    || NVL(rec.CITY,    'N/A') ||
          ', Country: ' || NVL(rec.COUNTRY, 'N/A') ||
          ', Email: '   || NVL(rec.EMAIL,   'N/A') || CHR(10);
      END LOOP;
    END IF;

    -- Product context
    IF INSTR(l_question,'PRODUCT')   > 0
    OR INSTR(l_question,'PRICE')     > 0
    OR INSTR(l_question,'EXPENSIVE') > 0
    OR INSTR(l_question,'CHEAP')     > 0
    OR INSTR(l_question,'ITEM')      > 0 THEN
      l_context := l_context || CHR(10) || '=== PRODUCTS ===' || CHR(10);
      FOR rec IN (
        SELECT PRODUCT_NAME, UNIT_PRICE
        FROM T_PRODUCTS
        ORDER BY UNIT_PRICE DESC
      ) LOOP
        l_context := l_context ||
          'Product: ' || rec.PRODUCT_NAME ||
          ', Price: $' || rec.UNIT_PRICE || CHR(10);
      END LOOP;
    END IF;

    -- Order context
    IF INSTR(l_question,'ORDER')    > 0
    OR INSTR(l_question,'PURCHASE') > 0
    OR INSTR(l_question,'BUY')      > 0 THEN
      l_context := l_context || CHR(10) || '=== ORDERS ===' || CHR(10);
      FOR rec IN (
        SELECT 
          o.ORDER_ID,
          c.NAME     AS CNAME,
          o.ORDER_DATE
        FROM T_ORDERS o
        JOIN T_CUSTOMERS c ON c.CUSTOMER_ID = o.CUSTOMER_ID
        ORDER BY o.ORDER_DATE DESC
      ) LOOP
        l_context := l_context ||
          'Order #'      || rec.ORDER_ID ||
          ', Customer: ' || rec.CNAME ||
          ', Date: '     || TO_CHAR(rec.ORDER_DATE,'DD-MON-YYYY') || CHR(10);
      END LOOP;
    END IF;

    -- Employee context
    IF INSTR(l_question,'EMPLOYEE') > 0
    OR INSTR(l_question,'STAFF')    > 0
    OR INSTR(l_question,'WORKER')   > 0 THEN
      l_context := l_context || CHR(10) || '=== EMPLOYEES ===' || CHR(10);
      FOR rec IN (
        SELECT ENAME, JOB, SAL, DEPTNO
        FROM T_EMPLOYEE
        ORDER BY ENAME
      ) LOOP
        l_context := l_context ||
          'Employee: ' || rec.ENAME ||
          ', Job: '    || NVL(rec.JOB,  'N/A') ||
          ', Salary: ' || NVL(TO_CHAR(rec.SAL), 'N/A') ||
          ', Dept: '   || NVL(TO_CHAR(rec.DEPTNO), 'N/A') || CHR(10);
      END LOOP;
    END IF;

    RETURN l_context;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 'Context error: ' || SQLERRM;
  END GET_DB_CONTEXT;

  -- ============================================================
  -- FUNCTION: ASK_RAG
  -- Sends context + question to Groq → returns answer
  -- ============================================================
  FUNCTION ASK_RAG(p_question IN VARCHAR2) RETURN CLOB IS
    l_context  CLOB;
    l_system   CLOB;
    l_body     CLOB;
    l_response CLOB;
    l_answer   CLOB;
    l_api_key  VARCHAR2(500);
  BEGIN
    -- Fetch Groq API key from T_API_KEYS
    SELECT KEY_VALUE INTO l_api_key
    FROM T_API_KEYS
    WHERE KEY_NAME = 'GROQ_API_KEY';

    -- Get DB context
    l_context := GET_DB_CONTEXT(p_question);

    -- Build system prompt
    l_system :=
      'You are a helpful database assistant for a company. ' ||
      'Answer questions ONLY based on the database data provided below. ' ||
      'If the data does not contain the answer, say so clearly. ' ||
      'Be concise, friendly and use bullet points where helpful.' ||
      CHR(10) || CHR(10) ||
      'DATABASE DATA:' || CHR(10) || l_context;

    -- Build JSON body using APEX_JSON
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('model', 'llama-3.3-70b-versatile');
      APEX_JSON.OPEN_ARRAY('messages');
        APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('role',    'system');
          APEX_JSON.WRITE('content', l_system);
        APEX_JSON.CLOSE_OBJECT;
        APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('role',    'user');
          APEX_JSON.WRITE('content', p_question);
        APEX_JSON.CLOSE_OBJECT;
      APEX_JSON.CLOSE_ARRAY;
      APEX_JSON.WRITE('max_tokens',  500);
      APEX_JSON.WRITE('temperature', 0.3);
    APEX_JSON.CLOSE_OBJECT;
    l_body := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    -- Call Groq API via APEX_WEB_SERVICE
    APEX_WEB_SERVICE.CLEAR_REQUEST_HEADERS;
    APEX_WEB_SERVICE.SET_REQUEST_HEADERS(
      p_name_01  => 'Authorization',
      p_value_01 => 'Bearer ' || l_api_key,
      p_name_02  => 'Content-Type',
      p_value_02 => 'application/json'
    );

    l_response := APEX_WEB_SERVICE.MAKE_REST_REQUEST(
      p_url         => 'https://api.groq.com/openai/v1/chat/completions',
      p_http_method => 'POST',
      p_body        => l_body
    );

    -- Parse response
    APEX_JSON.PARSE(l_response);
    l_answer := APEX_JSON.GET_CLOB(p_path => 'choices[1].message.content');

    RETURN l_answer;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 'Error: ' || SQLERRM;
  END ASK_RAG;

END PCK_RAG_CHATBOT;
/