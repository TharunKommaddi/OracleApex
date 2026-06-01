--
-- Procedure "CLEANUP_OLD_CHAT_CONVERSATIONS"
--
CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_THARUN"."CLEANUP_OLD_CHAT_CONVERSATIONS" AS
BEGIN
    -- Delete conversations older than 24 hours
    DELETE FROM T_chat_conversations 
    WHERE message_timestamp < (SYSTIMESTAMP - INTERVAL '24' HOUR);
    
    -- Log how many records were deleted
    DBMS_OUTPUT.PUT_LINE('Deleted ' || SQL%ROWCOUNT || ' old chat conversations');
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error cleaning up chat conversations: ' || SQLERRM);
END;
/