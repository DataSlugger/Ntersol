﻿CREATE OR REPLACE VIEW vwmlbcurrentdaygames
AS
SELECT
  m.gametype,
  m.season,
  TIMEZONE('America/Chicago' :: TEXT, (m.gamedate) :: TIMESTAMP WITH TIME ZONE) AS "gameDateTime",
  m.officialdate,
  m.istie,
  m.publicfacing,
  m.gamesinseries,
  m.doubleheader,
  m.seasondisplay,
  m.daynight,
  m.seriesdescription,
  m.status_abstractgamestate,
  m.status_codedgamestate,
  m.status_detailedstate,
  m.status_statuscode,
  m.teams_away_team_name,
  m.teams_away_leaguerecord_wins,
  m.teams_away_leaguerecord_losses,
  m.teams_away_leaguerecord_pct,
  (m.teams_away_score) :: DOUBLE PRECISION AS teams_away_score,
  m.teams_away_iswinner,
  m.teams_home_team_name,
  m.teams_home_leaguerecord_wins,
  m.teams_home_leaguerecord_losses,
  m.teams_home_leaguerecord_pct,
  (m.teams_home_score) :: DOUBLE PRECISION AS teams_home_score,
  m.teams_home_iswinner,
  m.venue_name
FROM mlbscoresgames m
WHERE (m.officialdate = TIMEZONE('America/Chicago', CURRENT_DATE :: TIMESTAMPTZ)::DATE)
ORDER BY (TIMEZONE('America/Chicago' :: TEXT, (m.officialdate) :: TIMESTAMP WITH TIME ZONE)) DESC;

