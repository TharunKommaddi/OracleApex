--
-- Procedure "YT_POST_AUTH"
--
CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_THARUN"."YT_POST_AUTH" AS
BEGIN
  -- Log all available JSON keys for debugging
  debug('POST_AUTH_SUB', APEX_JSON.GET_VARCHAR2('sub'));
  debug('POST_AUTH_EMAIL', APEX_JSON.GET_VARCHAR2('email'));
  debug('POST_AUTH_TOKEN', APEX_JSON.GET_VARCHAR2('access_token'));
  
  -- Store access token in application item
  APEX_UTIL.SET_SESSION_STATE(
    'G_ACCESS_TOKEN',
    APEX_JSON.GET_VARCHAR2('access_token')
  );
END;
/