--
-- Procedure "CHECK_ALL_ENVELOPE_STATUS"
--
CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_THARUN"."CHECK_ALL_ENVELOPE_STATUS" IS
    l_access_token VARCHAR2(4000);
    l_status VARCHAR2(50);
    l_count NUMBER := 0;
BEGIN
    -- Get OAuth token
    l_access_token := get_docusign_token;
    
    debug('Auto Status Check', 'Starting automatic status check...');
    
    IF l_access_token IS NULL THEN
        debug('Auto Status Check', 'No OAuth token available - skipping real status check');
        RETURN;
    END IF;
    
    -- Check all active envelopes that are not completed
    FOR envelope_rec IN (
        SELECT envelope_id, doc_id, status
        FROM T_DOCUSIGN_ENVELOPES 
        WHERE status NOT IN ('completed', 'declined', 'voided')
        AND envelope_id NOT LIKE 'TEST_%'  -- Only real envelopes
        AND created_date > SYSDATE - 30    -- Last 30 days only
    ) LOOP
        
        BEGIN
            -- Get current status from DocuSign
            l_status := docusign_pkg.get_envelope_status(
                envelope_rec.envelope_id, 
                l_access_token
            );
            
            debug('Auto Status Check', 'Envelope ' || envelope_rec.envelope_id || ': ' || envelope_rec.status || ' -> ' || l_status);
            
            -- Update if status changed
            IF l_status IS NOT NULL AND l_status != envelope_rec.status THEN
                
                -- Update envelope status
                UPDATE T_DOCUSIGN_ENVELOPES
                SET status = l_status,
                    last_updated = SYSDATE
                WHERE envelope_id = envelope_rec.envelope_id;
                
                -- Update signer status if envelope is completed
                IF LOWER(l_status) = 'completed' THEN
                    UPDATE T_DOCU_SIGN_USER_DETAILS
                    SET signature_status = 'SIGNED',
                        updated_date = SYSDATE,
                        updated_by = 'AUTO_UPDATE'
                    WHERE parent_id = envelope_rec.doc_id
                    AND NVL(is_deleted, 'N') = 'N'
                    AND signature_status != 'SIGNED';
                    
                    debug('Auto Status Check', 'Updated signers for doc ' || envelope_rec.doc_id || ' to SIGNED');
                END IF;
                
                l_count := l_count + 1;
                
            END IF;
            
        EXCEPTION
            WHEN OTHERS THEN
                debug('Auto Status Check Error', 'Failed to check ' || envelope_rec.envelope_id || ': ' || SQLERRM);
        END;
        
    END LOOP;
    
    COMMIT;
    
    debug('Auto Status Check', 'Completed. Updated ' || l_count || ' envelopes.');
    
EXCEPTION
    WHEN OTHERS THEN
        debug('Auto Status Check Fatal', SQLERRM);
END;
/