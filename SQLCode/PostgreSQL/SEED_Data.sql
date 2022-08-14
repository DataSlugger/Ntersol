INSERT INTO countries (countryid, countryname, countryinitials, active, lastupdatedatetime) VALUES (1,'UNITED STATES OF AMERICA','USA',TRUE,NOW());

INSERT INTO leagues (leagueid, leaguename, leagueabreviation, leaguecountryid, descriptions, active) VALUES (1,'MAJOR LEAGUE BASEBALL','MLB',1,'MAJOR LEAGUE BASEBALL OF UNITED STATES OF AMERICA',TRUE);

INSERT INTO conference_league (conferenceid, leagueid, conference_name, active, active_fromdate, lastchangedetected)
  VALUES (1, 1, 'AMERICAN LEAGUE', TRUE, NOW(), NOW());
INSERT INTO conference_league (conferenceid, leagueid, conference_name, active, active_fromdate, lastchangedetected)
  VALUES (2, 1, 'NATIONAL LEAGUE', TRUE, NOW(), NOW());

  INSERT INTO teams (teamid, teamname, teamleagueid, teamsportid, active, lastupdatedate) VALUES (0,NULL,0,0,FALSE,'');

  SELECT DISTINCT
    m.teams_away_team_id,
    m.teams_away_team_name
  FROM mlbscoresgames m
  UNION ALL
  SELECT DISTINCT
    m.teams_home_team_id,
    m.teams_home_team_name
  FROM mlbscoresgames m;

INSERT INTO teams (teamid, teamname, teamleagueid, teamsportid, active, lastupdatedate)
SELECT
  119,
  'Los Angeles Dodgers',
  2,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  116,
  'Detroit Tigers',
  1,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  141,
  'Toronto Blue Jays',
  1,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  112,
  'Chicago Cubs',
  2,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  113,
  'Cincinnati Reds',
  2,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  115,
  'Colorado Rockies',
  2,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  111,
  'Boston Red Sox',
  1,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  109,
  'Arizona Diamondbacks',
  2,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  143,
  'Philadelphia Phillies',
  2,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  136,
  'Seattle Mariners',
  1,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  118,
  'Kansas City Royals',
  1,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  121,
  'New York Mets',
  2,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  158,
  'Milwaukee Brewers',
  2,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  133,
  'Oakland Athletics',
  1,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  110,
  'Baltimore Orioles',
  1,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  108,
  'Los Angeles Angels',
  1,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  135,
  'San Diego Padres',
  2,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  145,
  'Chicago White Sox',
  1,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  117,
  'Houston Astros',
  1,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  146,
  'Miami Marlins',
  2,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  140,
  'Texas Rangers',
  1,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  137,
  'San Francisco Giants',
  2,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  147,
  'New York Yankees',
  1,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  138,
  'St. Louis Cardinals',
  2,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  139,
  'Tampa Bay Rays',
  1,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  114,
  'Cleveland Guardians',
  1,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  120,
  'Washington Nationals',
  2,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  144,
  'Atlanta Braves',
  2,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  142,
  'Minnesota Twins',
  1,
  1,
  TRUE,
  NOW()
UNION ALL

SELECT
  134,
  'Pittsburgh Pirates',
  2,
  1,
  TRUE,
  NOW();

INSERT INTO stadiums (stadiumid, stadiumname, stadiumleagueid, stadiumdescription, stadiumcountryid, active, lastupdatedate)
SELECT
  680,
  'T-Mobile Park',
  1,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  2680,
  'Petco Park',
  2,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  2394,
  'Comerica Park',
  1,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  15,
  'Chase Field',
  2,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  2889,
  'Busch Stadium',
  2,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  4,
  'Guaranteed Rate Field',
  1,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  7,
  'Kauffman Stadium',
  1,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  10,
  'Oakland Coliseum',
  1,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  5325,
  'Globe Life Field',
  1,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  17,
  'Wrigley Field',
  2,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  2602,
  'Great American Ball Park',
  2,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  3313,
  'Yankee Stadium',
  1,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  2681,
  'Citizens Bank Park',
  2,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  3312,
  'Target Field',
  1,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  19,
  'Coors Field',
  2,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  31,
  'PNC Park',
  2,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  2,
  'Oriole Park at Camden Yards',
  1,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  3,
  'Fenway Park',
  1,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  4169,
  'loanDepot park',
  2,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  5,
  'Progressive Field',
  1,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  3309,
  'Nationals Park',
  2,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  22,
  'Dodger Stadium',
  2,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  12,
  'Tropicana Field',
  1,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  2392,
  'Minute Maid Park',
  1,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  2395,
  'Oracle Park',
  2,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  1,
  'Angel Stadium',
  1,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  4705,
  'Truist Park',
  2,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  32,
  'American Family Field',
  2,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  3289,
  'Citi Field',
  2,
  ' ',
  1,
  TRUE,
  NOW()
UNION ALL
SELECT
  14,
  'Rogers Centre',
  1,
  ' ',
  1,
  TRUE,
  NOW();