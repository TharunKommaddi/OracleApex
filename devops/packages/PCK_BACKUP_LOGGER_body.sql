--
-- Package_Body "PCK_BACKUP_LOGGER"
--
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."PCK_BACKUP_LOGGER" AS
    PROCEDURE P_LOG(
        p_app_id       IN NUMBER,
        p_app_alias    IN VARCHAR2,
        p_status       IN VARCHAR2,
        p_http_status  IN NUMBER DEFAULT NULL,
        p_message      IN VARCHAR2,
        p_error_code   IN VARCHAR2 DEFAULT NULL,
        p_duration_s   IN NUMBER DEFAULT NULL
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO T_BACKUP_LOG (
            app_id, app_alias, status, http_status,
            message, error_code, run_duration_s
        ) VALUES (
            p_app_id, p_app_alias, p_status, p_http_status,
            p_message, p_error_code, p_duration_s
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN NULL;
    END P_LOG;
END PCK_BACKUP_LOGGER;
/