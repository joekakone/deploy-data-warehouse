-- New script in postgres.
-- Date: Sep 22, 2025
-- Time: 4:57:10 AM


--------------------------------------------------------------------------------------------------------------

-- Check all created tables limited to 10 first entries
SELECT * from foot.teams LIMIT 10;
SELECT * from foot.players LIMIT 10;
SELECT * from foot.stadiums LIMIT 10;
SELECT * from foot.matches LIMIT 10;
SELECT * from foot.goals LIMIT 10;
SELECT * from foot.cards LIMIT 10;

-- Check rows count in created tables
SELECT COUNT(*) AS teams_count from foot.teams ;
SELECT COUNT(*) AS players_count from foot.players;
SELECT COUNT(*) AS stadiums_count from foot.stadiums;
SELECT COUNT(*) AS matches_count from foot.matches;
SELECT COUNT(*) AS goals_count from foot.goals;
SELECT COUNT(*) AS cards_count from foot.cards;

--------------------------------------------------------------------------------------------------------------

--- Queries from foot.very simple to more complex ---

--UPDATE cards
--SET card_type = 'red'
--WHERE player_id = (
--    SELECT id from foot.players WHERE name = 'Christian Martinez'
--);
--
--
--DELETE
--from foot.stadiums
--WHERE city = 'Maryland';
--
--
--INSERT INTO stadiums (id, name, city, capacity)
--VALUES ('31', 'Simpson, Larson and Hernandez Stadium', 'Maryland', '35378');


SELECT *
from foot.players;


SELECT
    name,
    city
from foot.teams;


SELECT
    name,
    capacity
from foot.stadiums
ORDER BY capacity DESC;


SELECT *
from foot.matches
ORDER BY match_date ASC;


SELECT
    name,
    city,
    capacity
from foot.stadiums
ORDER BY capacity DESC
LIMIT 10;


SELECT
    players.name AS player,
    teams.name AS team
from foot.players
join foot.teams ON players.team_id = teams.id;


SELECT
    matches.match_date,
    home.name AS home_team,
    away.name AS away_team,
    matches.home_score,
    matches.away_score
from foot.matches
join foot.teams AS home ON matches.home_team_id = home.id
join foot.teams AS away ON matches.away_team_id = away.id;


SELECT
    goals.id,
    matches.match_date,
    players.name AS player,
    teams.name AS team,
    goals.minute
from foot.goals
join foot.matches ON goals.match_id = matches.id
join foot.players ON goals.player_id = players.id
join foot.teams ON players.team_id = teams.id
ORDER BY
    matches.match_date DESC,
    goals.minute ASC;


SELECT
    cards.card_type,
    cards.minute,
    matches.match_date,
    stadiums.name AS stadium,
    players.name AS player,
    teams.name AS team
from foot.cards
join foot.matches ON cards.match_id = matches.id
join foot.stadiums ON matches.stadium_id = stadiums.id
join foot.players ON cards.player_id = players.id
join foot.teams ON players.team_id = teams.id;


SELECT
    players.name AS player,
    players.position,
    teams.name AS team
from foot.players
join foot.teams ON players.team_id = teams.id
ORDER BY
    teams.name ASC,
    players.position ASC;


SELECT
    teams.name AS team,
    COUNT(players.id) AS player_count
from foot.teams
join foot.players ON teams.id = players.team_id
GROUP BY teams.name
ORDER BY
    player_count DESC,
    team ASC;


SELECT
    teams.name,
    COUNT(matches.id) AS match_count
from foot.teams
join foot.matches ON
    teams.id = matches.home_team_id OR
    teams.id = matches.away_team_id
GROUP BY teams.name
ORDER BY match_count DESC
LIMIT 10;


SELECT
    players.name AS player,
    teams.name AS team,
    COUNT(goals.id) AS goals_count
from foot.players
join foot.teams ON players.team_id = teams.id
join foot.goals ON players.id = goals.player_id
GROUP BY players.id
ORDER BY goals_count DESC
LIMIT 10;


SELECT AVG(home_score + away_score) AS average_goals_per_match
from foot.matches;


SELECT
    teams.name AS team,
    COUNT(goals.id) AS goals_count
from foot.teams
join foot.players ON teams.id = players.team_id
join foot.goals ON players.id = goals.player_id
GROUP BY teams.id
ORDER BY goals_count DESC;


SELECT
    players.name AS player,
    teams.name AS team,
    matches.match_date
from foot.cards
join foot.players ON cards.player_id = players.id
join foot.teams ON players.team_id = teams.id
join foot.matches ON cards.match_id = matches.id
WHERE cards.card_type = 'red'
ORDER BY matches.match_date DESC;


SELECT
    matches.match_date,
    home.name AS home_team,
    away.name AS away_team,
    SUM(matches.home_score + matches.away_score) AS goals_total
