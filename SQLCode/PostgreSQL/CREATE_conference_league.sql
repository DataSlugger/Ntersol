DROP TABLE IF EXISTS conference_league;

CREATE TABLE conference_league (
  conferenceID INT NOT NULL,
  leagueID INT NOT NULL,
  conference_name VARCHAR(50) NOT NULL,
  active BOOLEAN NOT NULL,
  active_fromdate DATE NOT NULL,
  lastchangedetected TIMESTAMP NULL
);