## Setup BigQuery
```
CREATE OR REPLACE EXTERNAL TABLE `hw3_de_zoomcamp_2025.yellow_tripdata_2024`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://hw3_de_zoomcamp_2025/yellow_tripdata_2024-*.parquet']
);

CREATE OR REPLACE TABLE `hw3_de_zoomcamp_2025.yellow_tripdata_2024_nonpartitioned`
AS SELECT * FROM `hw3_de_zoomcamp_2025.yellow_tripdata_2024`;
```

## Question 1
```
SELECT COUNT(*) FROM `hw3_de_zoomcamp_2025.yellow_tripdata_2024`;
```

## Question 2
```
SELECT COUNT(DISTINCT PULocationID)
FROM `hw3_de_zoomcamp_2025.yellow_tripdata_2024`; -- 0 MB

SELECT COUNT(DISTINCT PULocationID)
FROM `hw3_de_zoomcamp_2025.yellow_tripdata_2024_nonpartitioned`; -- 155.12 MB
```

## Question 3
```
SELECT PULocationID
FROM `hw3_de_zoomcamp_2025.yellow_tripdata_2024_nonpartitioned`; -- 155.12 MB

SELECT PULocationID, DOLocationID
FROM `hw3_de_zoomcamp_2025.yellow_tripdata_2024_nonpartitioned`; -- 310.24 MB
```

## Question 4
```
SELECT COUNT(*)
FROM `hw3_de_zoomcamp_2025.yellow_tripdata_2024`
WHERE fare_amount = 0;
```

## Question 5
```
CREATE OR REPLACE TABLE `hw3_de_zoomcamp_2025.yellow_tripdata_2024_partitioned`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS (
  SELECT * FROM `hw3_de_zoomcamp_2025.yellow_tripdata_2024`
);
```

## Question 6
```
SELECT COUNT(DISTINCT VendorID)
FROM `hw3_de_zoomcamp_2025.yellow_tripdata_2024_nonpartitioned`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15'; -- 337.08 MB

SELECT COUNT(DISTINCT VendorID)
FROM `hw3_de_zoomcamp_2025.yellow_tripdata_2024_partitioned`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15'; -- 26.84 MB
```

## Question 9
```
SELECT COUNT(*) FROM `hw3_de_zoomcamp_2025.yellow_tripdata_2024_nonpartitioned`;
-- 0B will be processed because the materialized table in BigQuery have metadata already have the result for the row counts.
```
