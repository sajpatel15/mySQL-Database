DROP TABLE IF EXISTS vg_sales;
DROP TABLE IF EXISTS vg_game_platform;
DROP TABLE IF EXISTS vg_game_publisher;
DROP TABLE IF EXISTS vg_game;
DROP TABLE IF EXISTS vg_genre;
DROP TABLE IF EXISTS vg_publisher;
DROP TABLE IF EXISTS vg_platform;


CREATE TABLE vg_genre (
	genre_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(25)
);

CREATE TABLE vg_publisher (
	publisher_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100)
);

CREATE TABLE vg_platform (
	platform_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    platform_name VARCHAR(25)
);

CREATE TABLE vg_game (
	game_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    game_name VARCHAR(1000),
    genre_id BIGINT,
    CONSTRAINT vg_game_genre_id_fk FOREIGN KEY (genre_id) REFERENCES vg_genre(genre_id)
);

CREATE TABLE vg_sales (
	sales_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    game_id BIGINT,
    platform_id BIGINT,
    publisher_id BIGINT,
    sales_year INT(4),
    NA_sales DOUBLE(4,2),
    EU_sales DOUBLE(4,2),
    JP_sales DOUBLE(4,2),
    other_sales DOUBLE (4,2),
    CONSTRAINT vg_sales_game_id_fk FOREIGN KEY (game_id) REFERENCES vg_game(game_id),
    CONSTRAINT vg_game_platform_platform_id_fk FOREIGN KEY (platform_id) REFERENCES vg_platform(platform_id),
    CONSTRAINT vg_game_publisher_publisher_id_fk FOREIGN KEY (publisher_id) REFERENCES vg_publisher(publisher_id)
);

INSERT INTO vg_genre (genre_name) (SELECT DISTINCT Genre FROM vg_csv);

INSERT INTO vg_platform (platform_name) (SELECT DISTINCT Platform FROM vg_csv);

INSERT INTO vg_publisher (publisher_name) (SELECT DISTINCT 
	(
		CASE WHEN publisher = 'Unknown' OR publisher = 'N/A' THEN NULL
		ELSE publisher END
	)
    FROM vg_csv);

INSERT INTO vg_game (game_name, genre_id) 
	(SELECT DISTINCT v.Name, g.genre_id 
     FROM vg_csv v JOIN vg_genre g ON v.Genre = g.genre_name);
     
INSERT INTO vg_sales(game_id, platform_id, publisher_id, sales_year, NA_sales, EU_sales, JP_sales, other_sales)
	(SELECT g.game_id, p.platform_id, (CASE WHEN v.Publisher = 'N/A' OR v.Publisher = 'Unknown' THEN NULL ELSE pb.publisher_id END) AS pub_id, 
    (CASE WHEN v.Year = 'N/A' THEN NULL ELSE CONVERT(v.year, SIGNED) END), 
		CONVERT(v.NA_sales,DOUBLE), CONVERT(v.EU_sales, DOUBLE), CONVERT(v.JP_sales, DOUBLE), 
        CONVERT(v.Other_Sales,DOUBLE)
	FROM vg_csv v JOIN vg_game g ON v.Name = g.game_name
    JOIN vg_platform p ON v.Platform = p.platform_name
    LEFT JOIN vg_publisher pb ON v.Publisher = pb.publisher_name);
    