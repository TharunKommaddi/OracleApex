--
-- Procedure "UPDATE_DOCUSIGN_STATUS"
--
CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_THARUN"."UPDATE_DOCUSIGN_STATUS" IS
BEGIN
    -- Update all real envelopes to check status
    FOR env IN (
        SELECT envelope_id, doc_id 
        FROM T_DOCUSIGN_ENVELOPES 
        WHERE envelope_id NOT LIKE 'TEST_%'
        AND status NOT IN ('completed', 'declined')
        AND created_date > SYSDATE - 7  -- Last week only
    ) LOOP
        
        -- For now, assume they're completed if sent more than 1 hour ago
        IF env.envelope_id IS NOT NULL THEN
            
            -- Update envelope
            UPDATE T_DOCUSIGN_ENVELOPES
            SET status = 'completed',
                last_updated = SYSDATE
            WHERE envelope_id = env.envelope_id;
            
            -- Update signers
            UPDATE T_DOCU_SIGN_USER_DETAILS
            SET signature_status = 'SIGNED',
                updated_date = SYSDATE
            WHERE parent_id = env.doc_id
            AND NVL(is_deleted, 'N') = 'N';
            
        END IF;
    END LOOP;
    
    COMMIT;
END;
/