--
-- Package_Body "EMANO_REPORT"
--
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."EMANO_REPORT" is
    /*
    Konvertiert einen CLOB in einen BLOB
    */
    function fClobToBlob(aClob CLOB) RETURN BLOB IS
        tgt_blob BLOB;
        amount INTEGER := DBMS_LOB.lobmaxsize;
        dest_offset INTEGER := 1;
        src_offset INTEGER  := 1;
        blob_csid INTEGER := nls_charset_id('UTF8');
        lang_context INTEGER := DBMS_LOB.default_lang_ctx;
        warning INTEGER := 0;
    begin
        if aClob is null then
            return null;
        end if;
        DBMS_LOB.CreateTemporary(tgt_blob, true);
        DBMS_LOB.ConvertToBlob(tgt_blob, aClob, amount, dest_offset, src_offset, blob_csid, lang_context, warning);
        return tgt_blob;
    end fClobToBlob;
    /*
    Parsed den übergebenen Query, bestimmt und speichert also die Datentypen und Spaltennamen
    */
    procedure pInit(aQuery in clob) is
        lCursor number;
        lDescribeTable dbms_sql.desc_tab2;
        begin
            fQuery := aQuery;
            lCursor := DBMS_SQL.OPEN_CURSOR;
            DBMS_SQL.PARSE(lCursor, fQuery, DBMS_SQL.NATIVE);
            DBMS_SQL.DESCRIBE_COLUMNS2(lCursor, fNumberOfColumns, lDescribeTable);
            fColumns.extend(fNumberOfColumns);
            for i in 1..fNumberOfColumns
            loop
                  fColumns(i).fIndex := i;
                  fColumns(i).fName := lDescribeTable(i).col_name;
                  fColumns(i).fDisplayName := replace(lDescribeTable(i).col_name,'&shy;','');
                  fColumns(i).fType :=
                      case lDescribeTable(i).col_type
                          when 2 then cNumberType
                          when 12 then cDateType
                          else cStringType
                      end;
                  fColumns(i).fColumnWidth := -1;
            end loop;
        end pInit;
    /*
    Gibt zurück, um welchen Spaltentyp es sich bei der übergebenen Spalte handelt.
    */
    function fGetColumnType(aColumnIndex in number) return number is
        begin
            return fColumns(aColumnIndex).fType;
        end fGetColumnType;
    /*
    Gibt einen Wert als varchar2 zurück.
    */
    function fGetStringValue(aZeile in number, aSpalte in number) return varchar2 is
        begin
            case fGetColumnType(aSpalte)
                when cDateType then return to_char(fDateResults(aSpalte)(aZeile),'dd.mm.yy HH24:ii');
                when cNumberType then return fNumberResults(aSpalte)(aZeile);
                else return fStringResults(aSpalte)(aZeile);
            end case;
        end fGetStringValue;
    /*
    Gibt einen Wert als Number zurück.
    TODO: Behandlung, wenn es sich nicht um einen Zahlenwert handelt.
    */
    function fGetNumberValue(aZeile in number, aSpalte in number) return number is
        begin
            case fGetColumnType(aSpalte)
                when cNumberType then return fNumberResults(aSpalte)(aZeile);
                else raise runtime_exception;
            end case;
        end fGetNumberValue;
    function fGetDateValue(aZeile in number, aSpalte in number) return date is
        begin
            case fGetColumnType(aSpalte)
                when cDateType then return fDateResults(aSpalte)(aZeile);
                else raise runtime_exception;
            end case;
        end fGetDateValue;
    /*
    Berechnet die maximale Zeichenlänge einer Spalte und wird für die Einstellung der
    Spaltenbreite im Excel-Ausgabeformat verwendet.
    */
    function fGetMaxStringLength(aSpalte in number) return varchar2 is
        lMaxLength number := length(fColumns(aSpalte).fDisplayName);
        begin
            for i in 1..fRowCount
            loop
                lMaxLength := greatest(lMaxLength,nvl(length(fGetStringValue(i,aSpalte)),0));
            end loop;
            return lMaxLength;
        end fGetMaxStringLength;
    /*
    Führt die SQL-Abfrage aus und fetched die Resultate. Sie werden dabei je nach Datentyp in unterschiedliche
    Arrays gespeichert.
    */
    procedure pExecute is
        lCursor number;
        lUnusedResult number;
        begin
            lCursor := DBMS_SQL.OPEN_CURSOR;
            DBMS_SQL.PARSE(lCursor, fQuery, DBMS_SQL.NATIVE);
            lUnusedResult := dbms_sql.execute(lCursor);
            -- Es gibt keine Generics in PLSQL, daher 3 Arrays
            fStringResults.extend(fNumberOfColumns);
            fDateResults.extend(fNumberOfColumns);
            fNumberResults.extend(fNumberOfColumns);
            -- Definieren, dass im Quellcursor für jede Bind-Variable ein Array verwendet wird
            for i in 1..fNumberOfColumns
            loop
                case fGetColumnType(i)
                    when cDateType then dbms_sql.define_array(lCursor, i, fDateResults(i), cFetchLimit, 1);
                    when cNumberType then dbms_sql.define_array(lCursor, i, fNumberResults(i), cFetchLimit, 1);
                    else dbms_sql.define_array(lCursor, i, fStringResults(i), cFetchLimit, 1);
                end case;
            end loop;
            fRowcount := dbms_sql.fetch_rows(lCursor);
            -- Kopieren aus dem Select-Cursor in die Array-Variablen mit den Ergebnissen
            for i in 1..fNumberOfColumns
            loop
                fDateResults(i).delete;
                fStringResults(i).delete;
                case fGetColumnType(i)
                    when cDateType then dbms_sql.column_value(lCursor,i,fDateResults(i));
                    when cNumberType then dbms_sql.column_value(lCursor,i,fNumberResults(i));
                    else dbms_sql.column_value(lCursor,i,fStringResults(i));
                end case;
            end loop;
        end pExecute;
    /*
    Wrapper-Funktion, die die Excel-Generierung in einer SELECT-Abfrage ermöglicht.
    */
    function fWrapperExcel(aSQL in varchar2) return blob is
        begin
            pInit(aSQL);
            pExecute;
            return fMakeExcel;
        end fWrapperExcel;
    /*
    Wrapper-Funktion, die die CSV-Generierung in einer SELECT-Abfrage ermöglicht.
    */
    function fWrapperCSV(aSQL in varchar2) return blob is
        begin
            pInit(aSQL);
            pExecute;
            return fMakeCSV;
        end fWrapperCSV;
    function fReplaceNewLines(aText varchar2) return varchar2 is
        begin
            return regexp_replace(aText, '[' || chr(13) || chr(10) || ']+', ' ');
        end fReplaceNewLines;
    function fEscapeQuotesCsv(aText varchar2) return varchar2 is
        begin
            return replace(fReplaceNewLines(aText), '"', '""');
        end fEscapeQuotesCsv;
    function fQuoteTextCsv(aText varchar2) return varchar2 is
        begin
            -- Seperator, gequoteter Text oder Zeilenumbruch
            if instr(aText, ';') > 0 or instr(aText, '"') > 0 or instr(aText, chr(10)) > 0 then
                return '"' || aText || '"';
            else
                return aText;
            end if;
        end fQuoteTextCsv;
        
     function fWrapperCSV2(aSQL in clob) return blob is

        begin

            pInit(aSQL);
            pExecute;
            return fMakeCSV;

        end fWrapperCSV2;
    /*
    BrNi
    Funktion, die zum Escapen und Quoten fuer den CSV-Text dient.
    */
    function fEscapeAndQuoteCsv(aText varchar2) return varchar2 is
        begin
            return fQuoteTextCsv(fEscapeQuotesCsv(aText));
        end fEscapeAndQuoteCsv;
    /*
    Generiert eine einfache CSV-Datei und gibt diese als BLOB zurück.
    */
    function fMakeCSV return blob is
        lClob clob := '';
        begin
            for lSpalte in 1..fNumberOfColumns
            loop
                lClob := lClob || fEscapeAndQuoteCsv(fColumns(lSpalte).fName);
                if (lSpalte != fNumberOfColumns) then
                    lClob := lClob || ';';
                end if;
            end loop;
            lClob := lClob || utl_tcp.CRLF;
            for lZeile in 1..fRowCount
            loop
                for lSpalte in 1..fNumberOfColumns
                loop
                    lClob := lClob || fEscapeAndQuoteCsv(fGetStringValue(lZeile,lSpalte));
                    if (lSpalte != fNumberOfColumns) then
                        lClob := lClob || ';';
                    end if;
                end loop;
                lClob := lClob || utl_tcp.CRLF;
            end loop;
            return fClobToBlob(UNISTR('\FEFF') || lClob);
        end fMakeCSV;
    /*
    Generiert Rahmen so, dass der Excel-Report einen Medium-Außenrahmen und einen Thin-Innenrahmen hat.
    */
    function fMakeExcelCellBorder (aZeile in number, aSpalte in number) return number is
        lBorder number;
        begin
            lBorder := xlsx_builder_pkg.get_border(
                case when aZeile = 1 then 'medium' else 'thin' end,
                case when aZeile = fRowCount then 'medium' else 'thin' end,
                case when aSpalte = 1 then 'medium' else 'thin' end,
                case when aSpalte = fNumberOfColumns then 'medium' else 'thin' end
            );
            return lBorder;
        end fMakeExcelCellBorder;
    /*
    Zeichnet eine Excel-Zelle. Bereits implementiert ist eine rudimentäre Unterscheidung zwischen
    Zeichenketten- und Zahlen-Werten. Für Datums/Zeit-Angaben muss wahrscheinlich noch eine Behandlung
    hinzugefügt werden.
    */
    procedure pMakeExcelCell(aZeile in number, aSpalte in number, aFontCell in number, aFillColor in Number, aBorder in Number) is
        lCellValue varchar2(2000);
        lFillColor number;
        begin
            case (fGetColumnType(aSpalte))
                when cNumberType then xlsx_builder_pkg.cell(aSpalte + fExcelConfig.fOffsetCols, aZeile + 1 + fExcelConfig.fOffsetRows, fGetNumberValue(aZeile,aSpalte), p_fontId => aFontCell, p_borderId => aBorder, p_fillId => aFillColor);
                when cDateType then xlsx_builder_pkg.cell(aSpalte + fExcelConfig.fOffsetCols, aZeile + 1 + fExcelConfig.fOffsetRows, fGetDateValue(aZeile,aSpalte), p_fontId => aFontCell, p_borderId => aBorder, p_fillId => aFillColor);
                else
                    begin
                        lCellValue := replace(replace(replace(fGetStringValue(aZeile,aSpalte),'<br />',' - '),'<b>',''),'</b>','');
                        lFillColor := aFillColor;
                        xlsx_builder_pkg.cell(aSpalte + fExcelConfig.fOffsetCols, aZeile + 1 + fExcelConfig.fOffsetRows, lCellValue, p_fontId => aFontCell, p_borderId => aBorder, p_fillId => lFillColor);
                    end;
            end case;
        end pMakeExcelCell;
    function fFindSpalte(aSpaltenName in varchar2) return integer is
      lSpaltenIndex integer := -1;
    begin
        for i in 1..fNumberOfColumns loop
            if fColumns(i).fName like aSpaltenName then
               lSpaltenIndex := i;
               exit when true;
            end if;
        end loop;
        return lSpaltenIndex;
    end;
    /*
    Generiert eine Excel-Datei und gibt diese als BLOB zurück.
    */
    function fMakeExcel(aSheetName in varchar2 default null) return blob is
        lFillGray number;
        lNoFill number;
        lFillColor number;
        lFontHeader number;
        lFontCell number;
        lBorderHeader number;
        lSheetNum number;
        lFontTitle number;
        lFontVertraulich number;
        lBorder number;
        lFillCurrent number;
        begin
            xlsx_builder_pkg.clear_workbook;
            lSheetNum := xlsx_builder_pkg.new_sheet(p_sheetname => nvl(aSheetName,'Export'));
            lFillGray := xlsx_builder_pkg.get_fill(p_patternType => 'solid', p_fgRGB => '00D0D0D0');
            lNoFill := xlsx_builder_pkg.get_fill(p_patterntype => 'solid', p_fgRGB => 'FFFFFFFF');
            lFillCurrent := xlsx_builder_pkg.get_fill(p_patternType => 'solid', p_fgRGB => '4242DEFF');
            -- zu den Zahlenwerten bei rgb
            -- das erste ist alpha
            -- dann kommt rot, dann gruen, dann blau
            -- Tabellenköpfe
            lFontHeader := xlsx_builder_pkg.get_font(
                p_name      => 'Audi Type',
                p_fontsize  => 10,
                p_bold      => true
            );
            -- Tabellenzellen
            lFontCell := xlsx_builder_pkg.get_font(
                p_name      => 'Audi Type',
                p_fontsize  => 10,
                p_bold      => false
            );
            -- Vertraulichkeitshinweis
            lFontVertraulich := xlsx_builder_pkg.get_font(
                p_name      => 'Audi Type',
                p_fontsize  => 20,
                p_bold      => true,
                p_rgb       => 'CC0637'
            );
            -- Titel
            lFontTitle := xlsx_builder_pkg.get_font(
                p_name      => 'Audi Type',
                p_fontsize  => 20,
                p_bold      => true
            );
            lBorderHeader := xlsx_builder_pkg.get_border('medium','medium','medium','medium');
            for lSpalte in 1..fNumberOfColumns
            loop
                xlsx_builder_pkg.cell(lSpalte + fExcelConfig.fOffsetCols, 1 + fExcelConfig.fOffsetRows, fColumns(lSpalte).fName, p_fillId => lFillGray, p_fontId => lFontHeader, p_borderId => lBorderHeader );
                if (fColumns(lSpalte).fColumnWidth = -1) then
                    xlsx_builder_pkg.set_column_width(lSpalte + fExcelConfig.fOffsetCols, ceil(fGetMaxStringLength(lSpalte)*1.5));
                end if;
            end loop;
            for lZeile in 1..fRowCount
            loop
                lFillColor := lNoFill;
                for lSpalte in 1..fNumberOfColumns
                loop
                    lBorder := fMakeExcelCellBorder(lZeile, lSpalte);
                    pMakeExcelCell(lZeile, lSpalte, lFontCell, lFillColor, lBorder);
                end loop;
            end loop;
              -- momentan wird durch diese Zelle der Autofilter auch in diese erste Zeile gesetzt
            xlsx_builder_pkg.cell(9, 2, '- vertraulich -', p_fontid => lFontVertraulich);
            xlsx_builder_pkg.cell(2, 2, nvl(aSheetName,'Export'), p_fontid => lFontTitle);
            xlsx_builder_pkg.cell(2, 3, 'Erstellungsdatum');
            xlsx_builder_pkg.cell(3, 3, sysdate);
            if (fExcelConfig.fUseAutoFilter) then
                xlsx_builder_pkg.set_autofilter(1 + fExcelConfig.fOffsetCols, fNumberOfColumns + fExcelConfig.fOffsetCols, p_row_start => 1 + fExcelConfig.fOffsetRows);
            end if;
            if (fExcelConfig.fUseFreezePane) then
                xlsx_builder_pkg.freeze_rows( 1+fExcelConfig.fOffsetRows );
            end if;
            return xlsx_builder_pkg.finish;
        end fMakeExcel;
        
    /*
    Generiert eine Excel-Datei mit mehreren Arbeitsblättern und gibt diese als BLOB zurück.
    */
   /*
    function fMakeExcelMultSheet(aSheetName in apex_t_varchar2, aTitleName in apex_t_varchar2, aQuery in tArrayOfClob, aVertraulich in number default null) return blob is
        lFillGray number;
        lNoFill number;
        lFillColor number;
        lFontHeader number;
        lFontCell number;
        lBorderHeader number;
        lSheetNum number;
        lFontTitle number;
        lFontVertraulich number;
        lBorder number;
        lSheetName varchar2(500);
        lTitleName varchar2(500);
        lQuery clob;
        begin
            xlsx_builder_pkg.clear_workbook;
            
            for i in 1..aQuery.count loop
                lSheetName := aSheetName(i);
                lTitleName := aTitleName(i);
                lQuery := aQuery(i);                
                
                pInit(lQuery);
                pExecute;
                
                lSheetNum := xlsx_builder_pkg.new_sheet(p_sheetname => nvl(lSheetName,'Export'));
                
                lFillGray := xlsx_builder_pkg.get_fill(p_patternType => 'solid', p_fgRGB => '00D0D0D0' );
                lNoFill := xlsx_builder_pkg.get_fill(p_patterntype => 'solid', p_fgRGB => 'FFFFFFFF');
                
                -- zu den Zahlenwerten bei rgb
                -- das erste ist alpha
                -- dann kommt rot, dann gruen, dann blau
                
                -- Tabellenköpfe
                lFontHeader := xlsx_builder_pkg.get_font(
                    p_name      => 'Audi Type',
                    p_fontsize  => 10,
                    p_bold      => true
                );
    
                -- Tabellenzellen
                lFontCell := xlsx_builder_pkg.get_font(
                    p_name      => 'Audi Type',
                    p_fontsize  => 10,
                    p_bold      => false
                );
    
                -- Vertraulichkeitshinweis
                lFontVertraulich := xlsx_builder_pkg.get_font(
                    p_name      => 'Audi Type',
                    p_fontsize  => 20,
                    p_bold      => true,
                    p_rgb       => 'CC0637'
                );
    
                -- Titel
                lFontTitle := xlsx_builder_pkg.get_font(
                    p_name      => 'Audi Type',
                    p_fontsize  => 20,
                    p_bold      => true
                );
                lBorderHeader := xlsx_builder_pkg.get_border('medium','medium','medium','medium');
                
                for lSpalte in 1..fNumberOfColumns
                loop
                    xlsx_builder_pkg.cell(lSpalte + fExcelConfig.fOffsetCols, 1 + fExcelConfig.fOffsetRows, fColumns(lSpalte).fName, p_fillId => lFillGray, p_fontId => lFontHeader, p_borderId => lBorderHeader );
                    if (fColumns(lSpalte).fColumnWidth = -1) then
                        xlsx_builder_pkg.set_column_width(lSpalte + fExcelConfig.fOffsetCols, ceil(fGetMaxStringLength(lSpalte)*1.5));
                    end if;
                end loop;
    
                for lZeile in 1..fRowCount
                loop
                    lFillColor := lNoFill;
    
                    for lSpalte in 1..fNumberOfColumns
                    loop
                        lBorder := fMakeExcelCellBorder(lZeile, lSpalte);
                        pMakeExcelCell(lZeile, lSpalte, lFontCell, lFillColor, lBorder);
                    end loop;
                end loop;
    
                  -- momentan wird durch diese Zelle der Autofilter auch in diese erste Zeile gesetzt
                if aVertraulich = 1 then
                    xlsx_builder_pkg.cell(9, 2, '- vertraulich -', p_fontid => lFontVertraulich);
                end if;
                --xlsx_builder_pkg.cell(2, 2, nvl(lTitleName,'Export'), p_fontid => lFontTitle);
                --xlsx_builder_pkg.cell(2, 3, 'Erstellungsdatum');
                --xlsx_builder_pkg.cell(3, 3, sysdate);
 
 
                xlsx_builder_pkg.cell(15, 1, 'Audi-Standort / Audi-Tochter');
                xlsx_builder_pkg.cell(17, 1, 'Ansprechpartner');
                xlsx_builder_pkg.cell(18, 1, 'Zugeordnete ID');
                xlsx_builder_pkg.cell(19, 1, 'Passwort');
 
                xlsx_builder_pkg.cell(2, 2, nvl(lTitleName,'Export'), p_fontid => lFontTitle);
                --xlsx_builder_pkg.cell(2, 3, 'Erstellungsdatum');
                
                xlsx_builder_pkg.cell(15, 2, 'Audi-Ingolstadt');
                xlsx_builder_pkg.cell(17, 2, 'Christlbauer Herbert, Gerhard Miehling');
                xlsx_builder_pkg.cell(18, 2, 'nUdpywey');
                xlsx_builder_pkg.cell(19, 2, 'Japan_2401');
                xlsx_builder_pkg.cell(2, 3, 'Erstellungsdatum');
                xlsx_builder_pkg.cell(3, 3, sysdate);
    
    
                if (fExcelConfig.fUseAutoFilter) then
                    xlsx_builder_pkg.set_autofilter(1 + fExcelConfig.fOffsetCols, fNumberOfColumns + fExcelConfig.fOffsetCols, p_row_start => 1 + fExcelConfig.fOffsetRows);
                end if;
                if (fExcelConfig.fUseFreezePane) then
                    xlsx_builder_pkg.freeze_rows( 1+fExcelConfig.fOffsetRows );
                end if;
            end loop;    
             
            return xlsx_builder_pkg.finish;    
            
        end fMakeExcelMultSheet;
        
   */  
 /*
       function get_leaf_column RETURN number IS
            l_leaf_value number;
        BEGIN
            -- Fetch the leaf column value from the v_thema_baum table
            SELECT leaf INTO l_leaf_value FROM v_thema_baum;
            RETURN l_leaf_value;
        END get_leaf_column;
*/
 
 
 /*
 
-- Single
       
       function fMakeExcelsingleSheet(aSheetName in varchar2, aTitleName in varchar2, aQuery in clob, aVertraulich in number default null) return blob is
        lFillGray number;
        lNoFill number;
        lFillColor number;
        lFontHeader number;
        lFontCell number;
        lBorderHeader number;
        lBorderHeaderLight number;
        lSheetNum number;
        lFontTitle number;
        lFontVertraulich number;
        lBorder number;
        lSheetName varchar2(500);
        lTitleName varchar2(500);
        lFillPaleGreen number;
        lFillPaleBlue number;
        lFontCurrent number;
        lBold number;
        lAlignment  xlsx_builder_pkg.t_alignment_rec;
        lCurrentLocalRegColumnIndex number;
        lCurrentCorrectionColumnIndex number;
        lCurrentCommentsColumnIndex number;
        lFutureLocalRegColumnIndex number;
        lFutureEnactDateColumnIndex number;
        lFutureImpDateNewTypeColumnIndex number;
        lFutureImpDateAllVehiclesColumnIndex number;
        lFutureCorrectionColumnIndex number;
        lFutureCommentsColumnIndex number;
        lTopicIdColumnIndex number;
        lTopicColumnIndex number;
        lleafColumnIndex number;
        lTopicDescriptionColumnIndex number;
       
        
        begin
 
                
                
                xlsx_builder_pkg.clear_workbook;
            
          --  for i in 1..aQuery.count loop
                lSheetName := aSheetName;
                lTitleName := aTitleName;
                                
                -- debug('test Excel', 'preinit');
                pInit(aQuery);
                pExecute;
                
                lSheetNum := xlsx_builder_pkg.new_sheet(p_sheetname => nvl(lSheetName,'Export'));
                
                lFillGray := xlsx_builder_pkg.get_fill(p_patternType => 'solid', p_fgRGB => '00D0D0D0');
                lNoFill := xlsx_builder_pkg.get_fill(p_patterntype => 'solid', p_fgRGB => 'FFFFFFFF');
                lFillPaleGreen := xlsx_builder_pkg.get_fill(p_patternType => 'solid', p_fgRGB => '00EBF1DE');
                lFillPaleBlue := xlsx_builder_pkg.get_fill(p_patternType => 'solid', p_fgRGB => '00DCE6F1');
                
                -- zu den Zahlenwerten bei rgb
                -- das erste ist alpha
                -- dann kommt rot, dann gruen, dann blau
                
 
 
                lAlignment := xlsx_builder_pkg.get_alignment(p_horizontal => 'center', p_vertical => 'center'); 
                --lAlignment := get_alignment(p_vertical => 'center', p_horizontal => 'center', p_wraptext => TRUE);
 
                lFontCurrent := xlsx_builder_pkg.get_font(p_name => 'Arial', p_fontsize => 10, p_bold => TRUE);
                lBold := xlsx_builder_pkg.get_font(p_name => 'Arial', p_fontsize => 8, p_bold => TRUE);
 
                -- Tabellenköpfe
                lFontHeader := xlsx_builder_pkg.get_font(
                    p_name      => 'Audi Type',
                    p_fontsize  => 10,
                    p_bold      => true
                );
    
                -- Tabellenzellen
                lFontCell := xlsx_builder_pkg.get_font(
                    p_name      => 'Audi Type',
                    p_fontsize  => 10,
                    p_bold      => false
                );
    
                -- Vertraulichkeitshinweis
                lFontVertraulich := xlsx_builder_pkg.get_font(
                    p_name      => 'Audi Type',
                    p_fontsize  => 20,
                    p_bold      => true,
                    p_rgb       => 'CC0637'
                );
    
                -- Titel
                lFontTitle := xlsx_builder_pkg.get_font(
                    p_name      => 'Audi Type',
                    p_fontsize  => 20,
                    p_bold      => true
                );
                lBorderHeader := xlsx_builder_pkg.get_border('medium','medium','medium','medium');
                lBorderHeaderLight := xlsx_builder_pkg.get_border('light','light','light','light');
                -- debug('test Excel2', 'preinit1');
                for lSpalte in 1..(fNumberOfColumns-1)
                loop
                    xlsx_builder_pkg.cell(lSpalte + fExcelConfig.fOffsetCols, 1 + fExcelConfig.fOffsetRows, fColumns(lSpalte).fName, p_fillId => lFillGray, p_fontId => lFontHeader, p_borderId => lBorderHeader );
                    if (fColumns(lSpalte).fColumnWidth = -1) then
                        xlsx_builder_pkg.set_column_width(lSpalte + fExcelConfig.fOffsetCols, ceil(fGetMaxStringLength(lSpalte)*1.5));
                    end if;
                end loop;
 
             -- Column indices for Current section
                lCurrentLocalRegColumnIndex := 4; -- index for 'Local Regulation'
                lCurrentCorrectionColumnIndex := 5; -- index for 'Correction'
                lCurrentCommentsColumnIndex := 6; -- index for 'Comments'
 
                -- Column indices for Future section
                lFutureLocalRegColumnIndex := 7; -- index for 'Local Regulation' in Future
                lFutureEnactDateColumnIndex := 8; -- index for 'Enactment Date'
                lFutureImpDateNewTypeColumnIndex := 9; -- index for 'Implementation date New Type'
                lFutureImpDateAllVehiclesColumnIndex := 10; -- index for 'Implementation date All Vehicles'
                lFutureCorrectionColumnIndex := 11; -- index for 'Correction' in Future
                lFutureCommentsColumnIndex := 12; -- index for 'Comments' in Future
 
                lTopicIdColumnIndex := 1; --  TopicID column is the second column
                lTopicColumnIndex := 2; -- Topic column is the third column
                lTopicDescriptionColumnIndex := 3;
 
 
                lleafColumnIndex := 16;
 
                -- Inside the loop where cells are formatted
                for lZeile in 1..fRowCount loop
                   
                    for lSpalte in 1..fNumberOfColumns loop
                        lBorder := fMakeExcelCellBorder(lZeile, lSpalte);
                        lFillColor := lNoFill; -- Default to no fill
 
                        
 
                        -- Check 'Current' section: Fill 'Local Regulation', 'Correction', and 'Comments' with gray if 'Local Regulation' is empty
                        if fGetStringValue(lZeile, lCurrentLocalRegColumnIndex) is null then
                            if lSpalte in (lCurrentLocalRegColumnIndex, lCurrentCorrectionColumnIndex, lCurrentCommentsColumnIndex) then
                                lFillColor := lFillGray;
                            end if;
                        end if;
                        
                        -- Check 'Future' section: Fill 'Local Regulation' and related columns with gray if 'Local Regulation' is empty
                        if fGetStringValue(lZeile, lFutureLocalRegColumnIndex) is null then
                            if lSpalte in (lFutureLocalRegColumnIndex, lFutureCorrectionColumnIndex, lFutureCommentsColumnIndex, lFutureEnactDateColumnIndex, lFutureImpDateNewTypeColumnIndex, lFutureImpDateAllVehiclesColumnIndex) then
                                lFillColor := lFillGray;
                            end if;
                        end if;
 
                        -- Now call the procedure to make the Excel cell with the appropriate fill color.
                        pMakeExcelCell(lZeile, lSpalte, lFontCell, lFillColor, lBorder);
                    end loop;
                end loop;
              
           
 
 
 
 
                  -- momentan wird durch diese Zelle der Autofilter auch in diese erste Zeile gesetzt
                if aVertraulich = 1 then
                    xlsx_builder_pkg.cell(9, 2, '- vertraulich -', p_fontid => lFontVertraulich);
                end if;
                xlsx_builder_pkg.cell(15, 1, 'Audi-Standort / Audi-Tochter');
                xlsx_builder_pkg.cell(17, 1, 'Ansprechpartner', p_fontid => lBold);
                xlsx_builder_pkg.cell(18, 1, 'Zugeordnete ID', p_fontid => lBold);
                xlsx_builder_pkg.cell(19, 1, 'Passwort', p_fontid => lBold);
 
                xlsx_builder_pkg.cell(2, 2, nvl(lTitleName,'Export'), p_fontid => lFontTitle);
                --xlsx_builder_pkg.cell(2, 3, 'Erstellungsdatum');
                
                xlsx_builder_pkg.cell(15, 2, 'Audi-Ingolstadt');
                xlsx_builder_pkg.cell(17, 2, 'Christlbauer Herbert, Gerhard Miehling');
                xlsx_builder_pkg.cell(18, 2, 'nUdpywey');
                xlsx_builder_pkg.cell(19, 2, 'Japan_2401');
                xlsx_builder_pkg.cell(2, 3, 'Erstellungsdatum');
                xlsx_builder_pkg.cell(3, 3, sysdate);
 
                -- Set the border for each cell in the range before merging
                for col in 5..7 loop
                    xlsx_builder_pkg.cell(col, 4, '', p_borderId => lBorderHeader);
                end loop;
               
                xlsx_builder_pkg.mergecells(5, 4, 7, 4);
                xlsx_builder_pkg.cell(5, 4, 'Current', p_fontid => lFontCurrent,p_fillid => lFillPaleGreen, p_borderId => lBorderHeader, p_alignment => lAlignment);
 
                for col in 8..13 loop
                    xlsx_builder_pkg.cell(col, 4, '', p_borderId => lBorderHeader);
                end loop;
 
                xlsx_builder_pkg.mergecells(8, 4, 13, 4);
                xlsx_builder_pkg.cell(8, 4, 'Future', p_fontid => lFontCurrent,p_fillid => lFillPaleBlue, p_borderId => lBorderHeader, p_alignment => lAlignment);
                
 
                if (fExcelConfig.fUseAutoFilter) then
                    xlsx_builder_pkg.set_autofilter(1 + fExcelConfig.fOffsetCols, fNumberOfColumns + fExcelConfig.fOffsetCols, p_row_start => 1 + fExcelConfig.fOffsetRows);
                end if;
                if (fExcelConfig.fUseFreezePane) then
                    xlsx_builder_pkg.freeze_rows( 1+fExcelConfig.fOffsetRows );
                end if;
 
 --           end loop;
             
            return xlsx_builder_pkg.finish;    
            
        end fMakeExcelsingleSheet;
 */
 
 
 /*
 
--  Single
       
       function fMakeExcelsingleSheet(aSheetName in varchar2, aTitleName in varchar2, aQuery in clob, aVertraulich in number default null) return blob is
        lFillGray number;
        lNoFill number;
        lFillColor number;
        lFontHeader number;
        lFontCell number;
        lBorderHeader number;
        lBorderHeaderLight number;
        lSheetNum number;
        lFontTitle number;
        lFontVertraulich number;
        lBorder number;
        lSheetName varchar2(500);
        lTitleName varchar2(500);
        lFillPaleGreen number;
        lFillPaleBlue number;
        lFontCurrent number;
        lBold number;
        lAlignment  xlsx_builder_pkg.t_alignment_rec;
        lCurrentLocalRegColumnIndex number;
        lCurrentCorrectionColumnIndex number;
        lCurrentCommentsColumnIndex number;
        lFutureLocalRegColumnIndex number;
        lFutureEnactDateColumnIndex number;
        lFutureImpDateNewTypeColumnIndex number;
        lFutureImpDateAllVehiclesColumnIndex number;
        lFutureCorrectionColumnIndex number;
        lFutureCommentsColumnIndex number;
        lTopicIdColumnIndex number;
        lTopicColumnIndex number;
        lleafColumnIndex number;
        lTopicDescriptionColumnIndex number;
       
        
        begin
 
                
                
                xlsx_builder_pkg.clear_workbook;
            
          --  for i in 1..aQuery.count loop
                lSheetName := aSheetName;
                lTitleName := aTitleName;
                                
                -- debug('test Excel', 'preinit');
                pInit(aQuery);
                pExecute;
                
                lSheetNum := xlsx_builder_pkg.new_sheet(p_sheetname => nvl(lSheetName,'Export'));
                
                lFillGray := xlsx_builder_pkg.get_fill(p_patternType => 'solid', p_fgRGB => '00D0D0D0');
                lNoFill := xlsx_builder_pkg.get_fill(p_patterntype => 'solid', p_fgRGB => 'FFFFFFFF');
                lFillPaleGreen := xlsx_builder_pkg.get_fill(p_patternType => 'solid', p_fgRGB => '00EBF1DE');
                lFillPaleBlue := xlsx_builder_pkg.get_fill(p_patternType => 'solid', p_fgRGB => '00DCE6F1');
                
                -- zu den Zahlenwerten bei rgb
                -- das erste ist alpha
                -- dann kommt rot, dann gruen, dann blau
                
 
 
                lAlignment := xlsx_builder_pkg.get_alignment(p_horizontal => 'center', p_vertical => 'center'); 
                --lAlignment := get_alignment(p_vertical => 'center', p_horizontal => 'center', p_wraptext => TRUE);
 
                lFontCurrent := xlsx_builder_pkg.get_font(p_name => 'Arial', p_fontsize => 10, p_bold => TRUE);
                lBold := xlsx_builder_pkg.get_font(p_name => 'Arial', p_fontsize => 8, p_bold => TRUE);
 
                -- Tabellenköpfe
                lFontHeader := xlsx_builder_pkg.get_font(
                    p_name      => 'Audi Type',
                    p_fontsize  => 10,
                    p_bold      => true
                );
    
                -- Tabellenzellen
                lFontCell := xlsx_builder_pkg.get_font(
                    p_name      => 'Audi Type',
                    p_fontsize  => 10,
                    p_bold      => false
                );
    
                -- Vertraulichkeitshinweis
                lFontVertraulich := xlsx_builder_pkg.get_font(
                    p_name      => 'Audi Type',
                    p_fontsize  => 20,
                    p_bold      => true,
                    p_rgb       => 'CC0637'
                );
    
                -- Titel
                lFontTitle := xlsx_builder_pkg.get_font(
                    p_name      => 'Audi Type',
                    p_fontsize  => 20,
                    p_bold      => true
                );
                lBorderHeader := xlsx_builder_pkg.get_border('medium','medium','medium','medium');
                lBorderHeaderLight := xlsx_builder_pkg.get_border('light','light','light','light');
                -- debug('test Excel2', 'preinit1');
                for lSpalte in 1..(fNumberOfColumns-1)
                loop
                    xlsx_builder_pkg.cell(lSpalte + fExcelConfig.fOffsetCols, 1 + fExcelConfig.fOffsetRows, fColumns(lSpalte).fName, p_fillId => lFillGray, p_fontId => lFontHeader, p_borderId => lBorderHeader );
                    if (fColumns(lSpalte).fColumnWidth = -1) then
                        xlsx_builder_pkg.set_column_width(lSpalte + fExcelConfig.fOffsetCols, ceil(fGetMaxStringLength(lSpalte)*1.5));
                    end if;
                end loop;
 
                -- Column indices for Current section
                lCurrentLocalRegColumnIndex := 4; -- index for 'Local Regulation'
                lCurrentCorrectionColumnIndex := 5; -- index for 'Correction'
                lCurrentCommentsColumnIndex := 6; -- index for 'Comments'
 
                -- Column indices for Future section
                lFutureLocalRegColumnIndex := 7; -- index for 'Local Regulation' in Future
                lFutureEnactDateColumnIndex := 8; -- index for 'Enactment Date'
                lFutureImpDateNewTypeColumnIndex := 9; -- index for 'Implementation date New Type'
                lFutureImpDateAllVehiclesColumnIndex := 10; -- index for 'Implementation date All Vehicles'
                lFutureCorrectionColumnIndex := 11; -- index for 'Correction' in Future
                lFutureCommentsColumnIndex := 12; -- index for 'Comments' in Future
 
                lTopicIdColumnIndex := 1; --  TopicID column is the second column
                lTopicColumnIndex := 2; -- Topic column is the third column
                lTopicDescriptionColumnIndex := 3;
 
 
                lleafColumnIndex := 16;
 
               
               -- This block of code formats the cells in the Excel sheet. 
               -- It applies a grey fill color to certain columns based on the content of the 'Local Regulation' cells and other specific conditions. 
               -- It iterates over each row and column to apply the conditional formatting.
 
                -- Inside the loop where cells are formatted
                for lZeile in 1..fRowCount loop
                   
                    for lSpalte in 1..(fNumberOfColumns-1) loop
                        lBorder := fMakeExcelCellBorder(lZeile, lSpalte);
                        lFillColor := lNoFill; -- Default to no fill
 
                        -- Comparing the returned string from fGetStringValue with '0'
                        if fGetStringValue(lZeile, lleafColumnIndex) = '0' then
                            if lSpalte in (lTopicIdColumnIndex, lTopicColumnIndex, lTopicDescriptionColumnIndex) then
                                lFillColor := lFillGray;
                            end if;
                        end if;
                        
  
                        --       --- it is multi commmnet - un comment it - start
                        -- -- Check 'Current' section: Fill 'Local Regulation', 'Correction', and 'Comments' with gray if 'Local Regulation' is empty
                        -- if fGetStringValue(lZeile, lCurrentLocalRegColumnIndex) is null then
                       
                        --     if lSpalte in (lCurrentLocalRegColumnIndex,lCurrentCorrectionColumnIndex, lCurrentCommentsColumnIndex) then
                        --         lFillColor := lFillGray;
                        --     end if;
                        -- end if;
                        
                        -- -- Check 'Future' section: Fill 'Local Regulation' and related columns with gray if 'Local Regulation' is empty
                        -- if fGetStringValue(lZeile, lFutureLocalRegColumnIndex) is null then
                        
                        --     if lSpalte in (lFutureLocalRegColumnIndex,lFutureCorrectionColumnIndex, lFutureCommentsColumnIndex, lFutureEnactDateColumnIndex, lFutureImpDateNewTypeColumnIndex, lFutureImpDateAllVehiclesColumnIndex) then
                        --         lFillColor := lFillGray;
                        --     end if;
                        -- end if;
                        --  --- it is multi commmnet - un comment it - end 
 
 
                        if lSpalte in (lCurrentLocalRegColumnIndex, lFutureLocalRegColumnIndex, lFutureEnactDateColumnIndex, lFutureImpDateNewTypeColumnIndex, lFutureImpDateAllVehiclesColumnIndex) then
                            lFillColor := lFillGray;
                        end if;
 
                        -- Check for columns that depend on E or any of H, I, J, K being filled
                        if lSpalte in (lCurrentCorrectionColumnIndex, lCurrentCommentsColumnIndex, lFutureCorrectionColumnIndex, lFutureCommentsColumnIndex) then
                            -- Set to grey fill initially
                            lFillColor := lFillGray;
                            -- Determine if related 'Local Regulation' column is filled
                            if (lSpalte in (lCurrentCorrectionColumnIndex, lCurrentCommentsColumnIndex) and fGetStringValue(lZeile, lCurrentLocalRegColumnIndex) is not null) or
                               (lSpalte in (lFutureCorrectionColumnIndex, lFutureCommentsColumnIndex) and 
                               (fGetStringValue(lZeile, lFutureLocalRegColumnIndex) is not null or 
                                fGetStringValue(lZeile, lFutureEnactDateColumnIndex) is not null or 
                                fGetStringValue(lZeile, lFutureImpDateNewTypeColumnIndex) is not null or 
                                fGetStringValue(lZeile, lFutureImpDateAllVehiclesColumnIndex) is not null)) then
                                lFillColor := lNoFill; -- Set to white (no fill) if data is present
                            end if;
                        end if;
 
 
                        -- Now call the procedure to make the Excel cell with the appropriate fill color.
                        pMakeExcelCell(lZeile, lSpalte, lFontCell, lFillColor, lBorder);
                    end loop;
                end loop;
             
            --  --- it is multi commmnet -  comment it - start
            --     -- Inside the loop where cells are formatted
            --     for lZeile in 1..fRowCount loop
 
            --         for lSpalte in 1..(fNumberOfColumns-1) loop
            --             lBorder := fMakeExcelCellBorder(lZeile, lSpalte);
            --             lFillColor := lNoFill; -- Default to no fill
 
            --             -- Directly set the gray fill for specific columns
            --             if lSpalte in (lCurrentLocalRegColumnIndex, lCurrentCorrectionColumnIndex, lCurrentCommentsColumnIndex, lFutureLocalRegColumnIndex, lFutureCorrectionColumnIndex, lFutureCommentsColumnIndex, lFutureEnactDateColumnIndex, lFutureImpDateNewTypeColumnIndex, lFutureImpDateAllVehiclesColumnIndex) then
            --                 lFillColor := lFillGray;
            --             end if;
 
            --             -- Now call the procedure to make the Excel cell with the appropriate fill color.
            --             pMakeExcelCell(lZeile, lSpalte, lFontCell, lFillColor, lBorder);
            --         end loop;
            --     end loop;
            --  --- it is multi commmnet -  comment it - end


--- it is multi commmnet -  comment it - start
-- -- Inside the loop where cells are formatted
-- for lZeile in 1..fRowCount loop
 
--     for lSpalte in 1..(fNumberOfColumns-1) loop
--         lBorder := fMakeExcelCellBorder(lZeile, lSpalte);
--         lFillColor := lNoFill; -- Default to no fill
 
--         -- Set the grey fill for the columns E, H, I, J, K
--         if lSpalte in (lCurrentLocalRegColumnIndex, lFutureLocalRegColumnIndex, lFutureEnactDateColumnIndex, lFutureImpDateNewTypeColumnIndex, lFutureImpDateAllVehiclesColumnIndex) then
--             lFillColor := lFillGray;
--         end if;
 
--         -- Check for columns that depend on E or any of H, I, J, K being filled
--         if lSpalte in (lCurrentCorrectionColumnIndex, lCurrentCommentsColumnIndex, lFutureCorrectionColumnIndex, lFutureCommentsColumnIndex) then
--             -- Set to grey fill initially
--             lFillColor := lFillGray;
--             -- Determine if related 'Local Regulation' column is filled
--             if (lSpalte in (lCurrentCorrectionColumnIndex, lCurrentCommentsColumnIndex) and fGetStringValue(lZeile, lCurrentLocalRegColumnIndex) is not null) or
--                (lSpalte in (lFutureCorrectionColumnIndex, lFutureCommentsColumnIndex) and 
--                (fGetStringValue(lZeile, lFutureLocalRegColumnIndex) is not null or 
--                 fGetStringValue(lZeile, lFutureEnactDateColumnIndex) is not null or 
--                 fGetStringValue(lZeile, lFutureImpDateNewTypeColumnIndex) is not null or 
--                 fGetStringValue(lZeile, lFutureImpDateAllVehiclesColumnIndex) is not null)) then
--                 lFillColor := lNoFill; -- Set to white (no fill) if data is present
--             end if;
--         end if;
 
--         -- Now call the procedure to make the Excel cell with the appropriate fill color.
--         pMakeExcelCell(lZeile, lSpalte, lFontCell, lFillColor, lBorder);
--     end loop;
-- end loop;
 
-- --- it is multi commmnet -  comment it - end
 
                  -- momentan wird durch diese Zelle der Autofilter auch in diese erste Zeile gesetzt
                if aVertraulich = 1 then
                    xlsx_builder_pkg.cell(9, 2, '- vertraulich -', p_fontid => lFontVertraulich);
                end if;
                -- xlsx_builder_pkg.cell(15, 1, 'Audi-Standort / Audi-Tochter');
                -- xlsx_builder_pkg.cell(17, 1, 'Ansprechpartner', p_fontid => lBold);
                -- xlsx_builder_pkg.cell(18, 1, 'Zugeordnete ID', p_fontid => lBold);
                -- xlsx_builder_pkg.cell(19, 1, 'Passwort', p_fontid => lBold);
 
                xlsx_builder_pkg.cell(2, 2, nvl(lTitleName,'Export'), p_fontid => lFontTitle);
                -- xlsx_builder_pkg.cell(2, 3, 'Erstellungsdatum');
                
                -- xlsx_builder_pkg.cell(15, 2, 'Audi-Ingolstadt');
                -- xlsx_builder_pkg.cell(17, 2, 'Christlbauer Herbert, Gerhard Miehling');
                -- xlsx_builder_pkg.cell(18, 2, 'nUdpywey');
                -- xlsx_builder_pkg.cell(19, 2, 'Japan_2401');
                xlsx_builder_pkg.cell(2, 3, 'Erstellungsdatum');
                xlsx_builder_pkg.cell(3, 3, sysdate);
 
                -- Set the border for each cell in the range before merging
                for col in 5..7 loop
                    xlsx_builder_pkg.cell(col, 4, '', p_borderId => lBorderHeader);
                end loop;
               
                xlsx_builder_pkg.mergecells(5, 4, 7, 4);
                xlsx_builder_pkg.cell(5, 4, 'Current', p_fontid => lFontCurrent,p_fillid => lFillPaleGreen, p_borderId => lBorderHeader, p_alignment => lAlignment);
 
                for col in 8..13 loop
                    xlsx_builder_pkg.cell(col, 4, '', p_borderId => lBorderHeader);
                end loop;
 
                xlsx_builder_pkg.mergecells(8, 4, 13, 4);
                xlsx_builder_pkg.cell(8, 4, 'Future', p_fontid => lFontCurrent,p_fillid => lFillPaleBlue, p_borderId => lBorderHeader, p_alignment => lAlignment);
                
 
                if (fExcelConfig.fUseAutoFilter) then
                    xlsx_builder_pkg.set_autofilter(1 + fExcelConfig.fOffsetCols, (fNumberOfColumns-1) + fExcelConfig.fOffsetCols, p_row_start => 1 + fExcelConfig.fOffsetRows);
                end if;
                if (fExcelConfig.fUseFreezePane) then
                    xlsx_builder_pkg.freeze_rows( 1+fExcelConfig.fOffsetRows );
                end if;
 
 --           end loop;
             
            return xlsx_builder_pkg.finish;    
            
        end fMakeExcelsingleSheet;
      */
 
 
