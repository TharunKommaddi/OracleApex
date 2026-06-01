--
-- Function "GET_TABLE_DOCS_HTML"
--
CREATE OR REPLACE EDITIONABLE FUNCTION "WKSP_THARUN"."GET_TABLE_DOCS_HTML" (
    p_table_name in varchar2 default null
) return clob
is
    l_html_clob clob;
    l_table_count number := 0;
    l_constraint_count number := 0;
    l_relationship_count number := 0;
begin
    -- Initialize CLOB
    dbms_lob.createtemporary(l_html_clob, false);

    -- If no table selected, show message
    IF p_table_name IS NULL THEN
        dbms_lob.append(l_html_clob, '<div style="text-align: center; padding: 50px; color: #666;">');
        dbms_lob.append(l_html_clob, '<h2>Database Documentation</h2>');
        dbms_lob.append(l_html_clob, '<p>Please select a table from the dropdown above to view its documentation.</p>');
        dbms_lob.append(l_html_clob, '</div>');
        RETURN l_html_clob;
    END IF;

    
    
    -- Header
    dbms_lob.append(l_html_clob, '<h1>Database Tables Documentation</h1>');
    dbms_lob.append(l_html_clob, '<p><strong>Generated: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI') || '</strong></p>');
    
    -- Loop through tables
    for table_rec in (
        select table_name
        from user_tables
        where (p_table_name is null or table_name = upper(p_table_name))
        and table_name not like 'APEX$%'
        and table_name not like 'BIN$%'
        order by table_name
    ) loop
        l_table_count := l_table_count + 1;
        
        -- Table header
        dbms_lob.append(l_html_clob, '<h2>' || table_rec.table_name || '</h2>');
        
        -- Columns section header
        dbms_lob.append(l_html_clob, '<h3>Columns</h3>');
        
        -- Create HTML table for columns
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
        
        -- Loop through columns
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
                and ac.table_name = table_rec.table_name
            ) pk on (c.column_name = pk.column_name)
            where c.table_name = table_rec.table_name
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
        
        -- Constraints Section
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
            where c.table_name = table_rec.table_name
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
            where c.table_name = table_rec.table_name
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
        
        -- Unique Constraints
        for cons_rec in (
            select 
                c.constraint_name,
                listagg(cc.column_name, ', ') within group (order by cc.position) as constraint_columns
            from user_constraints c
            join user_cons_columns cc on (c.constraint_name = cc.constraint_name)
            where c.table_name = table_rec.table_name
            and c.constraint_type = 'U'
            group by c.constraint_name
        ) loop
            l_constraint_count := l_constraint_count + 1;
            dbms_lob.append(l_html_clob, '<tr>');
            dbms_lob.append(l_html_clob, '<td class="col-name">' || cons_rec.constraint_name || '</td>');
            dbms_lob.append(l_html_clob, '<td><span class="uk-badge">UNIQUE</span></td>');
            dbms_lob.append(l_html_clob, '<td class="col-name">' || cons_rec.constraint_columns || '</td>');
            dbms_lob.append(l_html_clob, '<td>Unique constraint</td>');
            dbms_lob.append(l_html_clob, '</tr>');
        end loop;
        
        -- Check Constraints (simplified - no search condition due to LONG data type issues)
        for cons_rec in (
            select 
                c.constraint_name,
                listagg(cc.column_name, ', ') within group (order by cc.position) as constraint_columns
            from user_constraints c
            join user_cons_columns cc on (c.constraint_name = cc.constraint_name)
            where c.table_name = table_rec.table_name
            and c.constraint_type = 'C'
            and c.constraint_name not like 'SYS_%'
            group by c.constraint_name
        ) loop
            l_constraint_count := l_constraint_count + 1;
            dbms_lob.append(l_html_clob, '<tr>');
            dbms_lob.append(l_html_clob, '<td class="col-name">' || cons_rec.constraint_name || '</td>');
            dbms_lob.append(l_html_clob, '<td><span class="ck-badge">CHECK</span></td>');
            dbms_lob.append(l_html_clob, '<td class="col-name">' || cons_rec.constraint_columns || '</td>');
            dbms_lob.append(l_html_clob, '<td>Check constraint</td>');
            dbms_lob.append(l_html_clob, '</tr>');
        end loop;
        
        dbms_lob.append(l_html_clob, '</tbody>');
        dbms_lob.append(l_html_clob, '</table>');
        
        -- Relationships Section (Tables that reference this table)
        dbms_lob.append(l_html_clob, '<h3>Referenced By (Incoming Relationships)</h3>');
        dbms_lob.append(l_html_clob, '<table class="doc-table">');
        dbms_lob.append(l_html_clob, '<thead>');
        dbms_lob.append(l_html_clob, '<tr>');
        dbms_lob.append(l_html_clob, '<th>Child Table</th>');
        dbms_lob.append(l_html_clob, '<th>Child Columns</th>');
        dbms_lob.append(l_html_clob, '<th>Parent Columns</th>');
        dbms_lob.append(l_html_clob, '<th>Constraint Name</th>');
        dbms_lob.append(l_html_clob, '</tr>');
        dbms_lob.append(l_html_clob, '</thead>');
        dbms_lob.append(l_html_clob, '<tbody>');
        
        l_relationship_count := 0;
        -- Find tables that reference this table
        for rel_rec in (
            select 
                c.table_name as child_table,
                listagg(cc.column_name, ', ') within group (order by cc.position) as child_columns,
                listagg(rc.column_name, ', ') within group (order by rc.position) as parent_columns,
                c.constraint_name
            from user_constraints c
            join user_cons_columns cc on (c.constraint_name = cc.constraint_name)
            join user_constraints r on (c.r_constraint_name = r.constraint_name)
            join user_cons_columns rc on (r.constraint_name = rc.constraint_name and cc.position = rc.position)
            where r.table_name = table_rec.table_name
            and c.constraint_type = 'R'
            group by c.table_name, c.constraint_name
            order by c.table_name
        ) loop
            l_relationship_count := l_relationship_count + 1;
            dbms_lob.append(l_html_clob, '<tr>');
            dbms_lob.append(l_html_clob, '<td class="col-name">' || rel_rec.child_table || '</td>');
            dbms_lob.append(l_html_clob, '<td class="col-name">' || rel_rec.child_columns || '</td>');
            dbms_lob.append(l_html_clob, '<td class="col-name">' || rel_rec.parent_columns || '</td>');
            dbms_lob.append(l_html_clob, '<td>' || rel_rec.constraint_name || '</td>');
            dbms_lob.append(l_html_clob, '</tr>');
        end loop;
        
        -- If no relationships, show message
        if l_relationship_count = 0 then
            dbms_lob.append(l_html_clob, '<tr><td colspan="4"><em>No tables reference this table</em></td></tr>');
        end if;
        
        dbms_lob.append(l_html_clob, '</tbody>');
        dbms_lob.append(l_html_clob, '</table>');
        
        dbms_lob.append(l_html_clob, '<hr style="margin: 30px 0; border: none; height: 2px; background: linear-gradient(90deg, #bb0a31, #e74c3c, #c0392b);">');
        
    end loop;
    
    -- Summary
    dbms_lob.append(l_html_clob, '<h2>Summary</h2>');
    dbms_lob.append(l_html_clob, '<p class="summary"><strong>Total tables documented: ' || l_table_count || '</strong></p>');
    dbms_lob.append(l_html_clob, '<p class="summary"><strong>Total constraints: ' || l_constraint_count || '</strong></p>');
    
    -- Return pure HTML (no markdown conversion)
    return l_html_clob;
    
exception
    when others then
        return '<p>Error: ' || sqlerrm || '</p>';
end;
/