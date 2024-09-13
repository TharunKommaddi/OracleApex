


```sql
-- Inline CSS - Format 1
/*START - Historie Tooltip*/

.a-GV-tooltip.ui-tooltip {
    max-width: inherit;
    overflow: initial;  
    background-color: white;
    padding: 1px;
}

div.tooltipHistorie {
    margin: 0px;
    padding: 1px;
    /* padding-right: 5px; */
}
div.tooltipHistorie div {
    margin: 5px;
}
.tooltipHistorie table {
    background-color: grey;
    margin: 5px;
    border-collapse: collapse;
    border: 1px solid black;
}
.tooltipHistorie td, .tooltipHistorie th {
    background-color: white;
    padding: 4px;
    white-space: pre-wrap;
    border: 1px solid black;
    
}

.tooltipHistorie th {
    background-color: #f2f2f2;
}

/*END - Historie Tooltip*/
```



```sql

-- Inline CSS - Format 2

/*Beginn - Historie Tooltip*/

.a-GV-tooltip.ui-tooltip {
    max-width: inherit;
    overflow: initial;  
    background-color: white;
    padding: 1px;
    color:black;
}

div.tooltipHistorie {
    margin: 0px;
    padding: 1px;
    

}
div.tooltipHistorie div {
    margin: 5px;
}
.tooltipHistorie table {
    background-color: grey;
    margin: 5px;
    
 
}
.tooltipHistorie td, .tooltipHistorie th {
    background-color: white;
    padding: 4px;
    white-space: pre-wrap;
    color:black;

    
}

.tooltipHistorie th {
    background-color: #f2f2f2;
}

/*Ende - Historie Tooltip*/


```

## Tooltip 1

```sql
declare
    lcount number;
begin
    select count(*) into lcount
    from t_h_ds
    where ds_id = apex_application.g_x01;

    if lcount > 0 then

        
        -- Generate HTML content
    htp.p('<div class="tooltipHistorie">');
    htp.p('<table>');
        htp.p('<tr>
        <th>Letzte Änderung Benutzer</th>
        <th>Letzte Änderung Datum</th>
        </tr>');

        for e in (
            select ds_id,
            /*
            DECODE(TRIM(UPPER(h.MARKER)),
            10, '-',
            20, 'Info',
            30, 'Wichtig',
            40, 'Erledigt',
            50, 'Kritisch',
            60, 'To-Do',
            h.MARKER) AS MARKER,
            */
            
            nvl2(h.letzte_aenderung_benutzer_id, b.nachname || ' ' || b.vorname || ' (' || b.abteilung || ')', '-') as letzte_aenderung_benutzer,
            nvl2(h.letzte_aenderung_datum, to_char(h.letzte_aenderung_datum, 'dd.mm.yyyy, hh24:mi:ss'), '-') as letzte_aenderung_datum
            from t_h_ds h
            left outer join t_benutzer b on (b.benutzer_id = h.letzte_aenderung_benutzer_id)
            where h.ds_id = apex_application.g_x01
            order by H_DS_ID desc 
            fetch first 1 rows only         
        ) loop
            htp.p('<tr>
            <td>' || e.letzte_aenderung_benutzer || '</td>
            <td>' || e.letzte_aenderung_datum || '</td></tr>');
        end loop;

        htp.p('</table>');
        htp.p('</div>');
    end if;
end;

```

## Tooltip 2

