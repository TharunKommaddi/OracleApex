--
-- Package "PCK_MARKDOWN"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_THARUN"."PCK_MARKDOWN" as

    procedure show_table_docs(p_table_name varchar2 default null);
    procedure show_view_docs(p_view_name varchar2 default null);
    procedure show_mview_docs(p_mview_name varchar2 default null);
    procedure show_package_docs(p_package_name varchar2 default null);
    procedure show_procedure_docs(p_procedure_name varchar2 default null);
    procedure show_function_docs(p_function_name varchar2 default null);
    procedure show_sequence_docs(p_sequence_name varchar2 default null);
    procedure show_trigger_docs(p_trigger_name varchar2 default null);
    procedure show_overview_docs;
    
    function get_table_docs_html(p_table_name varchar2 default null) return clob;
    function get_view_docs_html(p_view_name varchar2 default null) return clob;
    function get_mview_docs_html(p_mview_name varchar2 default null) return clob;
    function get_package_docs_html(p_package_name varchar2 default null) return clob;
    function get_procedure_docs_html(p_procedure_name varchar2 default null) return clob;
    function get_function_docs_html(p_function_name varchar2 default null) return clob;
    function get_sequence_docs_html(p_sequence_name varchar2 default null) return clob;
    function get_trigger_docs_html(p_trigger_name varchar2 default null) return clob;
    function get_overview_docs_html return clob;
    
    procedure output_clob_in_chunks(p_clob clob);

    procedure show_job_docs(p_job_name varchar2 default null);
function get_job_docs_html(p_job_name varchar2 default null) return clob;

