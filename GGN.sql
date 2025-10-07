--  NETFLIX PROJECT
-- TABLES
CREATE TABLE netflix(
show_id VARCHAR(6),
type VARCHAR (10),
title VARCHAR(150),
director VARCHAR(208),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250)
)

DROP TABLE NETFLIX;

SELECT * FROM NETFLIX;

-- TASKS 
/*
1. Count the Number of Movies vs TV Shows.Determine the distribution of content types on Netflix.
2. Find the Most Common Rating for Movies and TV ShowS.Identify the most frequently occurring rating for each type of content.
3. List All Movies Released in a Specific Year (e.g., 2020). Retrieve all movies released in a specific year.
4. Find the Top 5 Countries with the Most Content on Netflix.Identify the top 5 countries with the highest number of content items.
5. Identify the Longest Movie.Find the movie with the longest duration.
6. Find Content Added in the Last 5 Years. Retrieve content added to Netflix in the last 5 years.
7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'. List all content directed by 'Rajiv Chilaka'.
8. List All TV Shows with More Than 5 Seasons. Identify TV shows with more than 5 seasons.
9. Count the Number of Content Items in Each Genre. Count the number of content items in each genre.
10.Find each year and the average numbers of content release in India on netflix.return top 5 year with highest avg content release!
 Calculate and rank years by the average number of content releases by India.
11. List All Movies that are Documentaries. Retrieve all movies classified as documentaries.
12. Find All Content Without a Director. List content that does not have a director.
13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years. Count the number of movies featuring 'Salman Khan' 
in the last 10 years.
14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India. Identify the top 10 actors with the
most appearances in Indian-produced movies.
15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords.
Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.
*/

-- 1. Count the Number of Movies vs TV Shows. Determine the distribution of content types on Netflix.

SELECT 
	type,
	COUNT(*)
FROM netflix
GROUP BY type
;

-- 2. Find the Most Common Rating for Movies and TV ShowS.Identify the most frequently occurring rating for each type of content.

SELECT type, rating 
FROM 
(SELECT 
	TYPE,
	RATING,
	COUNT(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM NETFLIX
GROUP BY 1,2) AS t1
WHERE RANKING = 1

-- 3. List All Movies Released in a Specific Year (e.g., 2020). Retrieve all movies released in a specific year.

SELECT 
*
FROM NETFLIX
WHERE TYPE = 'Movie'
AND release_year = 2020

-- 4. Find the Top 5 Countries with the Most Content on Netflix.Identify the top 5 countries with the highest number of content items.
SELECT 
TRIM(UNNEST(STRING_TO_ARRAY(country,','))),
COUNT(show_id) as total_content FROM NETFLIX
group by 1
order by 2 desc
limit 5

--select UNNEST(STRING_TO_ARRAY(country,',')) FROM NETFLIX -- ITS USED TO CHANGE AN ARRAY INTO A SET OF ROWS

-- 5. Identify the Longest Movie.Find the movie with the longest duration.

SELECT title, duration, type
FROM netflix
WHERE type = 'Movie'
  AND duration ~ '^[0-9]+ min$'
ORDER BY CAST(split_part(duration, ' ', 1) AS INTEGER) DESC;

-- 6. Find Content Added in the Last 5 Years. Retrieve content added to Netflix in the last 5 years.
SELECT 
    title, 
    TO_DATE(date_added, 'Month DD, YYYY') AS added_date
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
ORDER BY added_date DESC;

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'. List all content directed by 'Rajiv Chilaka'.

-- THIS WAY ONLY FINDS WHERE ONLY DIRECTOR IS RAJIV CHILAKA
SELECT  director,TITLE FROM NETFLIX
WHERE 
DIRECTOR = 'Rajiv Chilaka'

-- OTHER WAY IS MAKING THIS STRING TO AN ARRAY
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';

-- OTHER WAY
SELECT *
FROM NETFLIX
WHERE DIRECTOR ILIKE '%Rajiv Chilaka%'

-- 8. List All TV Shows with More Than 5 Seasons. Identify TV shows with more than 5 seasons.

SELECT *
FROM NETFLIX
WHERE TYPE = 'TV Show'
AND 
SPLIT_PART(duration, ' ', 1)::INT > 5;

-- 9. Count the Number of Content Items in Each Genre.

SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;

-- 10.Find each year and the average numbers of content release in India on netflix.return top 5 year with highest avg content release!
-- Calculate and rank years by the average number of content releases by India.
/*11. List All Movies that are Documentaries. Retrieve all movies classified as documentaries.
12. Find All Content Without a Director. List content that does not have a director.
13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years. Count the number of movies featuring 'Salman Khan' 
in the last 10 years.
14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India. Identify the top 10 actors with the
most appearances in Indian-produced movies.
15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords.
Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.*/
-- 12. Find All Content Without a Director
SELECT * 
FROM netflix
WHERE director IS NULL;