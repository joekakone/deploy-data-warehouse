-- New script in postgres.
-- Date: Sep 22, 2025
-- Time: 4:58:38 AM


drop view if exists foot.top_scorers;
drop view if exists foot.match_results;
drop view if exists foot.team_stats;
drop view if exists foot.player_cards;
drop view if exists foot.match_goals;


drop table if exists foot.goals;
drop table if exists foot.cards;
drop table if exists foot.matches;
drop table if exists foot.players;
drop table if exists foot.teams;
drop table if exists foot.stadiums;


drop index if exists index_teams_stadium_id;
drop index if exists index_players_team_id;
drop index if exists index_matches_stadium_id;
drop index if exists index_matches_home_team_id;
drop index if exists index_matches_away_team_id;
drop index if exists index_matches_match_date;
drop index if exists index_goals_match_id;
drop index if exists index_goals_player_id;
drop index if exists index_goals_minute;
drop index if exists index_cards_match_id;
drop index if exists index_cards_player_id;
drop index if exists index_cards_card_type;
drop index if exists index_cards_minute;


--drop schema if exists foot;


--drop database football_db;


-- VACUUM




