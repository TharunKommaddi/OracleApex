--
-- Package_Body "DOCUSIGN_PKG"
--
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."DOCUSIGN_PKG" AS

    FUNCTION get_access_token(p_auth_code IN VARCHAR2) RETURN VARCHAR2 IS
        l_response CLOB;
        l_body VARCHAR2(4000);
        l_access_token VARCHAR2(4000);
        l_json_response apex_json.t_values;
        l_error VARCHAR2(1000);
    BEGIN
        debug('OAuth', 'Starting token exchange with auth code: ' || SUBSTR(p_auth_code, 1, 50));
        
        -- Build request body
        l_body := 'grant_type=authorization_code' ||
                  '&code=' || p_auth_code ||
                  '&redirect_uri=https://gd1895d7a91019d-h5vz0428ux25xs1n.adb.eu-frankfurt-1.oraclecloudapps.com/ords/f?p=200:194' ||
                  '&client_id=' || g_integration_key ||
                  '&client_secret=' || g_client_secret;

        -- Set headers
        apex_web_service.g_request_headers(1).name := 'Content-Type';
        apex_web_service.g_request_headers(1).value := 'application/x-www-form-urlencoded';

        -- Make token request
        l_response := apex_web_service.make_rest_request(
            p_url         => g_auth_base_uri || '/oauth/token',
            p_http_method => 'POST',
            p_body        => l_body
        );

        debug('OAuth Response', l_response);

        -- Parse response
        apex_json.parse(l_json_response, l_response);
        l_access_token := apex_json.get_varchar2(p_path => 'access_token', p_values => l_json_response);

        IF l_access_token IS NULL THEN
            l_error := apex_json.get_varchar2(p_path => 'error', p_values => l_json_response);
            debug('OAuth Error', l_error);
            RETURN NULL;
        END IF;

        debug('OAuth Success', 'Token obtained successfully');
        RETURN l_access_token;

    EXCEPTION
        WHEN OTHERS THEN
            debug('OAuth Exception', SQLERRM);
            RETURN NULL;
    END get_access_token;

    FUNCTION send_envelope_to_docusign(
        p_doc_id IN NUMBER,
        p_file_blob IN BLOB,
        p_document_name IN VARCHAR2,
        p_access_token IN VARCHAR2
    ) RETURN VARCHAR2 IS
        l_request CLOB;
        l_response CLOB;
        l_doc_base64 CLOB;
        l_signers_json CLOB := '';
        l_envelope_id VARCHAR2(100);
        l_doc_name VARCHAR2(255);
        l_user_email VARCHAR2(200);
        l_json_response apex_json.t_values;
    BEGIN
        debug('Send Real Envelope', 'Starting for doc_id: ' || p_doc_id);
        
        -- Get document details
        SELECT email, NVL(document_title, 'Document') 
        INTO l_user_email, l_doc_name
        FROM T_DOCUSIGN_USERS 
        WHERE user_id = p_doc_id;
        
        -- Convert document to base64
        l_doc_base64 := apex_web_service.blob2clobbase64(p_file_blob);
        
        -- Build signers JSON from your details table
        FOR r_signer IN (
            SELECT signatory_name as email,
                   NVL(signatory_name, 'Signer') as name,
                   NVL(TO_NUMBER(sequence_of_signature), ROWNUM) as routing_order,
                   ROWNUM as recipient_id
            FROM T_DOCU_SIGN_USER_DETAILS 
            WHERE parent_id = p_doc_id
            AND NVL(is_deleted, 'N') = 'N'
            ORDER BY NVL(TO_NUMBER(sequence_of_signature), ROWNUM)
        ) LOOP
            IF l_signers_json IS NOT NULL THEN
                l_signers_json := l_signers_json || ',';
            END IF;
            
            l_signers_json := l_signers_json || 
                '{' ||
                '"email":"' || r_signer.email || '",' ||
                '"name":"' || r_signer.name || '",' ||
                '"recipientId":"' || r_signer.recipient_id || '",' ||
                '"routingOrder":"' || r_signer.routing_order || '",' ||
                '"tabs": {' ||
                '  "signHereTabs": [{' ||
                '    "documentId": "1",' ||
                '    "pageNumber": "1",' ||
                '    "xPosition": "200",' ||
                '    "yPosition": "200"' ||
                '  }]' ||
                '}' ||
                '}';
        END LOOP;
        
        -- Build envelope request
        l_request := '{
            "emailSubject": "Please sign: ' || l_doc_name || '",
            "emailBlurb": "Please review and sign this document",
            "documents": [{
                "documentId": "1",
                "name": "' || NVL(p_document_name, l_doc_name) || '",
                "fileExtension": "pdf",
                "documentBase64": "' || l_doc_base64 || '"
            }],
            "recipients": {
                "signers": [' || l_signers_json || ']
            },
            "status": "sent"
        }';
        
        debug('DocuSign Request', 'Sending envelope to DocuSign API');
        
        -- Set headers for DocuSign API
        apex_web_service.g_request_headers(1).name := 'Authorization';
        apex_web_service.g_request_headers(1).value := 'Bearer ' || p_access_token;
        apex_web_service.g_request_headers(2).name := 'Content-Type';
        apex_web_service.g_request_headers(2).value := 'application/json';
        
        -- Make the envelope creation request
        l_response := apex_web_service.make_rest_request(
            p_url         => g_api_base_uri || '/restapi/v2.1/accounts/' || g_account_id || '/envelopes',
            p_http_method => 'POST',
            p_body        => l_request
        );
        
        debug('DocuSign Response', l_response);
        
        -- Parse response to get envelope ID
        apex_json.parse(l_json_response, l_response);
        l_envelope_id := apex_json.get_varchar2(p_path => 'envelopeId', p_values => l_json_response);
        
        IF l_envelope_id IS NULL THEN
            debug('DocuSign Error', 'No envelope ID returned');
            RETURN NULL;
        END IF;
        
        debug('DocuSign Success', 'Envelope created: ' || l_envelope_id);
        RETURN l_envelope_id;
        
    EXCEPTION
        WHEN OTHERS THEN
            debug('Send Envelope Error', SQLERRM);
            RETURN NULL;
    END send_envelope_to_docusign;

    PROCEDURE send_envelope(
        p_doc_id IN NUMBER,
        p_file_blob IN BLOB,
        p_document_name IN VARCHAR2
    ) IS
        l_envelope_id VARCHAR2(100);
        l_signer_count NUMBER := 0;
        l_doc_name VARCHAR2(255);
    BEGIN
        debug('Send Envelope', 'Starting envelope creation for doc_id: ' || p_doc_id);
        
        -- Validate inputs
        IF p_file_blob IS NULL THEN
            RAISE_APPLICATION_ERROR(-20005, 'Document file is required');
        END IF;
        
        -- Check if signatories exist
        SELECT COUNT(*) INTO l_signer_count
        FROM T_DOCU_SIGN_USER_DETAILS 
        WHERE parent_id = p_doc_id 
        AND NVL(is_deleted, 'N') = 'N';
        
        IF l_signer_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20007, 'At least one signatory is required. Please add signatories first.');
        END IF;
        
        debug('Send Envelope', 'Found ' || l_signer_count || ' signatories');
        
        -- For now, create a test envelope (in production, use real DocuSign API)
        l_envelope_id := 'TEST_ENV_' || p_doc_id || '_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
        
        -- Store envelope info in your table
        INSERT INTO T_DOCUSIGN_ENVELOPES (
            envelope_id,
            doc_id,
            status,
            created_by,
            created_date,
            last_updated
        ) VALUES (
            l_envelope_id,
            p_doc_id,
            'TEST_SENT',
            NVL(USER, 'SYSTEM'),
            SYSDATE,
            SYSDATE
        );
        
        -- Update signatory status
        UPDATE T_DOCU_SIGN_USER_DETAILS
        SET signature_status = 'TEST_PENDING',
            updated_date = SYSDATE,
            updated_by = NVL(USER, 'SYSTEM')
        WHERE parent_id = p_doc_id
        AND NVL(is_deleted, 'N') = 'N';
        
        COMMIT;
        
        debug('Send Envelope Success', 'Test envelope created: ' || l_envelope_id);
        
        -- Show how to use real DocuSign
        debug('Real Integration Note', 'To use real DocuSign: 1) Get OAuth token from page 188, 2) Call send_envelope_to_docusign with token');
        
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            debug('Send Envelope Error', SQLERRM);
            RAISE;
    END send_envelope;

    FUNCTION get_envelope_status(
        p_envelope_id IN VARCHAR2,
        p_access_token IN VARCHAR2
    ) RETURN VARCHAR2 IS
        l_response CLOB;
        l_status VARCHAR2(100);
        l_json_response apex_json.t_values;
    BEGIN
        IF p_access_token IS NULL OR INSTR(p_envelope_id, 'TEST_') = 1 THEN
            RETURN 'TEST_STATUS';
        END IF;
        
        -- Set headers
        apex_web_service.g_request_headers(1).name := 'Authorization';
        apex_web_service.g_request_headers(1).value := 'Bearer ' || p_access_token;
        
        -- Get envelope status from DocuSign
        l_response := apex_web_service.make_rest_request(
            p_url         => g_api_base_uri || '/restapi/v2.1/accounts/' || g_account_id || '/envelopes/' || p_envelope_id,
            p_http_method => 'GET'
        );
        
        -- Parse status
        apex_json.parse(l_json_response, l_response);
        l_status := apex_json.get_varchar2(p_path => 'status', p_values => l_json_response);
        
        RETURN NVL(l_status, 'UNKNOWN');
        
    EXCEPTION
        WHEN OTHERS THEN
            debug('Get Status Error', SQLERRM);
            RETURN 'ERROR';
    END get_envelope_status;

    PROCEDURE update_envelope_status(
        p_envelope_id IN VARCHAR2,
        p_status IN VARCHAR2
    ) IS
    BEGIN
        UPDATE T_DOCUSIGN_ENVELOPES
        SET status = UPPER(p_status),
            last_updated = SYSDATE
        WHERE envelope_id = p_envelope_id;
        
        IF SQL%ROWCOUNT > 0 THEN
            COMMIT;
            debug('Status Update', 'Envelope ' || p_envelope_id || ' updated to ' || p_status);
        ELSE
            debug('Status Update', 'Envelope not found: ' || p_envelope_id);
        END IF;
        
    EXCEPTION
        WHEN OTHERS THEN
            debug('Status Update Error', SQLERRM);
    END update_envelope_status;

    PROCEDURE fetch_and_store_envelopes(p_access_token IN VARCHAR2) IS
        l_response CLOB;
        l_json_response apex_json.t_values;
        l_envelope_count NUMBER := 0;
        l_envelope_id VARCHAR2(100);
        l_status VARCHAR2(50);
        l_subject VARCHAR2(500);
    BEGIN
        IF p_access_token IS NULL THEN
            debug('Fetch Envelopes', 'No access token provided');
            RETURN;
        END IF;
        
        -- Set headers
        apex_web_service.g_request_headers(1).name := 'Authorization';
        apex_web_service.g_request_headers(1).value := 'Bearer ' || p_access_token;

        -- Call DocuSign Envelopes API
        l_response := apex_web_service.make_rest_request(
            p_url         => g_api_base_uri || '/restapi/v2.1/accounts/' || g_account_id || '/envelopes?from_date=2024-01-01T00:00:00Z',
            p_http_method => 'GET'
        );

        debug('Fetch Envelopes', 'API Response received');

        -- Parse JSON response
        apex_json.parse(l_json_response, l_response);
        l_envelope_count := apex_json.get_number(p_path => 'resultSetSize', p_values => l_json_response);
        
        debug('Fetch Envelopes', 'Found ' || l_envelope_count || ' envelopes');

        -- Process each envelope
        FOR i IN 1..l_envelope_count LOOP
            l_envelope_id := apex_json.get_varchar2(p_path => 'envelopes[%d].envelopeId', p0 => i, p_values => l_json_response);
            l_status := apex_json.get_varchar2(p_path => 'envelopes[%d].status', p0 => i, p_values => l_json_response);
            l_subject := apex_json.get_varchar2(p_path => 'envelopes[%d].emailSubject', p0 => i, p_values => l_json_response);

            -- Store or update envelope
            MERGE INTO T_DOCUSIGN_ENVELOPES d
            USING (SELECT l_envelope_id as envelope_id FROM dual) s
            ON (d.envelope_id = s.envelope_id)
            WHEN MATCHED THEN
                UPDATE SET 
                    status = l_status,
                    last_updated = SYSDATE
            WHEN NOT MATCHED THEN
                INSERT (envelope_id, doc_id, status, created_by, created_date, last_updated)
                VALUES (l_envelope_id, 0, l_status, 'DOCUSIGN_API', SYSDATE, SYSDATE);
                
            debug('Process Envelope', 'ID: ' || l_envelope_id || ', Status: ' || l_status);
        END LOOP;

        COMMIT;
        
    EXCEPTION
        WHEN OTHERS THEN
            debug('Fetch Envelopes Error', SQLERRM);
    END fetch_and_store_envelopes;

    FUNCTION create_oauth_url RETURN VARCHAR2 IS
    BEGIN
        RETURN g_auth_base_uri || '/oauth/auth?' ||
               'response_type=code' ||
               '&scope=signature' ||
               '&client_id=' || g_integration_key ||
               '&redirect_uri=https://gd1895d7a91019d-h5vz0428ux25xs1n.adb.eu-frankfurt-1.oraclecloudapps.com/ords/f?p=200:194';
    END create_oauth_url;

    PROCEDURE test_package IS
        l_count NUMBER;
        l_oauth_url VARCHAR2(1000);
    BEGIN
        debug('Package Test', '=== TESTING DOCUSIGN PACKAGE ===');
        debug('Package Test', 'Integration Key: ' || g_integration_key);
        debug('Package Test', 'Account ID: ' || g_account_id);
        
        -- Test table access
        SELECT COUNT(*) INTO l_count FROM T_DOCUSIGN_USERS;
        debug('Package Test', 'T_DOCUSIGN_USERS count: ' || l_count);
        
        SELECT COUNT(*) INTO l_count FROM T_DOCUSIGN_ENVELOPES;
        debug('Package Test', 'T_DOCUSIGN_ENVELOPES count: ' || l_count);
        
        SELECT COUNT(*) INTO l_count FROM T_DOCU_SIGN_USER_DETAILS;
        debug('Package Test', 'T_DOCU_SIGN_USER_DETAILS count: ' || l_count);
        
        -- Test OAuth URL generation
        l_oauth_url := create_oauth_url;
        debug('Package Test', 'OAuth URL: ' || l_oauth_url);
        
        debug('Package Test', '=== PACKAGE READY FOR USE ===');
        debug('Package Test', 'Use APEX page 188 to start OAuth flow');
        debug('Package Test', 'Use APEX page 192 to create and send documents');
        
    EXCEPTION
        WHEN OTHERS THEN
            debug('Package Test Error', SQLERRM);
    END test_package;

END docusign_pkg;
/