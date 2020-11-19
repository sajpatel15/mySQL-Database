-- 1 -- 
SELECT name_last
FROM mlb_batting b JOIN mlb_master m
	ON b.player_id = m.player_id
WHERE b.doubles > 45;

-- 2 --
SELECT name_last
FROM mlb_master
WHERE player_id in
	(SELECT player_id
    FROM mlb_batting
    WHERE doubles > 45);

-- 3 -- 
SELECT name_last, doubles
FROM mlb_batting b JOIN mlb_master m
	ON b.player_id = m.player_id
WHERE b.doubles > 45; 

-- 4 -- 
SELECT name, wins
FROM mlb_team
WHERE wins > 
		(SELECT avg(wins)
        FROM mlb_team)
ORDER BY wins DESC;

-- 5 --
SELECT name_first, name_last, hit_by_pitch
FROM mlb_master m JOIN mlb_pitching p
	ON m.player_id = p.player_id
WHERE hit_by_pitch = 
		(SELECT MAX(hit_by_pitch)
        from mlb_pitching);

-- 6 --
SELECT name_first, name_last, height, name
FROM mlb_master m JOIN mlb_manager mgr
	ON m.player_id = mgr.player_id
	JOIN  mlb_team t 
    ON mgr.team_id = t.team_id
WHERE height = 
		(SELECT min(height)
        FROM mlb_master m JOIN mlb_manager mgr
			ON m.player_id = mgr.player_id);

-- 7 -- 
SELECT name_first, name_last, (strikeouts/walks) AS strikeOutsPerWalk
FROM mlb_master m JOIN mlb_pitching p 
	ON m.player_id = p.player_id
WHERE p.walks >= 1 AND p.games >= 25
ORDER BY strikeOutsPerWalk DESC 
LIMIT 10;

-- 8 --
SELECT team_id
FROM mlb_batting
WHERE stolen_bases > 40
UNION
SELECT team_id
FROM mlb_batting
WHERE homeruns > 35;

-- 9 --
SELECT DISTINCT p1.player_id
FROM (
		SELECT * FROM mlb_pitching
     ) p1
    INNER JOIN 
    (
		SELECT * FROM mlb_batting
		WHERE homeruns > 10
    ) p2
    ON p1.player_id = p2.player_id;

-- 10 --
CREATE OR REPLACE VIEW mlb_national AS
SELECT *
FROM mlb_team
WHERE league = 'NL';

SELECT *
FROM mlb_national;