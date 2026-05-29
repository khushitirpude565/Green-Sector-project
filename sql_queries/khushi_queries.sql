/*Topic 1 :
SQL Functions:
1.	Calculate the total energy_produced from energy_production for each source.
Hint: Use SUM().
Expected Output: Total energy produced per source.
*/
select p.production_id,sum(p.energy_produced) as total_energy_produced from energy_production.productions p 
group by p.production_id
order by total_energy_produced desc

/*2.	Find the average capacity of all energy sources in energy_capacity.
Hint: Use AVG().
Expected Output: Average capacity.*/
select ec.energy_source_id,ec.year,avg (ec.capacity) as average_capacity
from energy_sources.energy_capacity ec
group by ec.energy_source_id,ec.year
order by average_capacity desc 

/*3.	Count the number of energy sources with capacity greater than 10000 MW.
Hint: Use COUNT() with WHERE.
Expected Output: Count of sources over 10000 MW.
*/
select count(*) as sources_over_10000_mw
from energy_sources.energy_capacity ec
where ec.capacity > 10000;

/*4.	Calculate the total amount_consumed per region and source in monthly_consumption.
Hint: Use GROUP BY.
Expected Output: Total consumption by region and source.
*/
select m.region_id,sum(m.amount_consumed) as total_amount_consumed,m.month
from energy_consumption.monthly_consumption m
group by m.region_id,m.month
order by total_amount_consumed desc

/*5.	Calculate the growth percentage in energy consumption between 2019 and 2020 for each region.
Hint: Use ROUND() and simple percentage formula.
Expected Output: Growth percentage for each region.
*/
select yc_2019.region_id,r.region_name,
round(((yc_2020.total_consumed - yc_2019.total_consumed) * 100.0 / yc_2019.total_consumed), 2) as growth_percentage
from energy_consumption.yearly_consumption as yc_2019
join energy_consumption.yearly_consumption as yc_2020
on yc_2019.region_id = yc_2020.region_id
join regions.region_data as r
on yc_2019.region_id = r.region_id
where yc_2019.year = 2019 and yc_2020.year = 2020;


/*Topic 2:
 Aggregate Functions:
1.	Retrieve the maximum capacity in the energy_sources.energy_capacity table.
Hint: Use MAX().
Expected Output: Maximum energy source capacity.
*/
select max(ec.capacity) as maximum_capacity
from energy_sources.energy_capacity ec ;

/*2.Count how many energy sources have a capacity greater than 15,000 MW in energy_sources.energy_capacity.
Hint: Use COUNT() with WHERE.
Expected Output: Count of energy sources exceeding 15,000 MW.*/
select count(*) as sources_over_15000_mw
from energy_sources.energy_capacity ec
where ec.capacity > 15000;

/*3.Find the average energy consumption per month in energy_consumption.monthly_consumption for 2020.
Hint: Use AVG() with WHERE.
Expected Output: Average consumption for 2020.*/
select avg(y.total_consumed) as average_monthly_consumption
from  energy_consumption.yearly_consumption y
where y.year = 2020;

/*4.Find the top 3 energy sources by capacity for each year in energy_sources.energy_capacity.
Hint: Use ORDER BY with LIMIT.
Expected Output: Top 3 energy sources per year.*/
with rankedsources as (select ec.year,ec.energy_source_id,ec.capacity,rank() over (partition by year order by capacity desc) 
as rank from energy_sources.energy_capacity ec)
select year,energy_source_id,capacity
from rankedsources
where rank <= 3
order by year, rank;

/*5.Calculate the total energy produced per month in energy_production.monthly_production for each energy source in 2020.
Hint: Use SUM() with GROUP BY.
Expected Output: Monthly production by energy source in 2020.*/
select mp.month as month,mp.energy_source_id,sum(mp.energy_produced) as total_monthly_production
from energy_production.monthly_production mp 
group by mp.month,mp.energy_source_id
order by mp.month, mp.energy_source_id;

