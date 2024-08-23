<h1>Materialized View and Usage Guide</h1>
<h3>Create View:</h3>
<pre data-line="1" class="language-sql line-numbers"><code class="language-sql">CREATE VIEW V_CUSTOMERS AS
SELECT CUSTOMER_ID, NAME, ADDRESS, CITY, STATE, ZIPCODE, EMAIL, PHONE 
FROM T_CUSTOMERS;
</code></pre>

<h3>Create Materialized View:</h3>
<pre data-line="1" class="language-sql line-numbers"><code class="language-sql">CREATE MATERIALIZED VIEW MV_V_T_CUSTOMERS
AS 
SELECT *
FROM V_CUSTOMERS;
</code></pre>

<h3>Create Job Scheduler:</h3>
<pre data-line="1" class="language-sql line-numbers"><code class="language-sql">BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name        => 'J_REFRESH_MV_V_T_CUSTOMERS',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN DBMS_MVIEW.REFRESH(''MV_V_T_CUSTOMERS''); END;',
    -- start_date      => TRUNC(SYSDATE) + 1, -- Start tomorrow
    start_date      => SYSDATE, -- Starts immediately
    --  repeat_interval => 'FREQ=DAILY;BYHOUR=2;BYDAY=MON,TUE,WED,THU,FRI', -- Daily at 2 AM on weekdays
    repeat_interval => 'FREQ=DAILY;BYHOUR=2', -- Daily at 2 AM
    end_date        => NULL, -- No end date (run indefinitely)
    enabled         => TRUE,
    comments        => 'Refresh materialized view MV_V_T_CUSTOMERS'
  );
END;
/
</code></pre>
