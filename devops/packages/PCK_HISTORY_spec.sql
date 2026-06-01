--
-- Package "PCK_HISTORY"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_THARUN"."PCK_HISTORY" AS
    -- Function to compare and highlight differences between current and previous values
    FUNCTION fDiff(
        aCurrent IN VARCHAR2, 
        aPrevious IN VARCHAR2, 
        aAction IN NUMBER DEFAULT 20
    ) RETURN VARCHAR2;

END PCK_HISTORY;
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."PCK_HISTORY" AS
   
   /*
   
   FUNCTION fDiff(
       aCurrent IN VARCHAR2, 
       aPrevious IN VARCHAR2, 
       aAction IN NUMBER DEFAULT 20
   ) RETURN VARCHAR2 AS
   BEGIN
       RETURN 
           CASE 
               -- No change (Update with same value)
               WHEN aCurrent = aPrevious AND aAction = 20 THEN
                   apex_escape.html(aCurrent)
                   
               -- Both values null 
               WHEN aCurrent IS NULL AND aPrevious IS NULL THEN
                   NULL
                   
               -- Deletion or value removed
               WHEN aCurrent IS NULL OR aAction = 30 THEN
                   '<span style="color:red;text-decoration:line-through;background-color:pink;">' 
                   || apex_escape.html(aPrevious) 
                   || '</span>'
                   
               -- Insertion or new value added
               WHEN aPrevious IS NULL OR aAction = 10 THEN
                   '<span style="color:green; background-color:palegreen">' 
                   || apex_escape.html(aCurrent) 
                   || '</span>'
                   
               -- Value changed (show both old and new)
               ELSE
                   '<span style="color:green; background-color:palegreen">' 
                   || apex_escape.html(aCurrent) 
                   || '</span> <span style="color:red;text-decoration:line-through;background-color:pink;">' 
                   || apex_escape.html(aPrevious) 
                   || '</span>'        
           END;
   END fDiff;

   */

    FUNCTION fDiff(
       aCurrent IN VARCHAR2, 
       aPrevious IN VARCHAR2, 
       aAction IN NUMBER DEFAULT 20
   ) RETURN VARCHAR2 AS
   BEGIN
       CASE aAction
           -- INSERT (10) - BLUE background
           WHEN 10 THEN 
               RETURN '<span style="color:blue; background-color:lightblue">' 
                      || apex_escape.html(aCurrent) 
                      || '</span>';
               
           -- UPDATE (20) - GREEN background
           WHEN 20 THEN 
               IF aCurrent != aPrevious OR (aCurrent IS NULL AND aPrevious IS NOT NULL) 
                  OR (aCurrent IS NOT NULL AND aPrevious IS NULL) THEN
                   RETURN '<span style="color:green; background-color:palegreen">' 
                          || apex_escape.html(aCurrent) 
                          || '</span>';
               ELSE
                   RETURN apex_escape.html(aCurrent);
               END IF;
               
           -- DELETE (30) - RED background with strikethrough
           WHEN 30 THEN 
               RETURN '<span style="color:red;text-decoration:line-through;background-color:pink;">' 
                      || apex_escape.html(aPrevious) 
                      || '</span>';
               
           ELSE
               RETURN apex_escape.html(aCurrent);
       END CASE;
   END fDiff;



   



END PCK_HISTORY;
/