```sql



BEGIN
    
        -- Generate HTML content
    htp.p('<div class="tooltipHistorie">');
    htp.p('<table>');

    -- Table header
    htp.p('
        <tr>
           <th>Projektbezeichnung</th>
           <th>SOP</th>
           <th>EA/PP Splittungen</th>
           <th>Paket Nr.</th>
           <th>Freigabepaket</th>
           <th>Freigabe Status ET-C</th>
        </tr>'
    );

for i in (      
        SELECT 
            -- t.ds_id as DS_id,
            kpb.kpb as Projektbezeichnung,
            case when nvl2(t.sop_jahrkw, substr(t.sop_jahrkw,1,4) || '/' || substr(t.sop_jahrkw,5,2),null)= '9999/99' 
                            then null 
                            else nvl2(t.sop_jahrkw, substr(t.sop_jahrkw,1,4) || '/' || substr(t.sop_jahrkw,5,2),null) 
                            end SOP,
            eapp.ea_pp||
            TRIM(REGEXP_SUBSTR(t.EA_PP_SPLITTUNGEN, '[^,]+', 1, LEVEL)) AS EA_PP_Splittungen,
            f.paket_nr as Paket_Nr,
            f.freigabepaket as Freigabepaket,
            fsetc.freigabe_status_text_lang as Freigabe_Status_ET_C
            
            


        FROM 
            t_ds t
            left outer join t_kpb kpb on (kpb.kpb_id = t.kpb_id)
            left outer join t_freigabepaket f on (f.freigabepaket_id = t.freigabepaket_id)
            left outer join t_freigabe_status_et_c2 fsetc on (fsetc.freigabe_status_et_c2_id = t.freigabe_status_et_c2_id)
            left outer join t_ea_pp eapp on (eapp.ea_pp_id = t.ea_pp_id)
        WHERE 
            t.ds_id = apex_application.g_x01
        CONNECT BY 
            PRIOR t.ds_id = t.ds_id
            AND PRIOR SYS_GUID() IS NOT NULL
            AND LEVEL <= LENGTH(REGEXP_REPLACE(t.EA_PP_SPLITTUNGEN, '[^,]+')) + 1

        ORDER BY 
            t.ds_id, LEVEL)loop

        htp.p(
        '<tr>
        
        <td style="border: 1px solid black; padding: 5px;">' || i.Projektbezeichnung || '</td>
        <td style="border: 1px solid black; padding: 5px;">' || i.SOP || '</td>
        <td style="border: 1px solid black; padding: 5px;">' || i.EA_PP_Splittungen || '</td>
        <td style="border: 1px solid black; padding: 5px;">' || i.Paket_Nr || '</td>
        <td style="border: 1px solid black; padding: 5px;">' || i.Freigabepaket || '</td>
        <td style="border: 1px solid black; padding: 5px;">' || i.Freigabe_Status_ET_C || '</td>
        </tr>'
        );
        
end loop;

EXCEPTION
            WHEN NO_DATA_FOUND THEN
                htp.p('<tr><td colspan="6" style="border: 1px solid black; padding: 5px;">No data found</td></tr>');


        htp.p('</table>');
        htp.p('</div>');


    
END;

```


## Tooltip 3

```sql
DECLARE
    v_data_exists BOOLEAN := FALSE;
    -- v_css CLOB;
    v_html CLOB;
    v_count NUMBER;
BEGIN
    -- Check if data exists
    SELECT 
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM T_DS_ET_C_PROJEKTSTEUERUNG tdecp
                JOIN t_ds tds ON tds.ds_id = tdecp.DS_ID
                WHERE tds.ds_id = apex_application.g_x01
            ) 
            THEN 1 
            ELSE 0 
        END
    INTO v_count
    FROM DUAL;

    v_data_exists := (v_count = 1);
/*
    -- Define CSS
  v_css := q'[
        <style>
            .a-GV-tooltip.ui-tooltip {
    max-width: inherit;
    overflow: initial;  
    background-color: white;
    padding: 1px;
}

div.tooltipHistorie {
    margin: 0px;
    padding: 1px;
}
div.tooltipHistorie div {
    margin: 5px;
}
.tooltipHistorie table {
    background-color: grey;
    margin: 5px;
    border-collapse: collapse;
    border: 1px solid black;
}
.tooltipHistorie td, .tooltipHistorie th {
    background-color: white;
    padding: 4px;
    white-space: pre-wrap;
    border: 1px solid black;
    
}

.tooltipHistorie th {
    background-color: #f2f2f2;
}
        </style>
    ]';
*/
    -- Generate HTML content
    IF v_data_exists THEN
        v_html := '<div class="tooltipHistorie"><table>';
        v_html := v_html || '<tr>
            <th>Erstelldatum</th>
            <th>Ersteller</th>
            <th>Kommentar ET-C Projektsteuerung</th>
            <th>Änderungsdatum</th>
            <th>Änderung durch</th>
        </tr>';

        FOR rec IN (
            SELECT 
                TO_CHAR(tdecp.ERSTELL_DATUM, 'DD.MM.YYYY - HH24:MI:SS') AS ERSTELL_DATUM,
                NVL2(tdecp.ERSTELL_BENUTZER_ID, b.nachname || ', ' || b.vorname || ' (' || b.abteilung || ')', '-') AS ERSTELL_BENUTZER,
                tdecp.ET_C_PROJEKTSTEUERUNG,
                -- TO_CHAR(tdecp.LETZTE_AENDERUNG_DATUM, 'DD.MM.YYYY - HH24:MI:SS') AS LETZTE_AENDERUNG_DATUM,
                NVL2(tdecp.LETZTE_AENDERUNG_DATUM, TO_CHAR(tdecp.LETZTE_AENDERUNG_DATUM, 'DD.MM.YYYY, HH24:MI:SS'), '-') AS LETZTE_AENDERUNG_DATUM,
                NVL2(tdecp.LETZTE_AENDERUNG_BENUTZER_ID, b1.nachname || ', ' || b1.vorname || ' (' || b1.abteilung || ')', '-') AS LETZTE_AENDERUNG_BENUTZER
            FROM T_DS_ET_C_PROJEKTSTEUERUNG tdecp
            JOIN t_ds tds ON tds.ds_id = tdecp.DS_ID
            LEFT JOIN T_BENUTZER b ON b.Benutzer_id = tdecp.ERSTELL_BENUTZER_ID
            LEFT JOIN T_BENUTZER b1 ON b1.Benutzer_id = tdecp.LETZTE_AENDERUNG_BENUTZER_ID
            WHERE tds.ds_id = apex_application.g_x01
            ORDER BY tdecp.ERSTELL_DATUM DESC
            FETCH FIRST 10 ROWS ONLY
        ) LOOP
            v_html := v_html || '<tr>' ||
                '<td>' || rec.ERSTELL_DATUM || '</td>' ||
                '<td>' || rec.ERSTELL_BENUTZER || '</td>' ||
                '<td>' || rec.ET_C_PROJEKTSTEUERUNG || '</td>' ||
                '<td>' || rec.LETZTE_AENDERUNG_DATUM || '</td>' ||
                '<td>' || rec.LETZTE_AENDERUNG_BENUTZER || '</td>' ||
                '</tr>';
        END LOOP;

        v_html := v_html || '</table></div>';
    ELSE
        v_html := '<div class="tooltipHistorie"><p>Keine Daten gefunden</p></div>';
    END IF;

    -- Output CSS and HTML
    -- htp.p(v_css);
    htp.p(v_html);
END;
```