/*Topic 3:
inner join :
1.	Join energy_consumption.monthly_consumption and regions.region_data on region_id to list the region names and energy 
consumed per month.
o	Hint: Use INNER JOIN.
o	Expected Output: Region names and their corresponding monthly energy consumption.*/
select r.region_name,m.amount_consumed as monthly_consumption
from energy_consumption.monthly_consumption m
inner join regions.region_data r
on m.region_id = r.region_id;

/*2.Join regions.region_area and regions.region_data on region_id to retrieve region names and area sizes for the year 2020.
o	Hint: Use INNER JOIN with WHERE.
o	Expected Output: Region names and area sizes for 2020.*/
select rd.region_name, ra.area_size
from regions.region_area as ra
inner join regions.region_data as rd
on ra.region_id = rd.region_id
where ra.year = 2020;

/*3.Join energy_consumption.yearly_consumption and energy_sources.energy_source on energy_source_id to list energy sources and their total energy consumption.
o	Hint: Use INNER JOIN.
o	Expected Output: Energy source names and total energy consumption.*/
select es.source_name, sum(yc.total_consumed) as total_energy_consumption
from energy_consumption.yearly_consumption as yc
inner join energy_sources.energy_source as es
on yc.energy_source_id = es.energy_source_id
group by es.source_name;

/*4.	Join energy_consumption.yearly_consumption and energy_sources.energy_source on energy_source_id to retrieve the energy source with the highest energy consumption for 2020.
o	Hint: Use INNER JOIN with ORDER BY.
o	Expected Output: Energy source with the highest consumption.*/
select es.source_name, yc.total_consumed
from energy_consumption.yearly_consumption as yc
inner join energy_sources.energy_source as es
on yc.energy_source_id = es.energy_source_id
where yc.year = 2020
order by yc.total_consumed desc
limit 1;

/*5.	Join regions.region_data, energy_sources.energy_capacity, and energy_consumption.yearly_consumption on region_id and energy_source_id to find regions and their total energy consumption per energy source for 2020.
o	Hint: Use multiple INNER JOINs with GROUP BY.
o	Expected Output: Total energy consumption per energy source for each region.*/
select rd.region_name, es.source_name,
  sum(yc.total_consumed) as total_energy_consumption
from regions.region_data as rd
inner join energy_consumption.yearly_consumption as yc
on rd.region_id = yc.region_id
inner join energy_sources.energy_source as es
on yc.energy_source_id = es.energy_source_id
where yc.year = 2020
group by rd.region_name, es.source_name
order by rd.region_name, es.source_name;

/*topic 4:
self joins:
1.	find regions in regions.region_data where the population is greater than that of the region with region_id = 5.
o	hint: use self join with a comparison.
o	expected output: regions with a larger population than region 5.*/
select r1.region_name as region_with_higher_population, r1.population
from regions.region_data as r1
inner join regions.region_data as r2 on 
r1.country = r2.country
where   r2.region_id = 5 and r1.population > r2.population;

/*2.	find pairs of regions in regions.region_data where the sum of their populations is greater than 20 million.
o	hint: use self join and compare the sum of populations.
o	expected output: pairs of regions with a combined population greater than 20 million.*/
select r1.region_name as region1, r2.region_name as region2,
    (r1.population + r2.population) as combined_population
from regions.region_data as r1
inner join regions.region_data as r2
on r1.region_id < r2.region_id
where  (r1.population + r2.population) > 20000000;

/*3.	join regions.region_data with itself to list regions with the same area_size but different population.
o	hint: use self join with where to compare area_size and population.
o	expected output: regions with the same area but different populations.*/
select rd.region_name as region1, rd.region_name as region2, r1.area_size,
    rd.population as population1, rd.population as population2
from regions.region_area as r1
inner join regions.region_area as r2
on r1.area_size = r2.area_size
inner join regions.region_data rd on r1.region_id = rd.region_id
where rd.population <> rd.population

/*4.	join regions.region_data with itself to find regions that have a population between the minimum and maximum population values in the entire dataset.
o	hint: use self join with where conditions comparing population.
o	expected output: regions with populations between the smallest and largest values.*/
select r1.region_name, r1.population
from regions.region_data as r1
inner join  (select min(population) as min_population, max(population) as max_population
from regions.region_data) as stats
on r1.population between stats.min_population and stats.max_population;

