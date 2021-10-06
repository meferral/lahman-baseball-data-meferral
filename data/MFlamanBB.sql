

/*  1. What range of years for baseball games played does the provided database cover?*/
-- Better Answer
SELECT MAX(yearid), MIN(yearid) FROM teams

 /*2. Find the name and height of the shortest player in the database.
 How many games did he play in? What is the name of the
 team for which he played?*/
--- BETTER WAY
SELECT
namegiven,
height,
debut,
finalgame,
teamid
FROM people AS p
INNER JOIN appearances AS a
ON p.playerid = a.playerid
ORDER BY height
LIMIT 1
/*3.  Find all players in the database who played at Vanderbilt University.
Create a list showing each player’s first and last names as well as the
total salary they earned in the major leagues. Sort this list in
descending order by the total salary earned. Which Vanderbilt player earned
 the most money in the majors?   */
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

SELECT
c.schoolid,
p.namegiven,
SUM(s.salary) over (PARTITION BY p.namegiven) AS majorsalary
FROM collegeplaying as c
LEFT JOIN salaries as s
ON c.playerid = s.playerid
JOIN people as p
ON p.playerid = c.playerid
WHERE c.schoolid = 'vandy'
AND s.salary IS NOT NULL
GROUP BY p.namegiven, c.schoolid,s.salary
ORDER BY majorsalary DESC;

---MUCH BETTER WAY
SELECT CONCAT (p.namefirst,' ', p.namelast) AS play_name,
		SUM(s.salary::numeric::money) AS total_earned
FROM people AS p
JOIN salaries AS s
ON p.playerid = s.playerid
WHERE p.playerid IN (SELECT cp.playerid
					FROM collegeplaying AS CP
					WHERE cp.schoolid = 'vandy')
GROUP BY play_name
ORDER BY total_earned DESC

/* 4.Using the fielding table, group players into three groups based on
their position: label players with position OF as "Outfield",
those with position "SS", "1B", "2B", and "3B" as "Infield",
and those with position "P" or "C" as "Battery". Determine the number
 of putouts made by each of these three groups in 2016. */


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

/*5. Find the average number of strikeouts per game by decade since 1920.
Round the numbers you report to 2 decimal places. Do the same for home
runs per game. Do you see any trends? */

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

/* 6. Find the player who had the most success stealing bases in 2016,
where success is measured as the percentage of stolen base attempts which
are successful. (A stolen base attempt results either in a stolen base or
being caught stealing.) Consider only players who attempted at
 least 20 stolen bases. */

WITH stolen_success AS
(SELECT
b.playerid,
CONCAT (p.namefirst,' ', p.namelast) AS play_name,
b.sb::NUMERIC,
b.cs,
b.cs + b.sb::NUMERIC AS attempts
FROM batting AS b
JOIN people AS p
ON b.playerid = p.playerid
WHERE yearid = 2016 AND sb > 20)
	SELECT
	playerid,
	play_name,
	sb,
	cs,
	ROUND(sb/attempts*100,2) AS per_successful
	FROM stolen_success
	ORDER BY per_successful DESC;

/*7.From 1970 – 2016, what is the largest number of wins for a team that
did not win the world series? What is the smallest number of wins for a team
that did win the world series? Doing this will probably result in an unusually
small number of wins for a world series champion – determine why this
is the case. Then redo your query, excluding the problem year.
How often from 1970 – 2016 was it the case that a team with the most
wins also won the world series? What percentage of the time?  */

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

WITH wswinners AS
(SELECT
	yearid,
	name,
	wswin,
	MAX(w) as mostwins
	FROM teams
	WHERE yearid BETWEEN 1970 AND 2016
	GROUP BY yearid, name, wswin
	ORDER BY mostwins DESC)
	SELECT
	COUNT()

SELECT
	yearid,
	name,
	wswin,
	MAX(w) as mostwins
	FROM teams
	WHERE yearid BETWEEN 1970 AND 2016
	GROUP BY yearid, name, wswin

/*  8. Using the attendance figures from the homegames table, find the
teams and parks which had the top 5 average attendance per game in 2016
(where average attendance is defined as total attendance divided by
number of games). Only consider parks where there were at least 10 games
played. Report the park name, team name, and average attendance.
Repeat for the lowest 5 average attendance*/

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


--- EXTRA
SELECT
s.schoolname,
COUNT (DISTINCT hof.playerid)
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
		l,
		l>w AS losers,
		totalsalary,
		t.teamid,
		t.yearid
		FROM teams AS t
		FULL JOIN salaries AS s
		ON t.teamid = s.teamid
		WHERE TOTALSALARY IS NOT NULL AND w IS NOT NULL
		ORDER BY totalsalary DESC
