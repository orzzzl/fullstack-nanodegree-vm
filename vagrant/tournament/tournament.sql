-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- Clean up if there exists any database.
DROP DATABASE IF EXISTS tournament;


-- Create the main database
CREATE DATABASE tournament;

-- cd to this database
\c tournament;


-- Create the table for recording player infos
CREATE TABLE Players(
	name text,
	id serial PRIMARY KEY
);


-- Create the table for recording match results
CREATE TABLE Matches(
	winner_id int REFERENCES Players(id),
	loser_id int REFERENCES Players(id),
	id serial PRIMARY KEY
);


-- Create a view which shows how many wins each player has
CREATE VIEW Wins AS 
	SELECT Players.id AS id, COUNT(Matches.winner_id) AS wins
	FROM Players left join Matches on Players.id = Matches.winner_id
	GROUP BY Players.id
	ORDER BY wins DESC;


-- Create a view which shows how many losses each player has
CREATE VIEW Losses AS 
	SELECT Players.id AS id, COUNT(Matches.winner_id) AS losses
	FROM Players left join Matches on Players.id = Matches.loser_id
	GROUP BY Players.id
	ORDER BY losses DESC;

-- Create a view of total games played for each player
CREATE VIEW TotalGames AS
	SELECT Wins.id, Wins.wins + Losses.losses AS matches
	FROM Wins, Losses
	WHERE Wins.id = Losses.id 
	ORDER BY matches DESC;