/*5.	find the region in regions.region_data where the population is greater than the average population of regions from the same country and whose area is greater than 100,000 km².
o	hint: use self join with where and group by for the country.
o	expected output: regions that meet both conditions*/
select rd.region_name,rd.population, ra.area_size
from regions.region_data as rd
inner join regions.region_area ra on rd.region_id = ra.region_id
inner join  (select country, avg(population) as avg_population
     from regions.region_data
     group by country) as avg_stats
on rd.country = avg_stats.country
where rd.population > avg_stats.avg_population
    and ra.area_size > 100000;

/*topic 5:
left joins:
1.	retrieve all regions from regions.region_data and their energy consumption for 2020 from energy_consumption.yearly_consumption, including regions with no consumption data.
o	hint: use left join.
o	expected output: region names and their 2020 energy consumption (null if no data available).*/
select rd.region_name, yc.total_consumed as energy_consumption_2020
from regions.region_data as rd
left join energy_consumption.yearly_consumption as yc
on rd.region_id = yc.region_id
and yc.year = 2020;

/*2.	retrieve all regions from regions.region_data and their population and energy consumption for 2020 from regions.region_data and energy_consumption.yearly_consumption, including regions with no consumption data.
o	hint: use left join.
o	expected output: region names, populations, and 2020 energy consumption (null if no consumption data).*/
select rd.region_name, rd.population, yc.total_consumed as energy_consumption_2020
from regions.region_data as rd
left join energy_consumption.yearly_consumption as yc
on rd.region_id = yc.region_id
and yc.year = 2020;

/*3.	get all energy sources from energy_sources.energy_source and their production data from energy_production.productions, including sources with no production data.
o	hint: use left join.
o	expected output: energy source names and their production data (null if no production data).*/
select es.source_name, ep.energy_produced
from energy_sources.energy_source as es
left join energy_production.productions as ep
on es.energy_source_id = ep.energy_source_id;

/*4.	list all regions from regions.region_data and their energy consumption and production for 2020 from energy_consumption.yearly_consumption and energy_production.yearly_production, including regions with missing data in either table, and order them by energy consumption.
o	hint: use left join and order by.
o	expected output: region names with energy consumption and production data, ordered by consumption.
select rd.region_name, yc.total_consumed as energy_consumption_2020,
yp.total_produced as energy_production_2020
from regions.region_data as rd
left join energy_consumption.yearly_consumption as yc
on rd.region_id = yc.region_id
and yc.year = 2020
left join energy_production.yearly_production as yp
on rd.region_id = yp.region_id
and yp.year = 2020
order by yc.total_consumed asc;*/

/*5.	retrieve all regions and their energy sources from regions.region_data and energy_sources.energy_source, including regions with no energy consumption data.
o	hint: use left join.
o	expected output: region names and energy sources (null if no consumption data).*/
select rd.region_name, es.source_name
from regions.region_data as rd
left join energy_sources.energy_source as es
on rd.region_id = es.energy_source_id;

/*topic 6:
subqueries:
1.	find the regions from regions.region_data that have a population greater than the region with region_id = 5.
o	hint: use a subquery in the where clause.
o	expected output: regions with populations greater than that of region 5.*/
select rd.region_name, rd.population
from regions.region_data rd 
where rd.population > (select rd.population from regions.region_data rd where rd.region_id = 5);

/*2.	retrieve the regions from regions.region_data where the population is greater than the population of the region with the largest area.
o	hint: use a subquery to find the region with the largest area and compare populations.
o	expected output: regions with populations greater than the region with the largest area.*/
select rd.region_name, rd.population
from regions.region_data rd
inner join regions.region_area ra on rd.region_id = ra.region_id
where rd.population > (select population
from regions.region_data rd_sub
where rd_sub.region_id = (select region_id
from regions.region_area
where area_size = (select max(area_size) 
from regions.region_area)
limit 1));

