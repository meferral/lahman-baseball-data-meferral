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
(SELECT CASE WHEN pos = 'OF' THEN 'Outfield'
		WHEN pos = 'SS' or pos = '1B' or pos = '2B' or pos = '3B' THEN 'Infield'
		WHEN pos = 'P' or pos = 'C' THEN 'Battery'
		END AS "positions")
		FROM fielding
		WHERE yearid = 2016
		GROUP BY pos;
		
SELECT
SUM(PO),
(SELECT CASE WHEN pos IN ('OF') THEN 'Outfield'
		WHEN pos IN ('SS','1B','2B','3B') THEN 'Infield'
	 	WHEN pos IN ('P', 'C') THEN 'Battery'
	 	END AS position_group)
		FROM fielding
		WHERE yearid = 2016
		GROUP BY position_group;		

--Derek's Code
/*WITH positions AS (
	SELECT
	po,
	yearid,
	CASE WHEN pos IN ('OF') THEN 'Outfield'
		WHEN pos IN ('SS','1B','2B','3B') THEN 'Infield'
	 	WHEN pos IN ('P', 'C') THEN 'Battery'
	 	END AS position_group
FROM fielding)

SELECT
	p.position_group,
	SUM(po) AS total_putouts
FROM positions as p
WHERE yearid = '2016'
GROUP BY position_group;*/
		
		
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

WITH sohr_game AS
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
WITH wsloser AS
(SELECT 
 	YEARid,
	name,
	W,
	L,
	WSWin
FROM teams
WHERE WSwin IS NOT NULL AND yearID BETWEEN 1970 AND 2016)
	SELECT *
	FROM wsloser
	WHERE wswin = 'N'
	ORDER BY w DESC;
-- SEATTLE MARINERS IS THE TEAM

WITH wswinner AS
(SELECT 
 	yearID,
	name,
	W,
	L,
	WSWin
FROM teams
WHERE WSwin IS NOT NULL AND yearID BETWEEN 1970 AND 2016)
	SELECT *
	FROM wswinner
	WHERE wswin = 'Y'
	ORDER BY w ASC;
---LA DODGERS IS THE TEAM
--- code with no year parameter
WITH wswinner AS
(SELECT 
 	yearID,
	name,
	W,
	L,
	WSWin
FROM teams
WHERE WSwin IS NOT NULL)
	SELECT *
	FROM wswinner
	WHERE wswin = 'Y'
	ORDER BY w ASC;


/*WITH winners AS
(SELECT 
 	yearID,
	name,
	W,
	L,
	WSWin
FROM teams
WHERE w>l AND wswin = 'Y'),
underdog AS 
(SELECT 
 	yearID,
	name,
	W,
	L,
	WSWin
FROM teams
WHERE l>w AND wswin = 'Y')
	SELECT COUNT(*)
	FROM WINNERS,
	COUNT(*) FROM underdog;*/
	
SELECT
	yearid,
	name,
	wswin,
	MAX(w)
	FROM teams
	WHERE yearid BETWEEN 1970 AND 2016
	GROUP BY yearid
	
----8
SELECT 
	h.team,
	h.park,
	h.attendance/h.games as avg_attendance,
	p.park_name
FROM homegames AS h
JOIN parks AS p
ON p.park = h.park
WHERE year = 2016 AND games > 10
ORDER BY avg_attendance DESC LIMIT 5


SELECT 
	h.team,
	h.park,
	h.attendance/h.games as avg_attendance,
	p.park_name
FROM homegames AS h
JOIN parks AS p
ON p.park = h.park
WHERE h.year = 2016 AND h.games > 10
ORDER BY avg_attendance ASC LIMIT 5

select * from parks
select * from homegames
select * from TEAMS

---9
SELECT *
FROM managers

SELECT 
namegiven
FROM people
where namegiven = 'Anthony'

WITH goodmanager AS
(SELECT 
	am.playerid, 
	am.lgid,
	am.yearid,
	p.namegiven,
	m.teamid
FROM awardsmanagers AS am
JOIN people as p
ON p.playerid = am.playerid
JOIN managers AS m
ON m.playerid = p.playerid
WHERE awardid = 'TSN Manager of the Year' and am.lgid = 'AL' OR am.lgid = 'NL')
	SELECT DISTINCT(namegiven),
	teamid,
	yearid,
	lgid,
	playerid
	FROM goodmanager


--- EXTRA
SELECT 
s.schoolname,
COUNT(hof.playerid)
FROM schools AS s
JOIN collegeplaying AS cp
ON s.schoolid = cp.schoolid
JOIN hALLoFfAME AS hof
ON cp.playerid = hof.playerid
WHERE schoolstate = 'TN'
GROUP BY schoolname
ORDER BY COUNT(hof.playerid) DESC;

select *
from collegeplaying
select *
from hALLoFfAME
select *
from schools

--- EXTRA

WITH salaries AS
(SELECT 
Teamid,
sum(salary) as totalsalary,
yearid
FROM salaries WHERE yearid > '2000'
GROUP BY CUBE (yearid, teamid) ORDER BY totalsalary DESC)
	SELECT
		w,
		totalsalary,
		t.teamid,
		t.yearid
		FROM teams AS t
		FULL JOIN salaries AS s
		ON t.teamid = s.teamid
		WHERE TOTALSALARY is not null
		ORDER BY totalsalary DESC



select *
from salaries


select *
from teams