## Tooltip 4

```sql
DECLARE
    v_data_exists BOOLEAN := FALSE;
    -- v_css CLOB;
    v_html CLOB;
    v_count NUMBER;
BEGIN
    -- Check if data exists
    SELECT 
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM T_DS_ET_C_FREIGABESTEUERUNG tdecf
                JOIN t_ds tds ON tds.ds_id = tdecf.DS_ID
                WHERE tds.ds_id = apex_application.g_x01
            ) 
            THEN 1 
            ELSE 0 
        END
    INTO v_count
    FROM DUAL;

    v_data_exists := (v_count = 1);
/*
    -- Define CSS
    v_css := q'[
        <style>
            .a-GV-tooltip.ui-tooltip {
    max-width: inherit;
    overflow: initial;  
    background-color: white;
    padding: 1px;
}

div.tooltipHistorie {
    margin: 0px;
    padding: 1px;
}
div.tooltipHistorie div {
    margin: 5px;
}
.tooltipHistorie table {
    background-color: grey;
    margin: 5px;
    border-collapse: collapse;
    border: 1px solid black;
}
.tooltipHistorie td, .tooltipHistorie th {
    background-color: white;
    padding: 4px;
    white-space: pre-wrap;
    border: 1px solid black;
    
}

.tooltipHistorie th {
    background-color: #f2f2f2;
}
        </style>
    ]';
*/
    -- Generate HTML content
    IF v_data_exists THEN
        v_html := '<div class="tooltipHistorie"><table>';
        v_html := v_html || '<tr>
            <th>Erstelldatum</th>
            <th>Ersteller</th>
            <th>Kommentar ET-C Freigabesteuerung</th>
            <th>Änderungsdatum</th>
            <th>Änderung durch</th>
        </tr>';

        FOR rec IN (
            SELECT 
                TO_CHAR(tdecf.ERSTELL_DATUM, 'DD.MM.YYYY - HH24:MI:SS') AS ERSTELL_DATUM,
                NVL2(tdecf.ERSTELL_BENUTZER_ID, b.nachname || ', ' || b.vorname || ' (' || b.abteilung || ')', '-') AS ERSTELL_BENUTZER,
                tdecf.ET_C_FREIGABESTEUERUNG,
                -- TO_CHAR(tdecf.LETZTE_AENDERUNG_DATUM, 'DD.MM.YYYY - HH24:MI:SS') AS LETZTE_AENDERUNG_DATUM,
                NVL2(tdecf.LETZTE_AENDERUNG_DATUM, TO_CHAR(tdecf.LETZTE_AENDERUNG_DATUM, 'DD.MM.YYYY, HH24:MI:SS'), '-') AS LETZTE_AENDERUNG_DATUM,
                NVL2(tdecf.LETZTE_AENDERUNG_BENUTZER_ID, b1.nachname || ', ' || b1.vorname || ' (' || b1.abteilung || ')', '-') AS LETZTE_AENDERUNG_BENUTZER
            FROM T_DS_ET_C_FREIGABESTEUERUNG tdecf
            JOIN t_ds tds ON tds.ds_id = tdecf.DS_ID
            LEFT JOIN T_BENUTZER b ON b.Benutzer_id = tdecf.ERSTELL_BENUTZER_ID
            LEFT JOIN T_BENUTZER b1 ON b1.Benutzer_id = tdecf.LETZTE_AENDERUNG_BENUTZER_ID
            WHERE tds.ds_id = apex_application.g_x01
            ORDER BY tdecf.ERSTELL_DATUM DESC
            FETCH FIRST 10 ROWS ONLY
        ) LOOP
            v_html := v_html || '<tr>' ||
                '<td>' || rec.ERSTELL_DATUM || '</td>' ||
                '<td>' || rec.ERSTELL_BENUTZER || '</td>' ||
                '<td>' || rec.ET_C_FREIGABESTEUERUNG || '</td>' ||
                '<td>' || rec.LETZTE_AENDERUNG_DATUM || '</td>' ||
                '<td>' || rec.LETZTE_AENDERUNG_BENUTZER || '</td>' ||
                '</tr>';
        END LOOP;

        v_html := v_html || '</table></div>';
    ELSE
        v_html := '<div class="tooltipHistorie"><p>Keine Daten gefunden</p></div>';
    END IF;

    -- Output CSS and HTML
    -- htp.p(v_css);
    htp.p(v_html);
END;
```


