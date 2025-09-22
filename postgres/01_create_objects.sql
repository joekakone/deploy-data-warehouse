--- SCHEMA ---
--create database football_db;

-- Select football_db;

--create schema foot;


--------------------------------------------------------------------------------------------------------------
--- TABLES ---
--------------------------------------------------------------------------------------------------------------


-- Table representing football stadiums
drop table if exists foot.stadiums;
create table foot.stadiums (
    id INTEGER,    -- Unique id for each stadium
    name TEXT NOT NULL,    -- Stadium name
    city TEXT NOT NULL,    -- City location of the stadium
    capacity INTEGER NOT NULL,    -- Max seating capacity of the stadium
    PRIMARY KEY (id)    -- Primary key
);

-- Table representing football teams
drop table if exists foot.teams;
create table foot.teams (
    id INTEGER,    -- Unique id for each team
    name TEXT NOT NULL,    -- Team name
    city TEXT NOT NULL,    -- City where the team is based
    stadium_id INTEGER,    -- Stadium assigned to the team (can be NULL if team has no staium)
    PRIMARY KEY (id),    -- Primary key
    FOREIGN KEY (stadium_id) REFERENCES foot.stadiums(id) ON DELETE SET NULL    -- Foreign key to stadium id
);

-- Table representing football players
drop table if exists foot.matches;
create table foot.players (
    id INTEGER,    -- Unique id for each player
    name TEXT NOT NULL,    -- Players full name
    position TEXT NOT NULL CHECK(position IN ('CF', 'LW', 'SS', 'RW', 'AM', 'LM', 'CM', 'RM',
                                                  'LWB', 'DM', 'RWB', 'LB', 'CB', 'RB', 'SW', 'GK')),
                                                  -- Players position on the field
    team_id INTEGER NOT NULL,    -- Team id where player belongs to
    PRIMARY KEY (id),    -- Primary key
    FOREIGN KEY (team_id) REFERENCES foot.teams(id) ON DELETE CASCADE    -- Foreign key to team id
);


-- Table representing match details
drop table if exists foot.matches;
create table foot.matches (
    id INTEGER,    -- Unique id for each match
    match_date DATE NOT NULL,    -- Match date
    stadium_id INTEGER NOT NULL,    -- Stadium id where the match is played
    home_team_id INTEGER NOT NULL,    -- Home team id in the match
    away_team_id INTEGER NOT NULL,    -- Away team id in the match
    home_score INTEGER DEFAULT 0,    -- Home team goals score
    away_score INTEGER DEFAULT 0,    -- Away team goals score
    PRIMARY KEY (id),    -- Primary key
    FOREIGN KEY (stadium_id) REFERENCES foot.stadiums(id) ON DELETE CASCADE,    -- Foreign key to stadium id
    FOREIGN KEY (home_team_id) REFERENCES foot.teams(id) ON DELETE CASCADE,    -- Foreign key to team id
    FOREIGN KEY (away_team_id) REFERENCES foot.teams(id) ON DELETE CASCADE    -- Foreign key to team id
);


-- Table representing goal statistics
drop table if exists foot.goals;
create table foot.goals (
    id INTEGER,    -- Unique id for each goal
    match_id INTEGER NOT NULL,    -- Match id in which goal was scored
    player_id INTEGER NOT NULL,    -- Player id who scored the goal
    minute INTEGER NOT NULL CHECK(minute BETWEEN 1 AND 120),    -- Minute in which goal was scored
    PRIMARY KEY (id),    -- Primary key
    FOREIGN KEY (match_id) REFERENCES foot.matches(id) ON DELETE CASCADE,    -- Foreign key to match id
    FOREIGN KEY (player_id) REFERENCES foot.players(id) ON DELETE CASCADE    -- Foreign key to player id
);


-- Table representing cards given during matches
drop table if exists foot.cards;
create table foot.cards (
    id INTEGER,    -- Unique id for each card
    match_id INTEGER NOT NULL,    -- Match id in which card was given
    player_id INTEGER NOT NULL,    -- Player id who received the card
    card_type TEXT CHECK(card_type IN ('red', 'yellow')),    -- Type of the card (red or yellow)
    minute INTEGER NOT NULL CHECK(minute BETWEEN 1 AND 120),    -- Minute in which card was given
    PRIMARY KEY (id),    -- Primary key
    FOREIGN KEY (match_id) REFERENCES foot.matches(id) ON DELETE CASCADE,    -- Foreign key to match id
    FOREIGN KEY (player_id) REFERENCES foot.players(id) ON DELETE CASCADE    -- Foreign key to player id
);

