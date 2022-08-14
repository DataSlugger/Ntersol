﻿DROP TABLE IF EXISTS stage_mlbscores;

CREATE TABLE stage_mlbscores (
  gamePk INT,
  link VARCHAR,
  gameType VARCHAR,
  season INT,
  gameDate TIMESTAMP,
  officialDate DATE,
  isTie VARCHAR,
  gameNumber INTEGER,
  publicFacing VARCHAR,
  DoubleHeader VARCHAR,
  gameDayType VARCHAR,
  tiebreaker VARCHAR,
  calendarEventID VARCHAR,
  seasonDisplay VARCHAR,
  dayNight VARCHAR,
  scheduledInnings VARCHAR,
  reverseHomeAwayStatus VARCHAR,
  inningBreakLength VARCHAR,
  gamesInSeries VARCHAR,
  seriesGameNumber INTEGER,
  seriesDescription VARCHAR,
  recordSource VARCHAR,
  ifNecessary VARCHAR,
  ifNecessaryDescription VARCHAR,
  status_abstractGameState VARCHAR,
  status_codedGameState VARCHAR,
  status_detailedState VARCHAR,
  status_statusCode VARCHAR,
  status_startTimeTBD VARCHAR,
  status_abstractGameCode VARCHAR,
  teams_away_leagueRecord_wins VARCHAR,
  teams_away_leagueRecord_losses VARCHAR,
  teams_away_leagueRecord_pct VARCHAR,
  teams_away_score VARCHAR,
  teams_away_team_id VARCHAR,
  teams_away_team_name VARCHAR,
  teams_away_team_link VARCHAR,
  teams_away_isWinner VARCHAR,
  teams_away_splitSquad VARCHAR,
  teams_away_seriesNumber VARCHAR,
  teams_home_leagueRecord_wins VARCHAR,
  teams_home_leagueRecord_losses VARCHAR,
  teams_home_leagueRecord_pct VARCHAR,
  teams_home_score VARCHAR,
  teams_home_team_id VARCHAR,
  teams_home_team_name VARCHAR,
  teams_home_team_link VARCHAR,
  teams_home_isWinner VARCHAR,
  teams_home_splitSquad VARCHAR,
  teams_home_seriesNumber VARCHAR,
  venue_id VARCHAR,
  venue_name VARCHAR,
  venue_link VARCHAR,
  content_link VARCHAR,
  rescheduledFrom VARCHAR,
  rescheduledFromDate VARCHAR,
  description VARCHAR,
  status_reason VARCHAR 
)