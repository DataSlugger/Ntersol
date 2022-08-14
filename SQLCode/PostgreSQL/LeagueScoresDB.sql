CREATE DATABASE leaguescores
WITH OWNER = root_jmontero;

CREATE TABLE Leagues (
  LeagueID INTEGER,
  LeagueName TEXT,
  LeagueAbreviation CHAR(10),
  LeagueCountryID INTEGER,
  Descriptions TEXT,
  Active BOOLEAN
);

CREATE TABLE Countries (
  CountryID INTEGER,
  CountryName TEXT,
  CountryInitials CHAR(4),
  Active BOOLEAN,
  LastUpdateDateTime DATE
);

CREATE TABLE Stadiums (
  StadiumID INTEGER,
  StadiumName TEXT,
  StadiumLeagueID INTEGER,
  StadiumDescription TEXT,
  StadiumCountryID INTEGER,
  Active BOOLEAN,
  LastUpdateDate DATE
);

CREATE TABLE Teams (
  TeamID INTEGER,
  TeamName TEXT NOT NULL,
  TeamLeagueID INTEGER,
  TeamSportID INTEGER,
  Active BOOLEAN,
  LastUpdateDate DATE
); --drop SEQUENCE default_MLBScores_ID

CREATE SEQUENCE
IF NOT EXISTS default_MLBScores_ID
  AS BIGINT
  INCREMENT BY 1
  START WITH 1;
/*
DROP TABLE IF EXISTS MLBScoresGames;

CREATE TABLE MLBScoresGames (
  MLBScoreRowID BIGINT NOT NULL DEFAULT NEXTVAL('default_MLBScores_ID'),
  gamePK INT,
  link TEXT,
  gameType TEXT,
  season TEXT,
  gameDate TIMESTAMP,
  officeDate DATE,
  isTie TEXT,
  gameNumber INTEGER,
  publicFacing TEXT,
  DoubleHeader TEXT,
  gameDayType TEXT,
  tieBraker TEXT,
  CalendayEventID TEXT,
  seasonDisplay TEXT,
  dayNight TEXT,
  scheduleInnings TEXT,
  reverseHomeAwayStatus TEXT,
  inningBreakLenght INTEGER,
  gameinSeries TEXT,
  seriesGameNumber INTEGER,
  seriesDescription TEXT,
  RecordsSource TEXT,
  ifNecessary TEXT,
  ifNecessaryDescription TEXT,
  status_abstractGameState TEXT,
  status_codeGameState TEXT,
  status_detailedState TEXT,
  status_statusCode TEXT,
  status_startTimeTBD TEXT,
  status_abstractGameCode TEXT,
  teams_away_leagueRecord_wins TEXT,
  teams_away_leagueRecord_losses TEXT,
  teams_away_leagueRecord_pct TEXT,
  teams_away_score TEXT,
  teams_away_team_id TEXT,
  teams_away_team_name TEXT,
  teams_away_team_link TEXT,
  teams_away_isWinner TEXT,
  teams_away_splitSquad TEXT,
  teams_away_seriesNumber TEXT,
  teams_home_leagueRecord_wins TEXT,
  teams_home_leagueRecord_losses TEXT,
  teams_home_leagueRecord_pct TEXT,
  teams_home_score TEXT,
  teams_home_team_id TEXT,
  teams_home_team_name TEXT,
  teams_home_team_link TEXT,
  teams_home_isWinner TEXT,
  teams_home_splitSquad TEXT,
  teams_home_seriesNumber TEXT,
  venue_id TEXT,
  venue_name TEXT,
  venue_link TEXT,
  content_link TEXT,
  PRIMARY KEY (
  gamePK, officeDate
  )
);
*/
DROP TABLE IF EXISTS mlbscoresgames;

CREATE TABLE mlbscoresgames (
  MLBScoreRowID bigint NOT NULL DEFAULT NEXTVAL('default_MLBScores_ID'),
  gamePk int,
  link varchar,
  gameType varchar,
  season int,
  gameDate timestamp,
  officialDate date,
  isTie varchar,
  gameNumber integer,
  publicFacing varchar,
  DoubleHeader varchar,
  gameDayType varchar,
  tiebreaker varchar,
  calendarEventID varchar,
  seasonDisplay varchar,
  dayNight varchar,
  scheduledInnings varchar,
  reverseHomeAwayStatus varchar,
  inningBreakLength integer,
  gamesInSeries varchar,
  seriesGameNumber integer,
  seriesDescription varchar,
  recordSource varchar,
  ifNecessary varchar,
  ifNecessaryDescription varchar,
  status_abstractGameState varchar,
  status_codedGameState varchar,
  status_detailedState varchar,
  status_statusCode varchar,
  status_startTimeTBD varchar,
  status_abstractGameCode varchar,
  teams_away_leagueRecord_wins varchar,
  teams_away_leagueRecord_losses varchar,
  teams_away_leagueRecord_pct varchar,
  teams_away_score varchar,
  teams_away_team_id varchar,
  teams_away_team_name varchar,
  teams_away_team_link varchar,
  teams_away_isWinner varchar,
  teams_away_splitSquad varchar,
  teams_away_seriesNumber varchar,
  teams_home_leagueRecord_wins varchar,
  teams_home_leagueRecord_losses varchar,
  teams_home_leagueRecord_pct varchar,
  teams_home_score varchar,
  teams_home_team_id varchar,
  teams_home_team_name varchar,
  teams_home_team_link varchar,
  teams_home_isWinner varchar,
  teams_home_splitSquad varchar,
  teams_home_seriesNumber varchar,
  venue_id varchar,
  venue_name varchar,
  venue_link varchar,
  content_link varchar,
  rescheduledFrom varchar,
  rescheduledFromDate varchar,
  description VARCHAR,
 PRIMARY KEY (
  gamePK, officialDate
  )
)