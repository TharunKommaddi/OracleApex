--
-- Package "PCK_EXPORT"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_THARUN"."PCK_EXPORT" AS 
    -- Combined function for both current and future data
    FUNCTION fGetSQLExportCombined RETURN CLOB;

    -- New customer matrix functions
    FUNCTION fGenCustomerMatrixSQL(aFilterType VARCHAR2 DEFAULT NULL, aFilterValue VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;
    FUNCTION fGenCustomerMatrixSQLExcel(aFilterType VARCHAR2 DEFAULT NULL, aFilterValue VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;
    FUNCTION fGenCustomerMatrixSQLJSON(aFilterType VARCHAR2 DEFAULT NULL, aFilterValue VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;
    
    -- Data retrieval functions
    FUNCTION fGetCustomerMatrixData(aFilterType VARCHAR2 DEFAULT NULL, aFilterValue VARCHAR2 DEFAULT NULL) RETURN CLOB;
    FUNCTION fGetCustomerMetadata RETURN CLOB;
    FUNCTION fGetCategoryMetadata RETURN CLOB;
    
    -- Export functions (ZIP and Excel) - MODERN APEX STYLE
    FUNCTION fGenCustomerMatrixExport(aFilterType VARCHAR2 DEFAULT NULL, aFilterValue VARCHAR2 DEFAULT NULL) RETURN BLOB;
    FUNCTION fZipCustomerExports RETURN BLOB;
    
    -- NEW: ZIP and Excel export functions for buttons using APEX_DATA_EXPORT
    FUNCTION fGenCustomerMatrixZIP(aFilterType VARCHAR2 DEFAULT NULL, aFilterValue VARCHAR2 DEFAULT NULL) RETURN BLOB;
    FUNCTION fGenCustomerMatrixExcel(aFilterType VARCHAR2 DEFAULT NULL, aFilterValue VARCHAR2 DEFAULT NULL) RETURN BLOB;
    
    -- Utility procedures
    PROCEDURE HTPPRN(pClob IN OUT NOCOPY CLOB);

END PCK_EXPORT;
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."PCK_EXPORT" AS

    -- ============================================================
    -- Combined function for both current and future data
    -- ============================================================
    FUNCTION fGetSQLExportCombined RETURN CLOB AS
        lSQL CLOB;
    BEGIN
        lSQL := q'<
            SELECT 
                CUSTOMER_ID,
                NAME,
                ADDRESS,
                CITY,
                STATE,
                ZIPCODE,
                EMAIL,
                PHONE
            FROM 
                T_CUSTOMERS
        >';
        
        htp.p(lSQL);
        RETURN lSQL;
    END fGetSQLExportCombined;

    -- ============================================================
    -- Generate SQL for customer matrix display (with HTML formatting for APEX)
    -- ============================================================
    FUNCTION fGenCustomerMatrixSQL(aFilterType VARCHAR2 DEFAULT NULL, aFilterValue VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 AS
        lSQL VARCHAR2(32000);
    BEGIN
        lSQL := q'[
            WITH customer_order_summary AS (
                SELECT 
                    c.customer_id,
                    c.name as customer_name,
                    c.state,
                    c.country,
                    c.city,
                    c.email || ' <a href="mailto:' || c.email || '"><span class="fa fa-envelope-o"></span></a>' as email_link,
                    COUNT(o.order_id) as total_orders,
                    NVL(SUM(o.order_total), 0) as total_amount,
                    TO_CHAR(MAX(o.order_date), 'YYYY-MM-DD') as last_order_date,
                    LISTAGG(DISTINCT p.category, '<br />') WITHIN GROUP (ORDER BY p.category) as categories_purchased
                FROM t_customers c
                LEFT JOIN t_orders o ON c.customer_id = o.customer_id
                LEFT JOIN t_order_items oi ON o.order_id = oi.order_id
                LEFT JOIN t_products p ON oi.product_id = p.product_id]';

        -- Add filter condition if specified
        IF aFilterType IS NOT NULL AND aFilterValue IS NOT NULL THEN
            lSQL := lSQL || ' WHERE c.' || aFilterType || ' = ''' || aFilterValue || '''';
        ELSIF aFilterType IS NOT NULL AND aFilterValue IS NULL THEN
            lSQL := lSQL || ' WHERE c.' || aFilterType || ' IS NOT NULL';
        END IF;

        lSQL := lSQL || q'[
                GROUP BY c.customer_id, c.name, c.state, c.country, c.city, c.email
            )
            SELECT 
                cos.customer_name,
                cos.state,
                cos.country,
                cos.city,
                cos.email_link as email,
                cos.total_orders,
                TO_CHAR(cos.total_amount, 'FM$999,999,990.00') as total_amount,
                cos.last_order_date,
                cos.categories_purchased]';

        -- Add dynamic columns for each product category
        FOR cat_rec IN (
            SELECT DISTINCT category 
            FROM t_products 
            WHERE category IS NOT NULL 
            ORDER BY category
        ) LOOP
            lSQL := lSQL || q'[,
                NVL((
                    SELECT SUM(oi.quantity)
                    FROM t_orders o2
                    JOIN t_order_items oi ON o2.order_id = oi.order_id
                    JOIN t_products p ON oi.product_id = p.product_id
                    WHERE o2.customer_id = cos.customer_id 
                    AND p.category = ']' || cat_rec.category || q'['
                ), 0) as ]' || '"' || REPLACE(REPLACE(cat_rec.category, ' ', '_'), '-', '_') || '_QTY"';
        END LOOP;

        lSQL := lSQL || q'[
            FROM customer_order_summary cos
            ORDER BY cos.country, cos.state, cos.customer_name
        ]';

        RETURN lSQL;
    END fGenCustomerMatrixSQL;

    -- ============================================================
    -- Generate SQL for Excel export (without HTML formatting)
    -- ============================================================
    FUNCTION fGenCustomerMatrixSQLExcel(aFilterType VARCHAR2 DEFAULT NULL, aFilterValue VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 AS
        lSQL VARCHAR2(32000);
    BEGIN
        lSQL := q'[
            WITH customer_order_summary AS (
                SELECT 
                    c.customer_id,
                    c.name as customer_name,
                    c.state,
                    c.country,
                    c.city,
                    c.email,
                    COUNT(o.order_id) as total_orders,
                    NVL(SUM(o.order_total), 0) as total_amount,
                    TO_CHAR(MAX(o.order_date), 'YYYY-MM-DD') as last_order_date,
                    LISTAGG(DISTINCT p.category, ', ') WITHIN GROUP (ORDER BY p.category) as categories_purchased
                FROM t_customers c
                LEFT JOIN t_orders o ON c.customer_id = o.customer_id
                LEFT JOIN t_order_items oi ON o.order_id = oi.order_id
                LEFT JOIN t_products p ON oi.product_id = p.product_id]';

        -- Add filter condition if specified
        IF aFilterType IS NOT NULL AND aFilterValue IS NOT NULL THEN
            lSQL := lSQL || ' WHERE c.' || aFilterType || ' = ''' || aFilterValue || '''';
        ELSIF aFilterType IS NOT NULL AND aFilterValue IS NULL THEN
            lSQL := lSQL || ' WHERE c.' || aFilterType || ' IS NOT NULL';
        END IF;

        lSQL := lSQL || q'[
                GROUP BY c.customer_id, c.name, c.state, c.country, c.city, c.email
            )
            SELECT 
                cos.customer_name,
                cos.state,
                cos.country,
                cos.city,
                cos.email,
                cos.total_orders,
                cos.total_amount,
                cos.last_order_date,
                cos.categories_purchased]';

        -- Add dynamic columns for each product category
        FOR cat_rec IN (
            SELECT DISTINCT category 
            FROM t_products 
            WHERE category IS NOT NULL 
            ORDER BY category
        ) LOOP
            lSQL := lSQL || q'[,
                NVL((
                    SELECT SUM(oi.quantity)
                    FROM t_orders o2
                    JOIN t_order_items oi ON o2.order_id = oi.order_id
                    JOIN t_products p ON oi.product_id = p.product_id
                    WHERE o2.customer_id = cos.customer_id 
                    AND p.category = ']' || cat_rec.category || q'['
                ), 0) as ]' || '"' || REPLACE(REPLACE(cat_rec.category, ' ', '_'), '-', '_') || '_QTY"';
        END LOOP;

        lSQL := lSQL || q'[
            FROM customer_order_summary cos
            ORDER BY cos.country, cos.state, cos.customer_name
        ]';

        RETURN lSQL;
    END fGenCustomerMatrixSQLExcel;

    -- ============================================================
    -- Get Customer Matrix Data as JSON
    -- ============================================================
    FUNCTION fGetCustomerMatrixData(aFilterType VARCHAR2 DEFAULT NULL, aFilterValue VARCHAR2 DEFAULT NULL) RETURN CLOB AS
        l_data CLOB;
        l_sql VARCHAR2(32000);
        l_cursor SYS_REFCURSOR;
    BEGIN
        l_sql := fGenCustomerMatrixSQLExcel(aFilterType, aFilterValue);
        
        -- Convert SQL result to JSON using a simpler approach
        l_sql := 'SELECT json_arrayagg(json_object(
            ''customer_name'' value customer_name,
            ''state'' value state,
            ''country'' value country,
            ''city'' value city,
            ''email'' value email,
            ''total_orders'' value total_orders,
            ''total_amount'' value total_amount,
            ''last_order_date'' value last_order_date,
            ''categories_purchased'' value categories_purchased
            returning clob) 
            returning clob) as json_data
        FROM (' || l_sql || ')';
        
        OPEN l_cursor FOR l_sql;
        FETCH l_cursor INTO l_data;
        CLOSE l_cursor;
        
        RETURN NVL(l_data, '[]');
        
    EXCEPTION
        WHEN OTHERS THEN
            IF l_cursor%ISOPEN THEN
                CLOSE l_cursor;
            END IF;
            RETURN '[]';
    END fGetCustomerMatrixData;

    -- ============================================================
    -- Get Category Metadata as JSON
    -- ============================================================
    FUNCTION fGetCategoryMetadata RETURN CLOB AS
        l_result CLOB;
    BEGIN
        SELECT json_arrayagg(
            json_object('name' value category)
            returning clob
        ) INTO l_result
        FROM (SELECT DISTINCT category FROM t_products WHERE category IS NOT NULL ORDER BY category);
        
        RETURN NVL(l_result, '[]');
        
    EXCEPTION
        WHEN OTHERS THEN
            RETURN '[]';
    END fGetCategoryMetadata;

    -- ============================================================
    -- Generate ZIP file with customer matrix data - SAME AS COLLEAGUE'S STYLE
    -- ============================================================
    FUNCTION fGenCustomerMatrixZIP(aFilterType VARCHAR2 DEFAULT NULL, aFilterValue VARCHAR2 DEFAULT NULL) RETURN BLOB AS
        l_context1 APEX_EXEC.t_context;
        l_export1 APEX_DATA_EXPORT.t_export;
        l_zip_file BLOB;
        v_vcContentDisposition VARCHAR2(25) := 'inline';
        v_file_name VARCHAR2(255) := 'customer_matrix.zip';
        l_sql VARCHAR2(32000);
    BEGIN
        -- Get the SQL for Excel export (clean, no HTML)
        l_sql := fGenCustomerMatrixSQLExcel(aFilterType, aFilterValue);
        
        -- Create Excel file then zip it (same pattern as colleague)
        l_context1 := APEX_EXEC.open_query_context(
            p_location => APEX_EXEC.c_location_local_db,
            p_sql_query => l_sql
        );
        
        l_export1 := APEX_DATA_EXPORT.export(
            p_context => l_context1,
            p_format => APEX_DATA_EXPORT.c_format_xlsx
        );
        
        -- Add file to ZIP (exactly like colleague's code)
        APEX_ZIP.add_file(
            p_zipped_blob => l_zip_file,
            p_file_name => 'customer_matrix_' || REPLACE(LOWER(NVL(aFilterValue, 'all')), ' ', '_') || '.xlsx',
            p_content => l_export1.content_blob
        );
        
        -- Finish zipping (same as colleague)
        APEX_ZIP.finish(p_zipped_blob => l_zip_file);
        
        -- Close context
        APEX_EXEC.close(l_context1);
        
        RETURN l_zip_file;
        
    EXCEPTION
        WHEN OTHERS THEN
            IF l_context1 IS NOT NULL THEN
                APEX_EXEC.close(l_context1);
            END IF;
            RAISE;
    END fGenCustomerMatrixZIP;

    -- ============================================================
    -- Generate Excel file - MODERN APEX STYLE using APEX_DATA_EXPORT
    -- ============================================================
    FUNCTION fGenCustomerMatrixExcel(aFilterType VARCHAR2 DEFAULT NULL, aFilterValue VARCHAR2 DEFAULT NULL) RETURN BLOB AS
        l_context APEX_EXEC.t_context;
        l_export APEX_DATA_EXPORT.t_export;
        l_sql VARCHAR2(32000);
    BEGIN
        -- Get the SQL for Excel export (clean, no HTML)
        l_sql := fGenCustomerMatrixSQLExcel(aFilterType, aFilterValue);
        
        -- Create execution context
        l_context := APEX_EXEC.open_query_context(
            p_location => APEX_EXEC.c_location_local_db,
            p_sql_query => l_sql
        );
        
        -- Export to XLSX using APEX_DATA_EXPORT
        l_export := APEX_DATA_EXPORT.export(
            p_context => l_context,
            p_format => APEX_DATA_EXPORT.c_format_xlsx
        );
        
        -- Close the context
        APEX_EXEC.close(l_context);
        
        RETURN l_export.content_blob;
        
    EXCEPTION
        WHEN OTHERS THEN
            IF l_context IS NOT NULL THEN
                APEX_EXEC.close(l_context);
            END IF;
            RAISE;
    END fGenCustomerMatrixExcel;

    -- ============================================================
    -- Other functions
    -- ============================================================
    FUNCTION fGenCustomerMatrixSQLJSON(aFilterType VARCHAR2 DEFAULT NULL, aFilterValue VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 AS
    BEGIN
        RETURN fGenCustomerMatrixSQL(aFilterType, aFilterValue);
    END fGenCustomerMatrixSQLJSON;

    FUNCTION fGetCustomerMetadata RETURN CLOB AS
    BEGIN
        RETURN 'Metadata will go here';
    END fGetCustomerMetadata;

    FUNCTION fGenCustomerMatrixExport(aFilterType VARCHAR2 DEFAULT NULL, aFilterValue VARCHAR2 DEFAULT NULL) RETURN BLOB AS
        lBlob BLOB;
    BEGIN
        RETURN lBlob;
    END fGenCustomerMatrixExport;

    FUNCTION fZipCustomerExports RETURN BLOB AS
        lBlob BLOB;
    BEGIN
        RETURN lBlob;
    END fZipCustomerExports;

    PROCEDURE HTPPRN(pClob IN OUT NOCOPY CLOB) AS
    BEGIN
        htp.prn(pClob);
    END HTPPRN;

END PCK_EXPORT;
/