<h1>Processing - Process - PL/SQL - Custom APEX DATA EXPORT for NON Heirarchy Table</h1>
<h2>When Button Pressed - Export 1</h2>

```sql
DECLARE
    l_context apex_exec.t_context; 
    l_export  apex_data_export.t_export;
    lTitle varchar2(250);
    lPrintConfig apex_data_export.t_print_config;
    lFileName varchar2(250);
BEGIN
    -- Set the sheet title for the export
    lTitle := 'Customer Information Export';

    -- Generate the file name with timestamp
    lFileName := 'Excel-Export' || '-' || TO_CHAR(SYSDATE, 'DD.MM.YYYY HH24:MI:SS') || '.xlsx';

    -- Open the query context
    l_context := apex_exec.open_query_context(
        p_location    => apex_exec.c_location_local_db,
        p_sql_query   => q'[
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
        ]'
    );
                
    -- Set up print configuration
    lPrintConfig := apex_data_export.get_print_config(
        p_page_header => lTitle,
        p_page_header_font_color      => 'Black',
        p_page_header_font_size       => 14,
        p_page_header_font_weight     => apex_data_export.c_font_weight_bold               
    );

    -- Generate the export
    l_export := apex_data_export.export (
        p_context   => l_context,
        p_print_config => lPrintConfig,
        p_format    => apex_data_export.c_format_xlsx,
        p_file_name => lFileName
    );

    apex_exec.close( l_context );
    
    -- If this is a standalone script, you might want to download the file
    apex_data_export.download( p_export => l_export );

EXCEPTION
    WHEN OTHERS THEN
        apex_exec.close( l_context );
        RAISE;
END;
```