end PCK_MARKDOWN;
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."PCK_MARKDOWN" as

    procedure output_clob_in_chunks(p_clob clob) is
        l_chunk varchar2(1000);
        l_pos number := 1;
        l_len number;
        l_temp_clob clob;
    begin
        l_temp_clob := p_clob;  -- assign to local variable
        l_len := dbms_lob.getlength(l_temp_clob);
        
        while l_pos <= l_len loop
            l_chunk := dbms_lob.substr(l_temp_clob, least(1000, l_len - l_pos + 1), l_pos);
            htp.prn(l_chunk);
            l_pos := l_pos + 1000;
        end loop;
        
        -- Don't free the original CLOB since we didn't create it here
    exception
        when others then
            htp.p('<p style="color:red;">Error in output: ' || sqlerrm || '</p>');
    end output_clob_in_chunks;

    function get_table_docs_html(p_table_name varchar2 default null) return clob is
        l_html_clob clob;
        l_table_count number := 0;
        l_constraint_count number := 0;
        l_relationship_count number := 0;
    begin
        dbms_lob.createtemporary(l_html_clob, false);

        if p_table_name is null then
            dbms_lob.append(l_html_clob, '<div style="text-align: center; padding: 50px; color: #666;">');
            dbms_lob.append(l_html_clob, '<h2>Database Documentation</h2>');
            dbms_lob.append(l_html_clob, '<p>Please select a table from the dropdown above to view its documentation.</p>');
            dbms_lob.append(l_html_clob, '</div>');
            return l_html_clob;
        end if;

        dbms_lob.append(l_html_clob, '<h1>Table Documentation: ' || p_table_name || '</h1>');
        dbms_lob.append(l_html_clob, '<p><strong>Generated: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI') || '</strong></p>');
        
        for table_rec in (
            select table_name
            from user_tables
            where table_name = upper(p_table_name)
            and table_name not like 'APEX$%'
            and table_name not like 'BIN$%'
        ) loop
            l_table_count := l_table_count + 1;
            
            dbms_lob.append(l_html_clob, '<h3>Columns</h3>');
            dbms_lob.append(l_html_clob, '<table class="doc-table">');
            dbms_lob.append(l_html_clob, '<thead>');
            dbms_lob.append(l_html_clob, '<tr>');
            dbms_lob.append(l_html_clob, '<th>Column Name</th>');
            dbms_lob.append(l_html_clob, '<th>Data Type</th>');
            dbms_lob.append(l_html_clob, '<th>Nullable</th>');
            dbms_lob.append(l_html_clob, '<th>Primary Key</th>');
            dbms_lob.append(l_html_clob, '</tr>');
            dbms_lob.append(l_html_clob, '</thead>');
            dbms_lob.append(l_html_clob, '<tbody>');
            
            for col_rec in (
                select 
                    c.column_name,
                    case 
                        when c.data_type = 'VARCHAR2' then c.data_type || '(' || c.data_length || ')'
                        when c.data_type = 'NUMBER' and c.data_precision is not null then 
                            c.data_type || '(' || c.data_precision || 
                            case when c.data_scale > 0 then ',' || c.data_scale else '' end || ')'
                        else c.data_type
                    end as formatted_data_type,
                    case when c.nullable = 'Y' then 'Yes' else '<strong>No</strong>' end as nullable,
                    case when pk.column_name is not null then '<span class="pk-badge">YES</span>' else 'No' end as is_primary_key
                from user_tab_columns c
                left join (
                    select acc.column_name
                    from user_constraints ac
                    join user_cons_columns acc on (ac.constraint_name = acc.constraint_name)
                    where ac.constraint_type = 'P'
                    and ac.table_name = upper(p_table_name)
                ) pk on (c.column_name = pk.column_name)
                where c.table_name = upper(p_table_name)
                order by c.column_id
            ) loop
                dbms_lob.append(l_html_clob, '<tr>');
                dbms_lob.append(l_html_clob, '<td class="col-name">' || col_rec.column_name || '</td>');
                dbms_lob.append(l_html_clob, '<td class="data-type">' || col_rec.formatted_data_type || '</td>');
                dbms_lob.append(l_html_clob, '<td>' || col_rec.nullable || '</td>');
                dbms_lob.append(l_html_clob, '<td>' || col_rec.is_primary_key || '</td>');
                dbms_lob.append(l_html_clob, '</tr>');
            end loop;
            
            dbms_lob.append(l_html_clob, '</tbody>');
            dbms_lob.append(l_html_clob, '</table>');
            
            dbms_lob.append(l_html_clob, '<h3>Constraints</h3>');
            dbms_lob.append(l_html_clob, '<table class="doc-table">');
            dbms_lob.append(l_html_clob, '<thead>');
            dbms_lob.append(l_html_clob, '<tr>');
            dbms_lob.append(l_html_clob, '<th>Constraint Name</th>');
            dbms_lob.append(l_html_clob, '<th>Type</th>');
            dbms_lob.append(l_html_clob, '<th>Columns</th>');
            dbms_lob.append(l_html_clob, '<th>Details</th>');
            dbms_lob.append(l_html_clob, '</tr>');
            dbms_lob.append(l_html_clob, '</thead>');
            dbms_lob.append(l_html_clob, '<tbody>');
            
            -- Primary Keys
            for cons_rec in (
                select 
                    c.constraint_name,
                    'PRIMARY KEY' as constraint_type_display,
                    listagg(cc.column_name, ', ') within group (order by cc.position) as constraint_columns,
                    'Primary key constraint' as constraint_details
                from user_constraints c
                join user_cons_columns cc on (c.constraint_name = cc.constraint_name)
                where c.table_name = upper(p_table_name)
                and c.constraint_type = 'P'
                group by c.constraint_name
            ) loop
                l_constraint_count := l_constraint_count + 1;
                dbms_lob.append(l_html_clob, '<tr>');
                dbms_lob.append(l_html_clob, '<td class="col-name">' || cons_rec.constraint_name || '</td>');
                dbms_lob.append(l_html_clob, '<td><span class="pk-badge">PRIMARY KEY</span></td>');
                dbms_lob.append(l_html_clob, '<td class="col-name">' || cons_rec.constraint_columns || '</td>');
                dbms_lob.append(l_html_clob, '<td>' || cons_rec.constraint_details || '</td>');
                dbms_lob.append(l_html_clob, '</tr>');
            end loop;
            
            -- Foreign Keys
            for cons_rec in (
                select 
                    c.constraint_name,
                    listagg(cc.column_name, ', ') within group (order by cc.position) as constraint_columns,
                    r.table_name as referenced_table,
                    listagg(rc.column_name, ', ') within group (order by rc.position) as referenced_columns
                from user_constraints c
                join user_cons_columns cc on (c.constraint_name = cc.constraint_name)
                join user_constraints r on (c.r_constraint_name = r.constraint_name)
                join user_cons_columns rc on (r.constraint_name = rc.constraint_name and cc.position = rc.position)
                where c.table_name = upper(p_table_name)
                and c.constraint_type = 'R'
                group by c.constraint_name, r.table_name
            ) loop
                l_constraint_count := l_constraint_count + 1;
                dbms_lob.append(l_html_clob, '<tr>');
                dbms_lob.append(l_html_clob, '<td class="col-name">' || cons_rec.constraint_name || '</td>');
                dbms_lob.append(l_html_clob, '<td><span class="fk-badge">FOREIGN KEY</span></td>');
                dbms_lob.append(l_html_clob, '<td class="col-name">' || cons_rec.constraint_columns || '</td>');
                dbms_lob.append(l_html_clob, '<td>References ' || cons_rec.referenced_table || ' (' || cons_rec.referenced_columns || ')</td>');
                dbms_lob.append(l_html_clob, '</tr>');
            end loop;
            
            dbms_lob.append(l_html_clob, '</tbody>');
            dbms_lob.append(l_html_clob, '</table>');
            
        end loop;
        
        return l_html_clob;
        
    exception
        when others then
            if dbms_lob.istemporary(l_html_clob) = 1 then
                dbms_lob.freetemporary(l_html_clob);
            end if;
            dbms_lob.createtemporary(l_html_clob, false);
            dbms_lob.append(l_html_clob, '<p>Error: ' || sqlerrm || '</p>');
            return l_html_clob;
    end get_table_docs_html;

    -- Other HTML functions (keeping them simple for now)
    function get_view_docs_html(p_view_name varchar2 default null) return clob is
        l_html_clob clob;
    begin
        dbms_lob.createtemporary(l_html_clob, false);
        
        dbms_lob.append(l_html_clob, '<h1>View Documentation: ' || p_view_name || '</h1>');
        dbms_lob.append(l_html_clob, '<p><strong>Generated: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI') || '</strong></p>');
        
        -- View Information
        dbms_lob.append(l_html_clob, '<h3>View Information</h3>');
        dbms_lob.append(l_html_clob, '<table class="doc-table">');
        dbms_lob.append(l_html_clob, '<thead><tr><th>Property</th><th>Value</th></tr></thead><tbody>');
        
        for view_rec in (
            select view_name, text_length, read_only
            from user_views 
            where view_name = upper(p_view_name)
        ) loop
            dbms_lob.append(l_html_clob, '<tr><td>View Name</td><td class="col-name">' || view_rec.view_name || '</td></tr>');
            dbms_lob.append(l_html_clob, '<tr><td>Text Length</td><td>' || view_rec.text_length || ' characters</td></tr>');
            dbms_lob.append(l_html_clob, '<tr><td>Read Only</td><td>' || nvl(view_rec.read_only, 'N/A') || '</td></tr>');
        end loop;
        
        dbms_lob.append(l_html_clob, '</tbody></table>');
        
        -- View Columns
        dbms_lob.append(l_html_clob, '<h3>Columns</h3>');
        dbms_lob.append(l_html_clob, '<table class="doc-table">');
        dbms_lob.append(l_html_clob, '<thead><tr><th>Column Name</th><th>Data Type</th><th>Nullable</th></tr></thead><tbody>');
        
        for col_rec in (
            select column_name,
                   case 
                       when data_type = 'VARCHAR2' then data_type || '(' || data_length || ')'
                       when data_type = 'NUMBER' and data_precision is not null then 
                           data_type || '(' || data_precision || 
                           case when data_scale > 0 then ',' || data_scale else '' end || ')'
                       else data_type
                   end as formatted_data_type,
                   case when nullable = 'Y' then 'Yes' else '<strong>No</strong>' end as nullable
            from user_tab_columns 
            where table_name = upper(p_view_name)
            order by column_id
        ) loop
            dbms_lob.append(l_html_clob, '<tr>');
            dbms_lob.append(l_html_clob, '<td class="col-name">' || col_rec.column_name || '</td>');
            dbms_lob.append(l_html_clob, '<td class="data-type">' || col_rec.formatted_data_type || '</td>');
            dbms_lob.append(l_html_clob, '<td>' || col_rec.nullable || '</td>');
            dbms_lob.append(l_html_clob, '</tr>');
        end loop;
        
        dbms_lob.append(l_html_clob, '</tbody></table>');
        
        return l_html_clob;
    exception
        when others then
            if dbms_lob.istemporary(l_html_clob) = 1 then
                dbms_lob.freetemporary(l_html_clob);
            end if;
            dbms_lob.createtemporary(l_html_clob, false);
            dbms_lob.append(l_html_clob, '<p>Error: ' || sqlerrm || '</p>');
            return l_html_clob;
    end get_view_docs_html;

    function get_mview_docs_html(p_mview_name varchar2 default null) return clob is
        l_html_clob clob;
    begin
        dbms_lob.createtemporary(l_html_clob, false);
        
        dbms_lob.append(l_html_clob, '<h1>Materialized View Documentation: ' || p_mview_name || '</h1>');
        dbms_lob.append(l_html_clob, '<p><strong>Generated: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI') || '</strong></p>');
        
        -- Materialized View Information
        dbms_lob.append(l_html_clob, '<h3>Materialized View Information</h3>');
        dbms_lob.append(l_html_clob, '<table class="doc-table">');
        dbms_lob.append(l_html_clob, '<thead><tr><th>Property</th><th>Value</th></tr></thead><tbody>');
        
        for mview_rec in (
            select mview_name, refresh_mode, refresh_method, build_mode, 
                   fast_refreshable, last_refresh_date, compile_state, updatable
            from user_mviews 
            where mview_name = upper(p_mview_name)
        ) loop
            dbms_lob.append(l_html_clob, '<tr><td>Name</td><td class="col-name">' || mview_rec.mview_name || '</td></tr>');
            dbms_lob.append(l_html_clob, '<tr><td>Refresh Mode</td><td>' || mview_rec.refresh_mode || '</td></tr>');
            dbms_lob.append(l_html_clob, '<tr><td>Refresh Method</td><td>' || mview_rec.refresh_method || '</td></tr>');
            dbms_lob.append(l_html_clob, '<tr><td>Build Mode</td><td>' || mview_rec.build_mode || '</td></tr>');
            dbms_lob.append(l_html_clob, '<tr><td>Fast Refreshable</td><td>' || mview_rec.fast_refreshable || '</td></tr>');
            dbms_lob.append(l_html_clob, '<tr><td>Updatable</td><td>' || nvl(mview_rec.updatable, 'N/A') || '</td></tr>');
            dbms_lob.append(l_html_clob, '<tr><td>Last Refresh</td><td>' || 
                case when mview_rec.last_refresh_date is not null 
                     then to_char(mview_rec.last_refresh_date, 'DD-MON-YYYY HH24:MI:SS')
                     else 'Never refreshed'
                end || '</td></tr>');
            dbms_lob.append(l_html_clob, '<tr><td>Compile State</td><td>' || mview_rec.compile_state || '</td></tr>');
        end loop;
        
        dbms_lob.append(l_html_clob, '</tbody></table>');
        
        -- Materialized View Columns
        dbms_lob.append(l_html_clob, '<h3>Columns</h3>');
        dbms_lob.append(l_html_clob, '<table class="doc-table">');
        dbms_lob.append(l_html_clob, '<thead><tr><th>Column Name</th><th>Data Type</th><th>Nullable</th></tr></thead><tbody>');
        
        for col_rec in (
            select column_name,
                   case 
                       when data_type = 'VARCHAR2' then data_type || '(' || data_length || ')'
                       when data_type = 'NUMBER' and data_precision is not null then 
                           data_type || '(' || data_precision || 
                           case when data_scale > 0 then ',' || data_scale else '' end || ')'
                       else data_type
                   end as formatted_data_type,
                   case when nullable = 'Y' then 'Yes' else '<strong>No</strong>' end as nullable
            from user_tab_columns 
            where table_name = upper(p_mview_name)
            order by column_id
        ) loop
            dbms_lob.append(l_html_clob, '<tr>');
            dbms_lob.append(l_html_clob, '<td class="col-name">' || col_rec.column_name || '</td>');
            dbms_lob.append(l_html_clob, '<td class="data-type">' || col_rec.formatted_data_type || '</td>');
            dbms_lob.append(l_html_clob, '<td>' || col_rec.nullable || '</td>');
            dbms_lob.append(l_html_clob, '</tr>');
        end loop;
        
        dbms_lob.append(l_html_clob, '</tbody></table>');
        
        -- MView Logs (if any)
        dbms_lob.append(l_html_clob, '<h3>Materialized View Logs</h3>');
        dbms_lob.append(l_html_clob, '<table class="doc-table">');
        dbms_lob.append(l_html_clob, '<thead><tr><th>Master Table</th><th>Log Table</th><th>Rowids</th><th>Primary Key</th></tr></thead><tbody>');
        
        for log_rec in (
            select master, log_table, rowids, primary_key
            from user_mview_logs
            where master in (
                select table_name 
                from user_tables 
                where table_name in (
                    -- Try to find related tables (this is a simple approach)
                    select substr(mview_name, 1, 20) from user_mviews where mview_name = upper(p_mview_name)
                )
            )
        ) loop
            dbms_lob.append(l_html_clob, '<tr>');
            dbms_lob.append(l_html_clob, '<td class="col-name">' || log_rec.master || '</td>');
            dbms_lob.append(l_html_clob, '<td class="col-name">' || log_rec.log_table || '</td>');
            dbms_lob.append(l_html_clob, '<td>' || log_rec.rowids || '</td>');
            dbms_lob.append(l_html_clob, '<td>' || log_rec.primary_key || '</td>');
            dbms_lob.append(l_html_clob, '</tr>');
        end loop;
        
        -- If no logs found
        if sql%rowcount = 0 then
            dbms_lob.append(l_html_clob, '<tr><td colspan="4"><em>No materialized view logs found</em></td></tr>');
        end if;
        
        dbms_lob.append(l_html_clob, '</tbody></table>');
        
        return l_html_clob;
    exception
        when others then
            if dbms_lob.istemporary(l_html_clob) = 1 then
                dbms_lob.freetemporary(l_html_clob);
            end if;
            dbms_lob.createtemporary(l_html_clob, false);
            dbms_lob.append(l_html_clob, '<p>Error: ' || sqlerrm || '</p>');
            return l_html_clob;
    end get_mview_docs_html;

    function get_package_docs_html(p_package_name varchar2 default null) return clob is
    l_html_clob clob;