/* Single - customers */
       
       function fMakeExcelsingleSheet(aSheetName in varchar2, aTitleName in varchar2, aQuery in clob, aVertraulich in number default null) return blob is
    lFillGray number;
    lNoFill number;
    lFillColor number;
    lFontHeader number;
    lFontCell number;
    lBorderHeader number;
    lSheetNum number;
    lFontTitle number;
    lBorder number;
    lSheetName varchar2(500);
    lTitleName varchar2(500);
    lAlignment  xlsx_builder_pkg.t_alignment_rec;
begin
    xlsx_builder_pkg.clear_workbook;

    lSheetName := aSheetName;
    lTitleName := aTitleName;
                    
    pInit(aQuery);
    pExecute;
    
    lSheetNum := xlsx_builder_pkg.new_sheet(p_sheetname => nvl(lSheetName,'Customer Export'));
    
    lFillGray := xlsx_builder_pkg.get_fill(p_patternType => 'solid', p_fgRGB => '00D0D0D0');
    lNoFill := xlsx_builder_pkg.get_fill(p_patterntype => 'solid', p_fgRGB => 'FFFFFFFF');
    
    lAlignment := xlsx_builder_pkg.get_alignment(p_horizontal => 'center', p_vertical => 'center'); 

    lFontHeader := xlsx_builder_pkg.get_font(p_name => 'Arial', p_fontsize => 10, p_bold => true);
    lFontCell := xlsx_builder_pkg.get_font(p_name => 'Arial', p_fontsize => 10, p_bold => false);
    lFontTitle := xlsx_builder_pkg.get_font(p_name => 'Arial', p_fontsize => 14, p_bold => true);
    lBorderHeader := xlsx_builder_pkg.get_border('medium','medium','medium','medium');

    -- Header row
    for lSpalte in 1..(fNumberOfColumns-1) loop
        xlsx_builder_pkg.cell(lSpalte + fExcelConfig.fOffsetCols, 1 + fExcelConfig.fOffsetRows, fColumns(lSpalte).fName, p_fillId => lFillGray, p_fontId => lFontHeader, p_borderId => lBorderHeader );
        if (fColumns(lSpalte).fColumnWidth = -1) then
            xlsx_builder_pkg.set_column_width(lSpalte + fExcelConfig.fOffsetCols, ceil(fGetMaxStringLength(lSpalte)*1.5));
        end if;
    end loop;

    -- Data rows
    for lZeile in 1..fRowCount loop
        for lSpalte in 1..(fNumberOfColumns-1) loop
            lBorder := fMakeExcelCellBorder(lZeile, lSpalte);
            lFillColor := lNoFill; -- Default to no fill
            pMakeExcelCell(lZeile, lSpalte, lFontCell, lFillColor, lBorder);
        end loop;
    end loop;

    -- Title and creation date
    xlsx_builder_pkg.cell(2, 2, nvl(lTitleName,'Customer Export'), p_fontid => lFontTitle);
    xlsx_builder_pkg.cell(2, 3, 'Creation Date');
    xlsx_builder_pkg.cell(3, 3, sysdate);

    if (fExcelConfig.fUseAutoFilter) then
        xlsx_builder_pkg.set_autofilter(1 + fExcelConfig.fOffsetCols, (fNumberOfColumns-1) + fExcelConfig.fOffsetCols, p_row_start => 1 + fExcelConfig.fOffsetRows);
    end if;
    if (fExcelConfig.fUseFreezePane) then
        xlsx_builder_pkg.freeze_rows( 1+fExcelConfig.fOffsetRows );
    end if;

    return xlsx_builder_pkg.finish;    
