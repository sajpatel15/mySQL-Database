DROP PROCEDURE IF EXISTS gameProfitByRegion;
DROP PROCEDURE IF EXISTS genreRankingByRegion;
DROP PROCEDURE IF EXISTS publishedReleases;
DROP PROCEDURE IF EXISTS addNewRelease;

delimiter //
CREATE PROCEDURE gameProfitByRegion(IN sale INT, IN region VARCHAR(2))
BEGIN
	IF region = 'WD' THEN
		SELECT g.game_name, (s.NA_sales+s.EU_sales+s.JP_sales+s.other_sales)
        FROM vg_sales s JOIN vg_game g ON s.game_id = g.game_id
        WHERE s.NA_sales+s.EU_sales+s.JP_sales+s.other_sales > sale;
	ELSEIF region = 'NA' THEN
		SELECT g.game_name, s.NA_sales
        FROM vg_sales s JOIN vg_game g ON s.game_id = g.game_id
        WHERE s.NA_sales > sale;
	ELSEIF region = 'EU' THEN
		SELECT g.game_name, s.EU_sales
        FROM vg_sales s JOIN vg_game g ON s.game_id = g.game_id
        WHERE s.EU_sales > sale;
	ELSEIF region = 'JP' THEN
		SELECT g.game_name, s.JP_sales
        FROM vg_sales s JOIN vg_game g ON s.game_id = g.game_id
        WHERE s.JP_sales > sale;
	END IF;
END //
delimiter ;

delimiter //
CREATE PROCEDURE genreRankingByRegion(IN genre VARCHAR(100), IN region VARCHAR(2))

BEGIN
	IF region = 'WD' THEN
		WITH ranking AS
			(SELECT gr.genre_name, RANK() OVER (
            ORDER BY SUM((s.NA_sales+s.EU_sales+s.JP_sales+s.other_sales)) DESC
			) regionRanking
             FROM vg_sales s JOIN vg_game g ON s.game_id = g.game_id
			 JOIN vg_genre gr ON g.genre_id = gr.genre_id
             GROUP BY gr.genre_name
        )
        SELECT regionRanking FROM ranking
        WHERE genre_name = genre;
	ELSEIF region = 'NA' THEN
		WITH ranking AS
			(SELECT gr.genre_name, RANK() OVER (
            ORDER BY s.NA_sales DESC
			) regionRanking
             FROM vg_sales s JOIN vg_game g ON s.game_id = g.game_id
			 JOIN vg_genre gr ON g.genre_id = gr.genre_id
             GROUP BY gr.genre_name
        )
        SELECT regionRanking FROM ranking
        WHERE genre_name = genre;
	ELSEIF region = 'EU' THEN
		WITH ranking AS
			(SELECT gr.genre_name, RANK() OVER (
            ORDER BY s.EU_sales DESC
			) regionRanking
             FROM vg_sales s JOIN vg_game g ON s.game_id = g.game_id
			 JOIN vg_genre gr ON g.genre_id = gr.genre_id
             GROUP BY gr.genre_name
        )
        SELECT regionRanking FROM ranking
        WHERE genre_name = genre;
	ELSEIF region = 'JP' THEN
		WITH ranking AS
			(SELECT gr.genre_name, RANK() OVER (
            ORDER BY s.JP_sales DESC
			) regionRanking
             FROM vg_sales s JOIN vg_game g ON s.game_id = g.game_id
			 JOIN vg_genre gr ON g.genre_id = gr.genre_id
             GROUP BY gr.genre_name
        )
        SELECT regionRanking FROM ranking
        WHERE genre_name = genre;
	END IF;
END //
delimiter ;

-- consider the game to be the same... dont care about platform
delimiter //
CREATE PROCEDURE publishedReleases(IN pub_name VARCHAR(100), IN gen_name VARCHAR(100))
BEGIN
	SELECT COUNT(DISTINCT g.game_name) 
    FROM vg_publisher p JOIN vg_sales s ON p.publisher_id = s.publisher_id
    JOIN vg_game g ON g.game_id = s.game_id
    JOIN vg_genre gr ON g.genre_id = gr.genre_id
    WHERE p.publisher_name = pub_name AND gr.genre_name = gen_name;
END //
delimiter ;

delimiter //
CREATE PROCEDURE addNewRelease(IN title VARCHAR(100), IN platform VARCHAR(100), IN genre VARCHAR(100), 
	IN publisher VARCHAR(100))
BEGIN
	IF (SELECT genre_name FROM vg_genre WHERE genre_name = genre) IS NULL THEN
		INSERT INTO vg_genre(genre_name) VALUES (genre);
    END IF;
    IF (SELECT platform_name FROM vg_platform WHERE platform_name = platform) IS NULL THEN
		INSERT INTO vg_platform(platform_name) VALUES (platform);
    END IF;
    IF (SELECT publisher_name FROM vg_publisher WHERE publisher_name = publisher) IS NULL THEN
		INSERT INTO vg_publisher(publisher_name) VALUES (publisher);
	END IF;
    IF (SELECT game_name FROM vg_game WHERE game_name = title) IS NULL THEN
		INSERT INTO vg_game(game_name, genre_id) VALUES (title, (SELECT genre_id FROM vg_genre WHERE genre_name = genre)); 
	END IF;
    INSERT INTO vg_sales(game_id, platform_id, publisher_id, sales_year, NA_sales, EU_sales, JP_sales, other_sales)
    VALUES((SELECT game_id FROM vg_game WHERE title = game_name), (SELECT platform_id FROM vg_platform WHERE platform = platform_name),
		(SELECT publisher_id FROM vg_publisher WHERE publisher = publisher_name), (SELECT YEAR(CURDATE())),
        0, 0, 0, 0);
END //
delimiter ; 