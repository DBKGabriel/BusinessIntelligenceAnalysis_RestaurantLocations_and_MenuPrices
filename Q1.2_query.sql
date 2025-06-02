/*Which cities have the greatest number of authentic Mexican restaurants?*/

/* Because "authentic" is not well operationalized, I used the following criteria.
 1. The restaurant has fewer than 5 locations, as authentic restaurants tend to have fewer expansions
 2. The restaurant appears in only 1 city, as a larger chain is less likely to be authentic,
 3. The cuisine/category includes the word Mexican, and
 4. The cuisine does not include specific non-authentic keywords "*/
SELECT
  filtered_data.city,
  COUNT(filtered_data.name) AS restaurant_count --Count how many restaurants are in each city that meet the following criteria
FROM
  (
    --First, I select the names of each restaurant and each city
    SELECT
      l.name,
      l.city,
      COUNT(DISTINCT l.id) AS loc_count -- Then count unique restaurants
    FROM
      Locations l --Within the table Locations
      INNER JOIN menu_options_prices m ON l.id = m.id --Use ids between the tables Locations and menu_options_prices to tally restaurants
    WHERE
      l.name IN (
        -- only match ids between tables if the name meets criteria for "authentic"
        SELECT
          name
        FROM
          Locations
        GROUP BY
          name
        HAVING
          COUNT(DISTINCT id) < 5 --fewer than 5 locations
          AND COUNT(DISTINCT city) = 1 --only occur in 1 city
      ) -- Then only match names between tables if their "cuisine" description meets criteria that seem authentic.
      AND (
        cuisines LIKE '%Mexican%'
        OR m.categories LIKE '%Mexican%'
      )
      and cuisines NOT LIKE '%Traditional American%'
      and cuisines NOT LIKE '%contemporary American%'
      and cuisines NOT LIKE '%Tex-mex%'
      and cuisines NOT LIKE '%Fast Food%'
      and cuisines NOT LIKE '%Italian%'
      and cuisines NOT LIKE '%gastro pub%'
      and cuisines NOT LIKE '%Thai%'
      and cuisines NOT LIKE '%pizza%'
      and cuisines NOT LIKE '%fusion%'
      and cuisines NOT LIKE '%French%'
      and cuisines NOT LIKE '%Belgian%'
      and cuisines NOT LIKE '%Chinese%'
      and cuisines NOT LIKE '%sushi%'
      and m.categories NOT LIKE '%fast food%'
    GROUP BY
      l.name,
      l.city
  ) AS filtered_data
GROUP BY
  filtered_data.city
ORDER BY
  restaurant_count desc;