## Tooltip 5

```sql
DECLARE
    v_html CLOB;
    v_count NUMBER := 0; -- Initialize v_count to zero

BEGIN
    -- Generate HTML content
    v_html := '<div class="tooltipHistorie"><table>';
    v_html := v_html || '<tr>
        <th>Letzte Änderung</th>
        <th>Benutzer</th>
    </tr>';

    -- Execute the query and populate the table
    FOR rec IN (
        SELECT 
            TO_CHAR(tdroe.LETZTE_AENDERUNG_DATUM, 'dd.mm.yyyy, hh24:mi:ss') AS LETZTE_AENDERUNG_DATUM,
            tb.vorname || ' ' || tb.nachname || ' (' || tb.abteilung || ')' AS BENUTZER
        FROM t_ds td
        CROSS JOIN t_organisationseinheit toe
        LEFT OUTER JOIN t_ds_ref_oe tdroe ON (td.ds_id = tdroe.ds_id AND toe.oe_id = tdroe.oe_id AND tdroe.typ = 1)
        LEFT OUTER JOIN t_benutzer tb ON (tb.benutzer_id = tdroe.letzte_aenderung_benutzer_id)
        WHERE td.ds_id = apex_application.g_x01 
          AND tdroe.LETZTE_AENDERUNG_DATUM IS NOT NULL
        ORDER BY tdroe.LETZTE_AENDERUNG_DATUM DESC
        FETCH FIRST 1 ROWS ONLY
    ) LOOP
        v_html := v_html || '<tr>' ||
            '<td>' || NVL(rec.LETZTE_AENDERUNG_DATUM, '-') || '</td>' ||
            '<td>' || NVL(rec.BENUTZER, '-') || '</td>' ||
            '</tr>';
        v_count := v_count + 1;
    END LOOP;

    -- Check if no data was found
    IF v_count = 0 THEN
        v_html := '<div class="tooltipHistorie"><p>Keine Daten gefunden</p></div>';
    ELSE
        -- Close the table only if data was found
        v_html := v_html || '</table>';
    END IF;

    -- Close the div
    v_html := v_html || '</div>';

    -- Output HTML
    htp.p(v_html);
END;
```

## Tooltip 6