/*3.	find the total energy consumption of the region that has the highest population in regions.region_data.
o	hint: use a subquery to find the region with the highest population and join with energy_consumption.yearly_consumption.
o	expected output: total energy consumption of the region with the highest population.*/
select region_name, sum(yc.total_consumed) as total_energy_consumption
from  regions.region_data as rd
join energy_consumption.yearly_consumption as yc
on rd.region_id = yc.region_id
where rd.region_id = (select region_id from regions.region_data where population = (select max(population) from regions.region_data    ) limit 1 )
group by rd.region_name;

/*4.	find all energy sources from energy_sources.energy_source where their capacity is greater than the combined capacity of two renewable energy sources in energy_sources.energy_capacity.
o	hint: use a subquery to calculate the combined capacity of two sources.
o	expected output: energy sources with a capacity greater than the sum of two renewable energy sources.*/
select   es.source_name,    ec.capacity
from  energy_sources.energy_source as es
join energy_sources.energy_capacity as ec
on es.energy_source_id = ec.energy_source_id
where ec.capacity > (select sum(capacity) from energy_sources.energy_capacity
where energy_source_id in (select energy_source_id
from energy_sources.energy_source
where source_type = 'renewable'
limit 2));

/*5.	find the regions from regions.region_data where the population is greater than the average population of regions within the same area size range and the area size is larger than the average area size of regions within the same population range.
o	hint: use subqueries to compare population and area size ranges.
o	expected output: regions with both population and area size above average in their respective groups.*/
select rd.region_name,  rd.population, ra.area_size
from regions.region_data as rd
inner join regions.region_area as ra 
on rd.region_id = ra.region_id
where rd.population > (select avg(rd1.population)
from regions.region_data rd1
where ra.area_size between 
(select min(ra1.area_size) 
from regions.region_area ra1 
where ra1.region_id = rd1.region_id)
and (select max(ra2.area_size) 
from regions.region_area ra2 
where ra2.region_id = rd1.region_id))
and ra.area_size > (select avg(ra3.area_size)
from regions.region_area ra3
where rd.population between 
(select min(rd2.population) 
from regions.region_data rd2 
where rd2.region_id = ra3.region_id)
and (select max(rd3.population) 
from regions.region_data rd3 
where rd3.region_id = ra3.region_id));

/*topic 7:
over clause:
1.	find the average population across all regions in regions.region_data, displayed next to each region's population.
o	hint: use over() with partition by for calculating the average.
o	expected output: region population alongside the overall average population.*/
select rd.region_name,rd.population, avg(rd.population) over () as overall_average_population
from   regions.region_data rd;

/*2.	calculate the difference between each region's energy consumption and the average energy consumption in energy_consumption.yearly_consumption.
o	hint: use avg() with over() and subtract the result from each region's consumption.
o	expected output: difference between each region's consumption and the average.*/
select yc.region_id, yc.year, total_consumed, avg(total_consumed) over () as average_consumption,
 yc.total_consumed - avg(total_consumed) over () as consumption_difference
from energy_consumption.yearly_consumption yc;

/*3.	find the moving average of capacity for each energy source in energy_sources.energy_capacity over the last 5 years.
o	hint: use avg() with over() and rows between.
o	expected output: moving average of energy source capacities for the last 5 years.*/
select ec.energy_source_id, ec.year, ec.capacity,
avg(ec.capacity) over (partition by ec.energy_source_id order by ec.year 
rows between 4 preceding and current row) as moving_average_capacity
from energy_sources.energy_capacity ec;

/*4.	find the top 3 energy sources in energy_sources.energy_capacity based on their cumulative capacity, ordered by total capacity.
o	hint: use sum() with over() and order by.
o	expected output: top 3 energy sources based on cumulative capacity.*/
select ec.energy_source_id,  sum(ec.capacity) over (order by ec.capacity desc) as cumulative_capacity
from energy_sources.energy_capacity ec
order by  cumulative_capacity desc
limit 3;

/*5.	calculate the moving average of total_produced in energy_production.yearly_production over a window of 5 years, partitioned by energy_source_id.
o	hint: use avg() with over() and rows between and partition by.
o	expected output: 5-year moving average of energy produced per energy source.*/
select yp.energy_source_id, yp.year, yp.total_produced, avg(yp.total_produced) over (
partition by yp.energy_source_id order by year 
rows between 4 preceding and current row) as moving_average_production
from energy_production.yearly_production yp;