begin
    dbms_lob.createtemporary(l_html_clob, false);
    
    dbms_lob.append(l_html_clob, '<h1>Package Documentation: ' || p_package_name || '</h1>');
    dbms_lob.append(l_html_clob, '<p><strong>Generated: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI') || '</strong></p>');
    
    -- Package Information
    dbms_lob.append(l_html_clob, '<h3>Package Information</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Property</th><th>Value</th></tr></thead><tbody>');
    
    for pkg_rec in (
        select object_name, status, created, last_ddl_time
        from user_objects 
        where object_name = upper(p_package_name) and object_type = 'PACKAGE'
    ) loop
        dbms_lob.append(l_html_clob, '<tr><td>Package Name</td><td class="col-name">' || pkg_rec.object_name || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Status</td><td>' || pkg_rec.status || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Created</td><td>' || to_char(pkg_rec.created, 'DD-MON-YYYY HH24:MI:SS') || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Last DDL</td><td>' || to_char(pkg_rec.last_ddl_time, 'DD-MON-YYYY HH24:MI:SS') || '</td></tr>');
    end loop;
    
    -- Check for package body
    for body_rec in (
        select status
        from user_objects 
        where object_name = upper(p_package_name) and object_type = 'PACKAGE BODY'
    ) loop
        dbms_lob.append(l_html_clob, '<tr><td>Body Status</td><td>' || body_rec.status || '</td></tr>');
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Package Procedures and Functions
    dbms_lob.append(l_html_clob, '<h3>Package Contents</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Name</th><th>Type</th><th>Overload</th></tr></thead><tbody>');
    
    for proc_rec in (
        select object_name, procedure_name, object_type, overload
        from user_procedures
        where object_name = upper(p_package_name)
        order by procedure_name, nvl(overload,0)
    ) loop
        dbms_lob.append(l_html_clob, '<tr>');
        dbms_lob.append(l_html_clob, '<td class="col-name">' || nvl(proc_rec.procedure_name, 'Package Initialization') || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || proc_rec.object_type || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || nvl(to_char(proc_rec.overload), 'N/A') || '</td>');
        dbms_lob.append(l_html_clob, '</tr>');
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Package Parameters/Arguments
    dbms_lob.append(l_html_clob, '<h3>Parameters</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Procedure/Function</th><th>Parameter</th><th>Position</th><th>In/Out</th><th>Data Type</th></tr></thead><tbody>');
    
    for arg_rec in (
        select package_name, object_name, argument_name, position, in_out, data_type, overload
        from user_arguments
        where package_name = upper(p_package_name)
        and argument_name is not null
        order by object_name, nvl(overload,0), position
    ) loop
        dbms_lob.append(l_html_clob, '<tr>');
        dbms_lob.append(l_html_clob, '<td class="col-name">' || arg_rec.object_name || 
            case when arg_rec.overload is not null then ' (' || arg_rec.overload || ')' else '' end || '</td>');
        dbms_lob.append(l_html_clob, '<td class="col-name">' || arg_rec.argument_name || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || arg_rec.position || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || arg_rec.in_out || '</td>');
        dbms_lob.append(l_html_clob, '<td class="data-type">' || arg_rec.data_type || '</td>');
        dbms_lob.append(l_html_clob, '</tr>');
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Package Dependencies
    dbms_lob.append(l_html_clob, '<h3>Dependencies</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Referenced Name</th><th>Referenced Type</th><th>Referenced Owner</th></tr></thead><tbody>');
    
    for dep_rec in (
        select referenced_name, referenced_type, referenced_owner
        from user_dependencies
        where name = upper(p_package_name)
        and type = 'PACKAGE'
        and referenced_name != upper(p_package_name)
        order by referenced_name
    ) loop
        dbms_lob.append(l_html_clob, '<tr>');
        dbms_lob.append(l_html_clob, '<td class="col-name">' || dep_rec.referenced_name || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || dep_rec.referenced_type || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || dep_rec.referenced_owner || '</td>');
        dbms_lob.append(l_html_clob, '</tr>');
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    return l_html_clob;
exception
    when others then
        if dbms_lob.istemporary(l_html_clob) = 1 then
            dbms_lob.freetemporary(l_html_clob);
        end if;
        dbms_lob.createtemporary(l_html_clob, false);
        dbms_lob.append(l_html_clob, '<p>Error: ' || sqlerrm || '</p>');
        return l_html_clob;
end get_package_docs_html;

    function get_procedure_docs_html(p_procedure_name varchar2 default null) return clob is
    l_html_clob clob;
begin
    dbms_lob.createtemporary(l_html_clob, false);
    
    dbms_lob.append(l_html_clob, '<h1>Procedure Documentation: ' || p_procedure_name || '</h1>');
    dbms_lob.append(l_html_clob, '<p><strong>Generated: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI') || '</strong></p>');
    
    -- Procedure Information
    dbms_lob.append(l_html_clob, '<h3>Procedure Information</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Property</th><th>Value</th></tr></thead><tbody>');
    
    for proc_rec in (
        select object_name, status, created, last_ddl_time
        from user_objects 
        where object_name = upper(p_procedure_name) and object_type = 'PROCEDURE'
    ) loop
        dbms_lob.append(l_html_clob, '<tr><td>Procedure Name</td><td class="col-name">' || proc_rec.object_name || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Status</td><td>' || proc_rec.status || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Created</td><td>' || to_char(proc_rec.created, 'DD-MON-YYYY HH24:MI:SS') || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Last DDL</td><td>' || to_char(proc_rec.last_ddl_time, 'DD-MON-YYYY HH24:MI:SS') || '</td></tr>');
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Procedure Parameters
    dbms_lob.append(l_html_clob, '<h3>Parameters</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Parameter Name</th><th>Position</th><th>In/Out</th><th>Data Type</th><th>Default Value</th></tr></thead><tbody>');
    
    for param_rec in (
        select argument_name, position, in_out, data_type, 
               case when defaulted = 'Y' then 'Yes' else 'No' end as has_default
        from user_arguments
        where object_name = upper(p_procedure_name)
        and package_name is null
        and argument_name is not null
        order by position
    ) loop
        dbms_lob.append(l_html_clob, '<tr>');
        dbms_lob.append(l_html_clob, '<td class="col-name">' || param_rec.argument_name || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || param_rec.position || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || param_rec.in_out || '</td>');
        dbms_lob.append(l_html_clob, '<td class="data-type">' || param_rec.data_type || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || param_rec.has_default || '</td>');
        dbms_lob.append(l_html_clob, '</tr>');
    end loop;
    
    -- If no parameters
    if sql%rowcount = 0 then
        dbms_lob.append(l_html_clob, '<tr><td colspan="5"><em>No parameters</em></td></tr>');
    end if;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Dependencies (what this procedure uses)
    dbms_lob.append(l_html_clob, '<h3>Dependencies</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Referenced Name</th><th>Referenced Type</th><th>Referenced Owner</th></tr></thead><tbody>');
    
    for dep_rec in (
        select referenced_name, referenced_type, referenced_owner
        from user_dependencies
        where name = upper(p_procedure_name)
        and type = 'PROCEDURE'
        and referenced_name != upper(p_procedure_name)
        order by referenced_name
    ) loop
        dbms_lob.append(l_html_clob, '<tr>');
        dbms_lob.append(l_html_clob, '<td class="col-name">' || dep_rec.referenced_name || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || dep_rec.referenced_type || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || dep_rec.referenced_owner || '</td>');
        dbms_lob.append(l_html_clob, '</tr>');
    end loop;
    
    -- If no dependencies
    if sql%rowcount = 0 then
        dbms_lob.append(l_html_clob, '<tr><td colspan="3"><em>No dependencies found</em></td></tr>');
    end if;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Objects that depend on this procedure
    dbms_lob.append(l_html_clob, '<h3>Dependent Objects</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Object Name</th><th>Object Type</th></tr></thead><tbody>');
    
    for dep_rec in (
        select name, type
        from user_dependencies
        where referenced_name = upper(p_procedure_name)
        and referenced_type = 'PROCEDURE'
        order by name
    ) loop
        dbms_lob.append(l_html_clob, '<tr>');
        dbms_lob.append(l_html_clob, '<td class="col-name">' || dep_rec.name || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || dep_rec.type || '</td>');
        dbms_lob.append(l_html_clob, '</tr>');
    end loop;
    
    -- If no dependent objects
    if sql%rowcount = 0 then
        dbms_lob.append(l_html_clob, '<tr><td colspan="2"><em>No dependent objects found</em></td></tr>');
    end if;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    return l_html_clob;
exception
    when others then
        if dbms_lob.istemporary(l_html_clob) = 1 then
            dbms_lob.freetemporary(l_html_clob);
        end if;
        dbms_lob.createtemporary(l_html_clob, false);
        dbms_lob.append(l_html_clob, '<p>Error: ' || sqlerrm || '</p>');
        return l_html_clob;
end get_procedure_docs_html;

    function get_function_docs_html(p_function_name varchar2 default null) return clob is
    l_html_clob clob;
begin
    dbms_lob.createtemporary(l_html_clob, false);
    
    dbms_lob.append(l_html_clob, '<h1>Function Documentation: ' || p_function_name || '</h1>');
    dbms_lob.append(l_html_clob, '<p><strong>Generated: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI') || '</strong></p>');
    
    -- Function Information
    dbms_lob.append(l_html_clob, '<h3>Function Information</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Property</th><th>Value</th></tr></thead><tbody>');
    
    for func_rec in (
        select object_name, status, created, last_ddl_time
        from user_objects 
        where object_name = upper(p_function_name) and object_type = 'FUNCTION'
    ) loop
        dbms_lob.append(l_html_clob, '<tr><td>Function Name</td><td class="col-name">' || func_rec.object_name || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Status</td><td>' || func_rec.status || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Created</td><td>' || to_char(func_rec.created, 'DD-MON-YYYY HH24:MI:SS') || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Last DDL</td><td>' || to_char(func_rec.last_ddl_time, 'DD-MON-YYYY HH24:MI:SS') || '</td></tr>');
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Return Type
    dbms_lob.append(l_html_clob, '<h3>Return Type</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Data Type</th><th>Length</th><th>Precision</th><th>Scale</th></tr></thead><tbody>');
    
    for return_rec in (
        select data_type, data_length, data_precision, data_scale
        from user_arguments
        where object_name = upper(p_function_name)
        and package_name is null
        and argument_name is null
        and position = 0
    ) loop
        dbms_lob.append(l_html_clob, '<tr>');
        dbms_lob.append(l_html_clob, '<td class="data-type">' || return_rec.data_type || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || nvl(to_char(return_rec.data_length), 'N/A') || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || nvl(to_char(return_rec.data_precision), 'N/A') || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || nvl(to_char(return_rec.data_scale), 'N/A') || '</td>');
        dbms_lob.append(l_html_clob, '</tr>');
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Function Parameters
    dbms_lob.append(l_html_clob, '<h3>Parameters</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Parameter Name</th><th>Position</th><th>In/Out</th><th>Data Type</th><th>Default Value</th></tr></thead><tbody>');
    
    for param_rec in (
        select argument_name, position, in_out, data_type, 
               case when defaulted = 'Y' then 'Yes' else 'No' end as has_default
        from user_arguments
        where object_name = upper(p_function_name)
        and package_name is null
        and argument_name is not null
        and position > 0
        order by position
    ) loop
        dbms_lob.append(l_html_clob, '<tr>');
        dbms_lob.append(l_html_clob, '<td class="col-name">' || param_rec.argument_name || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || param_rec.position || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || param_rec.in_out || '</td>');
        dbms_lob.append(l_html_clob, '<td class="data-type">' || param_rec.data_type || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || param_rec.has_default || '</td>');
        dbms_lob.append(l_html_clob, '</tr>');
    end loop;
    
    -- If no parameters
    if sql%rowcount = 0 then
        dbms_lob.append(l_html_clob, '<tr><td colspan="5"><em>No parameters</em></td></tr>');
    end if;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Dependencies (what this function uses)
    dbms_lob.append(l_html_clob, '<h3>Dependencies</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Referenced Name</th><th>Referenced Type</th><th>Referenced Owner</th></tr></thead><tbody>');
    
    for dep_rec in (
        select referenced_name, referenced_type, referenced_owner
        from user_dependencies
        where name = upper(p_function_name)
        and type = 'FUNCTION'
        and referenced_name != upper(p_function_name)
        order by referenced_name
    ) loop
        dbms_lob.append(l_html_clob, '<tr>');
        dbms_lob.append(l_html_clob, '<td class="col-name">' || dep_rec.referenced_name || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || dep_rec.referenced_type || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || dep_rec.referenced_owner || '</td>');
        dbms_lob.append(l_html_clob, '</tr>');
    end loop;
    
    -- If no dependencies
    if sql%rowcount = 0 then
        dbms_lob.append(l_html_clob, '<tr><td colspan="3"><em>No dependencies found</em></td></tr>');
    end if;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Objects that depend on this function
    dbms_lob.append(l_html_clob, '<h3>Dependent Objects</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Object Name</th><th>Object Type</th></tr></thead><tbody>');
    
    for dep_rec in (
        select name, type
        from user_dependencies
        where referenced_name = upper(p_function_name)
        and referenced_type = 'FUNCTION'
        order by name
    ) loop
        dbms_lob.append(l_html_clob, '<tr>');
        dbms_lob.append(l_html_clob, '<td class="col-name">' || dep_rec.name || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || dep_rec.type || '</td>');
        dbms_lob.append(l_html_clob, '</tr>');
    end loop;
    
    -- If no dependent objects
    if sql%rowcount = 0 then
        dbms_lob.append(l_html_clob, '<tr><td colspan="2"><em>No dependent objects found</em></td></tr>');
    end if;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    return l_html_clob;
exception
    when others then
        if dbms_lob.istemporary(l_html_clob) = 1 then
            dbms_lob.freetemporary(l_html_clob);
        end if;
        dbms_lob.createtemporary(l_html_clob, false);
        dbms_lob.append(l_html_clob, '<p>Error: ' || sqlerrm || '</p>');
        return l_html_clob;
end get_function_docs_html;

    function get_sequence_docs_html(p_sequence_name varchar2 default null) return clob is
    l_html_clob clob;
begin
    dbms_lob.createtemporary(l_html_clob, false);
    
    dbms_lob.append(l_html_clob, '<h1>Sequence Documentation: ' || p_sequence_name || '</h1>');
    dbms_lob.append(l_html_clob, '<p><strong>Generated: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI') || '</strong></p>');
    
    -- Sequence Information
    dbms_lob.append(l_html_clob, '<h3>Sequence Information</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Property</th><th>Value</th></tr></thead><tbody>');
    
    for seq_rec in (
        select sequence_name, min_value, max_value, increment_by, 
               cycle_flag, order_flag, cache_size, last_number
        from user_sequences 
        where sequence_name = upper(p_sequence_name)
    ) loop
        dbms_lob.append(l_html_clob, '<tr><td>Sequence Name</td><td class="col-name">' || seq_rec.sequence_name || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Min Value</td><td>' || to_char(seq_rec.min_value) || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Max Value</td><td>' || to_char(seq_rec.max_value) || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Increment By</td><td>' || to_char(seq_rec.increment_by) || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Cycle</td><td>' || seq_rec.cycle_flag || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Order</td><td>' || seq_rec.order_flag || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Cache Size</td><td>' || to_char(seq_rec.cache_size) || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Last Number</td><td>' || to_char(seq_rec.last_number) || '</td></tr>');
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Object Information (creation details)
    dbms_lob.append(l_html_clob, '<h3>Object Details</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Property</th><th>Value</th></tr></thead><tbody>');
    
    for obj_rec in (
        select object_name, status, created, last_ddl_time
        from user_objects 
        where object_name = upper(p_sequence_name) and object_type = 'SEQUENCE'
    ) loop
        dbms_lob.append(l_html_clob, '<tr><td>Status</td><td>' || obj_rec.status || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Created</td><td>' || to_char(obj_rec.created, 'DD-MON-YYYY HH24:MI:SS') || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Last DDL</td><td>' || to_char(obj_rec.last_ddl_time, 'DD-MON-YYYY HH24:MI:SS') || '</td></tr>');
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Usage Analysis
    dbms_lob.append(l_html_clob, '<h3>Usage Analysis</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Analysis</th><th>Value</th></tr></thead><tbody>');
    
    for seq_rec in (
        select sequence_name, min_value, max_value, increment_by, last_number
        from user_sequences 
        where sequence_name = upper(p_sequence_name)
    ) loop
        -- Calculate remaining values
        declare
            l_remaining number;
            l_percentage_used number;
        begin
            if seq_rec.increment_by > 0 then
                l_remaining := seq_rec.max_value - seq_rec.last_number;
                l_percentage_used := ((seq_rec.last_number - seq_rec.min_value) / (seq_rec.max_value - seq_rec.min_value)) * 100;
            else
                l_remaining := seq_rec.last_number - seq_rec.min_value;
                l_percentage_used := ((seq_rec.max_value - seq_rec.last_number) / (seq_rec.max_value - seq_rec.min_value)) * 100;
            end if;
            
            dbms_lob.append(l_html_clob, '<tr><td>Current Value</td><td>' || to_char(seq_rec.last_number) || '</td></tr>');
            dbms_lob.append(l_html_clob, '<tr><td>Remaining Values</td><td>' || to_char(l_remaining) || '</td></tr>');
            dbms_lob.append(l_html_clob, '<tr><td>Percentage Used</td><td>' || to_char(round(l_percentage_used, 2)) || '%</td></tr>');
            
            -- Next few values
            dbms_lob.append(l_html_clob, '<tr><td>Next Value</td><td>' || to_char(seq_rec.last_number + seq_rec.increment_by) || '</td></tr>');
            dbms_lob.append(l_html_clob, '<tr><td>Next 5 Values</td><td>');
            for i in 1..5 loop
                dbms_lob.append(l_html_clob, to_char(seq_rec.last_number + (seq_rec.increment_by * i)));
                if i < 5 then
                    dbms_lob.append(l_html_clob, ', ');
                end if;
            end loop;
            dbms_lob.append(l_html_clob, '</td></tr>');
            
        exception
            when others then
                dbms_lob.append(l_html_clob, '<tr><td>Analysis Error</td><td>Unable to calculate usage statistics</td></tr>');
        end;
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Dependencies (objects that depend on this sequence)
    dbms_lob.append(l_html_clob, '<h3>Dependent Objects</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Object Name</th><th>Object Type</th></tr></thead><tbody>');
    
    for dep_rec in (
        select name, type
        from user_dependencies
        where referenced_name = upper(p_sequence_name)
        and referenced_type = 'SEQUENCE'
        order by name
    ) loop
        dbms_lob.append(l_html_clob, '<tr>');
        dbms_lob.append(l_html_clob, '<td class="col-name">' || dep_rec.name || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || dep_rec.type || '</td>');
        dbms_lob.append(l_html_clob, '</tr>');
    end loop;
    
    -- If no dependent objects
    if sql%rowcount = 0 then
        dbms_lob.append(l_html_clob, '<tr><td colspan="2"><em>No dependent objects found</em></td></tr>');
    end if;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Sequence Recommendations
    dbms_lob.append(l_html_clob, '<h3>Recommendations</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Recommendation</th><th>Description</th></tr></thead><tbody>');
    
    for seq_rec in (
        select sequence_name, min_value, max_value, increment_by, last_number, cache_size, cycle_flag
        from user_sequences 
        where sequence_name = upper(p_sequence_name)
    ) loop
        -- Cache size recommendation
        if seq_rec.cache_size < 20 then
            dbms_lob.append(l_html_clob, '<tr><td>Cache Size</td><td>Consider increasing cache size for better performance</td></tr>');
        end if;
        
        -- Approaching limit warning
        declare
            l_remaining number;
        begin
            if seq_rec.increment_by > 0 then
                l_remaining := seq_rec.max_value - seq_rec.last_number;
                if l_remaining < 1000 then
                    dbms_lob.append(l_html_clob, '<tr><td><span style="color:red;">Warning</span></td><td>Sequence is approaching maximum value</td></tr>');
                end if;
            end if;
        exception
            when others then
                null;
        end;
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    return l_html_clob;
exception
    when others then
        if dbms_lob.istemporary(l_html_clob) = 1 then
            dbms_lob.freetemporary(l_html_clob);
        end if;
        dbms_lob.createtemporary(l_html_clob, false);
        dbms_lob.append(l_html_clob, '<p>Error: ' || sqlerrm || '</p>');
        return l_html_clob;
end get_sequence_docs_html;

    function get_trigger_docs_html(p_trigger_name varchar2 default null) return clob is
    l_html_clob clob;
begin
    dbms_lob.createtemporary(l_html_clob, false);
    
    dbms_lob.append(l_html_clob, '<h1>Trigger Documentation: ' || p_trigger_name || '</h1>');
    dbms_lob.append(l_html_clob, '<p><strong>Generated: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI') || '</strong></p>');
    
    -- Trigger Information
    dbms_lob.append(l_html_clob, '<h3>Trigger Information</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Property</th><th>Value</th></tr></thead><tbody>');
    
    for trig_rec in (
        select trigger_name, trigger_type, triggering_event, table_name, base_object_type,
               table_owner, column_name, referencing_names, when_clause, status, 
               description, action_type, trigger_body
        from user_triggers 
        where trigger_name = upper(p_trigger_name)
    ) loop
        dbms_lob.append(l_html_clob, '<tr><td>Trigger Name</td><td class="col-name">' || trig_rec.trigger_name || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Trigger Type</td><td>' || trig_rec.trigger_type || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Triggering Event</td><td>' || trig_rec.triggering_event || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Table Name</td><td class="col-name">' || nvl(trig_rec.table_name, 'N/A') || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Base Object Type</td><td>' || nvl(trig_rec.base_object_type, 'N/A') || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Table Owner</td><td>' || nvl(trig_rec.table_owner, 'N/A') || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Column Name</td><td class="col-name">' || nvl(trig_rec.column_name, 'N/A') || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Status</td><td>' || trig_rec.status || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Action Type</td><td>' || nvl(trig_rec.action_type, 'N/A') || '</td></tr>');
        
        if trig_rec.referencing_names is not null then
            dbms_lob.append(l_html_clob, '<tr><td>Referencing Names</td><td>' || trig_rec.referencing_names || '</td></tr>');
        end if;
        
        if trig_rec.when_clause is not null then
            dbms_lob.append(l_html_clob, '<tr><td>When Clause</td><td><code>' || substr(trig_rec.when_clause, 1, 200) || 
                case when length(trig_rec.when_clause) > 200 then '...' else '' end || '</code></td></tr>');
        end if;
        
        if trig_rec.description is not null then
            dbms_lob.append(l_html_clob, '<tr><td>Description</td><td>' || substr(trig_rec.description, 1, 500) || 
                case when length(trig_rec.description) > 500 then '...' else '' end || '</td></tr>');
        end if;
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Object Information (creation details)
    dbms_lob.append(l_html_clob, '<h3>Object Details</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Property</th><th>Value</th></tr></thead><tbody>');
    
    for obj_rec in (
        select object_name, status, created, last_ddl_time
        from user_objects 
        where object_name = upper(p_trigger_name) and object_type = 'TRIGGER'
    ) loop
        dbms_lob.append(l_html_clob, '<tr><td>Object Status</td><td>' || obj_rec.status || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Created</td><td>' || to_char(obj_rec.created, 'DD-MON-YYYY HH24:MI:SS') || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Last DDL</td><td>' || to_char(obj_rec.last_ddl_time, 'DD-MON-YYYY HH24:MI:SS') || '</td></tr>');
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Trigger Body (partial)
    dbms_lob.append(l_html_clob, '<h3>Trigger Body (First 1000 Characters)</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Trigger Code</th></tr></thead><tbody>');
    
    for body_rec in (
        select trigger_body
        from user_triggers 
        where trigger_name = upper(p_trigger_name)
    ) loop
        dbms_lob.append(l_html_clob, '<tr><td><pre style="white-space: pre-wrap; font-family: monospace; font-size: 12px; background: #f5f5f5; padding: 10px; border-radius: 4px;">');
        
        if body_rec.trigger_body is not null then
            -- Show first 1000 characters of trigger body
            dbms_lob.append(l_html_clob, substr(body_rec.trigger_body, 1, 1000));
            if length(body_rec.trigger_body) > 1000 then
                dbms_lob.append(l_html_clob, chr(10) || chr(10) || '... (truncated)');
            end if;
        else
            dbms_lob.append(l_html_clob, 'No trigger body available');
        end if;
        
        dbms_lob.append(l_html_clob, '</pre></td></tr>');
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Dependencies (what this trigger uses)
    dbms_lob.append(l_html_clob, '<h3>Dependencies</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Referenced Name</th><th>Referenced Type</th><th>Referenced Owner</th></tr></thead><tbody>');
    
    for dep_rec in (
        select referenced_name, referenced_type, referenced_owner
        from user_dependencies
        where name = upper(p_trigger_name)
        and type = 'TRIGGER'
        and referenced_name != upper(p_trigger_name)
        order by referenced_name
    ) loop
        dbms_lob.append(l_html_clob, '<tr>');
        dbms_lob.append(l_html_clob, '<td class="col-name">' || dep_rec.referenced_name || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || dep_rec.referenced_type || '</td>');
        dbms_lob.append(l_html_clob, '<td>' || dep_rec.referenced_owner || '</td>');
        dbms_lob.append(l_html_clob, '</tr>');
    end loop;
    
    -- If no dependencies
    if sql%rowcount = 0 then
        dbms_lob.append(l_html_clob, '<tr><td colspan="3"><em>No dependencies found</em></td></tr>');
    end if;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Related Table Information (if applicable)
    dbms_lob.append(l_html_clob, '<h3>Related Table Information</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Property</th><th>Value</th></tr></thead><tbody>');
    
    for table_info in (
        select t.trigger_name, t.table_name, 
               (select count(*) from user_tab_columns where table_name = t.table_name) as column_count,
               (select count(*) from user_triggers where table_name = t.table_name) as trigger_count
        from user_triggers t
        where t.trigger_name = upper(p_trigger_name)
        and t.table_name is not null
    ) loop
        dbms_lob.append(l_html_clob, '<tr><td>Target Table</td><td class="col-name">' || table_info.table_name || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Table Columns</td><td>' || to_char(table_info.column_count) || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Total Triggers on Table</td><td>' || to_char(table_info.trigger_count) || '</td></tr>');
    end loop;
    
    -- If no related table
    if sql%rowcount = 0 then
        dbms_lob.append(l_html_clob, '<tr><td colspan="2"><em>No related table information (system or schema trigger)</em></td></tr>');
    end if;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Trigger Analysis
    dbms_lob.append(l_html_clob, '<h3>Trigger Analysis</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Analysis</th><th>Description</th></tr></thead><tbody>');
    
    for analysis in (
        select trigger_name, trigger_type, triggering_event, status, trigger_body
        from user_triggers 
        where trigger_name = upper(p_trigger_name)
    ) loop
        -- Trigger timing analysis
        if instr(upper(analysis.trigger_type), 'BEFORE') > 0 then
            dbms_lob.append(l_html_clob, '<tr><td>Timing</td><td>BEFORE trigger - executes before the triggering event</td></tr>');
        elsif instr(upper(analysis.trigger_type), 'AFTER') > 0 then
            dbms_lob.append(l_html_clob, '<tr><td>Timing</td><td>AFTER trigger - executes after the triggering event</td></tr>');
        elsif instr(upper(analysis.trigger_type), 'INSTEAD OF') > 0 then
            dbms_lob.append(l_html_clob, '<tr><td>Timing</td><td>INSTEAD OF trigger - replaces the triggering event</td></tr>');
        end if;
        
        -- Event analysis
        if instr(upper(analysis.triggering_event), 'INSERT') > 0 then
            dbms_lob.append(l_html_clob, '<tr><td>INSERT Event</td><td>Trigger fires on INSERT operations</td></tr>');
        end if;
        if instr(upper(analysis.triggering_event), 'UPDATE') > 0 then
            dbms_lob.append(l_html_clob, '<tr><td>UPDATE Event</td><td>Trigger fires on UPDATE operations</td></tr>');
        end if;
        if instr(upper(analysis.triggering_event), 'DELETE') > 0 then
            dbms_lob.append(l_html_clob, '<tr><td>DELETE Event</td><td>Trigger fires on DELETE operations</td></tr>');
        end if;
        
        -- Status analysis
        if analysis.status = 'DISABLED' then
            dbms_lob.append(l_html_clob, '<tr><td><span style="color:orange;">Status Warning</span></td><td>Trigger is currently disabled</td></tr>');
        end if;
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    return l_html_clob;
exception
    when others then
        if dbms_lob.istemporary(l_html_clob) = 1 then
            dbms_lob.freetemporary(l_html_clob);
        end if;
        dbms_lob.createtemporary(l_html_clob, false);
        dbms_lob.append(l_html_clob, '<p>Error: ' || sqlerrm || '</p>');
        return l_html_clob;
