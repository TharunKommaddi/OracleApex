--
-- Package "PCK_SOAP_API"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_THARUN"."PCK_SOAP_API" AS

  -- Project 1: Hello Service
  FUNCTION f_SOAP_API_Hello(p_name VARCHAR2) RETURN VARCHAR2;

  -- Project 2: Country Info Service
  FUNCTION f_Get_Continents RETURN CLOB;
  FUNCTION f_Get_Countries  RETURN CLOB;

  -- Project 2: Parsed results
  PROCEDURE p_Load_Continents;
  PROCEDURE p_Load_Countries;

END PCK_SOAP_API;
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."PCK_SOAP_API" AS

  -- =============================================
  -- Project 1: Hello Service
  -- =============================================
  FUNCTION f_SOAP_API_Hello(p_name VARCHAR2) RETURN VARCHAR2 AS
    l_envelope  VARCHAR2(4000);
    l_response  XMLTYPE;
    l_result    VARCHAR2(500);
  BEGIN
    l_envelope := '<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <HelloRequest xmlns="http://learnwebservices.com/services/hello">
      <Name>' || p_name || '</Name>
    </HelloRequest>
  </soapenv:Body>
</soapenv:Envelope>';

    l_response := APEX_WEB_SERVICE.MAKE_REQUEST(
      p_url      => 'https://apps.learnwebservices.com/services/hello',
      p_action   => '',
      p_envelope => l_envelope
    );

    l_result := l_response.EXTRACT(
      '//ns:Message/text()',
      'xmlns:ns="http://learnwebservices.com/services/hello"'
    ).GETSTRINGVAL();

    RETURN l_result;
  END f_SOAP_API_Hello;

  -- =============================================
  -- Project 2: Get Continents Raw XML
  -- =============================================
  FUNCTION f_Get_Continents RETURN CLOB AS
    l_envelope VARCHAR2(4000);
    l_response XMLTYPE;
  BEGIN
    l_envelope := '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:tns="https://soap-service-free.mock.beeceptor.com/CountryInfoService">
  <soap:Header/>
  <soap:Body>
    <tns:ListOfContinentsByName/>
  </soap:Body>
</soap:Envelope>';

    l_response := APEX_WEB_SERVICE.MAKE_REQUEST(
      p_url    => 'https://soap-service-free.mock.beeceptor.com/CountryInfoService.wso',
      p_action => 'https://soap-service-free.mock.beeceptor.com/CountryInfoService.wso/ListOfContinentsByName',
      p_envelope => l_envelope
    );

    RETURN l_response.GETCLOBVAL();
  END f_Get_Continents;

  -- =============================================
  -- Project 2: Get Countries Raw XML
  -- =============================================
  FUNCTION f_Get_Countries RETURN CLOB AS
    l_envelope VARCHAR2(4000);
    l_response XMLTYPE;
  BEGIN
    l_envelope := '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:tns="https://soap-service-free.mock.beeceptor.com/CountryInfoService">
  <soap:Header/>
  <soap:Body>
    <tns:ListOfCountryNamesByName/>
  </soap:Body>
</soap:Envelope>';

    l_response := APEX_WEB_SERVICE.MAKE_REQUEST(
      p_url    => 'https://soap-service-free.mock.beeceptor.com/CountryInfoService.wso',
      p_action => 'https://soap-service-free.mock.beeceptor.com/CountryInfoService.wso/ListOfCountryNamesByName',
      p_envelope => l_envelope
    );

    RETURN l_response.GETCLOBVAL();
  END f_Get_Countries;

  -- =============================================
  -- Project 2: Load Continents into Collection
  -- =============================================
  PROCEDURE p_Load_Continents AS
    l_xml XMLTYPE;
  BEGIN
    l_xml := XMLTYPE(f_Get_Continents());

    -- Clear and create collection
    IF APEX_COLLECTION.COLLECTION_EXISTS('SOAP_CONTINENTS') THEN
      APEX_COLLECTION.DELETE_COLLECTION('SOAP_CONTINENTS');
    END IF;
    APEX_COLLECTION.CREATE_COLLECTION('SOAP_CONTINENTS');

    -- Insert each continent into collection
    FOR r IN (
      SELECT x.code, x.name
      FROM XMLTABLE(
        XMLNAMESPACES(
          'http://schemas.xmlsoap.org/soap/envelope/' AS "soap",
          'http://www.oorsprong.org/websamples.countryinfo' AS "m"
        ),
        '/soap:Envelope/soap:Body/m:ListOfContinentsByNameResponse/m:ListOfContinentsByNameResult/m:tContinent'
        PASSING l_xml
        COLUMNS
          code VARCHAR2(10)  PATH 'm:sCode',
          name VARCHAR2(100) PATH 'm:sName'
      ) x
    ) LOOP
      APEX_COLLECTION.ADD_MEMBER(
        p_collection_name => 'SOAP_CONTINENTS',
        p_c001 => r.code,
        p_c002 => r.name
      );
    END LOOP;
  END p_Load_Continents;

  -- =============================================
  -- Project 2: Load Countries into Collection
  -- =============================================
  PROCEDURE p_Load_Countries AS
    l_xml XMLTYPE;
  BEGIN
    l_xml := XMLTYPE(f_Get_Countries());

    -- Clear and create collection
    IF APEX_COLLECTION.COLLECTION_EXISTS('SOAP_COUNTRIES') THEN
      APEX_COLLECTION.DELETE_COLLECTION('SOAP_COUNTRIES');
    END IF;
    APEX_COLLECTION.CREATE_COLLECTION('SOAP_COUNTRIES');

    -- Insert each country into collection
    FOR r IN (
      SELECT x.iso_code, x.country_name
      FROM XMLTABLE(
        XMLNAMESPACES(
          'http://schemas.xmlsoap.org/soap/envelope/' AS "soap",
          'http://www.oorsprong.org/websamples.countryinfo' AS "m"
        ),
        '/soap:Envelope/soap:Body/m:ListOfCountryNamesByNameResponse/m:ListOfCountryNamesByNameResult/m:tCountryCodeAndName'
        PASSING l_xml
        COLUMNS
          iso_code     VARCHAR2(10)  PATH 'm:sISOCode',
          country_name VARCHAR2(200) PATH 'm:sName'
      ) x
    ) LOOP
      APEX_COLLECTION.ADD_MEMBER(
        p_collection_name => 'SOAP_COUNTRIES',
        p_c001 => r.iso_code,
        p_c002 => r.country_name
      );
    END LOOP;
  END p_Load_Countries;

END PCK_SOAP_API;
/