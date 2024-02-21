SELECT * FROM country_list;

SELECT * FROM netflix_dataset;

--Checking for duplicates 'country_list' table
SELECT show_title, COUNT(*)
FROM country_list
GROUP BY show_title
HAVING COUNT(*) > 1;

--Deleting duplicates from 'country_list' table
DELETE FROM country_list
WHERE ROWID IN (
    SELECT ROWID
    FROM (
        SELECT ROWID,
               ROW_NUMBER() OVER (PARTITION BY show_title ORDER BY ROWID) AS dup
        FROM country_list
    ) ct
    WHERE dup > 1
);

--Checking for duplicates 'netflix_dataset' table
SELECT title, COUNT(*)
FROM netflix_dataset
GROUP BY title
HAVING COUNT(*) > 1;

--Distribution of TV Shows vs. Movies
SELECT 
    SUM(CASE WHEN category = 'TV' THEN 1 ELSE 0 END) AS total_tv,
    SUM(CASE WHEN category = 'Films' THEN 1 ELSE 0 END) AS total_movie
FROM country_list;

 --Analyze total hours spent on each category (TV or movie)
SELECT cl.category, SUM(nm.hours_viewed) AS total_hours_viewed
FROM netflix_dataset nm
JOIN country_list cl ON nm.title = cl.show_title
GROUP BY cl.category;

--Count the total number of TV shows and movies released in each country
SELECT country_name, category,
    COUNT(*) AS total_releases
FROM country_list
GROUp BY country_name, category

--Analyze most-watched shows and movies based on 'hours_viewed'column
SELECT Title, SUM(Hours_Viewed) AS Total_Hours_Viewed
FROM netflix_dataset
GROUP BY Title
ORDER BY Total_Hours_Viewed DESC
FETCH FIRST 20 ROWS ONLY;

--Analyze the 20 most-watched TV shows and movies and shows in 2022
SELECT * FROM netflix_dataset
WHERE EXTRACT(YEAR FROM release_date) = 2022
ORDER BY hours_viewed DESC
FETCH FIRST 20 ROWS ONLY;

--Analyze the 20 most-watched TV shows and movies and shows in 2023
SELECT * FROM netflix_dataset
WHERE EXTRACT(YEAR FROM release_date) = 2023
ORDER BY hours_viewed DESC
FETCH FIRST 20 ROWS ONLY;

--Analyze the number of TV Shows and Movies available globally to understand the distribution of content
SELECT 
    SUM(CASE WHEN available_globally = 'Yes' THEN 1 ELSE 0 END) AS available_globally_yes,
    SUM(CASE WHEN available_globally = 'No' THEN 1 ELSE 0 END) AS available_globally_no
FROM netflix_dataset;

--Analyze how the release date of a movie or TV show affects its viewership by comparing the total hours viewed for content released in different months or seasons
SELECT EXTRACT (MONTH FROM release_date) AS release_month,
    SUM(hours_viewed) AS total_hours_viewed
FROM netflix_dataset
GROUP BY EXTRACT(MONTH FROM release_date)
ORDER BY total_hours_viewed DESC;

--Analyze how the release date of a movie affects its viewership by comparing the total hours viewed for movies released in different months or seasons.    
SELECT EXTRACT (DAY FROM release_date) AS release_day,
    SUM(hours_viewed) AS total_hours_viewed
FROM netflix_dataset  
GROUP BY EXTRACT(DAY FROM release_date)
ORDER BY release_day; --that didn't return any useful information

--10 most-watched TV shows on Netflix by 'hours_viewed' column
SELECT nd.title, cl.category, SUM(nd.hours_viewed) AS total_hours_viewed
FROM netflix_dataset nd
JOIN country_list cl ON nd.title = cl.show_title
WHERE cl.category LIKE '%TV%'
GROUP BY  nd.title, cl.category
ORDER BY total_hours_viewed DESC;

--10 most-watched movies on Netflix by 'hours_viewed' column
SELECT nd.title, cl.category, nd.hours_viewed
FROM netflix_dataset nd
JOIN country_list cl ON nd.title = cl.show_title
WHERE cl.category = 'Films'
GROUP BY  nd.title, cl.category, nd.hours_viewed
ORDER BY nd.hours_viewed DESC;





