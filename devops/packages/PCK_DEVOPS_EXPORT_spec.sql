--
-- Package "PCK_DEVOPS_EXPORT"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_THARUN"."PCK_DEVOPS_EXPORT" AS
  PROCEDURE EXPORT_ALL_TO_GITHUB;
END PCK_DEVOPS_EXPORT;
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."PCK_DEVOPS_EXPORT" AS

  PROCEDURE EXPORT_ALL_TO_GITHUB IS
    l_repo CLOB;
  BEGIN
    -- Initialize repo
    l_repo := DBMS_CLOUD_REPO.INIT_GITHUB_REPO(
      credential_name => 'GITHUB_CRED',
      repo_name       => 'OracleApex',
      owner           => 'TharunKommaddi'
    );
    
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('STARTING DEVOPS EXPORT TO GITHUB');
    DBMS_OUTPUT.PUT_LINE('========================================');

    -- ============================================================
    -- 1. TABLES
    -- ============================================================
    DBMS_OUTPUT.PUT_LINE('--- Exporting TABLES ---');
    FOR rec IN (
      SELECT object_name 
      FROM user_objects 
      WHERE object_type = 'TABLE'
      AND object_name NOT LIKE 'DR$%'
      AND object_name NOT LIKE 'SYS_%'
      AND object_name NOT LIKE 'HTMLDB_%'
      AND object_name NOT LIKE 'DBTOOLS$%'
      ORDER BY object_name
    ) LOOP
      BEGIN
        DBMS_CLOUD_REPO.EXPORT_OBJECT(
          repo        => l_repo,
          object_type => 'TABLE',
          object_name => rec.object_name,
          file_path   => 'devops/tables/' || rec.object_name || '.sql'
        );
        DBMS_OUTPUT.PUT_LINE('  ✓ TABLE: ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ TABLE FAILED: ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;

    -- ============================================================
    -- 2. PACKAGES (SPEC + BODY together)
    -- ============================================================
    DBMS_OUTPUT.PUT_LINE('--- Exporting PACKAGES ---');
    FOR rec IN (
      SELECT object_name 
      FROM user_objects 
      WHERE object_type = 'PACKAGE'
      ORDER BY object_name
    ) LOOP
      BEGIN
        DBMS_CLOUD_REPO.EXPORT_OBJECT(
          repo        => l_repo,
          object_type => 'PACKAGE',
          object_name => rec.object_name,
          file_path   => 'devops/packages/' || rec.object_name || '_spec.sql'
        );
        DBMS_OUTPUT.PUT_LINE('  ✓ PACKAGE SPEC: ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ PACKAGE SPEC FAILED: ' || rec.object_name || ' - ' || SQLERRM);
      END;
      BEGIN
        DBMS_CLOUD_REPO.EXPORT_OBJECT(
          repo        => l_repo,
          object_type => 'PACKAGE_BODY',
          object_name => rec.object_name,
          file_path   => 'devops/packages/' || rec.object_name || '_body.sql'
        );
        DBMS_OUTPUT.PUT_LINE('  ✓ PACKAGE BODY: ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ PACKAGE BODY FAILED: ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;

    -- ============================================================
    -- 3. PROCEDURES
    -- ============================================================
    DBMS_OUTPUT.PUT_LINE('--- Exporting PROCEDURES ---');
    FOR rec IN (
      SELECT object_name 
      FROM user_objects 
      WHERE object_type = 'PROCEDURE'
      ORDER BY object_name
    ) LOOP
      BEGIN
        DBMS_CLOUD_REPO.EXPORT_OBJECT(
          repo        => l_repo,
          object_type => 'PROCEDURE',
          object_name => rec.object_name,
          file_path   => 'devops/procedures/' || rec.object_name || '.sql'
        );
        DBMS_OUTPUT.PUT_LINE('  ✓ PROCEDURE: ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ PROCEDURE FAILED: ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;

    -- ============================================================
    -- 4. FUNCTIONS
    -- ============================================================
    DBMS_OUTPUT.PUT_LINE('--- Exporting FUNCTIONS ---');
    FOR rec IN (
      SELECT object_name 
      FROM user_objects 
      WHERE object_type = 'FUNCTION'
      ORDER BY object_name
    ) LOOP
      BEGIN
        DBMS_CLOUD_REPO.EXPORT_OBJECT(
          repo        => l_repo,
          object_type => 'FUNCTION',
          object_name => rec.object_name,
          file_path   => 'devops/functions/' || rec.object_name || '.sql'
        );
        DBMS_OUTPUT.PUT_LINE('  ✓ FUNCTION: ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ FUNCTION FAILED: ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;

    -- ============================================================
    -- 5. VIEWS
    -- ============================================================
    DBMS_OUTPUT.PUT_LINE('--- Exporting VIEWS ---');
    FOR rec IN (
      SELECT object_name 
      FROM user_objects 
      WHERE object_type = 'VIEW'
      ORDER BY object_name
    ) LOOP
      BEGIN
        DBMS_CLOUD_REPO.EXPORT_OBJECT(
          repo        => l_repo,
          object_type => 'VIEW',
          object_name => rec.object_name,
          file_path   => 'devops/views/' || rec.object_name || '.sql'
        );
        DBMS_OUTPUT.PUT_LINE('  ✓ VIEW: ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ VIEW FAILED: ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;

    -- ============================================================
    -- 6. MATERIALIZED VIEWS
    -- ============================================================
    DBMS_OUTPUT.PUT_LINE('--- Exporting MATERIALIZED VIEWS ---');
    FOR rec IN (
      SELECT object_name 
      FROM user_objects 
      WHERE object_type = 'MATERIALIZED VIEW'
      ORDER BY object_name
    ) LOOP
      BEGIN
        DBMS_CLOUD_REPO.EXPORT_OBJECT(
          repo        => l_repo,
          object_type => 'MATERIALIZED_VIEW',
          object_name => rec.object_name,
          file_path   => 'devops/materialized_views/' || rec.object_name || '.sql'
        );
        DBMS_OUTPUT.PUT_LINE('  ✓ MV: ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ MV FAILED: ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;

    -- ============================================================
    -- 7. TRIGGERS
    -- ============================================================
    DBMS_OUTPUT.PUT_LINE('--- Exporting TRIGGERS ---');
    FOR rec IN (
      SELECT object_name 
      FROM user_objects 
      WHERE object_type = 'TRIGGER'
      ORDER BY object_name
    ) LOOP
      BEGIN
        DBMS_CLOUD_REPO.EXPORT_OBJECT(
          repo        => l_repo,
          object_type => 'TRIGGER',
          object_name => rec.object_name,
          file_path   => 'devops/triggers/' || rec.object_name || '.sql'
        );
        DBMS_OUTPUT.PUT_LINE('  ✓ TRIGGER: ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ TRIGGER FAILED: ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;

    -- ============================================================
    -- 8. SEQUENCES (named only, skip ISEQ$$_)
    -- ============================================================
    DBMS_OUTPUT.PUT_LINE('--- Exporting SEQUENCES ---');
    FOR rec IN (
      SELECT object_name 
      FROM user_objects 
      WHERE object_type = 'SEQUENCE'
      AND object_name NOT LIKE 'ISEQ$$_%'
      AND object_name NOT LIKE 'DBTOOLS$%'
      ORDER BY object_name
    ) LOOP
      BEGIN
        DBMS_CLOUD_REPO.EXPORT_OBJECT(
          repo        => l_repo,
          object_type => 'SEQUENCE',
          object_name => rec.object_name,
          file_path   => 'devops/sequences/' || rec.object_name || '.sql'
        );
        DBMS_OUTPUT.PUT_LINE('  ✓ SEQUENCE: ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ SEQUENCE FAILED: ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;

    -- ============================================================
    -- 9. INDEXES (named only, skip SYS_ auto ones)
    -- ============================================================
    DBMS_OUTPUT.PUT_LINE('--- Exporting INDEXES ---');
    FOR rec IN (
      SELECT object_name 
      FROM user_objects 
      WHERE object_type = 'INDEX'
      AND object_name NOT LIKE 'SYS_%'
      AND object_name NOT LIKE 'DR$%'
      AND object_name NOT LIKE 'DBTOOLS$%'
      ORDER BY object_name
    ) LOOP
      BEGIN
        DBMS_CLOUD_REPO.EXPORT_OBJECT(
          repo        => l_repo,
          object_type => 'INDEX',
          object_name => rec.object_name,
          file_path   => 'devops/indexes/' || rec.object_name || '.sql'
        );
        DBMS_OUTPUT.PUT_LINE('  ✓ INDEX: ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ INDEX FAILED: ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('EXPORT COMPLETED SUCCESSFULLY!');
    DBMS_OUTPUT.PUT_LINE('Check GitHub: TharunKommaddi/OracleApex/devops/');
    DBMS_OUTPUT.PUT_LINE('========================================');

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('FATAL ERROR: ' || SQLERRM);
  END EXPORT_ALL_TO_GITHUB;

END PCK_DEVOPS_EXPORT;
/