```sql
DECLARE
    v_html CLOB;
    v_count NUMBER := 0; -- Initialize v_count to zero

BEGIN
    -- Generate HTML content
    v_html := '<div class="tooltipHistorie"><table>';
    v_html := v_html || '<tr>
        <th>Letzte Änderung</th>
        <th>Benutzer</th>
    </tr>';

    -- Execute the query and populate the table
    FOR rec IN (
        SELECT 
            TO_CHAR(tdroe.LETZTE_AENDERUNG_DATUM, 'dd.mm.yyyy, hh24:mi:ss') AS LETZTE_AENDERUNG_DATUM,
            tb.vorname || ' ' || tb.nachname || ' (' || tb.abteilung || ')' AS BENUTZER
        FROM t_ds td
        CROSS JOIN t_organisationseinheit toe
        LEFT OUTER JOIN t_ds_ref_oe tdroe ON (td.ds_id = tdroe.ds_id AND toe.oe_id = tdroe.oe_id AND tdroe.typ = 2)
        LEFT OUTER JOIN t_benutzer tb ON (tb.benutzer_id = tdroe.letzte_aenderung_benutzer_id)
        WHERE td.ds_id = apex_application.g_x01 
          AND tdroe.LETZTE_AENDERUNG_DATUM IS NOT NULL
        ORDER BY tdroe.LETZTE_AENDERUNG_DATUM DESC
        FETCH FIRST 1 ROWS ONLY
    ) LOOP
        v_html := v_html || '<tr>' ||
            '<td>' || NVL(rec.LETZTE_AENDERUNG_DATUM, '-') || '</td>' ||
            '<td>' || NVL(rec.BENUTZER, '-') || '</td>' ||
            '</tr>';
        v_count := v_count + 1;
    END LOOP;

    -- Check if no data was found
    IF v_count = 0 THEN
        v_html := '<div class="tooltipHistorie"><p>Keine Daten gefunden</p></div>';
    ELSE
        -- Close the table only if data was found
        v_html := v_html || '</table>';
    END IF;

    -- Close the div
    v_html := v_html || '</div>';

    -- Output HTML
    htp.p(v_html);
END;
```

## Tooltip 7

```sql
DECLARE
    v_html CLOB;
    v_count NUMBER := 0; -- Initialize v_count to zero

BEGIN
    -- Generate HTML content
    v_html := '<div class="tooltipHistorie"><table>';
    v_html := v_html || '<tr>
        <th>ET-A Planung</th>
        <th>Subtasks</th>
        <th>Betroffene Maerkte</th>
        <th>Status Zuordnung</th>
    </tr>';

    -- Execute the query and populate the table
    FOR rec IN (
        WITH cte_m AS (
            SELECT p3p_ticket_id, 
                   LISTAGG(DISTINCT markt, ', ') WITHIN GROUP (ORDER BY markt) maerkte
            FROM t_p3p_ticket_markt
            GROUP BY p3p_ticket_id
        ), cte_sub1 AS (
            SELECT parent_ticket_id, 
                   LISTAGG(t.issuekey || ' (' || maerkte || ')<br>') WITHIN GROUP (ORDER BY issuekey) subtasks
            FROM t_p3p_ticket t
            LEFT OUTER JOIN cte_m m ON (t.p3p_ticket_id = m.p3p_ticket_id)
            WHERE parent_ticket_id IS NOT NULL 
              AND issuetype = 'Sub-Task' 
            GROUP BY parent_ticket_id
        )
        SELECT 
            ds.ET_A_PLANUNG,
            s1.subtasks,
            k.kpb || ' + ' || m.maerkte AS BETROFFENE_MAERKTE,
            CASE
                WHEN drp.status_zuordnung = 10 THEN 'Vorschlag'
                WHEN drp.status_zuordnung = 20 THEN 'Relevant P3'
                WHEN drp.status_zuordnung = 30 THEN 'Nicht relevant'
            END AS status_zuordnung
        FROM t_ds_ref_p3p_ticket drp
        JOIN t_ds ds ON (drp.ds_id = ds.ds_id)
        JOIN t_kpb k ON (ds.kpb_id = k.kpb_id)
        JOIN t_ea_pp ea ON (ds.ea_pp_id = ea.ea_pp_id)
        JOIN t_p3p_ticket p ON (drp.p3p_ticket_id = p.p3p_ticket_id)
        LEFT OUTER JOIN cte_sub1 s1 ON (p.p3p_ticket_id = s1.parent_ticket_id)
        LEFT OUTER JOIN cte_m m ON (p.p3p_ticket_id = m.p3p_ticket_id)
        WHERE ds.ds_id = apex_application.g_x01
    ) LOOP
        v_html := v_html || '<tr>' ||
            '<td>' || NVL(rec.ET_A_PLANUNG, '-') || '</td>' ||
            '<td>' || NVL(rec.subtasks, '-') || '</td>' ||
            '<td>' || NVL(rec.BETROFFENE_MAERKTE, '-') || '</td>' ||
            '<td>' || NVL(rec.status_zuordnung, '-') || '</td>' ||
            '</tr>';
        v_count := v_count + 1;
    END LOOP;

    -- Check if no data was found
    IF v_count = 0 THEN
        v_html := '<div class="tooltipHistorie"><p>Keine Daten gefunden</p></div>';
    ELSE
        -- Close the table only if data was found
        v_html := v_html || '</table>';
    END IF;

    -- Close the div
    v_html := v_html || '</div>';

    -- Output HTML
    htp.p(v_html);
END;

```


