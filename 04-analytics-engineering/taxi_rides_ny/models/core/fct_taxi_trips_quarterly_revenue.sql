WITH quarterly_revenue AS (
  SELECT
    service_type,
    pickup_year_quarter,
    pickup_quarter,
    SUM(total_amount) AS total_revenue
  FROM `coral-balancer-380015.dbt_vngo.fact_trips`
  WHERE pickup_year IN ('2019','2020')
  GROUP BY
    service_type,
    pickup_year_quarter,
    pickup_quarter
)

SELECT
  rev2020.service_type,
  rev2019.pickup_year_quarter AS quarter_2019,
  rev2019.total_revenue       AS revenue_2019,
  rev2020.pickup_year_quarter AS quarter_2020,
  rev2020.total_revenue       AS revenue_2020,
  ROUND((rev2020.total_revenue - rev2019.total_revenue) / rev2019.total_revenue * 100, 2) AS yoy_growth_pct
FROM quarterly_revenue rev2020
JOIN quarterly_revenue rev2019
  ON rev2020.service_type       = rev2019.service_type
  AND rev2020.pickup_quarter    = rev2019.pickup_quarter
  -- Match 2020's quarter to 2019's quarter
  AND rev2020.pickup_year_quarter LIKE '2020%'
  AND rev2019.pickup_year_quarter LIKE '2019%'
ORDER BY
  rev2020.service_type,
  rev2020.pickup_quarter
