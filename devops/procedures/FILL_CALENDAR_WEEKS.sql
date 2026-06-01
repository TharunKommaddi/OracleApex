--
-- Procedure "FILL_CALENDAR_WEEKS"
--
CREATE OR REPLACE EDITIONABLE PROCEDURE "WKSP_THARUN"."FILL_CALENDAR_WEEKS" (p_year NUMBER DEFAULT 2024) IS
    l_week_start DATE;
    l_week_end DATE;
    l_holidays VARCHAR2(500);
    l_holiday_count NUMBER;
    l_business_days NUMBER;
    l_week_type VARCHAR2(20);
BEGIN
    -- Clear existing data for the year
    DELETE FROM calendar_weeks WHERE year_number = p_year;
    
    -- Start with first Monday of the year
    l_week_start := TRUNC(TO_DATE(p_year || '-01-01', 'YYYY-MM-DD'), 'IW');
    
    -- Generate weeks for the whole year
    FOR week_num IN 1..53 LOOP
        l_week_end := l_week_start + 6;
        
        -- Find holidays in this week
        SELECT LISTAGG(holiday_name, ', ') WITHIN GROUP (ORDER BY holiday_date),
               COUNT(*)
        INTO l_holidays, l_holiday_count
        FROM german_holidays_simple
        WHERE holiday_date BETWEEN l_week_start AND l_week_end
        AND (state_code = 'ALL' OR state_code = 'HE') -- Hesse holidays
        AND EXTRACT(YEAR FROM holiday_date) = p_year;
        
        -- Calculate business days (assuming 5 work days minus holidays)
        l_business_days := GREATEST(0, 5 - l_holiday_count);
        
        -- Determine week type
        CASE 
            WHEN l_holiday_count >= 2 THEN l_week_type := 'holiday_heavy';
            WHEN l_holiday_count = 1 THEN l_week_type := 'holiday';
            ELSE l_week_type := 'normal';
        END CASE;
        
        -- Only insert weeks that actually belong to this year
        IF EXTRACT(YEAR FROM l_week_start) = p_year OR 
           EXTRACT(YEAR FROM l_week_end) = p_year THEN
           
            INSERT INTO calendar_weeks (
                week_id, week_number, year_number, 
                week_start_date, week_end_date, week_type,
                holiday_names, business_days
            ) VALUES (
                (p_year * 100) + week_num, week_num, p_year,
                l_week_start, l_week_end, l_week_type,
                l_holidays, l_business_days
            );
        END IF;
        
        l_week_start := l_week_start + 7;
        l_holidays := NULL;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Calendar populated for year ' || p_year);
END;
/