## Tooltip 8

```sql
DECLARE
    v_data_exists BOOLEAN := FALSE;
    v_html CLOB;
    v_count NUMBER;

BEGIN
    -- Check if data exists
    SELECT
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM t_ds tds
                WHERE tds.ds_id = apex_application.g_x01
            )
            THEN 1
            ELSE 0
        END
    INTO v_count
    FROM DUAL;

    v_data_exists := (v_count = 1);

    -- Generate HTML content
    IF v_data_exists THEN
        v_html := '<div class="tooltipHistorie"><table>';
        v_html := v_html || '<tr>
           
            <th>ET-A Planung</th>
            <th>Subtasks</th>
            <th>Betroffene Maerkte</th>
            <th>Status Zuordnung</th>
            
        </tr>';

        FOR rec IN (
            /*select td.ds_id, td.ET_A_PLANUNG  
                from t_ds td
                left outer join t_ds_ref_p3p_ticket tdrpt on td.ds_id = tdrpt.ds_id
                left outer join t_p3p_ticket tpt on tdrpt.P3P_TICKET_ID = tpt.P3P_TICKET_ID
                left outer join t_p3p_ticket_markt tptm on tpt.P3P_TICKET_ID = tptm.P3P_TICKET_ID
                where td.ds_id = apex_application.g_x01*/

               with cte_m as (
                    select p3p_ticket_id, 
                           listagg(distinct markt,', ') within group (order by markt) maerkte
                    from t_p3p_ticket_markt
                    group by p3p_ticket_id
                ), cte_sub1 as (
                    select parent_ticket_id, 
                           listagg( t.issuekey ||  ' (' || maerkte || ')<br>' ) within group (order by issuekey) subtasks
                    from t_p3p_ticket t
                    left outer join cte_m m on (t.p3p_ticket_id = m.p3p_ticket_id)
                    where parent_ticket_id is not null 
                      and issuetype = 'Sub-Task' 
                    group by parent_ticket_id
                )

                select 
                    -- ds.ds_id,
                    -- drp.DS_REF_P3P_TICKET_ID,
                    ds. ET_A_PLANUNG,
                    -- '<a class="jiralink" href="https://cicd.cloud.audi/jira/browse/' || p.issuekey || '" target="_blank">' || p.issuekey || '</a>' as issuekey,
                    s1.subtasks,
                    
                    k.kpb || ' + ' || m.maerkte as BETROFFENE_MAERKTE,
                    
                   
                    CASE
                        WHEN drp.status_zuordnung = 10 THEN 'Vorschlag'
                        WHEN drp.status_zuordnung = 20 THEN 'Relevant P3'
                        WHEN drp.status_zuordnung = 30 THEN 'Nicht relevanz'
                    END AS status_zuordnung
                    
                from t_ds_ref_p3p_ticket drp
                join t_ds ds on (drp.ds_id = ds.ds_id)
                join t_kpb k on (ds.kpb_id = k.kpb_id)
                join t_ea_pp ea on (ds.ea_pp_id = ea.ea_pp_id)
                join t_p3p_ticket p on (drp.p3p_ticket_id = p.p3p_ticket_id)
                left outer join cte_sub1 s1 on (p.p3p_ticket_id = s1.parent_ticket_id)
                left outer join cte_m m on (p.p3p_ticket_id = m.p3p_ticket_id)
                -- join apex_string.split_numbers(:P4110_DS_IDS,':') x on (drp.ds_id = x.column_value);
                where ds.ds_id = apex_application.g_x01
        ) LOOP
            v_html := v_html || '<tr>' ||
                
                '<td>' || NVL(rec.ET_A_PLANUNG, '-') || '</td>' ||
                '<td>' || NVL(rec.subtasks, '-') || '</td>' ||
                '<td>' || NVL(rec.BETROFFENE_MAERKTE, '-') || '</td>' ||
                '<td>' || NVL(rec.status_zuordnung, '-') || '</td>' ||
                
                '</tr>';
        END LOOP;

        v_html := v_html || '</table></div>';
    ELSE
        v_html := '<div class="tooltipHistorie"><p>Keine Daten gefunden</p></div>';
    END IF;

    -- Output HTML
    htp.p(v_html);
END;
```