/*topic 8:
windows function :
1.assign a row number to each region in regions.region_data, ordered by region_name.
o	hint: use row_number() with order by region_name.
o	expected output: row number assigned to each region based on region_name.*/
select rd.region_name,
row_number() over (order by rd.region_name) as row_number
from regions.region_data rd;

/*2.rank the energy sources in energy_sources.energy_capacity based on capacity in descending order, but ensure no gaps in ranking using dense_rank().
o	hint: use dense_rank() with order by capacity desc.
o	expected output: energy sources ranked without gaps for tied capacities.*/
select ec.energy_source_id, ec.capacity, 
dense_rank() over (order by capacity desc) as rank
from energy_sources.energy_capacity ec;

/*3.use rank() to find the top 5 regions with the highest area size from regions.region_area, ordered by area size.
o	hint: use rank() with order by area_size desc and filter for ranks 1 to 5.
o	expected output: top 5 regions ranked by area size.*/
select region_name, area_size, 
rank
from (select rd.region_name, ra.area_size, 
rank() over (order by ra.area_size desc) as rank
from regions.region_area ra
join regions.region_data rd 
on ra.region_id = rd.region_id
) rankedregions
where 
rank <= 5;

/*4.use rank() to rank energy sources in energy_sources.energy_capacity based on capacity, and only show ranks where capacity is greater than 10,000 mw.
o	hint: use rank() with where clause for filtering capacity > 10000.
o	expected output: energy sources ranked by capacity, showing only those with more than 10,000 mw.*/
select ec.energy_source_id, ec.capacity, 
rank() over (order by capacity desc) as rank
from energy_sources.energy_capacity ec
where ec.capacity > 10000;

/*5.Rank regions in regions.region_data based on area size and display only regions with ranks between 5 and 10 using RANK().
o	Hint: Use RANK() and filter by rank range.
o	Expected Output: Regions with ranks 5 to 10 based on area size.*/
WITH ranked_regions AS (SELECT rd.region_id,rd.region_name,rd.country,ra.area_size,
RANK() OVER (ORDER BY ra.area_size DESC) AS rank_num
FROM regions.region_data rd
JOIN regions.region_area ra ON rd.region_id = ra.region_id)
SELECT region_id,region_name,country,area_size,rank_num
FROM ranked_regions
WHERE rank_num BETWEEN 5 AND 10;
--review using subquery

/*Topic 9:
Aggregate Functions with PARTITION BY:
1.	Retrieve the average capacity for each energy source type in energy_sources.energy_capacity, partitioned by source_type.
o	Hint: Use AVG() with PARTITION BY source_type.
o	Expected Output: Average capacity for each energy source type.*/
SELECT es.source_type,
AVG(ec.capacity) OVER (PARTITION BY es.source_type) AS avg_capacity
FROM  energy_sources.energy_source es
JOIN energy_sources.energy_capacity ec ON es.energy_source_id = ec.energy_source_id;

/*2.	Calculate the total energy consumption for each energy source type in energy_consumption.yearly_consumption, partitioned by source_type.
o	Hint: Use SUM() with PARTITION BY source_type.
o	Expected Output: Total energy consumption per source type.*/
SELECT energy_source_id,SUM(total_consumed) OVER (PARTITION BY energy_source_id) AS total_consumption
FROM energy_consumption.yearly_consumption;

/*3.	Find the average population for each country in regions.region_data in 2020, partitioned by country.
o	Hint: Use AVG() with PARTITION BY country and WHERE clause for the year.
o	Expected Output: Average population in 2020 for each country.*/
SELECT country,
AVG(population) OVER (PARTITION BY country) AS avg_population
FROM regions.region_data
WHERE year = 2020;

