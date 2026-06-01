--
-- Procedure "SEND_DOCUSIGN_ENVELOPE_MANUAL"
--
CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_THARUN"."SEND_DOCUSIGN_ENVELOPE_MANUAL" (
    p_doc_id IN NUMBER,
    p_access_token IN VARCHAR2
) IS
    l_file_blob BLOB;
    l_doc_name VARCHAR2(255);
    l_signers_json CLOB := '';
    l_doc_base64 CLOB;
    l_request CLOB;
    l_response CLOB;
    l_envelope_id VARCHAR2(100);
    l_account_id VARCHAR2(100) := 'd8ceab46-dd3d-4f82-af3e-1a9ea17735cc';
    l_api_url VARCHAR2(200) := 'https://demo.docusign.net';
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== MANUAL ENVELOPE SENDING ===');
    DBMS_OUTPUT.PUT_LINE('Document ID: ' || p_doc_id);
    
    -- Get document
    SELECT file_blob, document_name INTO l_file_blob, l_doc_name
    FROM T_DOCUSIGN_USERS
    WHERE user_id = p_doc_id;
    
    DBMS_OUTPUT.PUT_LINE('Document: ' || l_doc_name);
    
    -- Convert to base64
    l_doc_base64 := apex_web_service.blob2clobbase64(l_file_blob);
    DBMS_OUTPUT.PUT_LINE('Document size: ' || LENGTH(l_doc_base64) || ' chars');
    
    -- Build signers (simple version)
    FOR r IN (
        SELECT signatory_name, ROWNUM as id
        FROM T_DOCU_SIGN_USER_DETAILS 
        WHERE parent_id = p_doc_id
        AND NVL(is_deleted, 'N') = 'N'
        ORDER BY TO_NUMBER(NVL(sequence_of_signature, '1'))
    ) LOOP
        IF l_signers_json IS NOT NULL THEN
            l_signers_json := l_signers_json || ',';
        END IF;
        
        l_signers_json := l_signers_json || 
            '{"email":"' || r.signatory_name || 
            '","name":"' || r.signatory_name || 
            '","recipientId":"' || r.id || 
            '","routingOrder":"' || r.id || 
            '","tabs":{"signHereTabs":[{"documentId":"1","pageNumber":"1","xPosition":"100","yPosition":"100"}]}}';
        
        DBMS_OUTPUT.PUT_LINE('Added signer: ' || r.signatory_name);
    END LOOP;
    
    -- Build request
    l_request := '{"emailSubject":"Please sign: ' || l_doc_name || 
                 '","documents":[{"documentId":"1","name":"' || l_doc_name || 
                 '","fileExtension":"pdf","documentBase64":"' || l_doc_base64 || 
                 '"}],"recipients":{"signers":[' || l_signers_json || 
                 ']},"status":"sent"}';
    
    -- Send request
    apex_web_service.g_request_headers.delete();
    apex_web_service.g_request_headers(1).name := 'Authorization';
    apex_web_service.g_request_headers(1).value := 'Bearer ' || p_access_token;
    apex_web_service.g_request_headers(2).name := 'Content-Type';
    apex_web_service.g_request_headers(2).value := 'application/json';
    
    DBMS_OUTPUT.PUT_LINE('Sending to DocuSign...');
    
    l_response := apex_web_service.make_rest_request(
        p_url => l_api_url || '/restapi/v2.1/accounts/' || l_account_id || '/envelopes',
        p_http_method => 'POST',
        p_body => l_request
    );
    
    DBMS_OUTPUT.PUT_LINE('Response: ' || SUBSTR(l_response, 1, 200) || '...');
    
    -- Simple envelope ID extraction
    IF INSTR(l_response, '"envelopeId"') > 0 THEN
        DECLARE
            l_start_pos NUMBER;
            l_end_pos NUMBER;
        BEGIN
            l_start_pos := INSTR(l_response, '"envelopeId":"') + 14;
            l_end_pos := INSTR(l_response, '"', l_start_pos);
            l_envelope_id := SUBSTR(l_response, l_start_pos, l_end_pos - l_start_pos);
            
            DBMS_OUTPUT.PUT_LINE('🎉 SUCCESS! Envelope ID: ' || l_envelope_id);
            
            -- Store in database
            INSERT INTO T_DOCUSIGN_ENVELOPES (envelope_id, doc_id, status, created_by, created_date, last_updated)
            VALUES (l_envelope_id, p_doc_id, 'SENT', USER, SYSDATE, SYSDATE);
            
            UPDATE T_DOCU_SIGN_USER_DETAILS
            SET signature_status = 'PENDING', updated_date = SYSDATE
            WHERE parent_id = p_doc_id AND NVL(is_deleted, 'N') = 'N';
            
            COMMIT;
            
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error extracting envelope ID: ' || SQLERRM);
        END;
    ELSE
        DBMS_OUTPUT.PUT_LINE('❌ ERROR: No envelope ID in response');
        DBMS_OUTPUT.PUT_LINE('Full response: ' || l_response);
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('=== END MANUAL SENDING ===');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        ROLLBACK;
END;
/