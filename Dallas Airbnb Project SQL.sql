select *
from usethis$

--Counting the numbe of amenities offered by each host
ALTER TABLE usethis$ ADD number_of_amenities INT;

UPDATE usethis$
SET 
	number_of_amenities = amenity_counts.count
FROM usethis$
JOIN (
    SELECT id, LEN(amenities) - LEN(REPLACE(amenities, ',', '')) + 1 AS count
    FROM usethis$
) amenity_counts
ON usethis$.id = amenity_counts.id;

--Dropping rows with null values
DELETE FROM usethis$
WHERE description is null or host_neighbourhood is null  or bedrooms is null or first_review is null or last_review is null or review_scores_rating is null or reviews_per_month is null or host_response_rate IS NULL or host_location is null or host_acceptance_rate  is null or beds is null or review_scores_accuracy is null;

--DROPPING UNNECESARY COLUMN
alter table usethis$
drop column listing_url ,neighborhood_overview,scrape_id,host_about,neighbourhood,neighbourhood_group_cleansed,bathrooms,license,calendar_updated, host_verifications,host_picture_url,host_thumbnail_url,host_url,picture_url,source ,last_scraped

--DROPPING DUPLICATE ROWS i.e listings with the same name
WITH deletingcte AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY name ORDER BY name) AS duplicate_count
    FROM usethis$
)
DELETE FROM deletingcte
WHERE duplicate_count > 1;


--HOSTS WITHT THE MOST APPARTMENT LISTINGS
select 
	host_name , 
	count(*) as listing_count
from usethis$
group by 
	host_name
order by 
	listing_count desc

--PROPERTY TYPE WITH THE MOST LISTINGS
SELECT 
	property_type,
	count(*) as apartment_type_count
from 
	usethis$
group by 
	property_type
order by 
	apartment_type_count desc

 --TOP SELLING LISTINGS
select 
	property_type,
	host_name, price, 
	bedrooms,
	review_scores_location,
	review_scores_rating
from 
	dbo.usethis$
order by 
	price desc

--NUMBER OF REVIEWS per host
select 
	host_name ,
	sum(number_of_reviews) as nmber_of_reviews
from 
	usethis$
group by 
	host_name
order by 
	host_name asc

--Average rating per Property
select 
	property_type,
		AVG(review_scores_rating) as Average1
from 
	usethis$
group by 
	property_type
having 
	AVG(review_scores_rating) is not null
order by 
	property_type asc

--HOSTS WITHT THE MOST APPARTMENT LISTINGS
select 
	host_name , 
	count(*) as listing_count
from 
	usethis$
group by 
	host_name
order by 
	listing_count desc

