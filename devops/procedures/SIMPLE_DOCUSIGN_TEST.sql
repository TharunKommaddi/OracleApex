--
-- Procedure "SIMPLE_DOCUSIGN_TEST"
--
CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_THARUN"."SIMPLE_DOCUSIGN_TEST" AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ALTERNATIVE APPROACH ===');
    DBMS_OUTPUT.PUT_LINE('If PKCE continues to cause issues, you can:');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Option 1: Change DocuSign app to use "Implicit Grant" instead of "Authorization Code Grant with PKCE"');
    DBMS_OUTPUT.PUT_LINE('Option 2: Implement full JWT authentication (more complex)');
    DBMS_OUTPUT.PUT_LINE('Option 3: Use a simpler integration method');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('For now, try the PKCE version above first.');
    DBMS_OUTPUT.PUT_LINE('=== END ALTERNATIVES ===');
END;
/