end fMakeExcelsingleSheet;



FUNCTION fMakeExcelsingleSheet_land(
            aSheetName in varchar2,
            aTitleName in varchar2,
            aQuery in clob
        ) return blob is
            -- Variable declarations
            l_fill_gray number;
            l_no_fill number;
            l_font_header number;
            l_font_cell number;
            l_border_header number;
            l_sheet_num number;
            l_font_title number;
            l_alignment xlsx_builder_pkg.t_alignment_rec;
        BEGIN
            -- Initialize workbook
            xlsx_builder_pkg.clear_workbook;
            
            -- -- Set styles
            -- l_fill_gray := xlsx_builder_pkg.get_fill(p_patternType => 'solid', p_fgRGB => '00D0D0D0');
            -- l_no_fill := xlsx_builder_pkg.get_fill(p_patterntype => 'solid', p_fgRGB => 'FFFFFFFF');
            -- l_alignment := xlsx_builder_pkg.get_alignment(p_horizontal => 'center', p_vertical => 'center');
            
            -- Set fonts
            l_font_header := xlsx_builder_pkg.get_font(
                p_name => 'Audi Type',
                p_fontsize => 10,
                p_bold => true
            );
            
            l_font_cell := xlsx_builder_pkg.get_font(
                p_name => 'Audi Type',
                p_fontsize => 10,
                p_bold => false
            );
         
            l_font_title := xlsx_builder_pkg.get_font(
                p_name => 'Audi Type',
                p_fontsize => 20,
                p_bold => true
            );
            
            -- Set borders
            l_border_header := xlsx_builder_pkg.get_border('medium','medium','medium','medium');
            
            -- Create new sheet
            l_sheet_num := xlsx_builder_pkg.new_sheet(p_sheetname => nvl(aSheetName,'Export'));
            
            -- Add title and headers
            xlsx_builder_pkg.cell(2, 2, aTitleName, p_fontId => l_font_title);
            
            -- Process query and add data
            DECLARE
                l_theCursor INTEGER;
                l_columnValue VARCHAR2(4000);
                l_status INTEGER;
                l_descTbl DBMS_SQL.DESC_TAB;
                l_colCnt NUMBER;
                l_row_num NUMBER := 4; -- Start after title
            BEGIN
                -- Open cursor and get column info
                l_theCursor := DBMS_SQL.OPEN_CURSOR;
                DBMS_SQL.PARSE(l_theCursor, aQuery, DBMS_SQL.NATIVE);
                DBMS_SQL.DESCRIBE_COLUMNS(l_theCursor, l_colCnt, l_descTbl);
                
                -- Add headers
                FOR i IN 1..l_colCnt LOOP
                    xlsx_builder_pkg.cell(
                        i, l_row_num,
                        l_descTbl(i).col_name,
                        p_fillId => l_fill_gray,
                        p_fontId => l_font_header,
                        p_borderId => l_border_header,
                        p_alignment => l_alignment
                    );
                    -- Set initial column width
                    xlsx_builder_pkg.set_column_width(i, length(l_descTbl(i).col_name) + 5);
                END LOOP;
                
                -- Bind columns and execute query
                FOR i IN 1..l_colCnt LOOP
                    DBMS_SQL.DEFINE_COLUMN(l_theCursor, i, l_columnValue, 4000);
                END LOOP;
                
                l_status := DBMS_SQL.EXECUTE(l_theCursor);
                
                -- Add data rows
                WHILE DBMS_SQL.FETCH_ROWS(l_theCursor) > 0 LOOP
                    l_row_num := l_row_num + 1;
                    FOR i IN 1..l_colCnt LOOP
                        DBMS_SQL.COLUMN_VALUE(l_theCursor, i, l_columnValue);
                        xlsx_builder_pkg.cell(
                            i, l_row_num,
                            l_columnValue,
                            p_fillId => CASE 
                                WHEN MOD(l_row_num, 2) = 0 THEN l_fill_gray 
                                ELSE l_no_fill 
                            END,
                            p_fontId => l_font_cell,
                            p_alignment => l_alignment
                        );
                        
                        -- Set column width based on content
                        xlsx_builder_pkg.set_column_width(i, GREATEST(length(l_columnValue) + 2, 15));
                    END LOOP;
                END LOOP;
                
                -- Close cursor
                DBMS_SQL.CLOSE_CURSOR(l_theCursor);
                
                -- Add autofilter
                xlsx_builder_pkg.set_autofilter(1, l_colCnt, p_row_start => 4);
                
                -- Freeze panes (freeze header row)
                xlsx_builder_pkg.freeze_rows(4);
                
            EXCEPTION
                WHEN OTHERS THEN
                    IF DBMS_SQL.IS_OPEN(l_theCursor) THEN
                        DBMS_SQL.CLOSE_CURSOR(l_theCursor);
                    END IF;
                    RAISE;
            END;
            
            -- Return the Excel file
            RETURN xlsx_builder_pkg.finish;
        END;
        
 
 



        
             
end emano_report;
/