--
-- View "V_CALENDAR_OVERVIEW"
--
CREATE OR REPLACE FORCE EDITIONABLE VIEW "WKSP_THARUN"."V_CALENDAR_OVERVIEW" ("WEEK_NUMBER", "WEEK_START", "WEEK_END", "WEEK_TYPE", "BUSINESS_DAYS", "HOLIDAY_NAMES", "SELECTION_STATUS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 
    week_number,
    TO_CHAR(week_start_date, 'DD.MM.YYYY') as week_start,
    TO_CHAR(week_end_date, 'DD.MM.YYYY') as week_end,
    week_type,
    business_days,
    holiday_names,
    CASE WHEN is_selected = 'Y' THEN 'SELECTED' ELSE '' END as selection_status
FROM calendar_weeks
WHERE year_number = 2024
ORDER BY week_number
/