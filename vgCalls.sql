-- Calls to game profit by region --
call gameProfitByRegion(35, 'WD');
call gameProfitByRegion(12, 'EU');
call gameProfitByRegion(10, 'JP');

-- Calls to genre ranking by region --
call genreRankingByRegion('Sports', 'WD');
call genreRankingByRegion('Role-playing', 'NA');
call genreRankingByRegion('Role-playing', 'JP');

-- Calls to published releases
call publishedReleases('Electronic Arts', 'Sports');
call publishedReleases('Electronic Arts', 'Action');

-- Call to add new release
call addNewRelease('Foo Attacks', 'X360', 'Strategy', 'Stevenson Studios');

-- select statements to check if data was inserted correctly (Is Not Auto Incrementing Correctly)
select * from vg_game where game_name = 'Foo Attacks';
select * from vg_publisher where publisher_name = 'Stevenson Studios';
select * from vg_sales s join vg_game g on s.game_id = g.game_id where g.game_name = 'Foo Attacks';