--------------------------------------------------------------------------------------------------------------
--- INDEXES ---
--------------------------------------------------------------------------------------------------------------


-- Index for teams
CREATE INDEX  index_teams_stadium_id
ON foot.teams (stadium_id);


-- Index for players
CREATE INDEX  index_players_team_id
ON foot.players (team_id);


-- Indexes for matches
CREATE INDEX  index_matches_stadium_id
ON foot.matches (stadium_id);

CREATE INDEX  index_matches_home_team_id
ON foot.matches (home_team_id);

CREATE INDEX  index_matches_away_team_id
ON foot.matches (away_team_id);

CREATE INDEX  index_matches_match_date
ON foot.matches (match_date);


-- Indexes for goals
CREATE INDEX  index_goals_match_id
ON foot.goals (match_id);

CREATE INDEX  index_goals_player_id
ON foot.goals (player_id);

CREATE INDEX  index_goals_minute
ON foot.goals (minute);


-- Indexes for cards
CREATE INDEX  index_cards_match_id
ON foot.cards (match_id);

CREATE INDEX  index_cards_player_id
ON foot.cards (player_id);

CREATE INDEX  index_cards_card_type
ON foot.cards (card_type);

CREATE INDEX  index_cards_minute
ON foot.cards (minute);


--------------------------------------------------------------------------------------------------------------
--- VIEWS ---
--------------------------------------------------------------------------------------------------------------


-- This view provides the top 10 players who have scored the most goals
drop view if exists foot.top_scorers;
create or replace view foot.top_scorers AS
SELECT
    players.name AS player,
    teams.name AS team,
    COUNT(goals.id) AS goals_count
from foot.players
join foot.teams ON players.team_id = teams.id
join foot.goals ON players.id = goals.player_id
GROUP BY players.name, teams.name
ORDER BY goals_count DESC
LIMIT 10;


-- This view shows all match results with the actual team names instead of IDs
drop view if exists foot.match_results;
create or replace view foot.match_results AS
SELECT
    matches.match_date,
    home.name AS home_team,
    away.name AS away_team,
    matches.home_score,
    matches.away_score
from foot.matches
join foot.teams AS home ON matches.home_team_id = home.id
join foot.teams AS away ON matches.away_team_id = away.id;


-- This view calculates key statistics for each team
drop view if exists foot.team_stats;
create or replace view foot.team_stats AS
SELECT
    teams.name AS team,
    COUNT(matches.id) AS total_matches,
    SUM(CASE WHEN matches.home_team_id = teams.id AND matches.home_score > matches.away_score THEN 1
             WHEN matches.away_team_id = teams.id AND matches.away_score > matches.home_score THEN 1
             ELSE 0 END) AS wins,
    SUM(CASE WHEN matches.home_team_id = teams.id THEN matches.home_score
             WHEN matches.away_team_id = teams.id THEN matches.away_score
             ELSE 0 END) AS total_goals
from foot.teams
LEFT join foot.matches ON
    teams.id = matches.home_team_id OR
    teams.id = matches.away_team_id
GROUP BY teams.id;


-- This view lists all players who have received yellow or red cards
drop view if exists foot.player_cards;
create or replace view foot.player_cards AS
SELECT
    players.name AS player,
    teams.name AS team,
    matches.match_date,
    cards.card_type,
    cards.minute
from foot.cards
join foot.players ON cards.player_id = players.id
join foot.teams ON players.team_id = teams.id
join foot.matches ON cards.match_id = matches.id;


-- This view provides a detailed list of goals scored in each match
drop view if exists foot.match_goals;
create or replace view foot.match_goals AS
SELECT
    matches.match_date,
    players.name AS player,
    teams.name AS team,
    goals.minute
from foot.goals
join foot.players ON goals.player_id = players.id
join foot.teams ON players.team_id = teams.id
join foot.matches ON goals.match_id = matches.id;

--------------------------------------------------------------------------------------------------------------

