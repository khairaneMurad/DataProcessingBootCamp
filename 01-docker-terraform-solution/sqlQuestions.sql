/*
Question 3: During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive),
how many trips, respectively, happened:
- Up to 1 mile
- In between 1 (exclusive) and 3 miles (inclusive),
- In between 3 (exclusive) and 7 miles (inclusive),
- In between 7 (exclusive) and 10 miles (inclusive),
- Over 10 miles
*/

SELECT
    ( select count(*)
      from "green_tripdata_2019-10"
      where lpep_pickup_datetime >= '2019-10-01' and lpep_pickup_datetime < '2019-11-01'
        and lpep_dropoff_datetime >= '2019-10-01' and lpep_dropoff_datetime < '2019-11-01'
        and trip_distance <= 1
    ) as UP_TO_ONE_MILE,
    ( select count(*)
      from "green_tripdata_2019-10"
      where lpep_pickup_datetime >= '2019-10-01' and lpep_pickup_datetime < '2019-11-01'
        and lpep_dropoff_datetime >= '2019-10-01' and lpep_dropoff_datetime < '2019-11-01'
        and trip_distance > 1 and trip_distance <= 3
    ) AS TRIPS_BETWEEN_1_AND_3E,
    ( select count(*)
      from "green_tripdata_2019-10"
      where lpep_pickup_datetime >= '2019-10-01' and lpep_pickup_datetime < '2019-11-01'
        and lpep_dropoff_datetime >= '2019-10-01' and lpep_dropoff_datetime < '2019-11-01'
        and trip_distance > 3 and trip_distance <= 7
    ) as TRIPS_BETWEEN_3_AND_7E,
    ( select count(*)
      from "green_tripdata_2019-10"
      where lpep_pickup_datetime >= '2019-10-01' and lpep_pickup_datetime < '2019-11-01'
        and lpep_dropoff_datetime >= '2019-10-01' and lpep_dropoff_datetime < '2019-11-01'
        and trip_distance > 7 and trip_distance <= 10
    ) as TRIPS_BETWEEN_7_AND_10E,
    ( select count(*)
      from "green_tripdata_2019-10"
      where lpep_pickup_datetime >= '2019-10-01' and lpep_pickup_datetime < '2019-11-01'
        and lpep_dropoff_datetime >= '2019-10-01' and lpep_dropoff_datetime < '2019-11-01'
        and trip_distance > 10) as TRIPS_BEYOND_10E;

/*
Question 4: Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.
Tip: For every day, we only care about one single trip with the longest distance.
*/

select DATE_TRUNC('day', lpep_pickup_datetime)::date as pickup_day, trip_distance
from "green_tripdata_2019-10"
order by trip_distance desc
    limit 1;

/*
Question 5: Which were the top pickup locations with over 13,000 in total_amount (across all trips) for 2019-10-18?
Consider only lpep_pickup_datetime when filtering by date.
*/
SELECT
    zl."Zone" as pickup_zone,
    zl."Borough" as borough,
    SUM(gt.total_amount) as total_amount
FROM "green_tripdata_2019-10" gt JOIN taxi_zone_lookup zl ON gt."PULocationID" = zl."LocationID"
WHERE DATE_TRUNC('day', gt.lpep_pickup_datetime)::date = '2019-10-18'
GROUP BY zl."Zone", zl."Borough"
HAVING SUM(gt.total_amount) > 13000
ORDER BY total_amount DESC;

/*
Question 6: For the passengers picked up in October 2019 in the zone name "East Harlem North"
which was the drop off zone that had the largest tip?
Note: it's tip , not trip
We need the name of the zone, not the ID.
*/

select dropoff."Zone", max(t.tip_amount) as largest_tip
from "green_tripdata_2019-10" t JOIN taxi_zone_lookup pickup ON t."PULocationID" = pickup."LocationID"
                                JOIN taxi_zone_lookup dropoff ON t."DOLocationID" = dropoff."LocationID"
where DATE_TRUNC('day', t.lpep_pickup_datetime)::date between '2019-10-01' and '2019-10-31'
and pickup."Zone" = 'East Harlem North'
group by dropoff."Zone"
ORDER BY largest_tip DESC
    limit 1;