prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.16'
,p_default_workspace_id=>7477305853296329
,p_default_application_id=>200
,p_default_id_offset=>7486375356367559
,p_default_owner=>'WKSP_THARUN'
);
end;
/
 
prompt APPLICATION 200 - TharunKommaddi
--
-- Application Export:
--   Application:     200
--   Name:            TharunKommaddi
--   Date and Time:   09:12 Sunday May 31, 2026
--   Exported By:     THARUN
--   Flashback:       0
--   Export Type:     Application Export
--     Pages:                    228
--       Items:                  716
--       Computations:             4
--       Validations:             13
--       Processes:              401
--       Regions:                811
--       Buttons:                380
--       Dynamic Actions:        510
--     Shared Components:
--       Logic:
--         Items:                 17
--         Processes:             16
--         Computations:           1
--         Build Options:          1
--         Data Loads:             2
--       Navigation:
--         Lists:                  8
--         Breadcrumbs:            1
--           Entries:            162
--       Security:
--         Authentication:         4
--         Authorization:          3
--       User Interface:
--         Themes:                 1
--         Templates:
--           Page:                 1
--         LOVs:                  11
--         Shortcuts:              1
--         Plug-ins:              34
--       PWA:
--       Globalization:
--       Reports:
--         Queries:                1
--         Layouts:                1
--       E-Mail:
--     Supporting Objects:  Included
--       Install scripts:          1
--   Version:         24.2.16
--   Instance ID:     7477158538261490
--

