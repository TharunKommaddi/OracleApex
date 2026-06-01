--
-- Trigger "TRG_CLEANUP_OLD_CHATS"
--
CREATE OR REPLACE EDITIONABLE TRIGGER "WKSP_THARUN"."TRG_CLEANUP_OLD_CHATS" 
    AFTER INSERT ON T_chat_conversations
DECLARE
    v_deleted_count NUMBER;
BEGIN
    -- Only run cleanup randomly (10% chance) to avoid performance impact
    IF DBMS_RANDOM.VALUE(1, 100) <= 10 THEN
        -- Delete conversations older than 24 hours
        DELETE FROM T_chat_conversations 
        WHERE message_timestamp < (SYSTIMESTAMP - INTERVAL '24' HOUR);
        
        v_deleted_count := SQL%ROWCOUNT;
        
        -- Only commit if we actually deleted something
        IF v_deleted_count > 0 THEN
            COMMIT;
        END IF;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- Don't let cleanup errors affect the main insert
        NULL;
END;
ALTER TRIGGER "WKSP_THARUN"."TRG_CLEANUP_OLD_CHATS" ENABLE
/