end get_trigger_docs_html;

    function get_overview_docs_html return clob is
        l_html_clob clob;
    begin
        dbms_lob.createtemporary(l_html_clob, false);
        
        dbms_lob.append(l_html_clob, '<div style="text-align: center; padding: 50px; color: #666;">');
        dbms_lob.append(l_html_clob, '<h2>Database Documentation</h2>');
        dbms_lob.append(l_html_clob, '<p>Please select an object type and name to view documentation.</p>');
        dbms_lob.append(l_html_clob, '</div>');
        
        return l_html_clob;
    exception
        when others then
            if dbms_lob.istemporary(l_html_clob) = 1 then
                dbms_lob.freetemporary(l_html_clob);
            end if;
            dbms_lob.createtemporary(l_html_clob, false);
            dbms_lob.append(l_html_clob, '<p>Error: ' || sqlerrm || '</p>');
            return l_html_clob;
    end get_overview_docs_html;

    -- Show procedures that call the HTML functions
    procedure show_table_docs(p_table_name varchar2 default null) is
        l_html clob;
    begin
        l_html := get_table_docs_html(p_table_name);
        output_clob_in_chunks(l_html);
        
        -- Clean up the CLOB
        if dbms_lob.istemporary(l_html) = 1 then
            dbms_lob.freetemporary(l_html);
        end if;
    exception
        when others then
            htp.p('<p style="color:red;">Error: ' || sqlerrm || '</p>');
    end show_table_docs;

    procedure show_view_docs(p_view_name varchar2 default null) is
        l_html clob;
    begin
        l_html := get_view_docs_html(p_view_name);
        output_clob_in_chunks(l_html);
        if dbms_lob.istemporary(l_html) = 1 then
            dbms_lob.freetemporary(l_html);
        end if;
    exception
        when others then
            htp.p('<p style="color:red;">Error: ' || sqlerrm || '</p>');
    end show_view_docs;

    procedure show_mview_docs(p_mview_name varchar2 default null) is
        l_html clob;
    begin
        l_html := get_mview_docs_html(p_mview_name);
        output_clob_in_chunks(l_html);
        if dbms_lob.istemporary(l_html) = 1 then
            dbms_lob.freetemporary(l_html);
        end if;
    exception
        when others then
            htp.p('<p style="color:red;">Error: ' || sqlerrm || '</p>');
    end show_mview_docs;

    procedure show_package_docs(p_package_name varchar2 default null) is
        l_html clob;
    begin
        l_html := get_package_docs_html(p_package_name);
        output_clob_in_chunks(l_html);
        if dbms_lob.istemporary(l_html) = 1 then
            dbms_lob.freetemporary(l_html);
        end if;
    exception
        when others then
            htp.p('<p style="color:red;">Error: ' || sqlerrm || '</p>');
    end show_package_docs;

    procedure show_procedure_docs(p_procedure_name varchar2 default null) is
        l_html clob;
    begin
        l_html := get_procedure_docs_html(p_procedure_name);
        output_clob_in_chunks(l_html);
        if dbms_lob.istemporary(l_html) = 1 then
            dbms_lob.freetemporary(l_html);
        end if;
    exception
        when others then
            htp.p('<p style="color:red;">Error: ' || sqlerrm || '</p>');
    end show_procedure_docs;

    procedure show_function_docs(p_function_name varchar2 default null) is
        l_html clob;
    begin
        l_html := get_function_docs_html(p_function_name);
        output_clob_in_chunks(l_html);
        if dbms_lob.istemporary(l_html) = 1 then
            dbms_lob.freetemporary(l_html);
        end if;
    exception
        when others then
            htp.p('<p style="color:red;">Error: ' || sqlerrm || '</p>');
    end show_function_docs;

    procedure show_sequence_docs(p_sequence_name varchar2 default null) is
        l_html clob;
    begin
        l_html := get_sequence_docs_html(p_sequence_name);
        output_clob_in_chunks(l_html);
        if dbms_lob.istemporary(l_html) = 1 then
            dbms_lob.freetemporary(l_html);
        end if;
    exception
        when others then
            htp.p('<p style="color:red;">Error: ' || sqlerrm || '</p>');
    end show_sequence_docs;

    procedure show_trigger_docs(p_trigger_name varchar2 default null) is
        l_html clob;
    begin
        l_html := get_trigger_docs_html(p_trigger_name);
        output_clob_in_chunks(l_html);
        if dbms_lob.istemporary(l_html) = 1 then
            dbms_lob.freetemporary(l_html);
        end if;
    exception
        when others then
            htp.p('<p style="color:red;">Error: ' || sqlerrm || '</p>');
    end show_trigger_docs;

    procedure show_overview_docs is
        l_html clob;
    begin
        l_html := get_overview_docs_html();
        output_clob_in_chunks(l_html);
        if dbms_lob.istemporary(l_html) = 1 then
            dbms_lob.freetemporary(l_html);
        end if;
    exception
        when others then
            htp.p('<p style="color:red;">Error: ' || sqlerrm || '</p>');
    end show_overview_docs;



    function get_job_docs_html(p_job_name varchar2 default null) return clob is
    l_html_clob clob;
