--
-- Package "PKG_DASHBOARD_MGMT"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_THARUN"."PKG_DASHBOARD_MGMT" AS    
    -------------------------------------------------------------------------------------------------------------------------------------------------
    -- Section 1: Execute Dashboard
    -------------------------------------------------------------------------------------------------------------------------------------------------
    -- used to get dashboard data for different modes
    FUNCTION GET_DASHBOARD (
        P_IN_DASHBOARD_IDENT   NUMBER,
        P_IN_LOADING_MODE      VARCHAR2 := 'S',
        P_IN_ITEM_IDENT        NUMBER := NULL
    ) RETURN BLOB;

    -------------------------------------------------------------------------------------------------------------------------------------------------
    -- Section 2: Edit Dashboard (Create, Edit or Delete Dashboards and Items
    -------------------------------------------------------------------------------------------------------------------------------------------------

    PROCEDURE ADD_ITEM (
        P_IN_DASHBOARD_IDENT     NUMBER,
        P_IN_TYPE_ID             VARCHAR2,
        P_IN_ITEM_TITLE          VARCHAR2,
        P_IN_ITEM_WIDTH          NUMBER,
        P_IN_ITEM_HEIGHT         NUMBER,
        P_IN_ITEM_ORDER_NUMBER   NUMBER,
        P_IN_ATTRIBUTE_01        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_02        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_03        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_04        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_05        VARCHAR2 := NULL
    );

    PROCEDURE EDIT_ITEM (
        P_IN_ITEM_IDENT          NUMBER,
        P_IN_TYPE_ID             VARCHAR2,
        P_IN_ITEM_TITLE          VARCHAR2,
        P_IN_ITEM_WIDTH          NUMBER,
        P_IN_ITEM_HEIGHT         NUMBER,
        P_IN_ITEM_ORDER_NUMBER   NUMBER,
        P_IN_ATTRIBUTE_01        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_02        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_03        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_04        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_05        VARCHAR2 := NULL
    );

    PROCEDURE DELETE_ITEM (
        P_IN_ITEM_IDENT NUMBER
    );

    PROCEDURE STORE_NEW_ITEM_ORDER (
        P_IN_DASHBOARD_IDENT   NUMBER,
        P_IN_ITEMS             VARCHAR
    );

END;
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."PKG_DASHBOARD_MGMT" AS
    -------------------------------------------------------------------------------------------------------------------------------------------------
    -- Section 1: Execute Dashboard
    -------------------------------------------------------------------------------------------------------------------------------------------------
    
    -- used to get dashboard data for different modes
    FUNCTION GET_DASHBOARD (
        P_IN_DASHBOARD_IDENT   NUMBER,
        P_IN_LOADING_MODE      VARCHAR2 := 'S',
        P_IN_ITEM_IDENT        NUMBER := NULL
    ) RETURN BLOB AS

        B_BINARY_JSON   BLOB := EMPTY_BLOB();
        B_COMMA         CONSTANT BLOB := UTL_RAW.CAST_TO_RAW(',');
        I               PLS_INTEGER := 0;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(
            LOB_LOC   => B_BINARY_JSON,
            CACHE     => TRUE,
            DUR       => DBMS_LOB.CALL
        );

        FOR REC IN (
            SELECT
                ITEMS.*,
                COUNT(*) OVER() AS ITEMS_COUNT
            FROM
                (
                    SELECT
                        JSON_OBJECT (
                            /* required - ID of each item that is needed for async load and resort */
                            'itemID' VALUE TDI.ITEM_IDENT, 
                            /* required -  type of the item e.g. chart or calendar */
                            'itemType' VALUE TDI.TYPE_ID,
                            /* optional - title of the dashboard item */
                            'title' VALUE TDI.ITEM_TITLE,
                            /* optional - set background color of dashboard item */
                            'backColor' VALUE NULL, 
                            /* optional - set color of dashboard item */
                            'color' VALUE NULL,
                            /* optional - set box-shadow of dashboard item */
                            'boxShadow' VALUE null,
                            /* optional - set a background color for the item title */
                            'titleBackColor' VALUE NULL,
                            /* optional - set a icon for the item title */
                            'titleIcon' VALUE NULL, 
                            /* optional - set a color for the item title */
                            'titleColor' VALUE NULL,
                            /* optional - set width of the item between 1 and 12 */
                            'colSpan' VALUE TDI.ITEM_WIDTH,
                            /* optional - set height of the item */
                            'height' VALUE ( TDI.ITEM_HEIGHT * 90 ),
                            /* optional - set if the item is marked */
                            'isMarked' VALUE NULL,
                            /* optional - set if the item has auto refresh (Only for async items) */
                            'refresh' VALUE NULL,
                            /* optional - set if the item is loaded async */
                            'isAsync' VALUE CASE WHEN TDI.TYPE_ID IN ('chart', 'calendar') THEN 1 ELSE 0 END,
                            /* optional - set an url for the options link */
                            'optionsLink' VALUE APEX_PAGE.GET_URL(
                                P_PAGE     => 3,
                                P_ITEMS    => 'P3_ITEM_IDENT',
                                P_VALUES   => TDI.ITEM_IDENT
                            ),
                            /* optional - set icon for the options link */
                            'optionsLinkIcon' VALUE 'fa-edit',
                            /* optional - set background color for the options link */
                            'optionsLinkBackColor' VALUE NULL,
                            /* optional - set color for the options link */
                            'optionsLinkColor' VALUE NULL,
                            /* optional - set an url for the options link top */
                            'optionsLinkTop' VALUE NULL,
                            /* optional - set icon for the options link top */
                            'optionsLinkTopIcon' VALUE 'fa-edit',
                            /* optional - set background color for the options link top */
                            'optionsLinkTopBackColor' VALUE NULL,
                            /* optional - set color for the options link top */
                            'optionsLinkTopColor' VALUE NULL,
                            /* optional - when using sanitizer and want to exclude the item from sanitizing then set this 1 */
                            'noSanitize' VALUE NULL,
                            /* optional - here is the item config loaded */
                            'itemConfig' VALUE PKG_DASHBOARD_ITEM_DATA.GET_ITEM_CONFIG(
                                P_IN_IN_ITEM_IDENT => TDI.ITEM_IDENT,
                                P_IN_TYPE_ID => TDI.TYPE_ID,
                                P_IN_ATTRIBUTE_01 => TDI.ATTRIBUTE_01,
                                P_IN_ATTRIBUTE_02 => TDI.ATTRIBUTE_02,
                                P_IN_ATTRIBUTE_03 => TDI.ATTRIBUTE_03,
                                P_IN_ATTRIBUTE_04 => TDI.ATTRIBUTE_04,
                                P_IN_ATTRIBUTE_05 => TDI.ATTRIBUTE_05
                            ) FORMAT JSON,
                            /* optional - here is the item data loaded */
                            'itemData' VALUE PKG_DASHBOARD_ITEM_DATA.GET_ITEM_DATA(
                                P_IN_IN_ITEM_IDENT => TDI.ITEM_IDENT,
                                P_IN_TYPE_ID => TDI.TYPE_ID,
                                P_IN_LOADING_MODE => P_IN_LOADING_MODE,
                                P_IN_ATTRIBUTE_01 => TDI.ATTRIBUTE_01,
                                P_IN_ATTRIBUTE_02 => TDI.ATTRIBUTE_02,
                                P_IN_ATTRIBUTE_03 => TDI.ATTRIBUTE_03,
                                P_IN_ATTRIBUTE_04 => TDI.ATTRIBUTE_04,
                                P_IN_ATTRIBUTE_05 => TDI.ATTRIBUTE_05
                            ) FORMAT JSON 
                        RETURNING BLOB ) AS JSON_BLOB
                    FROM
                        T_DASHBOARD_ITEMS TDI
                    WHERE
                        TDI.DASHBOARD_IDENT = P_IN_DASHBOARD_IDENT
                        AND (TDI.ITEM_IDENT = P_IN_ITEM_IDENT
                            OR P_IN_ITEM_IDENT IS NULL)
                    ORDER BY
                        TDI.ITEM_ORDER_NUMBER
                ) ITEMS
        ) LOOP
            I := I + 1;
            DBMS_LOB.APPEND(
                B_BINARY_JSON,
                REC.JSON_BLOB
            );
                -- exit when it's the last item and don't add a comma at the end
            IF I = REC.ITEMS_COUNT THEN
                EXIT;
            ELSE
                DBMS_LOB.APPEND(
                    B_BINARY_JSON,
                    B_COMMA
                );
            END IF;

        END LOOP;

        RETURN B_BINARY_JSON;
    END;

    -------------------------------------------------------------------------------------------------------------------------------------------------
    -- Section 2: Edit Dashboard (Create, Edit or Delete Dashboards and Items
    -------------------------------------------------------------------------------------------------------------------------------------------------
    -- add a new dashboard item
    PROCEDURE ADD_ITEM (
        P_IN_DASHBOARD_IDENT     NUMBER,
        P_IN_TYPE_ID             VARCHAR2,
        P_IN_ITEM_TITLE          VARCHAR2,
        P_IN_ITEM_WIDTH          NUMBER,
        P_IN_ITEM_HEIGHT         NUMBER,
        P_IN_ITEM_ORDER_NUMBER   NUMBER,
        P_IN_ATTRIBUTE_01        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_02        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_03        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_04        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_05        VARCHAR2 := NULL
    ) AS
    BEGIN
        INSERT INTO T_DASHBOARD_ITEMS (
            DASHBOARD_IDENT,
            TYPE_ID,
            ITEM_TITLE,
            ITEM_WIDTH,
            ITEM_HEIGHT,
            ITEM_ORDER_NUMBER,
            ATTRIBUTE_01,
            ATTRIBUTE_02,
            ATTRIBUTE_03,
            ATTRIBUTE_04,
            ATTRIBUTE_05
        ) VALUES (
            P_IN_DASHBOARD_IDENT,
            P_IN_TYPE_ID,
            P_IN_ITEM_TITLE,
            P_IN_ITEM_WIDTH,
            P_IN_ITEM_HEIGHT,
            P_IN_ITEM_ORDER_NUMBER,
            P_IN_ATTRIBUTE_01,
            P_IN_ATTRIBUTE_02,
            P_IN_ATTRIBUTE_03,
            P_IN_ATTRIBUTE_04,
            P_IN_ATTRIBUTE_05
        );

    END;

    -- edit a dashboard item

    PROCEDURE EDIT_ITEM (
        P_IN_ITEM_IDENT          NUMBER,
        P_IN_TYPE_ID             VARCHAR2,
        P_IN_ITEM_TITLE          VARCHAR2,
        P_IN_ITEM_WIDTH          NUMBER,
        P_IN_ITEM_HEIGHT         NUMBER,
        P_IN_ITEM_ORDER_NUMBER   NUMBER,
        P_IN_ATTRIBUTE_01        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_02        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_03        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_04        VARCHAR2 := NULL,
        P_IN_ATTRIBUTE_05        VARCHAR2 := NULL
    ) AS
    BEGIN
        UPDATE T_DASHBOARD_ITEMS
        SET
            TYPE_ID = P_IN_TYPE_ID,
            ITEM_TITLE = P_IN_ITEM_TITLE,
            ITEM_WIDTH = P_IN_ITEM_WIDTH,
            ITEM_HEIGHT = P_IN_ITEM_HEIGHT,
            ITEM_ORDER_NUMBER = P_IN_ITEM_ORDER_NUMBER,
            ATTRIBUTE_01 = P_IN_ATTRIBUTE_01,
            ATTRIBUTE_02 = P_IN_ATTRIBUTE_02,
            ATTRIBUTE_03 = P_IN_ATTRIBUTE_03,
            ATTRIBUTE_04 = P_IN_ATTRIBUTE_04,
            ATTRIBUTE_05 = P_IN_ATTRIBUTE_05
        WHERE
            ITEM_IDENT = P_IN_ITEM_IDENT;

    END;

    -- delete a dashboard item
    PROCEDURE DELETE_ITEM (
        P_IN_ITEM_IDENT NUMBER
    ) AS
    BEGIN
        DELETE FROM T_DASHBOARD_ITEMS
        WHERE
            ITEM_IDENT = P_IN_ITEM_IDENT;

    END;

    PROCEDURE STORE_NEW_ITEM_ORDER (
        P_IN_DASHBOARD_IDENT   NUMBER,
        P_IN_ITEMS             VARCHAR
    ) AS
    BEGIN
        FOR REC IN (
            SELECT
                COLUMN_VALUE AS ITEM_IDENT,
                ROWNUM AS ITEM_ORDER_NUMBER
            FROM
                TABLE ( APEX_STRING.SPLIT(
                    P_IN_ITEMS,
                    ':'
                ) )
        ) LOOP
            UPDATE T_DASHBOARD_ITEMS
            SET
                ITEM_ORDER_NUMBER = REC.ITEM_ORDER_NUMBER
            WHERE
                ITEM_IDENT = REC.ITEM_IDENT
                AND DASHBOARD_IDENT = P_IN_DASHBOARD_IDENT;

        END LOOP;
    END;

END;
/