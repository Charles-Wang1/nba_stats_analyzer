# nba_stats_analyzer

This project uses a dataset found on Kaggle that contains every NBA player’s stats by game from 1950 to 2018. These basic stats serve as valuable information to both teams and fans. From a team’s perspective, every decision from trading players to designing a training schedule is influenced by these stats. From a fan’s perspective, the ability to compare and contrast different teams and players is very interesting. We wanted to find a way to filter and analyze this dataset in a useful manner. We got inspiration from currently existing websites such as NBA.com and basketball-reference.com. Our application aims to deliver a user friendly search engine for player stats in many different ways for a thorough analysis. 



We used a MAMP server to create a connection to the MySQL database (version 14). Our frontend is written in PHP and HTML. To recreate the database, simply download the csv from Kaggle (source below) and put it into the correct folder. Then, run the database creation script.

The demo file contains a link to a running demo of the application.



**Data source:** https://www.kaggle.com/ehallmar/nba-historical-stats-and-betting-data?select=nba_players_game_stats.csv