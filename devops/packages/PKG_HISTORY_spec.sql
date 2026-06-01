--
-- Package "PKG_HISTORY"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_THARUN"."PKG_HISTORY" is

procedure P_TABLE_Historie (aDSid in number, aBenutzerid in number default null);

end PKG_HISTORY;
/