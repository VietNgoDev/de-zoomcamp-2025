WITH trip_durations AS (
  SELECT
    pickup_locationid, dropoff_locationid,
    pickup_zone, dropoff_zone,
    TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) AS trip_duration
  FROM `coral-balancer-380015.dbt_vngo.fact_fhv_trips`
  WHERE pickup_zone IN ('Newark Airport', 'SoHo', 'Yorkville East')
    AND pickup_year = '2019' AND pickup_month = '11'
),
percentile AS (
  SELECT 
    pickup_zone, dropoff_zone,
    PERCENTILE_CONT(trip_duration, 0.90) OVER(PARTITION BY pickup_locationid, dropoff_locationid) AS p90,
    ROW_NUMBER() OVER (PARTITION BY pickup_locationid, dropoff_locationid) AS rn
  FROM trip_durations
),
percentile_unique AS (
  SELECT pickup_zone, dropoff_zone, p90,
    ROW_NUMBER() OVER (PARTITION BY pickup_zone ORDER BY p90 DESC) AS p90_rank
  FROM percentile
  WHERE rn = 1
)

SELECT pickup_zone, dropoff_zone 
FROM percentile_unique
WHERE p90_rank = 2