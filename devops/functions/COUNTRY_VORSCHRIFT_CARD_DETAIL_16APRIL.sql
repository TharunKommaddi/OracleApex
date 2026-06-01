--
-- Function "COUNTRY_VORSCHRIFT_CARD_DETAIL_16APRIL"
--
CREATE OR REPLACE EDITIONABLE FUNCTION "WKSP_THARUN"."COUNTRY_VORSCHRIFT_CARD_DETAIL_16APRIL" (
    p_search_id number, 
    p_milestone number, 
    P_LANDID VARCHAR2,
    p_format IN VARCHAR2 DEFAULT 'DISPLAY' 
) RETURN CLOB
AS
    l_body_html_table CLOB;
    l_row_num NUMBER := 0;
BEGIN

    IF p_format = 'DISPLAY' THEN
        l_body_html_table := '';
                        
        FOR i IN (
            WITH search_countries AS (
                SELECT 
                    sucheid,
                    to_number(COLUMN_VALUE) as landid
                FROM t_suche_json,
                TABLE(apex_string.split(
                    json_value(suchdaten FORMAT JSON, '$[0].LAENDER'),
                    ':'
                ))
                WHERE sucheid = p_search_id
            )
            SELECT DISTINCT
                ms.vorschriftnummer AS r
            FROM search_countries sc
            LEFT JOIN T_MS_SUCHERGEBNISS ms ON (
                ms.sucheid = sc.sucheid 
                AND ms.landid = sc.landid
                AND sc.landid IN (
                    SELECT column_value 
                    FROM table(apex_string.split_numbers(P_LANDID, ':'))
                )
            )
            WHERE vorschriftnummer IS NOT NULL 
            AND ms.MEILENSTEIN = p_milestone
            ORDER BY r
        ) LOOP
            l_row_num := l_row_num + 1;
            l_body_html_table := l_body_html_table || 
                '<tr>' ||
                '<td class="t-Report-cell" headers="VORSCHRIFT" style="padding: 8px 12px; height: 32px; text-align: center;' ||
                CASE 
                    WHEN MOD(l_row_num, 2) = 1 THEN ' background-color: #E0E0E0;'
                    ELSE ''
                END || '">' || 
                i.r || 
                '</td></tr>';
        END LOOP;
        
        RETURN l_body_html_table;
        
    ELSIF p_format = 'EXCEL' THEN
        RETURN q'[
            WITH search_countries AS (
                SELECT 
                    sucheid,
                    to_number(COLUMN_VALUE) as landid
                FROM t_suche_json,
                TABLE(apex_string.split(
                    json_value(suchdaten FORMAT JSON, '$[0].LAENDER'),
                    ':'
                ))
                WHERE sucheid = ]' || p_search_id || q'[
            )
            SELECT DISTINCT
                ms.landnummer||' - '||ms.landbezeichnung AS Landbezeichnung,
                ms.vorschriftnummer as Vorschriftennummer
            FROM search_countries sc
            JOIN T_MS_SUCHERGEBNISS ms ON (
                ms.sucheid = sc.sucheid 
                AND ms.landid = sc.landid
                AND ms.meilenstein = ]' || p_milestone || q'[
                AND ms.landid IN (
                    SELECT TO_NUMBER(COLUMN_VALUE)
                    FROM TABLE(apex_string.split(']' || P_LANDID || q'[', ':'))
                )
            )
            ORDER BY 
                Landbezeichnung,
                Vorschriftennummer]';
    END IF;
END;
/