from foot.matches
join foot.teams AS home ON matches.home_team_id = home.id
join foot.teams AS away ON matches.away_team_id = away.id
GROUP BY matches.id
ORDER BY goals_total DESC;

--------------------------------------------------------------------------------------------------------------

--- View queries ---

SELECT *
from foot.top_scorers;


SELECT *
from foot.match_results
ORDER BY match_date DESC;


SELECT *
from foot.team_stats ORDER BY wins DESC;


SELECT *
from foot.player_cards
WHERE card_type = 'red'
ORDER BY match_date DESC;


SELECT *
from foot.match_goals
ORDER BY
    match_date DESC,
    minute ASC;

--------------------------------------------------------------------------------------------------------------

--- Explain Query Plan ---

EXPLAIN QUERY PLAN
SELECT *
from foot.players;


EXPLAIN QUERY PLAN
SELECT
    name,
    city
from foot.teams;


EXPLAIN QUERY PLAN
SELECT
    name,
    capacity
from foot.stadiums
ORDER BY capacity DESC;


EXPLAIN QUERY PLAN
SELECT *
from foot.matches
ORDER BY match_date ASC;


EXPLAIN QUERY PLAN
SELECT
    name,
    city,
    capacity
from foot.stadiums
ORDER BY capacity DESC
LIMIT 10;


EXPLAIN QUERY PLAN
SELECT
    players.name AS player,
    teams.name AS team
from foot.players
join foot.teams ON players.team_id = teams.id;


EXPLAIN QUERY PLAN
SELECT
    matches.match_date,
    home.name AS home_team,
    away.name AS away_team,
    matches.home_score,
    matches.away_score
from foot.matches
join foot.teams AS home ON matches.home_team_id = home.id
join foot.teams AS away ON matches.away_team_id = away.id;


EXPLAIN QUERY PLAN
SELECT
    goals.id,
    matches.match_date,
    players.name AS player,
    teams.name AS team,
    goals.minute
from foot.goals
join foot.matches ON goals.match_id = matches.id
join foot.players ON goals.player_id = players.id
join foot.teams ON players.team_id = teams.id
ORDER BY
    matches.match_date DESC,
    goals.minute ASC;


EXPLAIN QUERY PLAN
SELECT
    cards.card_type,
    cards.minute,
    matches.match_date,
    stadiums.name AS stadium,
    players.name AS player,
    teams.name AS team
from foot.cards
join foot.matches ON cards.match_id = matches.id
join foot.stadiums ON matches.stadium_id = stadiums.id
join foot.players ON cards.player_id = players.id
join foot.teams ON players.team_id = teams.id;


EXPLAIN QUERY PLAN
SELECT
    players.name AS player,
    players.position,
    teams.name AS team
from foot.players
join foot.teams ON players.team_id = teams.id
ORDER BY
    teams.name ASC,
    players.position ASC;


EXPLAIN QUERY PLAN
SELECT
    teams.name AS team,
    COUNT(players.id) AS player_count
from foot.teams
join foot.players ON teams.id = players.team_id
GROUP BY teams.name
ORDER BY
    player_count DESC,
    team ASC;


EXPLAIN QUERY PLAN
SELECT
    teams.name,
    COUNT(matches.id) AS match_count
from foot.teams
join foot.matches ON
    teams.id = matches.home_team_id OR
    teams.id = matches.away_team_id
GROUP BY teams.name
ORDER BY match_count DESC
LIMIT 10;


EXPLAIN QUERY PLAN
SELECT
    players.name AS player,
    teams.name AS team,
    COUNT(goals.id) AS goals_count
from foot.players
join foot.teams ON players.team_id = teams.id
join foot.goals ON players.id = goals.player_id
GROUP BY players.id
ORDER BY goals_count DESC
LIMIT 10;


EXPLAIN QUERY PLAN
SELECT AVG(home_score + away_score) AS average_goals_per_match
from foot.matches;


EXPLAIN QUERY PLAN
SELECT
    teams.name AS team,
    COUNT(goals.id) AS goals_count
from foot.teams
join foot.players ON teams.id = players.team_id
join foot.goals ON players.id = goals.player_id
GROUP BY teams.id
ORDER BY goals_count DESC;


EXPLAIN QUERY PLAN
SELECT
    players.name AS player,
    teams.name AS team,
    matches.match_date
from foot.cards
join foot.players ON cards.player_id = players.id
join foot.teams ON players.team_id = teams.id
join foot.matches ON cards.match_id = matches.id
WHERE cards.card_type = 'red'
ORDER BY matches.match_date DESC;


EXPLAIN QUERY PLAN
SELECT
    matches.match_date,
    home.name AS home_team,
    away.name AS away_team,
    SUM(matches.home_score + matches.away_score) AS goals_total
from foot.matches
join foot.teams AS home ON matches.home_team_id = home.id
join foot.teams AS away ON matches.away_team_id = away.id
GROUP BY matches.id
ORDER BY goals_total DESC;

--------------------------------------------------------------------------------------------------------------