begin
    dbms_lob.createtemporary(l_html_clob, false);
    
    dbms_lob.append(l_html_clob, '<h1>Job Documentation: ' || p_job_name || '</h1>');
    dbms_lob.append(l_html_clob, '<p><strong>Generated: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI') || '</strong></p>');
    
    -- Job Information
    dbms_lob.append(l_html_clob, '<h3>Job Information</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Property</th><th>Value</th></tr></thead><tbody>');
    
    for job_rec in (
        select job_name, job_type, job_action, schedule_name, schedule_type,
               start_date, repeat_interval, end_date, enabled, state, 
               run_count, failure_count, retry_count, last_start_date, 
               last_run_duration, next_run_date, comments
        from user_scheduler_jobs 
        where job_name = upper(p_job_name)
    ) loop
        dbms_lob.append(l_html_clob, '<tr><td>Job Name</td><td class="col-name">' || job_rec.job_name || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Job Type</td><td>' || job_rec.job_type || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Job Action</td><td class="col-name">' || substr(job_rec.job_action, 1, 100) || 
            case when length(job_rec.job_action) > 100 then '...' else '' end || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Schedule Name</td><td>' || nvl(job_rec.schedule_name, 'Inline Schedule') || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Schedule Type</td><td>' || nvl(job_rec.schedule_type, 'N/A') || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Enabled</td><td>' || 
            case when job_rec.enabled = 'TRUE' then '<span style="color:green;">YES</span>' 
                 else '<span style="color:red;">NO</span>' end || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>State</td><td>' || job_rec.state || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Start Date</td><td>' || 
            case when job_rec.start_date is not null 
                 then to_char(job_rec.start_date, 'DD-MON-YYYY HH24:MI:SS')
                 else 'Not specified' end || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>End Date</td><td>' || 
            case when job_rec.end_date is not null 
                 then to_char(job_rec.end_date, 'DD-MON-YYYY HH24:MI:SS')
                 else 'Not specified' end || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Repeat Interval</td><td>' || nvl(job_rec.repeat_interval, 'Run once') || '</td></tr>');
        
        if job_rec.comments is not null then
            dbms_lob.append(l_html_clob, '<tr><td>Comments</td><td>' || job_rec.comments || '</td></tr>');
        end if;
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Job Statistics
    dbms_lob.append(l_html_clob, '<h3>Job Statistics</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Statistic</th><th>Value</th></tr></thead><tbody>');
    
    for stat_rec in (
        select job_name, run_count, failure_count, retry_count, 
               last_start_date, last_run_duration, next_run_date
        from user_scheduler_jobs 
        where job_name = upper(p_job_name)
    ) loop
        dbms_lob.append(l_html_clob, '<tr><td>Total Runs</td><td>' || to_char(nvl(stat_rec.run_count, 0)) || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Failures</td><td>' || to_char(nvl(stat_rec.failure_count, 0)) || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Retries</td><td>' || to_char(nvl(stat_rec.retry_count, 0)) || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Last Start</td><td>' || 
            case when stat_rec.last_start_date is not null 
                 then to_char(stat_rec.last_start_date, 'DD-MON-YYYY HH24:MI:SS')
                 else 'Never run' end || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Last Duration</td><td>' || nvl(stat_rec.last_run_duration, 'N/A') || '</td></tr>');
        dbms_lob.append(l_html_clob, '<tr><td>Next Run</td><td>' || 
            case when stat_rec.next_run_date is not null 
                 then to_char(stat_rec.next_run_date, 'DD-MON-YYYY HH24:MI:SS')
                 else 'Not scheduled' end || '</td></tr>');
        
        -- Calculate success rate
        declare
            l_success_rate number;
        begin
            if nvl(stat_rec.run_count, 0) > 0 then
                l_success_rate := ((nvl(stat_rec.run_count, 0) - nvl(stat_rec.failure_count, 0)) / stat_rec.run_count) * 100;
                dbms_lob.append(l_html_clob, '<tr><td>Success Rate</td><td>' || to_char(round(l_success_rate, 2)) || '%</td></tr>');
            else
                dbms_lob.append(l_html_clob, '<tr><td>Success Rate</td><td>N/A (No runs yet)</td></tr>');
            end if;
        exception
            when others then
                dbms_lob.append(l_html_clob, '<tr><td>Success Rate</td><td>Unable to calculate</td></tr>');
        end;
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Job Arguments (simplified - checking if view exists)
    dbms_lob.append(l_html_clob, '<h3>Job Arguments</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Position</th><th>Argument Name</th><th>Value</th></tr></thead><tbody>');
    
    begin
        for arg_rec in (
            select argument_position, argument_name, value
            from user_scheduler_job_args
            where job_name = upper(p_job_name)
            order by argument_position
        ) loop
            dbms_lob.append(l_html_clob, '<tr>');
            dbms_lob.append(l_html_clob, '<td>' || to_char(arg_rec.argument_position) || '</td>');
            dbms_lob.append(l_html_clob, '<td class="col-name">' || nvl(arg_rec.argument_name, 'Positional Arg') || '</td>');
            dbms_lob.append(l_html_clob, '<td>' || substr(arg_rec.value, 1, 100) || 
                case when length(arg_rec.value) > 100 then '...' else '' end || '</td>');
            dbms_lob.append(l_html_clob, '</tr>');
        end loop;
        
        -- If no arguments
        if sql%rowcount = 0 then
            dbms_lob.append(l_html_clob, '<tr><td colspan="3"><em>No job arguments</em></td></tr>');
        end if;
    exception
        when others then
            dbms_lob.append(l_html_clob, '<tr><td colspan="3"><em>Job arguments information not available</em></td></tr>');
    end;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Recent Job Runs (simplified)
    dbms_lob.append(l_html_clob, '<h3>Recent Job Runs</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Run Date</th><th>Status</th><th>Error Message</th></tr></thead><tbody>');
    
    begin
        for run_rec in (
            select log_date, status, additional_info
            from user_scheduler_job_log
            where job_name = upper(p_job_name)
            order by log_date desc
            fetch first 10 rows only
        ) loop
            dbms_lob.append(l_html_clob, '<tr>');
            dbms_lob.append(l_html_clob, '<td>' || to_char(run_rec.log_date, 'DD-MON-YYYY HH24:MI:SS') || '</td>');
            dbms_lob.append(l_html_clob, '<td>' || 
                case when run_rec.status = 'SUCCEEDED' then '<span style="color:green;">' || run_rec.status || '</span>'
                     when run_rec.status = 'FAILED' then '<span style="color:red;">' || run_rec.status || '</span>'
                     else run_rec.status 
                end || '</td>');
            dbms_lob.append(l_html_clob, '<td>' || substr(nvl(run_rec.additional_info, 'N/A'), 1, 200) || '</td>');
            dbms_lob.append(l_html_clob, '</tr>');
        end loop;
        
        -- If no run history
        if sql%rowcount = 0 then
            dbms_lob.append(l_html_clob, '<tr><td colspan="3"><em>No job run history found</em></td></tr>');
        end if;
    exception
        when others then
            dbms_lob.append(l_html_clob, '<tr><td colspan="3"><em>Job run history not available</em></td></tr>');
    end;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    -- Job Analysis and Recommendations
    dbms_lob.append(l_html_clob, '<h3>Analysis & Recommendations</h3>');
    dbms_lob.append(l_html_clob, '<table class="doc-table">');
    dbms_lob.append(l_html_clob, '<thead><tr><th>Analysis</th><th>Description</th></tr></thead><tbody>');
    
    for analysis in (
        select job_name, enabled, state, run_count, failure_count, next_run_date
        from user_scheduler_jobs 
        where job_name = upper(p_job_name)
    ) loop
        -- Job status analysis
        if analysis.enabled = 'FALSE' then
            dbms_lob.append(l_html_clob, '<tr><td><span style="color:orange;">Warning</span></td><td>Job is disabled</td></tr>');
        end if;
        
        if analysis.state = 'BROKEN' then
            dbms_lob.append(l_html_clob, '<tr><td><span style="color:red;">Error</span></td><td>Job is in BROKEN state</td></tr>');
        end if;
        
        -- Failure rate analysis
        if nvl(analysis.run_count, 0) > 0 and nvl(analysis.failure_count, 0) > 0 then
            declare
                l_failure_rate number;
            begin
                l_failure_rate := (analysis.failure_count / analysis.run_count) * 100;
                if l_failure_rate > 10 then
                    dbms_lob.append(l_html_clob, '<tr><td><span style="color:red;">High Failure Rate</span></td><td>Job has ' || 
                        to_char(round(l_failure_rate, 1)) || '% failure rate</td></tr>');
                elsif l_failure_rate > 5 then
                    dbms_lob.append(l_html_clob, '<tr><td><span style="color:orange;">Moderate Failures</span></td><td>Job has ' || 
                        to_char(round(l_failure_rate, 1)) || '% failure rate</td></tr>');
                end if;
            exception
                when others then
                    null;
            end;
        end if;
        
        -- Next run analysis
        if analysis.next_run_date is null and analysis.enabled = 'TRUE' then
            dbms_lob.append(l_html_clob, '<tr><td><span style="color:orange;">Schedule Issue</span></td><td>Job is enabled but has no next run date</td></tr>');
        end if;
        
        -- Performance recommendations
        if nvl(analysis.run_count, 0) = 0 then
            dbms_lob.append(l_html_clob, '<tr><td>Info</td><td>Job has never been executed</td></tr>');
        end if;
    end loop;
    
    dbms_lob.append(l_html_clob, '</tbody></table>');
    
    return l_html_clob;
exception
    when others then
        if dbms_lob.istemporary(l_html_clob) = 1 then
            dbms_lob.freetemporary(l_html_clob);
        end if;
        dbms_lob.createtemporary(l_html_clob, false);
        dbms_lob.append(l_html_clob, '<p>Error: ' || sqlerrm || '</p>');
        return l_html_clob;
end get_job_docs_html;

procedure show_job_docs(p_job_name varchar2 default null) is
    l_html clob;
begin
    l_html := get_job_docs_html(p_job_name);
    output_clob_in_chunks(l_html);
    if dbms_lob.istemporary(l_html) = 1 then
        dbms_lob.freetemporary(l_html);
    end if;
exception
    when others then
        htp.p('<p style="color:red;">Error: ' || sqlerrm || '</p>');
end show_job_docs;







    








end PCK_MARKDOWN;
/