-- 1 --
SELECT team_id, league, division, name
FROM mlb_team;

-- 2 --
SELECT MAX(complete_games) 
AS max_complete_games_pitched
FROM mlb_pitching;

-- 3 -- 
SELECT COUNT(*) AS debut_in_sept_2014
FROM mlb_master
WHERE year(debut) = 2014 and month(debut) = 09;

-- 4 --
SELECT MAX(DATEDIFF(final_game, debut)) 
AS max_game_diff_in_days
FROM mlb_master;

-- 5 --
SELECT AVG(opp_batting_avg) 
AS opp_batting_avg
FROM mlb_pitching
WHERE games >= 25;

-- 6 --
SELECT MAX(attendance), MIN(attendance), (MAX(attendance) - MIN(attendance)) 
AS min_max_and_difference
FROM mlb_team;

-- 7 --
SELECT park
FROM mlb_team
WHERE park LIKE '%park%' or park LIKE '%field%' or park lIKE '%stadium%'
ORDER BY park;

-- 8 --
SELECT COUNT(*) as team_with_mult_coaches
FROM mlb_manager
WHERE stint > 1;

-- 9 -- 
SELECT MAX((stolen_bases/ (stolen_bases + caught_stealing)) * 100) 
AS highest_stolen_base_percentage
FROM mlb_batting
where (stolen_bases + caught_stealing) > 20;

-- 10 --
SELECT name, league, won_ws, won_lg, won_div, won_wc
FROM mlb_team
WHERE won_div = 'Y' or won_wc = 'Y'
ORDER BY won_ws DESC , won_lg DESC, won_div DESC,  won_wc DESC, name;


