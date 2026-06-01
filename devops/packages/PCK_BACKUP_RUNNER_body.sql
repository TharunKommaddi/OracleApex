--
-- Package_Body "PCK_BACKUP_RUNNER"
--
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."PCK_BACKUP_RUNNER" AS
    PROCEDURE P_RUN_ALL_BACKUPS(p_token IN VARCHAR2) IS
    BEGIN
        FOR r IN (
            SELECT app_id, app_label, github_repo,
                   github_branch, base_path
            FROM   T_BACKUP_CONFIG
            WHERE  is_enabled = 'Y'
        ) LOOP
            PCK_GITHUB_BACKUP.P_BACKUP_APPLICATION(
                p_app_id      => r.app_id,
                p_github_repo => r.github_repo,
                p_branch      => r.github_branch,
                p_base_path   => r.base_path,
                p_token       => p_token
            );
        END LOOP;
    END P_RUN_ALL_BACKUPS;
END PCK_BACKUP_RUNNER;
/