prompt --application/delete_application
begin
wwv_flow_imp.remove_flow(wwv_flow.g_flow_id);
end;
/
prompt --application/create_application
begin
wwv_imp_workspace.create_flow(
 p_id=>wwv_flow.g_flow_id
,p_owner=>nvl(wwv_flow_application_install.get_schema,'WKSP_THARUN')
,p_name=>nvl(wwv_flow_application_install.get_application_name,'TharunKommaddi')
,p_alias=>nvl(wwv_flow_application_install.get_application_alias,'TK')
,p_page_view_logging=>'YES'
,p_page_protection_enabled_y_n=>'Y'
,p_checksum_salt=>'EC1D6FAFEF114546B5B5A3482093D888CE0363D487D9CA8A3B44900717A6632C'
,p_bookmark_checksum_function=>'SH512'
,p_accept_old_checksums=>false
,p_compatibility_mode=>'21.2'
,p_accessible_read_only=>'N'
,p_session_state_commits=>'IMMEDIATE'
,p_flow_language=>'en'
,p_flow_language_derived_from=>'ITEM_PREFERENCE'
,p_allow_feedback_yn=>'Y'
,p_date_format=>'DD.MM.YYYY'
,p_timestamp_format=>'DD.MM.YYYY HH24:MI'
,p_timestamp_tz_format=>'DD.MM.YYYY HH24:MI'
,p_direction_right_to_left=>'N'
,p_flow_image_prefix => nvl(wwv_flow_application_install.get_image_prefix,'')
,p_authentication_id=>wwv_flow_imp.id(35351223135967287705)
,p_application_tab_set=>1
,p_logo_type=>'IT'
,p_logo=>'#APP_IMAGES#contact.jpg'
,p_logo_text=>'TharunKommaddi'
,p_public_user=>'APEX_PUBLIC_USER'
,p_proxy_server=>nvl(wwv_flow_application_install.get_proxy,'')
,p_no_proxy_domains=>nvl(wwv_flow_application_install.get_no_proxy_domains,'')
,p_flow_version=>'DD.MM.YYYY'
,p_flow_status=>'AVAILABLE_W_EDIT_LINK'
,p_flow_unavailable_text=>'This application is currently unavailable at this time.'
,p_exact_substitutions_only=>'Y'
,p_browser_cache=>'N'
,p_browser_frame=>'D'
,p_referrer_policy=>'strict-origin-when-cross-origin'
,p_deep_linking=>'Y'
,p_runtime_api_usage=>'T'
,p_pass_ecid=>'N'
,p_rejoin_existing_sessions=>'P'
,p_csv_encoding=>'Y'
,p_auto_time_zone=>'N'
,p_oracle_text_function_type=>'CUSTOM'
,p_oracle_text_function=>'PCK_ORACLE_TEXT_CUSTOMERS.convert_text_query'
,p_tokenize_row_search=>'N'
,p_file_prefix => nvl(wwv_flow_application_install.get_static_app_file_prefix,'')
,p_files_version=>735
,p_version_scn=>46965252566765
,p_print_server_type=>'INSTANCE'
,p_file_storage=>'DB'
,p_is_pwa=>'Y'
,p_pwa_is_installable=>'Y'
,p_pwa_manifest_display=>'fullscreen'
,p_pwa_manifest_orientation=>'any'
,p_pwa_apple_status_bar_style=>'default'
,p_pwa_is_push_enabled=>'Y'
,p_pwa_push_credential_id=>wwv_flow_imp.id(12689335988945746360)
);
end;
/
prompt --application/user_interfaces
begin
wwv_flow_imp_shared.create_user_interface(
 p_id=>wwv_flow_imp.id(200)
,p_theme_id=>42
,p_home_url=>'f?p=&APP_ID.:1:&SESSION.'
,p_login_url=>'f?p=&APP_ID.:LOGIN_DESKTOP:&SESSION.'
,p_theme_style_by_user_pref=>false
,p_global_page_id=>0
,p_navigation_list_id=>wwv_flow_imp.id(40148533682322405075)
,p_navigation_list_position=>'SIDE'
,p_navigation_list_template_id=>2467739217141810545
,p_nav_list_template_options=>'#DEFAULT#:js-defaultCollapsed:js-navCollapsed--hidden:t-TreeNav--classic'
,p_css_file_urls=>'#APP_FILES#spotlight.css'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#APP_FILES#spotlight.js',
'',
'#APP_FILES#help_system.js'))
,p_nav_bar_type=>'LIST'
,p_nav_bar_list_id=>wwv_flow_imp.id(40148585736954405120)
,p_nav_bar_list_template_id=>2847543055748234966
,p_nav_bar_template_options=>'#DEFAULT#'
);
end;
/
prompt --workspace/credentials/youtube_oauth
begin
wwv_imp_workspace.create_credential(
 p_id=>wwv_flow_imp.id(125943667848951455)
,p_name=>'YouTube_OAuth'
,p_static_id=>'YouTube_OAuth'
,p_authentication_type=>'OAUTH2_CLIENT_CREDENTIALS'
,p_valid_for_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'https://www.googleapis.com',
'https://oauth2.googleapis.com',
'https://accounts.google.com',
''))
,p_prompt_on_install=>true
);
end;
/
prompt --workspace/credentials/app_181430_push_notifications_credentials
begin
wwv_imp_workspace.create_credential(
 p_id=>wwv_flow_imp.id(12689335988945746360)
,p_name=>'App 181430 Push Notifications Credentials'
,p_static_id=>'App_181430_Push_Notifications_Credentials'
,p_authentication_type=>'KEY_PAIR'
,p_prompt_on_install=>false
);
end;
/
prompt --workspace/remote_servers/api_openweathermap_org_data_2_5
begin
wwv_imp_workspace.create_remote_server(
 p_id=>wwv_flow_imp.id(125526063639805376)
,p_name=>'api-openweathermap-org-data-2-5'
,p_static_id=>'api_openweathermap_org_data_2_5'
,p_base_url=>nvl(wwv_flow_application_install.get_remote_server_base_url('api_openweathermap_org_data_2_5'),'https://api.openweathermap.org/data/2.5/')
,p_https_host=>nvl(wwv_flow_application_install.get_remote_server_https_host('api_openweathermap_org_data_2_5'),'')
,p_server_type=>'WEB_SERVICE'
,p_ords_timezone=>nvl(wwv_flow_application_install.get_remote_server_ords_tz('api_openweathermap_org_data_2_5'),'')
,p_remote_sql_default_schema=>nvl(wwv_flow_application_install.get_remote_server_default_db('api_openweathermap_org_data_2_5'),'')
,p_mysql_sql_modes=>nvl(wwv_flow_application_install.get_remote_server_sql_mode('api_openweathermap_org_data_2_5'),'')
,p_prompt_on_install=>false
,p_ai_is_builder_service=>false
,p_ai_model_name=>nvl(wwv_flow_application_install.get_remote_server_ai_model('api_openweathermap_org_data_2_5'),'')
,p_ai_http_headers=>nvl(wwv_flow_application_install.get_remote_server_ai_headers('api_openweathermap_org_data_2_5'),'')
,p_ai_attributes=>nvl(wwv_flow_application_install.get_remote_server_ai_attrs('api_openweathermap_org_data_2_5'),'')
);
end;
/
prompt --workspace/remote_servers/gd1895d7a91019d_h5vz0428ux25xs1n_adb_eu_frankfurt_1_oraclecloudapps_com_ords_tharun
begin
wwv_imp_workspace.create_remote_server(
 p_id=>wwv_flow_imp.id(125586067155473423)
,p_name=>'gd1895d7a91019d-h5vz0428ux25xs1n-adb-eu-frankfurt-1-oraclecloudapps-com-ords-tharun'
,p_static_id=>'gd1895d7a91019d_h5vz0428ux25xs1n_adb_eu_frankfurt_1_oraclecloudapps_com_ords_tharun'
,p_base_url=>nvl(wwv_flow_application_install.get_remote_server_base_url('gd1895d7a91019d_h5vz0428ux25xs1n_adb_eu_frankfurt_1_oraclecloudapps_com_ords_tharun'),'https://gd1895d7a91019d-h5vz0428ux25xs1n.adb.eu-frankfurt-1.oraclecloudapps.com/ords/tharun/')
,p_https_host=>nvl(wwv_flow_application_install.get_remote_server_https_host('gd1895d7a91019d_h5vz0428ux25xs1n_adb_eu_frankfurt_1_oraclecloudapps_com_ords_tharun'),'')
,p_server_type=>'WEB_SERVICE'
,p_ords_timezone=>nvl(wwv_flow_application_install.get_remote_server_ords_tz('gd1895d7a91019d_h5vz0428ux25xs1n_adb_eu_frankfurt_1_oraclecloudapps_com_ords_tharun'),'')
,p_remote_sql_default_schema=>nvl(wwv_flow_application_install.get_remote_server_default_db('gd1895d7a91019d_h5vz0428ux25xs1n_adb_eu_frankfurt_1_oraclecloudapps_com_ords_tharun'),'')
,p_mysql_sql_modes=>nvl(wwv_flow_application_install.get_remote_server_sql_mode('gd1895d7a91019d_h5vz0428ux25xs1n_adb_eu_frankfurt_1_oraclecloudapps_com_ords_tharun'),'')
,p_prompt_on_install=>false
,p_ai_is_builder_service=>false
,p_ai_model_name=>nvl(wwv_flow_application_install.get_remote_server_ai_model('gd1895d7a91019d_h5vz0428ux25xs1n_adb_eu_frankfurt_1_oraclecloudapps_com_ords_tharun'),'')
,p_ai_http_headers=>nvl(wwv_flow_application_install.get_remote_server_ai_headers('gd1895d7a91019d_h5vz0428ux25xs1n_adb_eu_frankfurt_1_oraclecloudapps_com_ords_tharun'),'')
,p_ai_attributes=>nvl(wwv_flow_application_install.get_remote_server_ai_attrs('gd1895d7a91019d_h5vz0428ux25xs1n_adb_eu_frankfurt_1_oraclecloudapps_com_ords_tharun'),'')
);
end;
/
prompt --application/shared_components/data_profiles/openweather_api
begin
wwv_flow_imp_shared.create_data_profile(
 p_id=>wwv_flow_imp.id(125526299272805380)
,p_name=>'OpenWeather_API'
,p_format=>'JSON'
,p_has_header_row=>false
,p_use_raw_json_selectors=>false
,p_is_single_row=>true
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(125526440181805391)
,p_data_profile_id=>wwv_flow_imp.id(125526299272805380)
,p_name=>'ID'
,p_sequence=>1
,p_column_type=>'DATA'
,p_data_type=>'NUMBER'
,p_has_time_zone=>false
,p_selector=>'id'
,p_remote_data_type=>'number'
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(125526789870805394)
,p_data_profile_id=>wwv_flow_imp.id(125526299272805380)
,p_name=>'ICON'
,p_sequence=>2
,p_column_type=>'DATA'
,p_data_type=>'VARCHAR2'
,p_max_length=>32767
,p_has_time_zone=>false
,p_selector=>'weather[0].icon'
,p_remote_data_type=>'string'
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(125527061615805395)
,p_data_profile_id=>wwv_flow_imp.id(125526299272805380)
,p_name=>'MAIN'
,p_sequence=>3
,p_column_type=>'DATA'
,p_data_type=>'VARCHAR2'
,p_max_length=>32767
,p_has_time_zone=>false
,p_selector=>'weather[0].main'
,p_remote_data_type=>'string'
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(125527353682805396)
,p_data_profile_id=>wwv_flow_imp.id(125526299272805380)
,p_name=>'DESCRIPTION'
,p_sequence=>4
,p_column_type=>'DATA'
,p_data_type=>'VARCHAR2'
,p_max_length=>32767
,p_has_time_zone=>false
,p_selector=>'weather[0].description'
,p_remote_data_type=>'string'
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(125529768996821366)
,p_data_profile_id=>wwv_flow_imp.id(125526299272805380)
,p_name=>'TEMP'
,p_sequence=>5
,p_column_type=>'DATA'
,p_data_type=>'NUMBER'
,p_has_time_zone=>true
,p_selector=>'main.temp'
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(125530184323823492)
,p_data_profile_id=>wwv_flow_imp.id(125526299272805380)
,p_name=>'FEELS_LIKE'
,p_sequence=>6
,p_column_type=>'DATA'
,p_data_type=>'NUMBER'
,p_has_time_zone=>true
,p_selector=>'main.feels_like'
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(125530804767826314)
,p_data_profile_id=>wwv_flow_imp.id(125526299272805380)
,p_name=>'HUMIDITY'
,p_sequence=>7
,p_column_type=>'DATA'
,p_data_type=>'NUMBER'
,p_has_time_zone=>true
,p_selector=>'main.humidity'
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(125531245630828399)
,p_data_profile_id=>wwv_flow_imp.id(125526299272805380)
,p_name=>'WIND_SPEED'
,p_sequence=>17
,p_column_type=>'DATA'
,p_data_type=>'NUMBER'
,p_has_time_zone=>true
,p_selector=>'wind.speed'
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(125531615320830866)
,p_data_profile_id=>wwv_flow_imp.id(125526299272805380)
,p_name=>'CITY_NAME'
,p_sequence=>27
,p_column_type=>'DATA'
,p_data_type=>'VARCHAR2'
,p_max_length=>4000
,p_has_time_zone=>true
,p_selector=>'name'
);
end;
/
prompt --application/shared_components/data_profiles/customers_ords_api
begin
wwv_flow_imp_shared.create_data_profile(
 p_id=>wwv_flow_imp.id(125586260627473433)
,p_name=>'Customers_ORDS_API'
,p_format=>'JSON'
,p_row_selector=>'items'
,p_use_raw_json_selectors=>false
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(125586447717473442)
,p_data_profile_id=>wwv_flow_imp.id(125586260627473433)
,p_name=>'ID'
,p_sequence=>1
,p_column_type=>'DATA'
,p_data_type=>'NUMBER'
,p_has_time_zone=>false
,p_selector=>'id'
,p_remote_data_type=>'number'
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(125586725979473443)
,p_data_profile_id=>wwv_flow_imp.id(125586260627473433)
,p_name=>'CITY'
,p_sequence=>2
,p_column_type=>'DATA'
,p_data_type=>'VARCHAR2'
,p_max_length=>32767
,p_has_time_zone=>false
,p_selector=>'city'
,p_remote_data_type=>'string'
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(125587097729473444)
,p_data_profile_id=>wwv_flow_imp.id(125586260627473433)
,p_name=>'DEPT'
,p_sequence=>3
,p_column_type=>'DATA'
,p_data_type=>'VARCHAR2'
,p_max_length=>32767
,p_has_time_zone=>false
,p_selector=>'dept'
,p_remote_data_type=>'string'
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(125587311526473445)
,p_data_profile_id=>wwv_flow_imp.id(125586260627473433)
,p_name=>'NAME'
,p_sequence=>4
,p_column_type=>'DATA'
,p_data_type=>'VARCHAR2'
,p_max_length=>32767
,p_has_time_zone=>false
,p_selector=>'name'
,p_remote_data_type=>'string'
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(125587662007473446)
,p_data_profile_id=>wwv_flow_imp.id(125586260627473433)
,p_name=>'SALARY'
,p_sequence=>5
,p_column_type=>'DATA'
,p_data_type=>'NUMBER'
,p_has_time_zone=>false
,p_selector=>'salary'
,p_remote_data_type=>'number'
);
end;
/
prompt --application/shared_components/web_sources/openweather_api
begin
wwv_flow_imp_shared.create_web_source_module(
 p_id=>wwv_flow_imp.id(125527620851805401)
,p_name=>'OpenWeather_API'
,p_static_id=>'openweather_api'
,p_web_source_type=>'NATIVE_HTTP'
,p_data_profile_id=>wwv_flow_imp.id(125526299272805380)
,p_remote_server_id=>wwv_flow_imp.id(125526063639805376)
,p_url_path_prefix=>'/weather'
,p_version_scn=>46965043946955
);
wwv_flow_imp_shared.create_web_source_param(
 p_id=>wwv_flow_imp.id(125528209649805410)
,p_web_src_module_id=>wwv_flow_imp.id(125527620851805401)
,p_name=>'appid'
,p_param_type=>'QUERY_STRING'
,p_data_type=>'VARCHAR2'
,p_is_required=>false
,p_value=>'b8adc837dc7e5a93ace6c3e9dc5f99e5'
,p_is_static=>true
);
wwv_flow_imp_shared.create_web_source_param(
 p_id=>wwv_flow_imp.id(125528608944805412)
,p_web_src_module_id=>wwv_flow_imp.id(125527620851805401)
,p_name=>'q'
,p_param_type=>'QUERY_STRING'
,p_data_type=>'VARCHAR2'
,p_is_required=>false
,p_value=>'&P221_CITY.'
,p_is_static=>true
);
wwv_flow_imp_shared.create_web_source_param(
 p_id=>wwv_flow_imp.id(125529036472805413)
,p_web_src_module_id=>wwv_flow_imp.id(125527620851805401)
,p_name=>'units'
,p_param_type=>'QUERY_STRING'
,p_data_type=>'VARCHAR2'
,p_is_required=>false
,p_value=>'metric'
,p_is_static=>true
);
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(125527861933805404)
,p_web_src_module_id=>wwv_flow_imp.id(125527620851805401)
,p_operation=>'GET'
,p_database_operation=>'FETCH_COLLECTION'
,p_url_pattern=>'.'
,p_force_error_for_http_404=>false
,p_allow_fetch_all_rows=>false
);
end;
/
prompt --application/shared_components/web_sources/customers_ords_api
begin
wwv_flow_imp_shared.create_web_source_module(
 p_id=>wwv_flow_imp.id(125587992005473451)
,p_name=>'Customers_ORDS_API'
,p_static_id=>'customers_ords_api'
,p_web_source_type=>'NATIVE_HTTP'
,p_data_profile_id=>wwv_flow_imp.id(125586260627473433)
,p_remote_server_id=>wwv_flow_imp.id(125586067155473423)
,p_url_path_prefix=>'/customers/employees/'
,p_version_scn=>46965067086914
);
wwv_flow_imp_shared.create_web_source_param(
 p_id=>wwv_flow_imp.id(125605077435544901)
,p_web_src_module_id=>wwv_flow_imp.id(125587992005473451)
,p_name=>'name'
,p_param_type=>'QUERY_STRING'
,p_data_type=>'VARCHAR2'
,p_is_required=>false
,p_value=>'&P225_NAME.'
,p_omit_when_null=>true
);
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(125588169970473455)
,p_web_src_module_id=>wwv_flow_imp.id(125587992005473451)
,p_operation=>'GET'
,p_database_operation=>'FETCH_COLLECTION'
,p_url_pattern=>'.'
,p_force_error_for_http_404=>false
,p_allow_fetch_all_rows=>false
);
wwv_flow_imp_shared.create_web_source_param(
 p_id=>wwv_flow_imp.id(125614362926695651)
,p_web_src_module_id=>wwv_flow_imp.id(125587992005473451)
,p_web_src_operation_id=>wwv_flow_imp.id(125588169970473455)
,p_name=>'name'
,p_param_type=>'QUERY_STRING'
,p_data_type=>'VARCHAR2'
,p_is_required=>false
,p_value=>'&P225_NAME.'
,p_omit_when_null=>true
);
end;
/
prompt --application/shared_components/navigation/lists/administration
begin
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(17700251695857997)
,p_name=>'Administration'
,p_list_status=>'PUBLIC'
,p_version_scn=>44599878483296
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(17700401947857996)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Theme Style'
,p_list_item_link_target=>'f?p=&APP_ID.:102:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-desktop'
,p_list_text_01=>'Change user interface theme style for all users.'
,p_translate_list_text_y_n=>'Y'
,p_list_item_current_type=>'TARGET_PAGE'
);
end;
/
prompt --application/shared_components/navigation/lists/admin_reports
begin
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(17703021528818447)
,p_name=>'Admin Reports'
,p_list_status=>'PUBLIC'
,p_version_scn=>44599878830845
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(17703275121818445)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Activity Calendar'
,p_list_item_link_target=>'f?p=&APP_ID.:178:&SESSION.::&DEBUG.:178:::'
,p_list_item_icon=>'fa-calendar'
,p_list_text_01=>'View page views by user in a monthly calendar'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(17703628572818444)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Page Views'
,p_list_item_link_target=>'f?p=&APP_ID.:177:&SESSION.::&DEBUG.:177:::'
,p_list_item_icon=>'fa-eye'
,p_list_text_01=>'Report page view for this application'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(17704082884818443)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Top Users'
,p_list_item_link_target=>'f?p=&APP_ID.:179:&SESSION.::&DEBUG.:179:::'
,p_list_item_icon=>'fa-users'
,p_list_text_01=>'Report user activity for this application'
,p_list_item_current_type=>'TARGET_PAGE'
);
end;
/
prompt --application/shared_components/navigation/lists/desktop_navigation_bar_bottom
begin
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(19904756341214048)
,p_name=>'Desktop Navigation Bar Bottom'
,p_list_status=>'PUBLIC'
,p_version_scn=>41485223466566
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(19905490158230452)
,p_list_item_display_sequence=>5
,p_list_item_link_text=>'&APP_USER.'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-user'
,p_list_text_02=>'has-username'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(19905026145222003)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Log Out'
,p_list_item_link_target=>'&LOGOUT_URL.'
,p_list_item_current_type=>'TARGET_PAGE'
);
end;
/
prompt --application/shared_components/navigation/lists/customer_wizard_progress
begin
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(19971488251133380)
,p_name=>'Customer Wizard Progress'
,p_list_status=>'PUBLIC'
,p_version_scn=>44601615960986
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(19971685051133379)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Customer Info'
,p_list_item_link_target=>'f?p=&APP_ID.:198:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(19972035561133377)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Order Details'
,p_list_item_link_target=>'f?p=&APP_ID.:199:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-shopping-cart'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(19972455595133377)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Order Items'
,p_list_item_link_target=>'f?p=&APP_ID.:200:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-list'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(19972807323133376)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Review & Submit'
,p_list_item_link_target=>'f?p=&APP_ID.:201:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-check'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(19973228593133375)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Complete'
,p_list_item_link_target=>'f?p=&APP_ID.:202:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-flag-checkered'
,p_list_item_current_type=>'TARGET_PAGE'
);
end;
/
prompt --application/shared_components/navigation/lists/employee_wizard_progress
begin
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(22357796404559158)
,p_name=>'Employee Wizard Progress'
,p_list_status=>'PUBLIC'
,p_version_scn=>44722555700181
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(22357987059559156)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Upload'
,p_list_item_link_target=>'f?p=&APP_ID.:213:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-cloud-upload'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(22358349493559155)
,p_list_item_display_sequence=>20
,p_