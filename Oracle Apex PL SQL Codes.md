
# Inserts distinct translations from apex_application_trans_repos into T_TRANSLATION_TABLE where German and English texts differ for application_id 112 and ensures no duplicate German entries in the T_TRANSLATION_TABLE.

```
INSERT INTO t_translation_table (text_german, text_english)
    SELECT DISTINCT dbms_lob.substr(from_string,2000) as from_string, dbms_lob.substr(to_string,2000) as to_string
    FROM apex_application_trans_repos
    WHERE dbms_lob.substr(from_string,2000) != dbms_lob.substr(to_string,2000)
    AND application_id = 112    
    AND NOT EXISTS (SELECT 1 
                    FROM t_translation_table WHERE application_id = 112
                    AND dbms_lob.substr(from_string,2000) = dbms_lob.substr(text_german, 2000));
```                                                    
                                                    
                                                    
# Updates the English text in T_TRANSLATION_TABLE by fetching distinct translations from apex_application_trans_repos for application_id 112 where German and English texts differ and match with the table's German text.
                                                  
-- Updating t_translation_table with new translations from apex_application_trans_repos

```
UPDATE t_translation_table ttt
SET (text_english) = (
    SELECT DISTINCT dbms_lob.substr(src.to_string,2000) 
    FROM apex_application_trans_repos src
    WHERE dbms_lob.substr(src.from_string,2000) = dbms_lob.substr(ttt.text_german, 2000)
    AND src.application_id = 112
    AND dbms_lob.substr(src.from_string,2000) != dbms_lob.substr(src.to_string,2000)
)
WHERE EXISTS (
    SELECT 1
    FROM apex_application_trans_repos src
    WHERE dbms_lob.substr(src.from_string,2000) = dbms_lob.substr(ttt.text_german, 2000)
    AND src.application_id = 112
    AND dbms_lob.substr(src.from_string,2000) != dbms_lob.substr(src.to_string,2000)
)
```


# Sets the APEX security group to the associated workspace, then updates English translations in APEX_APPLICATION_TRANS_REPOS 
based on matches with T_TRANSLATION_TABLE for a specific target application = 240. 


BEGIN
 -- The strings can be imported into the target application via the APEX_LANG package
 -- If running from SQL*Plus, we need to set the environment
 -- for the Application Express workspace associated with this schema. The
 -- call to apex_util.set_security_group_id is not necessary if
 -- you're running within the context of the App Builder
 -- or an Application Express application.

    FOR C1 IN (
        SELECT
            WORKSPACE_ID
        FROM
            APEX_WORKSPACES
    ) LOOP
        APEX_UTIL.SET_SECURITY_GROUP_ID( C1.WORKSPACE_ID );
        EXIT;
    END LOOP;
    -- Locate all strings in the repository for the specified application based on T_TRANSLATION_TABLE
    FOR C1 IN (
        SELECT
            TTT.TEXT_ENGLISH,
            AATR.ID
        FROM
            T_TRANSLATION_TABLE TTT
            JOIN APEX_APPLICATION_TRANS_REPOS AATR
            ON DBMS_LOB.COMPARE(TTT.TEXT_GERMAN, AATR.TO_STRING) = 0
        WHERE
            AATR.APPLICATION_ID = 118 -- ( Target APP ID )
            AND AATR.LANGUAGE_CODE = 'en'
    ) LOOP
    --Update the string
        APEX_LANG.UPDATE_TRANSLATED_STRING(
            P_ID => C1.ID,
            P_LANGUAGE => 'en',
            P_STRING => C1.TEXT_ENGLISH
        );
    END LOOP;
    COMMIT;
END;




# Fetches translation records from APEX_APPLICATION_TRANS_REPOS where the from_string and translated to_string are identical for application ID = 240. 


SELECT
    APPLICATION_ID,
    APPLICATION_NAME,
    TRANSLATED_APPLICATION_ID,
    ID,
    FROM_STRING,
    TO_STRING,
    LANGUAGE_CODE
FROM
    APEX_APPLICATION_TRANS_REPOS
WHERE
    APPLICATION_ID = 118
    AND  DBMS_LOB.COMPARE(FROM_STRING, TO_STRING) = 0
    
    --dbms_lob.substr(from_string,2000) = dbms_lob.substr(to_string,2000);
    


# Counts the number of translation records from APEX_APPLICATION_TRANS_REPOS where the from_string and translated to_string are identical for application ID = 240. 


SELECT
    COUNT(*) AS IDENTICAL_RECORD_COUNT
FROM
    APEX_APPLICATION_TRANS_REPOS
WHERE
    APPLICATION_ID = 112
    AND DBMS_LOB.COMPARE(FROM_STRING, TO_STRING) != 0;

    



# Updates a specific English translation string using the APEX_LANG package 


BEGIN
 APEX_LANG.UPDATE_TRANSLATED_STRING(
            P_ID => 730032710308662664,
            P_LANGUAGE => 'en',
            P_STRING => 'Start profile'
        );
END;



#
Retrieves records from APEX_APPLICATION_TRANS_REPOS where APPLICATION_ID is 240 and the original and translated strings are identical.



SELECT
    APPLICATION_ID,
    APPLICATION_NAME,
    TRANSLATED_APPLICATION_ID,
    ID,
    FROM_STRING,
    TO_STRING,
    LANGUAGE_CODE
FROM
    APEX_APPLICATION_TRANS_REPOS
WHERE
    APPLICATION_ID = 118
    AND  DBMS_LOB.COMPARE(FROM_STRING, TO_STRING) = 0
	
	
	
# Help Table t_hilfe



describe t_hilfe



SELECT COUNT(*) 
FROM t_hilfe 
WHERE TITEL IS NULL;



SELECT COUNT(*)
FROM t_hilfe 
WHERE TITEL_ENG IS NULL;



ALTER TABLE t_hilfe ADD TITEL_ENG VARCHAR2(40 CHAR);
ALTER TABLE t_hilfe ADD TOOLTIP_ENG VARCHAR2(1000 CHAR);
ALTER TABLE t_hilfe ADD HILFETEXT_ENG CLOB;


ALTER TABLE t_hilfe MODIFY TITEL_ENG VARCHAR2(50); 


ALTER TABLE t_hilfe RENAME COLUMN TITEL_ENG TO TITEL_ENGLISCH;
ALTER TABLE t_hilfe RENAME COLUMN TOOLTIP_ENG TO TOOLTIP_ENGLISCH;
ALTER TABLE t_hilfe RENAME COLUMN HILFETEXT_ENG TO HILFETEXT_ENGLISCH;


desc t_hilfe


# Page 25, titel table t_vorschrift 


ALTER TABLE t_vorschrift ADD Titel_German VARCHAR2(500 CHAR);

ALTER TABLE t_vorschrift ADD Comment_English VARCHAR2(4000 CHAR);

ALTER TABLE t_vorschrift RENAME COLUMN TITEL_GERMAN TO VORSCHRIFT_BEZEICHNUNG_DEUTSCH;

ALTER TABLE t_vorschrift RENAME COLUMN COMMENT_ENGLISH TO BEMERKUNG_ENGLISCH;




desc t_vorschrift 



# Page 25 table t_vorschrift_ref_einsatzdatum_typ 


ALTER TABLE t_vorschrift_ref_einsatzdatum_typ ADD EINSATZDATUM_TEXT_Englisch VARCHAR2(4000 CHAR);

select * from t_vorschrift_ref_einsatzdatum_typ

SELEct einsatzdatum_text
FROM t_vorschrift_ref_einsatzdatum_typ
WHERE einsatzdatum_text IS NOT NULL;



SELECT COUNT(einsatzdatum_text)
FROM t_vorschrift_ref_einsatzdatum_typ
WHERE einsatzdatum_text IS NULL;



SELECT COUNT(einsatzdatum_text)
FROM t_vorschrift_ref_einsatzdatum_typ
WHERE einsatzdatum_text = '';




desc t_vorschrift_ref_einsatzdatum_typ




# Page 25 tabel T_VORSCHRIFT_REF_VORSCHRIFT 


ALTER TABLE T_VORSCHRIFT_REF_VORSCHRIFT ADD Kommentar_Englisch VARCHAR2(1000 CHAR);



# Page 25 tabel T_VORSCHRIFT_REF_LAND 


ALTER TABLE T_VORSCHRIFT_REF_LAND ADD Bemerkung_Englisch VARCHAR2(4000 CHAR);



# Page 25 tabel T_VORSCHRIFT_REF_THEMA 


ALTER TABLE T_VORSCHRIFT_REF_THEMA ADD Bemerkung_Englisch VARCHAR2(4000 CHAR);




# Page 25 tabel T_THEMA 


ALTER TABLE t_thema RENAME COLUMN name_eng TO name_englisch;



ALTER TABLE t_thema 
MODIFY name_englisch VARCHAR2(256 CHAR);

ALTER TABLE t_thema RENAME COLUMN name_englisch TO BEZEICHNUNG_ENGLISCH;

desc t_thema


# Page 25 table T_LAND 


ALTER TABLE T_LAND ADD BesonderheitenMarkt_Englisch VARCHAR2(400 CHAR);



# view V_VORSCHRIFT_EQUAL


desc V_VORSCHRIFT_EQUAL


SELECT TEXT 
FROM ALL_VIEWS 
WHERE VIEW_NAME = 'V_VORSCHRIFT_EQUAL';

ALTER VIEW V_VORSCHRIFT_EQUAL ADD COLUMN land_eng VARCHAR2(4000);




#T_LAND Continent



desc t_land



ALTER TABLE t_land ADD (continent_eng VARCHAR2(50 CHAR));



UPDATE t_land SET continent_eng = 'Europe' WHERE KONTINENT = 'Europa';
UPDATE t_land SET continent_eng = 'Asia' WHERE KONTINENT = 'Asien';
UPDATE t_land SET continent_eng = 'South America' WHERE KONTINENT = 'Südamerika';
UPDATE t_land SET continent_eng = 'Africa' WHERE KONTINENT = 'Afrika';
UPDATE t_land SET continent_eng = 'North America' WHERE KONTINENT = 'Nordamerika';
UPDATE t_land SET continent_eng = 'Oceania' WHERE KONTINENT = 'Ozeanien';


--UPDATE t_land SET continent_eng = 'Unknown' WHERE KONTINENT IS NULL OR KONTINENT = '';



select distinct kontinent from t_land

SELECT LANDID, KONTINENT, continent_eng 
FROM t_land 
WHERE KONTINENT <> continent_eng OR 
      (KONTINENT IS NULL AND continent_eng IS NOT NULL) OR 
      (KONTINENT IS NOT NULL AND continent_eng IS NULL);



SELECT LANDID, LAND, LAND_ENG, KONTINENT, CONTINENT_ENG FROM T_LAND;


#t_thema bezeichnung


select BEZEICHNUNG from t_thema;


SELECT themaid, nummer, BEZEICHNUNG, name_eng 
FROM t_thema 
WHERE BEZEICHNUNG <> name_eng OR 
      (BEZEICHNUNG IS NULL AND name_eng IS NOT NULL) OR 
      (BEZEICHNUNG IS NOT NULL AND name_eng IS NULL);


#
Retrieves records from APEX_APPLICATION_TRANS_REPOS where APPLICATION_ID is 240 and the original and translated strings are identical.




SELECT
    FROM_STRING,
    TO_STRING
FROM
    APEX_APPLICATION_TRANS_REPOS
WHERE
    APPLICATION_ID = 118
    AND  DBMS_LOB.COMPARE(FROM_STRING, TO_STRING) = 0




# T_ET_B_AK 


ALTER TABLE T_ET_B_AK ADD name_eng VARCHAR2(250);


desc T_ET_B_AK

select count(*) from prod_t_thema

select count(*) from t_thema

where bezeichnung in (select bezeichnung from prod_t_thema)

UPDATE t_thema
SET name_eng = prod.name_eng
where t_thema.bezeichnung in (SELECT prod.name_eng
                FROM prod_t_thema prod
                WHERE t_thema.bezeichnung = prod.bezeichnung)




UPDATE t_thema t
SET name_eng = (SELECT prod.name_eng
                FROM prod_t_thema prod
                WHERE t.bezeichnung = prod.bezeichnung)
WHERE EXISTS (SELECT 1
              FROM prod_t_thema prod
              WHERE t.bezeichnung = prod.bezeichnung);



BEGIN 

FOR I IN (SELECT bezeichnung, name_eng FROM prod_t_thema) loop
update t_thema SET name_eng = i.name_eng where t_thema.bezeichnung = i.bezeichnung;
                
END loop;
END;


select count(*) from t_thema

SELECT T1.name_eng, t2.name_eng, t1.bezeichnung, t2.bezeichnung from t_thema t1, prod_t_thema t2 where t1.bezeichnung = t2.bezeichnung









   
   
# View V_VORSCHRIFT_EQUAL added land_eng



CREATE OR REPLACE FORCE EDITIONABLE VIEW "VORSCHRIFTEN_ADMIN"."V_VORSCHRIFT_EQUAL" ("LOCAL_VORSCHRIFT", "PERMALINK", "VORSCHRIFTID", "EQUAL_VORSCHRIFT", "PERMALINK_EQUAL", "VORSCHRIFTID_EQUAL", "LAND", "B_NUMMER", "AK_KURZ", "LAND_ENG") AS 
  with cte1 as(  Select  tv.vorschrift_nummer local_vorschrift,'https://apps1.web.audi.vwg/apexaudi-sp/apex-sp/f?p=REGINDEX:VORSCHRIFT::::25:P25_VORSCHRIFTID:'|| tv.vorschriftid as Permalink,tv.vorschriftid,
 tvl.vorschrift_nummer equal_vorschrift, 'https://apps1.web.audi.vwg/apexaudi-sp/apex-sp/f?p=REGINDEX:VORSCHRIFT::::25:P25_VORSCHRIFTID:'|| tvl.vorschriftid as Permalink_equal, tvl.vorschriftid vorschriftid_equal

from t_vorschrift_ref_vorschrift tr
join t_vorschrift tv on (tr.nachfolger_vorschriftid = tv.vorschriftid)
join t_vorschrift tvl on (tr.VORGAENGER_VORSCHRIFTID = tvl.vorschriftid)

where beziehung_art in (102))

Select t1."LOCAL_VORSCHRIFT",t1."PERMALINK",t1."VORSCHRIFTID",t1."EQUAL_VORSCHRIFT",t1."PERMALINK_EQUAL",t1."VORSCHRIFTID_EQUAL",
listagg(distinct tl.land,',') within group(order by b_nummer) as land,
LISTAGG(distinct tl.b_nummer,',') within group (order by tl.b_nummer) as b_nummer,
listagg(distinct ak.kurz,',') within group (order by ak.kurz) AK_Kurz,
listagg(distinct tl.land_eng,',') within group(order by b_nummer) as land_eng


from cte1 t1
left outer join t_vorschrift_ref_thema_ref_land tvrtl on (t1.vorschriftid= tvrtl.vorschriftid and tvrtl.geloescht =0)
left outer join t_land tl on (tvrtl.landid = tl.landid)
left outer join t_thema_ref_et_b_ak ttrak on (tvrtl.themaid = ttrak.themaid)
left outer join t_et_b_ak ak on (ttrak.et_b_akid = ak.et_b_akid)
group by t1.local_vorschrift,equal_vorschrift,Permalink,t1.vorschriftid,Permalink_equal,vorschriftid_equal;




# LIST AGG with separator ; semicolon and how we can use that in select statement and underline 



-- two or many records

r as (
  select v.vorschriftid vorschriftid, vrv.ist_Hauptverantwortlicher, listagg(vv.nachname || ', ' || vv.vorname, '; ') within group (order by vv.nachname) as verantwortlicher  
    from t_vorschrift v
    join t_vorschrift_ref_verantwortlicher vrv on (vrv.vorschriftid = v.vorschriftid)
    join t_verantwortlicher vv on (vv.verantwortlicherid = vrv.verantwortlicherid)
    group by v.vorschriftid, vrv.ist_Hauptverantwortlicher
),
select 
-- r.verantwortlicher,
CASE
    WHEN r.ist_Hauptverantwortlicher = 10 THEN '<span style="text-decoration: underline;">' || r.verantwortlicher || '</span>'
    ELSE r.verantwortlicher
END as verantwortlicher,

from t_vorschrift v
    join t_vorschrift_ref_verantwortlicher vrv on (vrv.vorschriftid = v.vorschriftid)
    join t_verantwortlicher vv on (vv.verantwortlicherid = vrv.verantwortlicherid)
--group by v.vorschriftid, vrv.ist_Hauptverantwortlicher


-- only one record

r as (
  select v.vorschriftid vorschriftid, 
  listagg(CASE WHEN vrv.IST_HAUPTVERANTWORTLICHER = 10 THEN 
  '<span style="text-decoration: underline;">' || vv.nachname || ', ' || vv.vorname || '</span>'
  ELSE vv.nachname || ', ' || vv.vorname END, '; ') WITHIN GROUP (ORDER BY vv.nachname) as verantwortlicher  
from 
t_vorschrift v
join 
t_vorschrift_ref_verantwortlicher vrv on vrv.vorschriftid = v.vorschriftid
join 
t_verantwortlicher vv on vv.verantwortlicherid = vrv.verantwortlicherid
group by 
v.vorschriftid

select 
r.verantwortlicher

from t_vorschrift v
    join t_vorschrift_ref_verantwortlicher vrv on (vrv.vorschriftid = v.vorschriftid)
    join t_verantwortlicher vv on (vv.verantwortlicherid = vrv.verantwortlicherid)
--group by v.vorschriftid, vrv.ist_Hauptverantwortlicher







#T_ANTRIEBSART 


desc T_ANTRIEBSART

ALTER TABLE T_ANTRIEBSART ADD NAME_ENG VARCHAR2(30 CHAR);


#T_SCHULUNG_TYP 



desc T_SCHULUNG_TYP

ALTER TABLE T_SCHULUNG_TYP ADD NAME_ENG VARCHAR2(100 CHAR);


#T_AUDIT_TYP 



desc T_AUDIT_TYP

ALTER TABLE T_AUDIT_TYP ADD NAME_ENG VARCHAR2(100 CHAR);



#T_VORSCHRIFT_TYP 




desc T_VORSCHRIFT_TYP

ALTER TABLE T_VORSCHRIFT_TYP ADD NAME_ENG VARCHAR2(100 CHAR);



# T_EINSATZDATUM_MODELL



desc T_EINSATZDATUM_MODELL

ALTER TABLE T_EINSATZDATUM_MODELL ADD Modell_ENG VARCHAR2(300 CHAR);



# T_KSU



desc T_KSU

ALTER TABLE T_KSU ADD name_eng VARCHAR2(250 CHAR);


select * from t_KSU



# V_TABLEAU_BASE 




  CREATE OR REPLACE FORCE EDITIONABLE VIEW "VORSCHRIFTEN_ADMIN"."V_TABLEAU_BASE" ("VORSCHRIFTNUMMER", "VORSCHRIFTTITEL", "VORSCHRIFTID", "VORSCHRIFTTYP", "LANDID", "IN_KRAFT", "NEUE_TYPEN", "NEUE_TYPEN_CKD", "NEUE_TYPEN_FBU", "ALLE_FZG", "ALLE_FZG_CKD", "ALLE_FZG_FBU", "ERSTELLUNG_DATUM", "AENDERUNGEN", "LAND", "LAND_ENG", "MFV_ID", "MFV_TYP", "AK_KURZ") AS 
  WITH vorschrift AS (
    SELECT
        vorschriftid,
        vorschrift_nummer,
        vorschrift_bezeichnung,
        prognose_qualitaet,
        jira_ticket,
        vorschrift_freigabestatusid,
        bemerkung,
        link_zur_vorschrift_dms,
        link_zur_vorschrift_getex,
        typschild,
        letzte_aenderung_datum,
        letzte_aenderung_benutzerid,
        websiteid,
        websitelink,
        einsatzdatum_modellid,
        tv.vorschrift_typid,
        tvt.bezeichnung vorschrifttyp,
        normid,
        ksuid,
        vorschrift_statusid
    FROM
        t_vorschrift       tv
        JOIN t_vorschrift_typ   tvt ON ( tv.vorschrift_typid = tvt.vorschrift_typid )
    WHERE
        vorschrift_statusid = 40
        AND prognose_qualitaet IN (
            10,
            20
        )
), vorschrift_aenderungen AS (
    SELECT
        vorschriftid,
        MIN(letzte_aenderung_datum) erstellung_datum,
        COUNT(h_vorschriftid) AS aenderungen
    FROM
        t_h_vorschrift
    GROUP BY
        vorschriftid
), mfvs as (
Select mfv_name as mfv_id, tmt.bezeichnung mfv_typ, tmrv.vorschriftid
from t_mfv tm
left outer join t_mfv_teil tmt on (tm.mfv_teilid = tmt.mfv_teilid )
join t_mfv_ref_vorschrift tmrv on (tm.mfvid = tmrv.mfvid)
),




vorschrift_ref_thema_land AS (
    SELECT
        vorschrift_ref_thema_ref_landid,
        vorschriftid,
        themaid,
        landid,
        geloescht
    FROM
        t_vorschrift_ref_thema_ref_land
    WHERE
        geloescht = 0
), vorschrift_ref_einsatzdatum_typ AS (
    SELECT
        vorschrift_ref_einsatzdatum_typid,
        vorschriftid,
        einsatzdatum_typid,
        einsatzdatum,
        einsatzdatum_text,
        letzte_aenderung_datum
    FROM
        t_vorschrift_ref_einsatzdatum_typ
), cte_datumsangaben AS (
    SELECT 
        v1.vorschrift_nummer   AS vorschriftnummer,
        v1.vorschrift_bezeichnung as vorschrifttitel,
        v1.vorschriftid,
        vorschrifttyp,
        vtl.landid,
        ed1.einsatzdatum       in_kraft,
        ed2.einsatzdatum       neue_typen,
        ed2_ckd.einsatzdatum   neue_typen_ckd,
        ed2_fbu.einsatzdatum   neue_typen_fbu,
        ed3.einsatzdatum       alle_fzg,
        ed3_ckd.einsatzdatum   alle_fzg_ckd,
        ed3_fbu.einsatzdatum   alle_fzg_fbu,
        va.erstellung_datum,
        va.aenderungen,
        tla.land ,
        tla.land_eng,
        mf.mfv_id,
        mf.mfv_typ,
        teba.kurz as AK_kurz
    FROM
        vorschrift                        v1
        LEFT OUTER JOIN vorschrift_ref_thema_land         vtl ON ( v1.vorschriftid = vtl.vorschriftid )
        LEFT OUTER JOIN t_land                            tla ON ( vtl.landid = tla.landid )
        LEFT OUTER JOIN t_thema                           tt ON ( vtl.themaid = tt.themaid )
        left outer join T_THEMA_REF_ET_B_AK ttrak on (tt.themaid = ttrak.themaid)
        left outer join t_et_b_ak teba on (ttrak.ET_B_AKID = teba.ET_B_AKID)
        LEFT OUTER JOIN vorschrift_ref_einsatzdatum_typ   vre ON ( v1.vorschriftid = vre.vorschriftid
                                                                 AND vre.einsatzdatum_typid = 1000 )
        LEFT OUTER JOIN vorschrift_ref_einsatzdatum_typ   ed1 ON ( ed1.vorschriftid = v1.vorschriftid
                                                                 AND ed1.einsatzdatum_typid = 1000 -- in kraft
                                                                  )
        LEFT OUTER JOIN vorschrift_ref_einsatzdatum_typ   ed2 ON ( ed2.vorschriftid = v1.vorschriftid
                                                                 AND ed2.einsatzdatum_typid IN (
            1010
        ) )
        LEFT OUTER JOIN vorschrift_ref_einsatzdatum_typ   ed2_ckd ON ( ed2_ckd.vorschriftid = v1.vorschriftid
                                                                     AND ed2_ckd.einsatzdatum_typid IN (
            1020
        ) )
        LEFT OUTER JOIN vorschrift_ref_einsatzdatum_typ   ed2_fbu ON ( ed2_fbu.vorschriftid = v1.vorschriftid
                                                                     AND ed2_fbu.einsatzdatum_typid IN (
            1022
        ) )
        LEFT OUTER JOIN vorschrift_ref_einsatzdatum_typ   ed3 ON ( ed3.vorschriftid = v1.vorschriftid
                                                                 AND ed3.einsatzdatum_typid IN (
            1011
        ) )
        LEFT OUTER JOIN vorschrift_ref_einsatzdatum_typ   ed3_ckd ON ( ed3_ckd.vorschriftid = v1.vorschriftid
                                                                     AND ed3_ckd.einsatzdatum_typid IN (
            1021
        ) )
        LEFT OUTER JOIN vorschrift_ref_einsatzdatum_typ   ed3_fbu ON ( ed3_fbu.vorschriftid = v1.vorschriftid
                                                                     AND ed3_fbu.einsatzdatum_typid IN (
            1023
        ) )
        LEFT OUTER JOIN vorschrift_aenderungen            va ON ( v1.vorschriftid = va.vorschriftid )
        left outer join mfvs mf on (v1.vorschriftid = mf.vorschriftid)
)
SELECT
    "VORSCHRIFTNUMMER","VORSCHRIFTTITEL","VORSCHRIFTID","VORSCHRIFTTYP","LANDID","IN_KRAFT","NEUE_TYPEN","NEUE_TYPEN_CKD","NEUE_TYPEN_FBU","ALLE_FZG","ALLE_FZG_CKD","ALLE_FZG_FBU","ERSTELLUNG_DATUM","AENDERUNGEN","LAND", "LAND_ENG", "MFV_ID","MFV_TYP", ak_kurz
FROM
    cte_datumsangaben;





# V_VORSCHRIFT_DEMANDS 



ALTER VIEW "VORSCHRIFTEN_ADMIN"."V_VORSCHRIFT_DEMANDS" COMPILE;





# -- This SQL creates a CTE to aggregate country numbers and names based on language preference, then joins with the T_NORM table to display Norm IDs, designations, and associated country details while excluding Norm ID 1016.




with cte_la as (
    select 
        normid,
        nvl(listagg(trim(la.b_nummer), ', ') within group (order by la.b_nummer),null) as laender_nummer,
        nvl(listagg(trim(CASE WHEN :FSP_LANGUAGE_PREFERENCE = 'de' THEN la.LAND ELSE la.LAND_ENG END), ', ') within group (order by la.LAND),null) as laender_name
    from t_norm_ref_land nrl
    left outer join t_land la on nrl.landid = la.landid
    group by normid
)
select 
    n.normid, 
    n.bezeichnung "BEZEICHNUNG",
    cte_la.laender_nummer "B_NUMMER",
    cte_la.laender_name "LAND"
from "#OWNER#"."T_NORM" n
left outer join cte_la on cte_la.normid = n.normid
where n.normid not in (1016)
order by n.BEZEICHNUNG asc;







# CSS inside SQL for colors 



case when FIRST_NAME_OLD <> FIRST_NAME_NEW 
                 OR(FIRST_NAME_OLD IS NOT NULL AND FIRST_NAME_NEW IS NULL)
                 OR(FIRST_NAME_OLD IS  NULL AND FIRST_NAME_NEW IS not NULL)
                     then 
       '<div class="green-background no-parent-padding">'||FIRST_NAME_NEW||'</div>'
       else '<font background-color=none>'||FIRST_NAME_NEW||'</font>' end FIRST_NAME_NEW ,


CREATE TABLE "VORSCHRIFTEN_ADMIN"."T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE" 
   (	"BILD_NUMMER_AUS_DOKU" VARCHAR2(26 BYTE), 
	"NUMMER" NUMBER(38,0), 
	"BEMERKUNG" VARCHAR2(500 BYTE), 
	"VERNETZUNGSART" VARCHAR2(26 BYTE), 
	"FAHRZEUGZULASSUNG" VARCHAR2(26 BYTE), 
	"FAHRZEUGKLASSE" VARCHAR2(26 BYTE), 
	"THEMENGEBIET" VARCHAR2(26 BYTE), 
	"LAND" VARCHAR2(128 BYTE), 
	"DATUMSANGABEN_ORIGINAL_VERNETZUNG" VARCHAR2(26 BYTE), 
	"VORSCHRIFTEN_TYP" VARCHAR2(26 BYTE), 
	"FBU_CKD_RELEVANTES_LAND" VARCHAR2(26 BYTE), 
	"PARAMETER_CKD_FBU_DATUM" VARCHAR2(26 BYTE), 
	"PARAMETER_MJ_DATUMSFORMAT" VARCHAR2(26 BYTE), 
	"SUPPLEMENT" VARCHAR2(26 BYTE), 
	"INTERNER_DB_STATUS" VARCHAR2(128 BYTE), 
	"STATUS" VARCHAR2(26 BYTE), 
	"PROGNOSE_QUALITAET" VARCHAR2(26 BYTE), 
	"IN_KRAFT_RELEVANT" VARCHAR2(26 BYTE), 
	"SOP_IST_VOR_DATUM_IN_KRAFT" VARCHAR2(26 BYTE), 
	"SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT" VARCHAR2(26 BYTE), 
	"NEUE_TYPEN_RELEVANT" VARCHAR2(26 BYTE), 
	"SOP_IST_VOR_DATUM_NEUE_TYPEN" VARCHAR2(26 BYTE), 
	"SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN" VARCHAR2(26 BYTE), 
	"ALLE_FAHRZEUGE_RELEVANT" VARCHAR2(26 BYTE), 
	"SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE" VARCHAR2(26 BYTE), 
	"SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_" VARCHAR2(26 BYTE), 
	"AUSSER_KRAFT_IST_LEER" VARCHAR2(26 BYTE), 
	"SOP_IST_VOR_DATUM_AUSSER_KRAFT" VARCHAR2(26 BYTE), 
	"SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT" VARCHAR2(26 BYTE), 
	"EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE" VARCHAR2(26 BYTE), 
	"EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE" VARCHAR2(26 BYTE), 
	"EOP_LIEGT_VOR_DATUM_IN_KRAFT" VARCHAR2(26 BYTE), 
	"EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT" VARCHAR2(26 BYTE), 
	"HOEHERE_SERIE_MOEGLICH" VARCHAR2(26 BYTE), 
	"KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION" VARCHAR2(26 BYTE), 
	"GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION" VARCHAR2(26 BYTE), 
	"SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS" VARCHAR2(26 BYTE), 
	"SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS" VARCHAR2(26 BYTE), 
	"EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS" VARCHAR2(26 BYTE), 
	"EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS" VARCHAR2(26 BYTE), 
	"NACHFOLGER_ANZEIGEN" VARCHAR2(26 BYTE), 
	"LESENDE_TABELLE_FUER_DATUMSANGABEN" VARCHAR2(26 BYTE), 
	"AUSGABE_FUER_ANDERES_TOOL_ODER_FUER_MENSCH" VARCHAR2(26 BYTE), 
	"AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE" VARCHAR2(26 BYTE), 
	"KEINE_AUSGABE_IN_DER_PROJEKTSPEZIFISCHEN_VORSCHRIFTEN_LISTE" VARCHAR2(26 BYTE), 
	"SOP_LIEGT_NACH_INKRAFTTRETEN_DER_VORSCHRIFT_UND_KANN_OPTIONAL_ALS_VERPFLICHTENDE_VORSCHRIFT_ANGEWENDET_WERDEN" VARCHAR2(26 BYTE), 
	"SOP_LIEGT_NACH_DEM_VORSCHRIFTEN_EINSATZTERMIN_FÜR_NEUE_TYPEN_VERPFLICHTENDER_EINSATZ" VARCHAR2(26 BYTE), 
	"EOP_LIEGT_NACH_EINSATZTERMIN_DER_VORSCHRIFT_FÜR_ALLE_FAHRZEUGE_VORSCHRIFT_IST_FÜR_ALTEN_TYP_VERPFLICHTEND" VARCHAR2(26 BYTE), 
	"SOP_LIEGT_NACH_DATUM_IN_KRAFT_DES_SUPPLEMENTS_UND_MUSS_ANGEWANDT_WERDEN" VARCHAR2(26 BYTE), 
	"EOP_NACH_DATUM_ALLE_FAHRZEUGE_ABER_SOP_VOR_DATUM_IN_KRAFT_UMSETZUNG_IN_DER_LAUFENDEN_SERIE_NÖTIG" VARCHAR2(26 BYTE), 
	"EOP_UND_SOP_LIEGT_NACH_INKRAFTTRETEN_DER_VORSCHRIFT_UND_KANN_OPTIONAL_ZUR_VERPFLICHTENDE_VORSCHRIFT_ANGEWENDET_WERDEN" VARCHAR2(26 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "VORSCHRIFTEN_DAT_OBJ" ;
  
  
  
  

  CREATE TABLE "VORSCHRIFTEN_ADMIN"."T_X_MS_PARAMETER_MODEL_YEAR" 
   (	"BILD_NUMMER_AUS_DOKU" VARCHAR2(26 BYTE), 
	"NUMMER" NUMBER(38,0), 
	"BEMERKUNG" VARCHAR2(500 BYTE), 
	"VERNETZUNGSART" VARCHAR2(26 BYTE), 
	"FAHRZEUGZULASSUNG" VARCHAR2(26 BYTE), 
	"FAHRZEUGKLASSE" VARCHAR2(26 BYTE), 
	"THEMENGEBIET" VARCHAR2(26 BYTE), 
	"LAND" VARCHAR2(26 BYTE), 
	"DATUMSANGABEN_ORIGINAL_VERNETZUNG" VARCHAR2(26 BYTE), 
	"VORSCHRIFTEN_TYP" VARCHAR2(26 BYTE), 
	"FBU_CKD_RELEVANTES_LAND" VARCHAR2(26 BYTE), 
	"PARAMETER_CKD_FBU_DATUM" VARCHAR2(26 BYTE), 
	"PARAMETER_MJ_DATUMSFORMAT" VARCHAR2(26 BYTE), 
	"QUELLVORSCHRIFT_GUELTIG" VARCHAR2(26 BYTE), 
	"INTERNER_DB_STATUS" VARCHAR2(128 BYTE), 
	"STATUS" VARCHAR2(26 BYTE), 
	"PROGNOSE_QUALITAET" VARCHAR2(26 BYTE), 
	"IN_KRAFT_RELEVANT" VARCHAR2(26 BYTE), 
	"SOP_IST_VOR_DATUM_IN_KRAFT" VARCHAR2(20 BYTE), 
	"SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT" VARCHAR2(26 BYTE), 
	"NEUE_TYPEN_RELEVANT" VARCHAR2(26 BYTE), 
	"SOP_IST_VOR_DATUM_NEUE_TYPEN" VARCHAR2(26 BYTE), 
	"SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN" VARCHAR2(26 BYTE), 
	"ALLE_FAHRZEUGE_RELEVANT" VARCHAR2(26 BYTE), 
	"SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE" VARCHAR2(26 BYTE), 
	"SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_" VARCHAR2(26 BYTE), 
	"SOP_IST_VOR_DATUM_AUSSER_KRAFT" VARCHAR2(26 BYTE), 
	"SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT" VARCHAR2(26 BYTE), 
	"EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE" VARCHAR2(26 BYTE), 
	"EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE" VARCHAR2(26 BYTE), 
	"EOP_LIEGT_VOR_DATUM_IN_KRAFT" VARCHAR2(26 BYTE), 
	"EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT" VARCHAR2(26 BYTE), 
	"HOEHERE_SERIE_MOEGLICH" VARCHAR2(26 BYTE), 
	"DECKELUNG_DER_HOEHEREN_SERIE" VARCHAR2(26 BYTE), 
	"SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS" VARCHAR2(26 BYTE), 
	"SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS" VARCHAR2(26 BYTE), 
	"EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS" VARCHAR2(26 BYTE), 
	"EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS" VARCHAR2(26 BYTE), 
	"NACHFOLGER_ANZEIGEN" VARCHAR2(26 BYTE), 
	"LESENDE_TABELLE_FUER_DATUMSANGABEN" VARCHAR2(26 BYTE), 
	"SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER" VARCHAR2(26 BYTE), 
	"SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_" VARCHAR2(26 BYTE), 
	"PHASE_IN_RELEVANT" VARCHAR2(26 BYTE), 
	"MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER" VARCHAR2(26 BYTE), 
	"MJ_SOP_NACH_PHASEIN_START" VARCHAR2(26 BYTE), 
	"MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER" VARCHAR2(26 BYTE), 
	"MJ_SOP_NACH_PHASEIN_END" VARCHAR2(26 BYTE), 
	"MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER" VARCHAR2(26 BYTE), 
	"MJ_EOP_NACH_PHASEIN_START" VARCHAR2(26 BYTE), 
	"PHASE_OUT_RELEVANT" VARCHAR2(26 BYTE), 
	"MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER" VARCHAR2(26 BYTE), 
	"MJ_EOP_NACH_PHASEIN_END" VARCHAR2(26 BYTE), 
	"MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT" VARCHAR2(26 BYTE), 
	"MJ_SOP_NACH_AUSSER_KRAFT" VARCHAR2(26 BYTE), 
	"MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR" VARCHAR2(26 BYTE), 
	"MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR" VARCHAR2(26 BYTE), 
	"MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR" VARCHAR2(26 BYTE), 
	"MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR" VARCHAR2(26 BYTE), 
	"MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR" VARCHAR2(26 BYTE), 
	"MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR" VARCHAR2(26 BYTE), 
	"AUSGABE_FÜR_ANDERES_TOOL_ODER_FÜR_MENSCH" VARCHAR2(26 BYTE), 
	"AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE" VARCHAR2(26 BYTE), 
	"KEINE_AUSGABE_IN_DER_PROJEKTSPEZIFISCHEN_VORSCHRIFTEN_LISTE" VARCHAR2(26 BYTE), 
	"SOP_LIEGT_NACH_INKRAFTTRETEN_DER_VORSCHRIFT_UND_KANN_OPTIONAL_ALS_VERPFLICHTENDE_VORSCHRIFT_ANGEWENDET_WERDEN" VARCHAR2(26 BYTE), 
	"SOP_LIEGT_NACH_DEM_VORSCHRIFTEN_EINSATZTERMIN_FÜR_NEUE_TYPEN_VERPFLICHTENDER_EINSATZ" VARCHAR2(26 BYTE), 
	"SOP_LIEGT_NACH_DEM_VORSCHRIFTEN_EINSATZTERMIN_ALLE_FAHRZEUGE_VORSCHRIFT_IST_VERPFLICHTEND_UMZUSETZEN" VARCHAR2(26 BYTE), 
	"EOP_LIEGT_NACH_EINSATZTERMIN_DER_VORSCHRIFT_FÜR_ALLE_FAHRZEUGE_VORSCHRIFT_IST_FÜR_ALTEN_TYP_VERPFLICHTEND" VARCHAR2(26 BYTE), 
	"SOP_LIEGT_NACH_DATUM_IN_KRAFT_DES_SUPPLEMENTS_UND_MUSS_ANGEWANDT_WERDEN" VARCHAR2(26 BYTE), 
	"EOP_NACH_DATUM_ALLE_FAHRZEUGE_ABER_SOP_VOR_DATUM_IN_KRAFT_UMSETZUNG_IN_DER_LAUFENDEN_SERIE_NÖTIG" VARCHAR2(26 BYTE), 
	"EOP_UND_SOP_LIEGT_NACH_INKRAFTTRETEN_DER_VORSCHRIFT_UND_KANN_OPTIONAL_ZUR_VERPFLICHTENDE_VORSCHRIFT_ANGEWENDET_WERDEN" VARCHAR2(26 BYTE), 
	"VORSCHRIFT_IST_VERPFLICHTEND_UMZUSETZEN_" VARCHAR2(26 BYTE), 
	"YES_ALL_VEHICLES_PRODUCED_AFTER_THE_PHASE_IN_END_MUST_BE_COMPLIANT" VARCHAR2(26 BYTE), 
	"YES_ALL_VEHICLES_PRODUCED_AFTER_THE_PHASE_IN_END_MUST_BE_COMPLIANT2" VARCHAR2(26 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "VORSCHRIFTEN_DAT_OBJ" ;








  CREATE TABLE "VORSCHRIFTEN_ADMIN"."T_MS_PARAMETER" 
   (	"MS_PARAMETERID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1000 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"NUMMER" NUMBER(38,0) NOT NULL ENABLE, 
	"BEMERKUNG" VARCHAR2(500 BYTE), 
	"VERNETZUNGSART" VARCHAR2(26 BYTE), 
	"FAHRZEUGZULASSUNG" VARCHAR2(26 BYTE), 
	"FAHRZEUGKLASSE" VARCHAR2(26 BYTE), 
	"THEMENGEBIET" VARCHAR2(26 BYTE), 
	"LAND" VARCHAR2(128 BYTE), 
	"DATUMSANGABEN_ORIGINAL_VERNETZUNG" VARCHAR2(26 BYTE), 
	"VORSCHRIFTEN_TYP" VARCHAR2(26 BYTE), 
	"FBU_CKD_RELEVANTES_LAND" VARCHAR2(26 BYTE), 
	"PARAMETER_CKD_FBU_DATUM" VARCHAR2(26 BYTE), 
	"QUELLVORSCHRIFT_GUELTIG" VARCHAR2(26 BYTE), 
	"SOP_IST_VOR_DATUM_IN_KRAFT" NUMBER(4,0), 
	"SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT" NUMBER(4,0), 
	"SOP_IST_VOR_DATUM_NEUE_TYPEN" NUMBER(4,0), 
	"SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN" NUMBER(4,0), 
	"SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE" NUMBER(4,0), 
	"SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_" NUMBER(4,0), 
	"SOP_IST_VOR_DATUM_AUSSER_KRAFT" NUMBER(4,0), 
	"SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT" NUMBER(4,0), 
	"EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE" NUMBER(4,0), 
	"EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE" NUMBER(4,0), 
	"EOP_LIEGT_VOR_DATUM_IN_KRAFT" NUMBER(4,0), 
	"EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT" NUMBER(4,0), 
	"HOEHERE_SERIE_MOEGLICH" NUMBER(4,0), 
	"DECKELUNG_DER_HOEHEREN_SERIE" NUMBER(4,0), 
	"SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS" NUMBER(4,0), 
	"SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS" NUMBER(4,0), 
	"EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS" NUMBER(4,0), 
	"EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS" NUMBER(4,0), 
	"NACHFOLGER_ANZEIGEN" NUMBER(4,0), 
	"LESENDE_TABELLE_FUER_DATUMSANGABEN" NUMBER(4,0), 
	"AUSGABE_FUER_ANDERES_TOOL_ODER_FUER_MENSCH" NUMBER(4,0), 
	"VERNETZUNGSARTID" NUMBER, 
	"INTERNER_DB_STATUS" NUMBER, 
	"STATUS" NUMBER, 
	"PROGNOSE_QUALITAET" NUMBER, 
	"SEARCH_MODE" NUMBER, 
	"PARAMETER_MJ_DATUMSFORMAT" NUMBER, 
	"MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR" NUMBER(4,0), 
	"MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR" NUMBER(4,0), 
	"MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR" NUMBER(4,0), 
	"MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR" NUMBER(4,0), 
	"MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR" NUMBER(4,0), 
	"MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR" NUMBER(4,0), 
	"SUPPLEMENT" NUMBER, 
	"AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE" NUMBER, 
	"MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER" NUMBER(4,0), 
	"MJ_SOP_NACH_PHASEIN_START" NUMBER(4,0), 
	"MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER" NUMBER(4,0), 
	"MJ_SOP_NACH_PHASEIN_END" NUMBER(4,0), 
	"MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER" NUMBER(4,0), 
	"MJ_EOP_NACH_PHASEIN_START" NUMBER(4,0), 
	"MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER" NUMBER(4,0), 
	"MJ_EOP_NACH_PHASEIN_END" NUMBER(4,0), 
	"MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT" NUMBER(4,0), 
	"MJ_SOP_NACH_AUSSER_KRAFT" NUMBER(4,0), 
	"IN_KRAFT_RELEVANT" NUMBER, 
	"NEUE_TYPEN_RELEVANT" NUMBER, 
	"ALLE_FAHRZEUGE_RELEVANT" NUMBER, 
	"PHASE_IN_RELEVANT" NUMBER, 
	"PHASE_OUT_RELEVANT" NUMBER, 
	"DATUM_MJ_STATUS" NUMBER, 
	"AUSSER_KRAFT_IST_LEER" VARCHAR2(50 BYTE), 
	"KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION" VARCHAR2(50 BYTE), 
	"GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION" VARCHAR2(50 BYTE), 
	"SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_" VARCHAR2(50 BYTE), 
	"SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER" VARCHAR2(50 BYTE));



















--delete from T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE;
--delete from T_X_MS_PARAMETER_MODEL_YEAR;


# T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE 




--select * from T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE;
--select * from T_X_MS_PARAMETER_MODEL_YEAR;

--select * from T_MS_PARAMETER;

UPDATE T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE
SET 
SOP_IST_VOR_DATUM_IN_KRAFT = DECODE(trim(upper(SOP_IST_VOR_DATUM_IN_KRAFT)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_VOR_DATUM_IN_KRAFT),

SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT = DECODE(trim(upper(SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT),

SOP_IST_VOR_DATUM_NEUE_TYPEN = DECODE(trim(upper(SOP_IST_VOR_DATUM_NEUE_TYPEN)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_VOR_DATUM_NEUE_TYPEN),

SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN = DECODE(trim(upper(SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN),

SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE = DECODE(trim(upper(SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE),

SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_ = DECODE(trim(upper(SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2,
    --trim(upper('fe')), 3, 
    SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_),

SOP_IST_VOR_DATUM_AUSSER_KRAFT = DECODE(trim(upper(SOP_IST_VOR_DATUM_AUSSER_KRAFT)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_VOR_DATUM_AUSSER_KRAFT),

SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT = DECODE(trim(upper(SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT),

EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE = DECODE(trim(upper(EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE),

EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE = DECODE(trim(upper(EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE),

EOP_LIEGT_VOR_DATUM_IN_KRAFT = DECODE(trim(upper(EOP_LIEGT_VOR_DATUM_IN_KRAFT)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    EOP_LIEGT_VOR_DATUM_IN_KRAFT),

EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT = DECODE(trim(upper(EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT),

NACHFOLGER_ANZEIGEN = DECODE(trim(upper(NACHFOLGER_ANZEIGEN)), 
    trim(upper('ja')), 1, 
    trim(upper('nein')), 0, 
    trim(upper('nicht relevant')), 2, 
    NACHFOLGER_ANZEIGEN),

HOEHERE_SERIE_MOEGLICH = DECODE(trim(upper(HOEHERE_SERIE_MOEGLICH)), 
    trim(upper('nein')), 0,
    trim(upper('ja')), 1,  
    trim(upper('nicht relevant')),  2,
    HOEHERE_SERIE_MOEGLICH),

SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS = DECODE(trim(upper(SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS),

SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS = DECODE(trim(upper(SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS),

EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS = DECODE(trim(upper(EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS),

EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS = DECODE(trim(upper(EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS),
--select distinct LESENDE_TABELLE_FUER_DATUMSANGABEN from T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE
--select distinct LESENDE_TABELLE_FUER_DATUMSANGABEN from T_MS_PARAMETER_date
LESENDE_TABELLE_FUER_DATUMSANGABEN = DECODE(trim(upper(LESENDE_TABELLE_FUER_DATUMSANGABEN)), 
    trim(upper('Vorschrift')), 1, 
    trim(upper('Vernetzungstabelle')), 2,  
    trim(upper('nicht relevant')), 0,  
    LESENDE_TABELLE_FUER_DATUMSANGABEN),

SUPPLEMENT = DECODE(trim(upper(SUPPLEMENT)), 
    trim(upper('ja')), 1, 
    trim(upper('nein')), 0,  
    trim(upper('nicht relevant')), 2,  
    SUPPLEMENT),
--select distinct INTERNER_DB_STATUS from T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE
INTERNER_DB_STATUS = DECODE(trim(upper(INTERNER_DB_STATUS)), 
    trim(upper('Sichtbar in Regulation Index DB')), 20, 
    trim(upper('nicht relevant für Audi AG; in Bearbeitung; Import is running')), 10,  
    trim(upper('nicht relevant')), 30,  
    INTERNER_DB_STATUS),
    

STATUS = DECODE(trim(upper(STATUS)), 
    trim(upper('Draft')), 20, 
    trim(upper('Enacted')), 40, 
    trim(upper('Final Document')), 30, 
    trim(upper('nicht relevant')), 50, 
    trim(upper('Draft, Final document')), 60, 
    STATUS),
    
PROGNOSE_QUALITAET = DECODE(trim(upper(PROGNOSE_QUALITAET)),
    trim(upper('offen')), 0,
    trim(upper('sicher')), 10,
    trim(upper('abschätzbar')), 20,
    trim(upper('bestätigt')), 30,
    trim(upper('nicht relevant')),40,
    trim(upper('leer')),50,
    trim(upper('abschätzbar, sicher')), 60,
    PROGNOSE_QUALITAET),

    --SELECT DISTINCT PROGNOSE_QUALITAET FROM T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE;


PARAMETER_MJ_DATUMSFORMAT = DECODE(trim(upper(PARAMETER_MJ_DATUMSFORMAT)), 
    trim(upper('Datum')), 10, 
    trim(upper('Jahreszahl')), 20, 
    trim(upper('nicht relevant')), 30, 
    PARAMETER_MJ_DATUMSFORMAT),

IN_KRAFT_RELEVANT = DECODE(trim(upper(IN_KRAFT_RELEVANT)), 
    trim(upper('existiert')), 10, -- relevant as existiert
    trim(upper('fehlt')), 0, -- nicht relevant as fehlt
    IN_KRAFT_RELEVANT),

NEUE_TYPEN_RELEVANT = DECODE(trim(upper(NEUE_TYPEN_RELEVANT)), 
    trim(upper('existiert')), 10, -- relevant as existiert
    trim(upper('fehlt')), 0, -- nicht relevant as fehlt
    NEUE_TYPEN_RELEVANT),

ALLE_FAHRZEUGE_RELEVANT = DECODE(trim(upper(ALLE_FAHRZEUGE_RELEVANT)), 
    trim(upper('existiert')), 10, -- relevant as existiert
    trim(upper('fehlt')), 0,  -- nicht relevant as fehlt
    ALLE_FAHRZEUGE_RELEVANT),

AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE = DECODE(trim(upper(AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE)),
    trim(upper('ja')), 1,
    trim(upper('nein')), 0, 
    --trim(upper('nicht relevant')), 2,  nicht relevant as null update
    AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE),

--select distinct KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION from T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE
--select distinct GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION from T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE
KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION = DECODE(trim(upper(KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION),

GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION = DECODE(trim(upper(GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2,
    GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION),
--select distinct AUSSER_KRAFT_IST_LEER from T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE

AUSSER_KRAFT_IST_LEER = DECODE(trim(upper(AUSSER_KRAFT_IST_LEER)),
     trim(upper('existiert')), 10, -- relevant as existiert
     trim(upper('fehlt')), 0, -- nicht relevant as fehlt
     AUSSER_KRAFT_IST_LEER),
 
 
ALLE_FAHRZEUGE_RELEVANT_EOP = DECODE(trim(upper(ALLE_FAHRZEUGE_RELEVANT_EOP)), 
    trim(upper('existiert')), 10, -- relevant as existiert
    trim(upper('fehlt')), 0, -- nicht relevant as fehlt
    ALLE_FAHRZEUGE_RELEVANT_EOP);
 
 
--select nummer, DECODE(trim(upper(AUSSER_KRAFT_IST_LEER)),
-- trim(upper('false')), 0,
-- trim(upper('true')), 1,
-- trim(upper('nicht relevant')), 2,
-- trim(upper('relevant')), 3,
-- AUSSER_KRAFT_IST_LEER) from T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE;
--
--
--select nummer,  DECODE(trim(upper(KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION)), 
--    trim(upper('false')), 0, 
--    trim(upper('true')), 1, 
--    trim(upper('nicht relevant')), 2, 
--    KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION) from T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE;
































# T_X_MS_PARAMETER_MODEL_YEAR 

--delete from T_X_MS_PARAMETER_MODEL_YEAR;

UPDATE T_X_MS_PARAMETER_MODEL_YEAR
SET 

SOP_IST_VOR_DATUM_IN_KRAFT = DECODE(trim(upper(SOP_IST_VOR_DATUM_IN_KRAFT)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_VOR_DATUM_IN_KRAFT),

SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT = DECODE(trim(upper(SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT),

SOP_IST_VOR_DATUM_NEUE_TYPEN = DECODE(trim(upper(SOP_IST_VOR_DATUM_NEUE_TYPEN)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_VOR_DATUM_NEUE_TYPEN),

SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN = DECODE(trim(upper(SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN),

SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE = DECODE(trim(upper(SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE),

SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_ = DECODE(trim(upper(SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_),

SOP_IST_VOR_DATUM_AUSSER_KRAFT = DECODE(trim(upper(SOP_IST_VOR_DATUM_AUSSER_KRAFT)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_VOR_DATUM_AUSSER_KRAFT),

SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT = DECODE(trim(upper(SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT),

EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE = DECODE(trim(upper(EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE),

EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE = DECODE(trim(upper(EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE),

EOP_LIEGT_VOR_DATUM_IN_KRAFT = DECODE(trim(upper(EOP_LIEGT_VOR_DATUM_IN_KRAFT)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    EOP_LIEGT_VOR_DATUM_IN_KRAFT),

EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT = DECODE(trim(upper(EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT),

NACHFOLGER_ANZEIGEN = DECODE(trim(upper(NACHFOLGER_ANZEIGEN)), 
    trim(upper('ja')), 1, 
    trim(upper('nein')), 0, 
    trim(upper('nicht relevant')), 2, 
    NACHFOLGER_ANZEIGEN),

HOEHERE_SERIE_MOEGLICH = DECODE(trim(upper(HOEHERE_SERIE_MOEGLICH)), 
    trim(upper('nein')), 0,
    trim(upper('ja')), 1,  
    trim(upper('nicht relevant')), 2,
    HOEHERE_SERIE_MOEGLICH), 

SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS = DECODE(trim(upper(SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS),

SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS = DECODE(trim(upper(SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS),

EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS = DECODE(trim(upper(EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS),

EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS = DECODE(trim(upper(EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS)), 
    trim(upper('false')), 0, 
    trim(upper('true')), 1, 
    trim(upper('nicht relevant')), 2, 
    EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS),

LESENDE_TABELLE_FUER_DATUMSANGABEN = DECODE(trim(upper(LESENDE_TABELLE_FUER_DATUMSANGABEN)), 
    trim(upper('ja')), 1, 
    trim(upper('nein')), 0,  
    trim(upper('nicht relevant')), 2,  
    LESENDE_TABELLE_FUER_DATUMSANGABEN),


--select distinct LESENDE_TABELLE_FUER_DATUMSANGABEN from T_X_MS_PARAMETER_MODEL_YEAR
INTERNER_DB_STATUS = DECODE(trim(upper(INTERNER_DB_STATUS)), 
    trim(upper('Sichtbar in Regulation Index DB')), 20, 
    trim(upper('nicht relevant für Audi AG; in Bearbeitung; Import is running')), 10,  
    trim(upper('nicht relevant')), 30,  
    INTERNER_DB_STATUS),

STATUS = DECODE(trim(upper(STATUS)), 
    trim(upper('Draft')), 20, 
    trim(upper('Enacted')), 40, 
    trim(upper('Final Document')), 30, 
    trim(upper('nicht relevant')), 50, 
    trim(upper('Draft, Final document')), 60, 
    STATUS),

--PROGNOSE_QUALITAET = DECODE(trim(upper(PROGNOSE_QUALITAET)),
--    trim(upper('offen')), 0,
--    trim(upper('sicher')), 10,
--    trim(upper('abschätzbar')), 20,
--    trim(upper('bestätigt')), 30,
--    trim(upper('nicht relevant')),40,
--    trim(upper('leer')),50,
--    PROGNOSE_QUALITAET),
    
    
--   SELECT DISTINCT PROGNOSE_QUALITAET FROM T_X_MS_PARAMETER_MODEL_YEAR;
 
    PROGNOSE_QUALITAET = DECODE(trim(upper(PROGNOSE_QUALITAET)),
    trim(upper('offen')), 0,
    trim(upper('sicher')), 10,
    trim(upper('abschätzbar')), 20,
    trim(upper('bestätigt')), 30,
    trim(upper('nicht relevant')),40,
    trim(upper('leer')),50,
    trim(upper('abschätzbar, sicher')), 60,
    PROGNOSE_QUALITAET),

PARAMETER_MJ_DATUMSFORMAT = DECODE(trim(upper(PARAMETER_MJ_DATUMSFORMAT)), 
    trim(upper('Datum')), 10, 
    trim(upper('Jahreszahl')), 20, 
    trim(upper('nicht relevant')), 30, 
    PARAMETER_MJ_DATUMSFORMAT),

IN_KRAFT_RELEVANT = DECODE(trim(upper(IN_KRAFT_RELEVANT)), 
    trim(upper('existiert')), 10, -- relevant as existiert
    trim(upper('fehlt')), 0, -- nicht relevant as fehlt
    IN_KRAFT_RELEVANT),


NEUE_TYPEN_RELEVANT = DECODE(trim(upper(NEUE_TYPEN_RELEVANT)), 
    trim(upper('existiert')), 10, -- relevant as existiert
    trim(upper('fehlt')), 0, -- nicht relevant as fehlt
    NEUE_TYPEN_RELEVANT),

ALLE_FAHRZEUGE_RELEVANT = DECODE(trim(upper(ALLE_FAHRZEUGE_RELEVANT)), 
    trim(upper('existiert')), 10, -- relevant as existiert
    trim(upper('fehlt')), 0,  -- nicht relevant as fehlt
    ALLE_FAHRZEUGE_RELEVANT),

   
MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER = DECODE(trim(upper(MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER)), trim(upper('false')), 0, trim(upper('true')), 1, trim(upper('nicht relevant')), 2, MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER),
MJ_SOP_NACH_PHASEIN_START = DECODE(trim(upper(MJ_SOP_NACH_PHASEIN_START)), trim(upper('false')), 0, trim(upper('true')), 1, trim(upper('nicht relevant')), 2, MJ_SOP_NACH_PHASEIN_START),
MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER = DECODE(trim(upper(MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER)), trim(upper('false')), 0, trim(upper('true')), 1, trim(upper('nicht relevant')), 2, MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER),
MJ_SOP_NACH_PHASEIN_END = DECODE(trim(upper(MJ_SOP_NACH_PHASEIN_END)), trim(upper('false')), 0, trim(upper('true')), 1, trim(upper('nicht relevant')), 2, MJ_SOP_NACH_PHASEIN_END),
MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER = DECODE(trim(upper(MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER)), trim(upper('false')), 0, trim(upper('true')), 1, trim(upper('nicht relevant')), 2, MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER),
MJ_EOP_NACH_PHASEIN_START = DECODE(trim(upper(MJ_EOP_NACH_PHASEIN_START)), trim(upper('false')), 0, trim(upper('true')), 1, trim(upper('nicht relevant')), 2, MJ_EOP_NACH_PHASEIN_START),
MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER = DECODE(trim(upper(MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER)), trim(upper('false')), 0, trim(upper('true')), 1, trim(upper('nicht relevant')), 2, MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER),
MJ_EOP_NACH_PHASEIN_END = DECODE(trim(upper(MJ_EOP_NACH_PHASEIN_END)), trim(upper('false')), 0, trim(upper('true')), 1, trim(upper('nicht relevant')), 2, MJ_EOP_NACH_PHASEIN_END),
MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT = DECODE(trim(upper(MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT)), trim(upper('false')), 0, trim(upper('true')), 1, trim(upper('nicht relevant')), 2, MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT),
MJ_SOP_NACH_AUSSER_KRAFT = DECODE(trim(upper(MJ_SOP_NACH_AUSSER_KRAFT)), trim(upper('false')), 0, trim(upper('true')), 1, trim(upper('nicht relevant')), 2, MJ_SOP_NACH_AUSSER_KRAFT),


PHASE_IN_RELEVANT = DECODE(TRIM(UPPER(PHASE_IN_RELEVANT)), 
        TRIM(UPPER('relevant')), 10,
        TRIM(UPPER('nicht relevant')), 0, 
        PHASE_IN_RELEVANT),
        
PHASE_OUT_RELEVANT = DECODE(TRIM(UPPER(PHASE_OUT_RELEVANT)), 
        TRIM(UPPER('relevant')), 10,
        TRIM(UPPER('nicht relevant')), 0, 
        PHASE_OUT_RELEVANT),
        
DECKELUNG_DER_HOEHEREN_SERIE = DECODE(TRIM(UPPER(DECKELUNG_DER_HOEHEREN_SERIE)), 
    TRIM(UPPER('Kleiner oder gleich "Letzte mögliche Vorschrift zur Homologation"')), 1, 
    TRIM(UPPER('Größer "Letzte mögliche Vorschrift zur Homologation"')), 2,
    TRIM(UPPER('nicht relevant')), 0,
    DECKELUNG_DER_HOEHEREN_SERIE),

    
MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR = DECODE(TRIM(UPPER(MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR)), 
    TRIM(UPPER('false')), 0, 
    TRIM(UPPER('true')), 1, 
    TRIM(UPPER('nicht relevant')), 2, 
    MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR),
--select distinct MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR from T_X_MS_PARAMETER_MODEL_YEAR
MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR = DECODE(TRIM(UPPER(MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR)), 
    TRIM(UPPER('false')), 0, 
    TRIM(UPPER('true')), 1, 
    TRIM(UPPER('nicht relevant')), 2, 
    TRIM(UPPER('serie')), 3,
    MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR),

MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR = DECODE(TRIM(UPPER(MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR)), 
    TRIM(UPPER('false')), 0, 
    TRIM(UPPER('true')), 1, 
    TRIM(UPPER('nicht relevant')), 2, 
    MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR),

MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR = DECODE(TRIM(UPPER(MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR)), 
    TRIM(UPPER('false')), 0, 
    TRIM(UPPER('true')), 1, 
    TRIM(UPPER('nicht relevant')), 2, 
    MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR),

MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR = DECODE(TRIM(UPPER(MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR)), 
    TRIM(UPPER('false')), 0, 
    TRIM(UPPER('true')), 1, 
    TRIM(UPPER('nicht relevant')), 2, 
    MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR),

MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR = DECODE(TRIM(UPPER(MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR)), 
    TRIM(UPPER('false')), 0, 
    TRIM(UPPER('true')), 1, 
    TRIM(UPPER('nicht relevant')), 2, 
    MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR),

AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE = DECODE(TRIM(UPPER(AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE)), 
    TRIM(UPPER('ja')), 1, 
    TRIM(UPPER('nein')), 0, 
    TRIM(UPPER('nicht relevant')), 2, 
    AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE),

SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER = DECODE(TRIM(UPPER(SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER)), 
        TRIM(UPPER('true')), 1, 
        TRIM(UPPER('false')), 0, 
        TRIM(UPPER('nicht relevant')), 2,
        TRIM(UPPER('Vorschrift')), 3, 
        SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER),
        
SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_ = DECODE(TRIM(UPPER(SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_)), 
        TRIM(UPPER('true')), 1, 
        TRIM(UPPER('false')), 0, 
        TRIM(UPPER('nicht relevant')), 2,
        TRIM(UPPER('Vorschrift')), 3, 
        SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_);


--SELECT SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER
--FROM T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE;
--
--
--SELECT SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_
--FROM T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE;
--
--
--SELECT SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER
--FROM T_X_MS_PARAMETER_MODEL_YEAR;
--
--
--SELECT SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_
--FROM T_X_MS_PARAMETER_MODEL_YEAR;
--
--
--SELECT SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER
--FROM T_MS_PARAMETER;
--
--
--SELECT SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_
--FROM T_MS_PARAMETER;

--SELECT 
--    nummer, DECODE(TRIM(UPPER(SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER)), 
--        TRIM(UPPER('true')), 1, 
--        TRIM(UPPER('false')), 0, 
--        TRIM(UPPER('nicht relevant')), 2,
--        TRIM(UPPER('Vorschrift')), 3, 
--        null)
--FROM T_X_MS_PARAMETER_MODEL_YEAR;

--
--UPDATE T_X_MS_PARAMETER_MODEL_YEAR
--SET
--SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER = DECODE(TRIM(UPPER(SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER)), 
--        TRIM(UPPER('true')), 1, 
--        TRIM(UPPER('false')), 0, 
--        TRIM(UPPER('nicht relevant')), 2,
--        TRIM(UPPER('Vorschrift')), 3, 
--        SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER);
    
--select distinct(SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER) from T_X_MS_PARAMETER_MODEL_YEAR
        
--SELECT 
--    DECODE(TRIM(UPPER(SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_)), 
--        TRIM(UPPER('true')), 1, 
--        TRIM(UPPER('false')), 0, 
--        TRIM(UPPER('nicht relevant')), 2, 
--        null)
--FROM T_X_MS_PARAMETER_MODEL_YEAR;

--select distinct(SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_) from T_X_MS_PARAMETER_MODEL_YEAR
 
--UPDATE T_X_MS_PARAMETER_MODEL_YEAR
--SET
--SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_ = DECODE(TRIM(UPPER(SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_)), 
--        TRIM(UPPER('true')), 1, 
--        TRIM(UPPER('false')), 0, 
--        TRIM(UPPER('nicht relevant')), 2,
--        TRIM(UPPER('Vorschrift')), 3, 
--        SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_);




--select AUSSER_KRAFT_IST_LEER,
--KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
--GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION from T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE
--
--select GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION
-- from T_X_MS_PARAMETER_MODEL_YEAR
-- 
-- KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
--GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION




--select SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER from T_X_MS_PARAMETER_MODEL_YEAR
--select SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_ from T_X_MS_PARAMETER_MODEL_YEAR
--
--
--UPDATE T_X_MS_PARAMETER_MODEL_YEAR
--SET
--SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER = (
--    SELECT DECODE(
--        trim(upper(SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER)), 
--        trim(upper('false')), 0, 
--        trim(upper('true')), 1, 
--        trim(upper('nicht relevant')), 2,
--        trim(upper('Vorschrift')), 3,
--        SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER
--    )
--    FROM T_X_MS_PARAMETER_MODEL_YEAR
--    WHERE ROWNUM = 1 -- This condition is used to update only one row; adjust as needed
--);
--














# MERGE WITH INSERT AND UPDATE

MERGE INTO T_MS_PARAMETER t
USING (
    SELECT distinct
    
    nvl(d.nummer, m.nummer) nummer,
    nvl(d.bemerkung, m.bemerkung) bemerkung,
    nvl(d.vernetzungsart, m.vernetzungsart) vernetzungsart,
    nvl(d.fahrzeugzulassung, m.fahrzeugzulassung) fahrzeugzulassung,
    nvl(d.fahrzeugklasse, m.fahrzeugklasse) fahrzeugklasse,
    nvl(d.themengebiet,  m.themengebiet) themengebiet,
    nvl(d.land, m.land) land,
    nvl(d.datumsangaben_original_vernetzung, m.datumsangaben_original_vernetzung) datumsangaben_original_vernetzung,
     nvl(d.vorschriften_typ, m.vorschriften_typ) vorschriften_typ,
     nvl(d.fbu_ckd_relevantes_land, m.fbu_ckd_relevantes_land) fbu_ckd_relevantes_land,
     nvl(d.parameter_ckd_fbu_datum, m.parameter_ckd_fbu_datum) parameter_ckd_fbu_datum,
     nvl(d.parameter_mj_datumsformat, m.parameter_mj_datumsformat) parameter_mj_datumsformat,
     d.supplement supplement,
     nvl(d.interner_db_status, m.interner_db_status) interner_db_status,
     nvl(d.status, m.status) status,
     nvl(d.prognose_qualitaet, m.prognose_qualitaet) prognose_qualitaet,
     nvl(d.in_kraft_relevant, m.in_kraft_relevant) in_kraft_relevant,
     nvl(d.sop_ist_vor_datum_in_kraft, m.sop_ist_vor_datum_in_kraft) sop_ist_vor_datum_in_kraft,
     nvl(d.sop_gleich_oder_nach_datum_in_kraft, m.sop_gleich_oder_nach_datum_in_kraft) sop_gleich_oder_nach_datum_in_kraft,
     nvl(d.neue_typen_relevant, m.neue_typen_relevant) neue_typen_relevant,
     nvl(d.sop_ist_vor_datum_neue_typen, m.sop_ist_vor_datum_neue_typen) sop_ist_vor_datum_neue_typen,
     nvl(d.sop_ist_nach_oder_gleich_datum_neue_typen, m.sop_ist_nach_oder_gleich_datum_neue_typen) sop_ist_nach_oder_gleich_datum_neue_typen,
     nvl(d.alle_fahrzeuge_relevant, m.alle_fahrzeuge_relevant) alle_fahrzeuge_relevant,
     nvl(d.sop_ist_vor_datum_alle_fahrzeuge, m.sop_ist_vor_datum_alle_fahrzeuge) sop_ist_vor_datum_alle_fahrzeuge,
     nvl(d.sop_ist_nach_oder_glecih_datum_alle_fahrzeuge_, m.sop_ist_nach_oder_glecih_datum_alle_fahrzeuge_) sop_ist_nach_oder_glecih_datum_alle_fahrzeuge_,
     nvl(d.sop_ist_vor_datum_ausser_kraft, m.sop_ist_vor_datum_ausser_kraft) sop_ist_vor_datum_ausser_kraft,
     nvl(d.sop_ist_nach_oder_gleich_datum_ausser_kraft, m.sop_ist_nach_oder_gleich_datum_ausser_kraft) sop_ist_nach_oder_gleich_datum_ausser_kraft,
     nvl(d.eop_liegt_vor_datum_alle_fahrzeuge, m.eop_liegt_vor_datum_alle_fahrzeuge) eop_liegt_vor_datum_alle_fahrzeuge,
     nvl(d.eop_liegt_nach_oder_gleich_datum_alle_fahrzeuge, m.eop_liegt_nach_oder_gleich_datum_alle_fahrzeuge) eop_liegt_nach_oder_gleich_datum_alle_fahrzeuge,
     nvl(d.eop_liegt_vor_datum_in_kraft, m.eop_liegt_vor_datum_in_kraft) eop_liegt_vor_datum_in_kraft,
     nvl(d.eop_liegt_nach_oder_gleich_datum_in_kraft, m.eop_liegt_nach_oder_gleich_datum_in_kraft) eop_liegt_nach_oder_gleich_datum_in_kraft,
     nvl(d.hoehere_serie_moeglich, m.hoehere_serie_moeglich) hoehere_serie_moeglich,
     nvl(d.sop_ist_vor_datum_in_kraft_des_nachfolgers, m.sop_ist_vor_datum_in_kraft_des_nachfolgers) sop_ist_vor_datum_in_kraft_des_nachfolgers,
     nvl(d.sop_ist_gleich_oder_nach_datum_in_kraft_des_nachfolgers, m.sop_ist_gleich_oder_nach_datum_in_kraft_des_nachfolgers) sop_ist_gleich_oder_nach_datum_in_kraft_des_nachfolgers,
     nvl(d.eop_ist_vor_datum_in_kraft_des_nachfolgers, m.eop_ist_vor_datum_in_kraft_des_nachfolgers) eop_ist_vor_datum_in_kraft_des_nachfolgers,
     nvl(d.eop_ist_gleich_oder_nach_datum_in_kraft_des_nachfolgers, m.eop_ist_gleich_oder_nach_datum_in_kraft_des_nachfolgers) eop_ist_gleich_oder_nach_datum_in_kraft_des_nachfolgers,
     nvl(d.nachfolger_anzeigen, m.nachfolger_anzeigen) nachfolger_anzeigen,
     nvl(d.lesende_tabelle_fuer_datumsangaben, m.lesende_tabelle_fuer_datumsangaben) lesende_tabelle_fuer_datumsangaben,
     
     
     
     d.ausgabe_fuer_anderes_tool_oder_fuer_mensch,
     nvl(d.ausgabe_der_vorschrift_bei_report_baureihe, m.ausgabe_der_vorschrift_bei_report_baureihe) ausgabe_der_vorschrift_bei_report_baureihe,
     m.quellvorschrift_gueltig,
     m.deckelung_der_hoeheren_serie,
     m.phase_in_relevant,
     m.mj_sop_vor_phasein_start_or_phasein_leer,
     m.mj_sop_nach_phasein_start,
     m.mj_sop_vor_phasein_end_or_phasein_leer,
     m.mj_sop_nach_phasein_end,
     m.mj_eop_vor_phasein_start_or_phasein_leer,
     m.mj_eop_nach_phasein_start,
     m.phase_out_relevant,
     m.mj_eop_vor_phasein_end_or_phasein_leer,
     m.mj_eop_nach_phasein_end,
     m.mj_sop_vor_oder_gleich_ausser_kraft,
     m.mj_sop_nach_ausser_kraft,
     m.mj_einsatz_jahr_kleiner_phasein_start_jahr,
     m.mj_einsatz_jahr_groesser_gleich_phasein_start_jahr,
     m.mj_einsatz_jahr_kleiner_phasein_ende_jahr,
     m.mj_einsatz_jahr_groesser_gleich_phasein_ende_jahr,
     m.mj_einsatz_jahr_kleiner_gleich_ausser_kraft_jahr,
     m.mj_einsatz_jahr_groesser_ausser_kraft_jahr,
     
     d.AUSSER_KRAFT_IST_LEER,
     d.KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
     d.GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
     
     m.SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER,
     m.SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_,
     d.ALLE_FAHRZEUGE_RELEVANT_EOP   -- newly added 
       
FROM
    T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE d
    FULL OUTER JOIN T_X_MS_PARAMETER_MODEL_YEAR m ON d.nummer = m.nummer where d.nummer is not null or m.nummer is not null
    
) s ON ( t.nummer = s.nummer and nvl(t.parameter_CKD_FBU_DATUM,0) = nvl(s.parameter_CKD_FBU_DATUM,0) )
WHEN MATCHED THEN UPDATE
SET 
    t.BEMERKUNG = s.BEMERKUNG,
    t.VERNETZUNGSART = s.VERNETZUNGSART,
    t.FAHRZEUGZULASSUNG = s.FAHRZEUGZULASSUNG,
    t.FAHRZEUGKLASSE = s.FAHRZEUGKLASSE,
    t.THEMENGEBIET = s.THEMENGEBIET,
     t.LAND = s.LAND,
t.datumsangaben_original_vernetzung = s.datumsangaben_original_vernetzung,
t.VORSCHRIFTEN_TYP = s.VORSCHRIFTEN_TYP,
t.FBU_CKD_RELEVANTES_LAND = s.FBU_CKD_RELEVANTES_LAND,
--t.PARAMETER_CKD_FBU_DATUM = s.PARAMETER_CKD_FBU_DATUM,
t.PARAMETER_MJ_DATUMSFORMAT = s.PARAMETER_MJ_DATUMSFORMAT,
     t.SUPPLEMENT = s.SUPPLEMENT,
     t.INTERNER_DB_STATUS = s.INTERNER_DB_STATUS,
     t.STATUS = s.STATUS,
     t.PROGNOSE_QUALITAET = s.PROGNOSE_QUALITAET,
     t.IN_KRAFT_RELEVANT = s.IN_KRAFT_RELEVANT,
     t.SOP_IST_VOR_DATUM_IN_KRAFT = s.SOP_IST_VOR_DATUM_IN_KRAFT,
     t.SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT = s.SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT,
     t.NEUE_TYPEN_RELEVANT = s.NEUE_TYPEN_RELEVANT,
     t.SOP_IST_VOR_DATUM_NEUE_TYPEN = s.SOP_IST_VOR_DATUM_NEUE_TYPEN,
     t.SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN = s.SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN,
     t.ALLE_FAHRZEUGE_RELEVANT = s.ALLE_FAHRZEUGE_RELEVANT,
     t.SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE = s.SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE,
     t.SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_ = s.SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_,
     t.SOP_IST_VOR_DATUM_AUSSER_KRAFT = s.SOP_IST_VOR_DATUM_AUSSER_KRAFT,
     t.SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT = s.SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT,
     t.EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE = s.EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE,
     t.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE = s.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE,
     t.EOP_LIEGT_VOR_DATUM_IN_KRAFT = s.EOP_LIEGT_VOR_DATUM_IN_KRAFT,
     t.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT = s.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT,
     t.HOEHERE_SERIE_MOEGLICH = s.HOEHERE_SERIE_MOEGLICH,
     t.SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS = s.SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS = s.SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS = s.EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS = s.EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.NACHFOLGER_ANZEIGEN = s.NACHFOLGER_ANZEIGEN,
     t.LESENDE_TABELLE_FUER_DATUMSANGABEN = s.LESENDE_TABELLE_FUER_DATUMSANGABEN,
     
     t.AUSGABE_FUER_ANDERES_TOOL_ODER_FUER_MENSCH = s.AUSGABE_FUER_ANDERES_TOOL_ODER_FUER_MENSCH,
     t.AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE = s.AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE,
     t.QUELLVORSCHRIFT_GUELTIG = s.QUELLVORSCHRIFT_GUELTIG,
     t.DECKELUNG_DER_HOEHEREN_SERIE = s.DECKELUNG_DER_HOEHEREN_SERIE,
     t.PHASE_IN_RELEVANT = s.PHASE_IN_RELEVANT,
     t.MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER = s.MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER,
     t.MJ_SOP_NACH_PHASEIN_START = s.MJ_SOP_NACH_PHASEIN_START,
     t.MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER = s.MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER,
     t.MJ_SOP_NACH_PHASEIN_END = s.MJ_SOP_NACH_PHASEIN_END,
     t.MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER = s.MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER,
     t.MJ_EOP_NACH_PHASEIN_START = s.MJ_EOP_NACH_PHASEIN_START,
     t.PHASE_OUT_RELEVANT = s.PHASE_OUT_RELEVANT,
     t.MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER = s.MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER,
     t.MJ_EOP_NACH_PHASEIN_END = s.MJ_EOP_NACH_PHASEIN_END,
     t.MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT = s.MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT,
     t.MJ_SOP_NACH_AUSSER_KRAFT = s.MJ_SOP_NACH_AUSSER_KRAFT,
     t.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR = s.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR,
     t.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR = s.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR,
     t.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR = s.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR,
     t.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR = s.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR,
     t.MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR = s.MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR,
     t.MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR = s.MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR,
     
     t.AUSSER_KRAFT_IST_LEER = s.AUSSER_KRAFT_IST_LEER,
     t.KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION = s.KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
     t.GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION = s.GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
     
     t.SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER = s.SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER,
     t.SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_ = s.SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_,
     t.ALLE_FAHRZEUGE_RELEVANT_EOP = s.ALLE_FAHRZEUGE_RELEVANT_EOP --  newly added
     
--WHERE
--    t.nummer =  s.nummer
WHEN NOT MATCHED THEN
INSERT ( 

    t.nummer, 
    t.BEMERKUNG,
    t.VERNETZUNGSART,
    t.FAHRZEUGZULASSUNG,
    t.FAHRZEUGKLASSE,
    t.THEMENGEBIET,
     t.LAND,
     t.DATUMSANGABEN_ORIGINAL_VERNETZUNG,
     t.VORSCHRIFTEN_TYP,
     t.FBU_CKD_RELEVANTES_LAND,
     t.PARAMETER_CKD_FBU_DATUM,
     t.PARAMETER_MJ_DATUMSFORMAT,
     t.SUPPLEMENT,
     t.INTERNER_DB_STATUS,
     t.STATUS,
     t.PROGNOSE_QUALITAET,
     t.IN_KRAFT_RELEVANT,
     t.SOP_IST_VOR_DATUM_IN_KRAFT,
     t.SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT,
     t.NEUE_TYPEN_RELEVANT,
     t.SOP_IST_VOR_DATUM_NEUE_TYPEN,
     t.SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN,
     t.ALLE_FAHRZEUGE_RELEVANT,
     t.SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE,
     t.SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_,
     t.SOP_IST_VOR_DATUM_AUSSER_KRAFT,
     t.SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT,
     t.EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE,
     t.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE,
     t.EOP_LIEGT_VOR_DATUM_IN_KRAFT,
     t.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT,
     t.HOEHERE_SERIE_MOEGLICH,
     t.SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.NACHFOLGER_ANZEIGEN,
     t.LESENDE_TABELLE_FUER_DATUMSANGABEN,
     
     t.AUSGABE_FUER_ANDERES_TOOL_ODER_FUER_MENSCH,
     t.AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE,
     t.QUELLVORSCHRIFT_GUELTIG,
     t.DECKELUNG_DER_HOEHEREN_SERIE,
     t.PHASE_IN_RELEVANT,
     t.MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER,
     t.MJ_SOP_NACH_PHASEIN_START,
     t.MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER,
     t.MJ_SOP_NACH_PHASEIN_END,
     t.MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER,
     t.MJ_EOP_NACH_PHASEIN_START,
     t.PHASE_OUT_RELEVANT,
     t.MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER,
     t.MJ_EOP_NACH_PHASEIN_END,
     t.MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT,
     t.MJ_SOP_NACH_AUSSER_KRAFT,
     t.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR,
     t.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR,
     t.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR,
     t.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR,
     t.MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR,
     t.MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR,
     
     t.AUSSER_KRAFT_IST_LEER,
     t.KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
     t.GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
     t.SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER,
     t.SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_,
     t.ALLE_FAHRZEUGE_RELEVANT_EOP   --  newly added
     )
 VALUES
     ( 
     s.nummer, 
     s.BEMERKUNG,
     s.VERNETZUNGSART,
     s.FAHRZEUGZULASSUNG,
     s.FAHRZEUGKLASSE,
     s.THEMENGEBIET,
     s.LAND,
     s.DATUMSANGABEN_ORIGINAL_VERNETZUNG,
     s.VORSCHRIFTEN_TYP,
     s.FBU_CKD_RELEVANTES_LAND,
     s.PARAMETER_CKD_FBU_DATUM,
     s.PARAMETER_MJ_DATUMSFORMAT,
     s.SUPPLEMENT,
     s.INTERNER_DB_STATUS,
     s.STATUS,
     s.PROGNOSE_QUALITAET,
     s.IN_KRAFT_RELEVANT,
     s.SOP_IST_VOR_DATUM_IN_KRAFT,
     s.SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT,
     s.NEUE_TYPEN_RELEVANT,
     s.SOP_IST_VOR_DATUM_NEUE_TYPEN,
     s.SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN,
     s.ALLE_FAHRZEUGE_RELEVANT,
     s.SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE,
     s.SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_,
     s.SOP_IST_VOR_DATUM_AUSSER_KRAFT,
     s.SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT,
     s.EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE,
     s.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE,
     s.EOP_LIEGT_VOR_DATUM_IN_KRAFT,
     s.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT,
     s.HOEHERE_SERIE_MOEGLICH,
     s.SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     s.SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     s.EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     s.EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     s.NACHFOLGER_ANZEIGEN,
     s.LESENDE_TABELLE_FUER_DATUMSANGABEN,
     
     s.AUSGABE_FUER_ANDERES_TOOL_ODER_FUER_MENSCH,
     s.AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE,
     s.QUELLVORSCHRIFT_GUELTIG,
     s.DECKELUNG_DER_HOEHEREN_SERIE,
     s.PHASE_IN_RELEVANT,
     s.MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER,
     s.MJ_SOP_NACH_PHASEIN_START,
     s.MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER,
     s.MJ_SOP_NACH_PHASEIN_END,
     s.MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER,
     s.MJ_EOP_NACH_PHASEIN_START,
     s.PHASE_OUT_RELEVANT,
     s.MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER,
     s.MJ_EOP_NACH_PHASEIN_END,
     s.MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT,
     s.MJ_SOP_NACH_AUSSER_KRAFT,
     s.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR,
     s.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR,
     s.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR,
     s.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR,
     s.MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR,
     s.MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR,
     
     s.AUSSER_KRAFT_IST_LEER,
     s.KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
     s.GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
     s.SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER,
     s.SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_,
     s.ALLE_FAHRZEUGE_RELEVANT_EOP --  newly added
    );
    




--select nummer, AUSSER_KRAFT_IST_LEER from T_MS_PARAMETER where AUSSER_KRAFT_IST_LEER = 30
--
--select AUSSER_KRAFT_IST_LEER from T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE







/* -- For each 'nummer' in the 'T_MS_PARAMETER' table, this query determines its 'datum_mj_status' as follows:
-- 1. If 'nummer' exists in both 'T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE' and 'T_X_MS_PARAMETER_MODEL_YEAR' tables, status is '3'.
-- 2. If 'nummer' exists only in 'T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE', status is '1'.
-- 3. If 'nummer' exists only in 'T_X_MS_PARAMETER_MODEL_YEAR', status is '2'.
-- 4. If 'nummer' doesn't exist in any of the two tables, status is NULL.
-- The result is ordered by 'nummer' and then by 'datum_mj_status'. */


/*
SELECT p.nummer, 
       CASE 
           WHEN EXISTS (SELECT 1 FROM T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE d,T_X_MS_PARAMETER_MODEL_YEAR y WHERE d.nummer = p.nummer and y.nummer=d.nummer) THEN 3
           WHEN EXISTS (SELECT 1 FROM T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE d WHERE d.nummer = p.nummer) THEN 1
           WHEN EXISTS (SELECT 1 FROM T_X_MS_PARAMETER_MODEL_YEAR y WHERE y.nummer = p.nummer) THEN 2
           ELSE datum_mj_status
       END AS datum_mj_status
FROM T_MS_PARAMETER p
order by nummer, datum_mj_status;
*/


--select datum_mj_status from t_ms_parameter;
UPDATE T_MS_PARAMETER p 
SET datum_mj_status = 
    CASE 
        WHEN EXISTS (SELECT 1 FROM T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE d, T_X_MS_PARAMETER_MODEL_YEAR y WHERE d.nummer = p.nummer AND y.nummer = d.nummer) THEN 3
        WHEN EXISTS (SELECT 1 FROM T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE d WHERE d.nummer = p.nummer) THEN 1
        WHEN EXISTS (SELECT 1 FROM T_X_MS_PARAMETER_MODEL_YEAR y WHERE y.nummer = p.nummer) THEN 2
        ELSE datum_mj_status
    END;










# This code dynamically updates For each specified column in T_MS_PARAMETER, update any NULL values to 30 
/*
DECLARE
    v_sql VARCHAR2(4000);
BEGIN
    FOR c IN (SELECT column_name 
              FROM all_tab_columns 
              WHERE table_name = 'T_MS_PARAMETER' 
              AND column_name IN (
                  'IN_KRAFT_RELEVANT',
                  'SOP_IST_VOR_DATUM_IN_KRAFT',
                  'SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT',
                  'NEUE_TYPEN_RELEVANT',
                  'SOP_IST_VOR_DATUM_NEUE_TYPEN',
                  'SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN',
                  'ALLE_FAHRZEUGE_RELEVANT',
                  'SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE',
                  'SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_',
                  'SOP_IST_VOR_DATUM_AUSSER_KRAFT',
                  'SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT',
                  'EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE',
                  'EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE',
                  'EOP_LIEGT_VOR_DATUM_IN_KRAFT',
                  'EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT',
                  'HOEHERE_SERIE_MOEGLICH',
                  'SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS',
                  'SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS',
                  'EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS',
                  'EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS',
                  'NACHFOLGER_ANZEIGEN',
                  'LESENDE_TABELLE_FUER_DATUMSANGABEN',
                  'AUSGABE_FUER_ANDERES_TOOL_ODER_FUER_MENSCH',
                  'AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE',
                  'QUELLVORSCHRIFT_GUELTIG',
                  'DECKELUNG_DER_HOEHEREN_SERIE',
                  'PHASE_IN_RELEVANT',
                  'MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER',
                  'MJ_SOP_NACH_PHASEIN_START',
                  'MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER',
                  'MJ_SOP_NACH_PHASEIN_END',
                  'MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER',
                  'MJ_EOP_NACH_PHASEIN_START',
                  'PHASE_OUT_RELEVANT',
                  'MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER',
                  'MJ_EOP_NACH_PHASEIN_END',
                  'MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT',
                  'MJ_SOP_NACH_AUSSER_KRAFT',
                  'MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR',
                  'MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR',
                  'MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR',
                  'MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR',
                  'MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR',
                  'MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR',
                  'PARAMETER_MJ_DATUMSFORMAT',
				  'AUSSER_KRAFT_IST_LEER',
                  'GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION',
                  'KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION',
                  'SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER',
                  'SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_',
                  'INTERNER_DB_STATUS',
                  'STATUS',
                  'SUPPLEMENT',
                  'PROGNOSE_QUALITAET'
              ))
    LOOP
        v_sql := 'UPDATE T_MS_PARAMETER SET ' || c.column_name || ' = 30 WHERE ' || c.column_name || ' IS NULL';
        EXECUTE IMMEDIATE v_sql;
    END LOOP;
    COMMIT; 
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/
*/


# This script updates specific columns in the T_MS_PARAMETER table to predefined values if they are NULL.

DECLARE
    v_sql VARCHAR2(4000);
    
    TYPE t_column_list IS TABLE OF VARCHAR2(100);
    
    v_columns_2 t_column_list := t_column_list(
        'SOP_IST_VOR_DATUM_IN_KRAFT',
        'SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT',
        'SOP_IST_VOR_DATUM_NEUE_TYPEN',
        'SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN',
        'SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE',
        'SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_',
        'SOP_IST_VOR_DATUM_AUSSER_KRAFT',
        'SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT',
        'EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE',
        'EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE',
        'EOP_LIEGT_VOR_DATUM_IN_KRAFT',
        'EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT',
        'HOEHERE_SERIE_MOEGLICH',
        'SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS',
        'SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS',
        'EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS',
        'EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS',
        'NACHFOLGER_ANZEIGEN',
        'AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE',
        'MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER',
        'MJ_SOP_NACH_PHASEIN_START',
        'MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER',
        'MJ_SOP_NACH_PHASEIN_END',
        'MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER',
        'MJ_EOP_NACH_PHASEIN_START',
        'MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER',
        'MJ_EOP_NACH_PHASEIN_END',
        'MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT',
        'MJ_SOP_NACH_AUSSER_KRAFT',
        'MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR',
        'MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR',
        'MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR',
        'MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR',
        'MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR',
        'MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR',
        'SUPPLEMENT',
        'AUSSER_KRAFT_IST_LEER',
        'GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION',
        'KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION',
        'SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER',
        'SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_'
    );
    
    v_columns_0 t_column_list := t_column_list(
        'IN_KRAFT_RELEVANT',
        'NEUE_TYPEN_RELEVANT',
        'ALLE_FAHRZEUGE_RELEVANT',
        'PHASE_IN_RELEVANT',
        'PHASE_OUT_RELEVANT',
        'LESENDE_TABELLE_FUER_DATUMSANGABEN',
        'DECKELUNG_DER_HOEHEREN_SERIE',
        'ALLE_FAHRZEUGE_RELEVANT_EOP'
    );
    
    v_columns_30 t_column_list := t_column_list(
        'INTERNER_DB_STATUS',
        'PARAMETER_MJ_DATUMSFORMAT'
    );
    
    v_columns_50 t_column_list := t_column_list(
        'STATUS'
    );
    
    v_columns_40 t_column_list := t_column_list(
        'PROGNOSE_QUALITAET'
    );
    
BEGIN
    FOR i IN 1..v_columns_2.COUNT LOOP
        v_sql := 'UPDATE T_MS_PARAMETER SET ' || v_columns_2(i) || ' = 2 WHERE ' || v_columns_2(i) || ' IS NULL';
        EXECUTE IMMEDIATE v_sql;
    END LOOP;
    
    FOR i IN 1..v_columns_0.COUNT LOOP
        v_sql := 'UPDATE T_MS_PARAMETER SET ' || v_columns_0(i) || ' = 0 WHERE ' || v_columns_0(i) || ' IS NULL';
        EXECUTE IMMEDIATE v_sql;
    END LOOP;
    
    FOR i IN 1..v_columns_30.COUNT LOOP
        v_sql := 'UPDATE T_MS_PARAMETER SET ' || v_columns_30(i) || ' = 30 WHERE ' || v_columns_30(i) || ' IS NULL';
        EXECUTE IMMEDIATE v_sql;
    END LOOP;
    
    FOR i IN 1..v_columns_50.COUNT LOOP
        v_sql := 'UPDATE T_MS_PARAMETER SET ' || v_columns_50(i) || ' = 50 WHERE ' || v_columns_50(i) || ' IS NULL';
        EXECUTE IMMEDIATE v_sql;
    END LOOP;
    
    FOR i IN 1..v_columns_40.COUNT LOOP
        v_sql := 'UPDATE T_MS_PARAMETER SET ' || v_columns_40(i) || ' = 40 WHERE ' || v_columns_40(i) || ' IS NULL';
        EXECUTE IMMEDIATE v_sql;
    END LOOP;

    COMMIT; 

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/



--/*NULL -> 2*/
--
--DECLARE
--    v_sql VARCHAR2(4000);
--BEGIN
--    FOR c IN (SELECT column_name 
--              FROM all_tab_columns 
--              WHERE table_name = 'T_MS_PARAMETER' 
--              AND column_name IN (
--                
--                  'SOP_IST_VOR_DATUM_IN_KRAFT',
--                  'SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT',
--            
--                  'SOP_IST_VOR_DATUM_NEUE_TYPEN',
--                  'SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN',
--                  
--                  'SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE',
--                  'SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_',
--                  'SOP_IST_VOR_DATUM_AUSSER_KRAFT',
--                  'SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT',
--                  'EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE',
--                  'EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE',
--                  'EOP_LIEGT_VOR_DATUM_IN_KRAFT',
--                  'EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT',
--                  'HOEHERE_SERIE_MOEGLICH',
--                  'SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS',
--                  'SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS',
--                  'EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS',
--                  'EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS',
--                  'NACHFOLGER_ANZEIGEN',
--
--                  'AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE',
--                  
--                  'MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER',
--                  'MJ_SOP_NACH_PHASEIN_START',
--                  'MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER',
--                  'MJ_SOP_NACH_PHASEIN_END',
--                  'MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER',
--                  'MJ_EOP_NACH_PHASEIN_START',
--                  
--                  'MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER',
--                  'MJ_EOP_NACH_PHASEIN_END',
--                  'MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT',
--                  'MJ_SOP_NACH_AUSSER_KRAFT',
--                  'MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR',
--                  'MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR',
--                  'MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR',
--                  'MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR',
--                  'MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR',
--                  'MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR',
--                  
--                  
--                  'SUPPLEMENT',
--                  'AUSSER_KRAFT_IST_LEER',
--                  'GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION',
--                  'KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION',
--                  'SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER',
--                  'SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_'
--                  
--              ))
--    LOOP
--        v_sql := 'UPDATE T_MS_PARAMETER SET ' || c.column_name || ' = 2 WHERE ' || c.column_name || ' IS NULL';
--        EXECUTE IMMEDIATE v_sql;
--    END LOOP;
--    COMMIT; 
--EXCEPTION
--    WHEN OTHERS THEN
--        ROLLBACK;
--        RAISE;
--END;
--/


--/*NULL -> 0*/
--DECLARE
--    v_sql VARCHAR2(4000);
--BEGIN
--    FOR c IN (SELECT column_name 
--              FROM all_tab_columns 
--              WHERE table_name = 'T_MS_PARAMETER' 
--              AND column_name IN (
--                
--                  'IN_KRAFT_RELEVANT',
--                  
--                  'NEUE_TYPEN_RELEVANT',
--                  
--                  'ALLE_FAHRZEUGE_RELEVANT',
--                  
--                  'PHASE_IN_RELEVANT',
--                  
--                  'PHASE_OUT_RELEVANT',
--                   'LESENDE_TABELLE_FUER_DATUMSANGABEN',
--                   'DECKELUNG_DER_HOEHEREN_SERIE',
--                   
--                   'DECKELUNG_DER_HOEHEREN_SERIE'
--                  
--                  
--                  
--                  
--              ))
--    LOOP
--        v_sql := 'UPDATE T_MS_PARAMETER SET ' || c.column_name || ' = 0 WHERE ' || c.column_name || ' IS NULL';
--        EXECUTE IMMEDIATE v_sql;
--    END LOOP;
--    COMMIT; 
--EXCEPTION
--    WHEN OTHERS THEN
--        ROLLBACK;
--        RAISE;
--END;
--/
--
--
--/*NULL -> 30*/
--
--
--DECLARE
--    v_sql VARCHAR2(4000);
--BEGIN
--    FOR c IN (SELECT column_name 
--              FROM all_tab_columns 
--              WHERE table_name = 'T_MS_PARAMETER' 
--              AND column_name IN (
--                
--                 'INTERNER_DB_STATUS', 
--                 'PARAMETER_MJ_DATUMSFORMAT'
--                  
--                  
--                  
--              ))
--    LOOP
--        v_sql := 'UPDATE T_MS_PARAMETER SET ' || c.column_name || ' = 30 WHERE ' || c.column_name || ' IS NULL';
--        EXECUTE IMMEDIATE v_sql;
--    END LOOP;
--    COMMIT; 
--EXCEPTION
--    WHEN OTHERS THEN
--        ROLLBACK;
--        RAISE;
--END;
--/
--
--
--
--/*NULL -> 50*/
--
--DECLARE
--    v_sql VARCHAR2(4000);
--BEGIN
--    FOR c IN (SELECT column_name 
--              FROM all_tab_columns 
--              WHERE table_name = 'T_MS_PARAMETER' 
--              AND column_name IN (
--                
--                 'STATUS'
--                  
--                  
--                  
--              ))
--    LOOP
--        v_sql := 'UPDATE T_MS_PARAMETER SET ' || c.column_name || ' = 50 WHERE ' || c.column_name || ' IS NULL';
--        EXECUTE IMMEDIATE v_sql;
--    END LOOP;
--    COMMIT; 
--EXCEPTION
--    WHEN OTHERS THEN
--        ROLLBACK;
--        RAISE;
--END;
--/
--
--
--
--
--/*NULL -> 40*/
--
--
--DECLARE
--    v_sql VARCHAR2(4000);
--BEGIN
--    FOR c IN (SELECT column_name 
--              FROM all_tab_columns 
--              WHERE table_name = 'T_MS_PARAMETER' 
--              AND column_name IN (
--                
--                 'PROGNOSE_QUALITAET'
--                  
--                  
--                  
--              ))
--    LOOP
--        v_sql := 'UPDATE T_MS_PARAMETER SET ' || c.column_name || ' = 40 WHERE ' || c.column_name || ' IS NULL';
--        EXECUTE IMMEDIATE v_sql;
--    END LOOP;
--    COMMIT; 
--EXCEPTION
--    WHEN OTHERS THEN
--        ROLLBACK;
--        RAISE;
--END;
--/


--30 -> null
--
--UPDATE T_MS_PARAMETER
--SET QUELLVORSCHRIFT_GUELTIG = NULL
--WHERE QUELLVORSCHRIFT_GUELTIG = '30';

--UPDATE T_MS_PARAMETER
--SET AUSGABE_FUER_ANDERES_TOOL_ODER_FUER_MENSCH = NULL
--WHERE AUSGABE_FUER_ANDERES_TOOL_ODER_FUER_MENSCH = '30';


--desc T_MS_PARAMETER

--select INTERNER_DB_STATUS from T_MS_PARAMETER
--
--
--
--
--
--ALTER TABLE T_MS_PARAMETER
--ADD AUSSER_KRAFT_IST_LEER VARCHAR2(50);
--select AUSSER_KRAFT_IST_LEER from T_MS_PARAMETER
--
--select KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION from T_MS_PARAMETER
--
--select GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION from T_MS_PARAMETER
--
--ALTER TABLE T_MS_PARAMETER
--ADD KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION VARCHAR2(50),
--    GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION VARCHAR2(50);
--
--ALTER TABLE T_MS_PARAMETER
--ADD AUSSER_KRAFT_IST_LEER VARCHAR2(50);
--
---- Add the first column
--ALTER TABLE T_MS_PARAMETER
--ADD KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION VARCHAR2(50);
--
---- Add the second column
--ALTER TABLE T_MS_PARAMETER
--ADD GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION VARCHAR2(50);
--
--
---- Add the first column
--ALTER TABLE T_MS_PARAMETER
--ADD SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_ VARCHAR2(50);
--
---- Add the second column
--ALTER TABLE T_MS_PARAMETER
--ADD SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER VARCHAR2(50);
--
--
--
--/* Delete a record and child record */
--
--select * from T_MS_PARAMETER where nummer = 99;
--
--select * from t_ms_parameter_ref_ausgabe where ms_parameterid = 1042;
--
--delete from T_MS_PARAMETER where nummer = 99;
--
--delete from t_ms_parameter_ref_ausgabe where ms_parameterid = 1042;
--
--
--select * from T_MS_PARAMETER where nummer = 199;
--
--select * from t_ms_parameter_ref_ausgabe where ms_parameterid = 1073;
--
--delete from T_MS_PARAMETER where nummer = 199;
--
--delete from t_ms_parameter_ref_ausgabe where ms_parameterid = 10;
--
--
--SELECT * FROM T_MS_PARAMETER WHERE nummer IN (99, 199);
--
--delete FROM T_MS_PARAMETER WHERE nummer IN (1042, 1073);

















-- Rows in t_ms_parameter_old but not in t_ms_parameter
SELECT olde.NUMMER
FROM t_ms_parameter AS olde
LEFT JOIN t_ms_parameter AS newe ON olde.NUMMER = newe.NUMMER
WHERE newe.NUMMER IS NULL;

-- Rows in t_ms_parameter but not in t_ms_parameter_old
SELECT new.NUMMER
FROM t_ms_parameter AS new
LEFT JOIN t_ms_parameter AS old ON new.NUMMER = old.NUMMER
WHERE old.NUMMER IS NULL;


-- common rows
SELECT old.NUMMER
FROM t_ms_parameter AS old
INNER JOIN t_ms_parameter AS new ON old.NUMMER = new.NUMMER;


-- new rows
SELECT 
    CASE 
        WHEN old.NUMMER IS NULL THEN 'New in t_ms_parameter'
        WHEN new.NUMMER IS NULL THEN 'New in t_ms_parameter_old'
    END AS Source,
    COALESCE(old.NUMMER, new.NUMMER) AS NUMMER
FROM t_ms_parameter AS old
FULL OUTER JOIN t_ms_parameter AS new ON old.NUMMER = new.NUMMER
WHERE old.NUMMER IS NULL OR new.NUMMER IS NULL;



-- common rows
SELECT pnew.NUMMER
FROM t_ms_parameter pnew
where pnew.NUMMER not in (select NUMMER from t_ms_parameter)




INSERT into t_ms_parameter t ( 
    t.nummer, 
    t.BEMERKUNG,
    t.VERNETZUNGSART,
    t.FAHRZEUGZULASSUNG,
    t.FAHRZEUGKLASSE,
    t.THEMENGEBIET,
     t.LAND,
     t.DATUMSANGABEN_ORIGINAL_VERNETZUNG,
     t.VORSCHRIFTEN_TYP,
     t.FBU_CKD_RELEVANTES_LAND,
     t.PARAMETER_CKD_FBU_DATUM,
     t.PARAMETER_MJ_DATUMSFORMAT,
     t.SUPPLEMENT,
     t.INTERNER_DB_STATUS,
     t.STATUS,
     t.PROGNOSE_QUALITAET,
     t.IN_KRAFT_RELEVANT,
     t.SOP_IST_VOR_DATUM_IN_KRAFT,
     t.SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT,
     t.NEUE_TYPEN_RELEVANT,
     t.SOP_IST_VOR_DATUM_NEUE_TYPEN,
     t.SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN,
     t.ALLE_FAHRZEUGE_RELEVANT,
     t.SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE,
     t.SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_,
     t.SOP_IST_VOR_DATUM_AUSSER_KRAFT,
     t.SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT,
     t.EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE,
     t.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE,
     t.EOP_LIEGT_VOR_DATUM_IN_KRAFT,
     t.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT,
     t.HOEHERE_SERIE_MOEGLICH,
     t.SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.NACHFOLGER_ANZEIGEN,
     t.LESENDE_TABELLE_FUER_DATUMSANGABEN,
     
     t.AUSGABE_FUER_ANDERES_TOOL_ODER_FUER_MENSCH,
     t.AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE,
     t.QUELLVORSCHRIFT_GUELTIG,
     t.DECKELUNG_DER_HOEHEREN_SERIE,
     t.PHASE_IN_RELEVANT,
     t.MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER,
     t.MJ_SOP_NACH_PHASEIN_START,
     t.MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER,
     t.MJ_SOP_NACH_PHASEIN_END,
     t.MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER,
     t.MJ_EOP_NACH_PHASEIN_START,
     t.PHASE_OUT_RELEVANT,
     t.MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER,
     t.MJ_EOP_NACH_PHASEIN_END,
     t.MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT,
     t.MJ_SOP_NACH_AUSSER_KRAFT,
     t.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR,
     t.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR,
     t.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR,
     t.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR,
     t.MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR,
     t.MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR,
     
     t.AUSSER_KRAFT_IST_LEER,
     t.KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
     t.GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
     t.SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER,
     t.SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_ 
     )
     ( select 
     s.nummer, 
     s.BEMERKUNG,
     s.VERNETZUNGSART,
     s.FAHRZEUGZULASSUNG,
     s.FAHRZEUGKLASSE,
     s.THEMENGEBIET,
     s.LAND,
     s.DATUMSANGABEN_ORIGINAL_VERNETZUNG,
     s.VORSCHRIFTEN_TYP,
     s.FBU_CKD_RELEVANTES_LAND,
     s.PARAMETER_CKD_FBU_DATUM,
     s.PARAMETER_MJ_DATUMSFORMAT,
     s.SUPPLEMENT,
     s.INTERNER_DB_STATUS,
     s.STATUS,
     s.PROGNOSE_QUALITAET,
     s.IN_KRAFT_RELEVANT,
     s.SOP_IST_VOR_DATUM_IN_KRAFT,
     s.SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT,
     s.NEUE_TYPEN_RELEVANT,
     s.SOP_IST_VOR_DATUM_NEUE_TYPEN,
     s.SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN,
     s.ALLE_FAHRZEUGE_RELEVANT,
     s.SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE,
     s.SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_,
     s.SOP_IST_VOR_DATUM_AUSSER_KRAFT,
     s.SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT,
     s.EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE,
     s.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE,
     s.EOP_LIEGT_VOR_DATUM_IN_KRAFT,
     s.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT,
     s.HOEHERE_SERIE_MOEGLICH,
     s.SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     s.SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     s.EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     s.EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     s.NACHFOLGER_ANZEIGEN,
     s.LESENDE_TABELLE_FUER_DATUMSANGABEN,
     
     s.AUSGABE_FUER_ANDERES_TOOL_ODER_FUER_MENSCH,
     s.AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE,
     s.QUELLVORSCHRIFT_GUELTIG,
     s.DECKELUNG_DER_HOEHEREN_SERIE,
     s.PHASE_IN_RELEVANT,
     s.MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER,
     s.MJ_SOP_NACH_PHASEIN_START,
     s.MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER,
     s.MJ_SOP_NACH_PHASEIN_END,
     s.MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER,
     s.MJ_EOP_NACH_PHASEIN_START,
     s.PHASE_OUT_RELEVANT,
     s.MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER,
     s.MJ_EOP_NACH_PHASEIN_END,
     s.MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT,
     s.MJ_SOP_NACH_AUSSER_KRAFT,
     s.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR,
     s.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR,
     s.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR,
     s.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR,
     s.MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR,
     s.MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR,
     
     s.AUSSER_KRAFT_IST_LEER,
     s.KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
     s.GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
     s.SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER,
     s.SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_ 
     from t_ms_parameter s
     where s.NUMMER not in (select NUMMER from t_ms_parameter)
    );
    
    
    
    
    
    select count(*) from t_ms_parameter;    -- before insert count - 163  -- after insert count - 166
    
    
     
  select count(*) from t_ms_parameter;  -- 102


-- delete

SELECT count(*)
FROM t_ms_parameter olde
where olde.NUMMER not in (select NUMMER from t_ms_parameter);

delete
FROM t_ms_parameter olde
where olde.NUMMER not in (select NUMMER from t_ms_parameter);



select * from t_ms_parameter where nummer not in (select nummer from t_ms_parameter);

begin

for s in (select * from t_ms_parameter) loop

update t_ms_parameter t SET 
    t.BEMERKUNG = s.BEMERKUNG,
    t.VERNETZUNGSART = s.VERNETZUNGSART,
    t.FAHRZEUGZULASSUNG = s.FAHRZEUGZULASSUNG,
    t.FAHRZEUGKLASSE = s.FAHRZEUGKLASSE,
    t.THEMENGEBIET = s.THEMENGEBIET,
     t.LAND = s.LAND,
t.datumsangaben_original_vernetzung = s.datumsangaben_original_vernetzung,
t.VORSCHRIFTEN_TYP = s.VORSCHRIFTEN_TYP,
t.FBU_CKD_RELEVANTES_LAND = s.FBU_CKD_RELEVANTES_LAND,
--t.PARAMETER_CKD_FBU_DATUM = s.PARAMETER_CKD_FBU_DATUM,
t.PARAMETER_MJ_DATUMSFORMAT = s.PARAMETER_MJ_DATUMSFORMAT,
     t.SUPPLEMENT = s.SUPPLEMENT,
     t.INTERNER_DB_STATUS = s.INTERNER_DB_STATUS,
     t.STATUS = s.STATUS,
     t.PROGNOSE_QUALITAET = s.PROGNOSE_QUALITAET,
     t.IN_KRAFT_RELEVANT = s.IN_KRAFT_RELEVANT,
     t.SOP_IST_VOR_DATUM_IN_KRAFT = s.SOP_IST_VOR_DATUM_IN_KRAFT,
     t.SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT = s.SOP_GLEICH_ODER_NACH_DATUM_IN_KRAFT,
     t.NEUE_TYPEN_RELEVANT = s.NEUE_TYPEN_RELEVANT,
     t.SOP_IST_VOR_DATUM_NEUE_TYPEN = s.SOP_IST_VOR_DATUM_NEUE_TYPEN,
     t.SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN = s.SOP_IST_NACH_ODER_GLEICH_DATUM_NEUE_TYPEN,
     t.ALLE_FAHRZEUGE_RELEVANT = s.ALLE_FAHRZEUGE_RELEVANT,
     t.SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE = s.SOP_IST_VOR_DATUM_ALLE_FAHRZEUGE,
     t.SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_ = s.SOP_IST_NACH_ODER_GLECIH_DATUM_ALLE_FAHRZEUGE_,
     t.SOP_IST_VOR_DATUM_AUSSER_KRAFT = s.SOP_IST_VOR_DATUM_AUSSER_KRAFT,
     t.SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT = s.SOP_IST_NACH_ODER_GLEICH_DATUM_AUSSER_KRAFT,
     t.EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE = s.EOP_LIEGT_VOR_DATUM_ALLE_FAHRZEUGE,
     t.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE = s.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_ALLE_FAHRZEUGE,
     t.EOP_LIEGT_VOR_DATUM_IN_KRAFT = s.EOP_LIEGT_VOR_DATUM_IN_KRAFT,
     t.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT = s.EOP_LIEGT_NACH_ODER_GLEICH_DATUM_IN_KRAFT,
     t.HOEHERE_SERIE_MOEGLICH = s.HOEHERE_SERIE_MOEGLICH,
     t.SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS = s.SOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS = s.SOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS = s.EOP_IST_VOR_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS = s.EOP_IST_GLEICH_ODER_NACH_DATUM_IN_KRAFT_DES_NACHFOLGERS,
     t.NACHFOLGER_ANZEIGEN = s.NACHFOLGER_ANZEIGEN,
     t.LESENDE_TABELLE_FUER_DATUMSANGABEN = s.LESENDE_TABELLE_FUER_DATUMSANGABEN,
     
     t.AUSGABE_FUER_ANDERES_TOOL_ODER_FUER_MENSCH = s.AUSGABE_FUER_ANDERES_TOOL_ODER_FUER_MENSCH,
     t.AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE = s.AUSGABE_DER_VORSCHRIFT_BEI_REPORT_BAUREIHE,
     t.QUELLVORSCHRIFT_GUELTIG = s.QUELLVORSCHRIFT_GUELTIG,
     t.DECKELUNG_DER_HOEHEREN_SERIE = s.DECKELUNG_DER_HOEHEREN_SERIE,
     t.PHASE_IN_RELEVANT = s.PHASE_IN_RELEVANT,
     t.MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER = s.MJ_SOP_VOR_PHASEIN_START_OR_PHASEIN_LEER,
     t.MJ_SOP_NACH_PHASEIN_START = s.MJ_SOP_NACH_PHASEIN_START,
     t.MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER = s.MJ_SOP_VOR_PHASEIN_END_OR_PHASEIN_LEER,
     t.MJ_SOP_NACH_PHASEIN_END = s.MJ_SOP_NACH_PHASEIN_END,
     t.MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER = s.MJ_EOP_VOR_PHASEIN_START_OR_PHASEIN_LEER,
     t.MJ_EOP_NACH_PHASEIN_START = s.MJ_EOP_NACH_PHASEIN_START,
     t.PHASE_OUT_RELEVANT = s.PHASE_OUT_RELEVANT,
     t.MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER = s.MJ_EOP_VOR_PHASEIN_END_OR_PHASEIN_LEER,
     t.MJ_EOP_NACH_PHASEIN_END = s.MJ_EOP_NACH_PHASEIN_END,
     t.MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT = s.MJ_SOP_VOR_ODER_GLEICH_AUSSER_KRAFT,
     t.MJ_SOP_NACH_AUSSER_KRAFT = s.MJ_SOP_NACH_AUSSER_KRAFT,
     t.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR = s.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_START_JAHR,
     t.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR = s.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_START_JAHR,
     t.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR = s.MJ_EINSATZ_JAHR_KLEINER_PHASEIN_ENDE_JAHR,
     t.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR = s.MJ_EINSATZ_JAHR_GROESSER_GLEICH_PHASEIN_ENDE_JAHR,
     t.MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR = s.MJ_EINSATZ_JAHR_KLEINER_GLEICH_AUSSER_KRAFT_JAHR,
     t.MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR = s.MJ_EINSATZ_JAHR_GROESSER_AUSSER_KRAFT_JAHR,
     
     t.AUSSER_KRAFT_IST_LEER = s.AUSSER_KRAFT_IST_LEER,
     t.KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION = s.KLEINER_ODER_GLEICH_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
     t.GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION = s.GRÖSSER_LETZTE_MÖGLICHE_VORSCHRIFT_ZUR_HOMOLOGATION,
     
     t.SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER = s.SOP_VOR_IN_KRAFT_ODER_IN_KRAFT_IST_LEER,
     t.SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_ = s.SOP__IST_GLEICH_ODER_NACH_IN_KRAFT_
     where t.nummer = s.nummer;
     
     
     end loop;
     end;
     
     
     
     
     
     select count(*) from t_ms_parameter
     select count(*) from t_ms_parameter
     
     
     
     
SELECT count(*)
FROM t_ms_parameter olde
where olde.NUMMER not in (select NUMMER from t_ms_parameter);

delete
FROM t_ms_parameter olde
where olde.NUMMER not in (select NUMMER from t_ms_parameter);



     
--# Delete a record and child record */
--
--select * from T_MS_PARAMETER where nummer = 99;
--
--select * from t_ms_parameter_ref_ausgabe where ms_parameterid = 1042;
--
--delete from T_MS_PARAMETER where nummer = 99;

delete from t_ms_parameter_ref_ausgabe where ms_parameterid IN (SELECT ms_parameterid  FROM t_ms_parameter olde 
where olde.NUMMER not in (select NUMMER from t_ms_parameter));

delete from t_ms_parameter_ref_bild where ms_parameterid IN (SELECT ms_parameterid  FROM t_ms_parameter olde 
where olde.NUMMER not in (select NUMMER from t_ms_parameter));
--
--
--select * from T_MS_PARAMETER where nummer = 199;
--
--select * from t_ms_parameter_ref_ausgabe where ms_parameterid = 1073;
--
--delete from T_MS_PARAMETER where nummer = 199;
--
--delete from t_ms_parameter_ref_ausgabe where ms_parameterid = 10;
--
--
--SELECT * FROM T_MS_PARAMETER WHERE nummer IN (99, 199);
--
--delete FROM T_MS_PARAMETER WHERE nummer IN (1042, 1073);

    
     
     
     select nummer, count(*) from t_ms_parameter
     group by nummer
     having count(*)>1;
     
      select nummer, count(*) from t_ms_parameter
     group by nummer
     having count(*)>1;
     
     
 delete from t_ms_parameter a
 where rowid >
 ( select min(rowid) from t_ms_parameter b
 where b.nummer = a.nummer);
     
-- DELETE FROM abcd a WHERE ROWID > (SELECT MIN(ROWID) FROM abcd b WHERE b.id=a.id );    
--     
--     
--     delete from T_X_MS_PARAMETER_MODEL_YEAR
     
 DELETE FROM T_MS_PARAMETER_REF_BILD
WHERE MS_PARAMETERID IN
(SELECT MS_PARAMETERID
 FROM t_ms_parameter a
 WHERE rowid >
 (SELECT MIN(rowid) FROM t_ms_parameter b
 WHERE b.nummer = a.nummer));
 
 
 
 
 SELECT * FROM T_MS_PARAMETER_REF_BILD
WHERE MS_PARAMETERID IN
(SELECT MS_PARAMETERID
 FROM t_ms_parameter a
 WHERE rowid >
 (SELECT MIN(rowid) FROM t_ms_parameter b
 WHERE b.nummer = a.nummer));

 
 
 
 DELETE FROM T_MS_PARAMETER_REF_BILD
WHERE MS_PARAMETERID IN
(SELECT MS_PARAMETERID
 FROM t_ms_parameter a
 WHERE rowid >
 (SELECT MIN(rowid) FROM t_ms_parameter b
 WHERE b.nummer = a.nummer));

 DELETE FROM T_MS_PARAMETER_REF_AUSGABE
WHERE MS_PARAMETERID IN
(SELECT MS_PARAMETERID
 FROM t_ms_parameter a
 WHERE rowid >
 (SELECT MIN(rowid) FROM t_ms_parameter b
 WHERE b.nummer = a.nummer));
 
 
 
DELETE FROM t_ms_parameter a
WHERE rowid >
(SELECT MIN(rowid) FROM t_ms_parameter b
WHERE b.nummer = a.nummer);



-- 1. To find the numbers of the new rules (i.e., those in T_MS_PARAMETER (which is a new table) but not in T_MS_PARAMETER_167_BACKUP(which is a old table):



SELECT pnew.NUMMER
FROM T_MS_PARAMETER pnew
WHERE NUMMER NOT IN (SELECT NUMMER FROM T_MS_PARAMETER_167_BACKUP);









-- 2. To find the numbers of the rules that need to be deleted (i.e., those in T_MS_PARAMETER_167_BACKUP (which is a old table) but not in T_MS_PARAMETER (which is a new table)  :



SELECT pold.NUMMER
FROM T_MS_PARAMETER_167_BACKUP pold
WHERE NUMMER NOT IN (SELECT NUMMER FROM T_MS_PARAMETER);


# 18.03.2024 

UPDATE T_MS_PARAMETER
SET NUMMER = NUMMER
WHERE 1=1;

select count(*) from T_MS_PARAMETER;

select count(3) from T_MS_PARAMETER;

select count(*) from T_H_MS_PARAMETER;

DELETE FROM T_H_MS_PARAMETER;


select * from T_H_MS_PARAMETER h, t_ms_parameter p where p.ms_parameterid = h.ms_parameterid;

select count(p.nummer) as history from t_ms_parameter p, t_h_ms_parameter h where p.NUMMER = h.NUMMER;


SELECT *
FROM T_MS_PARAMETER p
WHERE NOT EXISTS (
    SELECT 1
    FROM T_H_MS_PARAMETER h
    WHERE h.NUMMER = p.NUMMER
);





# all column names in a table 

SELECT column_name 
FROM all_tab_columns 
WHERE table_name = 'T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE' 

SELECT column_name 
FROM all_tab_columns 
WHERE table_name = 'T_X_MS_PARAMETER_MODEL_YEAR' 


select * from T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE

select * from T_X_MS_PARAMETER_MODEL_YEAR

# Distinct Count 
-- SELECT COUNT(DISTINCT IN_KRAFT_RELEVANT)
-- FROM T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE;

SELECT DISTINCT ALLE_FAHRZEUGE_RELEVANT_EOP
FROM T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE;

SELECT DISTINCT ALLE_FAHRZEUGE_RELEVANT_EOP
FROM T_X_MS_PARAMETER_MODEL_YEAR;

SELECT DISTINCT AUSSER_KRAFT_IST_LEER
FROM T_MS_PARAMETER;    


# Replacing one value with another 
UPDATE T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE
SET ALLE_FAHRZEUGE_RELEVANT_EOP = 'fehlt'
WHERE ALLE_FAHRZEUGE_RELEVANT_EOP = 'nicht relevant';

UPDATE T_X_MS_PARAMETER_MODEL_YEAR
SET ALLE_FAHRZEUGE_RELEVANT_EOP = 'fehlt'
WHERE ALLE_FAHRZEUGE_RELEVANT_EOP = 'nicht relevant';

UPDATE T_X_MS_PARAMETER_MODEL_YEAR
SET ALLE_FAHRZEUGE_RELEVANT_EOP = 'existiert'
WHERE ALLE_FAHRZEUGE_RELEVANT_EOP = 'relevant';

UPDATE T_MS_PARAMETER
SET IN_KRAFT_RELEVANT = null
WHERE IN_KRAFT_RELEVANT = '0';

-- IN_KRAFT_RELEVANT
-- NEUE_TYPEN_RELEVANT
-- ALLE_FAHRZEUGE_RELEVANT
-- AUSSER_KRAFT_IST_LEER
-- ALLE_FAHRZEUGE_RELEVANT_EOP





-- Compare/comparision two tabels IN_KRAFT_RELEVANT values between T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE (textual) and T_MS_PARAMETER (numeric), translating numeric to textual values for matching.

SELECT
  p1.IN_KRAFT_RELEVANT AS Relevant_China_Date,
  CASE 
    WHEN p2.IN_KRAFT_RELEVANT = 10 THEN 'existiert'
    WHEN p2.IN_KRAFT_RELEVANT = 0 THEN 'fehlt'
    ELSE '-' -- Assuming you want to represent NULLs from T_MS_PARAMETER as '-' for the comparison
  END AS Relevant_Parameter,
  CASE 
    WHEN p1.IN_KRAFT_RELEVANT = 'existiert' AND p2.IN_KRAFT_RELEVANT = 10 THEN 'Match'
    WHEN p1.IN_KRAFT_RELEVANT = 'fehlt' AND p2.IN_KRAFT_RELEVANT = 0 THEN 'Match'
    WHEN p1.IN_KRAFT_RELEVANT IS NULL AND p2.IN_KRAFT_RELEVANT IS NULL THEN 'Match'
    ELSE 'No Match'
  END AS Comparison_Result
FROM T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE p1
INNER JOIN T_MS_PARAMETER p2 ON p1.nummer = p2.nummer;






DECLARE
    v_column_name VARCHAR2(100);
    v_cursor_id INTEGER;
    v_ignore INTEGER;
    v_sql VARCHAR2(4000);
    v_value VARCHAR2(4000); -- This holds the distinct values. Adjust the size as needed or use a different type for non-string data.
BEGIN
    FOR column_rec IN (SELECT column_name FROM user_tab_columns WHERE table_name = 'T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE' ORDER BY column_name) LOOP
        -- Output the column name
        DBMS_OUTPUT.PUT_LINE('Column Name: ' || column_rec.column_name);
        DBMS_OUTPUT.PUT_LINE('Distinct Values:');

        v_sql := 'SELECT DISTINCT ' || column_rec.column_name || ' FROM T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE';

        v_cursor_id := DBMS_SQL.OPEN_CURSOR;
        DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQL.NATIVE);
        DBMS_SQL.DEFINE_COLUMN(v_cursor_id, 1, v_value, 4000); -- Adjust as necessary for non-string data.
        v_ignore := DBMS_SQL.EXECUTE(v_cursor_id);

        -- Fetch and output the distinct values for the column
        WHILE DBMS_SQL.FETCH_ROWS(v_cursor_id) > 0 LOOP
            DBMS_SQL.COLUMN_VALUE(v_cursor_id, 1, v_value);
            -- Output each distinct value
            DBMS_OUTPUT.PUT_LINE('- ' || v_value);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(''); -- Adds an empty line for better readability between columns

        DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        IF DBMS_SQL.IS_OPEN(v_cursor_id) THEN
            DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
        END IF;
        RAISE;
END;



DECLARE
    v_column_name VARCHAR2(100);
    v_cursor_id INTEGER;
    v_ignore INTEGER;
    v_sql VARCHAR2(4000);
    v_value VARCHAR2(4000); -- This holds the distinct values. Adjust the size as needed or use a different type for non-string data.
BEGIN
    FOR column_rec IN (SELECT column_name FROM user_tab_columns WHERE table_name = 'T_X_MS_PARAMETER_MODEL_YEAR' ORDER BY column_name) LOOP
        -- Output the column name
        DBMS_OUTPUT.PUT_LINE('Column Name: ' || column_rec.column_name);
        DBMS_OUTPUT.PUT_LINE('Distinct Values:');

        v_sql := 'SELECT DISTINCT ' || column_rec.column_name || ' FROM T_X_MS_PARAMETER_MODEL_YEAR';

        v_cursor_id := DBMS_SQL.OPEN_CURSOR;
        DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQL.NATIVE);
        DBMS_SQL.DEFINE_COLUMN(v_cursor_id, 1, v_value, 4000); -- Adjust as necessary for non-string data.
        v_ignore := DBMS_SQL.EXECUTE(v_cursor_id);

        -- Fetch and output the distinct values for the column
        WHILE DBMS_SQL.FETCH_ROWS(v_cursor_id) > 0 LOOP
            DBMS_SQL.COLUMN_VALUE(v_cursor_id, 1, v_value);
            -- Output each distinct value
            DBMS_OUTPUT.PUT_LINE('- ' || v_value);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(''); -- Adds an empty line for better readability between columns

        DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        IF DBMS_SQL.IS_OPEN(v_cursor_id) THEN
            DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
        END IF;
        RAISE;
END;








/* 
Trigger: TR_HILFE (as an example, since the trigger name was not provided)

Description:
This trigger is designed to keep a history of changes made on the T_HILFE table. It activates upon INSERT, UPDATE, or DELETE operations.

Workflow:
1. Upon INSERT or UPDATE:
   - Copies the new or updated data to the T_H_HILFE table for record-keeping.
   - The LETZTE_AENDERUNG_DATUM column is populated with the current system date to log the time of the change.

(Note: There's a commented section meant for DELETE operations, but it's currently inactive.)

Dependency:
- Uses the fDeleteMfv function for specific delete operations.
*/


create or replace TRIGGER TR_HILFE
AFTER INSERT OR UPDATE OR DELETE ON T_HILFE
FOR EACH ROW
BEGIN
  IF INSERTING OR UPDATING THEN
    INSERT INTO T_H_HILFE 
    (
      HILFEID, 
      TITEL, 
      TOOLTIP, 
      HILFETEXT, 
      URL_VIDEO, 
      BASISEINTRAGID, 
      TITEL_ENGLISCH, 
      TOOLTIP_ENGLISCH, 
      HILFETEXT_ENGLISCH,
      LETZTE_AENDERUNG_DATUM
    )
    VALUES 
    (
      :NEW.HILFEID, 
      :NEW.TITEL, 
      :NEW.TOOLTIP, 
      :NEW.HILFETEXT, 
      :NEW.URL_VIDEO, 
      :NEW.BASISEINTRAGID, 
      :NEW.TITEL_ENGLISCH, 
      :NEW.TOOLTIP_ENGLISCH, 
      :NEW.HILFETEXT_ENGLISCH,
      SYSDATE
    );
END IF;
/*  ELSIF DELETING THEN
    DELETE FROM T_H_HILFE
    WHERE HILFEID = :OLD.HILFEID;
  END IF;
*/
END;



/* 
Function: fDeleteMfv

Description:
This function is designed to delete a MfV record, including all its references and historical records, from multiple tables in the database.

Parameters:
- aMfvId: This is the ID of the MfV to be deleted.

Workflow:
1. Deletes references from T_MFV_REF_ET_B_AK.
2. Deletes references from T_MFV_REF_MFV_TEIL.
3. Deletes historical references from T_H_MFV_REF_VORSCHRIFT.
4. Deletes references from T_MFV_REF_VORSCHRIFT.
5. Deletes historical records from T_H_MFV.
6. Deletes the main MfV record from T_MFV.

Return:
- Returns 'true' upon successful execution.
*/

/* Loescht eine MfV mit allen Referenzen und Historie
    aMfvId: ID der MfV
    return: true bei Erfolg
*/
FUNCTION fDeleteMfv(aMfvId NUMBER) return BOOLEAN IS
  BEGIN
  
    DELETE FROM T_MFV_REF_ET_B_AK WHERE MFVID = aMfvId;
    DELETE FROM T_MFV_REF_MFV_TEIL WHERE MFVID = aMfvId;
    DELETE FROM T_H_MFV_REF_VORSCHRIFT WHERE MFVID = aMfvId;
    DELETE FROM T_MFV_REF_VORSCHRIFT WHERE MFVID = aMfvId;

    DELETE FROM T_H_MFV WHERE MFVID = aMfvId;
    DELETE FROM T_MFV WHERE MFVID = aMfvId;

  return true;
END fDeleteMfV;





/*
 * This PL/SQL block manages the user information in the 'T_ET_B_AK_REF_THEMA_BENUTZER' table:
 * 
 * 1. Initially, it checks the existence of a record with the specified 'ET_B_AK_REF_THEMA_BENUTZERID'.
 * 
 * 2. If a record exists:
 *    - The relevant fields of the record are updated with the provided values.
 * 
 * 3. If no such record exists:
 *    - A new entry is inserted into the table with the specified values.
 * 
 * The use of the 'no_data_found' exception ensures that a count of 0 is assigned if the query 
 * does not return any matching rows. The following logic then decides between an update or insert operation.
 */
declare
    l_count number;
begin
    begin
        select count(*) into l_count 
        from T_ET_B_AK_REF_THEMA_BENUTZER 
        where ET_B_AK_REF_THEMA_BENUTZERID = :P388_ET_B_AK_REF_THEMA_BENUTZERID;
    exception 
        when no_data_found then  
            l_count := 0;
    end;

    if l_count > 0 then
        update T_ET_B_AK_REF_THEMA_BENUTZER
        set benutzerid = :P388_R_BENUTZERID,
            ...
        WHERE ET_B_AK_REF_THEMA_BENUTZERID = :P388_ET_B_AK_REF_THEMA_BENUTZERID;
    else
        insert into T_ET_B_AK_REF_THEMA_BENUTZER  (
            benutzerid,
            ...
        );  
    end if;
end;



#
 * This PL/SQL block manages user data across multiple tables:
 *
 * 1. Determines if a user already exists in 't_benutzer' based on a given GID.
 * 2. Inserts a new user into 't_benutzer' based on specific conditions and 
 *    clears the 'BETREUERID' if the role is not 1006.
 * 3. Depending on the existence of 'P388_ET_B_AK_REF_THEMA_BENUTZERID', the block 
 *    either updates or inserts a new record into 'T_ET_B_AK_REF_THEMA_BENUTZER'.
 * 4. Manages theme references by either updating or inserting new references 
 *    in 'T_ET_B_AK_REF_THEMA_BENUTZER_REF_ET_B_AK_REF_THEMA'.
 * 5. Deletes unmatched theme references from the aforementioned table based on the provided IDs.
 * 
 * Overall, the block maintains data integrity and ensures the correct associations
 * between users and their respective themes and roles.
 

declare
    l_co number:=0;
    l_count number;
begin

    -- Determine if a user with the given GID already exists
    begin
        select count(*) into l_co from t_benutzer where gid = :P388_BENUTZER_GID;
    exception 
        when no_data_found then 
            l_co := 0;
    end;

    -- Insert a new user record if conditions are met and clear 'BETREUERID' if role is not 1006
    if (:P388_R_BENUTZERID is null and l_co =0 and :P388_NACHNAME is not null ) then
        ...
        if (:P388_ROLLE !=1006 ) then
            :P388_BETREUERID := null;
        end if;
    end if;

    -- Insert or update record in 'T_ET_B_AK_REF_THEMA_BENUTZER' depending on existence of an ID
    if :P388_ET_B_AK_REF_THEMA_BENUTZERID is not null then
        ...
    else
        ...
    end if;

    -- Update or insert references in 'T_ET_B_AK_REF_THEMA_BENUTZER_REF_ET_B_AK_REF_THEMA' based on the provided theme IDs
    merge into T_ET_B_AK_REF_THEMA_BENUTZER_REF_ET_B_AK_REF_THEMA ...
    when not matched then 
        ...

    -- Delete unmatched theme references from 'T_ET_B_AK_REF_THEMA_BENUTZER_REF_ET_B_AK_REF_THEMA'
    delete from T_ET_B_AK_REF_THEMA_BENUTZER_REF_ET_B_AK_REF_THEMA ...

end;





# The provided SQL statement is attempting to retrieve a message in either German or English based on a function called fLang. This function appears to determine the user's preferred language and then returns the respective string. The essence of the message seems to revolve around a "regulation" the user has picked.

1. Outer SELECT Statement:
   This fetches a singular column named 'message' using the fLang function. Depending on the output of the function, the column will contain the message in either German or English. The "dual" is a standard one-row, one-column table in Oracle, usually employed for select operations not actually linked to a specific table.

2. fLang Function:
   A custom function possibly from the emano_util package. It takes in two arguments: one message in German and another in English. The function's responsibility is likely determining which language to use for the output based on certain criteria, perhaps user settings or browser locale.

3. Inner SELECT Statement:
   Inside the main string, there's another SQL statement that fetches the regulation number (vorschrift_nummer) from the t_vorschrift table based on an ID (:P572_MASTER_VORSCHRIFTID). This ID looks like a bind variable, acting as a placeholder for a real value that's supplied during runtime.

4. Concatenation and Line Breaks:
   In Oracle SQL, the '||' operator serves the purpose of string concatenation. The statement also uses CHR(10) and CHR(13) to represent newline and carriage return characters, respectively, thus creating a new line in the returned message.

Note on Oracle APEX:
Oracle APEX (Application Express) is a platform that enables the development of enterprise apps with minimal coding. It facilitates the creation of apps that interact directly with Oracle databases. In this context, it's probable this SQL is part of a dynamic action or computed item in an APEX application. The user might select a regulation, and this message gets displayed to notify them about their choice and offer further directions.



SELECT emano_util.fLang(
    'Sie haben die Vorschrift ' || 
    (SELECT vorschrift_nummer FROM t_vorschrift WHERE vorschriftid = :P572_MASTER_VORSCHRIFTID) || 
    ' als Hauptvorschrift für Ihre MfV gewählt.' || CHR(10) || CHR(13) ||
    'Wenn Sie diese Vorschrift nicht als Hauptvorschrift verwenden möchten, müssen Sie den Ticket-Assistenten abbrechen! Bitte suchen Sie anschließend Ihre Hauptvorschrift und starten Sie den Assistenten neu!',
    'You have selected the regulation ' || 
    (SELECT vorschrift_nummer FROM t_vorschrift WHERE vorschriftid = :P572_MASTER_VORSCHRIFTID) || 
    ' as the main regulation for your MfV.' || CHR(10) || CHR(13) ||
    'If you do not want to use this regulation as the main regulation, you must cancel the ticket assistant! Please then search for your main regulation and restart the assistant!'
) AS message
FROM dual;







CREATE OR REPLACE FUNCTION CalculateEndDate (
    aDatumStart IN DATE,
    aDauer IN NUMBER,
    aMarktID IN NUMBER
   
) RETURN VARCHAR2 IS
    vEndDate DATE := aDatumStart + (aDauer * 7);
    vHolidayCount NUMBER;
    V_URLAUB_VON DATE;
    V_URLAUB_BIS DATE;
    V_DAYS_COUNT NUMBEr;
    V_DAYS_COUNT_WEEKS number;
    V_DAYS_COUNT_FINAL NUMBER :=0;
    v_out VARCHAR2(50);
BEGIN
DBMS_OUTPUT.PUT_LINE('aDatumStart: ' || aDatumStart);
DBMS_OUTPUT.PUT_LINE('vEndDate: ' || vEndDate);
    -- Count the number of holiday weeks between the start date and the projected end date
    begin
    SELECT COUNT(*)
    INTO vHolidayCount
    FROM T_HTL_URLAUB
    WHERE HTL_INT_MARKT_ID = aMarktID
    AND ( 
        (URLAUB_VON BETWEEN aDatumStart AND vEndDate) OR 
        (URLAUB_BIS BETWEEN aDatumStart AND vEndDate) 
      --  (URLAUB_VON <= aDatumStart AND URLAUB_BIS >= vEndDate)
    );
    exception when no_data_found then vHolidayCount :=0;
    end;
    if vHolidayCount>0 then 
    
    FOR HOL_DATE IN (SELECT URLAUB_VON,URLAUB_BIS 
    FROM T_HTL_URLAUB
    WHERE HTL_INT_MARKT_ID = aMarktID
    AND ( 
        (URLAUB_VON BETWEEN aDatumStart AND vEndDate) OR 
        (URLAUB_BIS BETWEEN aDatumStart AND vEndDate) 
      --  (URLAUB_VON <= aDatumStart AND URLAUB_BIS >= vEndDate)
    )) LOOP
    
    select (to_date(HOL_DATE.URLAUB_BIS,'dd-Mon-yyyy')-to_date(HOL_DATE.URLAUB_VON, 'dd-Mon-yyyy')) INTO V_DAYS_COUNT from dual;
   --DBMS_OUTPUT.PUT_LINE('V_DAYS_COUNT: ' || V_DAYS_COUNT) ;
   V_DAYS_COUNT_FINAL :=V_DAYS_COUNT_FINAL+V_DAYS_COUNT;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('V_DAYS_COUNT_FINAL:' ||V_DAYS_COUNT_FINAL);
    vEndDate := vEndDate + V_DAYS_COUNT_FINAL;
    ---for testing purpose--
    V_DAYS_COUNT_WEEKS :=round(V_DAYS_COUNT_FINAL/7);
    DBMS_OUTPUT.PUT_LINE('V_DAYS_COUNT_WEEKS:' ||V_DAYS_COUNT_WEEKS);
    
    ELSE
     vEndDate := vEndDate;
END IF;
    DBMS_OUTPUT.PUT_LINE('KW Format: KW ' || TO_CHAR(vEndDate, 'YYYY') || '/' || TO_CHAR(vEndDate, 'IW'));




    --RETURN NEXT_DAY(TRUNC(vEndDate, 'IW') +1, 'MONDAY');
    DBMS_OUTPUT.PUT_LINE('Next Monday After End Date: ' || NEXT_DAY(TRUNC(vEndDate, 'IW') + 1, 'MONDAY'));




    v_out := 'KW ' || TO_CHAR(vEndDate, 'YYYY') || '/' || TO_CHAR(vEndDate, 'IW');
    RETURN v_out;




END CalculateEndDate;










DECLARE
    vResult VARCHAR2(50);
BEGIN
    vResult := CalculateEndDate(TO_DATE('25-09-2024', 'DD-MM-YYYY'), 2, 4);
    DBMS_OUTPUT.PUT_LINE('End Date: ' || vResult);
END;
/





-- Creating the main table
CREATE TABLE T_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA (
    VORSCHRIFT_REF_VORSCHRIFT_REF_THEMAID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1000 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE,
    VORSCHRIFT_REF_VORSCHRIFTID number,
    THEMAID number,
    STATUS_VERKNUEPFUNG number, --DEFAULT 0 CHECK (STATUS_VERKNUEPFUNG IN (0, 1)),
    STATUS_PRUEFUNG number, --DEFAULT 0 CHECK (STATUS_PRUEFUNG IN (0, 1)),
    LETZTE_AENDERUNG_DATUM DATE,
    LETZTE_AENDERUNG_BENUTZERID number
);

-- Creating the history table
CREATE TABLE T_H_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA (
    H_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMAID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1000 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE,
    VORSCHRIFT_REF_VORSCHRIFT_REF_THEMAID number,
    VORSCHRIFT_REF_VORSCHRIFTID number,
    THEMAID number,
    STATUS_VERKNUEPFUNG number,
    STATUS_PRUEFUNG number,
    LETZTE_AENDERUNG_DATUM DATE,
    LETZTE_AENDERUNG_BENUTZERID number,
    AKTION_TYPE number
);


-- delete from T_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA

-- select count(*) from T_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA
-- select * from T_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA







Procedure inside PCK_RI


CREATE OR REPLACE PROCEDURE PROCEDURE proc_equivalent_vorschrift_thema(aVorschriftID in number)
 IS
    v_count NUMBER;
BEGIN
    FOR i IN (
        SELECT 
            vrt.VORSCHRIFT_REF_THEMAID, 
            vrt.THEMAID, 
            vrv.BEZIEHUNG_ART,
            vrt.LETZTE_AENDERUNG_DATUM,
            vrt.LETZTE_AENDERUNG_BENUTZERID
        FROM 
        t_vorschrift_ref_thema vrt
            JOIN T_VORSCHRIFT_REF_VORSCHRIFT vrv
                ON vrv.VORGAENGER_VORSCHRIFTID = vrt.vorschriftid
        WHERE 
            vrv.BEZIEHUNG_ART = 102  
            and vrv.VORGAENGER_VORSCHRIFTID =aVorschriftID -- equivalent
    ) LOOP
        -- Check if the record already exists
        begin
        SELECT COUNT(*) INTO v_count FROM T_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA
        WHERE VORSCHRIFT_REF_VORSCHRIFTID = i.VORSCHRIFT_REF_THEMAID;
        exception when no_data_found then v_count :=0;
        end;
        --   AND THEMAID = i.THEMAID;
 
        IF v_count > 0 THEN
        UPDATE T_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA  
            SET THEMAID = i.themaid,
                STATUS_VERKNUEPFUNG = 1,
                STATUS_PRUEFUNG = 1,
                LETZTE_AENDERUNG_DATUM = i.LETZTE_AENDERUNG_DATUM,
                LETZTE_AENDERUNG_BENUTZERID = i.LETZTE_AENDERUNG_BENUTZERID
            WHERE VORSCHRIFT_REF_VORSCHRIFTID = i.VORSCHRIFT_REF_THEMAID; 
        
        else
            -- If not exists, insert the record
            INSERT INTO T_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA (
                VORSCHRIFT_REF_VORSCHRIFTID,
                THEMAID,
                STATUS_VERKNUEPFUNG, --DEFAULT 0 CHECK (STATUS_VERKNUEPFUNG IN (0, 1)),
                STATUS_PRUEFUNG, --DEFAULT 0 CHECK (STATUS_PRUEFUNG IN (0, 1)),
                LETZTE_AENDERUNG_DATUM,
                LETZTE_AENDERUNG_BENUTZERID 
            )
            VALUES (
                i.VORSCHRIFT_REF_THEMAID,
                i.THEMAID,
                0, --  default status for 'STATUS_VERKNUEPFUNG' is 'not assigned'
                0, --  default status for 'STATUS_PRUEFUNG' is 'to be reviewed'
                i.LETZTE_AENDERUNG_DATUM, -- Current date and time
                i.LETZTE_AENDERUNG_BENUTZERID -- User ID should be dynamically determined
            );
       END IF;
       
    END LOOP;
 
    DELETE FROM t_vorschrift_ref_vorschrift_ref_thema
        WHERE
            vorschrift_ref_vorschriftid NOT IN (
        SELECT
            vrt.vorschrift_ref_themaid
        FROM
                 t_vorschrift_ref_thema vrt
            JOIN t_vorschrift_ref_vorschrift vrv ON vrv.vorgaenger_vorschriftid = vrt.vorschriftid
        WHERE vrv.beziehung_art = 102 
        --and vrv.VORGAENGER_VORSCHRIFTID =aVorschriftID 
    );
     
END proc_equivalent_vorschrift_thema;

--specification
PROCEDURE proc_equivalent_vorschrift_thema(aVorschriftID in number);


begin
PCK_RI.proc_equivalent_vorschrift_thema(aVorschriftID =>9720);
end;


Trigger
CREATE OR REPLACE EDITIONABLE TRIGGER  "TR_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA" 
AFTER INSERT OR UPDATE OR DELETE ON T_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA
FOR EACH ROW
declare
  l_aktion number := 20;
BEGIN     -- 0 = delete , 10 = insert, 20 = update
  IF DELETING THEN
    l_aktion := 0;
  ELSIF INSERTING THEN
    l_aktion := 10;
  ELSE -- UPDATING
    l_aktion := 20;
  END IF;
    -- Capture inserts to the history table
    IF INSERTING THEN
        INSERT INTO T_H_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA (
            VORSCHRIFT_REF_VORSCHRIFT_REF_THEMAID,
            VORSCHRIFT_REF_VORSCHRIFTID,
            THEMAID,
            STATUS_VERKNUEPFUNG,
            STATUS_PRUEFUNG,
            LETZTE_AENDERUNG_DATUM,
            LETZTE_AENDERUNG_BENUTZERID,
            AKTION_TYPE
        ) VALUES (
            :NEW.VORSCHRIFT_REF_VORSCHRIFT_REF_THEMAID,
            :NEW.VORSCHRIFT_REF_VORSCHRIFTID,
            :NEW.THEMAID,
            :NEW.STATUS_VERKNUEPFUNG,
            :NEW.STATUS_PRUEFUNG,
            SYSDATE,
            :NEW.LETZTE_AENDERUNG_BENUTZERID,
            l_aktion -- 10 represents an insert action
        );
    END IF;
    -- Capture updates to the history table
    IF UPDATING THEN
        INSERT INTO T_H_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA (
            VORSCHRIFT_REF_VORSCHRIFT_REF_THEMAID,
            VORSCHRIFT_REF_VORSCHRIFTID,
            THEMAID,
            STATUS_VERKNUEPFUNG,
            STATUS_PRUEFUNG,
            LETZTE_AENDERUNG_DATUM,
            LETZTE_AENDERUNG_BENUTZERID,
            AKTION_TYPE
        ) VALUES (
            :OLD.VORSCHRIFT_REF_VORSCHRIFT_REF_THEMAID,
            :OLD.VORSCHRIFT_REF_VORSCHRIFTID,
            :OLD.THEMAID,
            :OLD.STATUS_VERKNUEPFUNG,
            :OLD.STATUS_PRUEFUNG,
            SYSDATE,
            :OLD.LETZTE_AENDERUNG_BENUTZERID,
            l_aktion -- 20 represents an update action
        );
    END IF;
    -- Capture deletes to the history table
    IF DELETING THEN
        INSERT INTO T_H_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA (
            VORSCHRIFT_REF_VORSCHRIFT_REF_THEMAID,
            VORSCHRIFT_REF_VORSCHRIFTID,
            THEMAID,
            STATUS_VERKNUEPFUNG,
            STATUS_PRUEFUNG,
            LETZTE_AENDERUNG_DATUM,
            LETZTE_AENDERUNG_BENUTZERID,
            AKTION_TYPE
        ) VALUES (
            :OLD.VORSCHRIFT_REF_VORSCHRIFT_REF_THEMAID,
            :OLD.VORSCHRIFT_REF_VORSCHRIFTID,
            :OLD.THEMAID,
            :OLD.STATUS_VERKNUEPFUNG,
            :OLD.STATUS_PRUEFUNG,
            SYSDATE,
            :OLD.LETZTE_AENDERUNG_BENUTZERID,
            l_aktion -- 0 represents a delete action
        );
    END IF;
END;

/
ALTER TRIGGER  "TR_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA" ENABLE
/



SELECT   * from T_H_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA




CREATE OR REPLACE TRIGGER TR_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA_B
BEFORE INSERT OR UPDATE ON T_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA
FOR EACH ROW
BEGIN
  :new.LETZTE_AENDERUNG_DATUM := sysdate;
  :new.LETZTE_AENDERUNG_BENUTZERID := PCK_RI.fGetUserId;
END;

ALTER TRIGGER TR_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA_B ENABLE;





-- REGEXP


SELECT * 
FROM T_Benutzer
WHERE REGEXP_LIKE(nachname, '[0-9]') 
  AND REGEXP_LIKE(nachname, '[a-zA-Z]')







/* all column names in a table */

SELECT column_name 
FROM all_tab_columns 
WHERE table_name = 'T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE';

/* Distinct Count */

SELECT COUNT(DISTINCT IN_KRAFT_RELEVANT)
FROM T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE;


/* REplacing one value with aniother */

UPDATE T_X_MS_PARAMETER_EU_WENDER_CHINA_DATE
SET IN_KRAFT_RELEVANT = 'fehlt'
WHERE IN_KRAFT_RELEVANT = 'nicht relevant';

			

/* ADD role to the user */

INSERT INTO t_benutzer_ref_rolle (
    benutzerid, 
    rolleid, 
    letzte_aenderung_benutzerid, 
    letzte_aenderung_datum
) VALUES (
    2000,
    1005 ,
   PCK_RI.fGetUserId,
   sysdate -- or CURRENT_TIMESTAMP, based on your schema
);
			
		
		
/* Single Check box Color */

.apex-item-single-checkbox input:checked+.u-checkbox, .apex-item-single-checkbox input:checked+label, .u-checkbox.is-checked {
    --a-checkbox-background-color: #bb0a31 !important; -- red
    --a-checkbox-text-color: var(--a-checkbox-checked-text-color);
    border-color: black !important;
}



/* 2D to 3D any chart*/

-- Chart - attributes
-- Advanced
-- Initialization JavaScript Function

function (options) {
 options.styleDefaults = $.extend(options.styleDefaults, {
 threeDEffect: "on",
 });
 return options;
}



# Regular Expression with interactive built in Filter

### Examples

1. ^10$|^11$|^12$
2. ^10$|^11$|^12$|^20$
3. ^10$|^11$|^12$|^105$



/* Complete Oracle Text package in dynamic and also in lov ( list of value) */

-- Specification

create or replace package pck_ri_vorschrift_oracle_text_pkg authid current_user is 
    -- Checks if Oracle Text is available
    function text_is_available return boolean; 
    -- Procedures for creating and managing text preferences
    procedure create_text_preferences(
        p_pref_name         in varchar2, 
        p_object_name       in varchar2, 
        p_columns           in varchar2, 
        p_section_group     in varchar2, 
        p_tag               in varchar2, 
        p_lexer_name        in varchar2, 
        p_mixed_case        in varchar2, 
        p_base_letter       in varchar2, 
        p_base_letter_type  in varchar2
    );
    -- Procedures for dropping text preferences
    procedure drop_text_preferences(p_pref_name in varchar2);
    -- Procedures for creating text indexes
    procedure create_text_index(
        p_index_name    in varchar2, 
        p_table_name    in varchar2, 
        p_column_name   in varchar2, 
        p_sg_pref       in varchar2, 
        p_ds_pref       in varchar2, 
        p_lx_pref       in varchar2
    );
    -- Procedures for dropping text indexes
    procedure drop_text_index(p_index_name in varchar2);
    -- Initialization procedure to set up Oracle Text for specified tables
    --procedure init_oracle_text; 
    -- Function to convert end-user queries into Oracle Text queries
    function convert_text_query(p_enduser_query in varchar2) return varchar2;
    
end pck_ri_vorschrift_oracle_text_pkg;


-- BODY


create or replace package body pck_ri_vorschrift_oracle_text_pkg is
    procedure execute_sql(p_sql in varchar2, p_throw_error in boolean default true) is 
    begin 
        execute immediate p_sql; 
    exception 
        when others then  
            if p_throw_error then 
                raise; 
            end if;
    end execute_sql; 
    function text_is_available return boolean is 
        l_dummy number; 
    begin 
        select 1 into l_dummy from sys.all_objects 
         where owner = 'CTXSYS' and object_name = 'CTX_DDL' and rownum = 1; 
        return true; 
    exception  
        when NO_DATA_FOUND then 
            return false; 
    end text_is_available; 
    procedure create_text_preferences(p_pref_name in varchar2, p_object_name in varchar2, p_columns in varchar2, p_section_group in varchar2, p_tag in varchar2, p_lexer_name in varchar2, p_mixed_case in varchar2, p_base_letter in varchar2, p_base_letter_type in varchar2) is
    begin 
        execute_sql('begin ' ||
                    'ctx_ddl.create_preference(''' || p_pref_name || ''', ''' || p_object_name || '''); ' ||
                    'ctx_ddl.set_attribute(''' || p_pref_name || ''', ''COLUMNS'', ''' || p_columns || '''); ' ||
                    'ctx_ddl.create_section_group(''' || p_section_group || ''', ''XML_SECTION_GROUP''); ' ||
                    'ctx_ddl.add_field_section(''' || p_section_group || ''', ''' || p_tag || ''', ''' || p_tag || ''', true); ' ||
                    'ctx_ddl.create_preference(''' || p_lexer_name || ''', ''BASIC_LEXER''); ' ||
                    'ctx_ddl.set_attribute(''' || p_lexer_name || ''', ''MIXED_CASE'', ''' || p_mixed_case || '''); ' ||
                    'ctx_ddl.set_attribute(''' || p_lexer_name || ''', ''BASE_LETTER'', ''' || p_base_letter || '''); ' ||
                    'ctx_ddl.set_attribute(''' || p_lexer_name || ''', ''BASE_LETTER_TYPE'', ''' || p_base_letter_type || '''); ' ||
                    'end;');
    end create_text_preferences;
    procedure drop_text_preferences(p_pref_name in varchar2) is 
    begin 
        execute_sql('begin ctx_ddl.drop_preference(''' || p_pref_name || '''); end;', false);
    end drop_text_preferences;
    procedure create_text_index(p_index_name in varchar2, p_table_name in varchar2, p_column_name in varchar2, p_sg_pref in varchar2, p_ds_pref in varchar2, p_lx_pref in varchar2) is 
    begin 
        execute_sql('create index ' || p_index_name || ' on ' || p_table_name || '(' || p_column_name || ') ' ||
                    'indextype is ctxsys.context parameters (''section group ' || p_sg_pref || ' datastore ' || p_ds_pref || ' lexer ' || p_lx_pref || ' stoplist ctxsys.empty_stoplist memory 10M sync (on commit)'')');
    end create_text_index;
    procedure drop_text_index(p_index_name in varchar2) is 
    begin 
        execute_sql('drop index ' || p_index_name || ' force');
    end drop_text_index;
    
 -- commented
    /*procedure init_oracle_text is 
    begin 
        if text_is_available then 
            -- Specific setup for T_VORSCHRIFT_SYNTHETIC
            create_text_preferences('RI_VORSCHRIFT_DS_PREF', 'MULTI_COLUMN_DATASTORE', 'VORSCHRIFT_NUMMER,VORSCHRIFT_BEZEICHNUNG_DEUTSCH', 'RI_VORSCHRIFT_SG_PREF', 'VORSCHRIFT_BEZEICHNUNG_DEUTSCH', 'RI_VORSCHRIFT_LX_PREF', 'NO', 'YES', 'GENERIC');
            create_text_index('RI_VORSCHRIFT_TEXT_FTX', 'T_VORSCHRIFT_SYNTHETIC', 'VORSCHRIFT_NUMMER', 'RI_VORSCHRIFT_SG_PREF', 'RI_VORSCHRIFT_DS_PREF', 'RI_VORSCHRIFT_LX_PREF');
            -- Specific setup for T_VORSCHRIFT_SYNTHETIC_1
            create_text_preferences('RI_VORSCHRIFT_DS_PREF_1', 'MULTI_COLUMN_DATASTORE', 'VORSCHRIFT_NUMMER,VORSCHRIFT_BEZEICHNUNG_DEUTSCH', 'RI_VORSCHRIFT_SG_PREF_1', 'VORSCHRIFT_BEZEICHNUNG_DEUTSCH', 'RI_VORSCHRIFT_LX_PREF_1', 'NO', 'YES', 'GENERIC');
            create_text_index('RI_VORSCHRIFT_TEXT_FTX_1', 'T_VORSCHRIFT_SYNTHETIC_1', 'VORSCHRIFT_NUMMER', 'RI_VORSCHRIFT_SG_PREF_1', 'RI_VORSCHRIFT_DS_PREF_1', 'RI_VORSCHRIFT_LX_PREF_1');
            -- Specific setup for T_NORM
            create_text_preferences('RI_VORSCHRIFT_DS_PREF_NORM', 'MULTI_COLUMN_DATASTORE', 'BEZEICHNUNG', 'RI_VORSCHRIFT_SG_PREF_NORM', 'BEZEICHNUNG', 'RI_VORSCHRIFT_LX_PREF_NORM', 'NO', 'YES', 'GENERIC');
            create_text_index('RI_VORSCHRIFT_TEXT_FTX_NORM', 'T_NORM', 'BEZEICHNUNG', 'RI_VORSCHRIFT_SG_PREF_NORM', 'RI_VORSCHRIFT_DS_PREF_NORM', 'RI_VORSCHRIFT_LX_PREF_NORM');
        end if; 
    end init_oracle_text; */
    function convert_text_query( p_enduser_query in varchar2 ) return varchar2  
is  
    l_tokens       apex_t_varchar2 := apex_t_varchar2();
    c_xml constant varchar2(32767) := '<query><textquery><progression>' || 
                                        '<seq>#NORMAL#</seq>' || 
                                        '<seq>#FUZZY#</seq>' || 
                                      '</progression></textquery></query>'; 
    l_textquery    varchar2(32767);
    --------------------------------------------------------------------------------
    procedure tokenize
    is
        c_len constant pls_integer := length( p_enduser_query );
        l_pos pls_integer := 1;
        l_char varchar2( 1 char );
        l_quoted boolean := false;
        l_token  varchar2(32767);
    begin
        <<char_reader_loop>>
        while l_pos <= c_len loop
            l_char := substr( p_enduser_query, l_pos, 1 );
            if l_char = '"' then
                if substr( p_enduser_query, l_pos + 1) = '"' then
                     l_token := l_token || l_char;
                     l_pos := l_pos + 2;
                     continue char_reader_loop;
                end if;
                l_token := trim( both from l_token );
                if l_token is not null then
                    if l_quoted then
                        apex_string.push( l_tokens, l_token );
                    else
                        l_tokens := l_tokens multiset union apex_string.split( l_token, ' ' );
                    end if;
                    l_token := '';
                end if;
                l_quoted := not l_quoted;
            else
                l_token := l_token || l_char;
            end if;
            l_pos := l_pos + 1;
        end loop char_reader_loop;
        l_token := trim( both from l_token );
        if l_token is not null then
            l_tokens := l_tokens multiset union (apex_string.split( l_token, ' ' ));
        end if;
    end tokenize;
    --------------------------------------------------------------------------------
    function generate_query( 
            p_feature in varchar2) 
            return varchar2 is 
        l_query       varchar2(32767); 
        l_clean_token varchar2(32767); 
        l_not         boolean;
    begin 
        for i in 1..l_tokens.count loop 
            l_clean_token := lower( regexp_replace( l_tokens( i ), '[<>{}/()*%&!$?.:,;\+#]', '' ) ); 
            l_not         := false;
            if ltrim( rtrim( l_clean_token ) ) is not null then 
                l_not := l_clean_token like '-%' AND l_clean_token NOT like '-';
                if l_query is not null and not l_not then
                    l_query := l_query || ' and '; 
                end if; 
                if l_not then
                    l_query := l_query || 'NOT ';
                    l_clean_token := substr( l_clean_token, 2 );
                end if;
                if p_feature = 'FUZZY' then
                    if l_clean_token like '%"%' then
                        l_query := l_query || 'FUZZY("' || trim(both '"' from l_clean_token) || '", 50, 500) ';
                    else
                        l_query := l_query || 'FUZZY({' || l_clean_token || '}, 50, 500) ';
                    end if;
                else
                    if l_clean_token like '%"%' then
                        l_query := l_query || '"' || trim(both '"' from l_clean_token) || '"';
                    else
                        l_query := l_query || '{' || l_clean_token || '}';
                    end if;
                end if;
            end if; 
        end loop; 
        return ltrim( rtrim( l_query ));  
    end generate_query; 
begin 
    if substr( p_enduser_query, 1, 8 ) = 'ORATEXT:' then 
        return substr( p_enduser_query, 9 ); 
    else  
        l_textquery := c_xml; 
        
        if substr(p_enduser_query, 1, 1) = '"' and substr(p_enduser_query, -1) = '"' then
    l_textquery := replace( l_textquery, '#NORMAL#', '"' || trim(both '"' from p_enduser_query) || '"' );
    l_textquery := replace( l_textquery, '#FUZZY#', 'FUZZY("' || trim(both '"' from p_enduser_query) || '", 50, 500)' );
else
    tokenize;
    l_textquery := replace( l_textquery, '#NORMAL#', generate_query( 'NORMAL' ) );
    l_textquery := replace( l_textquery, '#FUZZY#', generate_query( 'FUZZY' ) );
end if;
        
        apex_debug.info( '#### Oracle TEXT Query is: %s', l_textquery);
        return l_textquery; 
    end if; 
end convert_text_query;
end pck_ri_vorschrift_oracle_text_pkg;


-- lov (list of value ) oracle text


with cte_la as (
    select 
        normid,
        nvl(listagg(trim(la.b_nummer), ', ') within group (order by la.b_nummer), null) as laender_nummer,
        nvl(listagg(trim(la.LAND), ', ') within group (order by la.LAND), null) as laender_name
    from t_norm_ref_land nrl
    left outer join t_land la on nrl.landid = la.landid
    group by normid
)
select 
    n.normid, 
    n.bezeichnung as BEZEICHNUNG,
    :APEX$F1 as search_string,
    cte_la.laender_nummer as B_NUMMER,
    cte_la.laender_name as LAND
from T_NORM n
left outer join cte_la on cte_la.normid = n.normid
where n.normid not in (1016) 
  and (:APEX$F1 is null or contains(n.BEZEICHNUNG, (select PCK_RI_VORSCHRIFT_ORACLE_TEXT_PKG.convert_text_query(nvl(:APEX$F1, 'xxx')) from dual), 1) > 0)
order by n.BEZEICHNUNG asc;



/* Complete Oracle Text package in static */

-- Specification

create or replace package pck_ri_vorschrift_oracle_text_pkg authid current_user is 
 
    function text_is_available return boolean; 
 
    procedure create_text_preferences;
    procedure create_text_preferences_1;
    procedure create_text_preferences_norm; 
 
    procedure drop_text_preferences;
    procedure drop_text_preferences_1;
    procedure drop_text_preferences_norm; 
 
    procedure create_text_index;
    procedure create_text_index_1;
    procedure create_text_index_norm; 
 
    procedure drop_text_index;
    procedure drop_text_index_1;
    procedure drop_text_index_norm; 
 
    procedure init_oracle_text; 
 
    function convert_text_query( p_enduser_query  in varchar2 ) return varchar2; 
 
end pck_ri_vorschrift_oracle_text_pkg;


-- BODY

create or replace package body pck_ri_vorschrift_oracle_text_pkg is 
    procedure execute_sql( 
        p_sql         in varchar2,  
        p_throw_error in boolean default true 
    ) is 
    begin 
        execute immediate p_sql; 
    exception 
        when others then  
            if p_throw_error then raise; end if; 
    end execute_sql; 
    
    function text_is_available return boolean  
    is 
        l_dummy number; 
    begin 
        select 1 into l_dummy  
          from sys.all_objects 
         where owner       = 'CTXSYS'  
           and object_name = 'CTX_DDL'  
           and rownum      = 1; 
        return true; 
    exception  
        when NO_DATA_FOUND then return false; 
    end text_is_available; 

    procedure init_oracle_text is 
    begin 
        if text_is_available then 
            create_text_preferences; 
            create_text_index; 
        end if; 
    end init_oracle_text; 
    
    procedure drop_text_index is  
    begin 
        execute_sql( q'#drop index RI_VORSCHRIFT_TEXT_FTX force#' ); 
    end drop_text_index;


    procedure drop_text_index_1 is  
    begin 
        execute_sql( q'#drop index RI_VORSCHRIFT_TEXT_FTX_1 force#' ); 
    end drop_text_index_1;

    procedure drop_text_index_norm is  
    begin 
        execute_sql( q'#drop index RI_VORSCHRIFT_TEXT_FTX_NORM force#' ); 
    end drop_text_index_norm; 


    procedure drop_text_preferences is 
    begin 
        execute_sql( q'#begin ctx_ddl.drop_preference( 'RI_VORSCHRIFT_LX_PREF'); end;#', false );  
        execute_sql( q'#begin ctx_ddl.drop_preference( 'RI_VORSCHRIFT_DS_PREF'); end;#', false );  
        execute_sql( q'#begin ctx_ddl.drop_section_group( 'RI_VORSCHRIFT_SG_PREF'); end;#', false );  
    end drop_text_preferences;

    procedure drop_text_preferences_1 is 
    begin 
        execute_sql( q'#begin ctx_ddl.drop_preference( 'RI_VORSCHRIFT_LX_PREF_1'); end;#', false );  
        execute_sql( q'#begin ctx_ddl.drop_preference( 'RI_VORSCHRIFT_DS_PREF_1'); end;#', false );  
        execute_sql( q'#begin ctx_ddl.drop_section_group( 'RI_VORSCHRIFT_SG_PREF_1'); end;#', false );  
    end drop_text_preferences_1;

    procedure drop_text_preferences_norm is 
    begin 
        execute_sql( q'#begin ctx_ddl.drop_preference( 'RI_VORSCHRIFT_LX_PREF'); end;#', false );  
        execute_sql( q'#begin ctx_ddl.drop_preference( 'RI_VORSCHRIFT_DS_PREF'); end;#', false );  
        execute_sql( q'#begin ctx_ddl.drop_section_group( 'RI_VORSCHRIFT_SG_PREF'); end;#', false );  
    end drop_text_preferences_norm;
    
    procedure create_text_preferences is 
    begin 
        -- Datastore Preference: Index the VORSCHRIFT_NUMMER and the VORSCHRIFT_BEZEICHNUNG_DEUTSCH columns 
        execute_sql(q'#  
        begin 
            ctx_ddl.create_preference( 
                preference_name  => 'RI_VORSCHRIFT_DS_PREF', 
                object_name      => 'MULTI_COLUMN_DATASTORE' 
            ); 
         
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_DS_PREF', 
                attribute_name   => 'COLUMNS', 
                attribute_value  => 'VORSCHRIFT_NUMMER,VORSCHRIFT_BEZEICHNUNG_DEUTSCH' 
            ); 
         
            ctx_ddl.create_section_group( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF', 
                group_type       => 'XML_SECTION_GROUP' 
            ); 
         
            ctx_ddl.add_field_section( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF', 
                section_name     => 'VORSCHRIFT_BEZEICHNUNG_DEUTSCH', 
                tag              => 'VORSCHRIFT_BEZEICHNUNG_DEUTSCH', 
                visible          => true 
            ); 
         
            ctx_ddl.add_field_section( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF', 
                section_name     => 'VORSCHRIFT_NUMMER', 
                tag              => 'VORSCHRIFT_NUMMER', 
                visible          => true 
            ); 
         
            ctx_ddl.create_preference( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF', 
                object_name      => 'BASIC_LEXER' 
            ); 
         
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF', 
                attribute_name   => 'MIXED_CASE', 
                attribute_value  => 'NO' 
            ); 
         
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF', 
                attribute_name   => 'BASE_LETTER', 
                attribute_value  => 'YES' 
            ); 
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF', 
                attribute_name   => 'BASE_LETTER_TYPE', 
                attribute_value  => 'GENERIC' 
            ); 
        end;#' 
        );  
    end create_text_preferences;




procedure create_text_preferences_1 is 
    begin 
        -- Datastore Preference: Index the VORSCHRIFT_NUMMER and the VORSCHRIFT_BEZEICHNUNG_DEUTSCH columns 
        execute_sql(q'#  
        begin 
            ctx_ddl.create_preference( 
                preference_name  => 'RI_VORSCHRIFT_DS_PREF_1', 
                object_name      => 'MULTI_COLUMN_DATASTORE' 
            ); 
         
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_DS_PREF_1', 
                attribute_name   => 'COLUMNS', 
                attribute_value  => 'VORSCHRIFT_NUMMER,VORSCHRIFT_BEZEICHNUNG_DEUTSCH' 
            ); 
         
            ctx_ddl.create_section_group( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF_1', 
                group_type       => 'XML_SECTION_GROUP' 
            ); 
         
            ctx_ddl.add_field_section( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF_1', 
                section_name     => 'VORSCHRIFT_BEZEICHNUNG_DEUTSCH', 
                tag              => 'VORSCHRIFT_BEZEICHNUNG_DEUTSCH', 
                visible          => true 
            ); 
         
            ctx_ddl.add_field_section( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF_1', 
                section_name     => 'VORSCHRIFT_NUMMER', 
                tag              => 'VORSCHRIFT_NUMMER', 
                visible          => true 
            ); 
         
            ctx_ddl.create_preference( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_1', 
                object_name      => 'BASIC_LEXER' 
            ); 
         
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_1', 
                attribute_name   => 'MIXED_CASE', 
                attribute_value  => 'NO' 
            ); 
         
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_1', 
                attribute_name   => 'BASE_LETTER', 
                attribute_value  => 'YES' 
            ); 
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_1', 
                attribute_name   => 'BASE_LETTER_TYPE', 
                attribute_value  => 'GENERIC' 
            ); 
        end;#' 
        );  
    end create_text_preferences_1;






 procedure create_text_preferences_norm is 
    begin

     execute_sql(q'#  
        begin  
            ctx_ddl.create_preference( 
                preference_name  => 'RI_VORSCHRIFT_DS_PREF_NORM', 
                object_name      => 'MULTI_COLUMN_DATASTORE' 
            ); 

            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_DS_PREF_NORM', 
                attribute_name   => 'COLUMNS', 
                attribute_value  => 'BEZEICHNUNG'
            ); 

            ctx_ddl.create_section_group( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF_NORM', 
                group_type       => 'XML_SECTION_GROUP' 
            ); 

            ctx_ddl.add_field_section( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF_NORM', 
                section_name     => 'BEZEICHNUNG', 
                tag              => 'BEZEICHNUNG', 
                visible          => true 
            ); 

            ctx_ddl.create_preference( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_NORM', 
                object_name      => 'BASIC_LEXER' 
            ); 

            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_NORM', 
                attribute_name   => 'MIXED_CASE', 
                attribute_value  => 'NO' 
            ); 

            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_NORM', 
                attribute_name   => 'BASE_LETTER', 
                attribute_value  => 'YES' 
            ); 
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_NORM', 
                attribute_name   => 'BASE_LETTER_TYPE', 
                attribute_value  => 'GENERIC' 
            ); 
    end;#' 
        );  
    end create_text_preferences_norm;


    procedure create_text_index is 
    begin 
        execute immediate  
q'#create index ri_vorschrift_text_ftx on T_VORSCHRIFT_SYNTHETIC (VORSCHRIFT_NUMMER) 
   indextype is ctxsys.context parameters ( 'section group  RI_VORSCHRIFT_SG_PREF 
                                             datastore      RI_VORSCHRIFT_DS_PREF 
                                             lexer          RI_VORSCHRIFT_LX_PREF 
                                             stoplist       ctxsys.empty_stoplist 
                                             memory         10M 
                                             sync           (on commit)')#'; 
    end create_text_index;



    procedure create_text_index_1 is 
    begin 
        execute immediate  
q'#create index ri_vorschrift_text_ftx_1 on T_VORSCHRIFT_SYNTHETIC_1 (VORSCHRIFT_NUMMER) 
   indextype is ctxsys.context parameters ( 'section group  RI_VORSCHRIFT_SG_PREF_1
                                             datastore      RI_VORSCHRIFT_DS_PREF_1
                                             lexer          RI_VORSCHRIFT_LX_PREF_1
                                             stoplist       ctxsys.empty_stoplist 
                                             memory         10M 
                                             sync           (on commit)')#'; 
    end create_text_index_1;





procedure create_text_index_norm is
begin 
        execute immediate  
q'#create index ri_vorschrift_text_ftx_norm on T_norm (BEZEICHNUNG) 
   indextype is ctxsys.context parameters ( 'section group  RI_VORSCHRIFT_SG_PREF_NORM 
                                             datastore      RI_VORSCHRIFT_DS_PREF_NORM 
                                             lexer          RI_VORSCHRIFT_LX_PREF_NORM 
                                             stoplist       ctxsys.empty_stoplist 
                                             memory         10M 
                                             sync           (on commit)')#'; 
    end create_text_index_norm;


/*

-- minus not working correctly in lov ( list of value ) also for this convert text query function

 function convert_text_query( p_enduser_query in varchar2 ) return varchar2  
is  
    l_tokens       apex_t_varchar2 := apex_t_varchar2();

    c_xml constant varchar2(32767) := '<query><textquery><progression>' || 
                                        '<seq>#NORMAL#</seq>' || 
                                        '<seq>#FUZZY#</seq>' || 
                                      '</progression></textquery></query>'; 
    l_textquery    varchar2(32767);

    --------------------------------------------------------------------------------
    procedure tokenize
    is
        c_len constant pls_integer := length( p_enduser_query );
        l_pos pls_integer := 1;
        l_char varchar2( 1 char );
        l_quoted boolean := false;
        l_token  varchar2(32767);
    begin
        <<char_reader_loop>>
        while l_pos <= c_len loop
            l_char := substr( p_enduser_query, l_pos, 1 );
            if l_char = '"' then
                if substr( p_enduser_query, l_pos + 1) = '"' then
                     l_token := l_token || l_char;
                     l_pos := l_pos + 2;
                     continue char_reader_loop;
                end if;
                l_token := trim( both from l_token );
                if l_token is not null then
                    if l_quoted then
                        apex_string.push( l_tokens, l_token );
                    else
                        l_tokens := l_tokens multiset union apex_string.split( l_token, ' ' );
                    end if;
                    l_token := '';
                end if;

                l_quoted := not l_quoted;
            else
                l_token := l_token || l_char;
            end if;
            l_pos := l_pos + 1;
        end loop char_reader_loop;

        l_token := trim( both from l_token );
        if l_token is not null then
            l_tokens := l_tokens multiset union (apex_string.split( l_token, ' ' ));
        end if;
    end tokenize;
    --------------------------------------------------------------------------------
    function generate_query( 
            p_feature in varchar2) 
            return varchar2 is 
        l_query       varchar2(32767); 
        l_clean_token varchar2(32767); 
        l_not         boolean;
    begin 
        for i in 1..l_tokens.count loop 
            l_clean_token := lower( regexp_replace( l_tokens( i ), '[<>{}/()*%&!$?.:,;\+#]', '' ) ); 
            l_not         := false;
            if ltrim( rtrim( l_clean_token ) ) is not null then 

                l_not := l_clean_token like '-%';

                if l_query is not null and not l_not then
                    l_query := l_query || ' and '; 
                end if; 

                if l_not then
                    l_query := l_query || 'NOT ';
                    l_clean_token := substr( l_clean_token, 2 );
                end if;

                if p_feature = 'FUZZY' then
                    if l_clean_token like '%"%' then
                        l_query := l_query || 'FUZZY("' || trim(both '"' from l_clean_token) || '", 50, 500) ';
                    else
                        l_query := l_query || 'FUZZY({' || l_clean_token || '}, 50, 500) ';
                    end if;
                else
                    if l_clean_token like '%"%' then
                        l_query := l_query || '"' || trim(both '"' from l_clean_token) || '"';
                    else
                        l_query := l_query || '{' || l_clean_token || '}';
                    end if;
                end if;

            end if; 
        end loop; 
        return ltrim( rtrim( l_query ));  
    end generate_query; 
begin 
    if substr( p_enduser_query, 1, 8 ) = 'ORATEXT:' then 
        return substr( p_enduser_query, 9 ); 
    else  
        l_textquery := c_xml; 

        
        if substr(p_enduser_query, 1, 1) = '"' and substr(p_enduser_query, -1) = '"' then
    l_textquery := replace( l_textquery, '#NORMAL#', '"' || trim(both '"' from p_enduser_query) || '"' );
    l_textquery := replace( l_textquery, '#FUZZY#', 'FUZZY("' || trim(both '"' from p_enduser_query) || '", 50, 500)' );
else
    tokenize;
    l_textquery := replace( l_textquery, '#NORMAL#', generate_query( 'NORMAL' ) );
    l_textquery := replace( l_textquery, '#FUZZY#', generate_query( 'FUZZY' ) );
end if;
        
        apex_debug.info( '#### Oracle TEXT Query is: %s', l_textquery);
        return l_textquery; 
    end if; 
end convert_text_query;
*/



-- minus working correctly in lov ( list of value ) also for this convert text query function

function convert_text_query( p_enduser_query in varchar2 ) return varchar2  
is  
    l_tokens       apex_t_varchar2 := apex_t_varchar2();
    c_xml constant varchar2(32767) := '<query><textquery><progression>' || 
                                        '<seq>#NORMAL#</seq>' || 
                                        '<seq>#FUZZY#</seq>' || 
                                      '</progression></textquery></query>'; 
    l_textquery    varchar2(32767);
    --------------------------------------------------------------------------------
    procedure tokenize
    is
        c_len constant pls_integer := length( p_enduser_query );
        l_pos pls_integer := 1;
        l_char varchar2( 1 char );
        l_quoted boolean := false;
        l_token  varchar2(32767);
    begin
        <<char_reader_loop>>
        while l_pos <= c_len loop
            l_char := substr( p_enduser_query, l_pos, 1 );
            if l_char = '"' then
                if substr( p_enduser_query, l_pos + 1) = '"' then
                     l_token := l_token || l_char;
                     l_pos := l_pos + 2;
                     continue char_reader_loop;
                end if;
                l_token := trim( both from l_token );
                if l_token is not null then
                    if l_quoted then
                        apex_string.push( l_tokens, l_token );
                    else
                        l_tokens := l_tokens multiset union apex_string.split( l_token, ' ' );
                    end if;
                    l_token := '';
                end if;
                l_quoted := not l_quoted;
            else
                l_token := l_token || l_char;
            end if;
            l_pos := l_pos + 1;
        end loop char_reader_loop;
        l_token := trim( both from l_token );
        if l_token is not null then
            l_tokens := l_tokens multiset union (apex_string.split( l_token, ' ' ));
        end if;
    end tokenize;
    --------------------------------------------------------------------------------
    function generate_query( 
            p_feature in varchar2) 
            return varchar2 is 
        l_query       varchar2(32767); 
        l_clean_token varchar2(32767); 
        l_not         boolean;
    begin 
        for i in 1..l_tokens.count loop 
            l_clean_token := lower( regexp_replace( l_tokens( i ), '[<>{}/()*%&!$?.:,;\+#]', '' ) ); 
            l_not         := false;
            if ltrim( rtrim( l_clean_token ) ) is not null then 
                l_not := l_clean_token like '-%' AND l_clean_token NOT like '-';
                if l_query is not null and not l_not then
                    l_query := l_query || ' and '; 
                end if; 
                if l_not then
                    l_query := l_query || 'NOT ';
                    l_clean_token := substr( l_clean_token, 2 );
                end if;
                if p_feature = 'FUZZY' then
                    if l_clean_token like '%"%' then
                        l_query := l_query || 'FUZZY("' || trim(both '"' from l_clean_token) || '", 50, 500) ';
                    else
                        l_query := l_query || 'FUZZY({' || l_clean_token || '}, 50, 500) ';
                    end if;
                else
                    if l_clean_token like '%"%' then
                        l_query := l_query || '"' || trim(both '"' from l_clean_token) || '"';
                    else
                        l_query := l_query || '{' || l_clean_token || '}';
                    end if;
                end if;
            end if; 
        end loop; 
        return ltrim( rtrim( l_query ));  
    end generate_query; 
begin 
    if substr( p_enduser_query, 1, 8 ) = 'ORATEXT:' then 
        return substr( p_enduser_query, 9 ); 
    else  
        l_textquery := c_xml; 
        
        if substr(p_enduser_query, 1, 1) = '"' and substr(p_enduser_query, -1) = '"' then
    l_textquery := replace( l_textquery, '#NORMAL#', '"' || trim(both '"' from p_enduser_query) || '"' );
    l_textquery := replace( l_textquery, '#FUZZY#', 'FUZZY("' || trim(both '"' from p_enduser_query) || '", 50, 500)' );
else
    tokenize;
    l_textquery := replace( l_textquery, '#NORMAL#', generate_query( 'NORMAL' ) );
    l_textquery := replace( l_textquery, '#FUZZY#', generate_query( 'FUZZY' ) );
end if;
        
        apex_debug.info( '#### Oracle TEXT Query is: %s', l_textquery);
        return l_textquery; 
    end if; 
end convert_text_query;
end pck_ri_vorschrift_oracle_text_pkg;


-- lov (list of value ) oracle text


with cte_la as (
    select 
        normid,
        nvl(listagg(trim(la.b_nummer), ', ') within group (order by la.b_nummer), null) as laender_nummer,
        nvl(listagg(trim(la.LAND), ', ') within group (order by la.LAND), null) as laender_name
    from t_norm_ref_land nrl
    left outer join t_land la on nrl.landid = la.landid
    group by normid
)
select 
    n.normid, 
    n.bezeichnung as BEZEICHNUNG,
    :APEX$F1 as search_string,
    cte_la.laender_nummer as B_NUMMER,
    cte_la.laender_name as LAND
from T_NORM n
left outer join cte_la on cte_la.normid = n.normid
where n.normid not in (1016) 
  and (:APEX$F1 is null or contains(n.BEZEICHNUNG, (select PCK_RI_VORSCHRIFT_ORACLE_TEXT_PKG.convert_text_query(nvl(:APEX$F1, 'xxx')) from dual), 1) > 0)
order by n.BEZEICHNUNG asc;


-- code to test in sql commands -- contains -- oracle text -- query


SELECT pck_ri_vorschrift_oracle_text_pkg.convert_text_query('Kommaddi -Tharun') FROM dual;


SELECT VORSCHRIFTID, VORSCHRIFT_NUMMER, VORSCHRIFT_BEZEICHNUNG_DEUTSCH
FROM T_VORSCHRIFT_SYNTHETIC
WHERE CONTAINS(VORSCHRIFT_NUMMER, pck_ri_vorschrift_oracle_text_pkg.convert_text_query('"tarun"')) > 0;


-- code to drop text preferences in oracle Text


BEGIN
    -- Attempt to drop the datastore preference
    BEGIN
        CTX_DDL.DROP_PREFERENCE('RI_VORSCHRIFT_DS_PREF_NORM');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20000 THEN
                NULL; -- Ignore if the preference does not exist
            ELSE
                RAISE; -- Re-raise other unexpected errors
            END IF;
    END;
    
    -- Attempt to drop the lexer preference
    BEGIN
        CTX_DDL.DROP_PREFERENCE('RI_VORSCHRIFT_LX_PREF_NORM');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20000 THEN
                NULL; -- Ignore if the preference does not exist
            ELSE
                RAISE; -- Re-raise other unexpected errors
            END IF;
    END;
    
    -- Attempt to drop the section group
    BEGIN
        CTX_DDL.DROP_SECTION_GROUP('RI_VORSCHRIFT_SG_PREF_NORM');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20000 THEN
                NULL; -- Ignore if the section group does not exist
            ELSE
                RAISE; -- Re-raise other unexpected errors
            END IF;
    END;
END;




/* ORACLE TEXT MULTIPLE TABLES AND MULTIPLE INDEXES FROM MULTIPLE TABLES USING MATERIALIZED VIEW*/




-- INITIAL CODE 


drop table customers

drop table addresses


CREATE TABLE customers (
     customer_id NUMBER,
     first_name VARCHAR2(15),
     last_name VARCHAR2(15),
     CONSTRAINT customers_pk PRIMARY KEY (customer_id)
   );




CREATE TABLE addresses (
     customer_id NUMBER,
     street VARCHAR2(15),
     city VARCHAR2(50),
     state VARCHAR2(50),
     CONSTRAINT addresses_fk FOREIGN KEY (customer_id)
     REFERENCES customers (customer_id)
   );



INSERT INTO customers VALUES (1, 'Tharun', 'Smith');

INSERT INTO customers VALUES (2, 'Bob', 'Jones');

INSERT INTO customers VALUES (3, 'Kommaddi', 'williams');

INSERT INTO addresses VALUES (1, 'Dominik', 'REDWOOD SHORES', 'CA');

INSERT INTO addresses VALUES (2, 'Smith St.', 'Kommaddi Tharun', 'CA');

INSERT INTO addresses VALUES (3, 'Redwood St.', 'RIVERSIDE', 'CA');


/*
CREATE VIEW customer_addresses AS
SELECT
    c.first_name,
    c.last_name,
    a.street,
    a.city,
    a.state
FROM
    customers c
JOIN
    addresses a ON c.customer_id = a.customer_id;
*/

/*
CREATE MATERIALIZED VIEW customer_addresses AS
  SELECT
    c.first_name,
    c.last_name,
    a.street,
    a.city,
    a.state,
    CAST (NULL AS VARCHAR2(1)) AS dummy
   FROM
   customers c, addresses a
   WHERE c.customer_id = a.customer_id;

*/


CREATE MATERIALIZED VIEW customer_addresses
BUILD IMMEDIATE
REFRESH ON DEMAND
AS
SELECT
  c.first_name,
  c.last_name,
  a.street,
  a.city,
  a.state,
  CAST(NULL AS VARCHAR2(1)) AS dummy
FROM
  customers c
JOIN
  addresses a ON c.customer_id = a.customer_id;



BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name        => 'refresh_customer_addresses_mv',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN DBMS_MVIEW.REFRESH(''customer_addresses'',''C''); END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY; INTERVAL=5', -- Runs every 5 minutes
    enabled         => TRUE
  );
END;
/



INSERT INTO customers VALUES (4, 'Thomas', 'Tschernich');

INSERT INTO addresses VALUES (4, 'Schrobenhausen', 'EMANO', 'DE');





-- SPECIFICATION


create or replace package pck_ri_vorschrift_oracle_text_pkg authid current_user is 
 
    function text_is_available return boolean; 
 
    procedure create_text_preferences;
    procedure create_text_preferences_1;
    procedure create_text_preferences_norm;
    procedure create_text_preferences_mv; 
 
    procedure drop_text_preferences;
    procedure drop_text_preferences_1;
    procedure drop_text_preferences_norm;
    procedure drop_text_preferences_mv; 
 
    procedure create_text_index;
    procedure create_text_index_1;
    procedure create_text_index_norm;
    procedure create_text_index_mv; 

    procedure drop_text_index;
    procedure drop_text_index_1;
    procedure drop_text_index_norm;
    procedure drop_text_index_mv;
 
    procedure init_oracle_text; 
 
    function convert_text_query( p_enduser_query  in varchar2 ) return varchar2; 
 
end pck_ri_vorschrift_oracle_text_pkg;
/




-- BODY

create or replace package body pck_ri_vorschrift_oracle_text_pkg is 
    procedure execute_sql( 
        p_sql         in varchar2,  
        p_throw_error in boolean default true 
    ) is 
    begin 
        execute immediate p_sql; 
    exception 
        when others then  
            if p_throw_error then raise; end if; 
    end execute_sql; 
    
    function text_is_available return boolean  
    is 
        l_dummy number; 
    begin 
        select 1 into l_dummy  
          from sys.all_objects 
         where owner       = 'CTXSYS'  
           and object_name = 'CTX_DDL'  
           and rownum      = 1; 
        return true; 
    exception  
        when NO_DATA_FOUND then return false; 
    end text_is_available; 

    procedure init_oracle_text is 
    begin 
        if text_is_available then 
            create_text_preferences; 
            create_text_index; 
        end if; 
    end init_oracle_text; 
    
    procedure drop_text_index is  
    begin 
        execute_sql( q'#drop index RI_VORSCHRIFT_TEXT_FTX force#' ); 
    end drop_text_index;


    procedure drop_text_index_1 is  
    begin 
        execute_sql( q'#drop index RI_VORSCHRIFT_TEXT_FTX_1 force#' ); 
    end drop_text_index_1;

    procedure drop_text_index_norm is  
    begin 
        execute_sql( q'#drop index RI_VORSCHRIFT_TEXT_FTX_NORM force#' ); 
    end drop_text_index_norm;

    procedure drop_text_index_mv is  
    begin 
        execute_sql( q'#drop index RI_VORSCHRIFT_TEXT_FTX_MV force#' ); 
    end drop_text_index_mv; 


    procedure drop_text_preferences is 
    begin 
        execute_sql( q'#begin ctx_ddl.drop_preference( 'RI_VORSCHRIFT_LX_PREF'); end;#', false );  
        execute_sql( q'#begin ctx_ddl.drop_preference( 'RI_VORSCHRIFT_DS_PREF'); end;#', false );  
        execute_sql( q'#begin ctx_ddl.drop_section_group( 'RI_VORSCHRIFT_SG_PREF'); end;#', false );  
    end drop_text_preferences;

    procedure drop_text_preferences_1 is 
    begin 
        execute_sql( q'#begin ctx_ddl.drop_preference( 'RI_VORSCHRIFT_LX_PREF_1'); end;#', false );  
        execute_sql( q'#begin ctx_ddl.drop_preference( 'RI_VORSCHRIFT_DS_PREF_1'); end;#', false );  
        execute_sql( q'#begin ctx_ddl.drop_section_group( 'RI_VORSCHRIFT_SG_PREF_1'); end;#', false );  
    end drop_text_preferences_1;

    procedure drop_text_preferences_norm is 
    begin 
        execute_sql( q'#begin ctx_ddl.drop_preference( 'RI_VORSCHRIFT_LX_PREF'); end;#', false );  
        execute_sql( q'#begin ctx_ddl.drop_preference( 'RI_VORSCHRIFT_DS_PREF'); end;#', false );  
        execute_sql( q'#begin ctx_ddl.drop_section_group( 'RI_VORSCHRIFT_SG_PREF'); end;#', false );  
    end drop_text_preferences_norm;


    procedure drop_text_preferences_mv is 
    begin 
        execute_sql( q'#begin ctx_ddl.drop_preference( 'RI_VORSCHRIFT_LX_PREF_MV'); end;#', false );  
        execute_sql( q'#begin ctx_ddl.drop_preference( 'RI_VORSCHRIFT_DS_PREF_MV'); end;#', false );  
        execute_sql( q'#begin ctx_ddl.drop_section_group( 'RI_VORSCHRIFT_SG_PREF_MV'); end;#', false );  
    end drop_text_preferences_mv;
    

    procedure create_text_preferences is 
    begin 
        -- Datastore Preference: Index the VORSCHRIFT_NUMMER and the VORSCHRIFT_BEZEICHNUNG_DEUTSCH columns 
        execute_sql(q'#  
        begin 
            ctx_ddl.create_preference( 
                preference_name  => 'RI_VORSCHRIFT_DS_PREF', 
                object_name      => 'MULTI_COLUMN_DATASTORE' 
            ); 
         
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_DS_PREF', 
                attribute_name   => 'COLUMNS', 
                attribute_value  => 'VORSCHRIFT_NUMMER,VORSCHRIFT_BEZEICHNUNG_DEUTSCH' 
            ); 
         
            ctx_ddl.create_section_group( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF', 
                group_type       => 'XML_SECTION_GROUP' 
            ); 
         
            ctx_ddl.add_field_section( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF', 
                section_name     => 'VORSCHRIFT_BEZEICHNUNG_DEUTSCH', 
                tag              => 'VORSCHRIFT_BEZEICHNUNG_DEUTSCH', 
                visible          => true 
            ); 
         
            ctx_ddl.add_field_section( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF', 
                section_name     => 'VORSCHRIFT_NUMMER', 
                tag              => 'VORSCHRIFT_NUMMER', 
                visible          => true 
            ); 
         
            ctx_ddl.create_preference( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF', 
                object_name      => 'BASIC_LEXER' 
            ); 
         
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF', 
                attribute_name   => 'MIXED_CASE', 
                attribute_value  => 'NO' 
            ); 
         
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF', 
                attribute_name   => 'BASE_LETTER', 
                attribute_value  => 'YES' 
            ); 
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF', 
                attribute_name   => 'BASE_LETTER_TYPE', 
                attribute_value  => 'GENERIC' 
            ); 
        end;#' 
        );  
    end create_text_preferences;




procedure create_text_preferences_1 is 
    begin 
        -- Datastore Preference: Index the VORSCHRIFT_NUMMER and the VORSCHRIFT_BEZEICHNUNG_DEUTSCH columns 
        execute_sql(q'#  
        begin 
            ctx_ddl.create_preference( 
                preference_name  => 'RI_VORSCHRIFT_DS_PREF_1', 
                object_name      => 'MULTI_COLUMN_DATASTORE' 
            ); 
         
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_DS_PREF_1', 
                attribute_name   => 'COLUMNS', 
                attribute_value  => 'VORSCHRIFT_NUMMER,VORSCHRIFT_BEZEICHNUNG_DEUTSCH' 
            ); 
         
            ctx_ddl.create_section_group( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF_1', 
                group_type       => 'XML_SECTION_GROUP' 
            ); 
         
            ctx_ddl.add_field_section( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF_1', 
                section_name     => 'VORSCHRIFT_BEZEICHNUNG_DEUTSCH', 
                tag              => 'VORSCHRIFT_BEZEICHNUNG_DEUTSCH', 
                visible          => true 
            ); 
         
            ctx_ddl.add_field_section( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF_1', 
                section_name     => 'VORSCHRIFT_NUMMER', 
                tag              => 'VORSCHRIFT_NUMMER', 
                visible          => true 
            ); 
         
            ctx_ddl.create_preference( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_1', 
                object_name      => 'BASIC_LEXER' 
            ); 
         
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_1', 
                attribute_name   => 'MIXED_CASE', 
                attribute_value  => 'NO' 
            ); 
         
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_1', 
                attribute_name   => 'BASE_LETTER', 
                attribute_value  => 'YES' 
            ); 
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_1', 
                attribute_name   => 'BASE_LETTER_TYPE', 
                attribute_value  => 'GENERIC' 
            ); 
        end;#' 
        );  
    end create_text_preferences_1;






 procedure create_text_preferences_norm is 
    begin

     execute_sql(q'#  
        begin  
            ctx_ddl.create_preference( 
                preference_name  => 'RI_VORSCHRIFT_DS_PREF_NORM', 
                object_name      => 'MULTI_COLUMN_DATASTORE' 
            ); 

            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_DS_PREF_NORM', 
                attribute_name   => 'COLUMNS', 
                attribute_value  => 'BEZEICHNUNG'
            ); 

            ctx_ddl.create_section_group( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF_NORM', 
                group_type       => 'XML_SECTION_GROUP' 
            ); 

            ctx_ddl.add_field_section( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF_NORM', 
                section_name     => 'BEZEICHNUNG', 
                tag              => 'BEZEICHNUNG', 
                visible          => true 
            ); 

            ctx_ddl.create_preference( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_NORM', 
                object_name      => 'BASIC_LEXER' 
            ); 

            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_NORM', 
                attribute_name   => 'MIXED_CASE', 
                attribute_value  => 'NO' 
            ); 

            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_NORM', 
                attribute_name   => 'BASE_LETTER', 
                attribute_value  => 'YES' 
            ); 
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_NORM', 
                attribute_name   => 'BASE_LETTER_TYPE', 
                attribute_value  => 'GENERIC' 
            ); 
    end;#' 
        );  
    end create_text_preferences_norm;

    
procedure create_text_preferences_mv is 
    begin 
        -- Datastore Preference: Index the VORSCHRIFT_NUMMER and the VORSCHRIFT_BEZEICHNUNG_DEUTSCH columns 
        execute_sql(q'#  
        begin 
            ctx_ddl.create_preference( 
                preference_name  => 'RI_VORSCHRIFT_DS_PREF_MV', 
                object_name      => 'MULTI_COLUMN_DATASTORE' 
            ); 
         
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_DS_PREF_MV', 
                attribute_name   => 'COLUMNS', 
                attribute_value  => 'FIRST_NAME,LAST_NAME,STREET,CITY'
            ); 
         
            ctx_ddl.create_section_group( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF_MV', 
                group_type       => 'XML_SECTION_GROUP' 
            ); 
         
            ctx_ddl.add_field_section( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF_MV', 
                section_name     => 'CITY', 
                tag              => 'CITY', 
                visible          => true 
            ); 
         
            ctx_ddl.add_field_section( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF_MV', 
                section_name     => 'STREET', 
                tag              => 'STREET', 
                visible          => true 
            );

            ctx_ddl.add_field_section( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF_MV', 
                section_name     => 'LAST_NAME', 
                tag              => 'LAST_NAME', 
                visible          => true 
            ); 


            ctx_ddl.add_field_section( 
                group_name       => 'RI_VORSCHRIFT_SG_PREF_MV', 
                section_name     => 'FIRST_NAME', 
                tag              => 'FIRST_NAME', 
                visible          => true 
            ); 
         
            ctx_ddl.create_preference( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_MV', 
                object_name      => 'BASIC_LEXER' 
            ); 
         
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_MV', 
                attribute_name   => 'MIXED_CASE', 
                attribute_value  => 'NO' 
            ); 
         
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_MV', 
                attribute_name   => 'BASE_LETTER', 
                attribute_value  => 'YES' 
            ); 
            ctx_ddl.set_attribute( 
                preference_name  => 'RI_VORSCHRIFT_LX_PREF_MV', 
                attribute_name   => 'BASE_LETTER_TYPE', 
                attribute_value  => 'GENERIC' 
            ); 
        end;#' 
        );  
    end create_text_preferences_mv;






    procedure create_text_index is 
    begin 
        execute immediate  
q'#create index ri_vorschrift_text_ftx on T_VORSCHRIFT_SYNTHETIC (VORSCHRIFT_NUMMER) 
   indextype is ctxsys.context parameters ( 'section group  RI_VORSCHRIFT_SG_PREF 
                                             datastore      RI_VORSCHRIFT_DS_PREF 
                                             lexer          RI_VORSCHRIFT_LX_PREF 
                                             stoplist       ctxsys.empty_stoplist 
                                             memory         10M 
                                             sync           (on commit)')#'; 
    end create_text_index;



    procedure create_text_index_1 is 
    begin 
        execute immediate  
q'#create index ri_vorschrift_text_ftx_1 on T_VORSCHRIFT_SYNTHETIC_1 (VORSCHRIFT_NUMMER) 
   indextype is ctxsys.context parameters ( 'section group  RI_VORSCHRIFT_SG_PREF_1
                                             datastore      RI_VORSCHRIFT_DS_PREF_1
                                             lexer          RI_VORSCHRIFT_LX_PREF_1
                                             stoplist       ctxsys.empty_stoplist 
                                             memory         10M 
                                             sync           (on commit)')#'; 
    end create_text_index_1;





    procedure create_text_index_norm is
    begin 
            execute immediate  
    q'#create index ri_vorschrift_text_ftx_norm on T_norm (BEZEICHNUNG) 
       indextype is ctxsys.context parameters ( 'section group  RI_VORSCHRIFT_SG_PREF_NORM 
                                                 datastore      RI_VORSCHRIFT_DS_PREF_NORM 
                                                 lexer          RI_VORSCHRIFT_LX_PREF_NORM 
                                                 stoplist       ctxsys.empty_stoplist 
                                                 memory         10M 
                                                 sync           (on commit)')#'; 
    end create_text_index_norm;


    procedure create_text_index_mv is
    begin 
            execute immediate  
    q'#create index ri_vorschrift_text_ftx_mv on customer_addresses (dummy) 
       indextype is ctxsys.context parameters ( 'section group  RI_VORSCHRIFT_SG_PREF_MV
                                                 datastore      RI_VORSCHRIFT_DS_PREF_MV 
                                                 lexer          RI_VORSCHRIFT_LX_PREF_MV 
                                                 stoplist       ctxsys.empty_stoplist 
                                                 memory         10M 
                                                 sync           (on commit)')#'; 
    end create_text_index_mv;




function convert_text_query( p_enduser_query in varchar2 ) return varchar2  
is  
    l_tokens       apex_t_varchar2 := apex_t_varchar2();
    c_xml constant varchar2(32767) := '<query><textquery><progression>' || 
                                        '<seq>#NORMAL#</seq>' || 
                                        '<seq>#FUZZY#</seq>' || 
                                      '</progression></textquery></query>'; 
    l_textquery    varchar2(32767);
    --------------------------------------------------------------------------------
    procedure tokenize
    is
        c_len constant pls_integer := length( p_enduser_query );
        l_pos pls_integer := 1;
        l_char varchar2( 1 char );
        l_quoted boolean := false;
        l_token  varchar2(32767);
    begin
        <<char_reader_loop>>
        while l_pos <= c_len loop
            l_char := substr( p_enduser_query, l_pos, 1 );
            if l_char = '"' then
                if substr( p_enduser_query, l_pos + 1) = '"' then
                     l_token := l_token || l_char;
                     l_pos := l_pos + 2;
                     continue char_reader_loop;
                end if;
                l_token := trim( both from l_token );
                if l_token is not null then
                    if l_quoted then
                        apex_string.push( l_tokens, l_token );
                    else
                        l_tokens := l_tokens multiset union apex_string.split( l_token, ' ' );
                    end if;
                    l_token := '';
                end if;
                l_quoted := not l_quoted;
            else
                l_token := l_token || l_char;
            end if;
            l_pos := l_pos + 1;
        end loop char_reader_loop;
        l_token := trim( both from l_token );
        if l_token is not null then
            l_tokens := l_tokens multiset union (apex_string.split( l_token, ' ' ));
        end if;
    end tokenize;
    --------------------------------------------------------------------------------
    function generate_query( 
            p_feature in varchar2) 
            return varchar2 is 
        l_query       varchar2(32767); 
        l_clean_token varchar2(32767); 
        l_not         boolean;
    begin 
        for i in 1..l_tokens.count loop 
            l_clean_token := lower( regexp_replace( l_tokens( i ), '[<>{}/()*%&!$?.:,;\+#]', '' ) ); 
            l_not         := false;
            if ltrim( rtrim( l_clean_token ) ) is not null then 
                l_not := l_clean_token like '-%' AND l_clean_token NOT like '-';
                if l_query is not null and not l_not then
                    l_query := l_query || ' and '; 
                end if; 
                if l_not then
                    l_query := l_query || 'NOT ';
                    l_clean_token := substr( l_clean_token, 2 );
                end if;
                if p_feature = 'FUZZY' then
                    if l_clean_token like '%"%' then
                        l_query := l_query || 'FUZZY("' || trim(both '"' from l_clean_token) || '", 50, 500) ';
                    else
                        l_query := l_query || 'FUZZY({' || l_clean_token || '}, 50, 500) ';
                    end if;
                else
                    if l_clean_token like '%"%' then
                        l_query := l_query || '"' || trim(both '"' from l_clean_token) || '"';
                    else
                        l_query := l_query || '{' || l_clean_token || '}';
                    end if;
                end if;
            end if; 
        end loop; 
        return ltrim( rtrim( l_query ));  
    end generate_query; 
begin 
    if substr( p_enduser_query, 1, 8 ) = 'ORATEXT:' then 
        return substr( p_enduser_query, 9 ); 
    else  
        l_textquery := c_xml; 
        
        if substr(p_enduser_query, 1, 1) = '"' and substr(p_enduser_query, -1) = '"' then
    l_textquery := replace( l_textquery, '#NORMAL#', '"' || trim(both '"' from p_enduser_query) || '"' );
    l_textquery := replace( l_textquery, '#FUZZY#', 'FUZZY("' || trim(both '"' from p_enduser_query) || '", 50, 500)' );
else
    tokenize;
    l_textquery := replace( l_textquery, '#NORMAL#', generate_query( 'NORMAL' ) );
    l_textquery := replace( l_textquery, '#FUZZY#', generate_query( 'FUZZY' ) );
end if;
        
        apex_debug.info( '#### Oracle TEXT Query is: %s', l_textquery);
        return l_textquery; 
    end if; 
end convert_text_query;
end pck_ri_vorschrift_oracle_text_pkg;
/












/* html and css for the alignment */

-- html to show while doing oracle text introduction

<p>This page shows how Oracle Text can be used within an Interactive Report to perform full-text search using linguistic features.</p>
<p>In this example, Oracle Text features are available to search the <b>VORSCHRIFT_NUMMER</b> and <b>VORSCHRIFT_BEZEICHNUNG_DEUTSCH</b> columns with the Interactive Report.</p>
<p>Few Test Cases which will work using Oracle Text</p>
<ul>
    <p style="color: #bb0a31;">Oracle Text <b>FUZZY</b> search on <b>VORSCHRIFT_NUMMER</b> column</p>
    <li><b>Thms</b><span class="align-colon">:</span> VORSCHRIFT_NUMMER - <strong> Tschernich Thomas</strong></li>
    <li><b>Domnk</b><span class="align-colon">:</span> VORSCHRIFT_NUMMER - <strong> Braunbeck Dominik</strong></li>
    <li><b>UN R</b><span class="align-colon">:</span> VORSCHRIFT_NUMMER -  <strong> UN-R</strong></li>
    <li><b>GB T</b><span class="align-colon">:</span> VORSCHRIFT_NUMMER -  <strong> GB/T and other records which match this</strong></li>
    <li><b>UN R 119 01 Suplmnt 2</b><span class="align-colon">:</span> VORSCHRIFT_NUMMER - <strong> UN-R 119/01 Supplement 2</strong></li>
    <li><b>119 00</b><span class="align-colon">:</span> VORSCHRIFT_NUMMER - <strong> UN-R 119/00 Supplement 4 and other records which match this</strong></li>
    <li><b>Brsbeläge</b><span class="align-colon">:</span> VORSCHRIFT_BEZEICHNUNG_DEUTSCH - <strong> Bremsbeläge für Automobile</strong></li>
    <br>

    <p style="color: #bb0a31;">Oracle Text <b>FUZZY</b> search on <b>VORSCHRIFT_NUMMER</b>, <b>VORSCHRIFT_BEZEICHNUNG_DEUTSCH</b> columns</p>
    <li><b>GB Bremsbeläge</b><span class="align-colon">:</span> VORSCHRIFT_NUMMER - <strong>GB 5763-2008</strong> ; VORSCHRIFT_BEZEICHNUNG_DEUTSCH - <strong> Bremsbeläge für Automobile</strong> &nbsp;&nbsp;&nbsp; <i> Normal record with two columns data </i> </li>
    <br>

    <p style="color: #bb0a31;">I have two records in data base for <b>VORSCHRIFT_NUMMER</b> column<br></p>
    <ol> 
    <li>Tschernich Thomas</li>
    <li>Tschernich is a software developer</li>
    </ol>

    <p style="color: #bb0a31;">Oracle Text <b>MINUS</b> search on <b>VORSCHRIFT_NUMMER</b> column</li></p>

    <li><b>Tschernich -Thomas</b><span class="align-colon">:</span> VORSCHRIFT_NUMMER - <strong> Tschernich is a software developer</strong> &nbsp;&nbsp;&nbsp; <i> Minus</i> </li>
    <!-- <li><b>emano -audi</b><span class="align-colon">:</span> VORSCHRIFT_NUMMER - <strong> emano</strong> &nbsp;&nbsp;&nbsp; <i> Minus</i> </li> -->
    <br>

    <p style="color: #bb0a31;">Oracle Text <b>EXACT PHRASE</b> search on <b>VORSCHRIFT_NUMMER</b> column</p>

    <li><b>Tschernich developer</b><span class="align-colon">:</span> VORSCHRIFT_NUMMER - <strong> Tschernich is a software developer</strong> &nbsp;&nbsp;&nbsp; <i> Normal record without using exact phrase </i> </li>
    <li><b>"Tschernich developer"</b><span class="align-colon">:</span> VORSCHRIFT_NUMMER - <strong> No Record Found</strong> &nbsp;&nbsp;&nbsp; <i> Exact Phrase</i> </li>
    <li><b>"software developer"</b><span class="align-colon">:</span> VORSCHRIFT_NUMMER - <strong> Tschernich is a software developer</strong> &nbsp;&nbsp;&nbsp; <i> Exact Phrase</i> </li>
    <li><b>"Tschernich tomas"</b><span class="align-colon">:</span> VORSCHRIFT_NUMMER - <strong> No Record Found </strong> &nbsp;&nbsp;&nbsp; <i> Exact Phrase</i> </li>
    <li><b>"Tschernich Thomas"</b><span class="align-colon">:</span> VORSCHRIFT_NUMMER - <strong> Tschernich Thomas </strong> &nbsp;&nbsp;&nbsp; <i> Exact Phrase</i> </li>

</ul>


-- inline css for that html 

.align-colon:before {
    content: '';
    display: inline-block;
    width: 1px;
}
ul {
    list-style-type: disc;
}
li b {
    display: inline-block;
    width: 180px;
}



/* Icon will show instead of link in interactive Report but when we click on icon it will 
redirect to link in new tab. for that we need to write that code in sql report using case statement*/

CASE WHEN v.url_getex_vorschrift IS NOT NULL 
            THEN '<a href="' || v.url_getex_vorschrift || '" title="' || v.url_getex_vorschrift || '"><span class="fa fa-link"></span></a>'
            ELSE null
END AS getex_vorschrift_link



/* To empty the columsn name we will use nbsp; for the column to keep empty in interactive report*/

&nbsp;





/* Procedure with two parameters returning output like select statement */

CREATE OR REPLACE PROCEDURE FILTER_DATA (
    p_operator IN VARCHAR2,
    p_kpb IN VARCHAR2
)
IS
    sql_stmt VARCHAR2(500);
    -- Declare a cursor variable
    type t_cursor is ref cursor;
    c_cursor t_cursor;
    rec T_KPB%ROWTYPE;
BEGIN
    
    IF p_operator = 'gleich' THEN
        sql_stmt := 'SELECT KPB_ID, KPB, KPB_TEXT FROM T_KPB WHERE KPB = :1';
    ELSIF p_operator = 'ungleich' THEN
        sql_stmt := 'SELECT KPB_ID, KPB, KPB_TEXT FROM T_KPB WHERE KPB <> :1';
    ELSE
        
        RAISE_APPLICATION_ERROR(-20001, 'Invalid operator specified.');
    END IF;

   
    OPEN c_cursor FOR sql_stmt USING p_kpb;

    -- Loop to fetch and output each row from the cursor
    LOOP
        FETCH c_cursor INTO rec;
        EXIT WHEN c_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('KPB_ID: ' || rec.KPB_ID || ', KPB: ' || rec.KPB || ', KPB_TEXT: ' || rec.KPB_TEXT);
    END LOOP;

    
    CLOSE c_cursor;
END FILTER_DATA;
/







BEGIN
    FILTER_DATA('ungleich', 'AU310/6EU_B');
END;
/





/* Procedure with two parameters returning output like only ids */


CREATE OR REPLACE PROCEDURE FILTER_DATA (
    p_operator IN VARCHAR2,
    p_kpb IN VARCHAR2
)
IS
    sql_stmt VARCHAR2(500);
    -- Declare a cursor variable
    type t_cursor is ref cursor;
    c_cursor t_cursor;
    rec T_KPB%ROWTYPE;
BEGIN
    
    IF p_operator = 'gleich' THEN
        sql_stmt := 'SELECT KPB_ID, KPB, KPB_TEXT FROM T_KPB WHERE KPB = :1';
    ELSIF p_operator = 'ungleich' THEN
        sql_stmt := 'SELECT KPB_ID, KPB, KPB_TEXT FROM T_KPB WHERE KPB <> :1';
    ELSE
        
        RAISE_APPLICATION_ERROR(-20001, 'Invalid operator specified.');
    END IF;

   
    OPEN c_cursor FOR sql_stmt USING p_kpb;

    -- Loop to fetch and output each row from the cursor
    LOOP
        FETCH c_cursor INTO rec;
        EXIT WHEN c_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(rec.KPB_ID);
    END LOOP;

    
    CLOSE c_cursor;
END FILTER_DATA;
/


BEGIN
    FILTER_DATA('gleich', 'AU310/6EU_B');
END;
/





/* Procedure with two parameters returning output like only ids */


-- PROCEDURE


CREATE OR REPLACE PROCEDURE FILTER_DATA (
    p_operator IN VARCHAR2,
    p_kpb IN VARCHAR2,
    p_list IN VARCHAR2 DEFAULT NULL -- This parameter is used for 'in' and 'not in' conditions
)
IS
    sql_stmt VARCHAR2(1000);
    -- Declare a cursor variable
    type t_cursor is ref cursor;
    c_cursor t_cursor;
    kpb_id T_KPB.KPB_ID%TYPE;
BEGIN
    
    CASE p_operator
        WHEN 'gleich' THEN
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE KPB = :1';
        WHEN 'ungleich' THEN
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE KPB <> :1';
        WHEN 'ist leer' THEN
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE TRIM(KPB) IS NULL OR KPB = '''''; -- Considering empty string as well
        WHEN 'ist nicht leer' THEN
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE TRIM(KPB) IS NOT NULL AND KPB <> ''''';
        WHEN 'in' THEN
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE KPB IN (' || p_list || ')';
        WHEN 'nicht in' THEN
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE KPB NOT IN (' || p_list || ')';
        WHEN 'enthält' THEN
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE KPB LIKE ''%' || p_kpb || '%''';
        WHEN 'enthält nicht' THEN
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE KPB NOT LIKE ''%' || p_kpb || '%''';
        WHEN 'beginnt mit' THEN
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE KPB LIKE ''' || p_kpb || '%''';
        WHEN 'beginnt nicht mit' THEN
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE KPB NOT LIKE ''' || p_kpb || '%''';
        WHEN 'entspricht regulärem Ausdruck' THEN
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE REGEXP_LIKE(KPB, ''' || p_kpb || ''')';
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Invalid operator specified.');
    END CASE;

    IF p_operator IN ('in', 'nicht in') THEN
        EXECUTE IMMEDIATE sql_stmt;
    ELSE
        OPEN c_cursor FOR sql_stmt USING p_kpb;
    END IF;

    IF p_operator NOT IN ('in', 'nicht in') THEN
        LOOP
            FETCH c_cursor INTO kpb_id;
            EXIT WHEN c_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(kpb_id);
        END LOOP;
        CLOSE c_cursor;
    END IF;
    
END FILTER_DATA;



-- TEST CASES 


BEGIN
    FILTER_DATA('gleich', 'AU310/6EU_B');
END;


BEGIN
    FILTER_DATA('ungleich', 'AU310/6EU_B');
END;


BEGIN
    FILTER_DATA('ist leer', NULL); -- Here, p_kpb is not used, so NULL is passed.
END;


BEGIN
    FILTER_DATA('ist nicht leer', NULL); -- Here, p_kpb is not used, so NULL is passed.
END;


BEGIN
    FILTER_DATA('in', NULL, '''AU310/6EU_B'', ''AU536/0MY_K2'''); -- p_kpb is not used here, p_list is passed as a comma-separated string.
END;


BEGIN
    FILTER_DATA('nicht in', NULL, '''AU310/6EU_B'', ''AU536/0MY_K2'''); -- p_kpb is not used here, p_list is passed as a comma-separated string.
END;


BEGIN
    FILTER_DATA('enthält', 'CUV');
END;


BEGIN
    FILTER_DATA('enthält nicht', 'CUV');
END;


BEGIN
    FILTER_DATA('beginnt mit', 'AU3');
END;


BEGIN
    FILTER_DATA('beginnt nicht mit', 'AU3');
END;


BEGIN
    FILTER_DATA('entspricht regulärem Ausdruck', '^AU3.*B$'); -- This regex matches strings that start with 'AU3' and end with 'B'.
END;






/* EMANO REPORT */


-- SPECIFICATION

create or replace package emano_report is
    -- Die folgenden Konstanten sind vierstellig, da die Oracle-internen
    -- Entsprechungen 1-3-stellig sind
    cStringType constant number := 1001;
    cDateType constant number := 1002;
    cNumberType constant number := 1003;
    fQuery clob;
    runtime_exception exception; -- Für Programmier-Fehler oder noch nicht implementierten Code
    parameter_exception exception; -- Für ungültige Parameter
    fNumberOfColumns number;
    fRowCount number;
    cFetchLimit constant number := 32000;
    type tExcelConfig is record (
        fOffsetRows number default 4,
        fOffsetCols number default 1,
        fUseAutoFilter boolean default true,
        fUseFreezePane boolean default true
    );
    fExcelConfig tExcelConfig;
    type tStringResults is table of dbms_sql.clob_table;
    type tNumberResults is table of dbms_sql.Number_Table;
    type tDateResults is table of dbms_sql.Date_Table;
    type tColumn is record (
        fIndex number,
        fName varchar2(250),
        fDisplayName varchar2(250),
        fType number,
        fColumnWidth number  -- Für Excel: -1 --> Auto-Breite (default), 0 --> keine Breite
    );
    type tColumnTable is table of tColumn;
    fColumns tColumnTable := tColumnTable();
    fStringResults tStringResults := tStringResults();
    fDateResults tDateResults := tDateResults();
    fNumberResults tNumberResults := tNumberResults();
    
    type tArrayOfClob is table of clob;
    procedure pInit(aQuery in clob);
    procedure pExecute;
    function fGetColumnType(aColumnIndex in number) return number;
    function fMakeExcel(aSheetName in varchar2 default null) return blob;
    function fWrapperExcel(aSQL in varchar2) return blob;
    function fMakeCSV return blob;
    function fWrapperCSV(aSQL in varchar2) return blob;
 function fWrapperCSV2(aSQL in clob) return blob;
  --  function fMakeExcelMultSheet(aSheetName in apex_t_varchar2, aTitleName in apex_t_varchar2, aQuery in tArrayOfClob, aVertraulich in number default null) return blob;
    function fMakeExcelSingleSheet(aSheetName in varchar2, aTitleName in varchar2, aQuery in clob, aVertraulich in number default null) return blob;
    
end emano_report;


-- BODY

create or replace package body emano_report is
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
 
 
 
 
 
/* Single */
       
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
                        
 
                        /*
                        -- Check 'Current' section: Fill 'Local Regulation', 'Correction', and 'Comments' with gray if 'Local Regulation' is empty
                        if fGetStringValue(lZeile, lCurrentLocalRegColumnIndex) is null then
                       
                            if lSpalte in (lCurrentLocalRegColumnIndex,lCurrentCorrectionColumnIndex, lCurrentCommentsColumnIndex) then
                                lFillColor := lFillGray;
                            end if;
                        end if;
                        
                        -- Check 'Future' section: Fill 'Local Regulation' and related columns with gray if 'Local Regulation' is empty
                        if fGetStringValue(lZeile, lFutureLocalRegColumnIndex) is null then
                        
                            if lSpalte in (lFutureLocalRegColumnIndex,lFutureCorrectionColumnIndex, lFutureCommentsColumnIndex, lFutureEnactDateColumnIndex, lFutureImpDateNewTypeColumnIndex, lFutureImpDateAllVehiclesColumnIndex) then
                                lFillColor := lFillGray;
                            end if;
                        end if;
                        */
 
 
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
             
            /*
                -- Inside the loop where cells are formatted
                for lZeile in 1..fRowCount loop
 
                    for lSpalte in 1..(fNumberOfColumns-1) loop
                        lBorder := fMakeExcelCellBorder(lZeile, lSpalte);
                        lFillColor := lNoFill; -- Default to no fill
 
                        -- Directly set the gray fill for specific columns
                        if lSpalte in (lCurrentLocalRegColumnIndex, lCurrentCorrectionColumnIndex, lCurrentCommentsColumnIndex, lFutureLocalRegColumnIndex, lFutureCorrectionColumnIndex, lFutureCommentsColumnIndex, lFutureEnactDateColumnIndex, lFutureImpDateNewTypeColumnIndex, lFutureImpDateAllVehiclesColumnIndex) then
                            lFillColor := lFillGray;
                        end if;
 
                        -- Now call the procedure to make the Excel cell with the appropriate fill color.
                        pMakeExcelCell(lZeile, lSpalte, lFontCell, lFillColor, lBorder);
                    end loop;
                end loop;
            */
/*
-- Inside the loop where cells are formatted
for lZeile in 1..fRowCount loop
 
    for lSpalte in 1..(fNumberOfColumns-1) loop
        lBorder := fMakeExcelCellBorder(lZeile, lSpalte);
        lFillColor := lNoFill; -- Default to no fill
 
        -- Set the grey fill for the columns E, H, I, J, K
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
 
*/
 
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
        
             
end emano_report;





/* EXCEL XLSX BUILDER PKG */


-- SPECIFICATION

create or replace PACKAGE xlsx_builder_pkg
   AUTHID CURRENT_USER
IS
   /**********************************************
   **
   ** Author: Anton Scheffer
   ** Date: 19-02-2011
   ** Website: http://technology.amis.nl/blog
   ** See also: http://technology.amis.nl/blog/?p=10995
   **
   ** Changelog:
   **   Date: 21-02-2011
   **     Added Aligment, horizontal, vertical, wrapText
   **   Date: 06-03-2011
   **     Added Comments, MergeCells, fixed bug for dependency on NLS-settings
   **   Date: 16-03-2011
   **     Added bold and italic fonts
   **   Date: 22-03-2011
   **     Fixed issue with timezone's set to a region(name) instead of a offset
   **   Date: 08-04-2011
   **     Fixed issue with XML-escaping from text
   **   Date: 27-05-2011
   **     Added MIT-license
   **   Date: 11-08-2011
   **     Fixed NLS-issue with column width
   **   Date: 29-09-2011
   **     Added font color
   **   Date: 16-10-2011
   **     fixed bug in add_string
   **   Date: 26-04-2012
   **     Fixed set_autofilter (only one autofilter per sheet, added _xlnm._FilterDatabase)
   **     Added list_validation = drop-down
   **   Date: 27-08-2013
   **     Added freeze_pane
   **   Date: 01-03-2014 (MK)
   **     Changed new_sheet to function returning sheet id
   **   Date: 22-03-2014 (MK)
   **     Added function to convert Oracle Number Format to Excel Format
   **   Date: 07-04-2014 (MK)
   **     Removed references to UTL_FILE
   **     query2sheet is now function returning BLOB
   **     changed date handling to be based on 01-01-1900
   **   Date: 08-04-2014 (MK)
   **     internal function for date to excel serial conversion added
   **   Date: 01-12-2014 (AMEI)
   **     Some Naming-conventions (and renaming of elements accordingly), new FUNCTION get_sheet_id
   **     Triggered by: @SEE AMEI, 20141129 Bugfix:
   **     For concatenation operations (in particular where record fields are involved) added a lot of TO_CHAR (...)
   **     to make sure correct explicit conversion (mayby not all caught where necessary)
   **     To make this easier to recognize, inducted some naming conventions and renamed some elements.
   **   Date: 26-04-2017 (MP)
   **     Added new function "query2sheet2" which is faster.
   **     For dates used following logic:
   **       - if trunc([column])=[column], then outputed cell value is formatted to format YYYYMMDD;
   **       - otherwise, outputted cell value is formatted to format YYYYMMDDTHH24MISS;
   ******************************************************************************
   ******************************************************************************
   Copyright (C) 2011, 2012 by Anton Scheffer

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.

   ******************************************************************************
   ******************************************************************************
   * @headcom
   */

   /**
   * Record with data about column alignment.
   * @param vertical   Vertical alignment.
   * @param horizontal Horizontal alignment.
   * @param wrapText   Switch to allow or disallow word wrap.
   */
   TYPE t_alignment_rec IS RECORD
   (
      vc_vertical     VARCHAR2 (11),
      vc_horizontal   VARCHAR2 (16),
      bo_wraptext     BOOLEAN
   );

   /**
   * Clears the whole workbook to start fresh.
   */
   PROCEDURE clear_workbook;

   /**
   * Create a new sheet in the workbook.
   * @param p_sheetname Name Excel should display for the new worksheet.
   * @return ID of newly created worksheet.
   */
   FUNCTION new_sheet (p_sheetname VARCHAR2 := NULL)
      RETURN PLS_INTEGER;

   /**
   * Converts an Oracle date format to the corresponding Excel date format.
   * @param p_format The Oracle date format to convert.
   * @return Corresponding Excel date format.
   */
   FUNCTION orafmt2excel (p_format VARCHAR2 := NULL)
      RETURN VARCHAR2;

   /**
   * Converts an Oracle number format to the corresponding Excel number format.
   * @param The Oracle number format to convert.
   * @return Corresponding Excel number format.
   */
   FUNCTION oranumfmt2excel (p_format VARCHAR2)
      RETURN VARCHAR2;

   /**
   * Get ID for given number format.
   * @param p_format Wanted number formatting using Excle number format.
   *                 Use OraNumFmt2Excel to convert from Oracle to Excel.
   * @return ID for given number format.
   */
   FUNCTION get_numfmt (p_format VARCHAR2 := NULL)
      RETURN PLS_INTEGER;

   /**
   * Get ID for given font settings.
   * @param p_name
   * @param p_family
   * @param p_fontsize
   * @param p_theme
   * @param p_underline
   * @param p_italic
   * @param p_bold
   * @param p_rgb
   * @return ID for given font definition
   */
   FUNCTION get_font (p_name         VARCHAR2,
                      p_family       PLS_INTEGER := 2,
                      p_fontsize     NUMBER := 8,
                      p_theme        PLS_INTEGER := 1,
                      p_underline    BOOLEAN := FALSE,
                      p_italic       BOOLEAN := FALSE,
                      p_bold         BOOLEAN := FALSE,
                      p_rgb          VARCHAR2 := NULL                        -- this is a hex ALPHA Red Green Blue value, but RGB works also
                                                     )
      RETURN PLS_INTEGER;

   /**
   * Get ID for given cell fill
   * @param p_patternType Pattern for the fill.
   * @param p_fgRGB       Color using an ARGB or RGB hex value
   * @return ID for given cell fill.
   */
   FUNCTION get_fill (p_patterntype VARCHAR2, p_fgrgb VARCHAR2 := NULL)
      RETURN PLS_INTEGER;

   /**
   * Get ID for given border definition.
   * Possible values for all parameters:
   * none, thin, medium, dashed, dotted, thick, double, hair, mediumDashed,
   * dashDot, mediumDashDot, dashDotDot, mediumDashDotDot, slantDashDot
   * @param p_top    Style for top border
   * @param p_bottom Style for bottom border
   * @param p_left   Style for left border
   * @param p_right  Style for right border
   * @return ID for given border definition
   */
   FUNCTION get_border (p_top       VARCHAR2 := 'thin',
                        p_bottom    VARCHAR2 := 'thin',
                        p_left      VARCHAR2 := 'thin',
                        p_right     VARCHAR2 := 'thin')
      RETURN PLS_INTEGER;

   /**
   * Function to get a record holding alignment data.
   * @param p_vertical   Vertical alignment.
   *                     (bottom, center, distributed, justify, top)
   * @param p_horizontal Horizontal alignment.
   *                     (center, centerContinuous, distributed, fill, general, justify, left, right)
   * @param p_wraptext   Switch to allow or disallow text wrapping.
   * @return Record with alignment data.
   */
   FUNCTION get_alignment (p_vertical VARCHAR2 := NULL, p_horizontal VARCHAR2 := NULL, p_wraptext BOOLEAN := NULL)
      RETURN t_alignment_rec;

   /**
   * Puts a number value into a cell of the spreadsheet.
   * @param p_col       Column number where the cell is located
   * @param p_row       Row number where the cell is located
   * @param p_value     The value to put into the cell
   * @param p_numFmtId  ID of number format
   * @param p_fontId    ID of font defintion
   * @param p_fillId    ID of fill definition
   * @param p_borderId  ID of border definition
   * @param p_alignment The wanted alignment
   * @param p_sheet     Worksheet the cell is located, if omitted last worksheet is used
   */
   PROCEDURE cell (p_col          PLS_INTEGER,
                   p_row          PLS_INTEGER,
                   p_value        NUMBER,
                   p_numfmtid     PLS_INTEGER := NULL,
                   p_fontid       PLS_INTEGER := NULL,
                   p_fillid       PLS_INTEGER := NULL,
                   p_borderid     PLS_INTEGER := NULL,
                   p_alignment    t_alignment_rec := NULL,
                   p_sheet        PLS_INTEGER := NULL);

   /**
   * Puts a character value into a cell of the spreadsheet.
   * @param p_col       Column number where the cell is located
   * @param p_row       Row number where the cell is located
   * @param p_value     The value to put into the cell
   * @param p_numFmtId  ID of formatting definition
   * @param p_fontId    ID of font defintion
   * @param p_fillId    ID of fill definition
   * @param p_borderId  ID of border definition
   * @param p_alignment The wanted alignment
   * @param p_sheet     Worksheet the cell is located, if omitted last worksheet is used
   */
   PROCEDURE cell (p_col          PLS_INTEGER,
                   p_row          PLS_INTEGER,
                   p_value        VARCHAR2,
                   p_numfmtid     PLS_INTEGER := NULL,
                   p_fontid       PLS_INTEGER := NULL,
                   p_fillid       PLS_INTEGER := NULL,
                   p_borderid     PLS_INTEGER := NULL,
                   p_alignment    t_alignment_rec := NULL,
                   p_sheet        PLS_INTEGER := NULL);

   /**
   * Puts a date value into a cell of the spreadsheet.
   * @param p_col       Column number where the cell is located
   * @param p_row       Row number where the cell is located
   * @param p_value     The value to put into the cell
   * @param p_numFmtId  ID of format definition
   * @param p_fontId    ID of font defintion
   * @param p_fillId    ID of fill definition
   * @param p_borderId  ID of border definition
   * @param p_alignment The wanted alignment
   * @param p_sheet     Worksheet the cell is located, if omitted last worksheet is used
   */
   PROCEDURE cell (p_col          PLS_INTEGER,
                   p_row          PLS_INTEGER,
                   p_value        DATE,
                   p_numfmtid     PLS_INTEGER := NULL,
                   p_fontid       PLS_INTEGER := NULL,
                   p_fillid       PLS_INTEGER := NULL,
                   p_borderid     PLS_INTEGER := NULL,
                   p_alignment    t_alignment_rec := NULL,
                   p_sheet        PLS_INTEGER := NULL);

   PROCEDURE hyperlink (p_col      PLS_INTEGER,
                        p_row      PLS_INTEGER,
                        p_url      VARCHAR2,
                        p_value    VARCHAR2 := NULL,
                        p_sheet    PLS_INTEGER := NULL);

   PROCEDURE comment (p_col       PLS_INTEGER,
                      p_row       PLS_INTEGER,
                      p_text      VARCHAR2,
                      p_author    VARCHAR2 := NULL,
                      p_width     PLS_INTEGER := 150                                                                               -- pixels
                                                    ,
                      p_height    PLS_INTEGER := 100                                                                               -- pixels
                                                    ,
                      p_sheet     PLS_INTEGER := NULL);

   PROCEDURE mergecells (p_tl_col    PLS_INTEGER                                                                                 -- top left
                                                ,
                         p_tl_row    PLS_INTEGER,
                         p_br_col    PLS_INTEGER                                                                             -- bottom right
                                                ,
                         p_br_row    PLS_INTEGER,
                         p_sheet     PLS_INTEGER := NULL);

   PROCEDURE list_validation (p_sqref_col      PLS_INTEGER,
                              p_sqref_row      PLS_INTEGER,
                              p_tl_col         PLS_INTEGER                                                                       -- top left
                                                          ,
                              p_tl_row         PLS_INTEGER,
                              p_br_col         PLS_INTEGER                                                                   -- bottom right
                                                          ,
                              p_br_row         PLS_INTEGER,
                              p_style          VARCHAR2 := 'stop'                                              -- stop, warning, information
                                                                 ,
                              p_title          VARCHAR2 := NULL,
                              p_prompt         VARCHAR2 := NULL,
                              p_show_error     BOOLEAN := FALSE,
                              p_error_title    VARCHAR2 := NULL,
                              p_error_txt      VARCHAR2 := NULL,
                              p_sheet          PLS_INTEGER := NULL);

   PROCEDURE list_validation (p_sqref_col       PLS_INTEGER,
                              p_sqref_row       PLS_INTEGER,
                              p_defined_name    VARCHAR2,
                              p_style           VARCHAR2 := 'stop'                                             -- stop, warning, information
                                                                  ,
                              p_title           VARCHAR2 := NULL,
                              p_prompt          VARCHAR2 := NULL,
                              p_show_error      BOOLEAN := FALSE,
                              p_error_title     VARCHAR2 := NULL,
                              p_error_txt       VARCHAR2 := NULL,
                              p_sheet           PLS_INTEGER := NULL);

   PROCEDURE defined_name (p_tl_col        PLS_INTEGER                                                                           -- top left
                                                      ,
                           p_tl_row        PLS_INTEGER,
                           p_br_col        PLS_INTEGER                                                                       -- bottom right
                                                      ,
                           p_br_row        PLS_INTEGER,
                           p_name          VARCHAR2,
                           p_sheet         PLS_INTEGER := NULL,
                           p_localsheet    PLS_INTEGER := NULL);

   PROCEDURE set_column_width (p_col PLS_INTEGER, p_width NUMBER, p_sheet PLS_INTEGER := NULL);

   PROCEDURE set_column (p_col          PLS_INTEGER,
                         p_numfmtid     PLS_INTEGER := NULL,
                         p_fontid       PLS_INTEGER := NULL,
                         p_fillid       PLS_INTEGER := NULL,
                         p_borderid     PLS_INTEGER := NULL,
                         p_alignment    t_alignment_rec := NULL,
                         p_sheet        PLS_INTEGER := NULL);

   PROCEDURE set_row (p_row          PLS_INTEGER,
                      p_numfmtid     PLS_INTEGER := NULL,
                      p_fontid       PLS_INTEGER := NULL,
                      p_fillid       PLS_INTEGER := NULL,
                      p_borderid     PLS_INTEGER := NULL,
                      p_alignment    t_alignment_rec := NULL,
                      p_sheet        PLS_INTEGER := NULL);

   PROCEDURE freeze_rows (p_nr_rows PLS_INTEGER := 1, p_sheet PLS_INTEGER := NULL);

   PROCEDURE freeze_cols (p_nr_cols PLS_INTEGER := 1, p_sheet PLS_INTEGER := NULL);

   PROCEDURE freeze_pane (p_col PLS_INTEGER, p_row PLS_INTEGER, p_sheet PLS_INTEGER := NULL);

   PROCEDURE set_autofilter (p_column_start    PLS_INTEGER := NULL,
                             p_column_end      PLS_INTEGER := NULL,
                             p_row_start       PLS_INTEGER := NULL,
                             p_row_end         PLS_INTEGER := NULL,
                             p_sheet           PLS_INTEGER := NULL);

   FUNCTION finish
      RETURN BLOB;

   FUNCTION query2sheet (p_sql VARCHAR2, p_column_headers BOOLEAN := TRUE, p_sheet PLS_INTEGER := NULL)
      RETURN BLOB;

   FUNCTION finish2 (p_clob                 IN OUT NOCOPY CLOB,
                     p_columns              PLS_INTEGER,
                     p_rows                 PLS_INTEGER,
                     p_XLSX_date_format     VARCHAR2,
                     p_XLSX_datetime_format VARCHAR2)
      RETURN BLOB;

   FUNCTION query2sheet2(p_sql                  VARCHAR2,
                         p_XLSX_date_format     VARCHAR2 := 'dd/mm/yyyy',
                         p_XLSX_datetime_format VARCHAR2 := 'dd/mm/yyyy hh24:mi:ss')
      RETURN BLOB;
END;




-- BODY

create or replace PACKAGE BODY xlsx_builder_pkg
IS
   /* Some Naming-conventions
   Prefixes for Datatypes in defined Records-Type-Elements
   vc   VARCHAR2
   nv   NVARCHAR2
   ch   CHAR
   nc   NCHAR
   nn   NUMBER
   pi   PLS_INTEGER
   bi   BINARY_INTEGER
   dt   DATE
   bo   BOOLEAN
   bf   BFILE
   bl   BLOB
   cl   CLOB
   nl   NCLOB
   lo   LONG
   tl   TIMESTAMP (fractional_seconds_precision) WITH LOCAL TIME ZONE
   ts   TIMESTAMP (fractional_seconds_precision)
   tz   TIMESTAMP (fractional_seconds_precision) WITH TIME ZONE
   iv   INTERVAL
        Sample: vc_name VARCHAR2 (10)
   Types-Prefixes
   t_... TYPE
   Types-Suffixes
   ..._rec record
   ..._tab PL/SQL-Table
   */
 
   /* Types */
   TYPE t_xf_fmt_rec IS RECORD
   (
      pi_numfmtid     PLS_INTEGER,
      pi_fontid       PLS_INTEGER,
      pi_fillid       PLS_INTEGER,
      pi_borderid     PLS_INTEGER,
      alignment_rec   t_alignment_rec
   );
 
   TYPE t_col_fmts_tab IS TABLE OF t_xf_fmt_rec
      INDEX BY PLS_INTEGER;
 
   TYPE t_row_fmts_tab IS TABLE OF t_xf_fmt_rec
      INDEX BY PLS_INTEGER;
 
   TYPE t_widths_tab IS TABLE OF NUMBER
      INDEX BY PLS_INTEGER;
 
   TYPE t_cell_rec IS RECORD
   (
      nn_value_id    NUMBER,
      vc_style_def   VARCHAR2 (50)
   );
 
   TYPE t_cells_tab IS TABLE OF t_cell_rec
      INDEX BY PLS_INTEGER;
 
   TYPE t_rows_tab IS TABLE OF t_cells_tab
      INDEX BY PLS_INTEGER;
 
   TYPE t_autofilter_rec IS RECORD
   (
      pi_column_start   PLS_INTEGER,
      pi_column_end     PLS_INTEGER,
      pi_row_start      PLS_INTEGER,
      pi_row_end        PLS_INTEGER
   );
 
   TYPE t_autofilters_tab IS TABLE OF t_autofilter_rec
      INDEX BY PLS_INTEGER;
 
   TYPE t_hyperlink_rec IS RECORD
   (
      vc_cell   VARCHAR2 (10),
      vc_url    VARCHAR2 (1000)
   );
 
   TYPE t_hyperlinks_tab IS TABLE OF t_hyperlink_rec
      INDEX BY PLS_INTEGER;
 
   SUBTYPE st_author IS VARCHAR2 (32767 CHAR);
 
   TYPE t_authors_tab IS TABLE OF PLS_INTEGER
      INDEX BY st_author;
 
   gv_authors_tab                         t_authors_tab;
 
   TYPE t_comment_rec IS RECORD
   (
      vc_text        VARCHAR2 (32767 CHAR),
      vc_author      st_author,
      pi_row_nr      PLS_INTEGER,
      pi_column_nr   PLS_INTEGER,
      pi_width       PLS_INTEGER,
      pi_height      PLS_INTEGER
   );
 
   TYPE t_comments_tab IS TABLE OF t_comment_rec
      INDEX BY PLS_INTEGER;
 
   TYPE t_mergecells_tab IS TABLE OF VARCHAR2 (21)
      INDEX BY PLS_INTEGER;
 
   TYPE t_validation_rec IS RECORD
   (
      vc_validation_type    VARCHAR2 (10),
      vc_errorstyle         VARCHAR2 (32),
      bo_showinputmessage   BOOLEAN,
      vc_prompt             VARCHAR2 (32767 CHAR),
      vc_title              VARCHAR2 (32767 CHAR),
      vc_error_title        VARCHAR2 (32767 CHAR),
      vc_error_txt          VARCHAR2 (32767 CHAR),
      bo_showerrormessage   BOOLEAN,
      vc_formula1           VARCHAR2 (32767 CHAR),
      vc_formula2           VARCHAR2 (32767 CHAR),
      bo_allowblank         BOOLEAN,
      vc_sqref              VARCHAR2 (32767 CHAR)
   );
 
   TYPE t_validations_tab IS TABLE OF t_validation_rec
      INDEX BY PLS_INTEGER;
 
   TYPE t_sheet_rec IS RECORD
   (
      sheet_rows_tab    t_rows_tab,
      widths_tab_tab    t_widths_tab,
      vc_sheet_name     VARCHAR2 (100),
      pi_freeze_rows    PLS_INTEGER,
      pi_freeze_cols    PLS_INTEGER,
      autofilters_tab   t_autofilters_tab,
      hyperlinks_tab    t_hyperlinks_tab,
      col_fmts_tab      t_col_fmts_tab,
      row_fmts_tab      t_row_fmts_tab,
      comments_tab      t_comments_tab,
      mergecells_tab    t_mergecells_tab,
      validations_tab   t_validations_tab
   );
 
   TYPE t_sheets_tab IS TABLE OF t_sheet_rec
      INDEX BY PLS_INTEGER;
 
   TYPE t_numfmt_rec IS RECORD
   (
      pi_numfmtid     PLS_INTEGER,
      vc_formatcode   VARCHAR2 (100)
   );
 
   TYPE t_numfmts_tab IS TABLE OF t_numfmt_rec
      INDEX BY PLS_INTEGER;
 
   TYPE t_fill_rec IS RECORD
   (
      vc_patterntype   VARCHAR2 (30),
      vc_fgrgb         VARCHAR2 (8)
   );
 
   TYPE t_fills_tab IS TABLE OF t_fill_rec
      INDEX BY PLS_INTEGER;
 
   TYPE t_cellxfs_tab IS TABLE OF t_xf_fmt_rec
      INDEX BY PLS_INTEGER;
 
   TYPE t_font_rec IS RECORD
   (
      vc_font_name   VARCHAR2 (100),
      pi_family      PLS_INTEGER,
      nn_fontsize    NUMBER,
      pi_theme       PLS_INTEGER,
      vc_rgb         VARCHAR2 (8),
      bo_underline   BOOLEAN,
      bo_italic      BOOLEAN,
      bo_bold        BOOLEAN
   );
 
   TYPE t_fonts_tab IS TABLE OF t_font_rec
      INDEX BY PLS_INTEGER;
 
   TYPE t_border_rec IS RECORD
   (
      vc_top_border      VARCHAR2 (17),
      vc_bottom_border   VARCHAR2 (17),
      vc_left_border     VARCHAR2 (17),
      vc_right_border    VARCHAR2 (17)
   );
 
   TYPE t_borders_tab IS TABLE OF t_border_rec
      INDEX BY PLS_INTEGER;
 
   TYPE t_numfmtindexes_tab IS TABLE OF PLS_INTEGER
      INDEX BY PLS_INTEGER;
 
   TYPE t_strings_tab IS TABLE OF PLS_INTEGER
      INDEX BY VARCHAR2 (32767 CHAR);
 
   TYPE t_str_ind_tab IS TABLE OF VARCHAR2 (32767 CHAR)
      INDEX BY PLS_INTEGER;
 
   TYPE t_defined_name_rec IS RECORD
   (
      vc_defined_name   VARCHAR2 (32767 CHAR),
      vc_defined_ref    VARCHAR2 (32767 CHAR),
      pi_sheet          PLS_INTEGER
   );
 
   TYPE t_defined_names_tab IS TABLE OF t_defined_name_rec
      INDEX BY PLS_INTEGER;
 
   TYPE t_book_rec IS RECORD
   (
      sheets_tab          t_sheets_tab,
      strings_tab         t_strings_tab,
      str_ind_tab         t_str_ind_tab,
      pi_str_cnt          PLS_INTEGER:= 0,
      fonts_tab           t_fonts_tab,
      fills_tab           t_fills_tab,
      borders_tab         t_borders_tab,
      numfmts_tab         t_numfmts_tab,
      cellxfs_tab         t_cellxfs_tab,
      numfmtindexes_tab   t_numfmtindexes_tab,
      defined_names_tab   t_defined_names_tab
   );
 
   /* Globals */
   -- the only global variable (objekt) without prefix and suffix
   workbook                               t_book_rec;
 
   --
   FUNCTION get_workbook
      RETURN t_book_rec
   AS
   BEGIN
      RETURN workbook;
   END get_workbook;
 
   /* Private API */
   /**
   * Procedure concatenates a VARCHAR2 to an CLOB.
   * It uses another VARCHAR2 as a buffer until it reaches 32767 characters.
   * Then it flushes the current buffer to the CLOB and resets the buffer using
   * the actual VARCHAR2 to add.
   * Your final call needs to be done setting p_eof to TRUE in order to
   * flush everything to the CLOB.
   *
   * @param p_clob        The CLOB you want to append to.
   * @param p_vc_buffer   The intermediate VARCHAR2 buffer. (must be VARCHAR2(32767))
   * @param p_vc_addition The VARCHAR2 value you want to append.
   * @param p_eof         Indicates if complete buffer should be flushed to CLOB.
   */
   PROCEDURE clob_vc_concat( p_clob IN OUT NOCOPY CLOB
                           , p_vc_buffer IN OUT NOCOPY VARCHAR2
                           , p_vc_addition IN VARCHAR2
                           , p_eof IN BOOLEAN DEFAULT FALSE
                           )
   AS
   BEGIN
     -- Standard Flow
     IF NVL(LENGTHB(p_vc_buffer), 0) + NVL(LENGTHB(p_vc_addition), 0) < 32767 THEN
       p_vc_buffer := p_vc_buffer || p_vc_addition;
     ELSE
       IF p_clob IS NULL THEN
         dbms_lob.createtemporary(p_clob, TRUE);
       END IF;
       dbms_lob.writeappend(p_clob, LENGTH(p_vc_buffer), p_vc_buffer);
       p_vc_buffer := p_vc_addition;
     END IF;
 
     -- Full Flush requested
     IF p_eof THEN
       IF p_clob IS NULL THEN
         p_clob := p_vc_buffer;
       ELSE
         dbms_lob.writeappend(p_clob, LENGTH(p_vc_buffer), p_vc_buffer);
       END IF;
     p_vc_buffer := NULL;
     END IF;
   END clob_vc_concat;
 
   FUNCTION get_sheet_id (p_sheet IN PLS_INTEGER)
      RETURN PLS_INTEGER
   AS
   BEGIN
      RETURN NVL (p_sheet, workbook.sheets_tab.COUNT);
   END get_sheet_id;
 
 
   FUNCTION alfan_col (p_col PLS_INTEGER)
      RETURN VARCHAR2
   AS
   BEGIN
      RETURN CASE
                WHEN p_col > 702
                THEN
                      CHR (64 + TRUNC ( (p_col - 27) / 676))
                   || CHR (65 + MOD (TRUNC ( (p_col - 1) / 26) - 1, 26))
                   || CHR (65 + MOD (p_col - 1, 26))
                WHEN p_col > 26
                THEN
                   CHR (64 + TRUNC ( (p_col - 1) / 26)) || CHR (65 + MOD (p_col - 1, 26))
                ELSE
                   CHR (64 + p_col)
             END;
   END alfan_col;
 
   FUNCTION col_alfan (p_col VARCHAR2)
      RETURN PLS_INTEGER
   AS
   BEGIN
      RETURN   ASCII (SUBSTR (p_col, -1))
             - 64
             + NVL ( (ASCII (SUBSTR (p_col, -2, 1)) - 64) * 26, 0)
             + NVL ( (ASCII (SUBSTR (p_col, -3, 1)) - 64) * 676, 0);
   END col_alfan;
 
   -- EMORKLE (2014/02/24): Moved to top, allowing usage in new_sheet
   FUNCTION add_string (p_string VARCHAR2)
      RETURN PLS_INTEGER
   AS
      t_cnt   PLS_INTEGER;
   BEGIN
      -- MKLEIN (2014/02/24): Fix to handle NULL values
      IF p_string IS NULL AND workbook.strings_tab.COUNT > 0
      THEN
         RETURN 0;
      END IF;
 
      -- END Fix
      IF workbook.strings_tab.EXISTS (p_string)
      THEN
         t_cnt := workbook.strings_tab (p_string);
      ELSE
         t_cnt := workbook.strings_tab.COUNT;
         workbook.str_ind_tab (t_cnt) := p_string;
         workbook.strings_tab (NVL (p_string, '')) := t_cnt;
      END IF;
 
      workbook.pi_str_cnt := workbook.pi_str_cnt + 1;
      RETURN t_cnt;
   END add_string;
 
   PROCEDURE clear_workbook
   IS
      t_row_ind   PLS_INTEGER;
   BEGIN
      FOR s IN 1 .. workbook.sheets_tab.COUNT
      LOOP
         t_row_ind := workbook.sheets_tab (s).sheet_rows_tab.FIRST;
 
         WHILE t_row_ind IS NOT NULL
         LOOP
            workbook.sheets_tab (s).sheet_rows_tab (t_row_ind).delete;
            t_row_ind := workbook.sheets_tab (s).sheet_rows_tab.NEXT (t_row_ind);
         END LOOP;
 
         workbook.sheets_tab (s).sheet_rows_tab.delete;
         workbook.sheets_tab (s).widths_tab_tab.delete;
         workbook.sheets_tab (s).autofilters_tab.delete;
         workbook.sheets_tab (s).hyperlinks_tab.delete;
         workbook.sheets_tab (s).col_fmts_tab.delete;
         workbook.sheets_tab (s).row_fmts_tab.delete;
         workbook.sheets_tab (s).comments_tab.delete;
         workbook.sheets_tab (s).mergecells_tab.delete;
         workbook.sheets_tab (s).validations_tab.delete;
      END LOOP;
 
      workbook.strings_tab.delete;
      workbook.str_ind_tab.delete;
      workbook.fonts_tab.delete;
      workbook.fills_tab.delete;
      workbook.borders_tab.delete;
      workbook.numfmts_tab.delete;
      workbook.cellxfs_tab.delete;
      workbook.defined_names_tab.delete;
      workbook := NULL;
   END;
 
   --
   FUNCTION new_sheet (p_sheetname VARCHAR2 := NULL)
      RETURN PLS_INTEGER
   AS
      t_nr    PLS_INTEGER := workbook.sheets_tab.COUNT + 1;
      t_ind   PLS_INTEGER;
   BEGIN
      workbook.sheets_tab (t_nr).vc_sheet_name :=
         NVL (DBMS_XMLGEN.CONVERT (TRANSLATE (p_sheetname, 'a/\[]*:?', 'a')), 'Sheet' || TO_CHAR (t_nr));
 
      IF workbook.strings_tab.COUNT = 0
      THEN
         workbook.pi_str_cnt := 0;
         -- MKLEIN (2014/02/24): Insert NULL into strings on known position
         t_ind := add_string (NULL);
      END IF;
 
      IF workbook.fonts_tab.COUNT = 0
      THEN
         t_ind := get_font ('Arial');
      END IF;
 
      IF workbook.fills_tab.COUNT = 0
      THEN
         t_ind := get_fill ('none');
         t_ind := get_fill ('gray125');
      END IF;
 
      IF workbook.borders_tab.COUNT = 0
      THEN
         t_ind :=
            get_border ('',
                        '',
                        '',
                        '');
      END IF;
 
      RETURN t_nr;
   END new_sheet;
 
   PROCEDURE set_col_width (p_sheet PLS_INTEGER, p_col PLS_INTEGER, p_format VARCHAR2)
   AS
      t_width    NUMBER;
      t_nr_chr   PLS_INTEGER;
   BEGIN
      IF p_format IS NULL
      THEN
         RETURN;
      END IF;
 
      IF INSTR (p_format, ';') > 0
      THEN
         t_nr_chr := LENGTH (TRANSLATE (SUBSTR (p_format, 1, INSTR (p_format, ';') - 1), 'a\"', 'a'));
      ELSE
         t_nr_chr := LENGTH (TRANSLATE (p_format, 'a\"', 'a'));
      END IF;
 
      t_width := TRUNC ( (t_nr_chr * 7 + 5) / 7 * 256) / 256;                                             -- assume default 11 point Calibri
 
      IF workbook.sheets_tab (p_sheet).widths_tab_tab.EXISTS (p_col)
      THEN
         workbook.sheets_tab (p_sheet).widths_tab_tab (p_col) := GREATEST (workbook.sheets_tab (p_sheet).widths_tab_tab (p_col), t_width);
      ELSE
         workbook.sheets_tab (p_sheet).widths_tab_tab (p_col) := GREATEST (t_width, 8.43);
      END IF;
   END set_col_width;
 
 
   FUNCTION orafmt2excel (p_format VARCHAR2 := NULL)
      RETURN VARCHAR2
   AS
      t_format   VARCHAR2 (1000) := LOWER (SUBSTR (p_format, 1, 1000));
   BEGIN
      t_format := REPLACE (REPLACE (REPLACE (t_format, 'HH', 'hh'), 'hh24', 'hh'), 'hh12', 'hh');
      t_format := REPLACE (REPLACE (t_format, 'MI', 'mi'), 'mi', 'mm');
      t_format := REPLACE (REPLACE (REPLACE (t_format, 'AM', '~~'), 'PM', '~~'), '~~', 'AM/PM');
      t_format := REPLACE (REPLACE (REPLACE (t_format, 'am', '~~'), 'pm', '~~'), '~~', 'AM/PM');
      t_format := REPLACE (REPLACE (t_format, 'day', 'DAY'), 'DAY', 'dddd');
      t_format := REPLACE (REPLACE (t_format, 'dy', 'DY'), 'DAY', 'ddd');
      t_format := REPLACE (REPLACE (t_format, 'rr', 'RR'), 'RR', 'YY');
      t_format := REPLACE (REPLACE (t_format, 'month', 'MONTH'), 'MONTH', 'mmmm');
      t_format := REPLACE (REPLACE (t_format, 'mon', 'MON'), 'MON', 'mmm');
      RETURN t_format;
   END orafmt2excel;
 
   FUNCTION oradatetoexcel (p_value IN DATE)
      RETURN NUMBER
   AS
      l_date_diff   NUMBER := 0;
   BEGIN
      IF TRUNC (p_value) >= TO_DATE ('01-01-1900', 'MM-DD-YYYY')
      THEN
         l_date_diff := 2;
      END IF;
 
      RETURN ( ( p_value - TO_DATE ('01-01-1900', 'MM-DD-YYYY') ) + l_date_diff );
   END oradatetoexcel;
 
   FUNCTION oranumfmt2excel (p_format VARCHAR2)
      RETURN VARCHAR2
   AS
      l_mso_fmt   VARCHAR2 (255);
   BEGIN
      IF INSTR (p_format, 'D') > 0
      THEN
         l_mso_fmt := '.' || REPLACE (SUBSTR (p_format, INSTR (p_format, 'D') + 1), '9', '0');
      END IF;
 
      IF INSTR (p_format, 'G') > 0
      THEN
         l_mso_fmt := '#,##0' || l_mso_fmt;
      ELSE
         l_mso_fmt := '0' || l_mso_fmt;
      END IF;
 
      RETURN l_mso_fmt;
   END oranumfmt2excel;
 
   FUNCTION get_numfmt (p_format VARCHAR2 := NULL)
      RETURN PLS_INTEGER
   AS
      t_cnt        PLS_INTEGER;
      t_numfmtid   PLS_INTEGER;
   BEGIN
      IF p_format IS NULL
      THEN
         RETURN 0;
      END IF;
 
      t_cnt := workbook.numfmts_tab.COUNT;
 
      FOR i IN 1 .. t_cnt
      LOOP
         IF workbook.numfmts_tab (i).vc_formatcode = p_format
         THEN
            t_numfmtid := workbook.numfmts_tab (i).pi_numfmtid;
            EXIT;
         END IF;
      END LOOP;
 
      IF t_numfmtid IS NULL
      THEN
         t_numfmtid := CASE WHEN t_cnt = 0 THEN 164 ELSE workbook.numfmts_tab (t_cnt).pi_numfmtid + 1 END;
         t_cnt := t_cnt + 1;
         workbook.numfmts_tab (t_cnt).pi_numfmtid := t_numfmtid;
         workbook.numfmts_tab (t_cnt).vc_formatcode := p_format;
         workbook.numfmtindexes_tab (t_numfmtid) := t_cnt;
      END IF;
 
      RETURN t_numfmtid;
   END get_numfmt;
 
 
   FUNCTION get_font (p_name         VARCHAR2,
                      p_family       PLS_INTEGER := 2,
                      p_fontsize     NUMBER := 8,
                      p_theme        PLS_INTEGER := 1,
                      p_underline    BOOLEAN := FALSE,
                      p_italic       BOOLEAN := FALSE,
                      p_bold         BOOLEAN := FALSE,
                      p_rgb          VARCHAR2 := NULL                                            -- this is a hex ALPHA Red Green Blue value
                                                     )
      RETURN PLS_INTEGER
   AS
      t_ind   PLS_INTEGER;
   BEGIN
      IF workbook.fonts_tab.COUNT > 0
      THEN
         FOR f IN 0 .. workbook.fonts_tab.COUNT - 1
         LOOP
            IF (    workbook.fonts_tab (f).vc_font_name = p_name
                AND workbook.fonts_tab (f).pi_family = p_family
                AND workbook.fonts_tab (f).nn_fontsize = p_fontsize
                AND workbook.fonts_tab (f).pi_theme = p_theme
                AND workbook.fonts_tab (f).bo_underline = p_underline
                AND workbook.fonts_tab (f).bo_italic = p_italic
                AND workbook.fonts_tab (f).bo_bold = p_bold
                AND (workbook.fonts_tab (f).vc_rgb = p_rgb OR (workbook.fonts_tab (f).vc_rgb IS NULL AND p_rgb IS NULL)))
            THEN
               RETURN f;
            END IF;
         END LOOP;
      END IF;
 
      t_ind := workbook.fonts_tab.COUNT;
      workbook.fonts_tab (t_ind).vc_font_name := p_name;
      workbook.fonts_tab (t_ind).pi_family := p_family;
      workbook.fonts_tab (t_ind).nn_fontsize := p_fontsize;
      workbook.fonts_tab (t_ind).pi_theme := p_theme;
      workbook.fonts_tab (t_ind).bo_underline := p_underline;
      workbook.fonts_tab (t_ind).bo_italic := p_italic;
      workbook.fonts_tab (t_ind).bo_bold := p_bold;
      workbook.fonts_tab (t_ind).vc_rgb := p_rgb;
      RETURN t_ind;
   END get_font;
 
   FUNCTION get_fill (p_patterntype VARCHAR2, p_fgrgb VARCHAR2 := NULL)
      RETURN PLS_INTEGER
   AS
      t_ind   PLS_INTEGER;
   BEGIN
      IF workbook.fills_tab.COUNT > 0
      THEN
         FOR f IN 0 .. workbook.fills_tab.COUNT - 1
         LOOP
            IF (    workbook.fills_tab (f).vc_patterntype = p_patterntype
                AND NVL (workbook.fills_tab (f).vc_fgrgb, 'x') = NVL (UPPER (p_fgrgb), 'x'))
            THEN
               RETURN f;
            END IF;
         END LOOP;
      END IF;
 
      t_ind := workbook.fills_tab.COUNT;
      workbook.fills_tab (t_ind).vc_patterntype := p_patterntype;
      workbook.fills_tab (t_ind).vc_fgrgb := UPPER (p_fgrgb);
      RETURN t_ind;
   END get_fill;
 
   FUNCTION get_border (p_top       VARCHAR2 := 'thin',
                        p_bottom    VARCHAR2 := 'thin',
                        p_left      VARCHAR2 := 'thin',
                        p_right     VARCHAR2 := 'thin')
      RETURN PLS_INTEGER
   AS
      t_ind   PLS_INTEGER;
   BEGIN
      IF workbook.borders_tab.COUNT > 0
      THEN
         FOR b IN 0 .. workbook.borders_tab.COUNT - 1
         LOOP
            IF (    NVL (workbook.borders_tab (b).vc_top_border, 'x') = NVL (p_top, 'x')
                AND NVL (workbook.borders_tab (b).vc_bottom_border, 'x') = NVL (p_bottom, 'x')
                AND NVL (workbook.borders_tab (b).vc_left_border, 'x') = NVL (p_left, 'x')
                AND NVL (workbook.borders_tab (b).vc_right_border, 'x') = NVL (p_right, 'x'))
            THEN
               RETURN b;
            END IF;
         END LOOP;
      END IF;
 
      t_ind := workbook.borders_tab.COUNT;
      workbook.borders_tab (t_ind).vc_top_border := p_top;
      workbook.borders_tab (t_ind).vc_bottom_border := p_bottom;
      workbook.borders_tab (t_ind).vc_left_border := p_left;
      workbook.borders_tab (t_ind).vc_right_border := p_right;
      RETURN t_ind;
   END get_border;
 
   FUNCTION get_alignment (p_vertical VARCHAR2 := NULL, p_horizontal VARCHAR2 := NULL, p_wraptext BOOLEAN := NULL)
      RETURN t_alignment_rec
   AS
      t_rv   t_alignment_rec;
   BEGIN
      t_rv.vc_vertical := p_vertical;
      t_rv.vc_horizontal := p_horizontal;
      t_rv.bo_wraptext := p_wraptext;
      RETURN t_rv;
   END get_alignment;
 
   FUNCTION get_xfid (p_sheet        PLS_INTEGER,
                      p_col          PLS_INTEGER,
                      p_row          PLS_INTEGER,
                      p_numfmtid     PLS_INTEGER := NULL,
                      p_fontid       PLS_INTEGER := NULL,
                      p_fillid       PLS_INTEGER := NULL,
                      p_borderid     PLS_INTEGER := NULL,
                      p_alignment    t_alignment_rec := NULL)
      RETURN VARCHAR2
   AS
      t_cnt      PLS_INTEGER;
      t_xfid     PLS_INTEGER;
      t_xf       t_xf_fmt_rec;
      t_col_xf   t_xf_fmt_rec;
      t_row_xf   t_xf_fmt_rec;
   BEGIN
      IF workbook.sheets_tab (p_sheet).col_fmts_tab.EXISTS (p_col)
      THEN
         t_col_xf := workbook.sheets_tab (p_sheet).col_fmts_tab (p_col);
      END IF;
 
      IF workbook.sheets_tab (p_sheet).row_fmts_tab.EXISTS (p_row)
      THEN
         t_row_xf := workbook.sheets_tab (p_sheet).row_fmts_tab (p_row);
      END IF;
 
      t_xf.pi_numfmtid :=
         COALESCE (p_numfmtid,
                   t_col_xf.pi_numfmtid,
                   t_row_xf.pi_numfmtid,
                   0);
      t_xf.pi_fontid :=
         COALESCE (p_fontid,
                   t_col_xf.pi_fontid,
                   t_row_xf.pi_fontid,
                   0);
      t_xf.pi_fillid :=
         COALESCE (p_fillid,
                   t_col_xf.pi_fillid,
                   t_row_xf.pi_fillid,
                   0);
      t_xf.pi_borderid :=
         COALESCE (p_borderid,
                   t_col_xf.pi_borderid,
                   t_row_xf.pi_borderid,
                   0);
      t_xf.alignment_rec := COALESCE (p_alignment, t_col_xf.alignment_rec, t_row_xf.alignment_rec);
 
      IF (    t_xf.pi_numfmtid + t_xf.pi_fontid + t_xf.pi_fillid + t_xf.pi_borderid = 0
          AND t_xf.alignment_rec.vc_vertical IS NULL
          AND t_xf.alignment_rec.vc_horizontal IS NULL
          AND NOT NVL (t_xf.alignment_rec.bo_wraptext, FALSE))
      THEN
         RETURN '';
      END IF;
 
      IF t_xf.pi_numfmtid > 0
      THEN
         set_col_width (p_sheet, p_col, workbook.numfmts_tab (workbook.numfmtindexes_tab (t_xf.pi_numfmtid)).vc_formatcode);
      END IF;
 
      t_cnt := workbook.cellxfs_tab.COUNT;
 
      FOR i IN 1 .. t_cnt
      LOOP
         IF (    workbook.cellxfs_tab (i).pi_numfmtid = t_xf.pi_numfmtid
             AND workbook.cellxfs_tab (i).pi_fontid = t_xf.pi_fontid
             AND workbook.cellxfs_tab (i).pi_fillid = t_xf.pi_fillid
             AND workbook.cellxfs_tab (i).pi_borderid = t_xf.pi_borderid
             AND NVL (workbook.cellxfs_tab (i).alignment_rec.vc_vertical, 'x') = NVL (t_xf.alignment_rec.vc_vertical, 'x')
             AND NVL (workbook.cellxfs_tab (i).alignment_rec.vc_horizontal, 'x') = NVL (t_xf.alignment_rec.vc_horizontal, 'x')
             AND NVL (workbook.cellxfs_tab (i).alignment_rec.bo_wraptext, FALSE) = NVL (t_xf.alignment_rec.bo_wraptext, FALSE))
         THEN
            t_xfid := i;
            EXIT;
         END IF;
      END LOOP;
 
      IF t_xfid IS NULL
      THEN
         t_cnt := t_cnt + 1;
         t_xfid := t_cnt;
         workbook.cellxfs_tab (t_cnt) := t_xf;
      END IF;
 
      RETURN 's="' || TO_CHAR (t_xfid) || '"';
   END get_xfid;
 
   PROCEDURE cell (p_col          PLS_INTEGER,
                   p_row          PLS_INTEGER,
                   p_value        NUMBER,
                   p_numfmtid     PLS_INTEGER := NULL,
                   p_fontid       PLS_INTEGER := NULL,
                   p_fillid       PLS_INTEGER := NULL,
                   p_borderid     PLS_INTEGER := NULL,
                   p_alignment    t_alignment_rec := NULL,
                   p_sheet        PLS_INTEGER := NULL)
   AS
      t_sheet   PLS_INTEGER;
   BEGIN
      t_sheet := get_sheet_id (p_sheet);
      workbook.sheets_tab (t_sheet).sheet_rows_tab (p_row) (p_col).nn_value_id := p_value;
      workbook.sheets_tab (t_sheet).sheet_rows_tab (p_row) (p_col).vc_style_def := NULL;
      workbook.sheets_tab (t_sheet).sheet_rows_tab (p_row) (p_col).vc_style_def :=
         get_xfid (t_sheet,
                   p_col,
                   p_row,
                   p_numfmtid,
                   p_fontid,
                   p_fillid,
                   p_borderid,
                   p_alignment);
   END cell;
 
   PROCEDURE cell (p_col          PLS_INTEGER,
                   p_row          PLS_INTEGER,
                   p_value        VARCHAR2,
                   p_numfmtid     PLS_INTEGER := NULL,
                   p_fontid       PLS_INTEGER := NULL,
                   p_fillid       PLS_INTEGER := NULL,
                   p_borderid     PLS_INTEGER := NULL,
                   p_alignment    t_alignment_rec := NULL,
                   p_sheet        PLS_INTEGER := NULL)
   AS
      t_sheet       PLS_INTEGER;
      t_alignment   t_alignment_rec := p_alignment;
   BEGIN
      t_sheet := get_sheet_id (p_sheet);
      workbook.sheets_tab (t_sheet).sheet_rows_tab (p_row) (p_col).nn_value_id := add_string (p_value);
 
      IF t_alignment.bo_wraptext IS NULL AND INSTR (p_value, CHR (13)) > 0
      THEN
         t_alignment.bo_wraptext := TRUE;
      END IF;
 
      workbook.sheets_tab (t_sheet).sheet_rows_tab (p_row) (p_col).vc_style_def :=
            't="s" '
         || get_xfid (t_sheet,
                      p_col,
                      p_row,
                      p_numfmtid,
                      p_fontid,
                      p_fillid,
                      p_borderid,
                      t_alignment);
   END cell;
 
   PROCEDURE cell (p_col          PLS_INTEGER,
                   p_row          PLS_INTEGER,
                   p_value        DATE,
                   p_numfmtid     PLS_INTEGER := NULL,
                   p_fontid       PLS_INTEGER := NULL,
                   p_fillid       PLS_INTEGER := NULL,
                   p_borderid     PLS_INTEGER := NULL,
                   p_alignment    t_alignment_rec := NULL,
                   p_sheet        PLS_INTEGER := NULL)
   AS
      t_numfmtid   PLS_INTEGER := p_numfmtid;
      t_sheet      PLS_INTEGER;
   BEGIN
      t_sheet := get_sheet_id (p_sheet);
 
      workbook.sheets_tab (t_sheet).sheet_rows_tab (p_row) (p_col).nn_value_id := oradatetoexcel (p_value);
 
      IF     t_numfmtid IS NULL
         AND NOT (    workbook.sheets_tab (t_sheet).col_fmts_tab.EXISTS (p_col)
                  AND workbook.sheets_tab (t_sheet).col_fmts_tab (p_col).pi_numfmtid IS NOT NULL)
         AND NOT (    workbook.sheets_tab (t_sheet).row_fmts_tab.EXISTS (p_row)
                  AND workbook.sheets_tab (t_sheet).row_fmts_tab (p_row).pi_numfmtid IS NOT NULL)
      THEN
         t_numfmtid := get_numfmt ('dd/mm/yyyy');
      END IF;
 
      workbook.sheets_tab (t_sheet).sheet_rows_tab (p_row) (p_col).vc_style_def :=
         get_xfid (t_sheet,
                   p_col,
                   p_row,
                   t_numfmtid,
                   p_fontid,
                   p_fillid,
                   p_borderid,
                   p_alignment);
   END cell;
 
   PROCEDURE hyperlink (p_col      PLS_INTEGER,
                        p_row      PLS_INTEGER,
                        p_url      VARCHAR2,
                        p_value    VARCHAR2 := NULL,
                        p_sheet    PLS_INTEGER := NULL)
   AS
      t_ind     PLS_INTEGER;
      t_sheet   PLS_INTEGER;
   BEGIN
      t_sheet := get_sheet_id (p_sheet);
 
      workbook.sheets_tab (t_sheet).sheet_rows_tab (p_row) (p_col).nn_value_id := add_string (NVL (p_value, p_url));
      workbook.sheets_tab (t_sheet).sheet_rows_tab (p_row) (p_col).vc_style_def :=
            't="s" '
         || get_xfid (t_sheet,
                      p_col,
                      p_row,
                      '',
                      get_font ('Calibri', p_theme => 10, p_underline => TRUE));
      t_ind := workbook.sheets_tab (t_sheet).hyperlinks_tab.COUNT + 1;
      workbook.sheets_tab (t_sheet).hyperlinks_tab (t_ind).vc_cell := alfan_col (p_col) || TO_CHAR (p_row);
      workbook.sheets_tab (t_sheet).hyperlinks_tab (t_ind).vc_url := p_url;
   END hyperlink;
 
   PROCEDURE comment (p_col       PLS_INTEGER,
                      p_row       PLS_INTEGER,
                      p_text      VARCHAR2,
                      p_author    VARCHAR2 := NULL,
                      p_width     PLS_INTEGER := 150,
                      p_height    PLS_INTEGER := 100,
                      p_sheet     PLS_INTEGER := NULL)
   AS
      t_ind     PLS_INTEGER;
      t_sheet   PLS_INTEGER;
   BEGIN
      t_sheet := get_sheet_id (p_sheet);
      t_ind := workbook.sheets_tab (t_sheet).comments_tab.COUNT + 1;
      workbook.sheets_tab (t_sheet).comments_tab (t_ind).pi_row_nr := p_row;
      workbook.sheets_tab (t_sheet).comments_tab (t_ind).pi_column_nr := p_col;
      workbook.sheets_tab (t_sheet).comments_tab (t_ind).vc_text := DBMS_XMLGEN.CONVERT (p_text);
      workbook.sheets_tab (t_sheet).comments_tab (t_ind).vc_author := DBMS_XMLGEN.CONVERT (p_author);
      workbook.sheets_tab (t_sheet).comments_tab (t_ind).pi_width := p_width;
      workbook.sheets_tab (t_sheet).comments_tab (t_ind).pi_height := p_height;
   END comment;
 
   PROCEDURE mergecells (p_tl_col    PLS_INTEGER                                                                                 -- top left
                                                ,
                         p_tl_row    PLS_INTEGER,
                         p_br_col    PLS_INTEGER                                                                             -- bottom right
                                                ,
                         p_br_row    PLS_INTEGER,
                         p_sheet     PLS_INTEGER := NULL)
   AS
      t_ind     PLS_INTEGER;
      t_sheet   PLS_INTEGER;
   BEGIN
      t_sheet := get_sheet_id (p_sheet);
      t_ind := workbook.sheets_tab (t_sheet).mergecells_tab.COUNT + 1;
      workbook.sheets_tab (t_sheet).mergecells_tab (t_ind) :=
         alfan_col (p_tl_col) || TO_CHAR (p_tl_row) || ':' || alfan_col (p_br_col) || TO_CHAR (p_br_row);
   END mergecells;
 
   PROCEDURE add_validation (p_type           VARCHAR2,
                             p_sqref          VARCHAR2,
                             p_style          VARCHAR2 := 'stop'                                               -- stop, warning, information
                                                                ,
                             p_formula1       VARCHAR2 := NULL,
                             p_formula2       VARCHAR2 := NULL,
                             p_title          VARCHAR2 := NULL,
                             p_prompt         VARCHAR2 := NULL,
                             p_show_error     BOOLEAN := FALSE,
                             p_error_title    VARCHAR2 := NULL,
                             p_error_txt      VARCHAR2 := NULL,
                             p_sheet          PLS_INTEGER := NULL)
   AS
      t_ind     PLS_INTEGER;
      t_sheet   PLS_INTEGER;
   BEGIN
      t_sheet := get_sheet_id (p_sheet);
      t_ind := workbook.sheets_tab (t_sheet).validations_tab.COUNT + 1;
      workbook.sheets_tab (t_sheet).validations_tab (t_ind).vc_validation_type := p_type;
      workbook.sheets_tab (t_sheet).validations_tab (t_ind).vc_errorstyle := p_style;
      workbook.sheets_tab (t_sheet).validations_tab (t_ind).vc_sqref := p_sqref;
      workbook.sheets_tab (t_sheet).validations_tab (t_ind).vc_formula1 := p_formula1;
      workbook.sheets_tab (t_sheet).validations_tab (t_ind).vc_error_title := p_error_title;
      workbook.sheets_tab (t_sheet).validations_tab (t_ind).vc_error_txt := p_error_txt;
      workbook.sheets_tab (t_sheet).validations_tab (t_ind).vc_title := p_title;
      workbook.sheets_tab (t_sheet).validations_tab (t_ind).vc_prompt := p_prompt;
      workbook.sheets_tab (t_sheet).validations_tab (t_ind).bo_showerrormessage := p_show_error;
   END add_validation;
 
   PROCEDURE list_validation (p_sqref_col      PLS_INTEGER,
                              p_sqref_row      PLS_INTEGER,
                              p_tl_col         PLS_INTEGER                                                                       -- top left
                                                          ,
                              p_tl_row         PLS_INTEGER,
                              p_br_col         PLS_INTEGER                                                                   -- bottom right
                                                          ,
                              p_br_row         PLS_INTEGER,
                              p_style          VARCHAR2 := 'stop'                                              -- stop, warning, information
                                                                 ,
                              p_title          VARCHAR2 := NULL,
                              p_prompt         VARCHAR2 := NULL,
                              p_show_error     BOOLEAN := FALSE,
                              p_error_title    VARCHAR2 := NULL,
                              p_error_txt      VARCHAR2 := NULL,
                              p_sheet          PLS_INTEGER := NULL)
   AS
   BEGIN
      add_validation (
         'list',
         alfan_col (p_sqref_col) || TO_CHAR (p_sqref_row),
         p_style         => LOWER (p_style),
         p_formula1      =>    '$'
                            || alfan_col (p_tl_col)
                            || '$'
                            || TO_CHAR (p_tl_row)
                            || ':$'
                            || alfan_col (p_br_col)
                            || '$'
                            || TO_CHAR (p_br_row),
         p_title         => p_title,
         p_prompt        => p_prompt,
         p_show_error    => p_show_error,
         p_error_title   => p_error_title,
         p_error_txt     => p_error_txt,
         p_sheet         => p_sheet);
   END list_validation;
 
   PROCEDURE list_validation (p_sqref_col       PLS_INTEGER,
                              p_sqref_row       PLS_INTEGER,
                              p_defined_name    VARCHAR2,
                              p_style           VARCHAR2 := 'stop'                                             -- stop, warning, information
                                                                  ,
                              p_title           VARCHAR2 := NULL,
                              p_prompt          VARCHAR2 := NULL,
                              p_show_error      BOOLEAN := FALSE,
                              p_error_title     VARCHAR2 := NULL,
                              p_error_txt       VARCHAR2 := NULL,
                              p_sheet           PLS_INTEGER := NULL)
   AS
   BEGIN
      add_validation ('list',
                      alfan_col (p_sqref_col) || TO_CHAR (p_sqref_row),
                      p_style         => LOWER (p_style),
                      p_formula1      => p_defined_name,
                      p_title         => p_title,
                      p_prompt        => p_prompt,
                      p_show_error    => p_show_error,
                      p_error_title   => p_error_title,
                      p_error_txt     => p_error_txt,
                      p_sheet         => TO_CHAR (p_sheet));
   END list_validation;
 
   PROCEDURE defined_name (p_tl_col        PLS_INTEGER                                                                           -- top left
                                                      ,
                           p_tl_row        PLS_INTEGER,
                           p_br_col        PLS_INTEGER                                                                       -- bottom right
                                                      ,
                           p_br_row        PLS_INTEGER,
                           p_name          VARCHAR2,
                           p_sheet         PLS_INTEGER := NULL,
                           p_localsheet    PLS_INTEGER := NULL)
   AS
      t_ind     PLS_INTEGER;
      t_sheet   PLS_INTEGER;
   BEGIN
      t_sheet := get_sheet_id (p_sheet);
      t_ind := workbook.defined_names_tab.COUNT + 1;
      workbook.defined_names_tab (t_ind).vc_defined_name := p_name;
      workbook.defined_names_tab (t_ind).vc_defined_ref :=
            'Sheet'
         || TO_CHAR (t_sheet)
         || '!$'
         || alfan_col (p_tl_col)
         || '$'
         || TO_CHAR (p_tl_row)
         || ':$'
         || alfan_col (p_br_col)
         || '$'
         || TO_CHAR (p_br_row);
      workbook.defined_names_tab (t_ind).pi_sheet := p_localsheet;
   END defined_name;
 
   PROCEDURE set_column_width (p_col PLS_INTEGER, p_width NUMBER, p_sheet PLS_INTEGER := NULL)
   AS
   BEGIN
      workbook.sheets_tab (NVL (p_sheet, workbook.sheets_tab.COUNT)).widths_tab_tab (p_col) := p_width;
   END set_column_width;
 
   PROCEDURE set_column (p_col          PLS_INTEGER,
                         p_numfmtid     PLS_INTEGER := NULL,
                         p_fontid       PLS_INTEGER := NULL,
                         p_fillid       PLS_INTEGER := NULL,
                         p_borderid     PLS_INTEGER := NULL,
                         p_alignment    t_alignment_rec := NULL,
                         p_sheet        PLS_INTEGER := NULL)
   AS
      t_sheet   PLS_INTEGER;
   BEGIN
      t_sheet := get_sheet_id (p_sheet);
      workbook.sheets_tab (t_sheet).col_fmts_tab (p_col).pi_numfmtid := p_numfmtid;
      workbook.sheets_tab (t_sheet).col_fmts_tab (p_col).pi_fontid := p_fontid;
      workbook.sheets_tab (t_sheet).col_fmts_tab (p_col).pi_fillid := p_fillid;
      workbook.sheets_tab (t_sheet).col_fmts_tab (p_col).pi_borderid := p_borderid;
      workbook.sheets_tab (t_sheet).col_fmts_tab (p_col).alignment_rec := p_alignment;
   END set_column;
 
   PROCEDURE set_row (p_row          PLS_INTEGER,
                      p_numfmtid     PLS_INTEGER := NULL,
                      p_fontid       PLS_INTEGER := NULL,
                      p_fillid       PLS_INTEGER := NULL,
                      p_borderid     PLS_INTEGER := NULL,
                      p_alignment    t_alignment_rec := NULL,
                      p_sheet        PLS_INTEGER := NULL)
   AS
      t_sheet   PLS_INTEGER;
   BEGIN
      t_sheet := get_sheet_id (p_sheet);
      workbook.sheets_tab (t_sheet).row_fmts_tab (p_row).pi_numfmtid := p_numfmtid;
      workbook.sheets_tab (t_sheet).row_fmts_tab (p_row).pi_fontid := p_fontid;
      workbook.sheets_tab (t_sheet).row_fmts_tab (p_row).pi_fillid := p_fillid;
      workbook.sheets_tab (t_sheet).row_fmts_tab (p_row).pi_borderid := p_borderid;
      workbook.sheets_tab (t_sheet).row_fmts_tab (p_row).alignment_rec := p_alignment;
   END set_row;
 
   PROCEDURE freeze_rows (p_nr_rows PLS_INTEGER := 1, p_sheet PLS_INTEGER := NULL)
   AS
      t_sheet   PLS_INTEGER;
   BEGIN
      t_sheet := get_sheet_id (p_sheet);
      workbook.sheets_tab (t_sheet).pi_freeze_cols := NULL;
      workbook.sheets_tab (t_sheet).pi_freeze_rows := p_nr_rows;
   END freeze_rows;
 
   PROCEDURE freeze_cols (p_nr_cols PLS_INTEGER := 1, p_sheet PLS_INTEGER := NULL)
   AS
      t_sheet   PLS_INTEGER;
   BEGIN
      t_sheet := get_sheet_id (p_sheet);
      workbook.sheets_tab (t_sheet).pi_freeze_rows := NULL;
      workbook.sheets_tab (t_sheet).pi_freeze_cols := p_nr_cols;
   END freeze_cols;
 
   PROCEDURE freeze_pane (p_col PLS_INTEGER, p_row PLS_INTEGER, p_sheet PLS_INTEGER := NULL)
   AS
      t_sheet   PLS_INTEGER;
   BEGIN
      t_sheet := get_sheet_id (p_sheet);
      workbook.sheets_tab (t_sheet).pi_freeze_rows := p_row;
      workbook.sheets_tab (t_sheet).pi_freeze_cols := p_col;
   END freeze_pane;
 
   PROCEDURE set_autofilter (p_column_start    PLS_INTEGER := NULL,
                             p_column_end      PLS_INTEGER := NULL,
                             p_row_start       PLS_INTEGER := NULL,
                             p_row_end         PLS_INTEGER := NULL,
                             p_sheet           PLS_INTEGER := NULL)
   AS
      t_ind     PLS_INTEGER;
      t_sheet   PLS_INTEGER;
   BEGIN
      t_sheet := get_sheet_id (p_sheet);
      t_ind := 1;
      workbook.sheets_tab (t_sheet).autofilters_tab (t_ind).pi_column_start := p_column_start;
      workbook.sheets_tab (t_sheet).autofilters_tab (t_ind).pi_column_end := p_column_end;
      workbook.sheets_tab (t_sheet).autofilters_tab (t_ind).pi_row_start := p_row_start;
      workbook.sheets_tab (t_sheet).autofilters_tab (t_ind).pi_row_end := p_row_end;
      /*defined_name (p_column_start,
                    p_row_start,
                    p_column_end,
                    p_row_end,
                    '_xlnm._FilterDatabase',
                    t_sheet,
                    t_sheet - 1);*/
   END set_autofilter;
 
   FUNCTION finish
      RETURN BLOB
   AS
      t_excel                      BLOB;
      t_xxx                        CLOB;
      t_tmp                        VARCHAR2 (32767 CHAR);
      t_str                        VARCHAR2 (32767 CHAR);
      t_c                          NUMBER;
      t_h                          NUMBER;
      t_w                          NUMBER;
      t_cw                         NUMBER;
      t_cell                       VARCHAR2 (1000 CHAR);
      t_row_ind                    PLS_INTEGER;
      t_col_min                    PLS_INTEGER;
      t_col_max                    PLS_INTEGER;
      t_col_ind                    PLS_INTEGER;
      t_len                        PLS_INTEGER;
   BEGIN
      DBMS_LOB.createtemporary (t_excel, TRUE);
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Default Extension="vml" ContentType="application/vnd.openxmlformats-officedocument.vmlDrawing"/>
<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>');
 
      FOR s IN 1 .. workbook.sheets_tab.COUNT
      LOOP
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '<Override PartName="/xl/worksheets/sheet'
                          || TO_CHAR (s)
                          || '.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>');
      END LOOP;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '
<Override PartName="/xl/theme/theme1.xml" ContentType="application/vnd.openxmlformats-officedocument.theme+xml"/>
<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
<Override PartName="/xl/sharedStrings.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml"/>
<Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
<Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>');
 
      FOR s IN 1 .. workbook.sheets_tab.COUNT
      LOOP
         IF workbook.sheets_tab (s).comments_tab.COUNT > 0
         THEN
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '<Override PartName="/xl/comments'
                             || TO_CHAR (s)
                             || '.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.comments+xml"/>');
         END IF;
      END LOOP;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '</Types>',
         p_eof         => TRUE);
      zip_util_pkg.add_file (t_excel, '[Content_Types].xml', t_xxx);
      t_xxx := NULL;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<dc:creator>'
                       || SYS_CONTEXT ('userenv', 'os_user')
                       || '</dc:creator>
<cp:lastModifiedBy>'
                       || SYS_CONTEXT ('userenv', 'os_user')
                       || '</cp:lastModifiedBy>
<dcterms:created xsi:type="dcterms:W3CDTF">'
                       || TO_CHAR (CURRENT_TIMESTAMP, 'yyyy-mm-dd"T"hh24:mi:ssTZH:TZM')
                       || '</dcterms:created>
<dcterms:modified xsi:type="dcterms:W3CDTF">'
                       || TO_CHAR (CURRENT_TIMESTAMP, 'yyyy-mm-dd"T"hh24:mi:ssTZH:TZM')
                       || '</dcterms:modified>
</cp:coreProperties>',
         p_eof         => TRUE);
      zip_util_pkg.add_file (t_excel, 'docProps/core.xml', t_xxx);
      t_xxx := NULL;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">
<Application>Microsoft Excel</Application>
<DocSecurity>0</DocSecurity>
<ScaleCrop>false</ScaleCrop>
<HeadingPairs>
<vt:vector size="2" baseType="variant">
<vt:variant>
<vt:lpstr>Worksheets</vt:lpstr>
</vt:variant>
<vt:variant>
<vt:i4>'
                       || TO_CHAR (workbook.sheets_tab.COUNT)
                       || '</vt:i4>
</vt:variant>
</vt:vector>
</HeadingPairs>
<TitlesOfParts>
<vt:vector size="'
                       || TO_CHAR (workbook.sheets_tab.COUNT)
                       || '" baseType="lpstr">');
 
      FOR s IN 1 .. workbook.sheets_tab.COUNT
      LOOP
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '<vt:lpstr>' || workbook.sheets_tab (s).vc_sheet_name || '</vt:lpstr>');
      END LOOP;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '</vt:vector>
</TitlesOfParts>
<LinksUpToDate>false</LinksUpToDate>
<SharedDoc>false</SharedDoc>
<HyperlinksChanged>false</HyperlinksChanged>
<AppVersion>14.0300</AppVersion>
</Properties>',
         p_eof         => TRUE);
      zip_util_pkg.add_file (t_excel, 'docProps/app.xml', t_xxx);
      t_xxx := NULL;
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
</Relationships>',
         p_eof         => TRUE);
      zip_util_pkg.add_file (t_excel, '_rels/.rels', t_xxx);
      t_xxx := NULL;
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
                       || chr(13) || chr(10)
                       || '<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac">');
 
      IF workbook.numfmts_tab.COUNT > 0
      THEN
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '<numFmts count="' || TO_CHAR (workbook.numfmts_tab.COUNT) || '">');
 
         FOR n IN 1 .. workbook.numfmts_tab.COUNT
         LOOP
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '<numFmt numFmtId="'
                             || TO_CHAR (workbook.numfmts_tab (n).pi_numfmtid)
                             || '" formatCode="'
                             || workbook.numfmts_tab (n).vc_formatcode
                             || '"/>');
         END LOOP;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '</numFmts>');
      END IF;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<fonts count="' || TO_CHAR (workbook.fonts_tab.COUNT) || '" x14ac:knownFonts="1">');
 
      FOR f IN 0 .. workbook.fonts_tab.COUNT - 1
      LOOP
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '<font>'
                          || CASE WHEN workbook.fonts_tab (f).bo_bold THEN '<b/>' END
                          || CASE WHEN workbook.fonts_tab (f).bo_italic THEN '<i/>' END
                          || CASE WHEN workbook.fonts_tab (f).bo_underline THEN '<u/>' END
                          || '<sz val="'
                          || TO_CHAR (workbook.fonts_tab (f).nn_fontsize, 'TM9', 'NLS_NUMERIC_CHARACTERS=.,')
                          || '"/>
                             <color '
                          || CASE
                                WHEN workbook.fonts_tab (f).vc_rgb IS NOT NULL THEN 'rgb="' || workbook.fonts_tab (f).vc_rgb
                                ELSE 'theme="' || TO_CHAR (workbook.fonts_tab (f).pi_theme)
                             END
                          || '"/>
                             <name val="'
                          || workbook.fonts_tab (f).vc_font_name
                          || '"/>
                             <family val="'
                          || TO_CHAR (workbook.fonts_tab (f).pi_family)
                          || '"/>
                             <scheme val="none"/>
                             </font>');
      END LOOP;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '</fonts><fills count="' || TO_CHAR (workbook.fills_tab.COUNT) || '">');
 
      FOR f IN 0 .. workbook.fills_tab.COUNT - 1
      LOOP
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '<fill><patternFill patternType="'
                          || workbook.fills_tab (f).vc_patterntype
                          || '">'
                          || CASE WHEN workbook.fills_tab (f).vc_fgrgb IS NOT NULL THEN '<fgColor rgb="' || workbook.fills_tab (f).vc_fgrgb || '"/>' END
                          || '</patternFill></fill>');
      END LOOP;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '</fills>
<borders count="' || TO_CHAR (workbook.borders_tab.COUNT) || '">');
 
      FOR b IN 0 .. workbook.borders_tab.COUNT - 1
      LOOP
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '<border>'
                          || CASE
                                WHEN workbook.borders_tab (b).vc_left_border IS NULL THEN '<left/>'
                                ELSE '<left style="' || workbook.borders_tab (b).vc_left_border || '"/>'
                             END
                          || CASE
                                WHEN workbook.borders_tab (b).vc_right_border IS NULL THEN '<right/>'
                                ELSE '<right style="' || workbook.borders_tab (b).vc_right_border || '"/>'
                             END
                          || CASE
                                WHEN workbook.borders_tab (b).vc_top_border IS NULL THEN '<top/>'
                                ELSE '<top style="' || workbook.borders_tab (b).vc_top_border || '"/>'
                             END
                          || CASE
                                WHEN workbook.borders_tab (b).vc_bottom_border IS NULL THEN '<bottom/>'
                                ELSE '<bottom style="' || workbook.borders_tab (b).vc_bottom_border || '"/>'
                             END
                          || '</border>');
      END LOOP;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '</borders>
<cellStyleXfs count="1">
<xf numFmtId="0" fontId="0" fillId="0" borderId="0"/>
</cellStyleXfs>
<cellXfs count="' || TO_CHAR (workbook.cellxfs_tab.COUNT + 1) || '">
<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>');
 
      FOR x IN 1 .. workbook.cellxfs_tab.COUNT
      LOOP
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<xf numFmtId="'
                       || TO_CHAR (workbook.cellxfs_tab (x).pi_numfmtid)
                       || '" fontId="'
                       || TO_CHAR (workbook.cellxfs_tab (x).pi_fontid)
                       || '" fillId="'
                       || TO_CHAR (workbook.cellxfs_tab (x).pi_fillid)
                       || '" borderId="'
                       || TO_CHAR (workbook.cellxfs_tab (x).pi_borderid)
                       || '">');
 
         IF (   workbook.cellxfs_tab (x).alignment_rec.vc_horizontal IS NOT NULL
             OR workbook.cellxfs_tab (x).alignment_rec.vc_vertical IS NOT NULL
             OR workbook.cellxfs_tab (x).alignment_rec.bo_wraptext)
         THEN
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<alignment'
                       || CASE
                             WHEN workbook.cellxfs_tab (x).alignment_rec.vc_horizontal IS NOT NULL
                             THEN ' horizontal="' || workbook.cellxfs_tab (x).alignment_rec.vc_horizontal || '"'
                          END
                       || CASE
                             WHEN workbook.cellxfs_tab (x).alignment_rec.vc_vertical IS NOT NULL
                             THEN ' vertical="' || workbook.cellxfs_tab (x).alignment_rec.vc_vertical || '"'
                          END
                       || CASE WHEN workbook.cellxfs_tab (x).alignment_rec.bo_wraptext
                               THEN ' wrapText="true"'
                          END
                       || '/>');
         END IF;
 
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '</xf>');
      END LOOP;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '</cellXfs>
<cellStyles count="1">
<cellStyle name="Normal" xfId="0" builtinId="0"/>
</cellStyles>
<dxfs count="0"/>
<tableStyles count="0" defaultTableStyle="TableStyleMedium2" defaultPivotStyle="PivotStyleLight16"/>
<extLst>
<ext uri="{EB79DEF2-80B8-43e5-95BD-54CBDDF9020C}" xmlns:x14="http://schemas.microsoft.com/office/spreadsheetml/2009/9/main">
<x14:slicerStyles defaultSlicerStyle="SlicerStyleLight1"/>
</ext>
</extLst>
</styleSheet>',
         p_eof         => TRUE);
      zip_util_pkg.add_file (t_excel, 'xl/styles.xml', t_xxx);
      t_xxx := NULL;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
<fileVersion appName="xl" lastEdited="5" lowestEdited="5" rupBuild="9302"/>
<workbookPr date1904="false" defaultThemeVersion="124226"/>
<bookViews>
<workbookView xWindow="120" yWindow="45" windowWidth="19155" windowHeight="4935"/>
</bookViews>
<sheets>');
 
      FOR s IN 1 .. workbook.sheets_tab.COUNT
      LOOP
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '<sheet name="'
                          || workbook.sheets_tab (s).vc_sheet_name
                          || '" sheetId="'
                          || TO_CHAR (s)
                          || '" r:id="rId'
                          || TO_CHAR (9 + s)
                          || '"/>');
      END LOOP;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '</sheets>');
 
      IF workbook.defined_names_tab.COUNT > 0
      THEN
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '<definedNames>');
 
         FOR s IN 1 .. workbook.defined_names_tab.COUNT
         LOOP
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '<definedName name="'
                             || workbook.defined_names_tab (s).vc_defined_name
                             || '"'
                             || CASE
                                   WHEN workbook.defined_names_tab (s).pi_sheet IS NOT NULL
                                   THEN ' localSheetId="' || TO_CHAR (workbook.defined_names_tab (s).pi_sheet) || '"'
                                END
                             || '>'
                             || workbook.defined_names_tab (s).vc_defined_ref
                             || '</definedName>');
         END LOOP;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '</definedNames>');
      END IF;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<calcPr calcId="144525"/></workbook>',
         p_eof         => TRUE);
      zip_util_pkg.add_file (t_excel, 'xl/workbook.xml', t_xxx);
      t_xxx := NULL;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="Office Theme">
<a:themeElements>
<a:clrScheme name="Office">
<a:dk1>
<a:sysClr val="windowText" lastClr="000000"/>
</a:dk1>
<a:lt1>
<a:sysClr val="window" lastClr="FFFFFF"/>
</a:lt1>
<a:dk2>
<a:srgbClr val="1F497D"/>
</a:dk2>
<a:lt2>
<a:srgbClr val="EEECE1"/>
</a:lt2>
<a:accent1>
<a:srgbClr val="4F81BD"/>
</a:accent1>
<a:accent2>
<a:srgbClr val="C0504D"/>
</a:accent2>
<a:accent3>
<a:srgbClr val="9BBB59"/>
</a:accent3>
<a:accent4>
<a:srgbClr val="8064A2"/>
</a:accent4>
<a:accent5>
<a:srgbClr val="4BACC6"/>
</a:accent5>
<a:accent6>
<a:srgbClr val="F79646"/>
</a:accent6>
<a:hlink>
<a:srgbClr val="0000FF"/>
</a:hlink>
<a:folHlink>
<a:srgbClr val="800080"/>
</a:folHlink>
</a:clrScheme>
<a:fontScheme name="Office">
<a:majorFont>
<a:latin typeface="Cambria"/>
<a:ea typeface=""/>
<a:cs typeface=""/>
<a:font script="Jpan" typeface="MS P????"/>
<a:font script="Hang" typeface="?? ??"/>
<a:font script="Hans" typeface="??"/>
<a:font script="Hant" typeface="????"/>
<a:font script="Arab" typeface="Times New Roman"/>
<a:font script="Hebr" typeface="Times New Roman"/>
<a:font script="Thai" typeface="Tahoma"/>
<a:font script="Ethi" typeface="Nyala"/>
<a:font script="Beng" typeface="Vrinda"/>
<a:font script="Gujr" typeface="Shruti"/>
<a:font script="Khmr" typeface="MoolBoran"/>
<a:font script="Knda" typeface="Tunga"/>
<a:font script="Guru" typeface="Raavi"/>
<a:font script="Cans" typeface="Euphemia"/>
<a:font script="Cher" typeface="Plantagenet Cherokee"/>
<a:font script="Yiii" typeface="Microsoft Yi Baiti"/>
<a:font script="Tibt" typeface="Microsoft Himalaya"/>
<a:font script="Thaa" typeface="MV Boli"/>
<a:font script="Deva" typeface="Mangal"/>
<a:font script="Telu" typeface="Gautami"/>
<a:font script="Taml" typeface="Latha"/>
<a:font script="Syrc" typeface="Estrangelo Edessa"/>
<a:font script="Orya" typeface="Kalinga"/>
<a:font script="Mlym" typeface="Kartika"/>
<a:font script="Laoo" typeface="DokChampa"/>
<a:font script="Sinh" typeface="Iskoola Pota"/>
<a:font script="Mong" typeface="Mongolian Baiti"/>
<a:font script="Viet" typeface="Times New Roman"/>
<a:font script="Uigh" typeface="Microsoft Uighur"/>
<a:font script="Geor" typeface="Sylfaen"/>
</a:majorFont>
<a:minorFont>
<a:latin typeface="Calibri"/>
<a:ea typeface=""/>
<a:cs typeface=""/>
<a:font script="Jpan" typeface="MS P????"/>
<a:font script="Hang" typeface="?? ??"/>
<a:font script="Hans" typeface="??"/>
<a:font script="Hant" typeface="????"/>
<a:font script="Arab" typeface="Arial"/>
<a:font script="Hebr" typeface="Arial"/>
<a:font script="Thai" typeface="Tahoma"/>
<a:font script="Ethi" typeface="Nyala"/>
<a:font script="Beng" typeface="Vrinda"/>
<a:font script="Gujr" typeface="Shruti"/>
<a:font script="Khmr" typeface="DaunPenh"/>
<a:font script="Knda" typeface="Tunga"/>
<a:font script="Guru" typeface="Raavi"/>
<a:font script="Cans" typeface="Euphemia"/>
<a:font script="Cher" typeface="Plantagenet Cherokee"/>
<a:font script="Yiii" typeface="Microsoft Yi Baiti"/>
<a:font script="Tibt" typeface="Microsoft Himalaya"/>
<a:font script="Thaa" typeface="MV Boli"/>
<a:font script="Deva" typeface="Mangal"/>
<a:font script="Telu" typeface="Gautami"/>
<a:font script="Taml" typeface="Latha"/>
<a:font script="Syrc" typeface="Estrangelo Edessa"/>
<a:font script="Orya" typeface="Kalinga"/>
<a:font script="Mlym" typeface="Kartika"/>
<a:font script="Laoo" typeface="DokChampa"/>
<a:font script="Sinh" typeface="Iskoola Pota"/>
<a:font script="Mong" typeface="Mongolian Baiti"/>
<a:font script="Viet" typeface="Arial"/>
<a:font script="Uigh" typeface="Microsoft Uighur"/>
<a:font script="Geor" typeface="Sylfaen"/>
</a:minorFont>
</a:fontScheme>
<a:fmtScheme name="Office">
<a:fillStyleLst>
<a:solidFill>
<a:schemeClr val="phClr"/>
</a:solidFill>
<a:gradFill rotWithShape="1">
<a:gsLst>
<a:gs pos="0">
<a:schemeClr val="phClr">
<a:tint val="50000"/>
<a:satMod val="300000"/>
</a:schemeClr>
</a:gs>
<a:gs pos="35000">
<a:schemeClr val="phClr">
<a:tint val="37000"/>
<a:satMod val="300000"/>
</a:schemeClr>
</a:gs>
<a:gs pos="100000">
<a:schemeClr val="phClr">
<a:tint val="15000"/>
<a:satMod val="350000"/>
</a:schemeClr>
</a:gs>
</a:gsLst>
<a:lin ang="16200000" scaled="1"/>
</a:gradFill>
<a:gradFill rotWithShape="1">
<a:gsLst>
<a:gs pos="0">
<a:schemeClr val="phClr">
<a:shade val="51000"/>
<a:satMod val="130000"/>
</a:schemeClr>
</a:gs>
<a:gs pos="80000">
<a:schemeClr val="phClr">
<a:shade val="93000"/>
<a:satMod val="130000"/>
</a:schemeClr>
</a:gs>
<a:gs pos="100000">
<a:schemeClr val="phClr">
<a:shade val="94000"/>
<a:satMod val="135000"/>
</a:schemeClr>
</a:gs>
</a:gsLst>
<a:lin ang="16200000" scaled="0"/>
</a:gradFill>
</a:fillStyleLst>
<a:lnStyleLst>
<a:ln w="9525" cap="flat" cmpd="sng" algn="ctr">
<a:solidFill>
<a:schemeClr val="phClr">
<a:shade val="95000"/>
<a:satMod val="105000"/>
</a:schemeClr>
</a:solidFill>
<a:prstDash val="solid"/>
</a:ln>
<a:ln w="25400" cap="flat" cmpd="sng" algn="ctr">
<a:solidFill>
<a:schemeClr val="phClr"/>
</a:solidFill>
<a:prstDash val="solid"/>
</a:ln>
<a:ln w="38100" cap="flat" cmpd="sng" algn="ctr">
<a:solidFill>
<a:schemeClr val="phClr"/>
</a:solidFill>
<a:prstDash val="solid"/>
</a:ln>
</a:lnStyleLst>
<a:effectStyleLst>
<a:effectStyle>
<a:effectLst>
<a:outerShdw blurRad="40000" dist="20000" dir="5400000" rotWithShape="0">
<a:srgbClr val="000000">
<a:alpha val="38000"/>
</a:srgbClr>
</a:outerShdw>
</a:effectLst>
</a:effectStyle>
<a:effectStyle>
<a:effectLst>
<a:outerShdw blurRad="40000" dist="23000" dir="5400000" rotWithShape="0">
<a:srgbClr val="000000">
<a:alpha val="35000"/>
</a:srgbClr>
</a:outerShdw>
</a:effectLst>
</a:effectStyle>
<a:effectStyle>
<a:effectLst>
<a:outerShdw blurRad="40000" dist="23000" dir="5400000" rotWithShape="0">
<a:srgbClr val="000000">
<a:alpha val="35000"/>
</a:srgbClr>
</a:outerShdw>
</a:effectLst>
<a:scene3d>
<a:camera prst="orthographicFront">
<a:rot lat="0" lon="0" rev="0"/>
</a:camera>
<a:lightRig rig="threePt" dir="t">
<a:rot lat="0" lon="0" rev="1200000"/>
</a:lightRig>
</a:scene3d>
<a:sp3d>
<a:bevelT w="63500" h="25400"/>
</a:sp3d>
</a:effectStyle>
</a:effectStyleLst>
<a:bgFillStyleLst>
<a:solidFill>
<a:schemeClr val="phClr"/>
</a:solidFill>
<a:gradFill rotWithShape="1">
<a:gsLst>
<a:gs pos="0">
<a:schemeClr val="phClr">
<a:tint val="40000"/>
<a:satMod val="350000"/>
</a:schemeClr>
</a:gs>
<a:gs pos="40000">
<a:schemeClr val="phClr">
<a:tint val="45000"/>
<a:shade val="99000"/>
<a:satMod val="350000"/>
</a:schemeClr>
</a:gs>
<a:gs pos="100000">
<a:schemeClr val="phClr">
<a:shade val="20000"/>
<a:satMod val="255000"/>
</a:schemeClr>
</a:gs>
</a:gsLst>
<a:path path="circle">
<a:fillToRect l="50000" t="-80000" r="50000" b="180000"/>
</a:path>
</a:gradFill>
<a:gradFill rotWithShape="1">
<a:gsLst>
<a:gs pos="0">
<a:schemeClr val="phClr">
<a:tint val="80000"/>
<a:satMod val="300000"/>
</a:schemeClr>
</a:gs>
<a:gs pos="100000">
<a:schemeClr val="phClr">
<a:shade val="30000"/>
<a:satMod val="200000"/>
</a:schemeClr>
</a:gs>
</a:gsLst>
<a:path path="circle">
<a:fillToRect l="50000" t="50000" r="50000" b="50000"/>
</a:path>
</a:gradFill>
</a:bgFillStyleLst>
</a:fmtScheme>
</a:themeElements>
<a:objectDefaults/>
<a:extraClrSchemeLst/>
</a:theme>',
         p_eof =>         TRUE);
      zip_util_pkg.add_file (t_excel, 'xl/theme/theme1.xml', t_xxx);
      t_xxx := NULL;
 
      FOR s IN 1 .. workbook.sheets_tab.COUNT
      LOOP
         t_col_min := 16384;
         t_col_max := 1;
         t_row_ind := workbook.sheets_tab (s).sheet_rows_tab.FIRST;
 
         WHILE t_row_ind IS NOT NULL
         LOOP
            t_col_min := LEAST (t_col_min, workbook.sheets_tab (s).sheet_rows_tab (t_row_ind).FIRST);
            t_col_max := GREATEST (t_col_max, workbook.sheets_tab (s).sheet_rows_tab (t_row_ind).LAST);
            t_row_ind := workbook.sheets_tab (s).sheet_rows_tab.NEXT (t_row_ind);
         END LOOP;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:xdr="http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing" xmlns:x14="http://schemas.microsoft.com/office/spreadsheetml/2009/9/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac">
<dimension ref="'
                       || alfan_col (t_col_min)
                       || workbook.sheets_tab (s).sheet_rows_tab.FIRST
                       || ':'
                       || alfan_col (t_col_max)
                       || workbook.sheets_tab (s).sheet_rows_tab.LAST
                       || '"/>
<sheetViews>
<sheetView'
                       || CASE WHEN s = 1 THEN ' tabSelected="1"' END
                       || ' workbookViewId="0">');
 
         IF workbook.sheets_tab (s).pi_freeze_rows > 0 AND workbook.sheets_tab (s).pi_freeze_cols > 0
         THEN
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<pane xSplit="'
                        || TO_CHAR (workbook.sheets_tab (s).pi_freeze_cols)
                        || '" '
                        || 'ySplit="'
                        || TO_CHAR (workbook.sheets_tab (s).pi_freeze_rows)
                        || '" '
                        || 'topLeftCell="'
                        || alfan_col (workbook.sheets_tab (s).pi_freeze_cols + 1)
                        || TO_CHAR (workbook.sheets_tab (s).pi_freeze_rows + 1)
                        || '" '
                        || 'activePane="bottomLeft" state="frozen"/>');
         ELSE
            IF workbook.sheets_tab (s).pi_freeze_rows > 0
            THEN
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '<pane ySplit="'
                                || TO_CHAR (workbook.sheets_tab (s).pi_freeze_rows)
                                || '" topLeftCell="A'
                                || TO_CHAR (workbook.sheets_tab (s).pi_freeze_rows + 1)
                                || '" activePane="bottomLeft" state="frozen"/>');
            END IF;
 
            IF workbook.sheets_tab (s).pi_freeze_cols > 0
            THEN
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '<pane xSplit="'
                                || TO_CHAR (workbook.sheets_tab (s).pi_freeze_cols)
                                || '" topLeftCell="'
                                || alfan_col (workbook.sheets_tab (s).pi_freeze_cols + 1)
                                || '1" activePane="bottomLeft" state="frozen"/>');
            END IF;
         END IF;
 
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '</sheetView>
</sheetViews>
<sheetFormatPr defaultRowHeight="15" x14ac:dyDescent="0.25"/>');
 
         IF workbook.sheets_tab (s).widths_tab_tab.COUNT > 0
         THEN
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '<cols>');
            t_col_ind := workbook.sheets_tab (s).widths_tab_tab.FIRST;
 
            WHILE t_col_ind IS NOT NULL
            LOOP
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '<col min="'
                                || TO_CHAR (t_col_ind)
                                || '" max="'
                                || TO_CHAR (t_col_ind)
                                || '" width="'
                                || TO_CHAR (workbook.sheets_tab (s).widths_tab_tab (t_col_ind), 'TM9', 'NLS_NUMERIC_CHARACTERS=.,')
                                || '" customWidth="1"/>');
               t_col_ind := workbook.sheets_tab (s).widths_tab_tab.NEXT (t_col_ind);
            END LOOP;
 
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '</cols>');
         END IF;
 
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '<sheetData>');
         t_row_ind := workbook.sheets_tab (s).sheet_rows_tab.FIRST;
 
         WHILE t_row_ind IS NOT NULL
         LOOP
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '<row r="' || t_row_ind || '" spans="' || TO_CHAR (t_col_min) || ':' || TO_CHAR (t_col_max) || '">');
            t_col_ind := workbook.sheets_tab (s).sheet_rows_tab (t_row_ind).FIRST;
 
            WHILE t_col_ind IS NOT NULL
            LOOP
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '<c r="'
                                || alfan_col (t_col_ind)
                                || TO_CHAR (t_row_ind)
                                || '"'
                                || ' '
                                || workbook.sheets_tab (s).sheet_rows_tab (t_row_ind) (t_col_ind).vc_style_def
                                || '><v>'
                                || TO_CHAR (workbook.sheets_tab (s).sheet_rows_tab (t_row_ind) (t_col_ind).nn_value_id,
                                            'TM9',
                                            'NLS_NUMERIC_CHARACTERS=.,')
                                || '</v></c>');
 
               t_col_ind := workbook.sheets_tab (s).sheet_rows_tab (t_row_ind).NEXT (t_col_ind);
            END LOOP;
 
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '</row>');
            t_row_ind := workbook.sheets_tab (s).sheet_rows_tab.NEXT (t_row_ind);
         END LOOP;
 
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '</sheetData>');
 
         FOR a IN 1 .. workbook.sheets_tab (s).autofilters_tab.COUNT
         LOOP
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '<autoFilter ref="'
                             || alfan_col (NVL (workbook.sheets_tab (s).autofilters_tab (A).pi_column_start, t_col_min))
                             || TO_CHAR (NVL (workbook.sheets_tab (s).autofilters_tab (a).pi_row_start, workbook.sheets_tab (s).sheet_rows_tab.FIRST))
                             || ':'
                             || alfan_col (
                                   COALESCE (workbook.sheets_tab (s).autofilters_tab (a).pi_column_end,
                                             workbook.sheets_tab (s).autofilters_tab (a).pi_column_start,
                                             t_col_max))
                             || TO_CHAR (NVL (workbook.sheets_tab (s).autofilters_tab (A).pi_row_end, workbook.sheets_tab (s).sheet_rows_tab.LAST))
                             || '"/>');
         END LOOP;
 
         IF workbook.sheets_tab (s).mergecells_tab.COUNT > 0
         THEN
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '<mergeCells count="' || TO_CHAR (workbook.sheets_tab (s).mergecells_tab.COUNT) || '">');
 
            FOR m IN 1 .. workbook.sheets_tab (s).mergecells_tab.COUNT
            LOOP
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '<mergeCell ref="' || workbook.sheets_tab (s).mergecells_tab (m) || '"/>');
            END LOOP;
 
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '</mergeCells>');
         END IF;
 
         --
 
         IF workbook.sheets_tab (s).validations_tab.COUNT > 0
         THEN
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '<dataValidations count="' || TO_CHAR (workbook.sheets_tab (s).validations_tab.COUNT) || '">');
 
            FOR m IN 1 .. workbook.sheets_tab (s).validations_tab.COUNT
            LOOP
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '<dataValidation'
                                || ' type="'
                                || workbook.sheets_tab (s).validations_tab (m).vc_validation_type
                                || '"'
                                || ' errorStyle="'
                                || workbook.sheets_tab (s).validations_tab (m).vc_errorstyle
                                || '"'
                                || ' allowBlank="'
                                || CASE WHEN NVL (workbook.sheets_tab (s).validations_tab (m).bo_allowblank, TRUE) THEN '1' ELSE '0' END
                                || '"'
                                || ' sqref="'
                                || workbook.sheets_tab (s).validations_tab (m).vc_sqref
                                || '"');
 
               IF workbook.sheets_tab (s).validations_tab (m).vc_prompt IS NOT NULL
               THEN
                  clob_vc_concat(
                     p_clob        => t_xxx,
                     p_vc_buffer   => t_tmp,
                     p_vc_addition => ' showInputMessage="1" prompt="'
                                   || workbook.sheets_tab (s).validations_tab (m).vc_prompt
                                   || '"');
 
                  IF workbook.sheets_tab (s).validations_tab (m).vc_title IS NOT NULL
                  THEN
                     clob_vc_concat(
                        p_clob        => t_xxx,
                        p_vc_buffer   => t_tmp,
                        p_vc_addition => ' promptTitle="'
                                      || workbook.sheets_tab (s).validations_tab (m).vc_title
                                      || '"');
                  END IF;
               END IF;
 
               IF workbook.sheets_tab (s).validations_tab (m).bo_showerrormessage
               THEN
                  clob_vc_concat(
                     p_clob        => t_xxx,
                     p_vc_buffer   => t_tmp,
                     p_vc_addition => ' showErrorMessage="1"');
 
                  IF workbook.sheets_tab (s).validations_tab (m).vc_error_title IS NOT NULL
                  THEN
                     clob_vc_concat(
                        p_clob        => t_xxx,
                        p_vc_buffer   => t_tmp,
                        p_vc_addition => ' errorTitle="'
                                      || workbook.sheets_tab (s).validations_tab (m).vc_error_title
                                      || '"');
                  END IF;
 
                  IF workbook.sheets_tab (s).validations_tab (m).vc_error_txt IS NOT NULL
                  THEN
                     clob_vc_concat(
                        p_clob        => t_xxx,
                        p_vc_buffer   => t_tmp,
                        p_vc_addition => ' error="'
                                      || workbook.sheets_tab (s).validations_tab (m).vc_error_txt
                                      || '"');
                  END IF;
               END IF;
 
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '>');
 
               IF workbook.sheets_tab (s).validations_tab (m).vc_formula1 IS NOT NULL
               THEN
                  clob_vc_concat(
                     p_clob        => t_xxx,
                     p_vc_buffer   => t_tmp,
                     p_vc_addition => '<formula1>'
                                   || workbook.sheets_tab (s).validations_tab (m).vc_formula1
                                   || '</formula1>');
               END IF;
 
               IF workbook.sheets_tab (s).validations_tab (m).vc_formula2 IS NOT NULL
               THEN
                  clob_vc_concat(
                     p_clob        => t_xxx,
                     p_vc_buffer   => t_tmp,
                     p_vc_addition => '<formula2>'
                                   || workbook.sheets_tab (s).validations_tab (m).vc_formula2
                                   || '</formula2>');
               END IF;
 
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '</dataValidation>');
            END LOOP;
 
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '</dataValidations>');
         END IF;
 
         IF workbook.sheets_tab (s).hyperlinks_tab.COUNT > 0
         THEN
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '<hyperlinks>');
 
            FOR h IN 1 .. workbook.sheets_tab (s).hyperlinks_tab.COUNT
            LOOP
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '<hyperlink ref="'
                                || workbook.sheets_tab (s).hyperlinks_tab (h).vc_cell
                                || '" r:id="rId'
                                || TO_CHAR (h)
                                || '"/>');
            END LOOP;
 
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '</hyperlinks>');
         END IF;
 
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '<pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/>');
 
         IF workbook.sheets_tab (s).comments_tab.COUNT > 0
         THEN
            -- AMEI, 20141129 Bugfix for
            -- t_xxx := t_xxx || '<legacyDrawing r:id="rId' || (workbook.sheets_tab (s).hyperlinks_tab.COUNT + 1) || '"/>';
            -- Raised ORA-06502: PL/SQL: numerischer oder Wertefehler,
            -- occurs when a at least on column has a Help Text,
            -- occurs NOT when NONE column has a Help Text at all.
            -- Bugfix by explicit conversion TO_CHAR(...)
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '<legacyDrawing r:id="rId'
                             || TO_CHAR (workbook.sheets_tab (s).hyperlinks_tab.COUNT + 1)
                             || '"/>');
         END IF;
 
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '</worksheet>',
            p_eof         => TRUE);
         zip_util_pkg.add_file (t_excel, 'xl/worksheets/sheet' || TO_CHAR (s) || '.xml', t_xxx);
         t_xxx := NULL;
 
         IF workbook.sheets_tab (s).hyperlinks_tab.COUNT > 0 OR workbook.sheets_tab (s).comments_tab.COUNT > 0
         THEN
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">');
 
            IF workbook.sheets_tab (s).comments_tab.COUNT > 0
            THEN
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '<Relationship Id="rId'
                                || TO_CHAR (workbook.sheets_tab (s).hyperlinks_tab.COUNT + 2)
                                || '" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/comments" Target="../comments'
                                || s
                                || '.xml"/>');
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '<Relationship Id="rId'
                                || TO_CHAR (workbook.sheets_tab (s).hyperlinks_tab.COUNT + 1)
                                || '" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/vmlDrawing" Target="../drawings/vmlDrawing'
                                || TO_CHAR (s)
                                || '.vml"/>');
            END IF;
 
            FOR h IN 1 .. workbook.sheets_tab (s).hyperlinks_tab.COUNT
            LOOP
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '<Relationship Id="rId'
                                || TO_CHAR (h)
                                || '" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink" Target="'
                                || workbook.sheets_tab (s).hyperlinks_tab (h).vc_url
                                || '" TargetMode="External"/>');
            END LOOP;
 
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '</Relationships>',
               p_eof         => TRUE);
            zip_util_pkg.add_file (t_excel, 'xl/worksheets/_rels/sheet' || TO_CHAR (s) || '.xml.rels', t_xxx);
            t_xxx := NULL;
         END IF;
 
         IF workbook.sheets_tab (s).comments_tab.COUNT > 0
         THEN
            DECLARE
               cnt          PLS_INTEGER;
               author_ind   st_author;
            BEGIN
               gv_authors_tab.delete;
 
               FOR c IN 1 .. workbook.sheets_tab (s).comments_tab.COUNT
               LOOP
                  gv_authors_tab (workbook.sheets_tab (s).comments_tab (c).vc_author) := 0;
               END LOOP;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<comments xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
<authors>');
               cnt := 0;
               author_ind := gv_authors_tab.FIRST;
 
               WHILE author_ind IS NOT NULL OR gv_authors_tab.NEXT (author_ind) IS NOT NULL
               LOOP
                  gv_authors_tab (author_ind) := cnt;
                  clob_vc_concat(
                     p_clob        => t_xxx,
                     p_vc_buffer   => t_tmp,
                     p_vc_addition => '<author>' || author_ind || '</author>');
                  cnt := cnt + 1;
                  author_ind := gv_authors_tab.NEXT (author_ind);
               END LOOP;
            END;
 
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '</authors><commentList>');
 
            FOR c IN 1 .. workbook.sheets_tab (s).comments_tab.COUNT
            LOOP
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '<comment ref="'
                                || alfan_col (workbook.sheets_tab (s).comments_tab (c).pi_column_nr)
                                || TO_CHAR (workbook.sheets_tab (s).comments_tab (c).pi_row_nr)
                                || '" authorId="'
                                || gv_authors_tab (workbook.sheets_tab (s).comments_tab (c).vc_author)
                                || '"><text>');
 
               IF workbook.sheets_tab (s).comments_tab (c).vc_author IS NOT NULL
               THEN
                  clob_vc_concat(
                     p_clob        => t_xxx,
                     p_vc_buffer   => t_tmp,
                     p_vc_addition => '<r><rPr><b/><sz val="9"/><color indexed="81"/><rFont val="Tahoma"/><charset val="1"/></rPr><t xml:space="preserve">'
                                   || workbook.sheets_tab (s).comments_tab (c).vc_author
                                   || ':</t></r>');
               END IF;
 
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '<r><rPr><sz val="9"/><color indexed="81"/><rFont val="Tahoma"/><charset val="1"/></rPr><t xml:space="preserve">'
                             || CASE WHEN workbook.sheets_tab (s).comments_tab (c).vc_author IS NOT NULL THEN '' END
                             || workbook.sheets_tab (s).comments_tab (c).vc_text
                             || '</t></r></text></comment>');
            END LOOP;
 
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '</commentList></comments>',
               p_eof         => TRUE);
            zip_util_pkg.add_file (t_excel, 'xl/comments' || TO_CHAR (s) || '.xml', t_xxx);
            t_xxx := NULL;
 
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '<xml xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel">
<o:shapelayout v:ext="edit"><o:idmap v:ext="edit" data="2"/></o:shapelayout>
<v:shapetype id="_x0000_t202" coordsize="21600,21600" o:spt="202" path="m,l,21600r21600,l21600,xe"><v:stroke joinstyle="miter"/><v:path gradientshapeok="t" o:connecttype="rect"/></v:shapetype>');
 
            FOR c IN 1 .. workbook.sheets_tab (s).comments_tab.COUNT
            LOOP
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '<v:shape id="_x0000_s'
                                || TO_CHAR (c)
                                || '" type="#_x0000_t202" style="position:absolute;margin-left:35.25pt;margin-top:3pt;z-index:'
                                || TO_CHAR (c)
                                || ';visibility:hidden;" fillcolor="#ffffe1" o:insetmode="auto">
<v:fill color2="#ffffe1"/><v:shadow on="t" color="black" obscured="t"/><v:path o:connecttype="none"/>
<v:textbox style="mso-direction-alt:auto"><div style="text-align:left"></div></v:textbox>
<x:ClientData ObjectType="Note"><x:MoveWithCells/><x:SizeWithCells/>');
               t_w := workbook.sheets_tab (s).comments_tab (c).pi_width;
               t_c := 1;
 
               LOOP
                  IF workbook.sheets_tab (s).widths_tab_tab.EXISTS (workbook.sheets_tab (s).comments_tab (c).pi_column_nr + t_c)
                  THEN
                     t_cw := 256 * workbook.sheets_tab (s).widths_tab_tab (workbook.sheets_tab (s).comments_tab (c).pi_column_nr + t_c);
                     t_cw := TRUNC ( (t_cw + 18) / 256 * 7);                                              -- assume default 11 point Calibri
                  ELSE
                     t_cw := 64;
                  END IF;
 
                  EXIT WHEN t_w < t_cw;
                  t_c := t_c + 1;
                  t_w := t_w - t_cw;
               END LOOP;
 
               t_h := workbook.sheets_tab (s).comments_tab (c).pi_height;
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '<x:Anchor>'
                                || TO_CHAR (workbook.sheets_tab (s).comments_tab (c).pi_column_nr)
                                || ',15,'
                                || TO_CHAR (workbook.sheets_tab (s).comments_tab (c).pi_row_nr)
                                || ',30,'
                                || TO_CHAR (workbook.sheets_tab (s).comments_tab (c).pi_column_nr + t_c - 1)
                                || ','
                                || TO_CHAR (ROUND (t_w))
                                || ','
                                || TO_CHAR (workbook.sheets_tab (s).comments_tab (c).pi_row_nr + 1 + TRUNC (t_h / 20))
                                || ','
                                || TO_CHAR (MOD (t_h, 20))
                                || '</x:Anchor>');
               clob_vc_concat(
                  p_clob        => t_xxx,
                  p_vc_buffer   => t_tmp,
                  p_vc_addition => '<x:AutoFill>false</x:AutoFill><x:Row>'
                                || TO_CHAR (workbook.sheets_tab (s).comments_tab (c).pi_row_nr - 1)
                                || '</x:Row><x:Column>'
                                || TO_CHAR (workbook.sheets_tab (s).comments_tab (c).pi_column_nr - 1)
                                || '</x:Column></x:ClientData></v:shape>');
            END LOOP;
 
            clob_vc_concat(
               p_clob        => t_xxx,
               p_vc_buffer   => t_tmp,
               p_vc_addition => '</xml>',
               p_eof         => TRUE);
            zip_util_pkg.add_file (t_excel, 'xl/drawings/vmlDrawing' || TO_CHAR (s) || '.vml', t_xxx);
            t_xxx := NULL;
         END IF;
      END LOOP;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings" Target="sharedStrings.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="theme/theme1.xml"/>');
 
      FOR s IN 1 .. workbook.sheets_tab.COUNT
      LOOP
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '<Relationship Id="rId'
                          || TO_CHAR (9 + s)
                          || '" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet'
                          || TO_CHAR (s)
                          || '.xml"/>');
      END LOOP;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '</Relationships>',
         p_eof         => TRUE);
      zip_util_pkg.add_file (t_excel, 'xl/_rels/workbook.xml.rels', t_xxx);
      t_xxx := NULL;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" count="'
                       || workbook.pi_str_cnt
                       || '" uniqueCount="'
                       || TO_CHAR (workbook.strings_tab.COUNT)
                       || '">');
 
      FOR i IN 0 .. workbook.str_ind_tab.COUNT - 1
      LOOP
         clob_vc_concat(
            p_clob        => t_xxx,
            p_vc_buffer   => t_tmp,
            p_vc_addition => '<si><t>'
                          || DBMS_XMLGEN.CONVERT (SUBSTR (workbook.str_ind_tab (i), 1, 32000))
                          || '</t></si>');
      END LOOP;
 
      clob_vc_concat(
         p_clob        => t_xxx,
         p_vc_buffer   => t_tmp,
         p_vc_addition => '</sst>',
         p_eof         => TRUE);
      zip_util_pkg.add_file (t_excel, 'xl/sharedStrings.xml', t_xxx);
      t_xxx := NULL;
      zip_util_pkg.finish_zip (t_excel);
      clear_workbook;
      RETURN t_excel;
   END finish;
 
   FUNCTION query2sheet (p_sql VARCHAR2, p_column_headers BOOLEAN := TRUE, p_sheet PLS_INTEGER := NULL)
      RETURN BLOB
   AS
      t_sheet       PLS_INTEGER;
      t_c           INTEGER;
      t_col_cnt     INTEGER;
      t_desc_tab    DBMS_SQL.desc_tab2;
      d_tab         DBMS_SQL.date_table;
      n_tab         DBMS_SQL.number_table;
      v_tab         DBMS_SQL.varchar2_table;
      t_bulk_size   PLS_INTEGER := 200;
      t_r           INTEGER;
      t_cur_row     PLS_INTEGER;
   BEGIN
      t_sheet := COALESCE (p_sheet, new_sheet);
      t_c := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (t_c, p_sql, DBMS_SQL.native);
      DBMS_SQL.describe_columns2 (t_c, t_col_cnt, t_desc_tab);
 
      FOR c IN 1 .. t_col_cnt
      LOOP
         IF p_column_headers
         THEN
            cell (c,
                  1,
                  t_desc_tab (c).col_name,
                  p_sheet   => t_sheet);
         END IF;
 
         CASE
            WHEN t_desc_tab (c).col_type IN (2, 100, 101)
            THEN
               DBMS_SQL.define_array (t_c,
                                      c,
                                      n_tab,
                                      t_bulk_size,
                                      1);
            WHEN t_desc_tab (c).col_type IN (12,
                                             178,
                                             179,
                                             180,
                                             181,
                                             231)
            THEN
               DBMS_SQL.define_array (t_c,
                                      c,
                                      d_tab,
                                      t_bulk_size,
                                      1);
            WHEN t_desc_tab (c).col_type IN (1,
                                             8,
                                             9,
                                             96,
                                             112)
            THEN
               DBMS_SQL.define_array (t_c,
                                      c,
                                      v_tab,
                                      t_bulk_size,
                                      1);
            ELSE
               NULL;
         END CASE;
      END LOOP;
 
      t_cur_row := CASE WHEN p_column_headers THEN 2 ELSE 1 END;
 
      t_r := DBMS_SQL.execute (t_c);
 
      LOOP
         t_r := DBMS_SQL.fetch_rows (t_c);
 
         IF t_r > 0
         THEN
            FOR c IN 1 .. t_col_cnt
            LOOP
               CASE
                  WHEN t_desc_tab (c).col_type IN (2, 100, 101)
                  THEN
                     DBMS_SQL.COLUMN_VALUE (t_c, c, n_tab);
 
                     FOR i IN 0 .. t_r - 1
                     LOOP
                        IF n_tab (i + n_tab.FIRST) IS NOT NULL
                        THEN
                           cell (c,
                                 t_cur_row + i,
                                 n_tab (i + n_tab.FIRST),
                                 p_sheet   => t_sheet);
                        END IF;
                     END LOOP;
 
                     n_tab.delete;
                  WHEN t_desc_tab (c).col_type IN (12,
                                                   178,
                                                   179,
                                                   180,
                                                   181,
                                                   231)
                  THEN
                     DBMS_SQL.COLUMN_VALUE (t_c, c, d_tab);
 
                     FOR i IN 0 .. t_r - 1
                     LOOP
                        IF d_tab (i + d_tab.FIRST) IS NOT NULL
                        THEN
                           cell (c,
                                 t_cur_row + i,
                                 d_tab (i + d_tab.FIRST),
                                 p_sheet   => t_sheet);
                        END IF;
                     END LOOP;
 
                     d_tab.delete;
                  WHEN t_desc_tab (c).col_type IN (1,
                                                   8,
                                                   9,
                                                   96,
                                                   112)
                  THEN
                     DBMS_SQL.COLUMN_VALUE (t_c, c, v_tab);
 
                     FOR i IN 0 .. t_r - 1
                     LOOP
                        IF v_tab (i + v_tab.FIRST) IS NOT NULL
                        THEN
                           cell (c,
                                 t_cur_row + i,
                                 v_tab (i + v_tab.FIRST),
                                 p_sheet   => t_sheet);
                        END IF;
                     END LOOP;
 
                     v_tab.delete;
                  ELSE
                     NULL;
               END CASE;
            END LOOP;
         END IF;
 
         EXIT WHEN t_r != t_bulk_size;
         t_cur_row := t_cur_row + t_r;
      END LOOP;
 
      DBMS_SQL.close_cursor (t_c);
      RETURN finish;
   EXCEPTION
      WHEN OTHERS
      THEN
         IF DBMS_SQL.is_open (t_c)
         THEN
            DBMS_SQL.close_cursor (t_c);
         END IF;
 
         RETURN NULL;
   END query2sheet;
 
   FUNCTION finish2 (p_clob                 IN OUT NOCOPY CLOB,
                     p_columns              PLS_INTEGER,
                     p_rows                 PLS_INTEGER,
                     p_XLSX_date_format     VARCHAR2,
                     p_XLSX_datetime_format VARCHAR2)
      RETURN BLOB
   AS
      t_excel               BLOB;
      t_xxx                 CLOB;
      t_str                 VARCHAR2 (32767);
   BEGIN
      DBMS_LOB.createtemporary (t_excel, TRUE);
    DBMS_LOB.createtemporary (t_xxx, TRUE);
    --
      t_str := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
           xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <dimension ref="A1:'
                       || alfan_col (p_columns)
                       || p_rows
                       || '"/>
  <sheetViews>
    <sheetView tabSelected="1"
               workbookViewId="0">
      <pane ySplit="1"
            topLeftCell="A2"
            activePane="bottomLeft"
            state="frozen"/>
      <selection pane="bottomLeft"
                 activeCell="A2"
                 sqref="A2"/>
    </sheetView>
  </sheetViews><sheetData>';
      DBMS_LOB.writeappend (t_xxx, length(t_str), t_str);
    DBMS_LOB.append (t_xxx, p_clob);
    DBMS_LOB.freetemporary (p_clob);
      t_str := '</sheetData><autoFilter ref="A1:'
                             || alfan_col (p_columns)
                             || p_rows
               || '"/>
</worksheet>';
      DBMS_LOB.writeappend (t_xxx, length(t_str), t_str);
      zip_util_pkg.add_file (t_excel, 'xl/worksheets/sheet1.xml', t_xxx);
      dbms_lob.trim( t_xxx, 0 );
      --
      t_str := '<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml" />
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml" />
  <Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml" />
  <Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml" />
  <Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
</Types>';
      DBMS_LOB.writeappend (t_xxx, length(t_str), t_str);
      zip_util_pkg.add_file (t_excel, '[Content_Types].xml', t_xxx);
      dbms_lob.trim( t_xxx, 0 );
      --
      t_str := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Target="xl/workbook.xml" Id="r_main" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument"/>
  <Relationship Target="docProps/core.xml" Id="r_props" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties"/>
</Relationships>';
      DBMS_LOB.writeappend (t_xxx, length(t_str), t_str);
      zip_util_pkg.add_file (t_excel, '_rels/.rels', t_xxx);
      dbms_lob.trim( t_xxx, 0 );
      --
      t_str := '<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
          xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <sheets>
    <sheet name="Sheet1"
           sheetId="1"
           r:id="r_sheet1" />
  </sheets>
  <definedNames>
    <definedName name="_xlnm._FilterDatabase"
                 localSheetId="0"
                 hidden="1">Sheet1!$A$1:'
           || alfan_col(p_columns) || '$' || p_rows
           || '</definedName>
  </definedNames>
</workbook>';
      DBMS_LOB.writeappend (t_xxx, length(t_str), t_str);
      zip_util_pkg.add_file (t_excel, 'xl/workbook.xml', t_xxx);
      dbms_lob.trim( t_xxx, 0 );
      --
      t_str := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
                   xmlns:dc="http://purl.org/dc/elements/1.1/"
                   xmlns:dcterms="http://purl.org/dc/terms/"
                   xmlns:dcmitype="http://purl.org/dc/dcmitype/"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <dc:creator>'
    || NVL(v('APP_USER'),SYS_CONTEXT ('userenv', 'os_user'))
    || '</dc:creator>
  <cp:lastModifiedBy>'
    || NVL(v('APP_USER'),SYS_CONTEXT ('userenv', 'os_user'))
    || '</cp:lastModifiedBy>
  <dcterms:created xsi:type="dcterms:W3CDTF">'
    || TO_CHAR (sysdate, 'yyyy-mm-dd"T"hh24:mi:ss')
    || '</dcterms:created>
  <dcterms:modified xsi:type="dcterms:W3CDTF">'
    || TO_CHAR (sysdate, 'yyyy-mm-dd"T"hh24:mi:ss')
    || '</dcterms:modified>
</cp:coreProperties>';
    DBMS_LOB.writeappend (t_xxx, length(t_str), t_str);
      zip_util_pkg.add_file (t_excel, 'docProps/core.xml', t_xxx);
      dbms_lob.trim( t_xxx, 0 );
      --
      t_str := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
  <numFmts count="2">
    <numFmt numFmtId="1000"
            formatCode="' || orafmt2excel(p_XLSX_date_format) || '" />
    <numFmt numFmtId="1001"
            formatCode="' || orafmt2excel(p_XLSX_datetime_format) || '" />
  </numFmts>
  <fonts count="2">
    <font />
    <font>
      <b/>
    </font>
  </fonts>
  <fills count="3">
    <fill>
      <patternFill patternType="none"/>
    </fill>
    <fill>
      <patternFill patternType="gray125"/>
    </fill>
    <fill>
      <patternFill patternType="solid">
        <fgColor rgb="FFE1E1E1"/>
        <bgColor indexed="64"/>
      </patternFill>
    </fill>
  </fills>
  <borders count="1">
    <border />
  </borders>
  <cellStyleXfs count="1">
    <xf />
  </cellStyleXfs>
  <cellXfs count="4">
    <xf />
    <xf fontId="1" fillId="2" applyFont="1" applyFill="1"/>
    <xf numFmtId="1000" />
    <xf numFmtId="1001" />
  </cellXfs>
</styleSheet>';
      DBMS_LOB.writeappend (t_xxx, length(t_str), t_str);
      zip_util_pkg.add_file (t_excel, 'xl/styles.xml', t_xxx);
      dbms_lob.trim( t_xxx, 0 );
      --
      t_str := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Target="worksheets/sheet1.xml" Id="r_sheet1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet"/>
  <Relationship Target="styles.xml" Id="r_styles" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles"/>
</Relationships>';
      DBMS_LOB.writeappend (t_xxx, length(t_str), t_str);
      zip_util_pkg.add_file (t_excel, 'xl/_rels/workbook.xml.rels', t_xxx);
      dbms_lob.trim( t_xxx, 0 );
      --
      zip_util_pkg.finish_zip (t_excel);
      DBMS_LOB.freetemporary (t_xxx);
      RETURN t_excel;
   exception
    when others then
        raise_application_error(-20002, '|+|' || sqlerrm || ',' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || '|+|');
   END finish2;
 
   FUNCTION query2sheet2(p_sql                  VARCHAR2,
                         p_XLSX_date_format     VARCHAR2 := 'dd/mm/yyyy',
                         p_XLSX_datetime_format VARCHAR2 := 'dd/mm/yyyy hh24:mi:ss')
      RETURN BLOB
   AS
      t_c               INTEGER;
      t_r               INTEGER;
      t_desc_tab        DBMS_SQL.desc_tab2;
      t_clob_sql        CLOB;
      t_clob_result     CLOB;
      t_column_name     VARCHAR2(30);
      t_column_type     VARCHAR2(10);
      t_str             VARCHAR2(32767);
      t_cols_count      PLS_INTEGER := 0;
      t_rows_count      PLS_INTEGER := 0;
   BEGIN
      DBMS_LOB.createtemporary (t_clob_sql, true);
      t_c := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (t_c, p_sql, DBMS_SQL.native);
      DBMS_SQL.describe_columns2 (t_c, t_cols_count, t_desc_tab);
 
      t_str := 'select xmlserialize(content xmlagg(t_xml)) as t_xml, count(*) as cnt from ( select '
            ||      'xmlelement("row",';
      DBMS_LOB.writeappend(t_clob_sql, length(t_str), t_str);
      FOR c IN 1 .. t_cols_count
      LOOP
         t_column_name := t_desc_tab (c).col_name;
         t_str := 'xmlelement("c",xmlattributes(''inlineStr'' as "t",''1'' as "s"),xmlelement("is",xmlelement("t",xmlcdata('''||t_column_name||'''))))' || case when c != t_cols_count then ',' end;
         DBMS_LOB.writeappend(t_clob_sql, length(t_str), t_str);
      END LOOP;
      t_str := ') as t_xml from dual ';
 
      DBMS_LOB.writeappend(t_clob_sql, length(t_str), t_str);
      t_str := ' union all select '
            ||      'xmlelement("row",';
      DBMS_LOB.writeappend(t_clob_sql, length(t_str), t_str);
      FOR c IN 1 .. t_cols_count
      LOOP
         t_column_name := t_desc_tab (c).col_name;
         t_column_type :=
            case
                when t_desc_tab(c).col_type IN (2,100,101)              then 'n' -- number
                when t_desc_tab(c).col_type IN (12,178,179,180,181,231) then 'd' -- date
                when t_desc_tab(c).col_type IN (1,9,96,112)             then 'inlineStr' -- char
                when t_desc_tab(c).col_type IN (8)                      then 'long' -- long
                else 'other'
            end;
         t_str :=
                'xmlelement("c",'
              ||    'xmlattributes('''||case when t_column_type in ('long','other') then 'inlineStr' else t_column_type end||''' as "t"'
              ||case when t_column_type != 'd' then '),' else ',case when nvl(trunc('||t_column_name||'),trunc(sysdate))=nvl('||t_column_name||',trunc(sysdate)) then ''2'' else ''3'' end as "s"),' end
              ||case
                    when t_column_type = 'inlineStr' then
                        'xmlelement("is",xmlelement("t",xmlcdata('||t_column_name||')))'
                    when t_column_type = 'long' then
                        'xmlelement("is",xmlelement("t",xmlcdata(''I don''''t know how to select longs'')))'
                    when t_column_type = 'other' then
                        'xmlelement("is",xmlelement("t",xmlcdata(to_clob('||t_column_name||'))))'
                    else
                        'case '
                        ||'when '||t_column_name||' is not null then xmlelement("v",'||case when t_column_type='d' then 'case when nvl(trunc('||t_column_name||'),trunc(sysdate))=nvl('||t_column_name||',trunc(sysdate)) then to_char('||t_column_name||',''yyyymmdd'') else to_char('||t_column_name||',''yyyymmdd"T"hh24miss'') end' else 'xmlcdata('||t_column_name||')' end ||') '
                        ||'else xmlelement("v") '
                        ||'end'
                end
              ||')'
              || case when c != t_cols_count then ',' end;
         DBMS_LOB.writeappend(t_clob_sql, length(t_str), t_str);
      END LOOP;
      t_str := ') as t_xml FROM ( ' || p_sql || ' )) ';
      DBMS_LOB.writeappend (t_clob_sql, length(t_str), t_str);
      DBMS_SQL.parse (t_c, t_clob_sql, DBMS_SQL.native);
      DBMS_LOB.freetemporary (t_clob_sql);
      DBMS_SQL.define_column (t_c, 1, t_clob_result);
      DBMS_SQL.define_column (t_c, 2, t_rows_count);
      t_r := DBMS_SQL.execute_and_fetch (t_c);
      DBMS_SQL.column_value (t_c, 1, t_clob_result);
      DBMS_SQL.column_value (t_c, 2, t_rows_count);
      DBMS_SQL.close_cursor (t_c);
      return finish2(p_clob             => t_clob_result,
                     p_columns          => t_cols_count,
                     p_rows             => t_rows_count,
                     p_XLSX_date_format      => p_XLSX_date_format,
                     p_XLSX_datetime_format  => p_XLSX_datetime_format) ;
   EXCEPTION
      WHEN OTHERS THEN
         IF DBMS_SQL.is_open (t_c) THEN DBMS_SQL.close_cursor (t_c); END IF;
         if DBMS_LOB.istemporary (t_clob_sql)=1 then DBMS_LOB.freetemporary (t_clob_sql); end if;
         raise_application_error(-20001, '|+|' || sqlerrm || ',' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || '|+|');
   END query2sheet2;
END;





/* ZIP UTIL PKG */



-- SPECIFICATION


create or replace PACKAGE zip_util_pkg
  AUTHID CURRENT_USER
AS

/**
* Purpose:      Package handles zipping and unzipping of files
*
* Remarks:      by Anton Scheffer, see http://forums.oracle.com/forums/thread.jspa?messageID=9289744#9289744
*
*               for unzipping, see http://technology.amis.nl/blog/8090/parsing-a-microsoft-word-docx-and-unzip-zipfiles-with-plsql
*               for zipping, see http://forums.oracle.com/forums/thread.jspa?threadID=1115748&tstart=0
*
* Who     Date        Description
* ------  ----------  --------------------------------
* MBR     09.01.2011  Created
* MK      16.04.2014  Removed UTL_FILE dependencies and file operations
* MK      01.07.2014  Added get_file_clob to immediately retrieve file content as a CLOB
*
* @headcom
**/

  /** List of all files within zipped file */
  TYPE t_file_list IS TABLE OF CLOB;


  FUNCTION little_endian( p_big IN NUMBER
                        , p_bytes IN pls_integer := 4
                        )
    RETURN RAW;

  FUNCTION get_file_list( p_zipped_blob IN BLOB
                        , p_encoding IN VARCHAR2 := NULL /* Use CP850 for zip files created with a German Winzip to see umlauts, etc */
                        )
    RETURN t_file_list;

  FUNCTION get_file( p_zipped_blob IN BLOB
                   , p_file_name IN VARCHAR2
                   , p_encoding IN VARCHAR2 := NULL
                   )
    RETURN BLOB;

  FUNCTION get_file_clob( p_zipped_blob IN BLOB
                        , p_file_name IN VARCHAR2
                        , p_encoding IN VARCHAR2 := NULL
                        )
    RETURN CLOB;

  PROCEDURE add_file( p_zipped_blob IN OUT NOCOPY BLOB
                    , p_name IN VARCHAR2
                    , p_content IN BLOB
                    )
  ;

  PROCEDURE add_file( p_zipped_blob IN OUT NOCOPY BLOB
                    , p_name IN VARCHAR2
                    , p_content CLOB
                    )
  ;

  PROCEDURE finish_zip( p_zipped_blob IN OUT NOCOPY BLOB);

END zip_util_pkg;








-- BODY


create or replace package body zip_util_pkg
is

/**
* Purpose:      Package handles zipping and unzipping of files
*
* Remarks:      by Anton Scheffer, see http://forums.oracle.com/forums/thread.jspa?messageID=9289744#9289744
*
*               for unzipping, see http://technology.amis.nl/blog/8090/parsing-a-microsoft-word-docx-and-unzip-zipfiles-with-plsql
*               for zipping, see http://forums.oracle.com/forums/thread.jspa?threadID=1115748&tstart=0
*
* Who     Date        Description
* ------  ----------  --------------------------------
* MBR     09.01.2011  Created
* MBR     21.05.2012  Fixed a bug related to use of dbms_lob.substr in get_file (use dbms_lob.copy instead)
* MK      01.07.2014  Added get_file_clob to immediatly retrieve file content as a CLOB
*
* @headcom
*/

  /* Constants */
  c_max_length CONSTANT PLS_INTEGER := 32767;
  c_file_comment CONSTANT RAW(32767) := utl_raw.cast_to_raw('Implementation by Anton Scheffer');

  /**
  * Convert to little endian raw
  */
  FUNCTION little_endian( p_big IN NUMBER
                        , p_bytes IN pls_integer := 4
                        )
    RETURN RAW
  AS
  BEGIN
    RETURN utl_raw.substr( utl_raw.cast_from_binary_integer( p_big
                                                             , utl_raw.little_endian
                                                           )
                         , 1
                         , p_bytes
                         );
  END little_endian;

  FUNCTION get_modify_date( p_modify_date IN DATE DEFAULT SYSDATE)
    RETURN RAW
  AS
  BEGIN
    RETURN little_endian( to_number( to_char( p_modify_date, 'dd' ) )
                          + to_number( to_char( p_modify_date, 'mm' ) ) * 32
                          + ( to_number( to_char( p_modify_date, 'yyyy' ) ) - 1980 ) * 512
                        , 2
                        );
  END get_modify_date;

  FUNCTION get_modify_time( p_modify_date IN DATE DEFAULT SYSDATE)
    RETURN RAW
  AS
  BEGIN
    RETURN little_endian( to_number( to_char( p_modify_date, 'ss' ) ) / 2
                          + to_number( to_char( p_modify_date, 'mi' ) ) * 32
                          + to_number( to_char( p_modify_date, 'hh24' ) ) * 2048
                        , 2
                        );
  END get_modify_time;


  FUNCTION raw2num( p_value in raw )
    RETURN NUMBER
  AS
  BEGIN                                               -- note: FFFFFFFF => -1
    RETURN utl_raw.cast_to_binary_integer( p_value
                                         , utl_raw.little_endian
                                         );

  END raw2num;

  FUNCTION raw2varchar2( p_raw IN RAW
                       , p_encoding IN VARCHAR2
                       )
    RETURN VARCHAR2
  AS
  BEGIN
    RETURN nvl( utl_i18n.raw_to_char( p_raw
                                    , p_encoding
                                    )
              , utl_i18n.raw_to_char ( p_raw
                                     , utl_i18n.map_charset( p_encoding
                                                           , utl_i18n.generic_context
                                                           , utl_i18n.iana_to_oracle
                                                           )
                                     )
              );
  END raw2varchar2;

  FUNCTION raw2varchar2( p_zipped_blob IN BLOB
                       , p_start_index IN NUMBER
                       , p_end_index IN NUMBER
                       , p_encoding IN VARCHAR2
                       )
    RETURN VARCHAR2
  AS
  BEGIN
    RETURN raw2varchar2( dbms_lob.substr( p_zipped_blob
                                        , p_start_index
                                        , p_end_index
                                        )
                       , p_encoding
                       );
  END raw2varchar2;


  FUNCTION raw2num( p_zipped_blob IN BLOB
                  , p_start_index IN NUMBER
                  , p_end_index IN NUMBER
                  )
    RETURN NUMBER
  AS
  BEGIN
    RETURN raw2num( dbms_lob.substr( p_zipped_blob
                                   , p_start_index
                                   , p_end_index
                                   )
                  );
  END raw2num;

  FUNCTION get_file_list( p_zipped_blob IN BLOB
                        , p_encoding IN VARCHAR2 := NULL
  )
    RETURN t_file_list
  AS
    l_index INTEGER;
    l_header_index INTEGER;
    l_file_list t_file_list;
  BEGIN
    l_index := dbms_lob.getlength( p_zipped_blob ) - 21;
    LOOP
      EXIT WHEN dbms_lob.substr( p_zipped_blob, 4, l_index ) = hextoraw( '504B0506' )
             OR l_index < 1;
      l_index := l_index - 1;
    END LOOP;

    IF l_index <= 0 THEN
      RETURN NULL;
    END IF;

    l_header_index := raw2num( p_zipped_blob, 4, l_index + 16 ) + 1;
    l_file_list := t_file_list( );
    l_file_list.EXTEND( raw2num( p_zipped_blob, 2, l_index + 10 ) );

    FOR i IN 1 .. raw2num( p_zipped_blob, 2, l_index + 8 )
    LOOP
      l_file_list( i ) := raw2varchar2( p_zipped_blob
                                      , raw2num( p_zipped_blob, 2, l_header_index + 28 )
                                      , l_header_index + 46
                                      , p_encoding
                                      );
      l_header_index := l_header_index
                      + 46
                      + raw2num( dbms_lob.substr( p_zipped_blob, 2, l_header_index + 28 ) )
                      + raw2num( dbms_lob.substr( p_zipped_blob, 2, l_header_index + 30 ) )
                      + raw2num( dbms_lob.substr( p_zipped_blob, 2, l_header_index + 32 ) );
    END LOOP;

    RETURN l_file_list;
  END get_file_list;

  FUNCTION get_file( p_zipped_blob IN BLOB
                   , p_file_name IN VARCHAR2
                   , p_encoding IN VARCHAR2 := NULL
                   )
    RETURN BLOB
  AS
    l_retval BLOB;
    l_index INTEGER;
    l_header_index INTEGER;
    l_file_index INTEGER;
  BEGIN
    l_index := dbms_lob.getlength( p_zipped_blob ) - 21;
    LOOP
      EXIT WHEN dbms_lob.substr( p_zipped_blob, 4, l_index ) = hextoraw( '504B0506' )
             OR l_index < 1;
      l_index := l_index - 1;
    END LOOP;

    IF l_index <= 0 THEN
      RETURN NULL;
    END IF;

    l_header_index := raw2num( p_zipped_blob, 4, l_index + 16 ) + 1;
    FOR i IN 1 .. raw2num( p_zipped_blob, 2, l_index + 8 )
    LOOP
      IF p_file_name = raw2varchar2( p_zipped_blob
                                   , raw2num( p_zipped_blob, 2, l_header_index + 28 )
                                   , l_header_index + 46
                                   , p_encoding
                                   )
      THEN
        IF dbms_lob.substr( p_zipped_blob, 2, l_header_index + 10 ) = hextoraw( '0800' ) -- deflate
        THEN
          l_file_index := raw2num( p_zipped_blob, 4, l_header_index + 42 );
          l_retval := hextoraw( '1F8B0800000000000003' ); -- gzip header
          dbms_lob.copy( l_retval
                       , p_zipped_blob
                       , raw2num( p_zipped_blob, 4, l_file_index + 19 )
                       , 11
                       , l_file_index
                         + 31
                         + raw2num( p_zipped_blob, 2, l_file_index + 27 )
                         + raw2num( p_zipped_blob, 2, l_file_index + 29 )
                       );
          dbms_lob.append( l_retval
                         , dbms_lob.substr( p_zipped_blob, 4, l_file_index + 15 )
                         );
          dbms_lob.append( l_retval
                         , dbms_lob.substr( p_zipped_blob, 4, l_file_index + 23 )
                         );
          RETURN utl_compress.lz_uncompress( l_retval );
        END IF;
        IF dbms_lob.substr( p_zipped_blob, 2, l_header_index + 10) = hextoraw( '0000' ) -- The file is stored (no compression)
        THEN
          l_file_index := raw2num( p_zipped_blob, 4, l_header_index + 42 );

          dbms_lob.createtemporary(l_retval, cache => true);

          dbms_lob.copy(dest_lob => l_retval,
                        src_lob => p_zipped_blob,
                        amount => raw2num( p_zipped_blob, 4, l_file_index + 19 ),
                        dest_offset => 1,
                        src_offset => l_file_index + 31 + raw2num(dbms_lob.substr(p_zipped_blob, 2, l_file_index + 27)) + raw2num(dbms_lob.substr( p_zipped_blob, 2, l_file_index + 29))
                       );

          RETURN l_retval;
        END IF;
      END IF;
      l_header_index := l_header_index
                      + 46
                      + raw2num( p_zipped_blob, 2, l_header_index + 28 )
                      + raw2num( p_zipped_blob, 2, l_header_index + 30 )
                      + raw2num( p_zipped_blob, 2, l_header_index + 32 );
    END LOOP;
    RETURN NULL;
  END get_file;

  FUNCTION get_file_clob( p_zipped_blob IN BLOB
                        , p_file_name IN VARCHAR2
                        , p_encoding IN VARCHAR2 := NULL
                        )
    RETURN CLOB
  AS
    l_file_blob BLOB;
    l_return CLOB;
    l_dest_offset INTEGER := 1;
    l_src_offset INTEGER := 1;
    l_warning INTEGER;
    l_lang_ctx INTEGER := dbms_lob.DEFAULT_LANG_CTX;
  BEGIN
    l_file_blob := get_file( p_zipped_blob => p_zipped_blob
                           , p_file_name => p_file_name
                           , p_encoding => p_encoding
                           );
    IF l_file_blob IS NULL THEN
      raise_application_error( -20000
                             , 'File not found...'
                             );
    END IF;
    dbms_lob.createtemporary (l_return, true);
    dbms_lob.converttoclob( dest_lob => l_return
                          , src_blob => l_file_blob
                          , amount => dbms_lob.lobmaxsize
                          , dest_offset => l_dest_offset
                          , src_offset => l_src_offset
                          , blob_csid => dbms_lob.default_csid
                          , lang_context =>l_lang_ctx
                          , warning => l_warning
                          );
    RETURN l_return;
  END get_file_clob;

  PROCEDURE add_file( p_zipped_blob IN OUT NOCOPY BLOB
                    , p_name IN VARCHAR2
                    , p_content IN BLOB
  )
  AS
    l_new_file BLOB;
    l_content_length INTEGER;
  BEGIN
    l_new_file := utl_compress.lz_compress( p_content );
    l_content_length := dbms_lob.getlength( l_new_file );

    IF p_zipped_blob IS NULL THEN
      dbms_lob.createtemporary( p_zipped_blob, true );
    END IF;
    dbms_lob.APPEND( p_zipped_blob
                   , utl_raw.concat ( hextoraw( '504B0304' )                                -- Local file header signature
                                    , hextoraw( '1400' )                                    -- version 2.0
                                    , hextoraw( '0000' )                                    -- no General purpose bits
                                    , hextoraw( '0800' )                                    -- deflate
                                    , get_modify_time                                       -- File last modification time
                                    , get_modify_date                                       -- File last modification date
                                    , dbms_lob.substr( l_new_file, 4, l_content_length - 7) -- CRC-321
                                    , little_endian( l_content_length - 18 )                -- compressed size
                                    , little_endian( dbms_lob.getlength( p_content ) )      -- uncompressed size
                                    , little_endian( LENGTH( p_name ), 2 )                  -- File name length
                                    , hextoraw( '0000' )                                    -- Extra field length
                                    , utl_raw.cast_to_raw( p_name )                         -- File name
                                    )
                   );
    dbms_lob.copy( p_zipped_blob
                 , l_new_file
                 , l_content_length - 18
                 , dbms_lob.getlength( p_zipped_blob ) + 1
                 , 11
                 );  -- compressed content
    dbms_lob.freetemporary( l_new_file );
  END add_file;

  PROCEDURE add_file( p_zipped_blob IN OUT NOCOPY BLOB
                    , p_name IN VARCHAR2
                    , p_content CLOB
                    )
  AS
    l_tmp BLOB;
    dest_offset INTEGER := 1;
    src_offset INTEGER := 1;
    l_warning INTEGER;
    l_lang_ctx INTEGER := dbms_lob.DEFAULT_LANG_CTX;
  BEGIN
    dbms_lob.createtemporary( l_tmp, true );
    dbms_lob.converttoblob( l_tmp
                          , p_content
                          , dbms_lob.lobmaxsize
                          , dest_offset
                          , src_offset
                          , nls_charset_id( 'AL32UTF8' )
                          , l_lang_ctx
                          , l_warning
                          );
    add_file( p_zipped_blob, p_name, l_tmp );
    dbms_lob.freetemporary( l_tmp );
  END add_file;

  PROCEDURE finish_zip( p_zipped_blob IN OUT NOCOPY BLOB )
  AS
    l_cnt pls_integer := 0;
    l_offset INTEGER;
    l_offset_directory INTEGER;
    l_offset_header INTEGER;
  BEGIN
    l_offset_directory := dbms_lob.getlength( p_zipped_blob );
    l_offset := dbms_lob.instr( p_zipped_blob
                              , hextoraw( '504B0304' )
                              , 1
                              );
    WHILE l_offset > 0 LOOP
      l_cnt := l_cnt + 1;
      dbms_lob.APPEND( p_zipped_blob
                     , utl_raw.concat( hextoraw( '504B0102' )                           -- Central directory file header signature
                                     , hextoraw( '1400' )                               -- version 2.0
                                     , dbms_lob.substr( p_zipped_blob, 26, l_offset + 4 )
                                     , hextoraw( '0000' )                               -- File comment length
                                     , hextoraw( '0000' )                               -- Disk number where file starts
                                     , hextoraw( '0100' )                               -- Internal file attributes
                                     , hextoraw( '2000B681' )                           -- External file attributes
                                     , little_endian( l_offset - 1 )                    -- Relative offset of local file header
                                     , dbms_lob.substr( p_zipped_blob
                                                      , utl_raw.cast_to_binary_integer( dbms_lob.substr( p_zipped_blob
                                                                                                       , 2
                                                                                                       , l_offset + 26
                                                                                                       )
                                                                                      , utl_raw.little_endian
                                                                                      )
                                                      , l_offset + 30
                                                      )                                 -- File name
                                    )
                     );
      l_offset := dbms_lob.instr( p_zipped_blob
                                , hextoraw( '504B0304' )
                                , l_offset + 32
                                );
    END LOOP;

    l_offset_header := dbms_lob.getlength( p_zipped_blob );
    dbms_lob.APPEND( p_zipped_blob
                  , utl_raw.concat( hextoraw( '504B0506' )                                         -- End of central directory signature
                                   , hextoraw( '0000' )                                            -- Number of this disk
                                   , hextoraw( '0000' )                                            -- Disk where central directory starts
                                   , little_endian( l_cnt, 2 )                                     -- Number of central directory records on this disk
                                   , little_endian( l_cnt, 2 )                                     -- Total number of central directory records
                                   , little_endian( l_offset_header - l_offset_directory )         -- Size of central directory
                                   , little_endian( l_offset_directory )                           -- Relative offset of local file header
                                   , little_endian( nvl( utl_raw.length( c_file_comment ), 0 ), 2) -- ZIP file comment length
                                   , c_file_comment
                                   )
                    );
  END finish_zip;

end zip_util_pkg;




/* APPLICATION PROCESS */



-- exportStatmentOfCompletenes2


declare
    lBlob blob;
    lQuery clob;
    lSheetName varchar2(500);
    lTitleName varchar2(500);
    lName varchar2(500);
    lLand varchar2(500);
    lLandBNr varchar2(50);
    lFilename varchar2(250);
begin
    -- Retrieve the user's name
    select b.nachname || '_' || b.Vorname
    into lName
    from T_Benutzer b
    where BENUTZERID = :G_BENUTZERID;

    -- Retrieve country information
    select b_nummer, land
    into lLandBNr, lLand
    from t_land
    where LANDID = :P430_LAND;
    
    -- Prepare the query array for the combined report
      
    lQuery := PCK_RI_EXPORT.fGetSQLExportCombined; -- Used the new combined function
    
    -- Prepare the title for the Excel sheet
    
    lTitleName := 'Country: ' || lLand || ' (' || lLandBNr || ') Combined Report';
    
    -- Prepare the sheet name
 
    lSheetName := 'Combined Report';
    
    -- Generate the Excel file with the combined report
    lBlob := emano_report.fMakeExcelsingleSheet(lSheetName, lTitleName, lQuery);
    
    -- Set the filename for the Excel file
    lFilename := 'Excel-Export-Statement_of_Completeness-' || lLandBNr || '-' || lLand || '-' || lName || '-' || to_char(sysdate, 'YYYY-MM-DD-HH24-MI-SS') || '.xlsx';
       
    -- Initiate the HTTP response for file download
    sys.htp.init;
    sys.owa_util.mime_header('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', false);   
    sys.htp.p('Content-length: ' || dbms_lob.getlength(lBlob));
    sys.htp.p('Content-Disposition: attachment; filename="' || lFilename || '"');
    sys.htp.p('Cache-Control: no-cache, no-store, must-revalidate');
    sys.htp.p('Pragma: no-cache');
    sys.htp.p('Expires: 0');
    sys.owa_util.http_header_close;
    
    -- Download the file
    sys.wpg_docload.download_file(lBlob);
    
    -- Stop further APEX processing
    apex_application.stop_apex_engine;
        
exception
    when others then
        htp.p(dbms_utility.format_error_backtrace);
end;







/* INTERACTIVE GRID CUSTOM FILTER USING PROCEDURE */




create or replace PROCEDURE FILTER_DATA (
    p_operator IN VARCHAR2,
    p_kpb IN VARCHAR2
)
IS
    sql_stmt VARCHAR2(1000);
    type t_cursor is ref cursor;
    c_cursor t_cursor;
    kpb_id T_KPB.KPB_ID%TYPE;
BEGIN
    CASE p_operator
        WHEN 'gleich' THEN -- 1 = 'gleich'
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE UPPER(TRIM(KPB)) = UPPER(TRIM(:p_kpb))';
        WHEN 'ungleich' THEN -- 2 = 'ungleich'
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE UPPER(TRIM(KPB)) <> UPPER(TRIM(:p_kpb))';
        WHEN 'ist leer' THEN -- 3 = 'ist leer'
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE TRIM(KPB) IS NULL OR TRIM(KPB) = ''''';
        WHEN 'ist nicht leer' THEN -- 4 = 'ist nicht leer'
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE UPPER(TRIM(KPB)) IS NOT NULL AND LENGTH(TRIM(KPB)) > 0';
        WHEN 'in' THEN -- 5 = 'in'
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE UPPER(TRIM(KPB)) IN (' || REGEXP_REPLACE(UPPER(TRIM(p_kpb)), '([^,]+)', '''\1''') || ')';
        WHEN 'nicht in' THEN -- 6 = 'nicht in'
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE UPPER(TRIM(KPB)) NOT IN (' || REGEXP_REPLACE(UPPER(TRIM(p_kpb)), '([^,]+)', '''\1''') || ')';
        WHEN 'enthält' THEN -- 7 = 'enthält'
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE UPPER(TRIM(KPB)) LIKE ''%' || UPPER(TRIM(p_kpb)) || '%''';
        WHEN 'enthält nicht' THEN -- 8 = 'enthält nicht'
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE UPPER(TRIM(KPB)) NOT LIKE ''%' || UPPER(TRIM(p_kpb)) || '%''';
        WHEN 'beginnt mit' THEN -- 9 = 'beginnt mit'
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE UPPER(TRIM(KPB)) LIKE ''' || UPPER(TRIM(p_kpb)) || '%''';
        WHEN 'beginnt nicht mit' THEN -- 10 = 'beginnt nicht mit'
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE UPPER(TRIM(KPB)) NOT LIKE ''' || UPPER(TRIM(p_kpb)) || '%''';
        WHEN 'entspricht regulärem Ausdruck' THEN
            sql_stmt := 'SELECT KPB_ID FROM T_KPB WHERE REGEXP_LIKE(UPPER(TRIM(KPB)), ''^'||UPPER(TRIM(p_kpb))||'\d+/\d+[A-Z]+_[A-Z]$'')';
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Invalid operator specified.');
    END CASE;


    IF p_operator IN ('gleich', 'ungleich') THEN
        OPEN c_cursor FOR sql_stmt USING UPPER(TRIM(p_kpb));
    ELSE
        OPEN c_cursor FOR sql_stmt;
    END IF;

    LOOP
        FETCH c_cursor INTO kpb_id;
        EXIT WHEN c_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(kpb_id);
    END LOOP;

    CLOSE c_cursor;
END FILTER_DATA;


-- TO check whether sql query and pl sql is returning correct or not we can check using 


SELECT KPB_ID, KPB FROM T_KPB WHERE REGEXP_LIKE(KPB, '^AU\d+/\d+[A-Z]+_[A-Z]$')


declare
l_sql clob;
begin
l_sql :='SELECT KPB_ID, KPB FROM T_KPB WHERE REGEXP_LIKE(UPPER(TRIM(KPB)), ''^'||UPPER(TRIM(:KPB))||'\d+/\d+[A-Z]+_[A-Z]$'')';

dbms_output.put_line(l_sql);
end;





BEGIN
  FILTER_DATA('entspricht regulärem Ausdruck', 'AU');
END;

-- TEST CASES

BEGIN
    FILTER_DATA('gleich', 'AU310/6Eu_B');
END;


BEGIN
    FILTER_DATA('ungleich', 'au310/6EU_B');
END;


BEGIN
    FILTER_DATA('ist leer', NULL); 
END;


BEGIN
    FILTER_DATA('ist nicht leer', NULL);
END;


BEGIN
    FILTER_DATA('in', 'AU536/0MY_K2,AU310/6EU_B,AU572/0EU_KR');
END;


BEGIN
    FILTER_DATA('nicht in', 'AU536/0MY_K2,AU310/6EU_B,AU572/0EU_KR');
END;


BEGIN
    FILTER_DATA('enthält', 'AU');
END;


BEGIN
    FILTER_DATA('enthält nicht', 'AU');
END;


BEGIN
FILTER_DATA('beginnt mit', 'AU3');
END;


BEGIN
FILTER_DATA('beginnt nicht mit', 'AU3');
END;


BEGIN
  FILTER_DATA('entspricht regulärem Ausdruck', '^AU\d+/\d+[A-Z]+_[A-Z]$');
END;



-- REG EXP EXPLANATION

Sure, let me break down the regular expression `'^AU\d+/\d+[A-Z]+_[A-Z]$'` for you:

1. `^`: This symbol represents the start of the string.
2. `AU`: This matches the literal characters "AU".
3. `\d+`: This matches one or more digits (0-9).
4. `/`: This matches the literal forward slash character.
5. `\d+`: This matches one or more digits (0-9).
6. `[A-Z]+`: This matches one or more uppercase letters (A-Z).
7. `_`: This matches the literal underscore character.
8. `[A-Z]`: This matches a single uppercase letter (A-Z).
9. `$`: This symbol represents the end of the string.

So, the complete regular expression `'^AU\d+/\d+[A-Z]+_[A-Z]$'` matches a string that:

- Starts with "AU"
- Followed by one or more digits
- Then a forward slash
- Followed by one or more digits
- Then one or more uppercase letters
- Then an underscore
- And finally, a single uppercase letter
- And the string must match the entire pattern (start to end)

For example, the following strings would match this regular expression:

- `AU123/456ABC_D`
- `AU456/789XYZ_Q`
- `AU1/2DEF_G`

And the following strings would not match:

- `AU123/456abc_D` (lowercase letters)
- `AU123/456_D` (no uppercase letters after the slash)
- `AU123/456ABCD` (no underscore)
- `AU123/456ABC_d` (lowercase letter at the end)





/* COMPLETE REGINDEX PACKAGES - AUDI */

	
/* EMANO REPORT */

-- SPECIFICATION

create or replace package emano_report is
    -- Die folgenden Konstanten sind vierstellig, da die Oracle-internen
    -- Entsprechungen 1-3-stellig sind
    cStringType constant number := 1001;
    cDateType constant number := 1002;
    cNumberType constant number := 1003;
    fQuery clob;
    runtime_exception exception; -- Für Programmier-Fehler oder noch nicht implementierten Code
    parameter_exception exception; -- Für ungültige Parameter
    fNumberOfColumns number;
    fRowCount number;
    cFetchLimit constant number := 32000;
    type tExcelConfig is record (
        fOffsetRows number default 4,
        fOffsetCols number default 1,
        fUseAutoFilter boolean default true,
        fUseFreezePane boolean default true
    );
    fExcelConfig tExcelConfig;
    type tStringResults is table of dbms_sql.clob_table;
    type tNumberResults is table of dbms_sql.Number_Table;
    type tDateResults is table of dbms_sql.Date_Table;
    type tColumn is record (
        fIndex number,
        fName varchar2(250),
        fDisplayName varchar2(250),
        fType number,
        fColumnWidth number  -- Für Excel: -1 --> Auto-Breite (default), 0 --> keine Breite
    );
    type tColumnTable is table of tColumn;
    fColumns tColumnTable := tColumnTable();
    fStringResults tStringResults := tStringResults();
    fDateResults tDateResults := tDateResults();
    fNumberResults tNumberResults := tNumberResults();
    
    type tArrayOfClob is table of clob;
    procedure pInit(aQuery in clob);
    procedure pExecute;
    function fGetColumnType(aColumnIndex in number) return number;
    function fMakeExcel(aSheetName in varchar2 default null) return blob;
    function fWrapperExcel(aSQL in varchar2) return blob;
    function fMakeCSV return blob;
    function fWrapperCSV(aSQL in varchar2) return blob;
 function fWrapperCSV2(aSQL in clob) return blob;
  --  function fMakeExcelMultSheet(aSheetName in apex_t_varchar2, aTitleName in apex_t_varchar2, aQuery in tArrayOfClob, aVertraulich in number default null) return blob;
    function fMakeExcelSingleSheet(aSheetName in varchar2, aTitleName in varchar2, aQuery in clob, aVertraulich in number default null) return blob;
    
end emano_report;




-- BODY

create or replace package body emano_report is
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
 
 
 
 
 
/* Single */
       
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
                        
 
                        /*
                        -- Check 'Current' section: Fill 'Local Regulation', 'Correction', and 'Comments' with gray if 'Local Regulation' is empty
                        if fGetStringValue(lZeile, lCurrentLocalRegColumnIndex) is null then
                       
                            if lSpalte in (lCurrentLocalRegColumnIndex,lCurrentCorrectionColumnIndex, lCurrentCommentsColumnIndex) then
                                lFillColor := lFillGray;
                            end if;
                        end if;
                        
                        -- Check 'Future' section: Fill 'Local Regulation' and related columns with gray if 'Local Regulation' is empty
                        if fGetStringValue(lZeile, lFutureLocalRegColumnIndex) is null then
                        
                            if lSpalte in (lFutureLocalRegColumnIndex,lFutureCorrectionColumnIndex, lFutureCommentsColumnIndex, lFutureEnactDateColumnIndex, lFutureImpDateNewTypeColumnIndex, lFutureImpDateAllVehiclesColumnIndex) then
                                lFillColor := lFillGray;
                            end if;
                        end if;
                        */
 
 
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
             
            /*
                -- Inside the loop where cells are formatted
                for lZeile in 1..fRowCount loop
 
                    for lSpalte in 1..(fNumberOfColumns-1) loop
                        lBorder := fMakeExcelCellBorder(lZeile, lSpalte);
                        lFillColor := lNoFill; -- Default to no fill
 
                        -- Directly set the gray fill for specific columns
                        if lSpalte in (lCurrentLocalRegColumnIndex, lCurrentCorrectionColumnIndex, lCurrentCommentsColumnIndex, lFutureLocalRegColumnIndex, lFutureCorrectionColumnIndex, lFutureCommentsColumnIndex, lFutureEnactDateColumnIndex, lFutureImpDateNewTypeColumnIndex, lFutureImpDateAllVehiclesColumnIndex) then
                            lFillColor := lFillGray;
                        end if;
 
                        -- Now call the procedure to make the Excel cell with the appropriate fill color.
                        pMakeExcelCell(lZeile, lSpalte, lFontCell, lFillColor, lBorder);
                    end loop;
                end loop;
            */
/*
-- Inside the loop where cells are formatted
for lZeile in 1..fRowCount loop
 
    for lSpalte in 1..(fNumberOfColumns-1) loop
        lBorder := fMakeExcelCellBorder(lZeile, lSpalte);
        lFillColor := lNoFill; -- Default to no fill
 
        -- Set the grey fill for the columns E, H, I, J, K
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
 
*/
 
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
        
             
end emano_report;






/* EMANO UTIL */

-- SPECIFICATION

create or replace PACKAGE "EMANO_UTIL" AS 

    procedure pResetPageIGIR(aPageID in number, aAPPID in number);
    function fLang(aTextDe in varchar2, aTextEn in varchar2) return varchar2;
    function fGetLang(aBenutzerid in number default null) return varchar2;    
    function fBlobToClob(aBlob in blob, aCharset in number default nls_charset_id('WE8ISO8859P1')) return clob;    
    function fTimestampToDate(aInput varchar2) return date;
    
    function fBitmaskSet(aBitmask in number, aIndex in number, aValue in number) return number deterministic;
    function fBitmaskGet(aBitmask in number, aIndex in number) return number deterministic;   
    function fPrintBitmask(aBitmask in number) return varchar2;    
    function fColonListToBitmask(aString in varchar2) return number deterministic;    
    function fIsUnequal (aString1 varchar2, aString2 varchar2) return number deterministic;    

END EMANO_UTIL;



-- BODY

create or replace PACKAGE BODY "EMANO_UTIL" AS

    /* Liefert die Sprache des angegebenen Benutzers zurück. Wird kein Benutzer angegeben, dann
       vom aktuell angemeldeten Benutzer. */
    function fGetLang(aBenutzerid in number default null) return varchar2 AS
        lLang varchar2(20);

    BEGIN
        if (aBenutzerID is null) then
            RETURN nvl(APEX_UTIL.FETCH_APP_ITEM('FSP_LANGUAGE_PREFERENCE'),'de');
        else
            select userlang into lLang
            from t_benutzer
            where benutzerid = aBenutzerid;
            return lLang;
        end if;

  END fGetLang;
  
  
  function fTimestampToDate(aInput varchar2) return date is
    begin
        return cast(to_timestamp_tz(aInput, 'yyyy-mm-dd"T"hh24:mi:ss.ff3+TZH:TZM') at time zone DBTIMEZONE as date) ;   
    end fTimestampToDate;


    function fLang(aTextDe in varchar2, aTextEn in varchar2) return varchar2 AS
        lLang varchar(20) := fGetLang();  
    BEGIN
        if (lLang = 'en') then
            return aTextEn;
        else
            return aTextDe;
        end if;
    END fLang;


    procedure pResetPageIGIR(aPageID in number, aAPPID in number) is
    begin

        for r in (
          select page_id, region_id 
          from apex_application_page_regions
          where application_id =aAPPID
          and (
              page_id=aPageID  
              ) 
          and source_type = 'Interactive Grid'
        ) loop
        apex_ig.reset_report (
            p_page_id  => r.page_id,
            p_region_id => r.region_id,
            p_report_id => null);
        end loop;


        for c in (
          select page_id, region_id 
          from apex_application_page_regions
          where application_id =aAPPID
          and (
              page_id=aPageID  
               )
          and source_type = 'Interactive Report'
        ) loop
        apex_ir.reset_report (
            p_page_id  => c.page_id,
            p_region_id => c.region_id,
            p_report_id => null);
        end loop; 


    end pResetPageIGIR;

function fBlobToClob(aBlob in blob, aCharset in number default nls_charset_id('WE8ISO8859P1')) return clob is

        lClob clob;
        lWarning number;
        lDestOffset number := 1;
        lSrcOffset number := 1;
        lLangContext number := dbms_lob.default_lang_ctx;
        -- Genau dieses Charset verwenden, falls von Excel gespeicherte CSVs umgewandelt werden sollen

    begin

        dbms_lob.createtemporary(lClob, true);

        dbms_lob.converttoclob(dest_lob     => lClob,
                               src_blob     => aBlob,
                               amount       => dbms_lob.lobmaxsize,
                               dest_offset  => lDestOffset,
                               src_offset   => lSrcOffset,
                               blob_csid    => aCharset,
                               lang_context => lLangContext,
                               warning      => lWarning);

        return lClob;

end fBlobToClob;   

    function fPrintBitmask(aBitmask in number) return varchar2 is
        lOutput varchar2(250) := '';
        lResult number;
    begin
    
        for i in 0..15 loop
            lResult := bitand(aBitmask,power(2,i));
            lOutput := case lResult when 0 then '0' else '1' end || lOutput;
        end loop;
        
        return lOutput;
    
    end fPrintBitmask;

    /* Setzt ein einzelnes Bit mit dem Index aIndex auf den Wert aValue */
    function fBitmaskSet(aBitmask in number, aIndex in number, aValue in number) return number deterministic AS
    BEGIN     
        if (aValue = 1) then
            -- ein Bit auf 1 setzen: XOR
            RETURN aBitmask + power(2,aIndex) - bitand(aBitmask,power(2,aIndex));
        else
            -- ein Bit auf Null setzen: NOT AND
            return bitand(aBitmask,power(2,20)-1-power(2,aIndex));
        end if;
    END fBitmaskSet;
    
    /* Holt ein einzelnes Bit aus einer Bitmaske mit dem Index aIndex */
    function fBitmaskGet(aBitmask in number, aIndex in number) return number deterministic as
        lResult number;
    begin
        lResult := bitand(aBitmask,power(2,aIndex));
        if (lResult > 0) then
            return 1;
        else
            return 0;
        end if;
            
    end fBitmaskGet;
    
    /* Wandelt eine Doppelpunkt-Liste in eine Bitmaske um
       z.B. '1:2:3' --> 2^1 + 2^2 + 2^3 = 14 */
    function fColonListToBitmask(aString in varchar2) return number deterministic is
        lReturn number;
    begin
        select sum(power(2,column_value)) into lReturn
        from apex_string.split_numbers(aString,':');
        return lReturn;
    end fColonListToBitmask;

  function fIsUnequal (aString1 varchar2, aString2 varchar2) return number deterministic is
    begin

        if (
          aString1 != aString2
          or (aString1 is null and aString2 is not null)
          or (aString1 is not null and aString2 is null)
        ) then
            return 1;
        else
            return 0;
        end if;

  end fIsUnequal;

END EMANO_UTIL;






/* KOALA UTIL */

-- SPECIFICATION


create or replace PACKAGE KOALA_UTIL AS 

    function fGetGroupmembers(aGroup in varchar2) return apex_t_varchar2;

    function fSearchDN(
        aDN in varchar2
    ) return t_ldap_table;

    /**
     gets sra groups user and saves them into T_SRA_Benutzer table 
    */
    procedure pRefresh_SRABenutzer;

   /**
    aktualize t_benutzer_ref_role table according T_SRA_Benutzer 
      aRoleid used  1000 -'VKO'  1002 - 'VEX',  1006 - 'FBEX'
    */
    procedure pupdateUserRolesfromSRA(aRoleid number);

END KOALA_UTIL;




-- BODY

```
create or replace PACKAGE BODY KOALA_UTIL AS
-- Daten sind Zugangsdaten für Schulungsumgebung!!!
    cLdapHost constant varchar2(250) := 'koala.in.audi.vwg';
    cLdapPort constant number := 636;
    cWalletPath constant varchar2(250) := 'file:/u00/app/oracle/admin/P181/wallet/REGINDEX2';
    cWalletPwd constant varchar2(250) := 'pw4_wallet_REGIND_P'; 
    cLDAPBindUser constant varchar2(250) := 'uid=S2SUDCR,cn=Users,ou=K-UMS,DC=VWG';
    cLDAPBindPass constant varchar2(250) := 'ZU>8e)%b969(ruIOSAeH'; -- Im Passwort ist nur ein Hochkomma, durch Maskierung hier doppelt!!

    function fGetGroupmembers(aGroup in varchar2) return apex_t_varchar2 AS
        lLdapAttCollection DBMS_LDAP.string_collection;   
        lLdapMessage DBMS_LDAP.message; 
        lLdapSession DBMS_LDAP.session;    
        lReturnValue number;      
        lLdapEntry DBMS_LDAP.message;  
        lAttValuesCollection DBMS_LDAP.STRING_COLLECTION;     
        lResult apex_t_varchar2;
    BEGIN

        dbms_ldap.use_exception := true;
        lLdapSession := dbms_ldap.init(cLdapHost,cLdapPort);

        lReturnValue := DBMS_LDAP.open_ssl(
                ld              => lLdapSession,
                sslwrl          => cWalletPath,
                sslwalletpasswd => cWalletPWD,
                sslauth         => 2 );

        lReturnValue := dbms_ldap.simple_bind_s(lLdapSession, cLDAPBindUser, cLDAPBindPass); 

        lLdapAttCollection(1) := 'uniquemember';        

        lReturnValue := DBMS_LDAP.search_s(
            ld       => lLdapSession,
            base     => 'DC=VWG',
            scope    => DBMS_LDAP.SCOPE_SUBTREE,
            filter   => '(&(cn=' || aGroup || '))',
            attrs    => lLdapAttCollection,
            attronly => 0,
            res      => lLdapMessage
        );        

        lLdapEntry := DBMS_LDAP.first_entry(lLdapSession, lLdapMessage);  

           while lLdapEntry IS NOT NULL loop

                dbms_output.put_line('Mitglied gefunden');

                lAttValuesCollection := DBMS_LDAP.get_values (lLdapSession, lLdapEntry,'uniquemember');

                if (lAttValuesCollection.count > 0) then

                    for i in lAttValuesCollection.first .. lAttValuesCollection.last loop

                        apex_string.push(lResult,lAttValuesCollection(i));

                    end loop;
                end if;

                lLdapEntry := DBMS_LDAP.next_entry(lLdapSession, lLdapEntry);

            end loop;

        lReturnValue := DBMS_LDAP.unbind_s(lLdapSession);        
        return lResult;

    END fGetGroupmembers;

    function fSearchDN(
        aDN in varchar2
    ) return t_ldap_table as

        lLdapFilter varchar2(250);
        lReturnValue number;
        lUserCount number;
        lLdapSession DBMS_LDAP.session;
        lLdapMessage DBMS_LDAP.message;
        lAttributeName varchar2(250);
        lLdapEntry DBMS_LDAP.message;
        lLdapElement DBMS_LDAP.ber_element;
        lAttributes DBMS_LDAP.string_collection;
        lValues DBMS_LDAP.STRING_COLLECTION;
        lLdapRow t_ldap_col;
        lLdapTable t_ldap_table := t_ldap_table();    

    begin

        lLdapFilter := '(objectclass=*)';

        dbms_ldap.use_exception := true;

        lLdapSession := dbms_ldap.init(cLdapHost,cLdapPort);

        lReturnValue := DBMS_LDAP.open_ssl(
                ld              => lLdapSession,
                sslwrl          => cWalletPath,
                sslwalletpasswd => cWalletPWD,
                sslauth         => 2 );

        lReturnValue := dbms_ldap.simple_bind_s(lLdapSession, cLDAPBindUser, cLDAPBindPass); 

        lAttributes(1) := 'telephoneNumber';
        lAttributes(2) := 'subDepartment';
        lAttributes(3) := 'mail';
        lAttributes(4) := 'givenName';
        lAttributes(5) := 'sn';
        lAttributes(6) := 'employeeNumber';
        lAttributes(7) := 'costCenter';
        lAttributes(8) := 'ntPrimaryUserAccount';
        lAttributes(9) := 'l';
        lAttributes(10):= 'uniqueidentifier';

        lAttributes(11) := 'roomNumber';
        lAttributes(12) := 'subDepartmentLong';
        lAttributes(13) := 'cn';

        lReturnValue := DBMS_LDAP.search_s(lLdapSession, aDN, DBMS_LDAP.SCOPE_SUBTREE, lLdapFilter, lAttributes, 0, lLdapMessage);
        lUserCount := DBMS_LDAP.count_entries(lLdapSession, lLdapMessage);

        lLdapEntry := DBMS_LDAP.first_entry(lLdapSession, lLdapMessage);

        while lLdapEntry IS NOT NULL
        loop

            lAttributeName := DBMS_LDAP.first_attribute(lLdapSession,lLdapEntry,lLdapElement);
            lLdapRow := t_ldap_col(null,null,null,null,null,null,null,null);

            WHILE lAttributeName IS NOT NULL
            LOOP

                lValues := DBMS_LDAP.get_values (lLdapSession, lLdapEntry, lAttributeName);

                IF (lValues.count > 0) THEN

                    case lAttributeName
                        when 'uniqueidentifier' then lLdapRow.GID:= lValues(0);
                        when 'sn' then lLdapRow.surname := lValues(0);
                        when 'givenName' then lLdapRow.givenName := lValues(0);
                        when 'subDepartment' then lLdapRow.SUBDEPARTMENT := lValues(0);
                        when 'mail' then lLdapRow.mail := lValues(0);
                        when 'telephoneNumber' then lLdapRow.phone := lValues(0);
                        else null;
                    end case;

                end if;

                lAttributeName := DBMS_LDAP.next_attribute(lLdapSession,lLdapEntry,lLdapElement);

            end loop;

            lLdapTable.extend();
            lLdapTable(lLdapTable.count) := lLdapRow;

            lLdapEntry := DBMS_LDAP.next_entry(lLdapSession, lLdapEntry);

        end loop;

        lReturnValue := DBMS_LDAP.unbind_s(lLdapSession);

        return lLdapTable; 

    end fSearchDN;

    /**
    *
    */
    procedure pRefresh_SRABenutzer is
     l_sqlcode varchar2(32);
     l_err_msg varchar2(200);
     l_co number :=0;
    BEGIN
     savepoint sp_start_del;
      delete from T_SRA_BENUTZER;
      --insert VKO
      insert into T_SRA_BENUTZER (nachname,  vorname,  abteilung,  gid, email, telefon, SRA_GROUP )
        with cte1 as ( select /*+ materialize */ column_value as dn from koala_util.fGetGroupmembers('AUDI_SRA_41384') 
                UNION
               select /*+ materialize */ column_value as dn from koala_util.fGetGroupmembers('AUDI_SRA_42067')),  
         cte2 as (  select *  from cte1  where dn != 'cn=dummy'  
       )
       select  k.surname , k.givenname , k.subdepartment ,  k.gid , k.mail, k.phone, 'VKO' 
         from cte2, koala_util.fSearchDN(cte2.dn) k ;   
      --insert VEX
      insert into T_SRA_BENUTZER (nachname,  vorname,  abteilung,   gid,email, telefon, SRA_GROUP )
        with cte1 as ( select /*+ materialize */ column_value as dn from koala_util.fGetGroupmembers('AUDI_SRA_45063') 
                UNION
               select /*+ materialize */ column_value as dn from koala_util.fGetGroupmembers('AUDI_SRA_44360')),  
         cte2 as (  select *  from cte1  where dn != 'cn=dummy'  
       )
       select  k.surname , k.givenname , k.subdepartment ,  k.gid , k.mail, k.phone, 'VEX' 
         from cte2, koala_util.fSearchDN(cte2.dn) k ;  
       --insert FBEX
      insert into T_SRA_BENUTZER (nachname,  vorname,  abteilung,   gid, email, telefon, SRA_GROUP )
        with cte1 as ( select /*+ materialize */ column_value as dn from koala_util.fGetGroupmembers('AUDI_SRA_44030') 
              ),  
         cte2 as (  select *  from cte1  where dn != 'cn=dummy'  
       )
       select  k.surname , k.givenname , k.subdepartment ,  k.gid , k.mail, k.phone,'FBEX' 
         from cte2, koala_util.fSearchDN(cte2.dn) k ; 
        commit; 
        --** actual add new user
     FOR cu2 in ( select  gid, nachname, vorname, abteilung , email, telefon from T_SRA_BENUTZER ) -- where sRA_group='FBEX' )
        LOOP
         select count(*) into l_co from T_Benutzer where gid = cu2.gid;
         if (l_co =0) then
          -- dbms_output.put_line(' benutzer mit gid= '|| cu2.gid || ' not exists' ) ;
           INSERT into T_BENUTZER( nachname,  vorname,  abteilung,  GID,  status, email, telefon )
            values(cu2.nachname, cu2.vorname, cu2.abteilung, cu2.GID, 10, cu2.email, cu2.telefon);
         else
            l_co := 0;
         end if;

     END LOOP;
     EXCEPTION 
        when others then
         l_sqlcode := sqlcode;
        l_err_msg := SUBSTR(SQLERRM, 1, 180);
           debug('exception in pRefresh_SRABenutzer, code:'|| l_sqlcode, 'msg:'||l_err_msg);
         rollback to sp_start_del;
   END;

/**
*/
 procedure pupdateUserRolesfromSRA(aRoleid number)
is
     cou number :=0;
     l_sqlcode varchar2(32);
     l_err_msg varchar2(200);
     l_roleBezeicn varchar2(16);
  begin
     if( aRoleid =1000) then
        l_roleBezeicn :='VKO';
     elsif( aRoleid =1002) then
        l_roleBezeicn :='VEX';
     elsif ( aRoleid =1006) then
        l_roleBezeicn :='FBEX';
     end if;
     savepoint start_insert;
      for cu in ( select gid from T_SRA_Benutzer 
                   where sra_group in (l_roleBezeicn) 
                     and gid not in ( select gid from T_Benutzer b 
                            join T_Benutzer_ref_Rolle brr on (b.Benutzerid = brr.Benutzerid and  rolleid = aRoleid) )
                    )
      loop
           select count(benutzerid) into cou from T_Benutzer where gid = cu.gid;
           if ( 0 < cou) then
              insert into T_Benutzer_ref_Rolle (benutzerid, rolleid)
              select benutzerid, aRoleid  from T_Benutzer where gid = cu.gid;
              cou := 0;
          -- else
                -- debug(' benutzer mit gid= '|| cu.gid || ' nicht vorhanden ' ) ;
           end if;
      end loop;
      -- entziehe rollen  - die ref in T_ET_B_AK_REF_THEMA_BENUTZER werden gelöscht 
 /*     if (aRoleid =1002 or aRoleid =1006) then
        FOR cu in (select Benutzer_ref_rolleid from T_Benutzer_ref_rolle  where rolleid = aRoleid and manuelle_zuweisung =0
               and benutzerid in (select benutzerid from t_Benutzer b where 
                          b.gid not in (select gid from T_SRA_Benutzer where sra_group =l_roleBezeicn)  )
             )
        LOOP
       -- check _ref tab
         DELETE from T_ET_B_AK_REF_THEMA_BENUTZER where BENUTZER_ref_rolleid = cu.BENUTZER_ref_rolleid;
        END LOOP;
        DELETE from T_Benutzer_ref_rolle  where rolleid = aRoleid and manuelle_zuweisung =0
         and benutzerid in (select benutzerid from t_Benutzer b where 
                            b.gid not in (select gid from T_SRA_Benutzer where sra_group =l_roleBezeicn) 
                          );
      end if;
*/
      commit;
   exception
         when others then
         l_sqlcode := sqlcode;
         l_err_msg := SUBSTR(SQLERRM, 1, 180);
           debug('exception beim SRA rollen Aktualisierung: sqlcode:'|| l_sqlcode, 'msg:'||l_err_msg);
           rollback to start_insert;
  end;

END KOALA_UTIL;
```





/* LDAP UTIL */

-- SPECIFICATION

```
create or replace PACKAGE "LDAP_UTIL" 
AS

    function fLdapSearch(
        aSurname in varchar2,
        aGivenname in varchar2 default null,
        aSubdept in varchar2 default null,
        aMail in varchar2 default null,
        aGid in varchar2 default null
    ) return t_ldap_table;

     procedure syncronizeUserDatawithLDAP;
END LDAP_UTIL;
```

-- BODY

```
create or replace PACKAGE BODY "LDAP_UTIL" AS

 --******************************************************************************
 --LDAP-Infos in Tabelle liefern
 --******************************************************************************

    function fLdapSearch(
        aSurname in varchar2,
        aGivenname in varchar2 default null,
        aSubdept in varchar2 default null,
        aMail in varchar2 default null,
        aGid in varchar2 default null
    ) return t_ldap_table as

        cLdapHost constant varchar2(250) := 'zebra.in.audi.vwg';
        cLdapPort constant number := 1389;
        cLdapBase constant varchar2(250) := 'DC=Audi,DC=vwg,DC=com';
        lLdapFilter varchar2(250);
        lReturnValue number;
        lUserCount number;
        lLdapSession DBMS_LDAP.session;
        lLdapMessage DBMS_LDAP.message;
        lAttributeName varchar2(250);
        lLdapEntry DBMS_LDAP.message;
        lLdapElement DBMS_LDAP.ber_element;
        lAttributes DBMS_LDAP.string_collection;
        lValues DBMS_LDAP.STRING_COLLECTION;
        lLdapRow t_ldap_col;
        lLdapTable t_ldap_table := t_ldap_table();

    begin

        lLdapFilter := '(&(sn=' || aSurname || '*)(givenname=' || aGivenname || '*)(subdepartment=' || aSubdept || '*)';
        if (aMail is not null) then
            lLdapFilter := lLdapFilter || '(mail=' || aMail || '*)';
        end if;
        lLdapFilter := lLdapFilter || '(gid=' || aGid || '*))';

        DBMS_LDAP.USE_EXCEPTION := TRUE;
        lLdapSession := DBMS_LDAP.init(cLdapHost,cLdapPort);
        lReturnValue := DBMS_LDAP.simple_bind_s(lLdapSession,null, null);

        lAttributes(1) := 'telephoneNumber';
        lAttributes(2) := 'subdepartment';
        lAttributes(3) := 'mail';
        lAttributes(4) := 'givenName';
        lAttributes(5) := 'sn';
        lAttributes(6) := 'employeeNumber';
        lAttributes(7) := 'costCenter';
        lAttributes(8) := 'ntPrimaryUserAccount';
        lAttributes(9) := 'l';
        lAttributes(10):= 'gid';

        lAttributes(11) := 'roomNumber';
        lAttributes(12) := 'subDepartmentLong';
        lAttributes(13) := 'cn';

        lReturnValue := DBMS_LDAP.search_s(lLdapSession, cLdapBase, DBMS_LDAP.SCOPE_SUBTREE, lLdapFilter, lAttributes, 0, lLdapMessage);
        lUserCount := DBMS_LDAP.count_entries(lLdapSession, lLdapMessage);

        lLdapEntry := DBMS_LDAP.first_entry(lLdapSession, lLdapMessage);

        while lLdapEntry IS NOT NULL
        loop

            lAttributeName := DBMS_LDAP.first_attribute(lLdapSession,lLdapEntry,lLdapElement);
            lLdapRow := t_ldap_col(null,null,null,null,null,null,null,null);

            WHILE lAttributeName IS NOT NULL
            LOOP

                lValues := DBMS_LDAP.get_values (lLdapSession, lLdapEntry, lAttributeName);

                IF (lValues.count > 0) THEN

                    case lAttributeName
                        when 'gid' then lLdapRow.GID:= lValues(0);
                        when 'sn' then lLdapRow.surname := lValues(0);
                        when 'givenName' then lLdapRow.givenName := lValues(0);
                        when 'subDepartment' then lLdapRow.SUBDEPARTMENT := lValues(0);
                        when 'mail' then lLdapRow.mail := lValues(0);
                        when 'telephoneNumber' then lLdapRow.phone := lValues(0);
                        else null;
                    end case;

                end if;

                lAttributeName := DBMS_LDAP.next_attribute(lLdapSession,lLdapEntry,lLdapElement);

            end loop;

            lLdapTable.extend();
            lLdapTable(lLdapTable.count) := lLdapRow;

            lLdapEntry := DBMS_LDAP.next_entry(lLdapSession, lLdapEntry);

        end loop;

        lReturnValue := DBMS_LDAP.unbind_s(lLdapSession);

        return lLdapTable;

    exception
        when others then
            lLdapRow := t_ldap_col(GID           => 'XXXXXXXXXXXXXXXX',
                                   SURNAME       => 'ACL',
                                   GIVENNAME     => 'Freischaltung',
                                   SUBDEPARTMENT => 'Zebra',
                                   MAIL          => 'fehlt',
                                   PHONE         => '',
                                   COSTCENTER    => '',
                                   EN            => '');
            lLdapTable := t_ldap_table();
            lLdapTable.extend();
            lLdapTable(1) := lLdapRow;
            return lLdapTable;

    end fLdapSearch;

procedure syncronizeUserDatawithLDAP is

  snachname T_Benutzer.nachname%type;
  svorname T_Benutzer.vorname%type;
  sabteilung T_Benutzer.abteilung%type;
  semail T_Benutzer.email%type;
  sphone T_Benutzer.telefon%type;
  icounter number :=0;
 BEGIN
  FOR cu IN (select gid, letzte_aenderung_datum from T_Benutzer for update) Loop
    if (cu.gid is null) then 
       continue;
    end if;
    begin
      select surname, givenname, subdepartment, mail, phone 
      into snachname, svorname, sabteilung, semail, sphone
      from Table(ldap_util.fLdapSearch( aSurname => null, aGid => cu.gid));

      EXCEPTION
       WHEN NO_DATA_FOUND THEN
       --dbms_output.put_line('no data found for ' || cu.gid ||  ', changed ' || to_char(cu.letzte_aenderung_datum, 'dd.mm.yyyy hh24:mi:ss'));
        continue;
    end;

    UPDATE T_Benutzer SET nachname = snachname, vorname = svorname,  abteilung = sabteilung,
         email = semail, telefon = sphone  
    WHERE gid = cu.gid 
      AND (nvl(nachname,'#') != nvl(snachname,'#') OR nvl(vorname,'#') != nvl(svorname,'#') OR  nvl(abteilung,'#') != nvl(sabteilung,'#') OR
         nvl(email,'#') != nvl(semail,'#') OR nvl(telefon,'#') != nvl(sphone,'#'));
    --dbms_output.put_line(' found ' || snachname || ', ' || svorname || ' for ' || cu.gid ||  ', changed ' || to_char(cu.letzte_aenderung_datum, 'dd.mm.yyyy hh24:mi:ss'));
   icounter := icounter+1;
  END LOOP;
  commit;
  dbms_output.put_line(' syncronized: ' || to_char(icounter) );
END syncronizeUserDatawithLDAP;

END LDAP_UTIL;
```




/* PCK AK*/

-- SPECIFICATION

```
create or replace PACKAGE PCK_AK AS 

    function fValidateDeleteVKO(aETB_AK_REF_BENUTZERID in number) return varchar2;


END PCK_AK;
```


-- BODY 

```
create or replace PACKAGE BODY PCK_AK AS

    function fValidateDeleteVKO(aETB_AK_REF_BENUTZERID in number) return varchar2 AS
        lAKID number;
        lBenutzerid number;
        lAnzahl number;
        lArbeitskreise varchar2(250);
    BEGIN
        select et_b_akid, benutzerid into lAKID, lBenutzerid
        from t_et_b_ak_ref_benutzer
        where et_b_ak_ref_benutzerid = aETB_AK_REF_BENUTZERID;
        
        -- Je Vorschrift, in denen der VKO Lead ist:
        for v in (select vorschriftid, vorschrift_nummer from t_vorschrift where lead_vko_benutzerid = lBenutzerid) loop
        
            with cte1 as (
                -- Arbeitskreise der Vorschrift
                select et_b_akid
                from t_vorschrift_ref_et_b_ak r
                where r.vorschriftid = v.vorschriftid
                
                intersect
                
                -- Arbeitskreise die beim Benutzer nach dem Löschvorgang übrig sind
                select et_b_akid
                from t_et_b_ak_ref_benutzer
                where benutzerid = lBenutzerid and et_b_akid != lAKID
            )
            select count(*) into lAnzahl
            from cte1;
            
            if (lAnzahl = 0) then
                -- Es bleibt nach dem Löschvorgang keine Schnittmenge übrig, Löschvorgang ist daher nicht erlaubt
                select listagg(ak.kurz, ', ') within group (order by ak.kurz) into lArbeitskreise
                from t_et_b_ak_ref_benutzer r
                join t_et_b_ak ak on (r.et_b_akid = ak.et_b_akid)
                where r.benutzerid = lBenutzerid;
                return 'Der Anwender ist den Arbeitskreisen ' || lArbeitskreise || ' als VKO zugeordnet. Der Löschvorgang ist daher wegen der Vorschrift ' || v.vorschrift_nummer || ' nicht erlaubt!';
            end if;
            
        end loop;
        
        RETURN null;
    END fValidateDeleteVKO;

END PCK_AK;
```


/* PCK RI*/

-- SPECIFICATION

```
create or replace PACKAGE                      "PCK_RI" AS 

    -- PK der Rolle 'Admin'
    g_rolleid_admin constant number := 1003;

function fGetUserId return NUMBER;

/* Setzt alle vernetzten Informationen für eine Vorschrift zurück */
procedure pResetVI(aVorschriftID in number);

/* Setzt die Arbeitskreise für eine Vorschrift zurück */
procedure pResetAK(aVorschriftID in number);

/* Setzt die Antriebsarten für eine Vorschrift zurück */
procedure pResetAA(aVorschriftID in number);

/* Setzt die FUKA-Funktionen für eine Vorschrift zurück */
procedure pResetFunktionen(aVorschriftID in number);

/* Entfernt Sonderzeichen */
function fSanitizeForTree(aText in varchar2) return varchar2;

/* Liefert 1 zurück, wenn es sich um einen anonymen oder deaktivierten User handelt
   --> nur freigegebene Vorschriften sichtbar */
function fIsLimitedUser(userId number default fGetUserId) return number;

-- Ermittlung ob der Benutzer auf die Seite lesend oder schreibend zugreifen darf
-- accessMode: 100 lesend, 200 schreibend, 300 Admin only
function fIsAuthorized(userId NUMBER default fGetUserId, pageId NUMBER, accessMode NUMBER) return BOOLEAN;

FUNCTION fIsAuthorized01(userId NUMBER default fGetUserId, pageId NUMBER, accessMode NUMBER) return number;

/* Ermittlung ob der Benutzer in der uebergebenen Liste von Rollen ist
    userid: zu pruefende Userid
    listRolleId: String mit einer durch ':' getrennten Liste von rolleIDs */
function fIsUserInRolle(userid NUMBER default fGetUSerId, listRolleId VARCHAR2) return NUMBER;

-- Prüft ob der uebergebene Text eine Uri ist und gibt einen HTML-Link zurück, 
-- wenn der Text eine Uri ist
function fCreateLinkIfUrl(aTextListUrls VARCHAR2, aMaxTitleLength in number default 20) return VARCHAR2;

-- Loescht eine Vorschrift mit allen Referenzen und Historie
FUNCTION fDeleteVorschrift(aVorschriftId NUMBER) return BOOLEAN;

-- Wandelt eine Liste von Ticketnummern in eine Liste von Links um
function fJiraTicketsToLinks(ticketList VARCHAR2) return VARCHAR2;

-- Erstellt einen Platzhalter-Benutzer für die Übergabe von Suchergebnissen
function fCreatePlaceHolderUser(aSearchGid in varchar2 default OWA_UTIL.GET_CGI_ENV('HTTP_GID')) return number;

-- Prüft, ob ein Eintrag in T_BENUTZER für den Anwender erstellbar ist
function fUserIsCreatable return number;

-- Wandelt String in Datum um (entweder mm/dd/yyyy oder dd.mm.yyyy)
function fMakeDate(aInput in varchar2) return date;

/* Ändert bestimmte Eigenschaften von Vorschriften
   aListVorschriftId: Durch ':' getrennte Liste von Vorschriften-IDs, 
        bearbeitet werden sollen
        aBezeichnung, aBemerkung, aFreigabeStatusId, aVorschriftStatus,
        aHomologation, aRxsWin: Neuer Wert der jeweiligen
        Spalte; null = alten Wert behalten
*/
function fChangeVorschriftenAttribut(aListVorschriftId VARCHAR2, aBezeichnung VARCHAR2, 
        aBemerkung VARCHAR2, aFreigabeStatusId NUMBER, aEinsatzdatumModellId NUMBER,
        aPrognoseQualitaet NUMBER, aHomologation NUMBER, aVorschriftStatus NUMBER, 
        aRxsWin NUMBER) return BOOLEAN;

/* Ändert die Zuordnung der Fahrzeugklassen von Vorschriften
   aListVorschriftId: Durch ':' getrennte Liste von Vorschriften-IDs, 
        bearbeitet werden sollen
   aListFahrzeugklasse: Durch ':' getrennte Liste von Fahrzeugklassen-IDs, 
        die gesetzt werden sollen;
        null = alten Wert behalten
*/
function fChangeVorschriftenAttributFahrzeugklasse(aListVorschriftId VARCHAR2, aListFahrzeugklasse VARCHAR2)
return boolean;

/* Ändert bestimmte Links von Vorschriften, *wenn diese noch nicht gesetzt sind*
   aListVorschriftId: Durch ':' getrennte Liste von Vorschriften-IDs, 
        bearbeitet werden sollen
    aLinkGetex, aLinkDms, aWebsiteId, aLinkWebsite: Neuer Wert der jeweiligen
        Spalte; null = alten Wert behalten
*/
function fChangeVorschriftenLinks(aListVorschriftId VARCHAR2, aLinkGetex VARCHAR2, 
        aLinkDms VARCHAR2, aWebsiteId NUMBER, aLinkWebsite VARCHAR2) return BOOLEAN;

/* Kopiert de Zuordnungen zu den Themengebieten von einem Quellland 
    auf ein Zielland für die ausgewählten Vorschriften.

   aListVorschriftId: Durch ':' getrennte Liste von Vorschriften-IDs, 
        bearbeitet werden sollen
    aSourceLandId: Quell-Land
    aListTargetLandId: Durch ':' getrennte List von Ziel-Land-IDs
*/
function fCopyVorschriftenThemenByLand(aListVorschriftId VARCHAR2, 
        aSourceLandId NUMBER, aListTargetLandId VARCHAR2) return BOOLEAN;

/* Kopiert de Zuordnungen zu den Laendern von einem Quell-Themengebiet 
    auf ein Ziel-Themengebiet für die ausgewählten Vorschriften.

   aListVorschriftId: Durch ':' getrennte Liste von Vorschriften-IDs, 
        bearbeitet werden sollen
    aSourceThemaId: Quell-Thema
    aTargetThemaId: Durch ':' getrennte Liste von Ziel-Thema-IDs
*/
function fCopyVorschriftenLaenderByThema(aListVorschriftId VARCHAR2, 
        aSourceThemaId NUMBER, aListTargetThemaId VARCHAR2) return BOOLEAN;

function fGetLinks(aVorschriftID in number) return apex_t_number;

/* Ändert bestimmte Eigenschaften von Vorschriften
    aListVorschriftId: Durch ':' getrennte Liste von Vorschriften-IDs, 
        bearbeitet werden sollen
    aAttribut: Numerische Repräsentation der Tabellenspalte
        Vorschriftennummer=10, Titel (Überschrift)=20, Bemerkung zur Vorschrift=30,
        Link zu DMS=40, Link zu GETEX=50, Link zu Web Site=60
    aPlainRegexReplae: Suchen und Erserten via Wortersetzung (0 = plain) oder 
        Regulärem Ausdruck (1)
    aSearchText: Text der gesucht und ersetzt werden soll
    aReplaceText: Text der den alten Text ersetzen soll
*/
function fSearchAndReplaceVorschriftenAttribut(aListVorschriftId VARCHAR2, aAttribut NUMBER, 
        aPlainRegexReplace NUMBER, aSearchText VARCHAR2, aReplaceText VARCHAR2) return NUMBER;


/* Erstellt eine URL zum erstellen eines Jira-Tickets basierend auf
   der übergebenen Vorschrift

   aVorschriftId: PK der Vorschrift
   return: der erstellte JIRA-Link
*/ 
function fCreateJiraUrl(aVorschriftId NUMBER) return VARCHAR2;

/* Erstellt einen Link zur externen Verlinkung der Vorschrift

    aVorschriftId PK der Vorschrift
    return: der erstellte Permalink
*/

function fCreateJiraUrlAssistent(aVorschriftId NUMBER, aMFV_TEILID NUMBER,aAKIDS VARCHAR2 default null,aSchlagwörter VARCHAR2 default null,  aZusVorschriften  VARCHAR2 default null, aMFVID VARCHAR2 default null) return clob;


function fCreatePermalinkUrl(aVorschriftId NUMBER) return VARCHAR2;


/* Loescht eine MfV mit allen Referenzen und Historie
    aMfvId: ID der MfV
    return: true bei Erfolg
*/
FUNCTION fDeleteMfv(aMfvId NUMBER) return BOOLEAN;

/*Erweitert die übergeben Themenliste um die Kinder der Themen */
function  fgetFullTHemenListe(aThemenliste varchar2) return varchar2;

/*
* set status of previous version of MFV (if any exist) to 30 
* eg.  for aMfvname = 'E01 00013 101 V03' the DMS_Documentenstatus of
*  'E01 00013 101 V02', 'E01 00013 101 V01' will be set to 30
*/
procedure pUpdateDocumentStatus(aMfvname in varchar2);

/* prüfft ob Benutzer is in Redaktionsteam
    auserid: ID der Benutzer
    return: 1 wenn in Redaktionsteam, sonst 0
*/
function fisInRedaktionsteam( auserid number) return number;

 /* sucht gemeinsame VKO-Benutzerids welche der liste der Vorschriften mit ids
   in ':'-separated aVorschriftenIds zugewiesen sind. 
   return   ':'-separated ids von  VKO-Benutzerids, die für alle Vorschriften
   aus der liste gelten.
 */
function fgetCommonVKOUserIds(avorschriftenids varchar2) return varchar2;

/* fügt den Vorschriften aus der liste avorschriftids
  die Länder aus der liste  alaenderids  hinzu
*/
function fAddLaenderToVorschriften(avorschriftids varchar2, alaenderids varchar2) return boolean;
/*
*/
function fAddThemenToVorschriften(avorschriftids varchar2, aThemenids varchar2) return boolean;

/**
*/

PROCEDURE proc_equivalent_vorschrift_thema(aVorschriftID in number);

/**
*/
-- JOB
PROCEDURE PREFRESH_MV_FREE_VKO_REPORT;

END PCK_RI;
```


-- BODY


```
create or replace PACKAGE BODY                      "PCK_RI" AS
 
  g_jira_base_url CONSTANT VARCHAR2(60 CHAR) := 'https://cicd.cloud.audi/jira/browse/';
 
 
    /* Setzt alle vernetzten Informationen für eine Vorschrift zurück */
    procedure pResetVI(aVorschriftID in number) is
    begin
        pResetAK(aVorschriftID);
        pResetAA(aVorschriftID);
        pResetFunktionen(aVorschriftID);        
    end pResetVI;
 
    /* Setzt die Arbeitskreise für eine Vorschrift zurück */
    procedure pResetAK(aVorschriftID in number) is
    begin
 
        update t_vorschrift_ref_et_b_ak
        set geloescht = 1, letzte_aenderung_datum = sysdate, letzte_aenderung_benutzerid = fGetUserId
        where vorschriftid = aVorschriftID 
        and et_b_akid not in (
            select distinct et_b_akid
            from t_vorschrift_ref_thema vrt
            join t_thema_ref_et_b_ak ref on (vrt.themaid = ref.themaid)
            where vorschriftid = aVorschriftID and geloescht = 0
        );            
 
        update t_vorschrift_ref_et_b_ak
        set geloescht = 0, letzte_aenderung_datum = sysdate, letzte_aenderung_benutzerid = fGetUserId
        where vorschriftid = aVorschriftID
        and et_b_akid in (
            select distinct et_b_akid
            from t_vorschrift_ref_thema vrt
            join t_thema_ref_et_b_ak ref on (vrt.themaid = ref.themaid)
            where vorschriftid = aVorschriftID and geloescht = 0
        );
 
        insert into t_vorschrift_ref_et_b_ak (
            vorschriftid, et_b_akid, letzte_aenderung_benutzerid, letzte_aenderung_datum
        )
        with cte1 as (
            select distinct et_b_akid
            from t_vorschrift_ref_thema vrt
            join t_thema_ref_et_b_ak ref on (vrt.themaid = ref.themaid)
            where vorschriftid = aVorschriftID and geloescht = 0
        )
        select aVorschriftID, et_b_akid, fGetUserId, sysdate
        from cte1
        where et_b_akid not in (
            select et_b_akid
            from t_vorschrift_ref_et_b_ak
            where vorschriftid = aVorschriftID
        );
 
    end pResetAK;
 
    /* Setzt die Antriebsarten für eine Vorschrift zurück */
    procedure pResetAA(aVorschriftID in number) is
     l_co number :=0;
     l_aa_co number :=0;
     l_insert_co number :=0;
    begin
        -- prüfe Änderungen in Getex-relevantem Attribut AntriebsArt
        select count(*) into l_co from t_vorschrift_ref_antriebsart
        where vorschriftid = aVorschriftID;
 
        select count(distinct antriebsartid) into l_aa_co
            from t_vorschrift_ref_thema vrt
            join t_thema_ref_antriebsart ref on (vrt.themaid = ref.themaid)
            where vorschriftid = aVorschriftID and vrt.geloescht = 0;
        --
        update t_vorschrift_ref_antriebsart
        set geloescht = 0, letzte_aenderung_datum = sysdate, letzte_aenderung_benutzerid = fGetUserId
        where vorschriftid = aVorschriftID
        and antriebsartid in (
            select distinct antriebsartid
            from t_vorschrift_ref_thema vrt
            join t_thema_ref_antriebsart ref on (vrt.themaid = ref.themaid)
            where vorschriftid = aVorschriftID and geloescht = 0
        );
 
        with cte1 as (
            select distinct antriebsartid
            from t_vorschrift_ref_thema vrt
            join t_thema_ref_antriebsart ref on (vrt.themaid = ref.themaid)
            where vorschriftid = aVorschriftID and geloescht = 0
        )
        select  count(antriebsartid) into l_insert_co
        from cte1
        where antriebsartid not in (
            select antriebsartid
            from t_vorschrift_ref_antriebsart
            where vorschriftid = aVorschriftID
        );
 
        insert into t_vorschrift_ref_antriebsart (
            vorschriftid, antriebsartid, letzte_aenderung_benutzerid, letzte_aenderung_datum
        )
        with cte1 as (
            select distinct antriebsartid
            from t_vorschrift_ref_thema vrt
            join t_thema_ref_antriebsart ref on (vrt.themaid = ref.themaid)
            where vorschriftid = aVorschriftID and geloescht = 0
        )
        select aVorschriftID, antriebsartid, fGetUserId, sysdate
        from cte1
        where antriebsartid not in (
            select antriebsartid
            from t_vorschrift_ref_antriebsart
            where vorschriftid = aVorschriftID
        );
 
         if( (l_co >0 and l_aa_co >0) or l_insert_co >0 ) then
          update t_vorschrift set letzte_aenderung_getex_attr =sysdate  where vorschriftid = aVorschriftID;
        end if;
    end pResetAA;
 
    /* Setzt die FUKA-Funktionen für eine Vorschrift zurück */
    procedure pResetFunktionen(aVorschriftID in number) is
    begin
        /* zugeordnete Funktionen, die als gelöscht markiert waren, wiederherstellen, wenn sie zum
           Standardprogramm der zugeordneten Themen gehören */
        update t_vorschrift_ref_funktion
        set geloescht = 0, letzte_aenderung_datum = sysdate, letzte_aenderung_benutzerid = fGetUserId
        where vorschriftid = aVorschriftID
        and geloescht = 1
        and funktionid in (
            select distinct funktionid
            from t_vorschrift_ref_thema vrt
            join t_thema_ref_funktion ref on (vrt.themaid = ref.themaid)
            where vorschriftid = aVorschriftID and geloescht = 0
        );
 
        /* zugeordnete Funktionen als gelöscht markieren, wenn sie nicht zum Standardprogramm der
           zugeordneten Themen gehören 
           Änderung TsTh 18.01.: Zusätzlich zugeordnete Funktionen sollen nicht mehr als gelöscht markiert werden 
 
            update t_vorschrift_ref_funktion
            set geloescht = 1, letzte_aenderung_datum = sysdate, letzte_aenderung_benutzerid = fGetUserId
            where vorschriftid = aVorschriftID
            and geloescht = 0
            and funktionid not in (
                select distinct funktionid
                from t_vorschrift_ref_thema_ref_land vrt
                join t_thema_ref_funktion ref on (vrt.themaid = ref.themaid)
                where vorschriftid = aVorschriftID and geloescht = 0
            );   
 
        */
 
        /* Funktionen aus dem Standardprogramm der Themen zuordnen, wenn noch nicht da */
        insert into t_vorschrift_ref_funktion (
            vorschriftid, funktionid, letzte_aenderung_benutzerid, letzte_aenderung_datum
        )
        with cte1 as (
            select distinct funktionid
            from t_vorschrift_ref_thema vrt
            join t_thema_ref_funktion ref on (vrt.themaid = ref.themaid)
            where vorschriftid = aVorschriftID and geloescht = 0
        )
        select aVorschriftID, funktionid, fGetUserId, sysdate
        from cte1
        where funktionid not in (
            select funktionid
            from t_vorschrift_ref_funktion
            where vorschriftid = aVorschriftID
        );
    end pResetFunktionen;
 
  function fSanitizeForTree(aText in varchar2) return varchar2 is
  begin    
      return trim(replace(replace(aText,chr(10)),chr(13)));
  end fSanitizeForTree;
 
  FUNCTION fGetUserId return NUMBER AS
  BEGIN
    RETURN V('G_BENUTZERID');
  END fGetUserId;
 
    function fGetLinks(aVorschriftID in number) return apex_t_number is
        lReturnList apex_t_number;   
 
    begin
        with cte1 as (
            select vrv.nachfolger_vorschriftid vorschriftid
            from t_vorschrift_ref_vorschrift vrv
            where vrv.vorgaenger_vorschriftid = aVorschriftID
            union
            select vrv.vorgaenger_vorschriftid
            from t_vorschrift_ref_vorschrift vrv
            where vrv.nachfolger_vorschriftid = aVorschriftID
        )
        select vorschriftid
        bulk collect into lReturnList
        from cte1;
        return lReturnList;
 
 
    end fGetLinks;
 
    FUNCTION fIsAuthorized01(userId NUMBER default fGetUserId, pageId NUMBER, accessMode NUMBER) return number
    is begin
        if (fIsAuthorized(userid, pageid, accessmode)) then
            return 1;
        else
            return 0;
        end if;
 
    end fIsAuthorized01;
 
    /* Liefert 1 zurück, wenn es sich um einen anonymen oder deaktivierten User handelt
       --> nur freigegebene Vorschriften sichtbar */
    function fIsLimitedUser(userId number default fGetUserId) return number is
        lUserStatus number;
        lGruppenAusserSuche number;
    begin
 
        if (userID is null) then
            return 1;
        else
            select status into lUserStatus
            from t_benutzer
            where benutzerid = userId;
 
            select count(*) into lGruppenAusserSuche
            from t_benutzer_ref_rolle
            where benutzerid = userid and rolleid  not in ( 1004, 1005);
 
            if (lUserStatus = 20 or lGruppenAusserSuche = 0) then
                return 1;
            end if;
        end if;
 
        return 0;
 
 
 
    end fIsLimitedUser;
 
 
 
 
 
 
  -- Ermittlung ob der Benutzer auf die Seite lesend oder schreibend zugreifen darf
  -- accessMode: 100 lesend, 200 schreibend, 300 Admin only
  FUNCTION fIsAuthorized(userId NUMBER default fGetUserId, pageId NUMBER, accessMode NUMBER) return BOOLEAN IS
    lResult NUMBER;
    lIsAdmin NUMBER;
  BEGIN
    lResult := 0;
    lIsAdmin := 0;
    -- Shortcut für Mynet User ohne eigenen Account, deaktivierte Accounts
    -- bzw. Seiten, die jeder immer aufrufen darf
    IF accessMode = 100  
            and pageId in (0, 1,2,  5, 9,20, 21, 23, 25, 28, 30, 35, 50,55, 65, 70, 
            130, 136, 200, 202, 210, 251, 
            300, 320, 322, 323, 325, 326, 327, 340, 341, 366, 367, 380, 390,
            400, 410, 440, 450, 452, 455, 457, 456, 457, 459,
            520,
            600,601,603,605,617, 630,
            2010) THEN
        return TRUE;
    END IF;
 
    -- Shortcut fuer Admin User: Immer alle Rechte
    /*select count(*) INTO lIsAdmin from T_BENUTZER b
    join T_BENUTZER_REF_ROLLE brr on brr.benutzerid = b.benutzerid
    where brr.benutzerid = userId 
      AND brr.rolleid = g_rolleid_admin 
      AND b.status = 10; -- 10: Benutzer aktiv
 
    IF lIsAdmin > 0 THEN
        return TRUE;
    END IF;*/
 
    -- Erstellt eine Tabelle access_rules mit Rollennamen (role_name), Benutzerrecht (userrigth)
    -- und den berechteten Seiten (page_id) 
    -- und selektiert daraus die Zeile(n) bei der Rolle, Seite und Benutzerrecht uebereinstimmen.
    with access_rules as (
      select 'Fachadmin' as role_name, 100 as userright, column_value as page_id from sys.odcinumberlist(
        0, 1, 10, 15, 16, 20, 21,23, 25, 26, 27, 28, 29, 30, 35, 45, 60, 65, 70, 75, 80, 85, 90, 95, 96, 
        100, 103, 104, 110, 115, 120, 125, 130, 135, 136, 140, 150, 155, 160, 165, 166, 170, 180, 185, 190, 195,
        200, 201, 202, 203, 210, 215, 225, 230, 250, 251, 255,
        300, 310, 320, 325, 326, 327, 328, 329, 330, 340, 341, 342, 343, 345, 346, 350, 351, 352, 353, 354, 355, 356, 357, 360, 365, 370, 375, 380, 385, 386, 387, 388, 390,
        400, 410, 415, 416, 430, 440, 450, 452, 453, 455, 456, 457, 458, 459, 470, 472, 474,
        510, 515, 520, 521, 530, 540, 541, 542, 543, 544, 545, 570, 571, 572, 573, 574, 575, 578, 590, 595,
         603, 610, 615, 617, 630, 640,645,
        700, 701,702,703, 705, 706, 710, 715, 720, 725, 730, 735,
        800, 810,820,
        900, 905, 910, 915, 920, 925, 926, 927, 928, 929, 930, 935, 940, 945, 950, 955, 960, 970,
        1000, 1010, 1100,
        2000, 2005, 2020,
        2100
      )
      union all
      select 'Fachadmin' as role_name, 200 as userright, column_value as page_id from sys.odcinumberlist(
        0, 1, 10, 15, 16, 20, 21, 23, 25, 26, 28, 29, 30, 35, 45, 60, 65, 70, 75, 80, 85, 90, 95, 96, 
        100, 103, 104, 110, 115, 120, 125, 130, 135, 136, 140, 150, 155, 160, 165, 166, 170,180,185, 190, 195,
        200, 201, 202, 203, 210, 215, 225, 230, 250, 251, 255,
        300, 310, 320, 325, 326, 327, 328, 329, 330, 340, 341, 342, 343, 345, 346, 350, 351, 352, 353, 354, 355, 356, 357, 360, 365, 370, 375, 380, 385, 386, 387, 388,
        400, 410, 415, 416, 440, 450, 452, 453, 455, 456, 457, 458, 459, 470, 472, 474,
        510, 515, 520, 540, 541, 542, 543, 544, 545, 570, 571, 572, 573, 574, 575, 578, 590, 595,
        601, 603, 610, 615, 617, 630, 640, 645,
        700, 701, 702, 703, 705, 706, 710, 715, 720, 725, 730, 735,
        900, 905, 910, 915, 920, 925, 926, 927, 928, 929, 930, 935, 940, 945, 950, 955, 960, 970, 1010, 1100,
        2000, 2005, 2020
      )
      union all
      select 'Fachadmin' as role_name, 300 as userright, column_value as page_id from sys.odcinumberlist(
        0, 1, 10, 15, 16, 20, 21, 23, 25, 30, 35, 45, 65, 70, 75, 80, 85, 90, 95, 96, 
        100, 110, 115, 120, 125, 130, 135, 136, 140, 150, 155, 160, 165, 166, 170, 180, 185, 190, 195,
        200, 201, 202, 203, 210, 215, 225, 230, 250, 251, 255,
        300, 310, 320, 325, 326, 327, 328, 329, 330, 340, 341, 342, 343, 345, 346, 350, 351, 352, 353, 354, 355, 356, 357, 360, 365, 370, 375, 380, 385, 386, 387, 388,
        400, 410, 415, 416, 440,
        510, 515, 520, 540, 541, 542, 543, 544, 545, 570, 571, 572, 573, 574, 575, 578, 590, 595,
        610, 615, 630, 640, 645,
        900, 905, 910, 915, 920, 925, 926, 927, 928, 929, 930, 935, 940, 945, 950, 955, 960, 970
      )
      union all
      select 'User Admin' as role_name, 100 as userright, column_value as page_id from sys.odcinumberlist(
        0, 1, 20, 21 , 25, 30, 35, 50, 55, 60, 70, 130, 202, 329, 341, 380, 400, 410, 450, 455, 456, 458, 520
      )
      union all
      select 'User Admin' as role_name, 200 as userright, column_value as page_id from sys.odcinumberlist(
        0, 1, 30, 50, 55, 60, 390, 440, 450
      )
      union all
      select 'User Admin' as role_name, 300 as userright, column_value as page_id from sys.odcinumberlist(
        0, 1, 50, 55
      )
 
       union all
      select 'RRE' as role_name, 100 as userright, column_value as page_id from sys.odcinumberlist(
        0, 1, 30, 35, 50,55, 70, --10, 20, 21, 25, 30, 70,
        130, 135,
        202, 
        341,--300, 320, 325, 326, 327, 387, 388, 340, 341, 343, 345, 380,385,
        400, 410, 415, 416, 450, 455, 456, 458, --440,
        510, 515, 520,
        900, 910, 920, 925, 926, 927, 928, 929, 930, 935, 940, 945, 950, 955,
        1000
      )
     union all
      select 'RRE' as role_name, 200 as userright, column_value as page_id from sys.odcinumberlist(
        30, 35, 50,55,
        130, 135, 
        --300, 320, 325, 326, 327, 387, 388, 340, 341, 343, 345, 380,385,
        450, 455, -- 410, 415, 416, 440,
        510, 515,
        910, 920, 925, 926, 927, 928, 929, 930, 935, 940, 950
      )
      union all
      select 'VEX' as role_name, 100 as userright, column_value as page_id from sys.odcinumberlist(
        0, 1, 10, 20, 21, 23,  25, 30, 35, 70, 
        130, 
        202,
        300, 320, 325, 326, 327, 329, 340, 341, 343, 345, 350, 351, 352, 353, 354, 355, 356, 357, 380, 385, 387, 388, 390,
        410, 415, 416, 440, 450, 455, 456, 458, 470, 472, 474,
        510, 520, 590,
        920, 960
      ) 
      union all
      select 'VEX' as role_name, 200 as userright, column_value as page_id from sys.odcinumberlist(
        30, 
        320, 325, 326, 327, 340, 341, 343, 345, 380, 385, 387, 388,
        410, 415, 416, 440, 450, 456, 458, 470, 472, 474
      )
      union all
      select 'ZVEX' as role_name, 100 as userright, column_value as page_id from sys.odcinumberlist(
        0, 1, 10, 20, 21, 25, 30, 35, 70, 
        130, 
        300, 320, 325, 326, 327, 329, 340, 341, 343, 345, 380, 387, 388, 390,
        400, 410, 415, 416, 440, 450, 455, 456, 458, 470, 472, 474,
        510, 520, 590,
        920, 960 --, 925, 926
      )
      union all
      select 'ZVEX' as role_name, 200 as userright, column_value as page_id from sys.odcinumberlist(
        30, 320, 325, 326, 327, 340, 341, 343, 345, 450, 470, 472, 474,
        410, 415, 416
      )
      union all
      select 'VKO' as role_name, 100 as userright, column_value as page_id from sys.odcinumberlist(
        0, 1, 10, 20, 21, 23, 25, 26, 28, 29, 30, 35, 45, 70, 75, 85, 100, 
        103, 104, 130, 140, 160, 165, 166, 190, 195, 
        200, 202, 203, 210, 215, 225, 250, 251, 255,
        300, 320, 325, 326, 327, 329, 350, 351, 352, 353, 354, 355, 356, 357, 380, 385, 386, 387, 388,
        410, 430, 440, 450, 455, 456, 458, 470, 472, 474,
        510, 515, 520, 540, 541, 542, 543, 544, 545, 570, 571, 572, 573, 574,575, 590,595,
        610, 615, 617, 630,
        800, 810, 820,
        920, 960, 2020 --, 925, 926
      ) 
      union all
      select 'VKO' as role_name, 200 as userright, column_value as page_id from sys.odcinumberlist(
        0, 1, 20, 21, 23, 25, 28, 30, 35, 45, 70, 75, 85, 100, 
        103, 104, 140, 160, 165, 166, 185,190, 195, 
        200, 202, 210, 215, 225, 250, 251, 255,
        300, 320, 325, 326, 327, 329,  380, 385, 386, 387, 388,
        440, 456, 458, 470, 472, 474,
        515, 520, 540, 541, 542, 543, 544, 545, 570, 571, 572, 573, 574,575, 590, 595,
        610, 615, 617
      ) 
      union all
      select 'FbEx' as role_name, 100 as userright, column_value as page_id from sys.odcinumberlist(
        20, 21, 25, 30, 35, 70, 
        130, 329, 341, 343, 345, 380, 387, 388, 390, 
        400, 410, 440, 450, 455, 456, 458, 470,
        510, 520,
        920, 960 --, 925, 926
      )
      union all
      select 'FbEx' as role_name, 200 as userright, column_value as page_id from sys.odcinumberlist(
        30, 343, 345, 380, 450, 470
      )
      union all
      select 'KFEx' as role_name, 100 as userright, column_value as page_id from sys.odcinumberlist(
       30, 35, 70, 
       130, 
       202, 
       329, 341, 380, 387, 388, 390, 
       400, 410, 440, 450, 455, 456, 458,
       510,  520,
       920, 960 --, 925, 926
      )
      union all
      select 'KFEx' as role_name, 200 as userright, column_value as page_id from sys.odcinumberlist(
       30, 
       450
      )
      union all
      select 'RRE' as role_name, 100 as userright, column_value as page_id from sys.odcinumberlist(
       900, 905, 910, 915, 920, 925, 926, 927, 928, 929, 930, 935, 940, 945, 950, 955, 960, 970
      )
      union all
      select 'RRE' as role_name, 200 as userright, column_value as page_id from sys.odcinumberlist(
       900, 905, 910, 915, 920, 925, 926, 927, 928, 929, 930, 935, 940, 945, 950, 955, 960, 970
      )            
      union all
      select 'Getex Migration' as role_name, 100 as userright, column_value as page_id from sys.odcinumberlist(
        0, 1, 2, 5, 20, 21, 23, 25, 26, 28, 29, 30, 35, 65, 70,
        130, 136, 200, 202, 210, 215, 
        300, 320, 322, 323, 325, 326, 327, 340, 341, 366, 367,380, 390,
        400, 410, 440, 457, 456, 457, 459,
        520,
        600, 603, 605, 617, 630,
        2010
      )
 
    )
    Select count(*) into lResult from access_rules ar
    join T_ROLLE r on r.ROLLE = ar.role_name 
    join T_BENUTZER_REF_ROLLE brr on brr.rolleid = r.rolleid
    join T_BENUTZER b on b.benutzerid = brr.benutzerid
    where b.benutzerid = userId and ar.userright=accessMode and ar.page_id = pageId and b.status = 10;
 
    RETURN lResult > 0;
 
  END fIsAuthorized;
 
 
 
 
/* Ermittlung ob der Benutzer in der uebergebenen Liste von Rollen ist
    userid: zu pruefende Userid
    listRolleId: String mit einer durch ':' getrennten Liste von rolleIDs */
function fIsUserInRolle(userid NUMBER default fGetUSerId, listRolleId VARCHAR2) return NUMBER IS
    lResult NUMBER := 0;
BEGIN
 
    select count(*) INTO lResult
    FROM T_BENUTZER_REF_ROLLE brr
    WHERE brr.BENUTZERID  = userid
        AND brr.ROLLEID in (select column_value FROM TABlE(APEX_STRING.split_numbers(listRolleId, ':')));
 
    return lResult;
 
END fIsUserInRolle;
 
 
 
 
 
-- Prüft ob der uebergebene Text eine Uri ist und gibt einen HTML-Link zurück, 
-- wenn der Text eine Uri ist
function fCreateLinkIfUrl(aTextListUrls VARCHAR2, aMaxTitleLength in number default 20) return VARCHAR2 IS
  lResult VARCHAR2(4096 CHAR);
  --lRegex VARCHAR2(256 CHAR) := 'https?\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,12}' -- Domain, Topleveldomain
  --          ||'\b(-a-zA-Z0-9@:%_\+.~#?&//=]*)'; -- lokaler Teil
  lUrlTitle VARCHAR2(4096 CHAR);
  lUrlText VARCHAR(4096 CHAR);
BEGIN
 
  for rec_url in (
    select column_value url_value
    from TABLE(APEX_STRING.split(aTextListUrls, apex_application.CR || '?' || apex_application.LF))) -- LF ist default
  loop
    lUrlText := rec_url.url_value;
 
    IF length(lUrlText) > aMaxTitleLength THEN
        lUrlTitle := substr(lUrlText, 1, aMaxTitleLength - 1) || unistr('\2026'); -- 2026 = ...
    ELSE
        lUrlTitle := lUrlText;
    END IF; 
 
    if (lUrlText LIKE '%vwdmsweb.wob.vw.vwg/groupdms%' and lUrlText not like '%&commandEvent=D2_ACTION_CONTENT_VIEW') then 
        lurlText := lurlText || '&commandEvent=D2_ACTION_CONTENT_VIEW';
    end if;        
 
    CASE 
        WHEN lUrlText is NULL THEN
          lResult := lResult;
        --WHEN regexp_like(lUrlText, '^https\:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,12}([-a-zA-Z0-9@:%_\+.~#?&\/=]*)$') THEN
        WHEN regexp_like(lUrlText, '^http[s]{0,1}\:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,12}([-a-zA-Z0-9@:%_\+.~#?&\/=;]*)$') THEN
 
          lResult := lResult || apex_string.format('<a href="%s" target="_blank" title="%s">%s</a>',
                lUrlText,
                APEX_ESCAPE.HTML(lUrlTEXT),
                APEX_ESCAPE.HTML(lUrlTitle)
            ) || apex_application.LF;
        ELSE
          lResult := lResult || '<span title="' || APEX_ESCAPE.HTML(lUrlText) || '">' || APEX_ESCAPE.HTML(lUrlTitle) || '</span>' || apex_application.LF ;
      END CASE;
 
  end loop;
 
  return lResult;
 
END fCreateLinkIfUrl;
 
 
  function fCreateJiraUrl(aVorschriftId NUMBER) return VARCHAR2 as
      l_vs_nummer varchar2(4096);
      l_vs_bezeichnung varchar2(4096);
      l_vs_status varchar2(4096);
      l_vs_typid number;
      l_progn_quali varchar2(4096);
      l_datum_in_kraft varchar2(4096);
      l_datum_neuer_typ varchar2(4096);
      l_datum_alle_typen varchar2(4096);
      l_laender_fields varchar2(4096);
      l_ak_fields varchar2(4096);
      l_mfv varchar(4096);
    begin
 
    select v.vorschrift_nummer, v.vorschrift_bezeichnung,
      s.status, v.VORSCHRIFT_TYPID
    into l_vs_nummer, l_vs_bezeichnung,
      l_vs_status, l_vs_typid
    from t_vorschrift v
    left outer join t_vorschrift_status s on s.VORSCHRIFT_STATUSID = v.VORSCHRIFT_STATUSID
    where v.vorschriftid = aVorschriftId;
 
    select case when v.prognose_qualitaet = 10 then 'sicher'
      when v.prognose_qualitaet = 20 then 'abschätzbar'
      else null
     end into l_progn_quali
    from T_VORSCHRIFT v
    where v.vorschriftid = aVorschriftId;
 
    select to_char(einsatzdatum, 'DD.MM.YYYY') into l_datum_in_kraft
    from t_vorschrift_ref_einsatzdatum_typ vre
    where vre.vorschriftid = aVorschriftId
        and vre.einsatzdatum_typid = 1000
    union all select null from dual
    fetch first 1 rows only;
 
    select listagg(case 
        when vre.einsatzdatum_typid = 1020 then 'CKD ' 
        when vre.einsatzdatum_typid = 1022 then 'FBU ' 
        else null
        end
        || to_char(einsatzdatum, 'DD.MM.YYYY'), ' ') within group (order by vre.einsatzdatum_typid) into l_datum_neuer_typ
    from t_vorschrift_ref_einsatzdatum_typ vre
    inner join t_vorschrift vs on (vs.vorschriftid = vre.vorschriftid)
    inner join t_einsatzdatum_typ edt on (edt.einsatzdatum_modellid = vs.einsatzdatum_modellid and vre.einsatzdatum_typid = edt.einsatzdatum_typid)
    where vre.vorschriftid = aVorschriftId
        and vre.einsatzdatum_typid in (1010, 1020, 1022, 1030)
    group by vs.vorschriftid
    union all select null from dual
    fetch first 1 rows only;
 
    select listagg(case 
        when vre.einsatzdatum_typid = 1021 then 'CKD ' 
        when vre.einsatzdatum_typid = 1023 then 'FBU ' 
        else null
        end
        || to_char(einsatzdatum, 'DD.MM.YYYY'), ' ') within group (order by vre.einsatzdatum_typid) into l_datum_alle_typen
    from t_vorschrift_ref_einsatzdatum_typ vre
    inner join t_vorschrift vs on (vs.vorschriftid = vre.vorschriftid)
    inner join t_einsatzdatum_typ edt on (edt.einsatzdatum_modellid = vs.einsatzdatum_modellid and vre.einsatzdatum_typid = edt.einsatzdatum_typid)
    where vre.vorschriftid = aVorschriftId
        and vre.einsatzdatum_typid in (1011, 1021, 1023, 1031)
    group by vs.vorschriftid
    union all select null from dual
    fetch first 1 rows only;
 
    --mfv
    with mapped_mfvs as (
        select m.mfv_name
        from t_mfv_ref_vorschrift mrv
        join t_mfv m on m.mfvid = mrv.mfvid
        where mrv.vorschriftid = aVorschriftId
     )
    select nvl2(listagg(mfv_name, '/'), listagg(mfv_name, '/') || ' ', '') into l_mfv
    from mapped_mfvs;
 
    with land_jira_codes as (
     select distinct land.jira_code
     from T_VORSCHRIFT_REF_THEMA_REF_LAND vtl 
     left outer join t_land land on land.landid = vtl.landid
     where vtl.vorschriftid = aVorschriftId 
      and vtl.geloescht = 0
      and land.jira_code is not null
    )
    select listagg('&customfield_16507=' || land_jira_codes.jira_code, '') into l_laender_fields
    from land_jira_codes;
 
    if l_vs_nummer like 'UN-R%'  or l_vs_typid = 20 then -- UN-R-Vorschrift oder Supplement
    l_laender_fields := l_laender_fields || '&customfield_16507=36764';
    end if;
 
    with ak_jira_codes as ( -- AK-Kurzebez. muessen noch in Jira-IDs umgewandelt werden
     select distinct t.ET_B_AK_KURZ
     from T_VORSCHRIFT_REF_THEMA_REF_LAND vtl 
     left outer join t_thema t on t.themaid = vtl.themaid
     where vtl.vorschriftid = aVorschriftId 
      and vtl.geloescht = 0
      and t.ET_B_AK_KURZ is not null
    )
    select listagg('&components=' || ak_jira_codes.ET_B_AK_KURZ, '') into l_ak_fields
    from ak_jira_codes;
 
 
    return 'https://cicd.cloud.audi/jira/secure/CreateIssueDetails!init.jspa?pid=24805&issuetype=3&priority=4' ||
    --'&components=44408' || -- Komponente Testticket (44408), weitere l_ak_fields
    '&summary=MfV '|| apex_util.url_encode(l_mfv || l_vs_nummer || ' ' || l_vs_bezeichnung) ||
    '&customfield_18301=' || apex_util.url_encode(l_vs_nummer) ||
    l_laender_fields || 
    '&description=' || apex_util.url_encode('\\Achtung! Das Feld Beschreibung (text) ist ausschließlich für Reg Index DB Informationen reserviert \\ ' ||
     ' \\ *Hilfen*: \\' ||
     ' Anleitung für das MfV Ticket (Aufgabe): [https://portal.epp.audi.vwg/wiki/display/ETW/Anleitung+zum+Thema+MfV+Teil+x+Vorgang] \\' ||
     ' \\ *Informationen:*\\' ||
     '  Lange Bezeichnung der Vorschrift:\\' ||
     ' ' || l_vs_bezeichnung || '\\' ||
     ' \\ Permalink: \\' ||
     ' [' || pck_ri.fCreatePermalinkUrl(aVorschriftId) || '] \\' ||
     ' \\ *Einleitende Informationen vom VKO:* \\' ||
     '  hier steht ihre Einleitung' ||
     ' \\ Quellenangabe: Quelle der Information (z.B. Importeur, Datenbank Abos, Newsletter, K-VKO), z.B. Importeur \\' || 
     '  Getex Link zur Vorschrift order Getex ID:\\ \\' ||
     '  Zusätzliche Links (Optional falls in Getex nicht vorhanden): \\ \\' ||
     ' \\ *Status der Vorschrift:* ' ||
     ' \\ +aus APEX+ ' || l_vs_status || '\\' ||
     '  Inkrafttreten der Vorschrift:' ||
     ' \\  +aus APEX+ ' || l_datum_in_kraft || '\\' ||
     '  Einsatzdatum für neuen Typ:' ||
     ' \\ +aus APEX+ ' || l_datum_neuer_typ || '\\' ||
     '  Einsatzdatum für allen Typen:' ||
     ' \\ +aus APEX+ ' || l_datum_alle_typen || '\\ ') ||
    '&customfield_17402=' || apex_util.url_encode('Scope Inhalt Details:') ||
    '&customfield_16509=' || apex_util.url_encode('Link zu MfV Power Point:\\ \\' ||
     'Links zu AK Protokollen:\\ \\' ||
     'Links zu ET-B Forum Protokoll:\\ \\' ||
     'Links zum SKFV Protokoll:') ||
    '&issueTemplateId=3137&customfield_18411=' || apex_util.url_encode(pck_ri.fCreatePermalinkUrl(aVorschriftId)) --||
 
     ;
 
end fCreateJiraUrl;
 
-- Wandelt eine Liste von Ticketnummern in eine Liste von Links um
function fJiraTicketsToLinks(ticketList VARCHAR2) return VARCHAR2 IS
  lResult VARCHAR2(4096 CHAR);
BEGIN
    lResult := REGEXP_REPLACE(ticketList, '([a-zA-Z0-9\-]*)\s*', '<a href="' || g_jira_base_url || '\1" target="_blank">\1</a> ');
  return lResult;
END fJiraTicketsToLinks;
 
 
function fCreatePermalinkUrl(aVorschriftId NUMBER) return varchar2 IS
BEGIN
 
    return apex_util.host_url('SCRIPT') || 'f?p='
        || V('APP_ALIAS') -- App
        || ':VORSCHRIFT'  -- Page
        || ':' -- Session
        || ':' -- Request
        || ':' -- Debug
        || ':25' -- Clear Cache
        || ':P25_VORSCHRIFTID' -- Items
        || ':' || aVorschriftId -- Values
        ;
 
    /* apex_page.get_url verziert die URL mit JavaScript, wenn
        man sich in einem modalen Dialog befindet, deshalb ist die
        Funktion hier unbrauchbar
    return apex_util.host_url('SCRIPT') || apex_page.get_url(
            p_application => V('APP_ALIAS')
            , p_page => 'VORSCHRIFT'
            , p_items => 'P25_VORSCHRIFTID'
            , p_values => aVorschriftId
            , p_session => null
            , p_clear_cache => '25'
        );*/
 
END fCreatePermalinkUrl;
 
-- Loescht eine Vorschrift mit allen Referenzen und Historie
FUNCTION fDeleteVorschrift(aVorschriftId NUMBER) return BOOLEAN IS
  lResult boolean;
  BEGIN
    DELETE FROM T_H_MFV_REF_VORSCHRIFT WHERE VORSCHRIFTID = aVorschriftId;
    DELETE FROM T_MFV_REF_VORSCHRIFT WHERE VORSCHRIFTID = aVorschriftId;    
    DELETE FROM T_VORSCHRIFT_REF_ET_B_AK where vorschriftid = aVorschriftId;
    DELETE FROM T_VORSCHRIFT_REF_ANTRIEBSART where vorschriftid = aVorschriftId;
    DELETE FROM T_VORSCHRIFT_REF_FUNKTION where vorschriftid = aVorschriftId;
 
    DELETE FROM T_VORSCHRIFT_REF_SCHLAGWORT where vorschriftid = aVorschriftId;
    DELETE FROM T_BENACHRICHTIGUNG_KOMMENTAR where benachrichtigungid in (select benachrichtigungid from t_benachrichtigung where vorschriftid = aVorschriftId);    
    DELETE FROM T_BENACHRICHTIGUNG where vorschriftid = aVorschriftId; 
 
    DELETE FROM T_H_VORSCHRIFT_REF_FAHRZEUGKLASSE where vorschriftid = aVorschriftId;
    DELETE FROM T_VORSCHRIFT_REF_FAHRZEUGKLASSE where vorschriftid = aVorschriftId;
 
    -- loesche Supplements/Amendments, die als Vorgaenger-Vorschrift eingetragen sind 
    FOR r_vv IN (
        select vrv.vorgaenger_vorschriftid as supplement_vorschriftid
        from t_vorschrift_ref_vorschrift vrv
        join t_vorschrift vv on vv.vorschriftid = vrv.vorgaenger_vorschriftid and vrv.beziehung_art in (20, 30) 
        where (vrv.nachfolger_vorschriftid = aVorschriftId and vv.vorschrift_typid = 20)
        )
    LOOP
        lResult := fDeleteVorschrift(r_vv.supplement_vorschriftid);
    END LOOP;
 
    -- loesche Supplements/Amendments, die als Nachfolger-Vorschrift eingetragen sind 
    for r_nv in (
        select vrv.nachfolger_vorschriftid as supplement_vorschriftid
        from t_vorschrift_ref_vorschrift vrv
        join t_vorschrift nv on nv.vorschriftid = vrv.nachfolger_vorschriftid and vrv.beziehung_art in (20, 30) 
        where (vrv.vorgaenger_vorschriftid = aVorschriftId and nv.vorschrift_typid = 20)
        )
    LOOP
        lResult := fDeleteVorschrift(r_nv.supplement_vorschriftid);
    END LOOP;
 
    -- loesche alle Verknuepfungen der Vorschrift und deren Historie
    DELETE FROM T_H_VORSCHRIFT_REF_VORSCHRIFT 
    WHERE VORGAENGER_VORSCHRIFTID = aVorschriftId
        OR NACHFOLGER_VORSCHRIFTID = aVorschriftId;
    DELETE FROM T_VORSCHRIFT_REF_VORSCHRIFT 
    WHERE VORGAENGER_VORSCHRIFTID = aVorschriftId
        OR NACHFOLGER_VORSCHRIFTID = aVorschriftId;
 
    -- loesche alle verlinkte Normen und deren Historie
    DELETE FROM T_H_VERLINKTE_NORM
    WHERE VORSCHRIFTID = aVorschriftId;
    DELETE FROM T_VERLINKTE_NORM
    WHERE VORSCHRIFTID = aVorschriftId;
 
    DELETE FROM T_H_VORSCHRIFT_REF_THEMA WHERE VORSCHRIFTID = aVorschriftId;
    DELETE FROM T_VORSCHRIFT_REF_THEMA WHERE VORSCHRIFTID = aVorschriftId;
 
    delete from t_h_vorschrift_ref_land where vorschriftid = aVorschriftID;
    delete from t_vorschrift_ref_land where vorschriftid = aVorschriftid;
 
    delete from t_h_vorschrift_ref_thema_ref_land where vorschriftid = aVorschriftid;
    delete from t_vorschrift_Ref_thema_ref_land where vorschriftid = aVorschriftid;
 
    DELETE FROM T_VORSCHRIFT_REF_EINSATZDATUM_TYP WHERE VORSCHRIFTID = aVorschriftId;
 
    DELETE FROM T_H_VORSCHRIFT WHERE VORSCHRIFTID = aVorschriftId;
    DELETE FROM T_VORSCHRIFT WHERE VORSCHRIFTID = aVorschriftId;
 
    lResult := true;
 
    return lResult;
END fDeleteVorschrift;
 
/* Loescht eine MfV mit allen Referenzen und Historie
    aMfvId: ID der MfV
    return: true bei Erfolg
*/
FUNCTION fDeleteMfv(aMfvId NUMBER) return BOOLEAN IS
  BEGIN
 
    DELETE FROM T_MFV_REF_ET_B_AK WHERE MFVID = aMfvId;
    DELETE FROM T_MFV_REF_MFV_TEIL WHERE MFVID = aMfvId;
    DELETE FROM T_H_MFV_REF_VORSCHRIFT WHERE MFVID = aMfvId;
    DELETE FROM T_MFV_REF_VORSCHRIFT WHERE MFVID = aMfvId;
 
    DELETE FROM T_H_MFV WHERE MFVID = aMfvId;
    DELETE FROM T_MFV WHERE MFVID = aMfvId;
 
  return true;
END fDeleteMfV;
 
function fUserIsCreatable return number is
 
begin
    if (v('G_BENUTZERID') is not null) then
        return 10;
    else
        apex_util.set_session_state('G_BENUTZERID',fCreatePlaceHolderUser());
        return 10;
    end if;
exception
    when no_data_found then
        return 20;
 
 
end fUserIsCreatable;
 
-- Erstellt einen Platzhalter-Benutzer für die Übergabe von Suchergebnissen
function fCreatePlaceHolderUser(aSearchGid in varchar2 default OWA_UTIL.GET_CGI_ENV('HTTP_GID')) return number is
    pragma autonomous_transaction;
    lBenutzerID number;
    lBenutzerGefunden number;
    lBenutzerDaten t_ldap_table;
begin
    select count(*) into lBenutzerGefunden
    from t_benutzer
    where gid = aSearchGid;
 
    if (lBenutzerGefunden > 0) then
        select benutzerid into lBenutzerID
        from t_benutzer
        where gid = aSearchGid;
    else
        lBenutzerDaten := ldap_util.fLdapSearch(
            aSurname => null,
            aGid => aSearchGid
        );
 
        if (lBenutzerDaten.count = 0) then
            -- GID, die im LDAP nicht gefunden wurde
            insert into t_benutzer (
                nachname, vorname, abteilung,
                gid, telefon, email,
                letzte_aenderung_benutzerid, letzte_aenderung_datum
            ) values (
                aSearchGid, null, null,
                aSearchGid, null, null,
                fGetUserid, sysdate
            ) returning benutzerid into lBenutzerID;
        else 
            insert into t_benutzer (
                nachname, vorname, abteilung,
                gid, telefon, email,
                letzte_aenderung_benutzerid, letzte_aenderung_datum
            ) values (
                lBenutzerDaten(1).surname, lBenutzerDaten(1).givenname, lBenutzerDaten(1).subdepartment,
                aSearchGid, null, lBenutzerDaten(1).mail,
                fGetUserid, sysdate
            ) returning benutzerid into lBenutzerID;
        end if;
        -- comment it for   trennung Rollen von  VKo, VEX Register !!!
        /*insert into t_benutzer_ref_rolle (
            benutzerid, rolleid, letzte_aenderung_benutzerid,
            letzte_aenderung_datum
        ) values (
            -- Benutzer erhält Platzhalter-Rolle
            lBenutzerID, 1004, fGetUserid,
            sysdate 
        );
        */
        commit;
 
    end if;
    return lBenutzerID;
end fCreatePlaceHolderUser;
 
 
-- Wandelt String in Datum um (entweder mm/dd/yyyy oder dd.mm.yyyy)
function fMakeDate(aInput in varchar2) return date is
begin
    if (regexp_count(aInput,'/') = 2) then
        return to_date(trim(aInput),'mm/dd/yyyy');        
    elsif (regexp_count(aInput,'\.') = 2) then
        return to_date(trim(aInput),'dd.mm.yyyy');
    else
        return null;
    end if;
exception
    when others then
        return null;
 
 
end fMakeDate;
 
/* Ändert bestimmte Eigenschaften von Vorschriften
   aListVorschriftId: Durch ':' getrennte Liste von Vorschriften-IDs, 
        bearbeitet werden sollen
    aBezeichnung, aBemerkung, aFreigabeStatusId, aVorschriftStatus,
    aHomologation, aRxsWin: Neuer Wert der jeweiligen
        Spalte; null = alten Wert behalten
*/
function fChangeVorschriftenAttribut(aListVorschriftId VARCHAR2, aBezeichnung VARCHAR2, 
    aBemerkung VARCHAR2, aFreigabeStatusId NUMBER, aEinsatzdatumModellId NUMBER,
    aPrognoseQualitaet NUMBER, aHomologation NUMBER, aVorschriftStatus NUMBER, 
    aRxsWin NUMBER) return BOOLEAN AS
BEGIN
 
    if (aBezeichnung is not null) then
        update t_vorschrift set vorschrift_bezeichnung = aBezeichnung, revisionszaehler = revisionszaehler+1
        where vorschriftid in (select column_value from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
    end if;
 
    if (aBemerkung is not null) then
        update t_vorschrift set bemerkung = aBemerkung, revisionszaehler = revisionszaehler+1
        where vorschriftid in (select column_value from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
    end if;
 
    if (aFreigabeStatusId is not null) then
        update t_vorschrift set vorschrift_freigabestatusid = aFreigabeStatusId, revisionszaehler = revisionszaehler+1
        where vorschriftid in (select column_value from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
    end if;
 
    if (aEinsatzdatumModellId is not null) then
        update t_vorschrift set einsatzdatum_modellid = aEinsatzdatumModellId, revisionszaehler = revisionszaehler+1
        where vorschriftid in (select column_value from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
    end if;
 
    if (aPrognoseQualitaet is not null) then
        update t_vorschrift set prognose_qualitaet = aPrognoseQualitaet, revisionszaehler = revisionszaehler+1
        where vorschriftid in (select column_value from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
    end if;
 
    if (aHomologation is not null) then
        update t_vorschrift set homologationsrelevant = aHomologation, revisionszaehler = revisionszaehler+1
        where vorschriftid in (select column_value from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
    end if;
 
    if (aVorschriftStatus is not null) then
        update t_vorschrift set vorschrift_statusid = aVorschriftStatus, revisionszaehler = revisionszaehler+1
        where vorschriftid in (select column_value from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
    end if;
 
    if (aRxsWin is not null) then
        update t_vorschrift set rxswin = aRxsWin, revisionszaehler = revisionszaehler+1
        where vorschriftid in (select column_value from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
    end if;
 
 
    RETURN true;
END fChangeVorschriftenAttribut;
 
/* Ändert die Zuordnung der Fahrzeugklassen von Vorschriften
   aListVorschriftId: Durch ':' getrennte Liste von Vorschriften-IDs, 
        bearbeitet werden sollen
   aListFahrzeugklasse: Durch ':' getrennte Liste von Fahrzeugklassen-IDs, 
        die gesetzt werden sollen;
        null = alten Wert behalten
*/
function fChangeVorschriftenAttributFahrzeugklasse(aListVorschriftId VARCHAR2, aListFahrzeugklasse VARCHAR2)
return boolean as
begin
 
    if (aListFahrzeugklasse is not null) then
        for lVorschriftId in (select column_value from table(apex_string.split_numbers(aListVorschriftId, ':')))
        loop
            merge into T_VORSCHRIFT_REF_FAHRZEUGKLASSE dest
            using (select lVorschriftId.column_value as vorschriftid, column_value as fahrzeugklasseid
                from table(apex_string.split_numbers(aListFahrzeugklasse, ':'))) src
            on (src.vorschriftid = dest.vorschriftid 
                and src.fahrzeugklasseid = dest.fahrzeugklasseid)
            when not matched then insert (
                vorschriftid, 
                fahrzeugklasseid
            ) VALUES (
               src.vorschriftid,
               src.fahrzeugklasseid
            );
 
            delete from T_VORSCHRIFT_REF_FAHRZEUGKLASSE
            where vorschriftid = lVorschriftId.column_value
                and fahrzeugklasseid not in (
                    select column_value
                    from table(apex_string.split_numbers(aListFahrzeugklasse, ':'))
            );
 
        end loop;
    end if;
 
    return true;
end fChangeVorschriftenAttributFahrzeugklasse;
 
 
/* Ändert bestimmte Links von Vorschriften, *wenn diese noch nicht gesetzt sind*
   aListVorschriftId: Durch ':' getrennte Liste von Vorschriften-IDs, 
        bearbeitet werden sollen
    aLinkGetex, aLinkDms, aWebsiteId, aLinkWebsite: Neuer Wert der jeweiligen
        Spalte; null = alten Wert behalten
*/
function fChangeVorschriftenLinks(aListVorschriftId VARCHAR2, aLinkGetex VARCHAR2, 
    aLinkDms VARCHAR2, aWebsiteId NUMBER, aLinkWebsite VARCHAR2) return BOOLEAN AS
BEGIN
 
    if (aLinkGetex is not null) then
        update t_vorschrift set link_zur_vorschrift_getex = aLinkGetex, revisionszaehler = revisionszaehler+1
        where vorschriftid in (select column_value from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
    end if;
 
 
    if (aLinkDms is not null) then
        update t_vorschrift set link_zur_vorschrift_dms = aLinkDms, revisionszaehler = revisionszaehler+1
        where vorschriftid in (select column_value from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
    end if;
 
 
    if (aWebsiteId is not null) then
        update t_vorschrift set websiteid = aWebsiteId, revisionszaehler = revisionszaehler+1
        where vorschriftid in (select column_value from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
    end if;
 
    if (aLinkWebsite is not null) then
        update t_vorschrift set websitelink = aLinkWebsite, revisionszaehler = revisionszaehler+1
        where vorschriftid in (select column_value from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
    end if;    
 
    return true;
END fChangeVorschriftenLinks;
 
/* Kopiert de Zuordnungen zu den Themengebieten von einem Quellland 
    auf ein Zielland für die ausgewählten Vorschriften.
 
   aListVorschriftId: Durch ':' getrennte Liste von Vorschriften-IDs, 
        bearbeitet werden sollen
    aSourceLandId: Quell-Land
    aListTargetLandId: Durch ':' getrennte List von Ziel-Land-IDs
*/
function fCopyVorschriftenThemenByLand(aListVorschriftId VARCHAR2, 
    aSourceLandId NUMBER, aListTargetLandId VARCHAR2) return BOOLEAN AS
BEGIN
 
    for lTargetLandId in (select * from table(apex_string.split_numbers(aListTargetLandId, ':')))
    loop
        merge into T_VORSCHRIFT_REF_THEMA_REF_LAND dest
        using (select * from T_VORSCHRIFT_REF_THEMA_REF_LAND
            where LANDID = aSourceLandId
            and VORSCHRIFTID in (
                SELECT column_value 
                from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')))) src
        on (src.vorschriftid = dest.vorschriftid
            and src.themaid = dest.themaid
            and lTargetLandId.column_value = dest.landid)
        when not matched then
            insert (vorschriftid, themaid, landid)
            values (src.vorschriftid, src.themaid, lTargetLandId.column_value);
    end loop;
 
    return true;
END fCopyVorschriftenThemenByLand;
 
/* Kopiert de Zuordnungen zu den Laendern von einem Quell-Themengebiet 
    auf ein Ziel-Themengebiet für die ausgewählten Vorschriften.
 
   aListVorschriftId: Durch ':' getrennte Liste von Vorschriften-IDs, 
        bearbeitet werden sollen
    aSourceThemaId: Quell-Thema
    aTargetThemaId: Durch ':' getrennte Liste von Ziel-Thema-IDs
*/
function fCopyVorschriftenLaenderByThema(aListVorschriftId VARCHAR2, 
        aSourceThemaId NUMBER, aListTargetThemaId VARCHAR2) return BOOLEAN AS
BEGIN
 
    for lTargetThemaId in (select * from table(apex_string.split_numbers(aListTargetThemaId, ':')))
    loop
        merge into T_VORSCHRIFT_REF_THEMA_REF_LAND dest
        using (select * from T_VORSCHRIFT_REF_THEMA_REF_LAND
            where THEMAID = aSourceThemaId
            and VORSCHRIFTID in (
                SELECT column_value 
                from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')))) src
        on (src.vorschriftid = dest.vorschriftid
            and lTargetThemaId.column_value = dest.themaid
            and src.landid = dest.landid)
        when not matched then
            insert (vorschriftid, themaid, landid)
            values (src.vorschriftid, lTargetThemaId.column_value, src.landid);
    end loop;
 
    return true;
END fCopyVorschriftenLaenderByThema;
 
  function fSearchAndReplaceVorschriftenAttribut(aListVorschriftId VARCHAR2, aAttribut NUMBER, 
        aPlainRegexReplace NUMBER, aSearchText VARCHAR2, aReplaceText VARCHAR2) return NUMBER AS
      lResult NUMBER := null;
  BEGIN
 
    case aAttribut
        when 10 then
            update t_vorschrift vs
            set vs.vorschrift_nummer = (
                select case to_char(aPlainRegexReplace)
                    when '0' then replace(inner_vs.vorschrift_nummer, aSearchText, aReplaceText) 
                    when '1' then regexp_replace(inner_vs.vorschrift_nummer, aSearchText, aReplaceText) 
                end Neuer_Wert
                from t_vorschrift inner_vs
                where vs.vorschriftid = inner_vs.vorschriftid
            ), vs.revisionszaehler = vs.revisionszaehler+1
            where vs.vorschriftid in (SELECT column_value 
                from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
            lResult := 1;
        when 20 then
            update t_vorschrift vs
            set vs.vorschrift_bezeichnung = (
                select case to_char(aPlainRegexReplace)
                    when '0' then replace(inner_vs.vorschrift_bezeichnung, aSearchText, aReplaceText) 
                    when '1' then regexp_replace(inner_vs.vorschrift_bezeichnung, aSearchText, aReplaceText) 
                end Neuer_Wert
                from t_vorschrift inner_vs
                where vs.vorschriftid = inner_vs.vorschriftid
            ) , vs.revisionszaehler = vs.revisionszaehler+1
            where vs.vorschriftid in (SELECT column_value 
                from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
            lResult := 1;
        when 30 then
            update t_vorschrift vs
            set vs.bemerkung = (
                select case to_char(aPlainRegexReplace)
                    when '0' then replace(inner_vs.bemerkung, aSearchText, aReplaceText) 
                    when '1' then regexp_replace(inner_vs.bemerkung, aSearchText, aReplaceText) 
                end Neuer_Wert
                from t_vorschrift inner_vs
                where vs.vorschriftid = inner_vs.vorschriftid
            ), vs.revisionszaehler = vs.revisionszaehler+1 
            where vs.vorschriftid in (SELECT column_value 
                from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
            lResult := 1;
        when 40 then
            update t_vorschrift vs
            set vs.LINK_ZUR_VORSCHRIFT_DMS = (
                select case to_char(aPlainRegexReplace)
                    when '0' then replace(inner_vs.LINK_ZUR_VORSCHRIFT_DMS, aSearchText, aReplaceText) 
                    when '1' then regexp_replace(inner_vs.LINK_ZUR_VORSCHRIFT_DMS, aSearchText, aReplaceText) 
                end Neuer_Wert
                from t_vorschrift inner_vs
                where vs.vorschriftid = inner_vs.vorschriftid
            ), vs.revisionszaehler = vs.revisionszaehler+1 
            where vs.vorschriftid in (SELECT column_value 
                from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
            lResult := 1;
        when 50 then
            update t_vorschrift vs
            set vs.LINK_ZUR_VORSCHRIFT_GETEX = (
                select case to_char(aPlainRegexReplace)
                    when '0' then replace(inner_vs.LINK_ZUR_VORSCHRIFT_GETEX, aSearchText, aReplaceText) 
                    when '1' then regexp_replace(inner_vs.LINK_ZUR_VORSCHRIFT_GETEX, aSearchText, aReplaceText) 
                end Neuer_Wert
                from t_vorschrift inner_vs
                where vs.vorschriftid = inner_vs.vorschriftid
            ), vs.revisionszaehler = vs.revisionszaehler+1 
            where vs.vorschriftid in (SELECT column_value 
                from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
            lResult := 1;
        when 60 then
            update t_vorschrift vs
            set vs.WEBSITELINK = (
                select case to_char(aPlainRegexReplace)
                    when '0' then replace(inner_vs.WEBSITELINK, aSearchText, aReplaceText) 
                    when '1' then regexp_replace(inner_vs.WEBSITELINK, aSearchText, aReplaceText) 
                end Neuer_Wert
                from t_vorschrift inner_vs
                where vs.vorschriftid = inner_vs.vorschriftid
            ), vs.revisionszaehler = vs.revisionszaehler+1 
            where vs.vorschriftid in (SELECT column_value 
                from TABLE(APEX_STRING.split_numbers(aListVorschriftId, ':')));
            lResult := 1;
    end case;
 
    RETURN lResult;
  END fSearchAndReplaceVorschriftenAttribut;
 
 
/* Erstellt eine URL zum erstellen eines Jira-Tickets basierend auf
   der übergebenen Vorschrift
 
   aVorschriftId: PK der Vorschrift
   return: der erstellte JIRA-Link
*/  
 /* function fCreateJiraUrl(aVorschriftId NUMBER) return VARCHAR2 as
      l_vs_nummer varchar2(4096);
      l_vs_bezeichnung varchar2(4096);
      l_vs_status varchar2(4096);
      l_vs_typid number;
      l_progn_quali varchar2(4096);
      l_datum_in_kraft varchar2(4096);
      l_datum_neuer_typ varchar2(4096);
      l_datum_alle_typen varchar2(4096);
      l_laender_fields varchar2(4096);
      l_ak_fields varchar2(4096);
      l_mfv varchar(4096);
    begin
 
    select v.vorschrift_nummer, v.vorschrift_bezeichnung,
      s.status, v.VORSCHRIFT_TYPID
    into l_vs_nummer, l_vs_bezeichnung,
      l_vs_status, l_vs_typid
    from t_vorschrift v
    left outer join t_vorschrift_status s on s.VORSCHRIFT_STATUSID = v.VORSCHRIFT_STATUSID
    where v.vorschriftid = aVorschriftId;
 
    select case when v.prognose_qualitaet = 10 then 'sicher'
      when v.prognose_qualitaet = 20 then 'abschätzbar'
      else null
     end into l_progn_quali
    from T_VORSCHRIFT v
    where v.vorschriftid = aVorschriftId;
 
    select to_char(einsatzdatum, 'DD.MM.YYYY') into l_datum_in_kraft
    from t_vorschrift_ref_einsatzdatum_typ vre
    where vre.vorschriftid = aVorschriftId
        and vre.einsatzdatum_typid = 1000
    union all select null from dual
    fetch first 1 rows only;
 
    select listagg(case 
        when vre.einsatzdatum_typid = 1020 then 'CKD ' 
        when vre.einsatzdatum_typid = 1022 then 'FBU ' 
        else null
        end
        || to_char(einsatzdatum, 'DD.MM.YYYY'), ' ') within group (order by vre.einsatzdatum_typid) into l_datum_neuer_typ
    from t_vorschrift_ref_einsatzdatum_typ vre
    inner join t_vorschrift vs on (vs.vorschriftid = vre.vorschriftid)
    inner join t_einsatzdatum_typ edt on (edt.einsatzdatum_modellid = vs.einsatzdatum_modellid and vre.einsatzdatum_typid = edt.einsatzdatum_typid)
    where vre.vorschriftid = aVorschriftId
        and vre.einsatzdatum_typid in (1010, 1020, 1022, 1030)
    group by vs.vorschriftid
    union all select null from dual
    fetch first 1 rows only;
 
    select listagg(case 
        when vre.einsatzdatum_typid = 1021 then 'CKD ' 
        when vre.einsatzdatum_typid = 1023 then 'FBU ' 
        else null
        end
        || to_char(einsatzdatum, 'DD.MM.YYYY'), ' ') within group (order by vre.einsatzdatum_typid) into l_datum_alle_typen
    from t_vorschrift_ref_einsatzdatum_typ vre
    inner join t_vorschrift vs on (vs.vorschriftid = vre.vorschriftid)
    inner join t_einsatzdatum_typ edt on (edt.einsatzdatum_modellid = vs.einsatzdatum_modellid and vre.einsatzdatum_typid = edt.einsatzdatum_typid)
    where vre.vorschriftid = aVorschriftId
        and vre.einsatzdatum_typid in (1011, 1021, 1023, 1031)
    group by vs.vorschriftid
    union all select null from dual
    fetch first 1 rows only;
 
    --mfv
    with mapped_mfvs as (
        select m.mfv_name
        from t_mfv_ref_vorschrift mrv
        join t_mfv m on m.mfvid = mrv.mfvid
        where mrv.vorschriftid = aVorschriftId
     )
    select nvl2(listagg(mfv_name, '/'), listagg(mfv_name, '/') || ' ', '') into l_mfv
    from mapped_mfvs;
 
    with land_jira_codes as (
     select distinct land.jira_code
     from T_VORSCHRIFT_REF_LAND vtl 
     left outer join t_land land on land.landid = vtl.landid
     where vtl.vorschriftid = aVorschriftId 
      and vtl.geloescht = 0
      and land.jira_code is not null
    )
    select listagg('&customfield_16470=' || land_jira_codes.jira_code, '') into l_laender_fields
    from land_jira_codes;
 
    if l_vs_nummer like 'UN-R%'  or l_vs_typid = 20 then -- UN-R-Vorschrift oder Supplement
    l_laender_fields := l_laender_fields || '&customfield_16470=39704';
    end if;
 
    with ak_jira_codes as ( -- AK-Kurzebez. muessen noch in Jira-IDs umgewandelt werden
     select distinct t.ET_B_AK_KURZ
     from T_VORSCHRIFT_REF_THEMA vtt 
     left outer join t_thema t on t.themaid = vtt.themaid
     where vtt.vorschriftid = aVorschriftId 
      and vtt.geloescht = 0
      and t.ET_B_AK_KURZ is not null
    )
    select listagg('&components=' || ak_jira_codes.ET_B_AK_KURZ, '') into l_ak_fields
    from ak_jira_codes;
 
 
    return 'https://portal.epp.audi.vwg/aenjira/secure/CreateIssueDetails!init.jspa?pid=21724&issuetype=3&priority=4' ||
    --'&components=44408' || -- Komponente Testticket (44408), weitere l_ak_fields
    '&summary=MfV '|| apex_util.url_encode(l_mfv || l_vs_nummer || ' ' || l_vs_bezeichnung) ||
    '&customfield_10695=' || apex_util.url_encode(l_vs_nummer) ||
    l_laender_fields || 
    '&description=' || apex_util.url_encode('\\Achtung! Das Feld Beschreibung (text) ist ausschließlich für Reg Index DB Informationen reserviert \\ \\' ||
     'h2. +Hilfen+: \\' ||
     '* Anleitung für das MfV Ticket (Aufgabe): [https://portal.epp.audi.vwg/wiki/display/ETW/Anleitung+zum+Thema+MfV+Teil+x+Vorgang] \\' ||
     'h2. *Informationen:*\\' ||
     '* Lange Bezeichnung der Vorschrift:\\' ||
     '** +' || l_vs_bezeichnung || '+\\' ||
     '* Permalink: \\' ||
     '** [' || pck_ri.fCreatePermalinkUrl(aVorschriftId) || '] \\' ||
     '* Einleitende Informationen vom VIK / VKO:\\' ||
     '** hier steht ihre Einleitung' ||
     '* Quellenangabe: Quelle der Information (z.B. Importeur, Datenbank Abos, Newsletter, K-VKO)\\' || 
     '** z.B. Importeur\\' ||
     '* Getex Link zur Vorschrift order Getex ID:\\ \\' ||
     '* Zusätzliche Links (Optional falls in Getex nicht vorhanden): \\ \\' ||
     '* Status der Vorschrift: \\' ||
     '** +aus APEX+ ' || l_vs_status || '\\' ||
     '* Inkrafttreten der Vorschrift:\\' ||
     '** +aus APEX+ ' || l_datum_in_kraft || '\\' ||
     '* Einsatzdatum für neuen Typ:\\' ||
     '** +aus APEX+ ' || l_datum_neuer_typ || '\\' ||
     '* Einsatzdatum für allen Typen:\\' ||
     '** +aus APEX+ ' || l_datum_alle_typen || '\\ ') ||
    '&customfield_14872=' || apex_util.url_encode('Scope Inhalt Details:') ||
    '&customfield_10696=' || apex_util.url_encode('h2. +Link zu MfV Power Point:+\\ \\' ||
     '+Links zu AK Protokollen:+\\ \\' ||
     '+Links zu ET-B Forum Protokoll:+\\ \\' ||
     '+Links zum SKFV Protokoll:+') ||
    '&customfield_10288=' || apex_util.url_encode(pck_ri.fCreatePermalinkUrl(aVorschriftId)) ||
    '&customfield_19470=' || apex_util.url_encode(l_vs_nummer) 
 
     ;
 
end fCreateJiraUrl; */
-- Fügt den Ausgewählten Themen noch die unterThemen hinzu
function fgetFullTHemenListe (aThemenliste varchar2) return varchar2
as
lreturn varchar2(4000);
begin
lreturn := '';
if(aThemenliste is not null) then
Select listagg (distinct themaid,':') into lreturn 
from v_thema_baum
start with themaid in
(SELECT column_value 
                from TABLE(APEX_STRING.split_numbers(aThemenliste, ':')))
connect by prior themaid = parentid;
 
end if;
return lreturn;
end fgetFullTHemenListe;
 
 
procedure pUpdateDocumentStatus(aMfvname in varchar2)
  is
    num2 number :=0;
    lmfv_Name varchar2(60);
  BEGIN
    lmfv_Name := aMfvname;
    num2 := to_number(substr(lmfv_Name, length(lmfv_Name)-1));
 
    --lmfv_Name :='E01 00013 101 V02';
    for cu in  (select mfv_name, mfvid from t_mfv 
         where mfv_name like Replace(substr(lmfv_Name,1, length(lmfv_Name)-2),' ','_')||'%'
         and regexp_like(substr(mfv_name, length(mfv_name)-1), '^\d+(\d+)?$')
          and mfv_Name not like Replace(lmfv_Name,' ','_')
          and to_number(substr(lmfv_Name, length(lmfv_Name)-1)) >
              to_number(substr(mfv_name, length(mfv_name)-1))
                and DMS_Dokumentenstatus !=30 and regexp_like(substr(mfv_name,-3),'V[[:digit:]]')  and regexp_like(substr(lmfv_Name,-3),'V[[:digit:]]'))
    LOOP
    dbms_output.put_line('input:' ||lmfv_Name || ', found:' || cu.mfv_name);
         Update t_mfv set DMS_Dokumentenstatus =30 where mfvid=cu.mfvid;
   END LOOP;
   exception
    when value_error then
    dbms_output.put_line('input:' ||lmfv_Name || ', two last chars are not numeric');
    null;
  END;
 
/*
*/
 function fisInRedaktionsteam( auserid number)
 return number as
 l_co number :=0;
  begin
    select count(benutzerid) into l_co from t_benutzer 
     where benutzerid = auserid 
       and GID in ('7B70CF1BCFCDA79C', '2DC19358859CC4CC', '2F0830D92AA94C87', '992503A1D45D1DF4', 'C633D4ECE491D4A9', '7AB61614AB1CD30C');
    return l_co;
 end;
 
 /*
 */
  function fgetCommonVKOUserIds(avorschriftenids varchar2)    
  return  varchar2 as
  l_ids_Table T_ListOfIds_Table;
  l_cnt     pls_integer;
  l_user_ids varchar2(5000);
  l_prev_user_ids varchar2(5000);
  l_v_co number :=0;
  ii number :=0;
BEGIN
  l_ids_Table := T_ListOfIds_Table();
   select count(*) into l_v_co 
   from  (select column_value from table (apex_string.split_numbers(avorschriftenids, ':'))  where column_value is not null );
  --add values
   l_ids_Table.extend(l_v_co);
   for cur in (select column_value from table (apex_string.split_numbers(avorschriftenids, ':'))  where column_value is not null
   ) loop
   ii := ii+1;
    l_ids_Table(ii) := cur.column_value;
   end loop;
 
 
  for ind in 1 .. l_v_co loop
    if( ind =1) then
      with cte as( select  distinct  bezeichnung as d,  benutzerid r, vorschriftid
                    FROM V_VORSCHRIFT_VKO )
      select listagg(r, ':') within group (order by r) into l_user_ids 
      from cte  where vorschriftid =  l_ids_Table(ind); 
    else
       with cte as( select  distinct  bezeichnung as d,  benutzerid r, vorschriftid
                    FROM V_VORSCHRIFT_VKO )
      select listagg(r, ':') within group (order by r) into l_user_ids 
      from cte  where vorschriftid =  l_ids_Table(ind) and r in 
      ( select column_value from table (apex_string.split_numbers(l_prev_user_ids, ':')) ); 
    end if;
 
     l_prev_user_ids := l_user_ids;
    dbms_output.put_line( l_user_ids );
    if( l_user_ids is null) then
      exit;
    end if;
  end loop;
   return l_user_ids;
  end;
 
  /**
  */
 function fAddLaenderToVorschriften(avorschriftids varchar2, alaenderids varchar2) return boolean
 as
  resu boolean :=true;
  begin
   UPDATE  t_vorschrift_ref_land set geloescht=0
    where vorschriftID in  (select column_value
                            from table(apex_string.split_numbers(avorschriftids, ':')) where column_value is not null )
    and geloescht =1
    and landid  in (select column_value  from table(apex_string.split_numbers(alaenderids, ':')));
 
     FOR  cur_v in (select column_value v_id from table(apex_string.split_numbers(avorschriftids, ':')) where column_value is not null )
     LOOP
        MERGE into t_vorschrift_ref_land dest
       USING ( select cur_v.v_id as vorschriftID, 
              y.column_value as landid from table (apex_string.split_numbers(alaenderids, ':')) y) src
       on (src.vorschriftID = dest.vorschriftID 
           and src.landid = dest.landid)
      WHEN NOT MATCHED THEN
       insert (vorschriftID, landid, geloescht)
       values (src.vorschriftID, src.landid, 0);
    end LOOP;
 return resu;
 end;
 
 /**
 */
 function fAddThemenToVorschriften(avorschriftids varchar2, aThemenids varchar2) return boolean
as
  resu boolean :=true;
  begin
   UPDATE  T_VORSCHRIFT_REF_THEMA SET geloescht=0
    where vorschriftID in  (select column_value
                            from table(apex_string.split_numbers(avorschriftids, ':')) )
    and geloescht =1
    and themaid  in (select column_value  from table(apex_string.split_numbers(aThemenids, ':')));
 
     FOR  cur_v in (select column_value v_id from table(apex_string.split_numbers(avorschriftids, ':')) )
     LOOP
        MERGE INTO T_VORSCHRIFT_REF_THEMA dest
       USING ( select cur_v.v_id as vorschriftID, 
              y.column_value as THEMAID from table (apex_string.split_numbers(aThemenids, ':')) y) src
       on (src.vorschriftID = dest.vorschriftID 
           and src.THEMAID = dest.THEMAID)
      WHEN NOT MATCHED THEN
       insert (  vorschriftID,    THEMAID, geloescht)
       values (src.vorschriftID, src.THEMAID, 0);
    end LOOP;
 return resu;
 end;
 
function fCreateJiraUrlAssistent(aVorschriftId NUMBER, aMFV_TEILID NUMBER,aAKIDS VARCHAR2 default null,aSchlagwörter VARCHAR2 default null, aZusVorschriften  VARCHAR2 default null, aMFVID VARCHAR2 default null) return clob as
      l_vs_nummer varchar2(4096);
      l_vs_bezeichnung varchar2(4096);
      l_vs_status varchar2(4096);
      l_vs_typid number;
      l_progn_quali varchar2(4096);
      l_datum_in_kraft varchar2(4096);
      l_datum_neuer_typ varchar2(4096);
      l_datum_alle_typen varchar2(4096);
      l_laender_fields varchar2(4096);
      l_ak_fields varchar2(4096);
      l_mfv varchar(4096);
      l_template varchar2(4096);
      l_issue_type varchar2(4096);
      l_labels varchar2(4096);
      l_vorschrift_old varchar2(4096);
      l_vorschrift_new varchar2(4096);
      l_vorschrift_permalink varchar2(4096);
      l_link  varchar2(4096);
      l_summary varchar2(4096);
      l_date_list varchar2(4096);
      l_land_list varchar2(4096);
 
    begin
    -- 1 = Information , 2 = Entcheidung
    select case when aMFV_TEILID = 1 then '&issuetype=13733&customfield_16813=41540' else '&issuetype=14201&customfield_16813=41541' end,case when aMFV_TEILID = 1 then '&issueTemplateId=2936' else '&issueTemplateId=2935' end
    into l_issue_type,l_template
    from dual;
--Vorschriftnummer
    select v.vorschrift_nummer, v.vorschrift_bezeichnung,
      s.status, v.VORSCHRIFT_TYPID
    into l_vs_nummer, l_vs_bezeichnung,
      l_vs_status, l_vs_typid
    from t_vorschrift v
    left outer join t_vorschrift_status s on s.VORSCHRIFT_STATUSID = v.VORSCHRIFT_STATUSID
    where v.vorschriftid = aVorschriftId;
-- Vorschriftennummern neu & Permalinks
    with cte1 as (
    select  'Main regulation number: \\\\'|| v.vorschrift_nummer vorschrift_nummer,1 as sortorder, pck_ri.fCreatePermalinkUrl(vorschriftid) vorschriftlink
    ,  l_vs_status as vs_status
    from t_vorschrift v
    where v.vorschriftid = aVorschriftId
 
 
    )
 
    Select listagg(vorschrift_nummer,', \\\\ ')within group (order by Sortorder asc, vorschrift_nummer asc), 
    listagg( vorschriftlink,',')within group (order by Sortorder asc, vorschrift_nummer asc)
 
    into l_vorschrift_new, l_vorschrift_permalink
    from cte1;
 
    with cte1 as (
    select v.vorschrift_nummer,2 as sortorder, pck_ri.fCreatePermalinkUrl(vorschriftid) vorschriftlink, s.status
    from t_vorschrift v
    left outer join t_vorschrift_status s on s.VORSCHRIFT_STATUSID = v.VORSCHRIFT_STATUSID
    where v.vorschriftid  in  (
                    SELECT
                        column_value
                    FROM
                        TABLE ( apex_string.split_numbers(aZusVorschriften , ':') )
                        ) and vorschriftid != aVorschriftId
                        )
    , cte2 as (Select listagg(vorschrift_nummer,', \\\\ ')within group (order by Sortorder asc, vorschrift_nummer asc) vorschriftnummer, 
    listagg( vorschriftlink,', ')within group (order by Sortorder asc, vorschrift_nummer asc) vorschriftlink    
     ,listagg (vorschrift_nummer||': '|| Status, ', \\\\ ')within group (order by Sortorder asc, vorschrift_nummer asc)  status
    from cte1)
    Select   nvl2(vorschriftnummer,l_vorschrift_new||'\\\\ \\\\ Additional regulation number(s): \\\\'||vorschriftnummer,l_vorschrift_new), 
    l_vorschrift_permalink || nvl2(vorschriftlink,', ' || vorschriftlink,'')
    ,  nvl2(vorschriftnummer,'Status main regulation: \\\\ ' || l_vs_status ||'\\\\ \\\\ Status additional regulation(s): \\\\'|| status,'Status main regulation: \\\\ ' || l_vs_status )
    into l_vorschrift_new, l_vorschrift_permalink 
    ,l_vs_status 
    from cte2;
-- Vorgänger Vorschrift Old
    with cte1 as (Select vorschrift_nummer
    from t_vorschrift_ref_vorschrift tvrv
    join t_vorschrift tv on (tvrv.VORGAENGER_VORSCHRIFTID = tv.vorschriftid)
    where  beziehung_art = 10 and nachfolger_vorschriftid =aVorschriftId
    )
    Select case when aMFV_TEILID = 2 then '' else listagg(vorschrift_nummer, ', ') end into l_vorschrift_old 
    from cte1;
-- Prognose Qualität
    select case when v.prognose_qualitaet = 10 then 'sicher'
      when v.prognose_qualitaet = 20 then 'abschätzbar'
      else null
     end into l_progn_quali
    from T_VORSCHRIFT v
    where v.vorschriftid = aVorschriftId;
-- Ausgwäjlte Stichwörter
    Select listagg('&labels=' || replace(stext,' ','_'),'') into l_labels
    from t_schlagwort
    where SCHLAGWORTID  in  (
                    SELECT
                        column_value
                    FROM
                        TABLE ( apex_string.split_numbers(aSchlagwörter, ':') )
                        );
 
--Datumsangaben   
    select to_char(einsatzdatum, 'DD/MON/YY') into l_datum_in_kraft
    from t_vorschrift_ref_einsatzdatum_typ vre
 
    where vre.vorschriftid = aVorschriftId
        and vre.einsatzdatum_typid = 1000
    union all select null from dual
    fetch first 1 rows only;
 
    select listagg(case 
        when vre.einsatzdatum_typid = 1020 then 'CKD ' 
        when vre.einsatzdatum_typid = 1022 then 'FBU ' 
        else null
        end
        || to_char(einsatzdatum, 'DD/MON/YY'), ' ') within group (order by vre.einsatzdatum_typid) into l_datum_neuer_typ
    from t_vorschrift_ref_einsatzdatum_typ vre
    inner join t_vorschrift vs on (vs.vorschriftid = vre.vorschriftid)
    inner join t_einsatzdatum_typ edt on (edt.einsatzdatum_modellid = vs.einsatzdatum_modellid and vre.einsatzdatum_typid = edt.einsatzdatum_typid)
    where vre.vorschriftid = aVorschriftId
        and vre.einsatzdatum_typid in (1010, 1020, 1022, 1030)
    group by vs.vorschriftid
    union all select null from dual
    fetch first 1 rows only;
 
    select listagg(case 
        when vre.einsatzdatum_typid = 1021 then 'CKD ' 
        when vre.einsatzdatum_typid = 1023 then 'FBU ' 
        else null
        end
        || to_char(einsatzdatum, 'DD/MON/YY'), ' ') within group (order by vre.einsatzdatum_typid) into l_datum_alle_typen
    from t_vorschrift_ref_einsatzdatum_typ vre
    inner join t_vorschrift vs on (vs.vorschriftid = vre.vorschriftid)
    inner join t_einsatzdatum_typ edt on (edt.einsatzdatum_modellid = vs.einsatzdatum_modellid and vre.einsatzdatum_typid = edt.einsatzdatum_typid)
    where vre.vorschriftid = aVorschriftId
        and vre.einsatzdatum_typid in (1011, 1021, 1023, 1031)
    group by vs.vorschriftid
    union all select null from dual
    fetch first 1 rows only;
 
-- Datumsangaben als Liste
 
  select 'Application timing main regulation: \\\\  '|| listagg(EINSATZDATUM_TYP ||': '||case when  vre.EINSATZDATUM_TYPID in (1030,1031) and modeljahr is not null  then 'Modelljahr '||to_char(modeljahr, 'YYYY') else  to_char(einsatzdatum, 'DD.MM.YYYY') end,',\\\\') within group ( order by sortorder)into l_date_list
    from t_vorschrift_ref_einsatzdatum_typ vre
        join t_einsatzdatum_typ ty on (vre.einsatzdatum_typid = ty.einsatzdatum_typid)
    where vre.vorschriftid = aVorschriftId and einsatzdatum is not null and vre.EINSATZDATUM_TYPID  not in (1031)
   ;
 
-- Datumsangaben Zusätzliche Vorschriften
 
   with cte1 as (
   Select  ' \\\\ '||VORSCHRIFT_NUMMER ||': \\\\' ||listagg( EINSATZDATUM_TYP ||': '||case when  vre.EINSATZDATUM_TYPID in (1030,1031) and modeljahr is not null  then 'Modelljahr '||to_char(modeljahr, 'YYYY') else  to_char(einsatzdatum, 'DD.MM.YYYY') end,',\\\\') within group ( order by sortorder) as datum_angaben
   from t_vorschrift_ref_einsatzdatum_typ vre
        join t_einsatzdatum_typ ty on (vre.einsatzdatum_typid = ty.einsatzdatum_typid)
       join t_vorschrift v on (vre.vorschriftid = v.vorschriftid)
 
   where vre.vorschriftid  in  (
                    SELECT
                        column_value
                    FROM
                        TABLE ( apex_string.split_numbers(aZusVorschriften , ':') )
                        ) and vre.vorschriftid != aVorschriftId and einsatzdatum is not null  and vre.EINSATZDATUM_TYPID  not in (1031)
     group by VORSCHRIFT_NUMMER
    ),cte2 as (
    Select listagg(datum_angaben, '\\\\') datum_angaben
    from cte1
    )
    Select case when   datum_angaben is not null then  l_date_list || '\\\\ \\\\ Application timing additional regulation(s): \\\\'|| datum_angaben else l_date_list end into l_date_list
    from cte2;
 
 
 
    --mfv
    with mapped_mfvs as (
        select m.mfv_name
        from t_mfv_ref_vorschrift mrv
        join t_mfv m on m.mfvid = mrv.mfvid
        where mrv.vorschriftid = aVorschriftId
     )
    select nvl2(listagg(mfv_name, '/'), listagg(mfv_name,  '/') || ' ', aMFVID||' ') into l_mfv
    from mapped_mfvs;
-- Länder
    with land_jira_codes as (
     select distinct land.jira_code2 as jira_code, land, ISO_ENGLISCH
     from T_VORSCHRIFT_REF_LAND vtl 
     left outer join t_land land on land.landid = vtl.landid
     where (vtl.vorschriftid = aVorschriftId or vtl.vorschriftid in  (
                    SELECT
                        column_value
                    FROM
                        TABLE ( apex_string.split_numbers(aZusVorschriften , ':') )
                        ) )
      and vtl.geloescht = 0
      and land.jira_code2 is not null
    )
    select listagg('&customfield_18402=' || land_jira_codes.jira_code, '') , listagg(ISO_ENGLISCH,', ')into l_laender_fields,l_land_list
    from land_jira_codes;
 
    if l_vs_nummer like 'UN-R%'  or l_vs_typid = 20 then -- UN-R-Vorschrift oder Supplement
    l_laender_fields := l_laender_fields || '&customfield_18402=42225';
    end if;
 
    with ak_jira_codes as ( -- AK-Kurzebez. muessen noch in Jira-IDs umgewandelt werden
     select distinct ak.JIRAID
     from  t_et_B_ak ak 
     where et_b_akid in  (
                    SELECT
                        column_value
                    FROM
                        TABLE ( apex_string.split_numbers(aAKIDS, ':') )
                        )
 
    )
    select listagg('&components='|| ak_jira_codes.JIRAID, '') into l_ak_fields
    from ak_jira_codes;
--Summary Abschneiden
with cte1 as(
 Select l_land_list|| ' - '||
 l_vs_nummer  as summary_text
 from dual
 ) Select case when length(summary_text) >= 250 then substr(summary_text,1,245)||'...' else summary_text end into l_summary
 from cte1;
 
    return 'https://cicd.cloud.audi/jira/secure/CreateIssueDetails!init.jspa?pid=24805'||l_issue_type||l_template||'&priority=4' ||
        '&summary=' ||apex_util.url_encode(l_summary) ||
      -- '&components=34306'||
       '&customfield_11643='||case when length(l_vs_bezeichnung) >= 250 then substr(l_vs_bezeichnung,1,245)||'...'  else l_vs_bezeichnung  end||
       l_ak_fields ||
       l_labels||
       '&customfield_18422=' ||apex_util.url_encode(l_vorschrift_old)||
      --  '&customfield_18424=' ||l_datum_in_kraft||
      --  '&customfield_18425=' ||l_datum_neuer_typ||
      --  '&customfield_18426=' ||l_datum_alle_typen||
    '&customfield_18301=' || apex_util.url_encode(l_vorschrift_new) ||
    l_laender_fields ||
    '&customfield_17402=' || apex_util.url_encode('Scope Inhalt Details:') ||
    '&customfield_18411=' || apex_util.url_encode(l_vorschrift_permalink )  ||
  --  '&customfield_16509=' ||apex_util.url_encode(l_link)||
    '&customfield_11635=' ||apex_util.url_encode(aMFVID)||
    '&customfield_18305=56468' ||
    '&customfield_19700='||l_vs_status||
    -- '&customfield_17108='|| apex_util.url_encode(l_date_list)||
    '&customfield_10302='|| apex_util.url_encode(l_date_list)
 
 
     ;
 
end fCreateJiraUrlAssistent;
 
--tharun
PROCEDURE proc_equivalent_vorschrift_thema(aVorschriftID in number)
 IS
    v_count NUMBER;
BEGIN
    FOR i IN (
        SELECT 
           -- vrt.VORSCHRIFT_REF_THEMAID, 
           vrv.VORSCHRIFT_REF_VORSCHRIFTID,
            vrt.THEMAID, 
            vrv.BEZIEHUNG_ART,
            vrt.LETZTE_AENDERUNG_DATUM,
            vrt.LETZTE_AENDERUNG_BENUTZERID
        FROM 
        t_vorschrift_ref_thema vrt
            JOIN T_VORSCHRIFT_REF_VORSCHRIFT vrv
                ON vrv.VORGAENGER_VORSCHRIFTID = vrt.vorschriftid
        WHERE 
            vrv.BEZIEHUNG_ART = 102  
            and vrv.VORGAENGER_VORSCHRIFTID =aVorschriftID -- equivalent
    ) LOOP
        -- Check if the record already exists
        begin
        SELECT COUNT(*) INTO v_count FROM T_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA
        WHERE VORSCHRIFT_REF_VORSCHRIFTID = i.VORSCHRIFT_REF_VORSCHRIFTID
        and THEMAID =i.THEMAID 
 
        ;
        exception when no_data_found then v_count :=0;
        end;
        --   AND THEMAID = i.THEMAID;
 
        IF v_count > 0 THEN
        UPDATE T_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA  
            SET THEMAID = i.themaid,
                STATUS_VERKNUEPFUNG = 1,
                STATUS_PRUEFUNG = 1,
                LETZTE_AENDERUNG_DATUM = i.LETZTE_AENDERUNG_DATUM,
                LETZTE_AENDERUNG_BENUTZERID = i.LETZTE_AENDERUNG_BENUTZERID
            WHERE VORSCHRIFT_REF_VORSCHRIFTID = i.VORSCHRIFT_REF_VORSCHRIFTID; 
 
        else
            -- If not exists, insert the record
            INSERT INTO T_VORSCHRIFT_REF_VORSCHRIFT_REF_THEMA (
                VORSCHRIFT_REF_VORSCHRIFTID,
                THEMAID,
                STATUS_VERKNUEPFUNG, --DEFAULT 0 CHECK (STATUS_VERKNUEPFUNG IN (0, 1)),
                STATUS_PRUEFUNG, --DEFAULT 0 CHECK (STATUS_PRUEFUNG IN (0, 1)),
                LETZTE_AENDERUNG_DATUM,
                LETZTE_AENDERUNG_BENUTZERID 
            )
            VALUES (
                i.VORSCHRIFT_REF_VORSCHRIFTID,
                i.THEMAID,
                0, --  default status for 'STATUS_VERKNUEPFUNG' is 'not assigned'
                0, --  default status for 'STATUS_PRUEFUNG' is 'to be reviewed'
                i.LETZTE_AENDERUNG_DATUM, -- Current date and time
                i.LETZTE_AENDERUNG_BENUTZERID -- User ID should be dynamically determined
            );
       END IF;
 
    END LOOP;
 
    -- DELETE FROM t_vorschrift_ref_vorschrift_ref_thema
    --     WHERE
    --         vorschrift_ref_vorschriftid NOT IN (
    --     SELECT
    --         vrt.vorschrift_ref_themaid
    --     FROM
    --              t_vorschrift_ref_thema vrt
    --         JOIN t_vorschrift_ref_vorschrift vrv ON vrv.vorgaenger_vorschriftid = vrt.vorschriftid
    --     WHERE vrv.beziehung_art = 102 
        --and vrv.VORGAENGER_VORSCHRIFTID =aVorschriftID 
   -- );
 
END proc_equivalent_vorschrift_thema;
 
 
PROCEDURE PREFRESH_MV_FREE_VKO_REPORT
  AS
  BEGIN
   DBMS_MVIEW.REFRESH('MV_FREE_VKO_REPORT');
END PREFRESH_MV_FREE_VKO_REPORT;
 
END PCK_RI;
```



/* PCK RI BENACHRICHTIGUNG */

-- SPECIFICATION

create or replace PACKAGE PCK_RI_BENACHRICHTIGUNG AS 

  procedure pBenachrichtigung( aVorschriftid in number,  aArbeitskreise varchar2, aText in varchar2, aGrund in number :=0, 
      aLoeschmarker in number :=0, aBenutzerid in number := null, aGrund70_bereich in number:= null, amfvid in number:= null);
  procedure pLoescheAlteBenachrichtigung( aDaysOld in number);
  PROCEDURE pMarkAndInform( aDaysOld in number);
  procedure pBenachrichtigungSWRelevanz(aVorschriftID in number);
  PROCEDURE pSetVorschriftInKraft;
  procedure  pBenachrichtigung_fremdzuweisung(aVorschriftid in number, lThemenIdliste in apex_t_number, abenutzerId in number);
  PROCEDURE  pBenachricht_Mfv_Arbeitskreise( aVorschriftid in number, aBereich in varchar2, benutzerId in number);
  PROCEDURE  pBenachrichtigung_Mfv_Gueltigkeit;
  procedure pWarnungEinsatzdatum;
  procedure pBenachrichtigung_Statuswechsel( aVorschriftid number, auserid number);
  procedure  pBenachrichtigung_fremdzuweisung2(  aVorschriftid in number, lThemenIdliste in varchar2, abenutzerId in number);
  procedure pThemenDiff_Vorgaenger(aVorschriftid in number, auserid in number );
 PROCEDURE working_group_user (
        aarbeitskreise        VARCHAR2,
        atext                 IN VARCHAR2,
        agrund                IN NUMBER := 0,
        aloeschmarker         IN NUMBER := 0,
        abenutzerid           IN NUMBER,
        abetroffener_anwender IN NUMBER
--        aGrund70_bereich IN NUMBER
    ) ;
END PCK_RI_BENACHRICHTIGUNG;
```


-- BODY

```
create or replace PACKAGE BODY PCK_RI_BENACHRICHTIGUNG AS

    PROCEDURE pBenachrichtigung( aVorschriftid in number,  aArbeitskreise varchar2, aText in varchar2, 
    aGrund in number :=0, aLoeschmarker in number :=0,
    aBenutzerid in number := null, aGrund70_bereich in number:= null, amfvid in number :=null)

    is
    -- create Benachrichtigung aGrund70_bereich 1-Datum, 2- Themen, 3- Laender 
    begin 
        FOR ak in (select  t.column_value val
                from table (apex_string.split_numbers(aArbeitskreise, ':'))  t
                where t.column_value IS NOT NULL)
        LOOP
          if (aGrund= 70) then -- set GRUND70_ 
        
            INSERT INTO T_Benachrichtigung (
               VorschriftID, ArbeitskreisID, benachrichtigung_text, status, Erstellung_DATUM, grund, Loeschmarker, erstellung_benutzerid,
                  Grund70_Datum, Grund70_THEMEN, Grund70_LAENDER
                    )
            values( aVorschriftid, ak.val, aText, 10, sysdate, aGrund, aLoeschmarker, aBenutzerid, 
                decode(aGrund70_bereich , 1, 1, null),decode(aGrund70_bereich , 2, 1,null), decode(aGrund70_bereich , 3, 1,null)
                    );
          else
            INSERT INTO T_Benachrichtigung (
               VorschriftID, ArbeitskreisID, benachrichtigung_text, status, Erstellung_DATUM, grund, Loeschmarker, 
               erstellung_benutzerid,  mfvid)
                    values( aVorschriftid, ak.val, aText, 10, sysdate, aGrund, aLoeschmarker, aBenutzerid, amfvid);
          end if;
        END LOOP;
        --commit;
    END pBenachrichtigung;

--tharun
     PROCEDURE working_group_user (
        aarbeitskreise        VARCHAR2,
        atext                 IN VARCHAR2,
        agrund                IN NUMBER := 0,
        aloeschmarker         IN NUMBER := 0,
        abenutzerid           IN NUMBER,
        abetroffener_anwender IN NUMBER
--        aGrund70_bereich IN NUMBER
    ) 
    is
    BEGIN
        INSERT INTO t_benachrichtigung (
            arbeitskreisid,
            benachrichtigung_text,
            status,
            erstellung_datum,
            grund,
            erstellung_benutzerid,          
            betroffener_anwender,
            STATUS_DMS,
            STATUS_GMT,
            STATUS_JIRA,
            STATUS_REQMAN,
            STATUS_ALL
        ) VALUES (
           aarbeitskreise,
            atext,
            10,
            sysdate,
            agrund,
            abenutzerid,
            abetroffener_anwender,
            10,
            10,
            10,
            10,
            10
        );

    END working_group_user;
    
    
    
    
    
    
    
    
    
    

    PROCEDURE pLoescheAlteBenachrichtigung( aDaysOld in number)
    is
    -- loesche Benachrichtigen welche ein Alter von mehr als aDaysOld Tagen haben.
    begin 
       DELETE FROM T_BENACHRICHTIGUNG_KOMMENTAR 
       where BENACHRICHTIGUNGID in (
                               SELECT BENACHRICHTIGUNGID FROM T_BENACHRICHTIGUNG 
                             WHERE ERSTELLUNG_DATUM < SYSDATE - aDaysOld );

       DELETE FROM T_BENACHRICHTIGUNG 
       WHERE ERSTELLUNG_DATUM < SYSDATE - aDaysOld ;
      COMMIT;
    end;


   PROCEDURE pMarkAndInform( aDaysOld in number)
    is
    -- 1.markiere Benachrichtigen welche ein Alter von mehr als aDaysOld Tagen haben zum löschen. (
    -- (4*365-30) ein monat vor dem Loschen
    -- 2. erstelle Benachrichtigung an VKO über neu vermerkte Benachrichtigungen

      listId_tomark varchar2(16384);
      ico number :=0;
   BEGIN
      SELECT LISTAGG(BenachrichtigungID, ',') INTO listId_tomark FROM  T_BENAchrichtigung 
       WHERE ERSTELLUNG_DATUM <= (SYSDATE - aDaysOld) 
         AND (loeschmarker is null OR loeschmarker != 1); 
       -- dbms_output.put_line(' list to mark: ' || listId_tomark );
       -- mark them
       IF (listId_tomark is not null) then
           UPDATE T_Benachrichtigung SET loeschmarker = 1  WHERE ERSTELLUNG_DATUM <= (SYSDATE - aDaysOld) AND (loeschmarker is null OR loeschmarker != 1);
           --DBMS_OUTPUT.PUT_LINE(TO_Char(SQL%ROWCOUNT)||' rows affected.');
            -- Notification an VKO:   grund = 50 (zum löschen in 30 Tagen)
           begin
               pbenachrichtigung(null, '1200', 
               'Benachrichtigungen mit ids: (' || listId_tomark || ') sind zum automatischen Löschen in 30 Tagen vermerkt', 50, 1);
              -- DBMS_OUTPUT.PUT_LINE(' procedure successed');
               COMMIT;
               EXCEPTION when OTHERS then
                rollback;
           end;
       END IF;
  end;

PROCEDURE pSetVorschriftInKraft
  is 
  v_id number;
  lst_AKreise varchar2(2000);
 BEGIN
  FOR cu in ( SELECT  v.vorschriftid as vorschriftid --,   vre.einsatzdatum, e.einsatzdatum_typid , vre.einsatzdatum , v.vorschrift_statusid
             FROM  t_einsatzdatum_typ e
            join  T_Vorschrift_ref_einsatzdatum_typ vre on ( e.einsatzdatum_typid = vre.einsatzdatum_typid)
            join t_vorschrift v on (v.vorschriftid = vre.vorschriftid)
            WHERE vre.einsatzdatum_typid =1000 and v.vorschrift_statusid != 40
            and vre.einsatzdatum < sysdate and vre.einsatzdatum is not null
            ) 
   LOOP

       v_id := cu.vorschriftid;
       -- alle AK of Vorschrift
       SELECT listagg(ET_B_AKid,':') within group (order by ET_B_AKid) as ET_B_AKid 
          into lst_AKreise
         from T_VORSCHRIFT_REF_ET_B_AK where vorschriftid = cu.vorschriftid;
         
       UPDATE t_vorschrift  
          set vorschrift_statusid = 40 , revisionszaehler = (revisionszaehler + 1)
       where  vorschriftid = cu.vorschriftid ;
       -- send benachrichtigung an "alle AK von Vorschrift" ,    grund 30-'Enacted'
      pbenachrichtigung(cu.vorschriftid, lst_AKreise, 
            'Status von Vorschrift ist automatisch in -Enacted- gesetzt', 30, 1);
               --DBMS_OUTPUT.PUT_LINE(' Status von ' || v_id || ' ist aktualisiert.');
   END LOOP;
   COMMIT;
 END;

  procedure pBenachrichtigungSWRelevanz(aVorschriftID in number) iS
    l_SW_relev number :=0;
    v_nummer varchar2(250);
    l_ak_id  varchar2(50);
    laend_in_schatten number :=0;
    BEGIN
      -- Hat die Vorschrift schon einmal die Benachrichtigung mit Grund 10 erhalten?
    select count(*) into l_SW_relev from T_Benachrichtigung where VorschriftID = aVorschriftID and Grund = 10;
    if (l_SW_relev > 0) then
        return;
    end if;

      -- Beginnt Vorschriften-Titel mit "UN-R" ?
    select substr(trim(VORSCHRIFT_NUMMER),1,4) into v_nummer from T_VORSCHRIFT where VorschriftID = aVorschriftID;
    
    if( upper(v_nummer) = 'UN-R') then
       -- create SW-Relev  Notation to AK E18 
       select  ET_B_AKID into l_ak_id from  T_ET_B_AK where kurz ='AK E18';
      PCK_RI_BENACHRICHTIGUNG.pBenachrichtigung( aVorschriftID,  l_ak_id , 'bitte prüfe bei dieser neuen Vorschrift die SW-Relevanz', 
       10, 0, PCK_RI.fGetUserId());
    else
      -- Ist die Vorschrift der Schattenländergruppe  (id = 1220) zugeordnet?
        select count(vrl.landid)  into laend_in_schatten
          from T_VORSCHRIFT_REF_LAND vrl
          join T_LAND l on (vrl.landid = l.landid  and vrl.vorschriftid = aVorschriftID)
          join T_LAND_ref_LAENDERGRUPPE lrlg on (lrlg.landid = vrl.landid and lrlg.laendergruppeid = 1220);
         
        if( laend_in_schatten>0) then
           -- create SW-Relev  Notation to AK E18 (is  ak independent)
           select  ET_B_AKID into l_ak_id from  T_ET_B_AK where kurz ='AK E18';
          PCK_RI_BENACHRICHTIGUNG.pBenachrichtigung( aVorschriftID,  l_ak_id , 'bitte prüfe bei dieser neuen Vorschrift die SW-Relevanz', 
           10, 0, PCK_RI.fGetUserId());
        end if;
    end if;
      
  END pBenachrichtigungSWRelevanz;

procedure  pBenachrichtigung_fremdzuweisung(
  aVorschriftid in number, lThemenIdliste in apex_t_number, abenutzerId in number)
     is                                
    lUser_Themas varchar2(1000);
    nCo number :=0;
    sq_qry varchar2(300);
    list_Ak varchar2(300);
    list_fremd_T varchar2(500);
begin  
   select listagg(distinct vrt.themaid,',') within group (order by vrt.themaid)  into lUser_Themas
                from T_ET_B_AK_REF_Benutzer arb
                join t_ET_B_AK_VKO_REF_THEMA  vrt on (vrt.ET_B_AK_VKOid = arb.ET_B_AK_REF_BenutzerID)
                --join T_THEMA t on (t.themaid = vrt.themaid)
                where arb.benutzerId = abenutzerId;
                --dbms_output.put_line(lThemenliste.count);
--debug('in proc: lUser_Themas=', lUser_Themas);
 for i in 1 .. lThemenIdliste.count
 LOOP
   -- check if ThemaID dem Benutzer id
   if(lUser_Themas is not null) then
      sq_qry := 'select count(*) from dual where '|| lThemenIdliste(i) || ' not in (' || lUser_Themas ||')';
        execute immediate sq_qry into nCo;
      --debug('in proc: exec immed i:', lThemenIdliste(i));
    else
     nCo :=1;
    end if;
    --debug('exec Immediate: nCo=', to_char(nCo));
    if (nvl(nCo,0) > 0 )  then
         list_fremd_T := list_fremd_T || lThemenIdliste(i)|| ':';
     end if;
    nCo :=0;
     
 END LOOP;
  
  
    --debug('list_fremd_T=', list_fremd_T);
    select listagg(distinct vra.et_b_akid,':') within group (order by vra.et_b_akid)
      into list_Ak
      from T_Vorschrift_ref_ET_B_AK vra   
      join T_Thema_ref_et_b_ak tra on (vra.et_b_akid = tra.et_b_akid )
     where tra.themaid in ( select column_value from table( APEX_STRING.split_numbers(list_fremd_T, ':')))
       and tra.themaid is not null;
        -- vra.vorschriftid= avorschriftid
     --dbms_output.put_line(list_Ak);
     --debug('list_Ak=', list_Ak);
     if (length(list_Ak)>1) then
        pBenachrichtigung( aVorschriftid, list_Ak,
               'Themengebiet prüfen da Fremdarbeitskreisvergabe', 60, 0 , abenutzerId);
     end if;
end;
/*
* Procedure ist vorbehalten für Benachrichtigungen mit GRUND=70 
* Parameter :
*    aVorschriftid - id von voschrift
*    aBereich      - geänderter Bereich im Vorschrift: ='Datum' oder ='Themen' oder ='Laender'
*    benutzerId    - id von benutzer , der die Änderungen vornimmt
*/
 PROCEDURE  pBenachricht_Mfv_Arbeitskreise(
   aVorschriftid in number, aBereich in varchar2, benutzerId in number)
     is                              
    lBenachricht_ids varchar2(900);
    lAkIds_for_update varchar2(900);
    lAkIds_for_insert varchar2(900);
    lAk_Idliste  varchar2(900);
    nGrund70_bereich number := 0;
BEGIN
  -- all ak of MFVs for given Vorschrift
  select  listagg(distinct et_b_akid,':') within group (order by et_b_akid)
    into lAk_Idliste
    from (
     select distinct mra.et_b_akid as et_b_akid  --, mrv.letzte_aenderung_datum
       from T_MFV_REF_VORSCHRIFT mrv
       join T_MFV m             on (mrv.mfvid = m.mfvid)
       join T_MFV_REF_et_b_ak mra on (mra.mfvid = m.mfvid)
        -- join T_VORSCHRIFT_REF_et_b_ak vra on (vra.VORSCHRIFTid = mrv.VORSCHRIFTid)
      where mrv.VORSCHRIFTid = aVorschriftid  

     MINUS     -- ak von Benutzer 
     select arb.et_b_akid as et_b_akid
       from T_et_b_ak_ref_benutzer arb
      where arb.benutzerid = benutzerId
  );
   -- inform über änderung in Themen_liste
  -- empty do nothing 
  IF( length(lAk_Idliste) > 1) THEN
     select decode(aBereich, 'Datum', 1,'Themen', 2, 'Laender', 3, null) into nGrund70_bereich from dual;
     IF aBereich = 'Themen' then
       select listagg(benachrichtigungId, ':') within group (order by benachrichtigungId),
           listagg(ArbeitskreisId, ':') within group (order by ArbeitskreisId)
         into lBenachricht_ids, lAkIds_for_update
         from t_benachrichtigung 
        where vorschriftid = aVorschriftid and GRUND =70 
          and erstellung_datum > sysdate -1
          and arbeitskreisid in (select column_value from table (apex_string.split_numbers(lAk_Idliste,':')));
          --and GRUND70_THEMEN not in (1);
          
        if (length(lAkIds_for_update)>1) then
           UPDATE t_benachrichtigung set benachrichtigung_text = benachrichtigung_text || ', ' || aBereich ,
                                   GRUND70_THEMEN =1
            WHERE benachrichtigungId in ( select column_value from table (apex_string.split_numbers(lBenachricht_ids,':')))
            and (GRUND70_THEMEN is null or GRUND70_THEMEN not in (1));
        end if;
        
     ELSIF aBereich = 'Datum' then
        select listagg(benachrichtigungId, ':') within group (order by benachrichtigungId),
           listagg(ArbeitskreisId, ':') within group (order by ArbeitskreisId)
         into lBenachricht_ids, lAkIds_for_update
         from t_benachrichtigung 
        where vorschriftid = aVorschriftid and GRUND =70 
          and erstellung_datum > sysdate -1
          and arbeitskreisid in (select column_value from table (apex_string.split_numbers(lAk_Idliste,':')));
          --and GRUND70_DATUM not in (1);
          
        if (length(lAkIds_for_update)>1) then
           UPDATE t_benachrichtigung set benachrichtigung_text = benachrichtigung_text || ', ' || aBereich ,
                                   GRUND70_DATUM =1
            WHERE benachrichtigungId in ( select column_value from table (apex_string.split_numbers(lBenachricht_ids,':')))
            and (GRUND70_DATUM is null or GRUND70_DATUM not in (1));
        end if;
     ELSE  -- if aBereich = 'Laender' then
        select listagg(benachrichtigungId, ':') within group (order by benachrichtigungId),
           listagg(ArbeitskreisId, ':') within group (order by ArbeitskreisId)
         into lBenachricht_ids, lAkIds_for_update
         from t_benachrichtigung 
        where vorschriftid = aVorschriftid and GRUND =70 
          and erstellung_datum > sysdate -1
          and arbeitskreisid in (select column_value from table (apex_string.split_numbers(lAk_Idliste,':')));
          --and GRUND70_LAENDER not in (1);
          
        if (length(lAkIds_for_update)>1) then
           UPDATE t_benachrichtigung set benachrichtigung_text = benachrichtigung_text || ', ' || aBereich ,
                                   GRUND70_LAENDER =1
            WHERE benachrichtigungId in ( select column_value from table (apex_string.split_numbers(lBenachricht_ids,':')))
            and (GRUND70_LAENDER is null or GRUND70_LAENDER not in (1));
        end if;
     END IF;
    
  -- insert Nachricht für  restliche Arbeitskreise
  
    SELECT listagg(distinct ArbeitskreisId, ':') within group (order by ArbeitskreisId)
      into lAkIds_for_insert
      FROM
     ( select column_value as ArbeitskreisId from table (apex_string.split_numbers(lAk_Idliste,':'))
      MINUS
      select column_value as ArbeitskreisId from table (apex_string.split_numbers(lAkIds_for_update,':'))
     );
     
     if (length(lAkIds_for_insert)>1) then
         pBenachrichtigung( aVorschriftid, lAkIds_for_insert,
               ' Vorschrift wurde geändert in Bereichen: ' || aBereich, 70, 0, benutzerId, nGrund70_bereich );
     end if;
     
  END IF;
END;

procedure pBenachrichtigung_MFV_Gueltigkeit
 is
     cur_v number :=0;
     cur_mfv number :=0;
     cur_aks varchar2(600);
 begin
 
   FOR cu in (select mrv.vorschriftid vorschriftid, mrv.mfvid mfvid,          --vra.et_b_akid
                   listagg(vra.et_b_akid,':') within group (order by vra.et_b_akid) aks
               from T_MFV_ref_vorschrift mrv
               join t_Vorschrift_ref_et_b_ak vra on (vra.vorschriftid = mrv.vorschriftid)
               join t_mfv m on (m.mfvid = mrv.mfvid and nvl(m.gueltigkeitsdatum, m.erstellung_datum +730) <sysdate and m.dms_dokumentenstatus !=30)   
               group by mrv.vorschriftid, mrv.mfvid)
   LOOP
       cur_v:= cu.vorschriftid;
       cur_mfv := cu.mfvid;
       pBenachrichtigung(cur_v, cu.aks, 'Gültigkeitsdatum von MFV ist abgelaufen', 80, 0, null, null, cur_mfv);
   
   END LOOP;
 end;
 
 /**
 * soll 1 mal pro Quartal ausgeführt werden . Prüft Einsatzdaten für  für Vorschriften mit "in Kraft" in Vergangenheit.
 * Erzeugt Benachrichtigung (Grund 100) für Arbeitskreise des Vorschrifts
 */
 procedure pWarnungEinsatzdatum
 is
   l_arbeitskreise varchar2(3000);
   l_co number :=0;
  begin
  
  -- 1.1
  for cur in (select distinct v.VORSCHRIFTid VORSCHRIFTid --, v.EINSATZDATUM_MODELLID, einsatzdatum --, vre.EINSATZDATUM_TYPID, vre.einsatzdatum  
                from T_VORSCHRIFT_REF_EINSATZDATUM_TYP vre 
             join T_Vorschrift v on (v.vorschriftid = vre.vorschriftid)
            where v.EINSATZDATUM_MODELLID = 10 and  vorschrift_statusid = 40  
                and vre.EINSATZDATUM_TYPid in (1010, 1011) and einsatzdatum is null)
   loop
      l_arbeitskreise:=''; --reset
      select count(*) into l_co  from t_vorschrift_ref_et_b_ak where VORSCHRIFTid = cur.Vorschriftid;
      if(l_co > 0 ) then
             select listagg(distinct et_b_akid, ':') within group (order by et_b_akid)
               into l_arbeitskreise
               from t_vorschrift_ref_et_b_ak 
              where VORSCHRIFTid = cur.Vorschriftid;
           -- send message  typ 100 -einsatzdatum nicht gesetzt
           --debug('Benachricht 100 for vorsch.ID ='||cur.Vorschriftid, 'a-kreise = '||l_arbeitskreise);
           pbenachrichtigung(cur.Vorschriftid , l_arbeitskreise , 
            'Mindestens ein Wert in entweder Datum neue Typen ODER Datum alle Fahrzeuge ist notwendig', 100, 
                                            aLoeschmarker => 0, aBenutzerid => pck_ri.fgetUserId );
      end if;
    end loop;
      -- 1.2  Alle fZG Oder Neue Typ   
    for cur in ( select distinct v.VORSCHRIFTid --, v.EINSATZDATUM_MODELLID
              from T_Vorschrift v where  v.EINSATZDATUM_MODELLID = 10 and vorschrift_statusid = 40 --enacted
             and VORSCHRIFTid not in (select distinct VORSCHRIFTid from T_VORSCHRIFT_REF_EINSATZDATUM_TYP vre 
                             where vre.EINSATZDATUM_TYPid in (1010, 1011) and (vre.einsatzdatum is not null or vre.einsatzdatum >= sysdate ))
                             order by vorschriftid)
   loop
      l_arbeitskreise:=''; --reset
      select count(*) into l_co  from t_vorschrift_ref_et_b_ak where VORSCHRIFTid = cur.Vorschriftid;
      if(l_co > 0 ) then
             select listagg(distinct et_b_akid, ':') within group (order by et_b_akid)
               into l_arbeitskreise
               from t_vorschrift_ref_et_b_ak 
              where VORSCHRIFTid = cur.Vorschriftid;
           -- send message  typ 100 -einsatzdatum nicht gesetzt
          -- debug('Benachricht. 100 for vorsch.ID ='||cur.Vorschriftid, 'a-kreise = '||l_arbeitskreise);
           pbenachrichtigung(cur.Vorschriftid , l_arbeitskreise ,
           'Mindestens ein Wert in entweder Datum neue Typen ODER Datum alle Fahrzeuge ist notwendig', 100, 
                                            aLoeschmarker => 0, aBenutzerid => pck_ri.fgetUserId );
      end if;
   end loop;
   
    -- 2.1
  for cur in (select distinct v.VORSCHRIFTid VORSCHRIFTid 
                from T_VORSCHRIFT_REF_EINSATZDATUM_TYP vre 
             join T_Vorschrift v on (v.vorschriftid = vre.vorschriftid)
            where v.EINSATZDATUM_MODELLID = 20 and  vorschrift_statusid = 40  
                and vre.EINSATZDATUM_TYPid in (1020, 1021, 1022, 1023) and einsatzdatum is null order by v.vorschriftid)
   loop
      l_arbeitskreise:=''; --reset
      select count(*) into l_co  from t_vorschrift_ref_et_b_ak where VORSCHRIFTid = cur.Vorschriftid;
      if(l_co > 0 ) then
             select listagg(distinct et_b_akid, ':') within group (order by et_b_akid)
               into l_arbeitskreise
               from t_vorschrift_ref_et_b_ak 
              where VORSCHRIFTid = cur.Vorschriftid;
           -- send message  typ 100 -einsatzdatum nicht gesetzt
          -- debug('Benachricht 100 for vorsch.ID ='||cur.Vorschriftid, 'a-kreise = '||l_arbeitskreise);
           pbenachrichtigung(cur.Vorschriftid , l_arbeitskreise , 
            'Mindestens ein Wert in entweder Datum neue Typen FBU ODER Datum alle Fahrzeuge FBU ODER Datum neue Typen CKD ODER Datum alle Fahrzeuge CKD ist notwendig',
             100,  aLoeschmarker => 0, aBenutzerid => pck_ri.fgetUserId );
      end if;
    end loop;
    -- 2.2  ----------
     for cur in (select v.VORSCHRIFTid, v.EINSATZDATUM_MODELLID
    from T_Vorschrift v where  v.EINSATZDATUM_MODELLID = 20 and vorschrift_statusid = 40 --enacted
   and VORSCHRIFTid not in (select distinct VORSCHRIFTid from T_VORSCHRIFT_REF_EINSATZDATUM_TYP vre 
                             where vre.EINSATZDATUM_TYPid in (1020, 1021, 1022, 1023) and ( vre.einsatzdatum is not null or vre.einsatzdatum >= sysdate ))
                             order by vorschriftid)
   loop
      l_arbeitskreise:=''; --reset
      select count(*) into l_co  from t_vorschrift_ref_et_b_ak where VORSCHRIFTid = cur.Vorschriftid;
      if(l_co > 0 ) then
             select listagg(distinct et_b_akid, ':') within group (order by et_b_akid)
               into l_arbeitskreise
               from t_vorschrift_ref_et_b_ak 
              where VORSCHRIFTid = cur.Vorschriftid;

          -- debug('Benachricht 100 for vorsch.ID ='||cur.Vorschriftid, 'a-kreise = '||l_arbeitskreise);
           pbenachrichtigung(cur.Vorschriftid , l_arbeitskreise , 
            'Mindestens ein Wert in entweder Datum neue Typen FBU ODER Datum alle Fahrzeuge FBU ODER Datum neue Typen CKD ODER Datum alle Fahrzeuge CKD ist notwendig',
             100,  aLoeschmarker => 0, aBenutzerid => pck_ri.fgetUserId );
      end if;
   end loop;
   
   -- 3.1  Modeljahr
  for cur in (select distinct v.VORSCHRIFTid VORSCHRIFTid --, v.EINSATZDATUM_MODELLID, einsatzdatum --, vre.EINSATZDATUM_TYPID, vre.einsatzdatum  
                from T_VORSCHRIFT_REF_EINSATZDATUM_TYP vre 
             join T_Vorschrift v on (v.vorschriftid = vre.vorschriftid)
            where v.EINSATZDATUM_MODELLID = 30 and  vorschrift_statusid = 40  
                and vre.EINSATZDATUM_TYPid in (1030, 1031) and einsatzdatum is null)
   loop
      l_arbeitskreise:=''; --reset
      select count(*) into l_co  from t_vorschrift_ref_et_b_ak where VORSCHRIFTid = cur.Vorschriftid;
      if(l_co > 0 ) then
             select listagg(distinct et_b_akid, ':') within group (order by et_b_akid)
               into l_arbeitskreise
               from t_vorschrift_ref_et_b_ak 
              where VORSCHRIFTid = cur.Vorschriftid;
           -- 
          -- debug('Benachricht 100 for vorsch.ID ='||cur.Vorschriftid, 'a-kreise = '||l_arbeitskreise);
           pbenachrichtigung(cur.Vorschriftid , l_arbeitskreise , 
            'Mindestens ein Wert in entweder Phasein Start ODER Phasein End ist notwendig', 100, 
                                            aLoeschmarker => 0, aBenutzerid => pck_ri.fgetUserId );
      end if;
    end loop;
    -- 3.2   Modeljahr   --
    for cur in ( select distinct v.VORSCHRIFTid --, v.EINSATZDATUM_MODELLID
              from T_Vorschrift v where  v.EINSATZDATUM_MODELLID = 30 and vorschrift_statusid = 40 --enacted
             and VORSCHRIFTid not in (select distinct VORSCHRIFTid from T_VORSCHRIFT_REF_EINSATZDATUM_TYP vre 
                             where vre.EINSATZDATUM_TYPid in (1030, 1031) and (vre.einsatzdatum is not null or vre.einsatzdatum >= sysdate ))
                             order by vorschriftid)
   loop
      l_arbeitskreise:=''; --reset
      select count(*) into l_co  from t_vorschrift_ref_et_b_ak where VORSCHRIFTid = cur.Vorschriftid;
      if(l_co > 0 ) then
             select listagg(distinct et_b_akid, ':') within group (order by et_b_akid)
               into l_arbeitskreise
               from t_vorschrift_ref_et_b_ak 
              where VORSCHRIFTid = cur.Vorschriftid;
           -- send message  typ 100 -einsatzdatum nicht gesetzt
         --  debug('Benachricht. 100 for vorsch.ID ='||cur.Vorschriftid, 'a-kreise = '||l_arbeitskreise);
           pbenachrichtigung(cur.Vorschriftid , l_arbeitskreise , 
           'Mindestens ein Wert in entweder Phasein Start ODER Phasein End ist notwendig', 100, 
                                            aLoeschmarker => 0, aBenutzerid => pck_ri.fgetUserId );
      end if;
   end loop;
   
end;
  
  procedure pBenachrichtigung_Statuswechsel( aVorschriftid number, auserid number) as
 
   
    l_arbeitskreise varchar2(2000);
  begin 
    --ermittle eigene AK 
  select listagg(et_b_akid, ':') within group (order by et_b_akid) into l_arbeitskreise 
      from T_VORSCHRIFT_REF_ET_B_AK 
     where Vorschriftid = aVorschriftid
       AND et_b_akid NOT IN ( select et_b_akid from t_et_b_ak_ref_benutzer  where benutzerid = auserid );
   
    if (l_arbeitskreise is not null and length(l_arbeitskreise)>1 ) then
        pbenachrichtigung(aVorschriftid , l_arbeitskreise , 
            'Vorschrift Status ist gewechselt zu  "VKO/VEX Bearbeitung" ',
             110,  aLoeschmarker => 0, aBenutzerid => auserid );
    end if;
  end;
  
  --**
  procedure  pBenachrichtigung_fremdzuweisung2(
  aVorschriftid in number, lThemenIdliste in varchar2, abenutzerId in number)
     is                                
    lUser_Themas varchar2(1000);
    list_Ak varchar2(1000);
    list_fremd_T varchar2(1000);
begin  
   select listagg(distinct vrt.themaid,',') within group (order by vrt.themaid)  into lUser_Themas
                from T_ET_B_AK_REF_Benutzer arb
                join t_ET_B_AK_VKO_REF_THEMA  vrt on (vrt.ET_B_AK_VKOid = arb.ET_B_AK_REF_BenutzerID)
                where arb.benutzerId = abenutzerId;
                --dbms_output.put_line(lThemenliste.count);
  --debug('in proc: lUser_Themas=', lUser_Themas);
  select listagg(distinct x.column_value ,':') within group (order by x.column_value ) into list_fremd_T 
    from table (apex_string.split_numbers(lThemenIdliste,':')) x 
   where x.column_value not in (select column_value from table (apex_string.split_numbers(lUser_Themas,':')));
       -- ////test
       --select listagg(distinct x.column_value ,':') within group (order by x.column_value ) --into list_fremd_T 
       --from table (apex_string.split_numbers('100:1200:134',':'))x
      -- where x.column_value not in (select column_value from table (apex_string.split_numbers('101:100:1300:135',':')));
      --//////
    --debug('list_fremd_T=', list_fremd_T);
     select listagg(distinct vra.et_b_akid,':') within group (order by vra.et_b_akid)
      into list_Ak
      from T_Vorschrift_ref_ET_B_AK vra   
      join T_Thema_ref_et_b_ak tra on (vra.et_b_akid = tra.et_b_akid )
     where tra.themaid in ( select column_value from table( APEX_STRING.split_numbers(list_fremd_T, ':')))
       and tra.themaid is not null
       and vra.et_b_akid not in ( select et_b_akid from T_et_b_ak_ref_benutzer where benutzerid = pck_ri.fgetUserId );  -- eigene AK von VKO ausschliessen
        -- vra.vorschriftid= avorschriftid
    --debug('list_Ak=', list_Ak);
     if (length(list_Ak)>1) then
        pBenachrichtigung( aVorschriftid, list_Ak,
               'Themengebiet prüfen da Fremdarbeitskreisvergabe', 60, 0 , abenutzerId);
     end if;
end;

/**
  Wenn Nachfolger andere Themengebietszuordnungen hat als Vorgänger:
  Versendung an alle Arbeitskreise die entweder fehlen oder zusätzlich zugeordnet sind
 */
 procedure pThemenDiff_Vorgaenger(aVorschriftid in number, auserid in number ) is

  lst_vorgaengerIds Varchar2(2000);
  lst_nachfolgerIds Varchar2(2000);
  l_co number :=0;
  list_Ak Varchar2(2000);
  list_Ak_nachf Varchar2(2000);
begin
  -- 1. suche vorgaenger 
   select  count(*) into l_co  from t_vorschrift_ref_vorschrift 
    where beziehung_art = 10 and nachfolger_vorschriftid = aVorschriftid ;
   if(l_co >0) then
        select  listagg(vorgaenger_vorschriftid, ':' ) within group (order by vorgaenger_vorschriftid)
          into lst_vorgaengerIds
          from t_vorschrift_ref_vorschrift 
         where beziehung_art = 10 and nachfolger_vorschriftid = aVorschriftid ;

    WITH vorg_th as ( 
          select themaid from t_vorschrift_ref_thema 
            where geloescht!=1 and vorschriftid in 
                        ( select column_value from table(apex_string.split_numbers(lst_vorgaengerIds, ':')) )  
    ),
    eig_th as ( select themaid from t_vorschrift_ref_thema  where geloescht!=1 and vorschriftid in ( aVorschriftid)
    )    
     SELECT listagg(distinct et_b_akid, ':') within group (order by et_b_akid) into list_Ak
     from
     (
       select distinct et_b_akid    
         from T_thema_ref_et_b_ak tra
         join eig_th on (eig_th.themaid = tra.themaid)
         join vorg_th on (vorg_th.themaid != tra.themaid)
       UNION
        select distinct et_b_akid   
         from T_thema_ref_et_b_ak tra 
         join vorg_th on (vorg_th.themaid = tra.themaid)
         join eig_th on (eig_th.themaid != tra.themaid)
     ) ; 
     if (list_Ak is not null and length(list_Ak)>1 ) then
         pBenachrichtigung(aVorschriftid, list_Ak,
               'Unterschiedliche Themengebietszuordnungen zwischen Vorgänger und Nachfolger einer Vorschrift', 120, 0, auserid );
      end if;
   end if;
    --2. nachfolger themas
   select count(*) into l_co from t_vorschrift_ref_vorschrift 
    where beziehung_art = 10 and vorgaenger_vorschriftid = aVorschriftid ;
   if(l_co >0) then
        select listagg(nachfolger_vorschriftid, ':' ) within group (order by nachfolger_vorschriftid)
          into lst_nachfolgerIds
          from t_vorschrift_ref_vorschrift 
         where beziehung_art = 10 and vorgaenger_vorschriftid = aVorschriftid ;
         
       WITH nachf_th as ( 
          select themaid from t_vorschrift_ref_thema 
            where geloescht!=1 and vorschriftid in 
                        ( select column_value from table(apex_string.split_numbers(lst_nachfolgerIds, ':')) )  
      ),
       eig_th as ( select themaid from t_vorschrift_ref_thema  where geloescht!=1 and vorschriftid in ( aVorschriftid)
      )    
      SELECT listagg(distinct et_b_akid, ':') within group (order by et_b_akid) into list_Ak_nachf
      from
      (
       select distinct et_b_akid    
         from T_thema_ref_et_b_ak tra
         join eig_th on (eig_th.themaid = tra.themaid)
         join nachf_th on (nachf_th.themaid != tra.themaid)
       UNION
        select distinct et_b_akid   
         from T_thema_ref_et_b_ak tra 
         join nachf_th on (nachf_th.themaid = tra.themaid)
         join eig_th on (eig_th.themaid != tra.themaid)
      ) 
      where list_Ak is null OR et_b_akid not in (select column_value from table(apex_string.split_numbers(list_Ak, ':'))) ; 
      if (list_Ak_nachf is not null and length(list_Ak_nachf)>1 ) then
          pBenachrichtigung(aVorschriftid, list_Ak_nachf,
               'Unterschiedliche Themengebietszuordnungen zwischen Vorgänger und Nachfolger einer Vorschrift', 120, 0, auserid );
      end if;
   end if;
end;


  
END PCK_RI_BENACHRICHTIGUNG;
```



/* PCK RI COCKPIT */

-- SPECIFICATION

```
create or replace PACKAGE                      "PCK_RI_COCKPIT" AS 

    type tConfig is record (
        laenderliste apex_t_number,
        themenliste apex_t_number
    );
    lConfig tConfig;

    cursor lCursorCockpit is


        with cte_laender_pre as (
            select column_value landid, rownum as land_sortorder
            from table(lConfig.laenderliste) x
        ),cte_laender as (
            -- Alle selektierten Länder unter Beachtung der Reihenfolge
            select x.landid, x.land_sortorder, l.b_nummer, l.besonderheiten
            from cte_laender_pre x  
            join t_land l on (x.landid = l.landid)
        ), cte_thema_filter as (
            select column_value themaid, rownum as thema_sortorder
            from table(lConfig.themenliste)        
        ), cte_thema_baum as (
            select tf.themaid, bezeichnung, xlevel, tf.thema_sortorder, nummer, leaf as thema_leaf, parentid
            from cte_thema_filter tf
            join v_thema_baum tb on (tf.themaid = tb.themaid)
            order by tf.thema_sortorder
/*        ), cte_nachfolgerdaten as (
            select vorgaenger_vorschriftid vorgaengerid, v.vorschriftid nf_vorschriftid, v.vorschrift_nummer nf_nummer,
            o.x as nf_datumsangaben
            from t_vorschrift_ref_vorschrift vrv
            join t_vorschrift v on (vrv.nachfolger_vorschriftid = v.vorschriftid)            
            outer apply (
                select cast(collect(t_einsatzdatum(einsatzdatum_typid, null, null, einsatzdatum, substr(einsatzdatum_text,1,2000), null, null)) as t_einsatzdatum_table) as x
                from t_vorschrift_ref_einsatzdatum_typ e
                where e.vorschriftid = v.vorschriftid
            ) o
            where vrv.beziehung_art = 10*/
        ), cte_vorschriften as (
            select
                lpad(' ',xlevel-1,' ') || t.bezeichnung as thema_bezeichnung, t.thema_sortorder,
                t.nummer thema_nummer, t.themaid, l.b_nummer, l.landid, l.besonderheiten, t.thema_leaf, 
                t.xlevel thema_level, t.parentid thema_parent_themaid, v.vorschriftid, 
                case when v.landid is null then 0 else count(v.landid) over (partition by v.landid, v.themaid) end anz_vorschriften_in_land,
                row_number() over (partition by v.themaid, v.landid order by v.vorschriftid) sort_in_land,
                v.vorschrift_bezeichnung, v.vorschrift_nummer, v.rr_vorschriftid, v.rr_vorschrift_nummer,
                l.land_sortorder,
                v.nf_vorschrift_nummer nf_nummer, v.nf_datumsangaben, v.nf_vorschriftid
            from cte_thema_baum t
            cross join cte_laender l
            join mv_cockpit2_neu v on (t.themaid = v.themaid and l.landid = v.landid)
            join t_vorschrift vs on (v.vorschriftid = vs.vorschriftid)
            where (vs.vorschrift_freigabestatusid = 20 or pck_ri.fIsLimitedUser = 0)            
            order by thema_sortorder, land_sortorder          
        )
        select
            t_cockpit(
                v.thema_bezeichnung,
                v.thema_sortorder,
                v.thema_nummer,
                v.themaid,
                v.b_nummer,
                v.landid,
                v.thema_leaf,
                v.thema_level,
                v.thema_parent_themaid,
                v.vorschriftid,
                v.anz_vorschriften_in_land,
                v.sort_in_land,
                v.land_sortorder,
                max(anz_vorschriften_in_land) over (partition by themaid),
                v.vorschrift_bezeichnung,
                v.vorschrift_nummer,
                v.nf_vorschriftid,
                v.nf_nummer,
                v.nf_datumsangaben,
                v.rr_vorschriftid,
                v.rr_vorschrift_nummer,
                v.besonderheiten
            )
        from cte_vorschriften v
        order by thema_sortorder, sort_in_land, land_sortorder;                    


    cursor lCursorLaender is
        with cte1 as (
            select column_value landid, rownum as xrownum
            from table(lConfig.laenderliste) 
        )
        select l.b_nummer, l.landid, l.land, nvl(l.einsatzdatum_modellid,10) as einsatzdatum_modellid, y.anzahl as anzahl_einsatzdaten,
            y.einsatzdaten, lg.liste_laendergruppen, l.betaflag, l.besonderheiten
        from t_land l        
        join cte1 x on (l.landid = x.landid)
        outer apply (
            select count(*) as anzahl,
                cast(collect(t_einsatzdatum(einsatzdatum_typid, einsatzdatum_typ, kurztext, null, null, null, null) order by einsatzdatum_typid) as t_einsatzdatum_table) einsatzdaten
            from t_einsatzdatum_typ
            where einsatzdatum_modellid is null or einsatzdatum_modellid = nvl(l.einsatzdatum_modellid,10)
            order by einsatzdatum_typid
        ) y
        outer apply (
            select listagg(lg.laendergruppe,', ') liste_laendergruppen
            from t_land_ref_laendergruppe lrlg
            join t_laendergruppe lg on (lrlg.laendergruppeid = lg.laendergruppeid)
            where lrlg.landid = l.landid
        ) lg
        order by x.xrownum;    

    type tLaenderListe is table of lCursorLaender%rowtype;
    lLaenderListe tLaenderListe;

    cursor lCursorEinsatzdatumTyp is
        select * from t_einsatzdatum_typ order by einsatzdatum_typid;

    type tEinsatzdatumTypTable is table of lCursorEinsatzdatumTyp%rowtype;
    lEinsatzdatumTypTable tEinsatzDatumTypTable;


    lCockpit t_cockpit_table;


    procedure pMain(aLaenderListe varchar2, aThemenListe varchar2);
    procedure pLaenderListe;
    procedure pInhalt;

END PCK_RI_COCKPIT;
```

-- BODY

```
create or replace PACKAGE BODY                      "PCK_RI_COCKPIT" AS

    procedure pMain(aLaenderListe varchar2, aThemenListe varchar2) is
    begin

        if (aLaenderListe is null) then
            select landid bulk collect into lConfig.laenderliste from t_land;
        else 



            lConfig.laenderliste := apex_string.split_numbers(aLaenderListe,':');
        end if;

        if (aThemenListe is null) then
            select themaid bulk collect into lConfig.themenliste from v_thema_baum order by thema_sortorder;
        else 

            select themaid bulk collect into lConfig.themenliste
            from t_thema
            connect by prior parentid = themaid
            start with themaid in (select column_value from apex_string.split_numbers(aThemenListe,':'));                
            --lConfig.themenliste := apex_string.split_numbers(aThemenListe,':');
        end if;   

        open lCursorEinsatzdatumTyp;
        fetch lCursorEinsatzdatumTyp bulk collect into lEinsatzdatumTypTable;
        close lCursorEinsatzdatumTyp;

        -- Beginn Tabelle
        htp.p('<table class="cockpit tg">');

        -- Beginn Überschriften-Zeile
        htp.p('<thead><tr>');

        -- Leere Zelle ganz oben links
        htp.p('<th rowspan=2 colspan=2 style="text-align: left; vertical-align: bottom">');
        htp.p('<a href="javascript:tgexpandall()"><span class="fa fa-plus-square" alt="Alle aufklappen" title="Alle aufklappen"></span></a>');
        htp.p('<a href="javascript:tgcollapseall()"><span class="fa fa-minus-square" alt="Alle zuklappen" title="Alle zuklappen"></span></a>');        
        htp.p('</th>');

        -- Länder-Überschriften
        pLaenderListe;

        -- Ende Überschriften-Zeile
        htp.p('</thead>');

        -- Beginn Table body
        htp.p('<tbody>');

        pInhalt;            

        -- Ende Table body
        htp.p('</tbody>');

        -- Ende Tabelle
        htp.p('</table>');

    END pMain;

    procedure pLaenderListe is

        lFlagUrl varchar2(250);
        lMarktBesonderheitenUrl varchar2(500);
    begin

        open lCursorLaender;
        fetch lCursorLaender bulk collect into lLaenderListe;
        close lCursorLaender;

        for lIndex in 1 .. lLaenderListe.count
        loop
            lFlagUrl := apex_page.get_url(p_page => 0, p_items => 'G_LANDID', p_values => lLaenderListe(lIndex).landid, p_request => 'APPLICATION_PROCESS=getFlag');
            lMarktBesonderheitenUrl := apex_page.get_url(p_page => 136, p_items => 'P136_LAENDER', p_values => lLaenderListe(lIndex).landid, p_clear_cache => 136);
            --htp.p('<th class="land" colspan=' || (lLaenderListe(lIndex).anzahl_einsatzdaten+2) || ' style="background-image: url(''' || lFlagUrl || ''')">' || lLaenderListe(lIndex).b_nummer || ' - ' || lLaenderListe(lIndex).land || '<div class="laendergruppen">' || lLaenderListe(lIndex).liste_laendergruppen || '</div></th>');
            htp.p('<th class="fbl land" colspan=' || (lLaenderListe(lIndex).anzahl_einsatzdaten+2) || '>');
            htp.p('<div class="landcontainer">');
            htp.p('<div class="landl">' || lLaenderListe(lIndex).b_nummer || ' - ' || lLaenderListe(lIndex).land || '<div class="laendergruppen">' || lLaenderListe(lIndex).liste_laendergruppen || '</div></div>');
            if (lLaenderListe(lIndex).BESONDERHEITEN is not null) then
                htp.p('<div class="landbesonderheiten"><a href="' || lMarktBesonderheitenUrl || '"><span class="fa fa-info-square-o fa-2x" aria-hidden="true" title="Kommentar zu diesem Land prüfen"></span></a></div>');
            end if;
            if (lLaenderListe(lIndex).betaflag = 1) then
                htp.p('<div class="landb"><img src="' || v('APP_IMAGES') || 'beta1.jpg" /></div>');
            end if;            
            htp.p('<div class="landr"><img src="' || lFlagUrl || '"/></div>');
            htp.p('</div>');
            htp.p('</th>');
        end loop;

        htp.p('</tr><tr>');

        for lIndex in 1 .. lLaenderListe.count
        loop
            htp.p('<th class="fbl landed">Vorschrift</th><th class="landed">Nachfolger</th>');
            for lIndexDatum in 1..lLaenderListe(lIndex).einsatzdaten.count
            loop
                htp.p('<th class="landed">' || lLaenderListe(lIndex).einsatzdaten(lIndexDatum).einsatzdatum_typ || '</th>');                
            end loop;            
        end loop;    

        htp.p('</tr>');

    end pLaenderListe;

    function fTdClass(aClassFBL in number,aClassFBT in number) return varchar2 is

    begin
        return
            '<td' ||
            case when aClassFBL = 1 or aClassFBT = 1 then ' class="' end ||
            case aClassFBL when 1 then 'fbl' else null end ||
            case when aClassFBL = 1 or aClassFBT = 1 then ' ' end ||
            case aClassFBT when 1 then 'fbt' else null end ||
            case when aClassFBL = 1 or aClassFBT = 1 then '"' end ||
            '>';

    end fTdClass;

    procedure pInhalt is
        lCount number;
        lRowspan number;
        lRowspanIndex number;
        lZelle t_cockpit;
        lLandZeile t_cockpit_table;
        lSkipLaender number;
        lEinsatzdatumTable t_einsatzdatum_table;
        lEinsatzdatum t_einsatzdatum;        
    begin

        open lCursorCockpit;
        fetch lCursorCockpit bulk collect into lCockpit;
        close lCursorCockpit;

        for lThema in (select * from v_thema_baum where themaid in (select column_value from table(lConfig.themenliste))) loop       

            select nvl(max(anz_vorschriften_in_land),1) into lRowspan
            from table(lCockpit) x
            where x.themaid = lThema.themaid;

            debug(lThema.bezeichnung, lRowspan);

            htp.p('<tr class="tgtr" tgid="' || lThema.themaid || '" tgparent="' || lThema.parentid || '" tgisleaf="' || lThema.leaf || '" tglevel="' || lThema.xlevel || '">');
            htp.p('<th tid="' || lThema.themaid || '" tnummer="' || lThema.nummer || '" tname="' || lThema.bezeichnung || '" class="themanum tg tgcollapsible fbt tmenu" rowspan="' || lRowspan || '">' || lThema.nummer || '</th>');
                htp.p('<th tid="' || lThema.themaid || '" tnummer="' || lThema.nummer || '" tname="' || lThema.bezeichnung || '" class="thema fbt tmenu" alt="' || lThema.bezeichnung || '" title="' || lThema.bezeichnung || '" rowspan="' || lRowspan || '"><div class="themaBez" ' || case lThema.beta_flag when 10 then ' style="width: 80%"' else null end || '>' || lThema.bezeichnung  || '</div>' || case lThema.beta_flag when 10 then '<img class="themaBeta" src="' || v('APP_IMAGES') || 'beta1.jpg" /></div>' else null end || '</th>');  

            for lRowspanIndex in 1..lRowSpan loop

                lSkipLaender := 0;

                select t_cockpit(

                        x.thema_bezeichnung,
                        x.thema_sortorder,
                        x.thema_nummer,
                        x.themaid,
                        x.b_nummer,
                        x.landid,
                        x.thema_leaf,
                        x.thema_level,
                        x.thema_parent_themaid,
                        x.vorschriftid,
                        x.anz_vorschriften_in_land,
                        x.sort_in_land,
                        x.land_sortorder,
                        x.anz_vorschriften_in_land,
                        x.vorschrift_bezeichnung,
                        x.vorschrift_nummer,
                        x.nachfolgerid,
                        x.nf_nummer,
                        x.nf_datumsangaben,
                        x.rr_vorschriftid,
                        x.rr_vorschrift_nummer,
                        x.besonderheiten
                    ) bulk collect into lLandZeile
                from table(lCockpit) x 
                where x.themaid = lThema.themaid
                and x.sort_in_land = lRowspanIndex
                order by land_sortorder;

                for lZelle in 1..lLandZeile.count loop

                        while (lLandZeile(lZelle).landid != lLaenderListe(lZelle + lSkipLaender).landid)
                        loop
                            -- Leere Zellen zwischendurch auffüllen
                            -- Anzahl Datumsspalten je nach Land + 2 Spalten für Angabe Vorgänger und Nachfolger
                            for lIndexDatum in 1..lLaenderListe(lZelle + lSkipLaender).anzahl_einsatzdaten+2 loop
                                --htp.p('<td class="' || case lIndexDatum when 1 then ' fbl' else null end || case lRowSpanIndex when 1 then ' fbt' else null end || '"></td>');
                                htp.p(fTdClass(lIndexDatum,lRowSpanIndex) || '</td>');
                            end loop;                        

                            lSkipLaender := lSkipLaender + 1;                    
                        end loop;

                        -- gültige Vorschrift
                        htp.p('<td class="fbl' || case lRowSpanIndex when 1 then ' fbt' else null end || ' vmenu" rrid="' || lLandZeile(lZelle).rr_vorschriftid || '" rrnummer="' || lLandZeile(lZelle).rr_vorschrift_nummer || '" vnummer= "' || lLandZeile(lZelle).vorschrift_nummer || '" vbezeichnung="' || lLandZeile(lZelle).vorschrift_bezeichnung || '" vid="' || lLandZeile(lZelle).vorschriftid || '">'
                              || case when lLandZeile(lZelle).rr_vorschriftid is not null then '<span alt="' || lLandZeile(lZelle).rr_vorschrift_nummer || '" title="' || lLandZeile(lZelle).rr_vorschrift_nummer || '" class="rr"></span>' end
                              || lLandZeile(lZelle).vorschrift_nummer ||

                              '</td>');

                        -- Nachfolger
                        htp.p('<td class="vmenu' || case lRowSpanIndex when 1 then ' fbt' else null end || '" vnummer="' || lLandZeile(lZelle).nf_nummer || '" vid="' || lLandZeile(lZelle).nachfolgerid || '">' || lLandZeile(lZelle).nf_nummer || '</td>');

                        -- Datumsangaben
                        lEinsatzDatumTable := lLaenderListe(lZelle + lSkipLaender).einsatzdaten; --lLandZeile(lZelle).nf_datumsangaben;

                        for lIndexDatum in 1..lEinsatzDatumTable.count
                        loop

                            begin

                                select t_einsatzdatum(einsatzdatum_typid, null, null, einsatzdatum, einsatzdatum_text, null, null) into lEinsatzdatum
                                from table(lLandZeile(lZelle).nf_datumsangaben) x
                                where x.einsatzdatum_typid = lEinsatzdatumTypTable(lIndexDatum).einsatzdatum_typid
                                fetch first 1 rows only;

                                --htp.p('<td class="' || case lRowSpanIndex when 1 then ' fbt' else null end || '">' || lEinsatzdatum.einsatzdatum || '</td>'); 
                                htp.p(fTdClass(-1,lRowSpanIndex) || lEinsatzdatum.einsatzdatum || '</td>');

                            exception
                                when no_data_found then
                                    --htp.p('<td class="' || case lRowSpanIndex when 1 then ' fbt' else null end || '"></td>');
                                    htp.p(fTdClass(-1,lRowSpanIndex) || '</td>');

                            end;
                        end loop;

                end loop;

                for lAuffuellen in lLandZeile.count+1+lSkipLaender .. lLaenderListe.count loop
                    -- Leere Zellen nach den Vorschriften auffüllen
                    -- Anzahl Datumsspalten je nach Land + 2 Spalten für Angabe Vorgänger und Nachfolger
                    for lIndexDatum in 1..lLaenderListe(lAuffuellen).anzahl_einsatzdaten+2 loop
                        --htp.p('<td class="' || case lIndexDatum when 1 then ' fbl' else null end || case lRowSpanIndex when 1 then ' fbt' else null end || '"></td>');
                        htp.p(fTdClass(lIndexDatum,lRowSpanIndex) || '</td>');
                    end loop;
                end loop;

                if (lRowSpanIndex = lRowspan) then
                    -- Ganzes Thema zu Ende
                    htp.p('</tr>');
                else
                    -- Nur Rowspan-Zeile zu Ende
                    htp.p('</tr><tr class="tgtr" tgid="' || lThema.themaid || '" tgparent="' || lThema.parentid || '" tgisleaf="' || lThema.leaf || '" tglevel="' || lThema.xlevel || '">');
                end if;

            end loop;

        end loop;

    end pInhalt;

END PCK_RI_COCKPIT;
```



/* PCK  RI COCKPIT2 */

-- SPECIFICATION

```
create or replace PACKAGE "PCK_RI_COCKPIT2" AS 

    gMaxSpaltenIndex number;
    gMaxZeilenIndex number;

    -- Wenn User Admin oder VKO, dann alle Vorschriften anzeigen, sonst die nicht relevanten ausblenden
    gZeigeAlleVorschriften number := least(pck_ri.fIsUserInRolle(pck_ri.fGetUserID,'1003:1000:1002:1001'),1);


    procedure pAufbereitungDaten;
    procedure pAufbereitungDaten(aLandID in number);

    type tConfig is record (
        laenderliste apex_t_number,
        themenliste apex_t_number,
        themenindexes apex_t_number,
        highlight_vorschrifen apex_t_number,
        highlight_datum number
    );
    lConfig tConfig;  

    cursor lCursorLaender is
        with cte1 as (
            select column_value landid, rownum as xrownum
            from table(lConfig.laenderliste) 
        )
        select l.b_nummer, l.landid, l.land, nvl(l.einsatzdatum_modellid,10) as einsatzdatum_modellid, y.anzahl as anzahl_einsatzdaten,
            y.einsatzdaten, lg.liste_laendergruppen, l.betaflag, l.besonderheiten, 0 as spaltenindex, x.xrownum, 1 as spaltentyp
        from t_land l        
        join cte1 x on (l.landid = x.landid)
        outer apply (
            select count(*) as anzahl,
                cast(collect(t_einsatzdatum(einsatzdatum_typid, einsatzdatum_typ, kurztext, null, null, null, null) order by spaltenindex_cockpit) as t_einsatzdatum_table) einsatzdaten
            from t_einsatzdatum_typ
            where (einsatzdatum_modellid is null or einsatzdatum_modellid = nvl(l.einsatzdatum_modellid,10))
            and spaltenindex_cockpit is not null
             order by spaltenindex_cockpit
        ) y
        outer apply (
            select listagg(lg.laendergruppe,', ') liste_laendergruppen
            from t_land_ref_laendergruppe lrlg
            join t_laendergruppe lg on (lrlg.laendergruppeid = lg.laendergruppeid)
            where lrlg.landid = l.landid
        ) lg
        
        union all
        
        select lg.laendergruppe, x.landid, lg.laendergruppe, nvl(l.einsatzdatum_modellid,10) as einsatzdatum_modellid, y.anzahl as anzahl_einsatzdaten,
            y.einsatzdaten, null as liste_laendergruppen, null as betaflag, null as besonderheiten, 0 as spaltenindex, x.xrownum, 2 as spaltentyp
        from t_laendergruppe lg        
        join cte1 x on ((lg.laendergruppeid + 1e7) = x.landid) 
        outer apply (
            select einsatzdatum_modellid
            from t_land l
            join t_land_ref_laendergruppe lrl on (l.landid = lrl.landid)
            where lrl.laendergruppeid = lg.laendergruppeid
            fetch first 1 rows only
        ) l
        outer apply (
            select count(*) as anzahl,
                cast(collect(t_einsatzdatum(einsatzdatum_typid, einsatzdatum_typ, kurztext, null, null, null, null)  order by spaltenindex_cockpit) as t_einsatzdatum_table) einsatzdaten
            from t_einsatzdatum_typ
            where (einsatzdatum_modellid is null or einsatzdatum_modellid = nvl(l.einsatzdatum_modellid,10))
            and spaltenindex_cockpit is not null
             order by spaltenindex_cockpit
        ) y
        
        order by xrownum;    

    type tLaenderListe is table of lCursorLaender%rowtype;
    lLaenderListe tLaenderListe;

    procedure pInit(aLaenderListe in varchar2, aThemenListe in varchar2, aHighlightVorschriften in varchar2 default null, aHighlightDatumAenderungMonate in number default 0, aLaendergruppenListe in varchar2 default null);
    procedure pDrawLaender;
    procedure pDrawVorschriften;
    procedure pDrawThemen;    

END PCK_RI_COCKPIT2;
```


-- BODY


```
create or replace PACKAGE BODY "PCK_RI_COCKPIT2" AS


    procedure pAufbereitungDaten(aLandID in number) is
        lRegelNr number;
        lAnzeigeIn number; 
        lErwAnzeige number;
        lAnzeigeName varchar2(2000 char);
    begin
    
        if (aLandID is null) then
            return;
        end if;    
    
        delete from t_cockpit_daten where landid = aLandID;
        
        select cockpit_erw_anzeige into lErwAnzeige from t_land where landid = aLandID;
        
        for lDatensatz in (
            select v.*, tv.dokumentendatum, tv.vorschrift_nummer
            from v_cockpit_daten v
            join t_vorschrift tv on (v.orig_vorschriftid = tv.vorschriftid)
            where ziel_landid = aLandID and orig_status_db_intern!= 1
        ) loop
        
            if (lErwAnzeige = 1 and lDatensatz.orig_status_vorschrift in (20,30)) then
                lAnzeigename := lDatensatz.vorschrift_nummer || ' - ' || to_char(lDatensatz.dokumentendatum,'dd.mm.yyyy');
            elsif (lErwAnzeige = 1 and lDatensatz.orig_status_vorschrift in (40,100)) then
                lAnzeigeName := lDatensatz.vorschrift_nummer || ' - ' || to_char(lDatensatz.orig_datum_in_kraft,'dd.mm.yyyy');
            else
                lAnzeigeName := lDatensatz.vorschrift_nummer;
            end if;
                

            lRegelNr := 0;
            lAnzeigeIn := 0;

            if (lDatensatz.art = 20
                and lDatensatz.rr_datum_neue_typen < sysdate
                and lDatensatz.rr_datum_alle_fzg is null
                and lDatensatz.verkn_datum_ausser_kraft is null
                and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then 
                lRegelNr := 10; 
                lAnzeigeIn := 10; --> Vorschrift verpflichtend

            elsif (lDatensatz.art = 20
                and lDatensatz.rr_datum_neue_typen is null
                and lDatensatz.rr_datum_alle_fzg < sysdate
                and lDatensatz.verkn_datum_ausser_kraft is null
                and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then 
                lRegelNr := 20; 
                lAnzeigeIn := 10; --> Vorschrift verpflichtend 

            elsif (lDatensatz.art = 20
                and lDatensatz.rr_datum_neue_typen < sysdate
                and lDatensatz.rr_datum_alle_fzg < sysdate
                and lDatensatz.verkn_datum_ausser_kraft is null
                and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then 
                lRegelNr := 30; 
                lAnzeigeIn := 10; --> Vorschrift verpflichtend     

            elsif (lDatensatz.art = 20
                    and lDatensatz.rr_datum_neue_typen < sysdate
                    and lDatensatz.rr_datum_alle_fzg is null
                    and lDatensatz.verkn_datum_ausser_kraft > sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 40;  
                lAnzeigeIn := 10; --> Vorschrift verpflichtend

            elsif (lDatensatz.art = 20
                    and lDatensatz.rr_datum_neue_typen is null
                    and lDatensatz.rr_datum_alle_fzg < sysdate
                    and lDatensatz.verkn_datum_ausser_kraft > sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 50; 
                lAnzeigeIn := 10; --> Vorschrift verpflichtend  

            elsif (lDatensatz.art = 20
                    and lDatensatz.rr_datum_neue_typen < sysdate
                    and lDatensatz.rr_datum_alle_fzg < sysdate
                    and lDatensatz.verkn_datum_ausser_kraft > sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 60; 
                lAnzeigeIn := 10; --> Vorschrift verpflichtend      

            elsif (lDatensatz.art = 20
                    and (lDatensatz.rr_datum_neue_typen is null or lDatensatz.rr_datum_neue_typen < sysdate)
                    and (lDatensatz.rr_datum_alle_fzg is null or lDatensatz.rr_datum_alle_fzg < sysdate)
                    and NOT (lDatensatz.rr_datum_neue_typen is null and lDatensatz.rr_datum_alle_fzg is null)
                    and lDatensatz.verkn_datum_ausser_kraft < sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 70; -- inkl. Regel Nr. 80 und 90 
                lAnzeigeIn := -1; --> (gar nicht)

            elsif (lDatensatz.art = 20
                    and lDatensatz.orig_status_db_intern = 30 -- nicht Relevant
            ) then
                lRegelNr := 100; 
                lAnzeigeIn := -1; --> (gar nicht)


            elsif (lDatensatz.art = 30
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and (lDatensatz.verkn_datum_ausser_kraft is null)
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
                    and lDatensatz.rr_datum_neue_typen < sysdate
                    and lDatensatz.rr_datum_alle_fzg < sysdate

            ) then
                lRegelNr := 120; 
                lAnzeigeIn := 20; --> Vorschrift optional



            elsif (lDatensatz.art = 30
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and (lDatensatz.verkn_datum_ausser_kraft is null)
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
                    and lDatensatz.rr_datum_neue_typen is null
                    and lDatensatz.rr_datum_alle_fzg < sysdate

            ) then
                lRegelNr := 121; 
                lAnzeigeIn := 20; --> Vorschrift optional                


            elsif (lDatensatz.art = 30
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and (lDatensatz.verkn_datum_ausser_kraft is null)
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
                    and lDatensatz.rr_datum_neue_typen < sysdate
                    and lDatensatz.rr_datum_alle_fzg is null

            ) then
                lRegelNr := 122; 
                lAnzeigeIn := 20; --> Vorschrift optional  
                
                
            elsif (lDatensatz.art = 30
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and (lDatensatz.verkn_datum_ausser_kraft is null)
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
                    and lDatensatz.rr_datum_neue_typen < sysdate
                    and lDatensatz.rr_datum_alle_fzg > sysdate

            ) then
                lRegelNr := 123; 
                lAnzeigeIn := 20; --> Vorschrift optional                  


            elsif (lDatensatz.art = 30
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and (lDatensatz.verkn_datum_ausser_kraft > sysdate)
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
                    and lDatensatz.rr_datum_neue_typen < sysdate
                    and lDatensatz.rr_datum_alle_fzg < sysdate

            ) then
                lRegelNr := 130; 
                lAnzeigeIn := 20; --> Vorschrift optional



            elsif (lDatensatz.art = 30
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and (lDatensatz.verkn_datum_ausser_kraft > sysdate)
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
                    and lDatensatz.rr_datum_neue_typen is null
                    and lDatensatz.rr_datum_alle_fzg < sysdate

            ) then
                lRegelNr := 131; 
                lAnzeigeIn := 20; --> Vorschrift optional                


            elsif (lDatensatz.art = 30
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and (lDatensatz.verkn_datum_ausser_kraft > sysdate)
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
                    and lDatensatz.rr_datum_neue_typen < sysdate
                    and lDatensatz.rr_datum_alle_fzg is null

            ) then
                lRegelNr := 132; 
                lAnzeigeIn := 20; --> Vorschrift optional


             elsif (lDatensatz.art = 30
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and lDatensatz.verkn_datum_ausser_kraft < sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
                    and lDatensatz.rr_datum_neue_typen < sysdate
                    and lDatensatz.rr_datum_alle_fzg < sysdate                    
            ) then
                lRegelNr := 140; 
                lAnzeigeIn := -1; --> (gar nicht)

            elsif (lDatensatz.art = 30
                    and lDatensatz.orig_datum_in_kraft > sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 160; 
                lAnzeigeIn := 30; --> Vorschrift Zukunft

           elsif (lDatensatz.art = 30
                    and lDatensatz.orig_datum_in_kraft is null
                    and lDatensatz.orig_status_vorschrift in (10, 20, 30) -- Prämisse/Bestätigt/Entwurf
                    and lDatensatz.orig_prognosequalitaet in (10, 20) -- sicher/abschätzbar
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 161; 
                lAnzeigeIn := 30; --> Vorschrift Zukunft     

            elsif (lDatensatz.art = 20
                    and lDatensatz.rr_datum_neue_typen > sysdate
                    and lDatensatz.rr_datum_alle_fzg is null
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 180;  
                lAnzeigeIn := 30; --> Vorschrift Zukunft

            elsif (lDatensatz.art = 20
                    and lDatensatz.rr_datum_neue_typen is null
                    and lDatensatz.rr_datum_alle_fzg > sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 190; 
                lAnzeigeIn := 30; --> Vorschrift Zukunft

            elsif (lDatensatz.art = 20
                    and lDatensatz.rr_datum_neue_typen > sysdate
                    and lDatensatz.rr_datum_alle_fzg > sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 200; 
                lAnzeigeIn := 30; --> Vorschrift Zukunft    

            elsif (lDatensatz.art = 20
                    and lDatensatz.orig_datum_in_kraft > sysdate
                    and lDatensatz.rr_datum_neue_typen is null
                    and lDatensatz.rr_datum_alle_fzg is null
                    and lDatensatz.orig_status_vorschrift in (10, 20, 30, 40) -- Prämisse/Bestätigt/Entwurf/in Kraft
                    and lDatensatz.orig_prognosequalitaet in (10, 20) -- sicher/abschätzbar
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe   
            ) then
                lRegelNr := 210; 
                lAnzeigeIn := 30; --> Vorschrift Zukunft

            elsif (lDatensatz.art = 20
                    and lDatensatz.orig_datum_in_kraft is null
                    and lDatensatz.rr_datum_neue_typen is null
                    and lDatensatz.rr_datum_alle_fzg is null
                    and lDatensatz.orig_status_vorschrift in (10, 20, 30) -- Prämisse/Bestätigt/Entwurf
                    and lDatensatz.orig_prognosequalitaet in (10, 20) -- sicher/abschätzbar
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe   
            ) then
                lRegelNr := 220; 
                lAnzeigeIn := 30; --> Vorschrift Zukunft
                
            elsif (lDatensatz.art = 20
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and lDatensatz.rr_datum_neue_typen < sysdate
                    and lDatensatz.rr_datum_alle_fzg > sysdate   
                    and (lDatensatz.verkn_datum_ausser_kraft is null or lDatensatz.verkn_datum_ausser_kraft > sysdate)
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe                  
            ) then
                lRegelNr := 221;
                lAnzeigeIn := 10; --> verfplichtend ( + Sonderfall Zukunft)                

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_neue_typen < sysdate
                    and lDatensatz.orig_datum_alle_fzg is null
                    and lDatensatz.orig_datum_ausser_kraft is null
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe   
            ) then
                lRegelNr := 250; 
                lAnzeigeIn := 10; --> Vorschrift verpflichtend

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_neue_typen is null
                    and lDatensatz.orig_datum_alle_fzg < sysdate
                    and lDatensatz.orig_datum_ausser_kraft is null
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe   
            ) then
                lRegelNr := 260; 
                lAnzeigeIn := 10; --> Vorschrift verpflichtend

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_neue_typen < sysdate
                    and lDatensatz.orig_datum_alle_fzg < sysdate
                    and lDatensatz.orig_datum_ausser_kraft is null
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe   
            ) then
                lRegelNr := 270; 
                lAnzeigeIn := 10; --> Vorschrift verpflichtend    

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_neue_typen < sysdate
                    and lDatensatz.orig_datum_alle_fzg is null
                    and lDatensatz.orig_datum_ausser_kraft > sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe  
            ) then
                lRegelNr := 280; 
                lAnzeigeIn := 10; --> Vorschrift verpflichtend

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_neue_typen is null
                    and lDatensatz.orig_datum_alle_fzg < sysdate
                    and lDatensatz.orig_datum_ausser_kraft > sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe  
            ) then
                lRegelNr := 290; 
                lAnzeigeIn := 10; --> Vorschrift verpflichtend

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_neue_typen < sysdate
                    and lDatensatz.orig_datum_alle_fzg < sysdate
                    and lDatensatz.orig_datum_ausser_kraft > sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe  
            ) then
                lRegelNr := 300; 
                lAnzeigeIn := 10; --> Vorschrift verpflichtend    

            elsif (lDatensatz.art = 10
                    and (lDatensatz.orig_datum_neue_typen is null or lDatensatz.orig_datum_neue_typen < sysdate)
                    and (lDatensatz.orig_datum_alle_fzg is null or lDatensatz.orig_datum_alle_fzg < sysdate)
                    and NOT (lDatensatz.orig_datum_neue_typen is null and lDatensatz.orig_datum_alle_fzg is null)
                    and lDatensatz.orig_datum_ausser_kraft < sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe  
            ) then
                lRegelNr := 310; -- inkl. Regel Nr. 320 und 330
                lAnzeigeIn := -1; --> (gar nicht)   
            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_neue_typen is not null
                    and lDatensatz.orig_datum_alle_fzg > sysdate
                    and lDatensatz.orig_datum_ausser_kraft < sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe  
            ) then
                lRegelNr := 331; -- inkl. Regel 332
                lAnzeigeIn := -1; --> (gar nicht)
            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and (lDatensatz.orig_datum_neue_typen > sysdate and (lDatensatz.orig_datum_alle_fzg is null or lDatensatz.orig_datum_alle_fzg > sysdate))                        
                    and lDatensatz.orig_datum_ausser_kraft is null
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 361; 
                lAnzeigeIn := 20; --> Vorschrift optional  & Vorschrift Zukunft (30) - !Sonderfall!

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and (lDatensatz.orig_datum_neue_typen is null and lDatensatz.orig_datum_alle_fzg > sysdate)
                    and lDatensatz.orig_datum_ausser_kraft is null
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 362; 
                lAnzeigeIn := 20; --> Vorschrift optional  & Vorschrift Zukunft (30) - !Sonderfall!    

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and lDatensatz.orig_datum_neue_typen is null
                    and lDatensatz.orig_datum_alle_fzg is null
                    and lDatensatz.orig_datum_ausser_kraft is null
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 360; 
                lAnzeigeIn := 20; --> Vorschrift optional

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and lDatensatz.orig_datum_neue_typen > sysdate 
                    and (lDatensatz.orig_datum_alle_fzg is null or lDatensatz.orig_datum_alle_fzg > sysdate)                        
                    and lDatensatz.orig_datum_ausser_kraft > sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 371; 
                lAnzeigeIn := 20; --> Vorschrift optional  & Vorschrift Zukunft (30) - !Sonderfall!

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and lDatensatz.orig_datum_neue_typen is null 
                    and lDatensatz.orig_datum_alle_fzg > sysdate
                    and lDatensatz.orig_datum_ausser_kraft > sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 372; 
                lAnzeigeIn := 20; --> Vorschrift optional  & Vorschrift Zukunft (30) - !Sonderfall!    

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and lDatensatz.orig_datum_neue_typen is null
                    and lDatensatz.orig_datum_alle_fzg is null
                    and lDatensatz.orig_datum_ausser_kraft > sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 370; 
                lAnzeigeIn := 20; --> Vorschrift optional

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and lDatensatz.orig_datum_neue_typen is null
                    and lDatensatz.orig_datum_alle_fzg is null
                    and lDatensatz.orig_datum_ausser_kraft < sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 380;
                lAnzeigeIn := -1; --> (gar nicht)

            elsif (lDatensatz.art = 10 
                    and lDatensatz.orig_datum_neue_typen > sysdate 
                    and lDatensatz.orig_datum_alle_fzg is null
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 400; 
                lAnzeigeIn := 30; --> Vorschrift Zukunft

            elsif (lDatensatz.art = 10 
                    and lDatensatz.orig_datum_neue_typen is null 
                    and lDatensatz.orig_datum_alle_fzg > sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 410; 
                lAnzeigeIn := 30; --> Vorschrift Zukunft    

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_in_kraft > sysdate
                    and lDatensatz.orig_datum_neue_typen is null
                    and lDatensatz.orig_datum_alle_fzg is null
                    and lDatensatz.orig_status_vorschrift in (10, 20, 30, 40) -- Prämisse/Bestätigt/Entwurf/in Kraft
                    and lDatensatz.orig_prognosequalitaet in (10, 20) -- sicher/abschätzbar
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe 
            ) then
                lRegelNr := 420;
                lAnzeigeIn := 30; --> Vorschrift Zukunft


            /*elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_in_kraft > sysdate   
                    and lDatensatz.orig_datum_neue_typen > sysdate
                    and lDatensatz.orig_datum_alle_fzg is null
                    and lDatensatz.orig_status_vorschrift in (10, 20, 30, 40) -- Prämisse/Bestätigt/Entwurf/in Kraft
                    and lDatensatz.orig_prognosequalitaet in (10, 20) -- sicher/abschätzbar
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe 
            ) then
                lRegelNr := 421;
                lAnzeigeIn := 30; --> Vorschrift Zukunft
                
            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_in_kraft > sysdate   
                    and lDatensatz.orig_datum_neue_typen is null
                    and lDatensatz.orig_datum_alle_fzg > sysdate
                    and lDatensatz.orig_status_vorschrift in (10, 20, 30, 40) -- Prämisse/Bestätigt/Entwurf/in Kraft
                    and lDatensatz.orig_prognosequalitaet in (10, 20) -- sicher/abschätzbar
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe 
            ) then
                lRegelNr := 422;
                lAnzeigeIn := 30; --> Vorschrift Zukunft*/
                
            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_in_kraft > sysdate   
                    and lDatensatz.orig_datum_neue_typen > sysdate
                    and lDatensatz.orig_datum_alle_fzg > sysdate
                    and lDatensatz.orig_status_vorschrift in (10, 20, 30, 40) -- Prämisse/Bestätigt/Entwurf/in Kraft
                    and lDatensatz.orig_prognosequalitaet in (10, 20) -- sicher/abschätzbar
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe 
            ) then
                lRegelNr := 423;
                lAnzeigeIn := 30; --> Vorschrift Zukunft                
            


            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_in_kraft is null
                    and lDatensatz.orig_datum_neue_typen is null 
                    and lDatensatz.orig_datum_alle_fzg is null
                    and lDatensatz.orig_status_vorschrift in (10, 20, 30) -- Prämisse/Bestätigt/Entwurf
                    and lDatensatz.orig_prognosequalitaet in (10, 20) -- sicher/abschätzbar
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe 
            ) then
                lRegelNr := 430; 
                lAnzeigeIn := 30; --> Vorschrift Zukunft 
                
            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_in_kraft is null
                    and lDatensatz.orig_datum_neue_typen is null 
                    and lDatensatz.orig_datum_alle_fzg is null
                    and lDatensatz.orig_status_vorschrift in (10, 20, 30) -- Prämisse/Bestätigt/Entwurf
                    and lDatensatz.orig_prognosequalitaet is null -- leer
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe 
            ) then
                lRegelNr := 435; 
                lAnzeigeIn := 30; --> Vorschrift Zukunft                 

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_in_kraft is null
                    and lDatensatz.orig_datum_neue_typen > sysdate 
                    and lDatensatz.orig_datum_alle_fzg > sysdate
                    and lDatensatz.orig_status_vorschrift in (10, 20, 30) -- Prämisse/Bestätigt/Entwurf
                    and lDatensatz.orig_prognosequalitaet in (10, 20) -- sicher/abschätzbar
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe 
            ) then
                lRegelNr := 440; 
                lAnzeigeIn := 30; --> Vorschrift Zukunft     

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_neue_typen < sysdate
                    and lDatensatz.orig_datum_alle_fzg > sysdate
                    and (lDatensatz.orig_datum_ausser_kraft is null or lDatensatz.orig_datum_ausser_kraft < sysdate or lDatensatz.orig_datum_ausser_kraft > sysdate)
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 460;
                lAnzeigeIn := 10; --> Vorschrift verpflichtend & Vorschrift Zukunft (30) - !Sonderfall!

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_neue_typen > sysdate
                    and lDatensatz.orig_datum_alle_fzg < sysdate
                    and lDatensatz.orig_datum_ausser_kraft is null
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 470; 
                lAnzeigeIn := 10; --> Vorschrift verpflichtend

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_neue_typen > sysdate
                    and lDatensatz.orig_datum_alle_fzg < sysdate
                    and lDatensatz.orig_datum_ausser_kraft > sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 480; 
                lAnzeigeIn := 10; --> Vorschrift verpflichtend    

            elsif (lDatensatz.art = 10
                    and lDatensatz.orig_datum_neue_typen > sysdate
                    and lDatensatz.orig_datum_alle_fzg < sysdate
                    and lDatensatz.orig_datum_ausser_kraft < sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 490; 
                lAnzeigeIn := -1; --> (gar nicht) 

            elsif (lDatensatz.art = 40
                    and lDatensatz.orig_datum_in_kraft < sysdate
                    and lDatensatz.orig_status_db_intern in (10, 20) -- Entwurf/Freigabe
            ) then
                lRegelNr := 510; 
                lAnzeigeIn := 20; --> Vorschrift optional  

           elsif (lDatensatz.art = 10
                    and lDatensatz.orig_status_db_intern = 30 -- nicht Relevant
            ) then
                lRegelNr := 520; 
                lAnzeigeIn := 20; --> Vorschrift optional      

            end if;

            if (lAnzeigeIn > 0) then
                INSERT INTO t_cockpit_daten (
                    REGEL_NR, ANZEIGE_IN, VORSCHRIFTID,
                    LANDID, THEMAID, RR_VORSCHRIFTID,
                    VERKN_VORSCHRIFTID, FBU_CKD, RR_URSP_VERKNUEPFUNG,
                    STATUS_DB_INTERN, STATUS_FREIGABE, ANZEIGENAME
                ) VALUES (
                    lRegelNr, lAnzeigeIn, lDatensatz.ORIG_VORSCHRIFTID,
                    lDatensatz.Ziel_landID, lDatensatz.ORIG_THEMAID , lDatensatz.RR_VORSCHRIFTID,
                    lDatensatz.VERKN_VORSCHRIFTID, lDatensatz.FBU_CKD, lDatensatz.rr_ursp_verknuepfung,
                    lDatensatz.orig_status_db_intern, lDatensatz.orig_status_vorschrift, lAnzeigeName
                );               
            end if;

            if (lRegelNr in (460, 361, 362, 371, 372, 221)) then
                -- !Sonderfall! Regel hat zwei "ANZEIGE_IN" Werte: Füge Vorschrift Zukunft (30) dazu
                INSERT INTO t_cockpit_daten (
                    REGEL_NR, ANZEIGE_IN, VORSCHRIFTID,
                    LANDID, THEMAID, RR_VORSCHRIFTID,
                    VERKN_VORSCHRIFTID, FBU_CKD, RR_URSP_VERKNUEPFUNG,
                    STATUS_DB_INTERN, STATUS_FREIGABE, ANZEIGENAME
                ) VALUES (
                    lRegelNr, 30, lDatensatz.ORIG_VORSCHRIFTID,
                    lDatensatz.Ziel_landID, lDatensatz.ORIG_THEMAID, lDatensatz.RR_VORSCHRIFTID,
                    lDatensatz.VERKN_VORSCHRIFTID, lDatensatz.FBU_CKD, lDatensatz.rr_ursp_verknuepfung,
                    lDatensatz.orig_status_db_intern, lDatensatz.orig_status_vorschrift, lAnzeigeName
                );               
            end if;

        end loop;

        /* Aussortierung von Duplikaten, wenn Land, Thema, Vorschrift, RR und Anzeige In übereinstimmen */
        merge into t_cockpit_daten t
        using (
            select count(1) over (partition by landid, themaid, vorschriftid, rr_vorschriftid, anzeige_in) xcounter,
               row_number() over (partition by landid, themaid, vorschriftid, rr_vorschriftid, anzeige_in order by fbu_ckd) xrownumber,
               sum(fbu_ckd) over (partition by landid, themaid, vorschriftid, rr_vorschriftid, anzeige_in) sum_fbu_ckd,
            t.*
            from t_cockpit_daten t
            where landid = aLandID
        ) u
        on (t.cockpit_datenid = u.cockpit_datenid)
        when matched then update set t.fbu_ckd = u.sum_fbu_ckd, anzeigen = case when xrownumber > 1 then 0 else 1 end;                

        commit;

    end pAufbereitungDaten;

    procedure pAufbereitungDaten is 
    begin
        for l in (select landid from t_land) loop
            pAufbereitungDaten(l.landid);
        end loop;    
    end pAufbereitungDaten;

    procedure pInit(aLaenderListe in varchar2, aThemenListe in varchar2, aHighlightVorschriften in varchar2 default null, aHighlightDatumAenderungMonate in number default 0, aLaendergruppenListe in varchar2 default null) is
    begin
        if (aLaenderListe is null and aLaendergruppenListe is null) then
            select landid bulk collect into lConfig.laenderliste from t_land;
        else 
            lConfig.laenderliste := apex_string.split_numbers(aLaendergruppenListe || ':' || aLaenderListe,':');
        end if;    
        open lCursorLaender;
        fetch lCursorLaender bulk collect into lLaenderListe;
        close lCursorLaender; 

        if (aThemenListe is null) then
            select themaid,themaid bulk collect into lConfig.themenliste, lConfig.themenindexes from v_thema_baum order by thema_sortorder;
        else 
            /*select distinct themaid, themaid bulk collect into lConfig.themenliste, lConfig.themenindexes
            from t_thema
            connect by prior parentid = themaid
            start with themaid in (select column_value from apex_string.split_numbers(aThemenListe,':'));   */

            select themaid,themaid bulk collect into lConfig.themenliste, lConfig.themenindexes
            from v_thema_baum v
            join table(apex_string.split_numbers(aThemenListe,':')) t on (v.themaid = t.column_value)
            order by v.thema_sortorder;

        end if;       

        if (aHighlightVorschriften is not null) then
            lConfig.highlight_vorschrifen := apex_string.split_numbers(aHighlightVorschriften,':');
        else 
            lConfig.highlight_vorschrifen := null;
        end if;

        lConfig.highlight_datum := aHighlightDatumAenderungMonate;

       -- lConfig.themenindexes := apex_t_number(1,500);


        htp.p('<div class="gridcontainer">');        

    end pInit;

    procedure pDrawLaender is
        lFlagUrl varchar2(250);
        lMarktBesonderheitenUrl varchar2(500); 
        lSpaltenIndex number := 2;

    begin


        htp.p('<div class="topleft"></div>');                

        for lIndex in 1 .. lLaenderListe.count
        loop
            lFlagUrl := apex_page.get_url(p_page => 0, p_items => 'G_LANDID', p_values => lLaenderListe(lIndex).landid, p_request => 'APPLICATION_PROCESS=getFlag'); 
            lMarktBesonderheitenUrl := apex_page.get_url(p_page => 136, p_items => 'P136_LAENDER', p_values => lLaenderListe(lIndex).landid, p_clear_cache => 136);            
            htp.p('<div class="land" style="grid-column: ' || (lSpaltenIndex+1) || ' / span ' || (lLaenderListe(lIndex).anzahl_einsatzdaten + 3) || '">');
            htp.p('<div class="landname">' || lLaenderListe(lIndex).b_nummer || ' - ' || lLaenderListe(lIndex).land || '<div class="laendergruppen">' || lLaenderListe(lIndex).liste_laendergruppen || '</div></div>');

            if (lLaenderListe(lIndex).BESONDERHEITEN is not null) then
                htp.p('<div class="landbesonderheiten"><a href="' || lMarktBesonderheitenUrl || '"><span class="fa fa-info-square-o fa-2x" aria-hidden="true" title="Kommentar zu diesem Land prüfen"></span></a></div>');
            end if;
            if (lLaenderListe(lIndex).betaflag = 1) then
                htp.p('<div class="landb"><img src="' || v('APP_IMAGES') || 'beta1.jpg" /></div>');
            end if;   
            htp.p('<div class="landr"><img src="' || lFlagUrl || '"/></div>');            



            htp.p('</div>'); 
            htp.p('<div class="subheader marginleft marginright" style="grid-column: ' || (lSpaltenIndex+1) || '">Vorschrift verpflichtend</div><div class="subheader marginleft marginright" style="grid-column: ' || (lSpaltenIndex+2) || '">Vorschrift optional</div><div class="subheader marginleft" style="grid-column: ' || (lSpaltenIndex+3) || '">Vorschrift zukünftig</div>');

            for lIndexDatum in 1..lLaenderListe(lIndex).einsatzdaten.count
            loop
                htp.p('<div class="subheader ' || case when lIndexDatum = lLaenderListe(lIndex).einsatzdaten.count then 'marginright' else null end || '" style="grid-column: ' || (lSpaltenIndex + 3 + lIndexDatum) || '">' || lLaenderListe(lIndex).einsatzdaten(lIndexDatum).einsatzdatum_typ || '</div>');                                 
            end loop;   

            htp.p('<div class="bgv" style="grid-column: ' || (lSpaltenIndex+1) || ' / span ' || (lLaenderListe(lIndex).anzahl_einsatzdaten + 3) || '' || '"></div>');

            lLaenderListe(lIndex).spaltenindex := lSpaltenIndex;
            lSpaltenIndex := lSpaltenIndex + lLaenderListe(lIndex).anzahl_einsatzdaten + 3;


        end loop;     

        gMaxSpaltenIndex := lSpaltenIndex;

    end pDrawLaender;

    function fGetSpaltenIndex(aLandid in number) return number is
    begin
        for lIndex in 1 .. lLaenderListe.count
        loop
            if (lLaenderListe(lIndex).landid = aLandid) then
                return lLaenderListe(lIndex).spaltenindex;
            end if;
        end loop;
        return 0;

    end fGetSpaltenIndex;  

    function fGetLandDatumspaltenAnzahl(aLandid in number) return number is

    begin
        for lIndex in 1 .. lLaenderListe.count
        loop
            if (lLaenderListe(lIndex).landid = aLandid) then
                return lLaenderListe(lIndex).anzahl_einsatzdaten;
            end if;
        end loop;
        return 0;
    end fGetLandDatumspaltenAnzahl;

    function fGetThemaStart(aThemaID in number) return number is

        lIndexThema number;

    begin

        for lIndex in 1 .. lConfig.themenliste.count
        loop
            if (lConfig.themenliste(lIndex) = aThemaID) then
                return lConfig.themenindexes(lIndex);
            end if;        
        end loop;

        return -1;
    end fGetThemaStart;



    procedure pDrawVorschriften is
        lSpaltenindex number;
        lAnzahlDatumsSpalten number;
        lCellCounter number;
        lEinsatzDatumTable t_einsatzdatum2_table;
        lMarginClass varchar2(250);
        lHighlight boolean;
        lDatumAusVerknuepfung boolean := false;
        lDatum date;
        lSpaltenIndexOverrideDatum number;

    begin    

        for x in (
            with cte1 as (
                select d.*, t.nummer, t.bezeichnung, v.vorschrift_nummer, v.vorschrift_bezeichnung, v.letzte_aenderung_datum, v.erstellung_datum,
                    row_number() over (partition by d.landid, d.themaid, d.anzeige_in order by d.anzeigen desc, v.vorschrift_nummer) row_in_cell,
                    dense_rank() over (order by d.themaid) thema_sortorder
                from t_cockpit_daten d
                join t_vorschrift v on (d.vorschriftid = v.vorschriftid)
                join v_thema_baum t on (d.themaid = t.themaid)
                join table(lConfig.laenderliste) ll on (ll.column_value = d.landid)
                join table(lConfig.themenliste) tl on (tl.column_value = d.themaid) 
                where anzeigen = 1 and (d.status_db_intern in (10,20) or gZeigeAlleVorschriften = 1)
            ), cte2 as (
                select cte1.*, max(row_in_cell) over (partition by themaid) thema_rows
                from cte1
            ), cte3 as (
                select distinct themaid, thema_sortorder, nummer, bezeichnung, thema_rows
                from cte2
            ), cte_datum as (
                select vorschriftid,
                    cast(collect (t_einsatzdatum2(vret.einsatzdatum_typid, null, null, einsatzdatum, substr(einsatzdatum_text,1,2000), et.spaltenindex_cockpit)) as t_einsatzdatum2_table) datumsangaben
                from t_vorschrift_ref_einsatzdatum_typ vret
                join t_einsatzdatum_typ et on (vret.einsatzdatum_typid = et.einsatzdatum_typid)
                where et.spaltenindex_cockpit is not null
                group by vorschriftid        
            )
            select o.*, /*nvl((select sum(thema_rows) from cte3 i where i.thema_sortorder < o.thema_sortorder),0) thema_zeile_start,*/
            v_rr.vorschrift_nummer rr_vorschrift_nummer, d.datumsangaben,
            rr_ursp_vk.datum_alle_typen as override_datum_alle_fzg, rr_ursp_vk.datum_neue_typen as override_datum_neue_typen
            from cte2 o
            left outer join t_vorschrift v_rr on (o.rr_vorschriftid = v_rr.vorschriftid)
            left outer join cte_datum d on (o.vorschriftid = d.vorschriftid)
            left outer join t_vorschrift_ref_vorschrift rr_ursp_vk on (o.rr_ursp_verknuepfung = rr_ursp_vk.vorschrift_ref_vorschriftid)
            order by thema_sortorder
        ) loop
            lSpaltenindex := fGetSpaltenIndex(x.landid) + (x.anzeige_in/10);

            -- Wenn Direktzuordnung aus einer Rahmenrichtlinie und bei optional angezeigt, dann Datumsangaben aus Verknüpfung anzeigen            
            if (x.regel_nr in (180,190,200,210,220,221) and x.anzeige_in = 30) then
                lDatumAusVerknuepfung := true;
            else 
                lDatumAusVerknuepfung := false;
            end if;


            if (lConfig.highlight_vorschrifen is not null and x.vorschriftid member of lConfig.highlight_vorschrifen) then
                lHighlight := true;
            else
                lHighlight := false;
            end if;            

            lMarginClass := case x.anzeige_in when 10 then 'marginleft marginright' when 20 then 'marginleft marginright' when 30 then 'marginleft' end;

            htp.p('<div class="vorschrift ' || lMarginClass || case lHighlight when true then ' highlight' else null end || '" fbuckd="' || x.fbu_ckd || '" rrid="' || x.rr_vorschriftid || '" rrnummer="' || x.rr_vorschrift_nummer || '" rrvk="' || x.rr_ursp_verknuepfung || '" tid="' || x.themaid || '" lid="' || x.landid || '" regel="' || x.regel_nr || '" vid="' || x.vorschriftid || '" vnummer="' || x.vorschrift_nummer || '" vbezeichnung="' || x.vorschrift_bezeichnung || '" style="grid-column: ' || lSpaltenindex || '; grid-row: ' || (fGetThemaStart(x.themaid) + x.row_in_cell + 2) || '">');            

            if (x.status_db_intern = 10) then
                -- entwurf
                htp.p('<span class="ventwurf" alt="Achtung Vorschrift ist derzeit im internen DB Status In VKO-/VEX-Prozess-Bearbeitung und nur eingeschränkt verfügbar" title="Achtung Vorschrift ist derzeit im internen DB Status Entwurf und nur eingeschränkt verfügbar "></span>');
            elsif (x.status_db_intern = 30) then
                -- nicht relevant
                htp.p('<span class="vnrelevant" alt="Achtung Vorschrift ist derzeit im internen DB Status nicht Relevant und somit nur für VKO sichtbar" title="Achtung Vorschrift ist derzeit im internen DB Status nicht Relevant und somit nur für VKO sichtbar"></span>');
            end if;


            if (x.rr_vorschriftid is not null) then
                htp.p('<span alt="' || x.rr_vorschrift_nummer || '" title="' || x.rr_vorschrift_nummer || '" class="rr"></span>');
            end if;
            if (x.fbu_ckd is not null) then
                htp.p('<span class="' || case x.fbu_ckd when 1 then 'fbu' when 2 then 'ckd' when 3 then 'fbuckd' end || '"></span>');
            end if;

            if (x.regel_nr in (10,40,250,280,460) and x.anzeige_in = 10) then
                htp.p('<img class="vIcon" title="Vorschrift ist für neue Typen verpflichtend' || chr(10) || 'Detailregelungen zu Übergangsbestimmungen oder der auslaufenden Serie sind nicht mit abgebildet" src="' || v('APP_IMAGES') || 'neue_typen_icon.png" />');
            end if;

            if (x.regel_nr in (20,30,50,60,260,270,290,300,470,480) and x.anzeige_in = 10) then
                htp.p('<img class="vIcon" title="Vorschrift ist für alle Fahrzeuge verpflichtend' || chr(10) || 'Detailregelungen zu Übergangsbestimmungen oder der auslaufenden Serie sind nicht mit abgebildet" src="' || v('APP_IMAGES') || 'alle_fzg_icon.png" />');
            end if;


            if (lConfig.highlight_datum != 0 and x.erstellung_datum  > (sysdate - 30 * lConfig.highlight_datum)) then
                htp.p('<img class="vIcon" title="Vorschrift wurde in den letzten ' || (30 * lConfig.highlight_datum) || ' Tagen erstellt" src="' || v('APP_IMAGES') || 'new_regulation.png" />');
            elsif (lConfig.highlight_datum != 0 and x.letzte_aenderung_datum > (sysdate - 30 * lConfig.highlight_datum)) then
                htp.p('<img class="vIcon" title="Vorschrift wurde in den letzten ' || (30 * lConfig.highlight_datum) || ' Tagen geändert" src="' || v('APP_IMAGES') || 'update_regulation.png" />');
            end if;            

            htp.p('<span class="fa fa-info-square-o infobox"></span> ' || x.anzeigename);
            htp.p(case x.status_freigabe when 20 then ' - <b>Draft</b>' when 30 then ' - <b>Final document</b>' when 40 then ' - Enacted' else null end);
            htp.p('</div>');

            -- Wenn zukünftig, dann Datumsangaben anzeigen
            if (x.anzeige_in = 30 and (x.datumsangaben is not null)) then                   

                lEinsatzDatumTable := x.datumsangaben;

                for lIndexDatum in 1..lEinsatzDatumTable.count
                loop 

                    if (lDatumAusVerknuepfung and lEinsatzDatumTable(lIndexDatum).einsatzdatum_typid = 1010) then -- neue Typen
                        continue; -- Nicht anzeigen, da überschrieben wird
                    elsif (lDatumAusVerknuepfung and lEinsatzDatumTable(lIndexDatum).einsatzdatum_typid = 1011) then -- alle Fzg
                        continue; -- Nicht anzeigen, da überschrieben wird             
                    else
                        lDatum := lEinsatzDatumTable(lIndexDatum).einsatzdatum;                 
                    end if;

                    htp.p('<div class="datum ' || case when lEinsatzDatumTable(lIndexDatum).spaltenindex = fGetLandDatumspaltenAnzahl(x.landid) then 'marginright' else null end
                         || '" style="grid-column: '                
                         || (lSpaltenindex + lEinsatzDatumTable(lIndexDatum).spaltenindex)
                         || '; grid-row: '
                         || (fGetThemaStart(x.themaid) + x.row_in_cell + 2)
                         || '">'
                         || to_char(lDatum,'dd.mm.yyyy')
                         || '</div>'
                    );
                end loop;

                if (lDatumAusVerknuepfung and x.override_datum_neue_typen is not null) then
                    lSpaltenIndexOverrideDatum := 2;

                    htp.p('<div class="datum ' || case when lSpaltenIndexOverrideDatum = fGetLandDatumspaltenAnzahl(x.landid) then 'marginright' else null end
                         || '" style="grid-column: '                
                         || (lSpaltenindex + lSpaltenIndexOverrideDatum)
                         || '; grid-row: '
                         || (fGetThemaStart(x.themaid) + x.row_in_cell + 2)
                         || '">'
                         || to_char(x.override_datum_neue_typen,'dd.mm.yyyy')
                         || '</div>'
                    );   
                end if;

                if (lDatumAusVerknuepfung and x.override_datum_alle_fzg is not null) then
                    lSpaltenIndexOverrideDatum := 3;

                    htp.p('<div class="datum ' || case when lSpaltenIndexOverrideDatum = fGetLandDatumspaltenAnzahl(x.landid) then 'marginright' else null end
                         || '" style="grid-column: '                
                         || (lSpaltenindex + lSpaltenIndexOverrideDatum)
                         || '; grid-row: '
                         || (fGetThemaStart(x.themaid) + x.row_in_cell + 2)
                         || '">'
                         || to_char(x.override_datum_alle_fzg,'dd.mm.yyyy')
                         || '</div>'
                    );   
                end if;                

            end if;

        end loop;

        htp.p('</div>');

    end pDrawVorschriften;

    procedure pDrawThemen is

        lIndexThema number := 0;

    begin

        for t in (

            with cte1 as (
                select d.vorschriftid, t.themaid, t.nummer, t.bezeichnung, t.et_b_ak_kurz ak, t.beta_flag,
                    case when d.vorschriftid is not null then row_number() over (partition by d.landid, d.themaid, d.anzeige_in order by v.vorschriftid) else null end row_in_cell,
                    dense_rank() over (order by t.thema_sortorder) thema_sortorder

                from v_thema_baum t
                join table(lConfig.themenliste) tl on (tl.column_value = t.themaid)  
                cross join table(lConfig.laenderliste) ll

                left outer join t_cockpit_daten d on (
                    t.themaid = d.themaid
                    and d.anzeigen = 1
                    and ll.column_value = d.landid
                    and (d.status_db_intern in (10,20) or gZeigeAlleVorschriften = 1)
                )
                left outer join t_vorschrift v on (d.vorschriftid = v.vorschriftid)                
            ), cte2 as (
                select cte1.*, nvl(max(row_in_cell) over (partition by themaid),1) thema_rows
                from cte1
            ), cte3 as (
                select distinct themaid, thema_sortorder, nummer, bezeichnung, thema_rows, ak, beta_flag
                from cte2
            )

            select o.*, nvl((select sum(thema_rows) from cte3 i where i.thema_sortorder < o.thema_sortorder),0) thema_zeile_start--,
            --nvl((select sum(thema_rows) from cte3 i where i.thema_sortorder <= o.thema_sortorder),0) thema_zeile_ende
            from cte3 o
            order by thema_sortorder     


        ) loop
            lIndexThema := lIndexThema + 1;
            lConfig.themenindexes(lIndexThema) := t.thema_zeile_start;
            htp.p('<div class="bg" style="grid-row: '  || (t.thema_zeile_start+3) || ' / span ' || t.thema_rows || '; grid-column: 1 / span ' || gMaxSpaltenIndex || '"></div>');
            htp.p('<div tak="' || t.ak || '" tid="' || t.themaid || '" tnummer="' || t.nummer || '" tname="' || t.bezeichnung || '" class="themanum tmenu" style="grid-row: ' || (t.thema_zeile_start+3) || ' / span ' || t.thema_rows || '" >' || t.nummer || '</div>');
            htp.p('<div tak="' || t.ak || '" tid="' || t.themaid || '" tnummer="' || t.nummer || '" tname="' || t.bezeichnung || '" class="themaname tmenu" style="grid-row: ' || (t.thema_zeile_start+3) || ' / span ' || t.thema_rows || '" >' || case t.beta_flag when 10 then '<img class="themaBeta" src="' || v('APP_IMAGES') || 'beta1.jpg" />' end || t.bezeichnung || '</div>');

            gMaxZeilenIndex := t.thema_zeile_start + 3 + t.thema_rows;

        end loop;

        htp.p('<style type="text/css"> .bgv { grid-row: 1 / span ' || gMaxZeilenIndex || '}</style>');        

    end pDrawThemen;


END PCK_RI_COCKPIT2;
```




/* PCK RI COCKPIT REFRESH */


-- SPECIFICATION

```
create or replace PACKAGE PCK_RI_COCKPIT_REFRESH AS 
    
    /* Gibt eine Aktualisierung der Cockpit-Daten in Auftrag. Kann direkt aufgerufen werden. */
    procedure pTriggerRefresh;
    
    /* Führt die Aktualisierung aus. Sollte nie direkt aufgerufen werden, sondern nur indirekt über pTriggerRefresh */
    procedure pRefresh;    

END PCK_RI_COCKPIT_REFRESH;
```

-- BODY

```
create or replace PACKAGE BODY PCK_RI_COCKPIT_REFRESH AS

    procedure pRefresh is

        lNeedsRefresh varchar2(30) := '';

        begin

            loop

                -- Zu Beginn des Loops den Kommentar setzen, um den Mview als aktuell zu markieren
                execute immediate 'comment on materialized view mv_cockpit_neu is ''fresh''';

                -- Refreshs durchführen
                dbms_mview.refresh('mv_cockpit_neu');                
                dbms_mview.refresh('mv_cockpit2_neu');

                select comments into lNeedsRefresh
                from all_mview_comments
                where mview_name = 'MV_COCKPIT_NEU';

                -- Wenn während des Refreshs ein anderer Prozess die Daten verändert hat, dann
                -- wird sofort ein weiterer Refresh durchgeführt
                exit when nvl(lNeedsRefresh,'fresh') != 'needs refresh';

            end loop;

        end;
        
    procedure pTriggerRefresh is

        lJobState varchar2(30);

        begin

            select state into lJobState
            from user_scheduler_jobs
            where job_name = 'J_REFRESH_COCKPIT';

            if (lJobState in ('DISABLED','SUCCEEDED')) then
            -- Job läuft gerade nicht und kann gestartet werden

                DBMS_SCHEDULER.RUN_JOB(
                    JOB_NAME            => 'J_REFRESH_COCKPIT',
                    USE_CURRENT_SESSION => FALSE
                );

            elsif (lJobState = 'RUNNING') then
            -- Job läuft gerade --> über Comment wird markiert, dass eine weitere Aktualisierung notwendig ist

                execute immediate 'comment on materialized view mv_cockpit_neu is ''needs refresh''';

            end if;


        end pTriggerRefresh;        

END PCK_RI_COCKPIT_REFRESH;
```




/* PCK RI EXPORT */

-- SPECIFICATION

```
create or replace PACKAGE PCK_RI_EXPORT AS 
    -- Combined function for both current and future data
    function fGetSQLExportCombined return clob;
END PCK_RI_EXPORT;
```


-- BODY

```
create or replace PACKAGE BODY PCK_RI_EXPORT AS
  FUNCTION fGetSQLExportCombined RETURN CLOB AS
    lSQL CLOB;
  BEGIN
    lSQL := '
   with cte_kc as (  
    select trc.themaid, listagg(kc.bezeichnung, '', '') within group (order by kc.bezeichnung) as liste_cluster
    from t_thema_ref_cluster trc
    join t_konzern_cluster kc on (kc.konzern_clusterid = trc.konzern_clusterid)
    group by trc.themaid
), cte_krz as (select LISTAGG(tebak.KURZ, '', '') WITHIN GROUP (ORDER BY tebak.KURZ) KURZ,t.themaid
    from t_thema t
    left outer join T_THEMA_REF_ET_B_AK ttrebak on ttrebak.THEMAID = t.themaid
    left outer join t_et_b_ak tebak on tebak.ET_B_AKID = ttrebak.ET_B_AKID
    group by t.themaid
 ), cte1 as (
    select anzeige_in, cd.landid, cd.themaid, cd.vorschriftid, rr_vorschriftid, v.vorschrift_nummer, v_rr.vorschrift_nummer as rr_vorschrift_nummer,
    
    count(*) over (partition by cd.landid, cd.themaid) max_thema_land, rr_ursp_verknuepfung,
    v_vk.vorschrift_nummer as verkn_vorschrift, t.nummer as thema_nummer, nvl(t2.name_eng,t.bezeichnung) as thema,
    cd.regel_nr, t.thema_sortorder, cte_kc.liste_cluster konzern_clusters, cte_krz.kurz, t2.DESCRIPTION_SOC_DE, t2.DESCRIPTION_SOC_EN
    from v_thema_baum t
    join t_land_statement_of_completeness lsc  on (lsc.themaid = t.themaid and lsc.landid = v(''P430_LAND''))
    join t_thema t2 on (t.themaid = t2.themaid)
    join t_cockpit_daten cd on (cd.themaid = t.themaid and anzeige_in = 30 and cd.landid = v(''P430_LAND'') and cd.anzeigen = 1)
    left outer join t_vorschrift v on (cd.vorschriftid = v.vorschriftid)
    left outer join t_vorschrift v_rr on (cd.rr_vorschriftid = v_rr.vorschriftid)
    left outer join t_vorschrift v_vk on (cd.verkn_vorschriftid = v_vk.vorschriftid)
    left outer join cte_kc on (cte_kc.themaid = cd.themaid)
    left outer join cte_krz on (cte_krz.themaid = cd.themaid)   
), cte_land as (
    select einsatzdatum_modellid
    from t_land l
    where l.landid = v(''P430_LAND'')
),cte_future_result as (
select
    
    thema_sortorder as future_thema_sortorder, 
    rank() over (partition by cte1.themaid order by cte1.vorschrift_nummer) future_row_index,
    thema_nummer as future_thema_nummer, 
    thema as future_thema,
    DESCRIPTION_SOC_DE as future_DESCRIPTION_SOC_DE,
    DESCRIPTION_SOC_EN as future_DESCRIPTION_SOC_EN,
    nvl(cte1.rr_vorschrift_nummer, cte1.vorschrift_nummer) as future_local_regulation,
    null as future_correction,
    null as future_comment,
    vret_ik.einsatzdatum future_in_kraft,
    case when regel_nr in (180,190,200,210,220) then rr_ursp_vk.datum_neue_typen else vret_nt.einsatzdatum end future_neue_typen,
    case when regel_nr in (180,190,200,210,220) then rr_ursp_vk.datum_alle_typen else vret_af.einsatzdatum end future_alle_fzg,
    null as future_comment_vko,
    konzern_clusters as future_konzern_clusters,
    kurz as future_kurz,
    themaid
from cte1
cross join cte_land
left outer join t_vorschrift_ref_vorschrift rr_ursp_vk on (cte1.rr_ursp_verknuepfung = rr_ursp_vk.vorschrift_ref_vorschriftid)
left outer join t_vorschrift_ref_einsatzdatum_typ vret_ik on (cte1.vorschriftid = vret_ik.vorschriftid and vret_ik.einsatzdatum_typid = 1000)
left outer join t_vorschrift_ref_einsatzdatum_typ vret_nt on (cte1.vorschriftid = vret_nt.vorschriftid 
                and vret_nt.einsatzdatum_typid = case einsatzdatum_modellid when 10 then 1010 when 20 then 1022 when 30 then 1030 end)
left outer join t_vorschrift_ref_einsatzdatum_typ vret_af on (cte1.vorschriftid = vret_af.vorschriftid
                and vret_af.einsatzdatum_typid = case einsatzdatum_modellid when 10 then 1011 when 20 then 1023 when 30 then 1031 end)

order by thema_sortorder, future_row_index

), 
cte_thema as (select t.themaid ct_themaid,
                    t.NUMMER,
                    nvl(t.name_eng,t.bezeichnung) as thema,
                    t.DESCRIPTION_SOC_EN,
                    
                    t.name_eng,
                    t.bezeichnung,
                   vt.thema_sortorder,
                   cte_kc.liste_cluster konzern_clusters,
                   cte_krz.kurz,
                   vt.leaf

            from v_thema_baum vt
    full outer join t_thema t on (t.themaid = vt.themaid)
    left outer join cte_kc on (cte_kc.themaid = t.themaid)
    left outer join cte_krz on (cte_krz.themaid = t.themaid)
),
cte_current as(select cd.landid,
      cd.themaid as current_themaid,
       cd.vorschriftid,
       
       row_number() over (partition by  cd.themaid order by v.vorschrift_nummer)  rowindexid,
       row_number() over (partition by cd.themaid order by v.vorschrift_nummer) index_thema_land_anzeige,
       nvl(v.vorschrift_nummer,v_rr.vorschrift_nummer) as current_local_regulation
from t_cockpit_daten cd
left outer join t_vorschrift v on (cd.vorschriftid = v.vorschriftid)
left outer join t_vorschrift v_rr on (cd.rr_vorschriftid = v_rr.vorschriftid)
where cd.ANZEIGE_IN in (10,20)
and anzeigen = 1
and cd.landid = v(''P430_LAND'')
order by cd.themaid,ROWINDEXID
),
cte3 as (select cte_current.landid, cte_current.current_themaid, nvl(t.name_eng,t.bezeichnung) as thema, 
    max(index_thema_land_anzeige) as max_thema_land, t.nummer as thema_nummer, vt.thema_sortorder,
    cte_kc.liste_cluster konzern_clusters 
    from v_thema_baum vt
    join t_thema t on (t.themaid = vt.themaid)
    join t_land_statement_of_completeness lsc on (lsc.themaid = t.themaid and lsc.landid = v(''P430_LAND''))
    left outer join cte_current on (cte_current.current_themaid = vt.themaid)
    left outer join cte_kc on (cte_kc.themaid = vt.themaid) 
    group by cte_current.landid, cte_current.current_themaid, t.bezeichnung, t.nummer, vt.thema_sortorder, t.name_eng , cte_kc.liste_cluster
), cte_current_result as (
select  cte3.landid, 
        cte3.thema_sortorder AS current_thema_sortorder,
        ctc.rowindexid AS current_rowindex,
        cte3.thema_nummer AS current_thema_nummer,
        cte3.thema AS current_thema, 
        
        ctc.current_local_regulation,
        null as current_correction, 
        null as current_comment,
        null as current_comment_vko,
        null as future_correction,
        null as future_comment,
        cte3.konzern_clusters as current_konzern_clusters,
        cte_krz.kurz AS current_kurz,
        cte3.current_themaid as themaid
      from cte3
     left outer join cte_current ctc on (ctc.current_themaid=cte3.current_themaid)
     left outer join cte_krz on(cte3.current_themaid=cte_krz.themaid)
     left outer join cte_thema cth on(cte3.current_themaid =cth.ct_themaid)
    order by cte3.thema_sortorder,ctc.rowindexid
) Select   
            
            t5.nummer as "Topic ID",

            t5.thema as "Topic",

            t5.DESCRIPTION_SOC_EN as "topics description SoC",
            ccr.current_local_regulation as "Local Regulation",
            ccr.current_correction as "Correction",
            ccr.current_comment as "Comment",
            cfr.future_local_regulation as "Local Regulation",
            future_in_kraft as "Enactement Date",
            future_neue_typen as "Implementation date New Type",
            future_alle_fzg as "Implementation date All Vehicles",
            cfr.future_correction as "Correction",
            cfr.future_comment as "Comment",
            nvl(ccr.current_comment_vko, cfr.future_comment_vko) as "Comment VKO",  
            t5.konzern_clusters as "Group Clusters",
            t5.kurz  as "AK",
            t5.leaf as "Leaf"
from cte_current_result ccr
full outer join cte_future_result cfr on (ccr.themaid = cfr.themaid and ccr.current_rowindex = cfr.future_row_index)
full outer join cte_thema t5 on t5.ct_themaid = ccr.themaid
order by thema_sortorder, nvl(current_rowindex, future_row_index)

    ';
    RETURN lSQL;
  END fGetSQLExportCombined;
END PCK_RI_EXPORT;
```




/* PCK RI EXPORT 1 */

-- SPECIFICATION

```
create or replace PACKAGE PCK_RI_EXPORT_1 AS 
    function fGetSQLExportCurrent return clob;
    function fGetSQLExportFuture return clob;
    --function fGetSQLExport return clob;
END PCK_RI_EXPORT_1;
```

-- BODY

```
create or replace PACKAGE BODY PCK_RI_EXPORT_1 AS
  function fGetSQLExportCurrent return clob AS
    lSQL clob;  
  BEGIN
    lSQL := '	
		with cte_fzgkl as (
			select listagg(f.bezeichnung,'', '') within group (order by f.bezeichnung) as fahrzeugklassen, vf.vorschriftid
			from t_vorschrift_ref_fahrzeugklasse vf
			join t_fahrzeugklasse f on (vf.fahrzeugklasseid = f.fahrzeugklasseid)
			group by vf.vorschriftid
		), cte1 as (
			select anzeige_in, cd.landid, cd.themaid, cd.vorschriftid, rr_vorschriftid, v.vorschrift_nummer, v_rr.vorschrift_nummer as rr_vorschrift_nummer,
			row_number() over (partition by cd.landid, cd.themaid, anzeige_in order by v.vorschrift_nummer) index_thema_land_anzeige, REGEXP_REPLACE(v.bemerkung, ''[^[:print:]]'', '''') as bemerkung,
			count(*) over (partition by cd.landid, cd.themaid) max_thema_land,
			fk.fahrzeugklassen, v_vk.vorschrift_nummer as verkn_vorschrift
			from t_cockpit_daten cd
			join t_vorschrift v on (cd.vorschriftid = v.vorschriftid)
			left outer join t_vorschrift v_rr on (cd.rr_vorschriftid = v_rr.vorschriftid)
			left outer join t_vorschrift v_vk on (cd.verkn_vorschriftid = v_vk.vorschriftid)
			left outer join cte_fzgkl fk on (cd.vorschriftid = fk.vorschriftid)
			where anzeige_in in (10,20)
			and anzeigen = 1
			and cd.landid = v(''P430_LAND'')
		), cte_kc as (  
            select trc.themaid, listagg(kc.bezeichnung, '','') within group (order by kc.bezeichnung) as liste_cluster
            from t_thema_ref_cluster trc
            join t_konzern_cluster kc on (kc.konzern_clusterid = trc.konzern_clusterid)
            group by trc.themaid
        ), cte2 as (
			select cte1.landid, cte1.themaid, max(index_thema_land_anzeige) as max_thema_land, nvl(t.name_eng,t.bezeichnung) as thema, t.nummer as thema_nummer, vt.thema_sortorder
            , cte_kc.liste_cluster konzern_clusters
            from v_thema_baum vt
            join t_thema t on (t.themaid = vt.themaid)
            join t_land_statement_of_completeness lsc on (lsc.themaid = t.themaid and lsc.landid = v(''P430_LAND''))
            left outer join cte1 on (cte1.themaid = vt.themaid)
            left outer join cte_kc on (cte_kc.themaid = vt.themaid) 
			group by cte1.landid, cte1.themaid, t.bezeichnung, t.nummer, vt.thema_sortorder, t.name_eng, cte_kc.liste_cluster
		), cte_counter as (
			select level as rowindex
			from dual
			connect by level <= (select max(max_thema_land) from cte2)
		), cte3 as (
			select *
			from cte2
			left outer join cte_counter cc on (cte2.max_thema_land >= cc.rowindex)
		)
		select thema_nummer as "Topic ID", thema as "Topic", nvl(anz10.rr_vorschrift_nummer, anz10.vorschrift_nummer) as "Local Regulation",
			case when anz10.rr_vorschrift_nummer is not null then anz10.vorschrift_nummer else anz10.verkn_vorschrift end as "Additional Alternative",
			anz20.vorschrift_nummer as "Optional", anz10.bemerkung as "Comments", anz10.fahrzeugklassen as "Vehicle Category" , konzern_clusters as "Group Clusters"
		from cte3
		left outer join cte1 anz10 on (anz10.landid = cte3.landid and anz10.themaid = cte3.themaid and anz10.index_thema_land_anzeige = cte3.rowindex and anz10.anzeige_in = 10)
		left outer join cte1 anz20 on (anz20.landid = cte3.landid and anz20.themaid = cte3.themaid and anz20.index_thema_land_anzeige = cte3.rowindex and anz20.anzeige_in = 20)
		order by cte3.thema_sortorder, cte3.rowindex';
	return lSQL;
  END fGetSQLExportCurrent;
  function fGetSQLExportFuture return clob AS
    lSQL clob;
    edModId number;
    lHeaderNeueTypen varchar2(100);
    lHeaderAlleFzg varchar2(100);
  BEGIN
    begin
        select EINSATZDATUM_MODELLID
        into edModId
        from T_LAND
        where LANDID = v('P430_LAND');
    exception when NO_DATA_FOUND then null;
    end;
    if edModId = 10 then
        lHeaderNeueTypen := 'Implementation date New Type'; --'Einsatztermin neue Typen';
        lHeaderAlleFzg := 'Implementation date All Vehicles'; --'Einsatztermin alle Fahrzeuge';
    elsif edModId = 20 then
        lHeaderNeueTypen := 'Implementation date New Type FBU'; --'Neue Typen FBU';
        lHeaderAlleFzg := 'Implementation date All Vehicles FBU'; --'Alle Fahrzeuge FBU';
    elsif edModId = 30 then
        lHeaderNeueTypen := 'Model Year Phase-in Start'; --'MJ Phasein start';
        lHeaderAlleFzg := 'Model Year Phase-in End'; --'MJ Phasein end';
    end if;    
    lSQL := '
        with cte_fzgkl as (
            select listagg(f.bezeichnung,'', '') within group (order by f.bezeichnung) as fahrzeugklassen, vf.vorschriftid
            from t_vorschrift_ref_fahrzeugklasse vf
            join t_fahrzeugklasse f on (vf.fahrzeugklasseid = f.fahrzeugklasseid)
            group by vf.vorschriftid
        ), cte_kc as (  
            select trc.themaid, listagg(kc.bezeichnung, '','') within group (order by kc.bezeichnung) as liste_cluster
            from t_thema_ref_cluster trc
            join t_konzern_cluster kc on (kc.konzern_clusterid = trc.konzern_clusterid)
            group by trc.themaid
        ), cte1 as (
            select anzeige_in, cd.landid, cd.themaid, cd.vorschriftid, rr_vorschriftid, v.vorschrift_nummer, v_rr.vorschrift_nummer as rr_vorschrift_nummer,
            row_number() over (partition by cd.landid, cd.themaid, anzeige_in order by v.vorschrift_nummer) index_thema_land_anzeige, REGEXP_REPLACE(v.bemerkung, ''[^[:print:]]'', '''') as bemerkung,
            count(*) over (partition by cd.landid, cd.themaid) max_thema_land, rr_ursp_verknuepfung,
            fk.fahrzeugklassen, v_vk.vorschrift_nummer as verkn_vorschrift, t.nummer as thema_nummer, nvl(t.name_eng,t.bezeichnung) as thema,
            cd.regel_nr, v.prognose_qualitaet, t.thema_sortorder, cte_kc.liste_cluster konzern_clusters
            from v_thema_baum t
            join t_land_statement_of_completeness lsc  on (lsc.themaid = t.themaid and lsc.landid = v(''P430_LAND''))
            join t_thema t2 on (t.themaid = t2.themaid)
            left outer join t_cockpit_daten cd on (cd.themaid = t.themaid and anzeige_in = 30 and cd.landid = v(''P430_LAND'') and cd.anzeigen = 1)
            left outer join t_vorschrift v on (cd.vorschriftid = v.vorschriftid)
            left outer join t_vorschrift v_rr on (cd.rr_vorschriftid = v_rr.vorschriftid)
            left outer join t_vorschrift v_vk on (cd.verkn_vorschriftid = v_vk.vorschriftid)
            left outer join cte_fzgkl fk on (cd.vorschriftid = fk.vorschriftid)
            left outer join cte_kc on (cte_kc.themaid = cd.themaid)
        ), cte_land as (
            select einsatzdatum_modellid
            from t_land l
            where l.landid = v(''P430_LAND'')
        )
        select thema_nummer as "Topic ID", thema as "Topic", nvl(cte1.rr_vorschrift_nummer, cte1.vorschrift_nummer) as "Local Regulation",
            case when cte1.rr_vorschrift_nummer is not null then cte1.vorschrift_nummer else cte1.verkn_vorschrift end as "Additional Alternative",
            cte1.fahrzeugklassen as "Vehicle Category",
            to_char(vret_ik.einsatzdatum,''dd.mm.yyyy'') as "Enactment date",
            to_char(case when regel_nr in (180,190,200,210,220) then rr_ursp_vk.datum_neue_typen else vret_nt.einsatzdatum end, ''dd.mm.yyyy'') as "' || lHeaderNeueTypen || '",
            to_char(case when regel_nr in (180,190,200,210,220) then rr_ursp_vk.datum_alle_typen else vret_af.einsatzdatum end,''dd.mm.yyyy'') as "' || lHeaderAlleFzg || '", ';
    if edModId = 20 then
        lSQL := lSQL || '      
            to_char(vret_ckd_nt.einsatzdatum,''dd.mm.yyyy'') as "Implementation date New Type LPV",    
            to_char(vret_ckd_af.einsatzdatum,''dd.mm.yyyy'') as "Implementation date All Vehicles LPV", ';
    end if;        
    lSQL := lSQL || '       
            case prognose_qualitaet when 10 then ''sicher'' when 20 then ''abschätzbar'' end as "Prognosis Quality",
            bemerkung as "Comments", konzern_clusters as "Group Clusters"
        from cte1
        cross join cte_land
        left outer join t_vorschrift_ref_vorschrift rr_ursp_vk on (cte1.rr_ursp_verknuepfung = rr_ursp_vk.vorschrift_ref_vorschriftid)
        left outer join t_vorschrift_ref_einsatzdatum_typ vret_ik on (cte1.vorschriftid = vret_ik.vorschriftid and vret_ik.einsatzdatum_typid = 1000) -- in kraft
        left outer join t_vorschrift_ref_einsatzdatum_typ vret_nt on ( -- neue typen 
            cte1.vorschriftid = vret_nt.vorschriftid
            and vret_nt.einsatzdatum_typid = case einsatzdatum_modellid when 10 then 1010 when 20 then 1022 when 30 then 1030 end
        )
        left outer join t_vorschrift_ref_einsatzdatum_typ vret_af on ( -- alle fahrzeuge 
            cte1.vorschriftid = vret_af.vorschriftid
            and vret_af.einsatzdatum_typid = case einsatzdatum_modellid when 10 then 1011 when 20 then 1023 when 30 then 1031 end
        )
        left outer join t_vorschrift_ref_einsatzdatum_typ vret_ckd_nt on ( -- neue typen ckd 
            cte1.vorschriftid = vret_ckd_nt.vorschriftid
            and vret_ckd_nt.einsatzdatum_typid = 1020
        )
        left outer join t_vorschrift_ref_einsatzdatum_typ vret_ckd_af on ( -- alle fzg ckd 
            cte1.vorschriftid = vret_ckd_af.vorschriftid
            and vret_ckd_af.einsatzdatum_typid = 1021
        )
        order by thema_sortorder, index_thema_land_anzeige';
    return lSQL;
  END fGetSQLExportFuture;
END PCK_RI_EXPORT_1;
```





/* EMANO UTIL */

-- SPECIFICATION


-- BODY




















