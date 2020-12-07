#Names: Charles Wang; Terry Luo
#Emails: charles.wang@vanderbilt.edu; terry.luo@vanderbilt.edu
#Project 2 Final Submission

#DATABASE/TABLE CREATION STATEMENTS

DROP DATABASE IF EXISTS nba_db;
CREATE DATABASE IF NOT EXISTS nba_db;
USE nba_db;

#used so empty decimal values can be inserted, and aggregations perform correctly
SET SESSION sql_mode = '';

#mega table
DROP TABLE IF EXISTS mega_game_stats;
CREATE TABLE IF NOT EXISTS mega_game_stats (
	season_id INT UNSIGNED NOT NULL, #this is represented as an unsigned number
	player_id INT UNSIGNED NOT NULL, #unsigned number
	player_name VARCHAR(100) NOT NULL, #string with variable length
	team_id INT UNSIGNED NOT NULL, #unsigned number within smallint's bounds
	team_abbreviation CHAR(3) NOT NULL, #abbreviation is always fixed length of 3
	team_name VARCHAR(100) NOT NULL, #variable length
	game_id INT UNSIGNED NOT NULL, #unsigned number within smallint's bounds
	game_date DATE NOT NULL,
	matchup VARCHAR(30) NOT NULL, #variable length string
	win_or_loss CHAR(1) NOT NULL, #fixed length of 1
	minutes TINYINT UNSIGNED NOT NULL, #unsigned integer within tinyint's bounds
	fgm TINYINT UNSIGNED NOT NULL, #unsigned integer within tinyint's bounds
	fga SMALLINT UNSIGNED NOT NULL, #unsigned integer within tinyint's bounds
	fg_pct DECIMAL(4,3) NOT NULL, 
	fg3m TINYINT UNSIGNED NOT NULL,  #unsigned integer within tinyint's bounds
	fg3a TINYINT UNSIGNED NOT NULL,  #unsigned integer within tinyint's bounds
	fg3_pct DECIMAL(4,3) NOT NULL,
	ftm TINYINT UNSIGNED NOT NULL,  #unsigned integer within tinyint's bounds
	fta TINYINT UNSIGNED NOT NULL, #unsigned integer within tinyint's bounds
	ft_pct DECIMAL(4,3) NOT NULL,
	oreb TINYINT UNSIGNED NOT NULL,  #unsigned integer within tinyint's bounds
	dreb TINYINT UNSIGNED NOT NULL, #unsigned integer within tinyint's bounds
	reb TINYINT UNSIGNED NOT NULL,  #unsigned integer within tinyint's bounds
	ast  TINYINT UNSIGNED NOT NULL,  #unsigned integer within tinyint's bounds
 	stl  TINYINT UNSIGNED NOT NULL,  #unsigned integer within tinyint's bounds
	blk  TINYINT UNSIGNED NOT NULL,  #unsigned integer within tinyint's bounds
	tov  TINYINT UNSIGNED NOT NULL,  #unsigned integer within tinyint's bounds
	pf  TINYINT UNSIGNED NOT NULL,  #unsigned integer within tinyint's bounds
	pts  TINYINT UNSIGNED  NOT NULL, #unsigned integer within tinyint's bounds
	plus_minus  TINYINT  NOT NULL, #could be negative
	season_type VARCHAR(20)  NOT NULL, -- not null - variable string length
	season_year SMALLINT UNSIGNED, #could be null – not necessary; season provides same info
	season CHAR(7) NOT NULL-- 4 digit year + ‘-’ + 2 digit year
);

#replace this path with wherever it is on your machine
#This is the data source used from Kaggle
#https://www.kaggle.com/ehallmar/nba-historical-stats-and-betting-data?select=nba_players_game_stats.csv – just this file
LOAD DATA INFILE '/Users/charleswang/Downloads/nba_players_game_stats.csv' 
INTO TABLE mega_game_stats
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES;


#Table that maps player id to player name
DROP TABLE IF EXISTS player_info; 
CREATE TABLE IF NOT EXISTS player_info (
	player_id INT UNSIGNED, #integer that is unsigned 
	player_name VARCHAR(100), #string with variable length
	PRIMARY KEY(player_id))
;

#maps a team name to the team id and abbreviation
DROP TABLE IF EXISTS team_info;
CREATE TABLE IF NOT EXISTS team_info(
    team_name VARCHAR(100),
	team_id  INT UNSIGNED NOT NULL,
    team_abbreviation CHAR(3) NOT NULL,
    PRIMARY KEY(team_name)
);

#season_info – maps season id to season type and years of the season
DROP TABLE IF EXISTS season_info;
CREATE TABLE IF NOT EXISTS season_info(
	season_id INT UNSIGNED,  #an integer that is unsigned
	season_type VARCHAR(20) NOT NULL, #string
	season CHAR(7) NOT NULL, #fixed length string
	PRIMARY KEY(season_id)
);
        
#season_to_year – maps a season as a string to its specific year
DROP TABLE IF EXISTS season_to_year;
CREATE TABLE IF NOT EXISTS season_to_year(
	season CHAR(7),
    season_year SMALLINT UNSIGNED NOT NULL, #years are small and unsigned
    PRIMARY KEY(season)
);
        
#game_date_info – maps a game id to the date of the game
DROP TABLE IF EXISTS game_date_info;
CREATE TABLE IF NOT EXISTS game_date_info(
	game_id INT UNSIGNED, #unsigned integer within bounds of int
	game_date DATE NOT NULL,
    PRIMARY KEY(game_id)
);
        
