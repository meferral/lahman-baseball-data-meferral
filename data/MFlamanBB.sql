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
GROUP BY p.namegiven, c.schoolid,s.salary
ORDER BY s.salary DESC;

/*--SELECT 
SUM(s.salary) AS sumsalary,
p.namegiven
FROM collegeplaying as c
LEFT JOIN salaries as s
ON c.playerid = s.playerid
JOIN people as p
ON p.playerid = c.playerid
WHERE c.schoolid = 'vandy'
ORDER BY sumsalary DESC
GROUP BY p.namegiven;*/

--- 4

SELECT *
FROM fielding;



SELECT
SUM(PO),
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
		WHERE yearid = 2016
		GROUP BY pos;
		
SELECT
SUM(PO),
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
		WHERE yearid = 2016
		GROUP BY pos;		
		
----5		

select 
yearid ,
hr,
so,
soa,
g
from teams
where yearid BETWEEN 1920 AND 1929;

select *
from teams

WITH sohr_game as
(SELECT 
 	FLOOR(yearid/10) * 10 AS decade,	
 	ROUND(AVG(soa+so),2) AS avg_strikeouts,
	ROUND(AVG(hr),2) AS avg_homeruns
	FROM teams
	GROUP BY decade)
		SELECT *
		FROM sohr_game
		WHERE decade >= 1920
		ORDER BY decade ASC;
		
---6		
SELECT
b.playerid,
p.namegiven,
b.sb,
b.cs,
ROUND((b.cs/b.sb)*100,2) AS success_rate
FROM batting AS b
JOIN people AS p
ON b.playerid = p.playerid
WHERE yearid = 2016 AND sb > 20

select * from batting

---7


