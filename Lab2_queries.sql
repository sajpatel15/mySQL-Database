-- 1 -- 
SELECT name_first, name_last, shut_outs
FROM mlb_pitching JOIN mlb_master
	ON mlb_pitching.player_id = mlb_master.player_id
WHERE shut_outs > 0
ORDER BY shut_outs DESC, name_last;

-- 2 -- 
SELECT name_first, name_last, 
		((homeruns*4)+(triples*3)+(doubles*2)+(hits-(doubles+triples+homeruns))) AS total_bases
FROM mlb_batting JOIN mlb_master
	on mlb_batting.player_id = mlb_master.player_id
WHERE name_last = "Smith";

-- 3 -- 
SELECT name, name_first, name_last
FROM mlb_team INNER JOIN mlb_manager
		ON mlb_team.team_id = mlb_manager.team_id
		INNER JOIN mlb_master
        ON mlb_manager.player_id = mlb_master.player_id
WHERE league = "NL" 
AND division = "C";

-- 4 --
SELECT throws, COUNT(*) AS number_of_pitchers
FROM mlb_pitching JOIN mlb_master
	ON mlb_pitching.player_id = mlb_master.player_id
GROUP BY throws;

-- 5 -- 
SELECT name, AVG(weight)
FROM mlb_pitching INNER JOIN mlb_master
	ON mlb_pitching.player_id = mlb_master.player_id
    INNER JOIN mlb_team
    ON mlb_pitching.team_id = mlb_team.team_id
GROUP BY name
ORDER BY AVG(weight) DESC;

-- 6 -- 
SELECT name_first, name_last, height, name 
FROM  mlb_manager INNER JOIN mlb_master
	ON mlb_manager.player_id = mlb_master.player_id
    INNER JOIN mlb_team
    ON mlb_team.team_id = mlb_manager.team_id
WHERE height < 70;

-- 7 -- 
SELECT p.player_id, name_first, name_last,
		SUM((outs_pitched) / 3) AS innings_pitched
FROM  mlb_pitching p INNER JOIN mlb_master m
	ON p.player_id = m.player_id
GROUP BY p.player_id
HAVING COUNT(p.stint) > 1
ORDER BY innings_pitched DESC;

-- 8 --
SELECT CONCAT(name_first, " ", name_last) AS full_name,
		wild_pitches
FROM  mlb_pitching JOIN mlb_master
	ON mlb_pitching.player_id = mlb_master.player_id
WHERE wild_pitches >= 13 
AND outs_pitched >= 500;

-- 9 -- 
SELECT name_last, (mlb_batting.hits / at_bats) AS batting_average,
		(outs_pitched / 3) AS innings_pitched
FROM  mlb_master LEFT JOIN mlb_pitching 
	ON mlb_pitching.player_id = mlb_master.player_id
    LEFT JOIN  mlb_batting
    ON mlb_batting.player_id = mlb_master.player_id
WHERE name_last LIKE "Z%";
	


        