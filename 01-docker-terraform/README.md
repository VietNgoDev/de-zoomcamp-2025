## Question 1
```
docker run -it --entrypoint=bash python:3.12.8
pip --version
```
## Question 2
```
python ingest_data.py \
   --user=root \
   --password=root \
   --host=localhost \
   --port=5432 \
   --db=ny_taxi \
   --table_name=green_taxi_trips \
   --url=https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz

python ingest_data.py \
   --user=root \
   --password=root \
   --host=localhost \
   --port=5432 \
   --db=ny_taxi \
   --table_name=taxi_zones \
   --url=https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
```

## Question 3
```
select trip_type, count(trip_type)
from (select 
	case when trip_distance <= 1 then 'A'
		 when trip_distance > 1 and trip_distance <= 3 then 'B'
	     when trip_distance > 3 and trip_distance <= 7 then 'C'
	     when trip_distance > 7 and trip_distance <= 10 then 'D'
		 else 'E' end as trip_type
from green_taxi_trips
where lpep_pickup_datetime >= '2019-10-01'
and lpep_dropoff_datetime < '2019-11-01') as sub
group by trip_type;
```

## Question 4
```
select lpep_pickup_datetime::date
from green_taxi_trips
where trip_distance = (select max(trip_distance) from green_taxi_trips);
```

## Question 5
```
select "Zone"
from (
	select "PULocationID", sum(total_amount) as sum_total
	from green_taxi_trips
	where lpep_pickup_datetime::date = '2019-10-18'
	group by "PULocationID" 
	having sum(total_amount) > 13000
) as sub
join taxi_zones tz on sub."PULocationID" = tz."LocationID";
```

## Question 6
```
select "Zone"
from taxi_zones
where "LocationID" = (
	select "DOLocationID"
	from green_taxi_trips
	where tip_amount = (
		select max(tip_amount)
		from green_taxi_trips
		where lpep_pickup_datetime >= '2019-10-01' and lpep_pickup_datetime < '2019-11-01'
		and "PULocationID" = (select "LocationID" from taxi_zones where "Zone" = 'East Harlem North')
	)
)
```

## Question 7
```
terraform init, terraform apply -auto-approve, terraform destroy
```