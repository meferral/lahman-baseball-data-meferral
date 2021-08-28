SELECT *
FROM allstarfull;

select distinct(playerid)
from managers;

select count(playerid)
from managers;

SELECT count(*)
FROM allstarfull;

select *
from salaries;


select max(salary)
from salaries;

select min(salary)
from salaries;.

select *
from collegeplaying;

SELECT MIN(yearid)
FROM salaries

---1

SELECT *
FROM people;

SELECT MAX(debut)
FROM people;

---2
SELECT
namegiven,
height
FROM people
order by height asc;

SELECT
namegiven,
height
FROM people;

SELECT *
FROM people
WHERE namegiven = 'Edward Carl';

SELECT *
FROM APPEARANCES
WHERE playerid ='gaedeed01';

SELECT *
FROM teams
WHERE teamid = 'SLA';
---3
SELECT 
c.schoolid,
s.salary,
p.namegiven
FROM collegeplaying as c
LEFT JOIN salaries as s
ON c.playerid = s.playerid
JOIN people as p
ON p.playerid = c.playerid
WHERE c.schoolid = 'vandy'
AND s.salary IS NOT NULL
ORDER BY salary DESC;

--- 4

SELECT *
FROM fielding;



SELECT
COUNT(PO),
(SELECT CASE pos
WHEN 'OF' THEN 'Outfield'
		WHEN 'SS' THEN 'Infield'
		WHEN'1B' THEN 'Infield'
		WHEN '2B' THEN 'Infield'
		WHEN'3B' THEN 'Infield'
		WHEN 'P' THEN'Battery'
		WHEN'C' THEN 'Battery'
		ELSE POS END)
		FROM fielding
		HAVING yearid = 2016
		GROUP BY GROUPING SETS ((POS,PO),(POS),(PO),());

