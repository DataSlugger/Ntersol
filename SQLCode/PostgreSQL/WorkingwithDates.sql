SELECT
  ((NOW()) :: DATE - INTERVAL '1 day') :: DATE AS "Now Day Before",
  NOW() AS "Now Time",
  ((CURRENT_DATE AT TIME ZONE 'CST') :: DATE - INTERVAL '2 day') :: DATE AS "HoustonDayBefore",
  (CURRENT_DATE AT TIME ZONE 'CST') :: DATE AS "HoustonTime",
  CURRENT_DATE :: DATE AS "UTCDate";


  SELECT
    TIMEZONE('America/Chicago', CURRENT_DATE) :: DATE AS "TEstingDAte";

  SELECT
    (CURRENT_DATE) :: DATE AS "TEstingDAte2";

  