### JS Initialization code in Report Atrributes in Advanced Section
### APPROACH 1
```js


function(config) {
    // Anfang Mouseover
config.defaultGridViewOptions = {
tooltip: {
    // when the tooltip is integrated with the grid view the content callback
    // gets some extra helpful parameters
    content: function(callback, model, recordMeta, colMeta, columnDef ) {
    var text = null;
    if (recordMeta && columnDef && columnDef.property != "APEX$ROW_SELECTOR" && columnDef.property != "APEX$ROW_ACTION" && columnDef.property != "DEL" && !$(this).hasClass( "a-GV-rowHeader" )) {
        switch (columnDef.property) {
                    
    case "ET_A_HF":case "ET_A11_HF":case "ET_A12_HF":case "ET_A21_HF":case "ET_A22_HF":case "ET_A5_HF":case "ET_G_HF":case "ET_G1_HF":case "ET_G2_HF":case "ET_G3_HF":case "ET_G4_HF":case "ET_G5_HF":case "ET_C2_HF":case "ET_C3_HF":
    if (model.getValue(recordMeta.record, columnDef.property + "_HTML") != "") {
        text = model.getValue(recordMeta.record, columnDef.property + "_HTML");
    }
    var promise1 = function(param) {
        return apex.server.process("get_historie_et_hf",
            { x01: model.getValue(recordMeta.record, "DS_ID"),
              x02: columnDef.property
            },
            {
                success: function(pData) {
                    return pData;
                },
                dataType: "text"
            });
    };
    $.when.apply($, [promise1()]).then(function(data) {
        callback(data);
    }).catch(function(error) {
        console.error("Error fetching HF data:", error);
        callback(text);
    });
    break;

    case "ET_A_ET":case "ET_A11_ET":case "ET_A12_ET":case "ET_A21_ET":case "ET_A22_ET":case "ET_A5_ET":case "ET_G_ET":case "ET_G1_ET":case "ET_G2_ET":case "ET_G3_ET":case "ET_G4_ET":case "ET_G5_ET":case "ET_C2_ET":case "ET_C3_ET":
        if (model.getValue(recordMeta.record, columnDef.property + "_HTML") != "") {
            text = model.getValue(recordMeta.record, columnDef.property + "_HTML");
        }
        var promise2 = function(param) {
            return apex.server.process("get_historie_et_et",
                { x01: model.getValue(recordMeta.record, "DS_ID"),
                x02: columnDef.property
                },
                {
                    success: function(pData) {
                        return pData;
                    },
                    dataType: "text"
                });
        };
        $.when.apply($, [promise2()]).then(function(data) {
            callback(data);
        }).catch(function(error) {
            console.error("Error fetching ET data:", error);
            callback(text);
        });
        break;
            
    case "":
        text = model.getValue( recordMeta.record, "" );
        break;
    
    case "MARKER":
        fAJAXTooltip("get_historie_marker", model.getValue( recordMeta.record, "DS_ID"), columnDef.property, callback);    
        break;

    case "EA_PP_SPLITTUNGEN1": -- EA_PP_SPLITTUNGEN1 = column names ; get_historie_ea_pp_splittungen =  process names 
        fAJAXTooltip("get_historie_ea_pp_splittungen", model.getValue( recordMeta.record, "DS_ID"), columnDef.property, callback);    
        break;
    case "ET_C_PROJEKTSTEUERUNG":
        fAJAXTooltip("get_historie_et_c_projektsteuerung", model.getValue( recordMeta.record, "DS_ID"), columnDef.property, callback);    
        break;
    case "ET_C_FREIGABESTEUERUNG":
        fAJAXTooltip("get_historie_et_c_freigabetsteuerung", model.getValue( recordMeta.record, "DS_ID"), columnDef.property, callback);    
        break;
    case "ET_A_PLANUNG_P3P":
        fAJAXTooltip("get_historie_ET_A_PLANUNG_P3P", model.getValue( recordMeta.record, "DS_ID"), columnDef.property, callback);    
        break;

    default:
        text = model.getValue( recordMeta.record, columnDef.property );
        if (typeof text != "string") {
            text = text.d;
}
}
}
return text;
}
}
};
// Ende Mouseover
return config;
}


```

