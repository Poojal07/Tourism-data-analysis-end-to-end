create DATABASE Tourism_Data;
USE Tourism_Data;

select * from tourism;
describe tourism;

DELETE FROM tourism
WHERE state IN ('Total', 'Grand Total'); -- remove unwanted rows

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE tourism ADD growth_rate FLOAT;


-- TOP STATES (2019)
SELECT 
    state,
    (domestic_2019 + foreign_2019) AS total_2019
FROM tourism
ORDER BY total_2019 DESC
LIMIT 10;

-- COVID IMPACT
SELECT 
    state,
    ((domestic_2020 + foreign_2020) - (domestic_2019 + foreign_2019)) 
    / (domestic_2019 + foreign_2019) * 100 AS decline_percent
FROM tourism
ORDER BY decline_percent ASC;

-- FOREIGN DEPENDENCY
SELECT 
    state,
    foreign_2019 * 100.0 / (domestic_2019 + foreign_2019) AS foreign_dependency
FROM tourism
ORDER BY foreign_dependency DESC;

-- CONTRIBUTION ANALYSIS
SELECT 
    state,
    (domestic_2019 + foreign_2019) * 100.0 /
    SUM(domestic_2019 + foreign_2019) OVER () AS contribution_percent
FROM tourism;

-- DOMESTIC DOMINANCE
SELECT 
    state,
    domestic_2019 * 100.0 / (domestic_2019 + foreign_2019) AS domestic_ratio
FROM tourism;

-- IMPACT CATEGORY
SELECT 
    state,
    `Growth rate - DTV  2020/19`,
    CASE 
        WHEN `Growth rate - DTV  2020/19` < -80 THEN 'Highly Affected'
        WHEN `Growth rate - DTV  2020/19` < -60 THEN 'Moderately Affected'
        ELSE 'Less Affected'
    END AS impact_category
FROM tourism;

-- ZONE CLASSIFICATION
SELECT 
    CASE 
        WHEN (domestic_2019 + foreign_2019) > 50000000 THEN 'High'
        WHEN (domestic_2019 + foreign_2019) > 10000000 THEN 'Medium'
        ELSE 'Low'
    END AS zone,
    COUNT(*) AS states
FROM tourism
GROUP BY zone;

-- TOP 5 SHARE how much % of total tourism is contributed by top 5 states
SELECT 
    SUM(total_2019) * 100.0 /
    (SELECT SUM(domestic_2019 + foreign_2019) FROM tourism)
FROM (
    SELECT (domestic_2019 + foreign_2019) AS total_2019
    FROM tourism
    ORDER BY total_2019 DESC
    LIMIT 5
) t;