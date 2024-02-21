FORMATTED

-- 1. Ranking Rows Based on a Specific Ordering Criteria (price)

SELECT 
    RANK() OVER (ORDER BY price DESC),
    ROUND(CAST(price AS numeric)), 
    squarefeet,
    bedrooms,
    bathrooms,
    neighborhood,
    yearbuilt
FROM HousePrice;

-- 2. List The First 5 Rows of a Result Set

WITH priceranking AS (
    SELECT 
        RANK() OVER (ORDER BY price DESC) AS ranking,
        ROUND(CAST(price AS numeric)), 
        squarefeet,
        bedrooms,
        bathrooms,
        neighborhood,
        yearbuilt
    FROM HousePrice
)
SELECT 
    squarefeet,
    bedrooms, 
    bathrooms,
    neighborhood,
    yearbuilt
FROM priceranking
WHERE ranking <= 5
ORDER BY ranking;

-- 3. List the Last 5 Rows of a Result Set

WITH priceranking AS (
    SELECT
        RANK() OVER (ORDER BY price ASC) AS ranking,
        ROUND(CAST(price AS numeric)),
        squarefeet,
        bedrooms,
        bathrooms,
        neighborhood,
        yearbuilt
    FROM HousePrice
)
SELECT 
    squarefeet,
    bedrooms, 
    bathrooms,
    neighborhood,
    yearbuilt
FROM priceranking
WHERE ranking <= 5
ORDER BY ranking DESC;

-- 4. List The Second Highest Row of a Result Set

WITH priceranking AS (
    SELECT 
        RANK() OVER (ORDER BY price DESC) AS ranking,
        ROUND(CAST(price AS numeric)),
        squarefeet,
        bedrooms,
        bathrooms,
        neighborhood,
        yearbuilt
    FROM HousePrice
)
SELECT 
    squarefeet,
    bedrooms, 
    bathrooms,
    neighborhood,
    yearbuilt
FROM priceranking 
WHERE ranking = 2
ORDER BY ranking;

-- 5. List the Second Highest Price By Neighborhood

WITH priceranking AS (
    SELECT 
        RANK() OVER (PARTITION BY neighborhood ORDER BY price DESC) AS ranking,
        neighborhood,
        squarefeet,
        bedrooms,
        bathrooms,
        yearbuilt,
        price
    FROM houseprice
)
SELECT 
    ranking,
    neighborhood,
    squarefeet,
    bedrooms,
    bathrooms,
    yearbuilt,
    price
FROM priceranking
WHERE ranking = 2
ORDER BY ranking;

-- 6. List the First 50% Rows in a Result Set
WITH priceranking AS (
    SELECT 
        NTILE(2) OVER (ORDER BY price DESC) AS ntile,
        squarefeet,
        bedrooms,
        bathrooms,
        neighborhood,
        yearbuilt,
        price
    FROM houseprice
)
SELECT 
    squarefeet,
    bedrooms,
    bathrooms,
    neighborhood,
    yearbuilt,
    price
FROM priceranking
WHERE ntile = 1
ORDER BY price;

-- 7. List the Last 25% Rows in a Result Set

WITH priceranking AS (
    SELECT
        NTILE(4) OVER (ORDER BY price DESC) as ntile,
        squarefeet,
        bedrooms,
        bathrooms,
        neighborhood,
        yearbuilt,
        price
    FROM houseprice
)
SELECT 
    squarefeet, 
    bedrooms,
    bathrooms,
    neighborhood,
    yearbuilt,
    price
FROM priceranking
WHERE ntile = 4
ORDER BY price;

-- 8. Number of the Rows in a Result Set

SELECT 
    squarefeet, 
    bedrooms,
    bathrooms,
    neighborhood,
    yearbuilt,
    price,
    ROW_NUMBER() OVER (ORDER BY price DESC) as ranking_position
FROM houseprice;

-- 9. Show All Rows with an Above-Average Value

SELECT *
FROM houseprice
WHERE price > (SELECT AVG(price) as avg_price
               FROM houseprice);
			  
-- 10. Houses with prices Higher Than Their Neighborhood Average (correlated subquery)

SELECT h1.price, h1.neighborhood
FROM houseprice h1
WHERE h1.price > (SELECT AVG(h2.price)
                  FROM houseprice h2
                  WHERE h1.neighborhood = h2.neighborhood);

-- 11. Find Duplicate Rows in SQL

SELECT squarefeet,
       bedrooms,
       bathrooms,
       neighborhood,
       yearbuilt,
       price
FROM houseprice
GROUP BY squarefeet,
         bedrooms,
         bathrooms,
         neighborhood,
         yearbuilt,
         price
HAVING COUNT(*) > 1;

-- 12. Count Duplicate Rows

SELECT squarefeet, 
       bedrooms,
       bathrooms,
       neighborhood, 
       yearbuilt,
       price,
       COUNT(*) as number_of_rows
FROM houseprice
GROUP BY squarefeet, 
         bedrooms,
         bathrooms,
         neighborhood, 
         yearbuilt,
         price
HAVING COUNT(*) > 1;
 

-- 13. Grouping Data with ROLLUP

SELECT yearbuilt, price, COUNT(*) AS number
FROM houseprice
GROUP BY ROLLUP (price, yearbuilt);

-- 14. Conditional Summation

SELECT 
    AVG(CASE WHEN bedrooms = 2 AND bathrooms = 1 AND neighborhood IN ('Rural') THEN price ELSE 0 END) AS small_house_avg_price,
    AVG(CASE WHEN bedrooms = 5 AND bathrooms = 3 AND neighborhood IN ('Rural') THEN price ELSE 0 END) AS big_house_avg_price
FROM houseprice;

-- 15. Group Rows by a Range

SELECT 
    CASE 
        WHEN price >= 300000 THEN 'High'
        WHEN price >= 150000 THEN 'Medium'
        WHEN price < 90000 THEN 'Low'
    END price_category,
    COUNT(*)
FROM houseprice
GROUP BY 
    CASE 
        WHEN price >= 300000 THEN 'High'
        WHEN price >= 150000 THEN 'Medium'
        WHEN price < 90000 THEN 'Low'
    END;