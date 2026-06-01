--
-- Package_Body "PCK_GITHUB_BACKUP"
--
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."PCK_GITHUB_BACKUP" AS

    PROCEDURE P_PUSH_TO_GITHUB(
        p_github_repo IN VARCHAR2,
        p_branch      IN VARCHAR2,
        p_file_path   IN VARCHAR2,
        p_token       IN VARCHAR2,
        p_content     IN VARCHAR2,
        p_app_id      IN NUMBER
    ) IS
        l_url         VARCHAR2(1000);
        l_body        CLOB;
        l_response    CLOB;
        l_http_status NUMBER;
    BEGIN
        l_url := 'https://api.github.com/repos/' || p_github_repo ||
                 '/contents/' || p_file_path;

        APEX_WEB_SERVICE.CLEAR_REQUEST_HEADERS;
        APEX_WEB_SERVICE.SET_REQUEST_HEADERS(
            p_name_01  => 'Authorization',
            p_value_01 => 'token ' || p_token,
            p_name_02  => 'Accept',
            p_value_02 => 'application/vnd.github.v3+json',
            p_name_03  => 'User-Agent',
            p_value_03 => 'APEX-Backup-Bot',
            p_name_04  => 'Content-Type',
            p_value_04 => 'application/json'
        );

        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('message', 'Auto backup App ' || p_app_id || ' - ' || p_file_path);
        APEX_JSON.WRITE('branch',  p_branch);
        APEX_JSON.WRITE('content', p_content);
        APEX_JSON.CLOSE_OBJECT;
        l_body := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        l_response := APEX_WEB_SERVICE.MAKE_REST_REQUEST(
            p_url         => l_url,
            p_http_method => 'PUT',
            p_body        => l_body
        );

        l_http_status := APEX_WEB_SERVICE.G_STATUS_CODE;

        IF l_http_status NOT IN (200, 201) THEN
            RAISE_APPLICATION_ERROR(-20001,
                'GitHub push failed: HTTP ' || l_http_status ||
                ' - ' || SUBSTR(l_response, 1, 200));
        END IF;
    END P_PUSH_TO_GITHUB;

    PROCEDURE P_BACKUP_APPLICATION(
        p_app_id      IN NUMBER,
        p_github_repo IN VARCHAR2,
        p_branch      IN VARCHAR2,
        p_base_path   IN VARCHAR2,
        p_token       IN VARCHAR2
    ) IS
        l_zip          BLOB;
        l_zip_len      INTEGER;
        l_chunk_size   INTEGER := 3000000; -- 3MB chunks
        l_offset       INTEGER := 1;
        l_chunk_num    INTEGER := 1;
        l_raw_chunk    RAW(32767);
        l_base64_chunk VARCHAR2(32767);
        l_timestamp    VARCHAR2(20);
        l_file_path    VARCHAR2(500);
        l_start        TIMESTAMP;
        l_duration     NUMBER;
        l_read_size    INTEGER;
    BEGIN
        l_start := SYSTIMESTAMP;

        -- Export full app as ZIP using PLEX
        l_zip := plex.to_zip(
                     plex.backapp(
                         p_app_id             => p_app_id,
                         p_include_object_ddl => false,
                         p_include_data       => false,
                         p_include_templates  => false
                     )
                 );

        l_zip_len   := DBMS_LOB.GETLENGTH(l_zip);
        l_timestamp := TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD_HH24MISS');

        -- Push chunks to GitHub
        WHILE l_offset <= l_zip_len LOOP

            -- Calculate read size for this chunk
            IF l_offset + l_chunk_size - 1 > l_zip_len THEN
                l_read_size := l_zip_len - l_offset + 1;
            ELSE
                l_read_size := l_chunk_size;
            END IF;

            -- Read chunk
            l_raw_chunk := DBMS_LOB.SUBSTR(l_zip, l_read_size, l_offset);

            -- Base64 encode and clean
            l_base64_chunk := UTL_RAW.CAST_TO_VARCHAR2(
                                  UTL_ENCODE.BASE64_ENCODE(l_raw_chunk)
                              );
            l_base64_chunk := REPLACE(l_base64_chunk, CHR(10), '');
            l_base64_chunk := REPLACE(l_base64_chunk, CHR(13), '');

            -- Build file path for this chunk
            l_file_path := p_base_path || '/app_' || p_app_id ||
                           '/' || l_timestamp ||
                           '/f' || p_app_id ||
                           '_part' || LPAD(l_chunk_num, 3, '0') || '.zip.b64';

            -- Push to GitHub
            P_PUSH_TO_GITHUB(
                p_github_repo => p_github_repo,
                p_branch      => p_branch,
                p_file_path   => l_file_path,
                p_token       => p_token,
                p_content     => l_base64_chunk,
                p_app_id      => p_app_id
            );

            l_offset     := l_offset + l_chunk_size;
            l_chunk_num  := l_chunk_num + 1;

        END LOOP;

        l_duration := EXTRACT(SECOND FROM (SYSTIMESTAMP - l_start));

        PCK_BACKUP_LOGGER.P_LOG(
            p_app_id      => p_app_id,
            p_app_alias   => 'App-' || p_app_id,
            p_status      => 'SUCCESS',
            p_http_status => 201,
            p_message     => 'Full backup done! ' || (l_chunk_num - 1) ||
                             ' chunks to: ' || p_base_path ||
                             '/app_' || p_app_id || '/' || l_timestamp,
            p_duration_s  => l_duration
        );

        DBMS_LOB.FREETEMPORARY(l_zip);

    EXCEPTION
        WHEN OTHERS THEN
            PCK_BACKUP_LOGGER.P_LOG(
                p_app_id      => p_app_id,
                p_app_alias   => 'App-' || p_app_id,
                p_status      => 'ERROR',
                p_message     => SQLERRM,
                p_error_code  => SQLCODE
            );
    END P_BACKUP_APPLICATION;

END PCK_GITHUB_BACKUP;
/