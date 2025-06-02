/* Calculate the monthly revenue earned per taco for tacos made with chicken protein by spice level over time. */

SELECT
  -- I select date data formated to focus on month
  FORMAT(date, 'yyyy-MM') AS month,
  -- I also select spice_level and meat_type data for filtering and grouping
  spice_level,
  meat_type,
  -- Then I total the amount of tacos sold
  SUM(quantity) AS total_taco_quantity,
  -- and calculate the revenue per taco
  SUM(total_revenue) / SUM(quantity) AS income_per_taco
FROM -- I get the data from the table taco_truck_sales 
  taco_truck_sales -- Only looking at chicekn tacos
WHERE
  meat_type = 'chicken' -- Look at monthly revenue/taco ratio by spice_level over time
GROUP BY
  FORMAT(date, 'yyyy-MM'), -- I aggregate the per taco revenue values by month
  spice_level,
  meat_type 
ORDER BY -- And sort revenue from oldest to most recent months, then by spice_level
  month,
  spice_level;