### APPROACH 2 - OPTIMZED


```js
function(config) {
// Mouseover configuration
config.defaultGridViewOptions = {
tooltip: {
content: function(callback, model, recordMeta, colMeta, columnDef) {
if (!recordMeta || !columnDef || 
["APEX$ROW_SELECTOR", "APEX$ROW_ACTION", "DEL"].includes(columnDef.property) || 
$(this).hasClass("a-GV-rowHeader")) {
return null;
}
const property = columnDef.property;
const dsId = model.getValue(recordMeta.record, "DS_ID");
// Helper function for AJAX tooltips
const fAJAXTooltip = (process, x01, x02, callback) => {
apex.server.process(process, { x01, x02 }, {
success: callback,
dataType: "text"
}).catch(error => {
console.error(`Error fetching ${process} data:`, error);
callback("");
});
};
// Group similar cases
const etCases = ["ET_A_HF", "ET_A11_HF", "ET_A12_HF", "ET_A21_HF", "ET_A22_HF", "ET_A5_HF", "ET_G_HF", "ET_G1_HF", "ET_G2_HF", "ET_G3_HF", "ET_G4_HF", "ET_G5_HF", "ET_C2_HF", "ET_C3_HF", "ET_A_ET", "ET_A11_ET", "ET_A12_ET", "ET_A21_ET", "ET_A22_ET", "ET_A5_ET", "ET_G_ET", "ET_G1_ET", "ET_G2_ET", "ET_G3_ET", "ET_G4_ET", "ET_G5_ET", "ET_C2_ET", "ET_C3_ET"];
if (etCases.includes(property)) {
const htmlValue = model.getValue(recordMeta.record, `${property}_HTML`);
const process = property.endsWith("_HF") ? "get_historie_et_hf" : "get_historie_et_et";
fAJAXTooltip(process, dsId, property, data => callback(data || htmlValue));
} else {
switch (property) {
case "MARKER":
    fAJAXTooltip("get_historie_marker", dsId, property, callback);
    break;
case "EA_PP_SPLITTUNGEN1":
    fAJAXTooltip("get_historie_ea_pp_splittungen", dsId, property, callback);
    break;
case "ET_C_PROJEKTSTEUERUNG":
    fAJAXTooltip("get_historie_et_c_projektsteuerung", dsId, property, callback);
    break;
case "ET_C_FREIGABESTEUERUNG":
    fAJAXTooltip("get_historie_et_c_freigabetsteuerung", dsId, property, callback);
    break;
case "P3_TICKETS_VORSCHLAG":
    fAJAXTooltip("get_historie_P3_TICKETS_VORSCHLAG", dsId, property, callback);
    break;
case "P3_TICKETS":
    fAJAXTooltip("get_historie_P3_TICKETS", dsId, property, callback);
    break;
case "BETROFFENE_EIGENSCHAFT_ET_G":
case "BETROFFENE_EIGENSCHAFT_ET_A":
    fAJAXTooltip("get_eigenschaften", dsId, property, callback);
    break;
case "EA_PP":
    fAJAXTooltip("get_ea_pp", dsId, property, callback);
    break;
case "BETROFFENE_MAERKTE_ET_G":
    fAJAXTooltip("Tooltip_BETROFFENE_MAERKTE_ET_G", dsId, property, callback);
    break;
case "BETROFFENE_MAERKTE_ET_A":
    fAJAXTooltip("Tooltip_BETROFFENE_MAERKTE_ET_A", dsId, property, callback);
    break;
case "STATUS_IDEX":
    fAJAXTooltip("Tooltip_STATUS_IDEX", dsId, property, callback);
    break;
case "TRAX_IDS":
    fAJAXTooltip("Tooltip_TRAX_IDS", dsId, property, callback);
    break;
default:
    let text = model.getValue(recordMeta.record, property);
    callback(typeof text !== "string" ? text.d : text);
}
}
}
}
};
return config;
}
```
