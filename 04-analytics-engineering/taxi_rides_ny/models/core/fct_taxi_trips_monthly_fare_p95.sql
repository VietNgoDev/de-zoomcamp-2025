WITH percentile AS (
  SELECT
    service_type, pickup_year, pickup_month,
    PERCENTILE_CONT(fare_amount, 0.97) OVER(PARTITION BY service_type, pickup_year, pickup_month) AS p97,
    PERCENTILE_CONT(fare_amount, 0.95) OVER(PARTITION BY service_type, pickup_year, pickup_month) AS p95,
    PERCENTILE_CONT(fare_amount, 0.90) OVER(PARTITION BY service_type, pickup_year, pickup_month) AS p90,
    ROW_NUMBER() OVER (
        PARTITION BY service_type, pickup_year, pickup_month
        ORDER BY pickup_datetime
      ) AS rn
  FROM `coral-balancer-380015.dbt_vngo.fact_trips`
  WHERE fare_amount > 0 
  AND trip_distance > 0 
  AND payment_type_description IN ('Cash', 'Credit Card')
  AND pickup_year = '2020' 
  AND pickup_month = '04'
)

SELECT service_type, p97, p95, p90
FROM percentile
WHERE rn = 1