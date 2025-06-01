/* Which restaurants that have both burritos and tacos on the menu have the most locations?*/


/* From the queston, I was unsure if I was to count the number of locations for each restaurant that had both tacos and burritos, 
 or count all locations of a restaurant if any had both items. The query below counts the former, since it seems more 
 useful than just knowing if a restaurant somewhere had both items on the menu.*/
 -- Grab and count names from the Locations table
select
  l.name,
  count(l.name) AS Occurrences
from
  locations l -- I match restaurant ids with menu_options_prices ids, since that is the column linking the two tables
  join (
    select
      distinct id
    from
      menu_options_prices
    where
      menus_name LIKE '%burrito%'
  ) m on l.id = m.id
  join (
    select
      distinct id
    from
      menu_options_prices
    where
      menus_name LIKE '%taco%'
  ) n on l.id = n.id -- Remove any restaurants that don't match on both burrito and taco keywords
where
  m.id IS NOT NULL
  AND n.id IS NOT NULL -- Show the count of each restaurant
GROUP BY
  l.name -- Sort restaurants with both items from most to least locations with both items
ORDER BY
  Occurrences DESC
