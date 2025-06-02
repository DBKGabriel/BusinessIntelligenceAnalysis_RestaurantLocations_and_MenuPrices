/*What is the ratio of burritos to tacos on restaurant menus from each city?  Sort by largest ratio to smallest.*/

/* We need a unique locations id in order to distinguish between different cities with the same name,  
similar to how the unique restaurant id distinguishes between different locations of the same restaurant*/
SELECT
  -- I select data from a new location column, created to avoid misclassifying repeated cities
  k.fulladdy,
  -- Then I count the number of burrito and taco menu items by id, since id is the only link between Locations and menu_options_prices
  COUNT(m.id) AS BurrOccurrences,
  COUNT(n.id) AS TacoOccurrences,
  COUNT(m.id) * 1.0 / COUNT(n.id) AS RATIO --calculates the burrito/taco ratio, avoiding divide by zero errors
FROM
  locations l -- Use location table to create k.full addy and calculate the desired ratio
  LEFT JOIN -- match locations with burrito locations
  (
    SELECT
      id
    FROM
      menu_options_prices
    WHERE
      menus_name LIKE '%burrito%'
  ) m ON l.id = m.id
  LEFT JOIN -- join match locations with taco locations 
  (
    SELECT
      id
    FROM
      menu_options_prices
    WHERE
      menus_name LIKE '%taco%'
  ) n ON l.id = n.id
  LEFT JOIN  --match restaurant ids with ids in the new, unique location id table
  (
    SELECT
      id,
      CONCAT(city, province) AS fulladdy -- creates a more unique city id by concatenating city name with province, since some different cities share the same name
    FROM
      locations
  ) k ON l.id = k.id
GROUP BY
  k.fulladdy -- group the ratios by those unique location names
HAVING
  COUNT(m.id) > 0 --Exclude any cities without any burrito items on their menus
  AND COUNT(n.id) > 0  --Exclude any cities without any tacos items on their menus
ORDER BY
  RATIO DESC;
 -- Sort from largest to smallest ratio