#history of all of a team's matchups against a team, and whether they won or lost
DROP TABLE IF EXISTS matchup_win_history;
CREATE TABLE IF NOT EXISTS matchup_win_history(
	game_id INT UNSIGNED, #id's are both unsigned integers
    team_id INT UNSIGNED,
    matchup VARCHAR(30) NOT NULL, #variable string length
    win_or_loss CHAR(1) NOT NULL, #win or loss
    PRIMARY KEY(game_id, team_id),
    CONSTRAINT fk_matchup_game #foreign key for the game id
		FOREIGN KEY (game_id)
        REFERENCES game_date_info(game_id) 
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
        
#game_to_season – maps a game id to a season id (the season the game was in)
DROP TABLE IF EXISTS game_to_season;
CREATE TABLE IF NOT EXISTS game_to_season(
	game_id INT UNSIGNED,
    season_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(game_id),
    CONSTRAINT fk_game_to_season #logic of this is shown on UML
		FOREIGN KEY (game_id)
        REFERENCES game_date_info(game_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
    );
    

#a player's statistics in a game – contains most of the important nba stats data itself
DROP TABLE IF EXISTS player_game_stats;
CREATE TABLE IF NOT EXISTS player_game_stats(
	player_id INT UNSIGNED, #unsigned number
	game_id INT UNSIGNED,
    team_name VARCHAR(100), #id is not used because name-->id, not the other way around – 
    #since a team's name changes, one id can map to multiple names
    minutes TINYINT UNSIGNED, #unsigned integer within tinyint's bounds
	fgm TINYINT UNSIGNED, #unsigned integer within tinyint's bounds
	fga SMALLINT UNSIGNED, #unsigned integer within tinyint's bounds
	fg3m TINYINT UNSIGNED,  #unsigned integer within tinyint's bounds
	fg3a TINYINT UNSIGNED,  #unsigned integer within tinyint's bounds
	ftm TINYINT UNSIGNED,  #unsigned integer within tinyint's bounds
	fta TINYINT UNSIGNED, #unsigned integer within tinyint's bounds
	oreb TINYINT UNSIGNED,  #unsigned integer within tinyint's bounds
	dreb TINYINT UNSIGNED, #unsigned integer within tinyint's bounds
	ast  TINYINT UNSIGNED,  #unsigned integer within tinyint's bounds
 	stl  TINYINT UNSIGNED,  #unsigned integer within tinyint's bounds
	blk  TINYINT UNSIGNED,  #unsigned integer within tinyint's bounds
	tov  TINYINT UNSIGNED,  #unsigned integer within tinyint's bounds
	pf  TINYINT UNSIGNED,  #unsigned integer within tinyint's bounds
	plus_minus  TINYINT, #could be negative
    PRIMARY KEY(player_id, game_id),
    
        CONSTRAINT fk_stats_player
		FOREIGN KEY (player_id)
        REFERENCES player_info(player_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	 CONSTRAINT fk_stats_game
		FOREIGN KEY (game_id)
        REFERENCES game_date_info(game_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


#these are additional statistics from a player in a game; necessary due to dependency issues with
#attributes in above table
DROP TABLE IF EXISTS player_game_additional_stats;
CREATE TABLE IF NOT EXISTS player_game_additional_stats(
	player_id INT UNSIGNED,
    game_id INT UNSIGNED,
	fg_pct DECIMAL(4,3), 
	fg3_pct DECIMAL(4,3),
	ft_pct DECIMAL(4,3),
	reb TINYINT UNSIGNED,  #unsigned integer within tinyint's bounds
	pts TINYINT UNSIGNED,
    PRIMARY KEY (player_id, game_id),
    CONSTRAINT fk_additional_stats_player #foreign key for player and game
		FOREIGN KEY (player_id)
        REFERENCES player_info(player_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	 CONSTRAINT fk_additional_stats_game
		FOREIGN KEY (game_id)
        REFERENCES game_date_info(game_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
	
);

#avg_player_stats – contains the average statistics for all nba players averaged by season
#NOTE: this table is not part of the official UML diagrams; but, it functions
#as a materialized view for all the averages data since it take so long to load.
DROP TABLE IF EXISTS avg_player_stats;
CREATE TABLE IF NOT EXISTS avg_player_stats(
	player_name VARCHAR(100),
    season CHAR(7),
    season_type VARCHAR(20),
    games_played TINYINT UNSIGNED,
    avg_minutes DECIMAL(4,1),
    avg_pts DECIMAL(4,1),
	avg_ast DECIMAL(4,1),
    avg_reb DECIMAL(4,1),
    avg_stl DECIMAL(4,1),
    avg_blk DECIMAL(4,1),
    avg_tov DECIMAL(4,1),
    avg_fgm DECIMAL(4,1),
    avg_fga DECIMAL(4,1),
    avg_fg_pct VARCHAR(10), #turn this into a labelled string
    avg_fg3m DECIMAL(4,1),
    avg_fg3a DECIMAL(4,1),
    avg_fg3_pct VARCHAR(10), #turn the decimal into a percentage-labelled string
    avg_ftm DECIMAL(4,1), 
    avg_fta DECIMAL(4,1),
    avg_ft_pct VARCHAR(10), #turn decimal into percentage-labelled string
    avg_oreb DECIMAL(4,1),
    avg_dreb DECIMAL(4,1),
    avg_pf DECIMAL(2,1), #max of 6
    avg_plus_minus DECIMAL(4,1),
    PRIMARY KEY(player_name,season,season_type)
);


#this index is created on player_name because there are many instances
#where the user will filter by, or search by a player_name. As constructed,
#the tables don't have a primary key on player_name. Thus, to 
#make this process more efficient, an index is created on player_name.
CREATE INDEX player_name_index ON player_info (player_name);



#DATABASE INSERTION STATEMENTS

#insertion into player_info table
INSERT INTO player_info 
	(SELECT 
player_id,
player_name
FROM mega_game_stats
GROUP BY player_id);

#insertion into team_info
INSERT INTO team_info
	(SELECT team_name, team_id, team_abbreviation FROM mega_game_stats GROUP BY team_name);

#inserts into season info from mega game stats table
INSERT INTO season_info
	(SELECT 
		season_id,
		season_type,
		season
		FROM mega_game_stats
		GROUP BY season_id);
        
        
#insertion into the table
INSERT INTO season_to_year
	(SELECT
		season,
		season_year
		FROM mega_game_stats
		GROUP BY season);
        
#insertion into game_date_info table
INSERT INTO game_date_info
	(SELECT
		game_id,
		game_date
		FROM mega_game_stats
		GROUP BY game_id);
        
	
#insertion into matchup_win_history table from mega table
INSERT INTO matchup_win_history
	(SELECT 
		game_id,
        team_id,
        matchup,
        win_or_loss
        FROM mega_game_stats
        GROUP BY game_id, team_id);
        
            
#insertion into game_to_season table from mega table
INSERT INTO game_to_season
	(SELECT game_id, season_id
    FROM mega_game_stats 
    GROUP BY game_id);

#inserts into the player game stats table from mega table
INSERT INTO player_game_stats
	(SELECT player_id, game_id, team_name, minutes, fgm,
			fga, fg3m, fg3a, ftm, fta, oreb,
            dreb, ast, stl, blk, tov, pf, plus_minus
            FROM mega_game_stats
            GROUP BY player_id, game_id);

#inserts into player game additional stats from mega table
INSERT INTO player_game_additional_stats
	(SELECT player_id, game_id, fg_pct, fg3_pct,
			ft_pct, reb, pts
            FROM mega_game_stats
            GROUP BY player_id, game_id);

#NOTE: The connection time limit may have to be increased from 30 seconds for this to properly load.
#It took 60 seconds on my machine, but may take longer or shorter depending on specific machine.
SET SESSION sql_mode = '';
INSERT INTO avg_player_stats
(SELECT player_name, season, season_type,
    COUNT(*) AS games_played, ROUND(AVG(minutes),1) AS avg_minutes,
	ROUND(AVG(pts),1) AS avg_pts,  ROUND(AVG(ast),1) AS avg_ast, ROUND(AVG(reb),1) AS avg_reb, ROUND(AVG(stl),1) AS avg_stl,
	ROUND(AVG(blk),1) AS avg_blk, ROUND(AVG(tov),1) AS avg_tov, ROUND(AVG(fgm),1) AS avg_fgm, ROUND(AVG(fga),1) AS avg_fga,
	CONCAT(ROUND(AVG(fg_pct)*100,1), '%') AS avg_fg_pct, ROUND(AVG(fg3m),1) AS avg_fg3m, ROUND(AVG(fg3a),1) AS avg_fg3a,
	CONCAT(ROUND(AVG(fg3_pct)*100,1),'%') AS avg_fg3_pct, ROUND(AVG(ftm),1) AS avg_ftm, ROUND(AVG(fta),1) AS avg_fta,
	CONCAT(ROUND(AVG(ft_pct)*100,1),'%') AS avg_ft_pct, ROUND(AVG(oreb),1) AS avg_oreb, ROUND(AVG(dreb),1) AS avg_dreb,
	ROUND(AVG(pf),1) AS avg_pf, ROUND(AVG(plus_minus),1) AS avg_plus_minus
  FROM player_info pi
    JOIN player_game_stats pgs
    ON pi.player_id = pgs.player_id
    JOIN player_game_additional_stats pgas
    ON pgs.player_id = pgas.player_id
        AND pgs.game_id = pgas.game_id
  JOIN game_to_season gts
    ON gts.game_id = pgs.game_id
  JOIN season_info si
    ON si.season_id = gts.season_id
  GROUP BY player_name, season, season_type);
   

#APPLICATION FUNCTIONALITY

#This procedure is used to get all of the player game statistics in a particular season
DROP PROCEDURE IF EXISTS sp_get_player_game;

DELIMITER //
CREATE PROCEDURE sp_get_player_game(IN new_player_name VARCHAR(100), IN new_season VARCHAR(20))
BEGIN


#performs all the appropriate select and join statements
SELECT  
	player_name, team_name, game_date, season_type, matchup, win_or_loss,
	minutes, pts, ast, reb, stl, blk, tov, fgm, fga, fg_pct, fg3m, fg3a, fg3_pct,
    ftm, fta, ft_pct, oreb, dreb, pf, plus_minus
    FROM player_info pi
    JOIN player_game_stats pgs
    ON pi.player_id = pgs.player_id
    JOIN player_game_additional_stats pgas
    ON pgs.player_id = pgas.player_id
        AND pgs.game_id = pgas.game_id
    JOIN team_info ti USING (team_name)
    JOIN game_date_info gdi
    ON gdi.game_id = pgs.game_id
    JOIN matchup_win_history mwh
    ON pgs.game_id = mwh.game_id
        AND ti.team_id = mwh.team_id
	JOIN game_to_season gts
	ON gts.game_id = pgs.game_id
    JOIN season_info USING (season_id)
  WHERE player_name = new_player_name
	AND season = new_season
  ORDER BY game_date DESC;
END //
DELIMITER ;



#This stored procedure is used to return the average statistics for a player
#over the course of their career – grouped by season.
#Makes use of the materialized view
DROP PROCEDURE IF EXISTS sp_get_player_season;

DELIMITER //

CREATE PROCEDURE sp_get_player_season(IN new_player_name VARCHAR(50))
BEGIN

#selects appropriate stats
SELECT * FROM avg_player_stats
WHERE player_name = new_player_name
ORDER BY season DESC;

END//

DELIMITER ;


#This stored procedure is used to get all of the existing matchups between two teams
#given that you are passed in two teams.
#Note that while you are passed in two names, the procedure uses 'id' to filter and find,
#which means that it will find all of the matchups betwen the two franchises, even if the name changed.
#We believed this was a good idea and the more preferable approach to take
USE nba_db;

DROP PROCEDURE IF EXISTS sp_matchup_history;

DELIMITER // 

CREATE PROCEDURE sp_matchup_history(team1 VARCHAR(100), team2 VARCHAR(100))
BEGIN 


	DECLARE team1_id INT UNSIGNED;
    DECLARE team2_id INT UNSIGNED;
    
    SELECT team_id
    FROM team_info
    WHERE team_name = team1
    INTO team1_id;
    
	SELECT team_id
    FROM team_info
    WHERE team_name = team2
    INTO team2_id;
    
    SELECT matchup, season_type, game_date, win_or_loss
    FROM matchup_win_history
		JOIN game_date_info USING(game_id)
        JOIN game_to_season USING(game_id)
        JOIN season_info USING(season_id)
	WHERE team_id = team1_id
		AND game_id IN 
		(SELECT game_id
        FROM matchup_win_history
        WHERE team_id = team2_id)
        ORDER BY game_date DESC;
        

END // 

DELIMITER ; 


#This stored procedure functions as a leaderboard – gets the 50 highest performers by a specific attribute
#and season type.
#We chose to only include the most salient/pertinent attributes to select on for simplicitys' sake
DROP PROCEDURE IF EXISTS sp_get_highest_season;

DELIMITER //
CREATE PROCEDURE sp_get_highest_season(IN attribute VARCHAR(20), IN new_season_type VARCHAR(20))
BEGIN
	#selects an attribute appropriately depending on the input
	SELECT * FROM avg_player_stats
	WHERE season_type = new_season_type
    ORDER BY 
	CASE attribute
 		WHEN 'points' THEN avg_pts 
		WHEN 'rebounds' THEN avg_reb
		WHEN 'assists'  THEN avg_ast
        WHEN 'steals' THEN avg_stl
        WHEN 'blocks' THEN avg_blk
		WHEN 'turnovers' THEN avg_tov
 	END DESC
    LIMIT 50
    ;
END//
DELIMITER ;

#This stored procedure gets all the player statistics for a game given a particular game

DROP PROCEDURE IF EXISTS sp_get_game_stats_all;

DELIMITER //
CREATE PROCEDURE sp_get_game_stats_all(IN team1 VARCHAR(100), IN team2 VARCHAR(100), IN new_game_date DATE)

BEGIN

	#find the 2 team's ids
	DECLARE team1_id INT UNSIGNED;
    DECLARE team2_id INT UNSIGNED;
    
    
    SELECT team_id
    FROM team_info
    WHERE team_name = team1
    INTO team1_id;
    
	SELECT team_id
    FROM team_info
    WHERE team_name = team2
    INTO team2_id;
    
    #find all the stats from their matchup
    SELECT player_name, team_name, minutes, pts, ast, reb, stl, blk, tov, 
    fgm, fga, fg_pct, fg3m, fg3a, fg3_pct, ftm, fta, ft_pct, oreb, dreb, pf, plus_minus  FROM game_date_info
    JOIN player_game_stats USING (game_id)
    JOIN player_info USING (player_id)
    JOIN player_game_additional_stats USING (player_id, game_id)
	WHERE team_name = team1
		AND game_date = new_game_date
		AND game_id IN 
		(SELECT game_id
        FROM matchup_win_history
        WHERE team_id = team2_id)
        OR
        team_name = team2  AND game_date = new_game_date
	ORDER BY team_name,pts DESC;

END //
DELIMITER ;



#This is a transaction used to insert a new season/season-type into the database.
#For instance, (2019-20 / Regular Season) 
DROP PROCEDURE IF EXISTS transaction_new_season;
 
 DELIMITER // 

 CREATE PROCEDURE transaction_new_season(season CHAR(7), season_type VARCHAR(20))
 
 BEGIN
	#variable declaration
	DECLARE s_id INT UNSIGNED;
    DECLARE season_year SMALLINT UNSIGNED;
    DECLARE message VARCHAR(100);
    
    DECLARE sql_error INT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET sql_error = TRUE;
    
    START TRANSACTION;
		
        #finds the season id
		SELECT season_id 
		FROM season_info
		WHERE season_info.season = season AND
        season_info.season_type = season_type
		INTO s_id;
        
        #inserts into season_
        SELECT CAST(LEFT(season,4) AS UNSIGNED) INTO season_year;
        
        IF season_year IS NULL THEN
			INSERT INTO season_to_year
			VALUES(season, season_year);
		END IF;
        
		
		IF s_id IS NULL THEN
			SELECT MAX(season_id) + 1
			FROM season_info
			INTO s_id;
			
			INSERT INTO season_info
			VALUES (s_id, season_type, season);
            
		ELSE
            SET sql_error = TRUE;
		END IF;
        
        IF sql_error = FALSE THEN
			COMMIT;
            SELECT "The season was successfully inserted." AS message;
		ELSE 
			ROLLBACK;
            SELECT "The new season was not inserted. Make sure the season doesn't already exist." AS message;
		END IF;
    
 END //
 
 DELIMITER ;
 
 
 
#This is a stored procedure. It inserts a new player into the player table
#given a new player.
 DROP PROCEDURE IF EXISTS sp_new_player;
 
 DELIMITER // 

 CREATE PROCEDURE sp_new_player(player_name VARCHAR(100))
 
 BEGIN
	DECLARE p_id INT UNSIGNED;
	
    #find player id
    SELECT player_id
	FROM player_info
	WHERE player_info.player_name = player_name
	INTO p_id;
    
    #insert it if it doesn't exist
	IF p_id IS NULL THEN
		SELECT MAX(player_id) + 1
		FROM player_info
		INTO p_id;
		
		INSERT INTO player_info
		VALUES (p_id, player_name);
        
        SELECT CONCAT(player_name, " was successfully inserted.") AS msg;
	ELSE
		SELECT CONCAT(player_name, " already exists.") AS msg;
	END IF;
    
 END //
 
 DELIMITER ;
 
 #This is a transaction. It will insert a new game between two teams, including 
 DROP PROCEDURE IF EXISTS transaction_new_game;

 DELIMITER //

 CREATE PROCEDURE transaction_new_game(team1 VARCHAR(100),
							  team2 VARCHAR(100),
							  g_date DATE,
                              season CHAR(7),
                              season_type VARCHAR(20),
                              result VARCHAR(3))

 BEGIN
	DECLARE s_id INT UNSIGNED;
	DECLARE g_id INT UNSIGNED;
	DECLARE team1_id INT UNSIGNED;
	DECLARE team2_id INT UNSIGNED;
    DECLARE team1_abbr CHAR(3);
    DECLARE team2_abbr CHAR(3);
    DECLARE team1_res CHAR(1);
    DECLARE team2_res CHAR(1);

    DECLARE sql_error INT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET sql_error = TRUE;

    START TRANSACTION;

		SELECT season_id
  		FROM season_info
  		WHERE season_info.season = season AND season_info.season_type = season_type
  		INTO s_id;
        
        IF s_id IS NULL THEN
  			SET sql_error = TRUE;
  		END IF;

		SELECT team_abbreviation 
        FROM team_info
        WHERE team_name = team1
        INTO team1_abbr;
        
        SELECT team_abbreviation 
        FROM team_info
        WHERE team_name = team2
        INTO team2_abbr;
        
        SELECT team_id
  		FROM team_info
  		WHERE team_name = team1
  		INTO team1_id;

  		SELECT team_id
  		FROM team_info
  		WHERE team_name = team2
  		INTO team2_id;

		SELECT game_id
  		FROM matchup_win_history
  			JOIN game_date_info USING(game_id)
  		WHERE team_id = team1_id AND game_date = g_date
  			AND game_id IN
  			(SELECT game_id
  			FROM matchup_win_history
  			WHERE team_id = team2_id)
  		INTO g_id;

		IF g_id IS NOT NULL THEN
  			SET sql_error = TRUE;
  		END IF;
        
        SELECT MAX(game_id) + 1
		FROM game_date_info
		INTO g_id;
		
		INSERT INTO game_date_info
		VALUES (g_id, g_date);
        
        INSERT INTO game_to_season
        VALUES (g_id, s_id);
        
        -- insert matchup result
        
        IF result = "YES" THEN
			SET team1_res = "W";
            SET team2_res = "L";
		ELSE
			SET team1_res = "L";
            SET team2_res = "W";
		END IF;
        
        INSERT INTO matchup_win_history
        VALUES (g_id, team1_id, CONCAT(team1_abbr, " vs. ", team2_abbr), team1_res);
        
        INSERT INTO matchup_win_history
        VALUES (g_id, team2_id, CONCAT(team2_abbr, " @ ", team1_abbr), team2_res);

        IF sql_error = FALSE THEN
			COMMIT;
            SELECT CONCAT("The new game between ", team1, " and ", team2,
            " on ", g_date, " was successfully inserted.") AS msg;
		ELSE
			ROLLBACK;
            SELECT CONCAT("The game between ", team1, " and ", team2,
            " on ", g_date, " was not inserted.",
            " Make sure both teams exist, the season exists, and 
            the game doesn't already exist.") AS msg;
		END IF;

 END //

 DELIMITER ;
 
 
#This is a transaction/stored procedure – it is used to insert a new set of player game 
#statistics into a particular game for a particular player. If the player's game stats
#already exist, it will instead update it with whatever new statistics the user inserted.
#Note – the player itself and the game itself must both exist in order for this to work.
#if neither of them exist, be sure to insert the new game or new player first
#before you insert the stats.
DROP PROCEDURE IF EXISTS transaction_update_insert_game_stats;	

DELIMITER // 

CREATE PROCEDURE transaction_update_insert_game_stats(player_name VARCHAR(100),
									team1 VARCHAR(100), 
                                    team2 VARCHAR(100),
									g_date DATE,
                                    minutes TINYINT UNSIGNED,
                                    fgm TINYINT UNSIGNED,
                                    fga TINYINT UNSIGNED,
                                    fg3m TINYINT UNSIGNED,
                                    fg3a TINYINT UNSIGNED,
                                    ftm TINYINT UNSIGNED,
                                    fta TINYINT UNSIGNED,
                                    oreb TINYINT UNSIGNED,
                                    dreb TINYINT UNSIGNED,
                                    ast TINYINT UNSIGNED,
                                    stl TINYINT UNSIGNED,
                                    blk TINYINT UNSIGNED,
                                    tov TINYINT UNSIGNED,
                                    pf TINYINT UNSIGNED,
                                    plus_minus TINYINT)
BEGIN 
	#initial variable declaration
	DECLARE g_id INT UNSIGNED;
    DECLARE t_name VARCHAR(100);
    DECLARE p_id INT UNSIGNED;
	DECLARE team1_id INT UNSIGNED;
    DECLARE team2_id INT UNSIGNED;
    DECLARE msg INT UNSIGNED;
    
	
	DECLARE fg_pct DECIMAL(4,3);
    DECLARE fg3_pct DECIMAL(4,3);
    DECLARE ft_pct DECIMAL(4,3);
    
	DECLARE sql_error INT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET sql_error = TRUE;
    
    
    
    START TRANSACTION;
    
		#calculates the statistics that can be calculated
		IF fga = 0 THEN
			SELECT 0 INTO fg_pct;
		ELSE        
			SELECT fgm / fga INTO fg_pct;
		END IF;
        
        IF fg3a = 0 THEN
			SELECT 0 INTO fg3_pct;
        ELSE
			SELECT fg3m / fg3a INTO fg3_pct;
        END IF;
        
        IF fta = 0 THEN
			SELECT 0 INTO ft_pct;
        ELSE
			SELECT ftm / fta INTO ft_pct;
        END IF;
        
        -- find player
        
        SELECT player_id
        FROM player_info
        WHERE player_info.player_name = player_name
        INTO p_id;
        
        IF p_id IS NULL THEN
			SET sql_error = TRUE;
            SET msg = 10;
		END IF;
        
		-- find game

		SELECT team_id
		FROM team_info
		WHERE team_name = team1
		INTO team1_id;
		
		SELECT team_id
		FROM team_info
		WHERE team_name = team2
		INTO team2_id;
        
        SELECT game_id
		FROM matchup_win_history
			JOIN game_date_info USING(game_id)
		WHERE team_id = team1_id AND game_date = g_date
			AND game_id IN 
			(SELECT game_id
			FROM matchup_win_history
			WHERE team_id = team2_id)
		INTO g_id;
        
        IF g_id IS NULL THEN
			SET sql_error = TRUE;
            SET msg = 20;
		END IF;
        
		#finds the player's team name
        SELECT DISTINCT team_name
        FROM player_game_stats
        WHERE game_id = g_id 
			AND p_id IN 
			(SELECT player_id
			FROM player_game_stats
			WHERE game_id = g_id)
			AND team_name = team1
		INTO t_name;
        
       
            
        #create a new entry
        IF t_name IS NULL THEN -- this player didn't play for either team in this game
			SET msg = 100;
			INSERT INTO player_game_stats
			VALUES (p_id,
					g_id,
					team1,
					minutes,
					fgm, fga,
					fg3m, fg3a,
					ftm, fta,
					oreb, dreb,
					ast,
					stl,
					blk,
					tov,
					pf,
					plus_minus);
						
			INSERT INTO player_game_additional_stats 
			VALUES (p_id, g_id, fg_pct, fg3_pct, ft_pct, oreb + dreb, (fgm - fg3m) * 2 + fg3m * 3 + ftm);
       ELSE
			#the entry already exists – perform all of the update functions appropriately
			UPDATE player_game_stats
			SET player_game_stats.minutes=minutes,
				player_game_stats.fgm=fgm,
				player_game_stats.fga=fga,
				player_game_stats.fg3m=fg3m,
				player_game_stats.fg3a=fg3a,
				player_game_stats.ftm=ftm,
				player_game_stats.fta=fta,
				player_game_stats.oreb=oreb,
				player_game_stats.dreb=dreb,
				player_game_stats.ast=ast,
				player_game_stats.stl=stl,
				player_game_stats.blk=blk,
				player_game_stats.tov=tov,
				player_game_stats.pf=pf,
				player_game_stats.plus_minus=plus_minus
			WHERE player_game_stats.player_id=p_id 
				AND player_game_stats.game_id=g_id;
				
			 
            
			UPDATE player_game_additional_stats
			SET
						player_game_additional_stats.fg_pct = fg_pct,
						player_game_additional_stats.fg3_pct = fg3_pct,
						player_game_additional_stats.ft_pct = ft_pct,
						player_game_additional_stats.reb = oreb+dreb,
						player_game_additional_stats.pts = (fgm - fg3m) * 2 + fg3m * 3 + ftm
			WHERE player_game_additional_stats.player_id=p_id
				AND player_game_additional_stats.game_id=g_id;

		END IF;
        
		IF sql_error = FALSE THEN
			COMMIT;
            SELECT CONCAT("The insertion or update for ", player_name, " on ", g_date, " was successful.") AS msg;
		ELSE 
			ROLLBACK;
			SELECT CONCAT("The insertion or update for ", player_name, " on ", g_date, " was unsuccessful. Make sure
            the player and game both exist first.") AS msg;

		END IF;
END // 

DELIMITER ;


#This is a transaction. It is used to delete a player's game statistics when passed in a particular player name
#and information used to identify a game (player's team, opponent's team, game date).
DROP PROCEDURE IF EXISTS transaction_delete_game_stats;	

DELIMITER // 

CREATE PROCEDURE transaction_delete_game_stats(player_name VARCHAR(100),
									team1 VARCHAR(100), 
                                    team2 VARCHAR(100),
									g_date DATE)
BEGIN 
	#initial variable declaration
	DECLARE g_id INT UNSIGNED;
    DECLARE p_id INT UNSIGNED;
	DECLARE team1_id INT UNSIGNED;
    DECLARE team2_id INT UNSIGNED;
    DECLARE message VARCHAR(100);
    DECLARE variableMinutes TINYINT UNSIGNED;
	
	DECLARE sql_error INT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET sql_error = TRUE;
    
    START TRANSACTION;
    
		#finds the player's id
		SELECT player_id
        FROM player_info
        WHERE player_info.player_name = player_name
        INTO p_id;
        
        IF p_id IS NULL THEN
			SET message = CONCAT("Couldn't find the player ", player_name);
		END IF;
        
        #finds both teams''s id
        SELECT team_id
		FROM team_info
		WHERE team_name = team1
		INTO team1_id;
		
		SELECT team_id
		FROM team_info
		WHERE team_name = team2
		INTO team2_id;
        
        #finds the game matchup between the two on the particular date
        SELECT game_id
		FROM matchup_win_history
			JOIN game_date_info USING(game_id)
		WHERE team_id = team1_id AND game_date = g_date
			AND game_id IN 
			(SELECT game_id
			FROM matchup_win_history
			WHERE team_id = team2_id)
		INTO g_id;
        
        IF p_id IS NULL THEN
			SET message = CONCAT("Couldn't find a game");
		END IF;

		#this is used to set the error to true if the game isn't actually found.
		SELECT minutes FROM player_game_stats
        WHERE player_id = p_id AND game_id = g_id INTO variableMinutes;
        
        IF variableMinutes IS NULL THEN
			SET sql_error = TRUE;
		
        ELSE 
			#performs the deletion
			DELETE FROM player_game_stats
			WHERE player_id = p_id AND game_id = g_id;
			
			DELETE FROM player_game_additional_stats 
			WHERE player_id = p_id AND game_id = g_id;
        
        END IF;
        
        #returns the appropriate message – commits/rolls back if necessar.
        IF sql_error = FALSE THEN
			COMMIT;
            SELECT CONCAT("The deletion for ", player_name, " on ", g_date, " was successful.") AS message;
		ELSE 
			ROLLBACK;
            SELECT CONCAT("The deletion for ", player_name, " on ", g_date, " did not occur. Check that the player's game statistics exist.")
            AS message;
		END IF;
END // 

DELIMITER ; 

#This is a trigger that is
#used to update average player stats whenever a new game is inserted (meaning an entry was made into player_game_stats.

DROP TRIGGER IF EXISTS avg_insert;
DELIMITER //

CREATE TRIGGER avg_insert
AFTER INSERT
ON player_game_additional_stats
FOR EACH ROW
BEGIN
	#variable declaration
	DECLARE new_season_id INT UNSIGNED;
    DECLARE new_season_type VARCHAR(20);
    DECLARE new_season CHAR(7);
    SELECT season_id FROM game_to_season WHERE game_id = new.game_id INTO new_season_id;
    SELECT season FROM season_info WHERE season_id = new_season_id INTO new_season;
	SELECT season_type FROM season_info WHERE season_id = new_season_id INTO new_season_type;

	#deletes the entry as it is before inserting it with new entries
	DELETE FROM avg_player_stats
    WHERE player_name = 
		(SELECT player_name FROM player_info WHERE player_id = new.player_id)
        AND season_type = new_season_type
		AND season = new_season;
        
        
	INSERT INTO avg_player_stats
		(SELECT player_name, season, season_type,
			COUNT(*) AS games_played, ROUND(AVG(minutes),1) AS avg_minutes,
			ROUND(AVG(pts),1) AS avg_pts,  ROUND(AVG(ast),1) AS avg_ast, ROUND(AVG(reb),1) AS avg_reb, ROUND(AVG(stl),1) AS avg_stl,
			ROUND(AVG(blk),1) AS avg_blk, ROUND(AVG(tov),1) AS avg_tov, ROUND(AVG(fgm),1) AS avg_fgm, ROUND(AVG(fga),1) AS avg_fga,
			CONCAT(ROUND(AVG(fg_pct)*100,1), '%') AS avg_fg_pct, ROUND(AVG(fg3m),1) AS avg_fg3m, ROUND(AVG(fg3a),1) AS avg_fg3a,
			CONCAT(ROUND(AVG(fg3_pct)*100,1),'%') AS avg_fg3_pct, ROUND(AVG(ftm),1) AS avg_ftm, ROUND(AVG(fta),1) AS avg_fta,
			CONCAT(ROUND(AVG(ft_pct)*100,1),'%') AS avg_ft_pct, ROUND(AVG(oreb),1) AS avg_oreb, ROUND(AVG(dreb),1) AS avg_dreb,
			ROUND(AVG(pf),1) AS avg_pf, ROUND(AVG(plus_minus),1) AS avg_plus_minus
  FROM player_info pi #performs appropriate joins
    JOIN player_game_stats pgs
    ON pi.player_id = pgs.player_id
    JOIN player_game_additional_stats pgas
    ON pgs.player_id = pgas.player_id
        AND pgs.game_id = pgas.game_id
  JOIN game_to_season gts
    ON gts.game_id = pgs.game_id
  JOIN season_info si
    ON si.season_id = gts.season_id
WHERE pi.player_id = new.player_id
AND si.season = new_season AND si.season_type = new_season_type
  GROUP BY player_name, season, season_type);
END//
DELIMITER ;
  

#triggers to update average player stats whenever a new game is delete
# (meaning an entry was removed from player_game_stats, or player_game_additional_stats

DROP TRIGGER IF EXISTS avg_delete;
DELIMITER //

CREATE TRIGGER avg_delete
AFTER DELETE
ON player_game_additional_stats
FOR EACH ROW
BEGIN
	DECLARE new_season_id INT UNSIGNED;
    DECLARE new_season_type VARCHAR(20);
    DECLARE new_season CHAR(7);
    SELECT season_id FROM game_to_season WHERE game_id = old.game_id INTO new_season_id;
    SELECT season_type, season FROM season_info WHERE season_id = new_season_id INTO new_season_type, new_season;
	
    #deletes first
	DELETE FROM avg_player_stats
    WHERE player_name = 
		(SELECT player_name FROM player_info WHERE player_id = old.player_id)
        AND season_type = new_season_type
		AND season = new_season;
        
	#re-inserts the entries
	INSERT INTO avg_player_stats
		(SELECT player_name, season, season_type,
			COUNT(*) AS games_played, AVG(minutes) AS avg_minutes,
			AVG(pts) AS avg_pts,  ROUND(AVG(ast),1) AS avg_ast, ROUND(AVG(reb),1) AS avg_reb, ROUND(AVG(stl),1) AS avg_stl,
			ROUND(AVG(blk),1) AS avg_blk, ROUND(AVG(tov),1) AS avg_tov, ROUND(AVG(fgm),1) AS avg_fgm, ROUND(AVG(fga),1) AS avg_fga,
			CONCAT(ROUND(AVG(fg_pct)*100,1), '%') AS avg_fg_pct, ROUND(AVG(fg3m),1) AS avg_fg3m, ROUND(AVG(fg3a),1) AS avg_fg3a,
			CONCAT(ROUND(AVG(fg3_pct)*100,1),'%') AS avg_fg3_pct, ROUND(AVG(ftm),1) AS avg_ftm, ROUND(AVG(fta),1) AS avg_fta,
			CONCAT(ROUND(AVG(ft_pct)*100,1),'%') AS avg_ft_pct, ROUND(AVG(oreb),1) AS avg_oreb, ROUND(AVG(dreb),1) AS avg_dreb,
			ROUND(AVG(pf),1) AS avg_pf, ROUND(AVG(plus_minus),1) AS avg_plus_minus
  FROM player_info pi #performs appropriate joins
    JOIN player_game_stats pgs
    ON pi.player_id = pgs.player_id
    JOIN player_game_additional_stats pgas
    ON pgs.player_id = pgas.player_id
        AND pgs.game_id = pgas.game_id
  JOIN game_to_season gts
    ON gts.game_id = pgs.game_id
  JOIN season_info si
    ON si.season_id = gts.season_id
WHERE pi.player_id = old.player_id
AND si.season = new_season AND si.season_type = new_season_type
  GROUP BY player_name, season, season_type);
END//
DELIMITER ;


#Triggers to update average player stats whenever a new game is updated (meaning an entry was updated in player_game_stats
#Separate triggers have to be made because you can't make a trigger to update/delete the same table
DROP TRIGGER IF EXISTS avg_update;
DELIMITER //

CREATE TRIGGER avg_update
AFTER UPDATE
ON player_game_additional_stats
FOR EACH ROW
BEGIN
	DECLARE new_season_id INT UNSIGNED;
    DECLARE new_season_type VARCHAR(20);
    DECLARE new_season CHAR(7);
    SELECT season_id FROM game_to_season WHERE game_id = new.game_id INTO new_season_id;
    SELECT season_type, season FROM season_info WHERE season_id = new_season_id INTO new_season_type, new_season;
	
    #deletes the entry for the player/season before changing it
	DELETE FROM avg_player_stats
    WHERE player_name = 
		(SELECT player_name FROM player_info WHERE player_id = new.player_id)
        AND season_type = new_season_type
		AND season = new_season;
        
	#re-inserts the entry
	INSERT INTO avg_player_stats
		(SELECT player_name, season, season_type,
			COUNT(*) AS games_played, AVG(minutes) AS avg_minutes,
			AVG(pts) AS avg_pts,  ROUND(AVG(ast),1) AS avg_ast, ROUND(AVG(reb),1) AS avg_reb, ROUND(AVG(stl),1) AS avg_stl,
			ROUND(AVG(blk),1) AS avg_blk, ROUND(AVG(tov),1) AS avg_tov, ROUND(AVG(fgm),1) AS avg_fgm, ROUND(AVG(fga),1) AS avg_fga,
			CONCAT(ROUND(AVG(fg_pct)*100,1), '%') AS avg_fg_pct, ROUND(AVG(fg3m),1) AS avg_fg3m, ROUND(AVG(fg3a),1) AS avg_fg3a,
			CONCAT(ROUND(AVG(fg3_pct)*100,1),'%') AS avg_fg3_pct, ROUND(AVG(ftm),1) AS avg_ftm, ROUND(AVG(fta),1) AS avg_fta,
			CONCAT(ROUND(AVG(ft_pct)*100,1),'%') AS avg_ft_pct, ROUND(AVG(oreb),1) AS avg_oreb, ROUND(AVG(dreb),1) AS avg_dreb,
			ROUND(AVG(pf),1) AS avg_pf, ROUND(AVG(plus_minus),1) AS avg_plus_minus
  FROM player_info pi #performs appropriate joins
    JOIN player_game_stats pgs
    ON pi.player_id = pgs.player_id
    JOIN player_game_additional_stats pgas
    ON pgs.player_id = pgas.player_id
        AND pgs.game_id = pgas.game_id
  JOIN game_to_season gts
    ON gts.game_id = pgs.game_id
  JOIN season_info si
    ON si.season_id = gts.season_id
WHERE pi.player_id = new.player_id
AND si.season = new_season AND si.season_type = new_season_type
  GROUP BY player_name, season, season_type);
END//
DELIMITER ;

 

            
            
            
            
            
            
            
            
            


