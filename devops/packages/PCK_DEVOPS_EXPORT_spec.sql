--
-- Package "PCK_DEVOPS_EXPORT"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_THARUN"."PCK_DEVOPS_EXPORT" AS
  
  -- Run all at once
  PROCEDURE EXPORT_ALL;
  
  -- Individual exports
  PROCEDURE EXPORT_TABLES;
  PROCEDURE EXPORT_PACKAGES;
  PROCEDURE EXPORT_PROCEDURES;
  PROCEDURE EXPORT_FUNCTIONS;
  PROCEDURE EXPORT_VIEWS;
  PROCEDURE EXPORT_MATERIALIZED_VIEWS;
  PROCEDURE EXPORT_TRIGGERS;
  PROCEDURE EXPORT_SEQUENCES;
  PROCEDURE EXPORT_INDEXES;

END PCK_DEVOPS_EXPORT;
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."PCK_DEVOPS_EXPORT" AS

  -- ============================================================
  -- PRIVATE: Initialize Repo (used by all procedures)
  -- ============================================================
  FUNCTION GET_REPO RETURN CLOB IS
  BEGIN
    RETURN DBMS_CLOUD_REPO.INIT_GITHUB_REPO(
      credential_name => 'GITHUB_CRED',
      repo_name       => 'OracleApex',
      owner           => 'TharunKommaddi'
    );
  END GET_REPO;

  -- ============================================================
  -- 1. TABLES
  -- ============================================================
  PROCEDURE EXPORT_TABLES IS
    l_repo CLOB := GET_REPO();
  BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Exporting TABLES ===');
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
        DBMS_OUTPUT.PUT_LINE('  ✓ ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=== TABLES DONE ===');
  END EXPORT_TABLES;

  -- ============================================================
  -- 2. PACKAGES
  -- ============================================================
  PROCEDURE EXPORT_PACKAGES IS
    l_repo CLOB := GET_REPO();
  BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Exporting PACKAGES ===');
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
        DBMS_OUTPUT.PUT_LINE('  ✓ SPEC: ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ SPEC FAILED: ' || rec.object_name || ' - ' || SQLERRM);
      END;
      BEGIN
        DBMS_CLOUD_REPO.EXPORT_OBJECT(
          repo        => l_repo,
          object_type => 'PACKAGE_BODY',
          object_name => rec.object_name,
          file_path   => 'devops/packages/' || rec.object_name || '_body.sql'
        );
        DBMS_OUTPUT.PUT_LINE('  ✓ BODY: ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ BODY FAILED: ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=== PACKAGES DONE ===');
  END EXPORT_PACKAGES;

  -- ============================================================
  -- 3. PROCEDURES
  -- ============================================================
  PROCEDURE EXPORT_PROCEDURES IS
    l_repo CLOB := GET_REPO();
  BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Exporting PROCEDURES ===');
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
        DBMS_OUTPUT.PUT_LINE('  ✓ ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=== PROCEDURES DONE ===');
  END EXPORT_PROCEDURES;

  -- ============================================================
  -- 4. FUNCTIONS
  -- ============================================================
  PROCEDURE EXPORT_FUNCTIONS IS
    l_repo CLOB := GET_REPO();
  BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Exporting FUNCTIONS ===');
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
        DBMS_OUTPUT.PUT_LINE('  ✓ ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=== FUNCTIONS DONE ===');
  END EXPORT_FUNCTIONS;

  -- ============================================================
  -- 5. VIEWS
  -- ============================================================
  PROCEDURE EXPORT_VIEWS IS
    l_repo CLOB := GET_REPO();
  BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Exporting VIEWS ===');
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
        DBMS_OUTPUT.PUT_LINE('  ✓ ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=== VIEWS DONE ===');
  END EXPORT_VIEWS;

  -- ============================================================
  -- 6. MATERIALIZED VIEWS
  -- ============================================================
  PROCEDURE EXPORT_MATERIALIZED_VIEWS IS
    l_repo CLOB := GET_REPO();
  BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Exporting MATERIALIZED VIEWS ===');
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
        DBMS_OUTPUT.PUT_LINE('  ✓ ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=== MATERIALIZED VIEWS DONE ===');
  END EXPORT_MATERIALIZED_VIEWS;

  -- ============================================================
  -- 7. TRIGGERS
  -- ============================================================
  PROCEDURE EXPORT_TRIGGERS IS
    l_repo CLOB := GET_REPO();
  BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Exporting TRIGGERS ===');
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
        DBMS_OUTPUT.PUT_LINE('  ✓ ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=== TRIGGERS DONE ===');
  END EXPORT_TRIGGERS;

  -- ============================================================
  -- 8. SEQUENCES
  -- ============================================================
  PROCEDURE EXPORT_SEQUENCES IS
    l_repo CLOB := GET_REPO();
  BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Exporting SEQUENCES ===');
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
        DBMS_OUTPUT.PUT_LINE('  ✓ ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=== SEQUENCES DONE ===');
  END EXPORT_SEQUENCES;

  -- ============================================================
  -- 9. INDEXES
  -- ============================================================
  PROCEDURE EXPORT_INDEXES IS
    l_repo CLOB := GET_REPO();
  BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Exporting INDEXES ===');
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
        DBMS_OUTPUT.PUT_LINE('  ✓ ' || rec.object_name);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  ✗ ' || rec.object_name || ' - ' || SQLERRM);
      END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=== INDEXES DONE ===');
  END EXPORT_INDEXES;

  -- ============================================================
  -- EXPORT ALL - Calls everything
  -- ============================================================
  PROCEDURE EXPORT_ALL IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('STARTING FULL DEVOPS EXPORT TO GITHUB');
    DBMS_OUTPUT.PUT_LINE('========================================');
    EXPORT_TABLES;
    EXPORT_PACKAGES;
    EXPORT_PROCEDURES;
    EXPORT_FUNCTIONS;
    EXPORT_VIEWS;
    EXPORT_MATERIALIZED_VIEWS;
    EXPORT_TRIGGERS;
    EXPORT_SEQUENCES;
    EXPORT_INDEXES;
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('FULL EXPORT COMPLETED!');
    DBMS_OUTPUT.PUT_LINE('========================================');
  END EXPORT_ALL;

END PCK_DEVOPS_EXPORT;
/