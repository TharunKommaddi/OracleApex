<h1>Processing - Process - PL/SQL - Custom APEX DATA EXPORT for Heirarchy Table</h1>
<h2>When Button Pressed - Export 1</h2>

```sql
DECLARE
    l_context apex_exec.t_context; 
    l_export  apex_data_export.t_export;
    lTitle varchar2(250);
    lPrintConfig apex_data_export.t_print_config;  
    lColumns apex_data_export.t_columns;
    lColumnGroups apex_data_export.t_column_groups;
    lCGCustomerDetails pls_integer;
    lCGCustomerAddress pls_integer;
    lFileName varchar2(250);
BEGIN
    -- Set the sheet 1 title for the export
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
    
    -- Add column groups
    apex_data_export.add_column_group(
        p_column_groups => lColumnGroups,
        p_idx => lCGCustomerDetails,
        p_name => 'Customer Details'
    );
    
    apex_data_export.add_column_group(
        p_column_groups => lColumnGroups,
        p_idx => lCGCustomerAddress,
        p_name => 'Customer Address'
    );
    
    -- Add columns for Customer Details
    apex_data_export.add_column(
        p_columns => lColumns,
        p_name => 'CUSTOMER_ID',
        p_heading => 'Customer ID',
        p_column_group_idx => lCGCustomerDetails
    );
    
    apex_data_export.add_column(
        p_columns => lColumns,
        p_name => 'NAME',
        p_heading => 'Name',
        p_column_group_idx => lCGCustomerDetails
    );
    
    -- Add columns for Customer Address
    apex_data_export.add_column(
        p_columns => lColumns,
        p_name => 'ADDRESS',
        p_heading => 'Address',
        p_column_group_idx => lCGCustomerAddress
    );
    
    apex_data_export.add_column(
        p_columns => lColumns,
        p_name => 'CITY',
        p_heading => 'City',
        p_column_group_idx => lCGCustomerAddress
    );
    
    apex_data_export.add_column(
        p_columns => lColumns,
        p_name => 'STATE',
        p_heading => 'State',
        p_column_group_idx => lCGCustomerAddress
    );
    
    apex_data_export.add_column(
        p_columns => lColumns,
        p_name => 'ZIPCODE',
        p_heading => 'Zip Code',
        p_column_group_idx => lCGCustomerAddress
    );
    
    apex_data_export.add_column(
        p_columns => lColumns,
        p_name => 'EMAIL',
        p_heading => 'Email',
        p_column_group_idx => lCGCustomerAddress
    );
    
    apex_data_export.add_column(
        p_columns => lColumns,
        p_name => 'PHONE',
        p_heading => 'Phone',
        p_column_group_idx => lCGCustomerAddress
    );

    -- Generate the export
    l_export := apex_data_export.export (
        p_context   => l_context,
        p_print_config => lPrintConfig,
        p_columns => lColumns,
        p_column_groups => lColumnGroups,
        p_format    => apex_data_export.c_format_xlsx,
        p_file_name => lFileName

    );

    apex_exec.close( l_context );
    
    -- If this is part of a function, you might want to return the content
    -- return l_export.content_blob;
    
    -- If this is a standalone script, you might want to download the file
    apex_data_export.download( p_export => l_export );

EXCEPTION
    WHEN OTHERS THEN
        apex_exec.close( l_context );
        RAISE;
END;
```
