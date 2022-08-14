CREATE OR REPLACE VIEW vwMLBCurrentDayGames
AS
SELECT
  m.gametype,
  m.season,
  TIMEZONE('America/Chicago', m.gamedate :: TIMESTAMPTZ) AS "gameDateTime",
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
  CAST(m.teams_away_score AS DOUBLE PRECISION) AS teams_away_score,
  m.teams_away_iswinner,
  m.teams_home_team_name,
  m.teams_home_leaguerecord_wins,
  m.teams_home_leaguerecord_losses,
  m.teams_home_leaguerecord_pct,
  CAST(m.teams_home_score AS DOUBLE PRECISION) AS teams_home_score,
  m.teams_home_iswinner,
  m.venue_name,
  c.conference_name AS "PlayingON"
FROM mlbscoresgames m
  INNER JOIN stadiums s
    ON s.stadiumid = CAST(m.venue_id AS INT)
  INNER JOIN conference_league c
    ON c.conferenceid = s.stadiumleagueid
WHERE m.officialdate = (NOW() AT TIME ZONE 'America/Chicago') :: DATE
--(CURRENT_DATE at TIME ZONE 'CST')::DATE
ORDER BY "gameDateTime" DESC