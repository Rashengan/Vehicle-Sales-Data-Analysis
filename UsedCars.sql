SELECT * FROM UsedCars..vehicles

--Best selling car brand in USA
SELECT manufacturer, COUNT(*) AS total
FROM UsedCars..vehicles
WHERE manufacturer IS NOT NULL AND manufacturer <> ''
GROUP BY manufacturer
ORDER BY total DESC;

--Most Expensive selling car in USA
SELECT manufacturer,model,transmission,drive,price
FROM UsedCars..vehicles
WHERE price = (
    SELECT MAX(price)
    FROM UsedCars..vehicles
    WHERE price IS NOT NULL
);

--Best selling car model in USA
SELECT model, COUNT(*) AS model_count
FROM UsedCars..vehicles
WHERE model IS NOT NULL AND model <> ''
GROUP BY model
ORDER BY model_count DESC;

--All manufacturers most expensive model
SELECT manufacturer, model, price
FROM UsedCars..vehicles v1
WHERE price = (
    SELECT MAX(price)
    FROM UsedCars..vehicles v2
    WHERE v1.manufacturer = v2.manufacturer 
    AND model IS NOT NULL AND model <> ''
    AND manufacturer IS NOT NULL AND manufacturer <> ''
)
AND manufacturer IS NOT NULL;

-- Average price per brand
SELECT manufacturer, AVG(price) AS avg_price
FROM UsedCars..vehicles
WHERE manufacturer IS NOT NULL AND price IS NOT NULL
GROUP BY manufacturer
ORDER BY avg_price DESC;

-- Top 10 most expensive car models in USA
SELECT TOP 10 model, manufacturer, price, year
FROM UsedCars..vehicles
WHERE model IS NOT NULL AND model <> ''
ORDER BY price DESC;

-- Average kilometer information for manufacturers
SELECT manufacturer, AVG(odometer) AS avg_km
FROM UsedCars..vehicles
WHERE manufacturer IS NOT NULL AND odometer IS NOT NULL
GROUP BY manufacturer
ORDER BY avg_km ASC;


-- Amount of car according to fuel types in USA
SELECT fuel, COUNT(*) AS count
FROM UsedCars..vehicles
WHERE fuel IS NOT NULL AND fuel <> ''
GROUP BY fuel
ORDER BY count DESC;

-- Average price of cars according to transmission type
SELECT transmission, AVG(price) AS avg_price
FROM UsedCars..vehicles
WHERE transmission IS NOT NULL AND transmission <> '' AND price IS NOT NULL 
GROUP BY transmission;


-- Specific year and brand's average price
SELECT AVG(price) AS avg_price
FROM UsedCars..vehicles
WHERE year = 2015 AND manufacturer = 'toyota';

-- Which city has the most cars?
SELECT region, COUNT(*) AS total
FROM UsedCars..vehicles
GROUP BY region
ORDER BY total DESC;

SELECT manufacturer, year, AVG(price) AS avg_price
FROM UsedCars..vehicles
WHERE manufacturer IS NOT NULL AND manufacturer <> '' AND price IS NOT NULL
GROUP BY manufacturer, year
ORDER BY manufacturer, year;

--Best selling body type in USA
SELECT type, COUNT(*) AS total
FROM UsedCars..vehicles
WHERE type IS NOT NULL AND type <> ''
GROUP BY type
ORDER BY total DESC;

--Show average prices for each year and the difference from last year.
WITH YearlyAvg AS (
    SELECT year, ROUND(AVG(price), 0) AS avg_price
    FROM UsedCars..vehicles
    WHERE year IS NOT NULL AND price IS NOT NULL
    GROUP BY year
),
YearlyDiff AS (
    SELECT y1.year,
           y1.avg_price,
           y1.avg_price - LAG(y1.avg_price) OVER (ORDER BY y1.year) AS price_diff
    FROM YearlyAvg y1
)
SELECT * FROM YearlyDiff
ORDER BY year;