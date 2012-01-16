-- prices.sql
--
-- Database schema from petrol price database
--
-- Author: Sean Carmody
CREATE TABLE city_state(town text, state);
CREATE TABLE mm (date text, town text, fuel text, price numeric);
CREATE TABLE mmc
	(date text,
	state text, 
	town text, 
	fuel text, 
	price numeric);
CREATE TABLE prices
	(date text,
	state text, 
	region text, 
	fuel text, 
	average numeric, 
	low numeric, 
	high numeric);
CREATE VIEW mm_all AS 
	SELECT date, state, mm.town, fuel, price
	FROM mm LEFT JOIN city_state c ON c.town=mm.town 
	UNION SELECT * FROM mmc 
	ORDER BY date;
CREATE INDEX mmc_date_town_fuel ON mmc (date, town, fuel); 
