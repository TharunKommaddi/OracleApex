--
-- Function "GET_COUNTRY_ISO_CODE"
--
CREATE OR REPLACE EDITIONABLE FUNCTION "WKSP_THARUN"."GET_COUNTRY_ISO_CODE" (p_country VARCHAR2) 
RETURN VARCHAR2 IS
BEGIN
    RETURN CASE UPPER(TRIM(p_country))
        WHEN 'USA' THEN 'us'
        WHEN 'UNITED STATES' THEN 'us'
        WHEN 'UNITED STATES OF AMERICA' THEN 'us'
        WHEN 'CANADA' THEN 'ca'
        WHEN 'GERMANY' THEN 'de'
        WHEN 'FRANCE' THEN 'fr'
        WHEN 'UNITED KINGDOM' THEN 'gb'
        WHEN 'UK' THEN 'gb'
        WHEN 'GREAT BRITAIN' THEN 'gb'
        WHEN 'SPAIN' THEN 'es'
        WHEN 'ITALY' THEN 'it'
        WHEN 'JAPAN' THEN 'jp'
        WHEN 'CHINA' THEN 'cn'
        WHEN 'INDIA' THEN 'in'
        WHEN 'AUSTRALIA' THEN 'au'
        WHEN 'BRAZIL' THEN 'br'
        WHEN 'MEXICO' THEN 'mx'
        WHEN 'NETHERLANDS' THEN 'nl'
        WHEN 'BELGIUM' THEN 'be'
        WHEN 'SWITZERLAND' THEN 'ch'
        WHEN 'AUSTRIA' THEN 'at'
        WHEN 'SWEDEN' THEN 'se'
        WHEN 'NORWAY' THEN 'no'
        WHEN 'DENMARK' THEN 'dk'
        WHEN 'FINLAND' THEN 'fi'
        WHEN 'POLAND' THEN 'pl'
        WHEN 'RUSSIA' THEN 'ru'
        WHEN 'SOUTH KOREA' THEN 'kr'
        WHEN 'SOUTH AFRICA' THEN 'za'
        ELSE NULL  -- Return NULL for unknown countries
    END;
END;
/