/*4.	Find the regions in regions.region_data where the population is greater than the combined population of the 3 regions with the smallest area sizes, partitioned by country.
o	Hint: Use SUM() with PARTITION BY country and a subquery to find the sum of the 3 smallest area sizes.
o	Expected Output: Regions with a population greater than the combined population of the 3 smallest area regions.*/
WITH smallest_areas AS (
    SELECT subquery.country, SUM(subquery.population) AS smallest_total_population
    FROM (
        SELECT rd.country, rd.population
        FROM regions.region_data rd
        JOIN regions.region_area ra ON rd.region_id = ra.region_id
        ORDER BY ra.area_size ASC
        LIMIT 3
    ) subquery
    GROUP BY subquery.country
)
SELECT r.region_id, r.region_name, r.country, r.population
FROM regions.region_data r
JOIN smallest_areas sa
ON r.country = sa.country
WHERE r.population > sa.smallest_total_population;

/*5.	Rank the energy sources in energy_sources.energy_capacity based on their capacity for each source type, and partition the results by source_type.
o	Hint: Use RANK() with PARTITION BY source_type and ORDER BY capacity DESC.
o	Expected Output: Rank of energy sources for each source type.*/
SELECT 
    energy_source_id, 
    year, 
    capacity, 
    RANK() OVER (PARTITION BY energy_source_id ORDER BY capacity DESC) AS rank
FROM energy_sources.energy_capacity;

/*Topic 10:
Views:
1.	Create a view to find all regions with a population greater than 10 million in regions.region_data.
o	Hint: Use CREATE VIEW with a WHERE clause filtering by population.
o	Expected Output: A view of regions with populations greater than 10 million.*/
CREATE VIEW regions.regions_with_high_population AS
SELECT region_id, region_name, country, population
FROM regions.region_data
WHERE population > 10000000;

select * from regions.regions_with_high_population

/*2.	Create a view to display the total emissions for each energy source, partitioned by source_type, in energy_sources.energy_emissions.
o	Hint: Use CREATE VIEW with SUM() and GROUP BY with source_type.
o	Expected Output: A view showing total emissions for each energy source type.*/
CREATE VIEW energy_sources.total_emissions_by_source_type AS
SELECT 
    energy_source_id, 
     co2_emissions,
    SUM(co2_emissions) AS total_emissions
FROM energy_sources.energy_emissions
GROUP BY energy_source_id, co2_emissions;
select * from energy_sources.total_emissions_by_source_type
/*3.	Create a view to list regions with their populations and area sizes from regions.region_data and regions.region_area.
o	Hint: Use CREATE VIEW with JOIN between region_data and region_area.
o	Expected Output: A view showing region names, populations, and area sizes.*/
CREATE VIEW regions.regions_with_population_and_area AS
SELECT 
    rd.region_id, 
    rd.region_name, 
    rd.population, 
    ra.area_size
FROM regions.region_data rd
JOIN regions.region_area ra ON rd.region_id = ra.region_id;
select * from regions.regions_with_population_and_area
/*4.	Create a view to show the cumulative energy consumption for each region over the last 3 years in energy_consumption.yearly_consumption, partitioned by region_id.
o	Hint: Use CREATE VIEW with SUM() and PARTITION BY region_id with ORDER BY year.
o	Expected Output: A view with cumulative energy consumption for each region over the last 3 years.*/
CREATE VIEW energy_consumption.cumulative_energy_consumption AS
SELECT 
    region_id, 
    year, 
    SUM(total_consumed) OVER (PARTITION BY region_id ORDER BY year) AS cumulative_consumption
FROM energy_consumption.yearly_consumption
WHERE year >= EXTRACT(YEAR FROM CURRENT_DATE) - 3;
select * from energy_consumption.cumulative_energy_consumption
/*5.	Create a view to display the regions with the highest energy production per area in energy_production.yearly_production and regions.region_area.
o	Hint: Use CREATE VIEW with a JOIN between yearly_production and region_area, ordered by energy production per area size.
o	Expected Output: A view showing regions with the highest energy production per area.
CREATE VIEW energy_production.highest_energy_production_per_area AS
SELECT 
    yp.region_id, 
    ra.region_name, 
    SUM(yp.energy_production) / ra.area_size AS production_per_area
FROM energy_production.yearly_production yp
JOIN regions.region_area ra ON yp.region_id = ra.region_id
GROUP BY yp.region_id, ra.region_name, ra.area_size
ORDER BY production_per_area DESC;
*/


