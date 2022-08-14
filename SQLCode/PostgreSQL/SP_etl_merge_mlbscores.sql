CREATE OR REPLACE PROCEDURE etl_merge_mlbscores
(
)
LANGUAGE PLPGSQL
AS $$
  begin
    insert into public.mlbscoresgames
      (
       gamePk
      ,link 
      ,gameType 
      ,season 
      ,gameDate 
      ,officialDate 
      ,isTie 
      ,gameNumber 
      ,publicFacing 
      ,DoubleHeader 
      ,gameDayType 
      ,tiebreaker 
      ,calendarEventID 
      ,seasonDisplay 
      ,dayNight 
      ,scheduledInnings 
      ,reverseHomeAwayStatus 
      ,inningBreakLength 
      ,gamesInSeries 
      ,seriesGameNumber 
      ,seriesDescription 
      ,recordSource 
      ,ifNecessary 
      ,ifNecessaryDescription 
      ,status_abstractGameState 
      ,status_codedGameState 
      ,status_detailedState 
      ,status_statusCode 
      ,status_startTimeTBD 
      ,status_abstractGameCode 
      ,teams_away_leagueRecord_wins 
      ,teams_away_leagueRecord_losses 
      ,teams_away_leagueRecord_pct 
      ,teams_away_score 
      ,teams_away_team_id 
      ,teams_away_team_name 
      ,teams_away_team_link 
      ,teams_away_isWinner 
      ,teams_away_splitSquad 
      ,teams_away_seriesNumber 
      ,teams_home_leagueRecord_wins 
      ,teams_home_leagueRecord_losses
      ,teams_home_leagueRecord_pct 
      ,teams_home_score 
      ,teams_home_team_id 
      ,teams_home_team_name 
      ,teams_home_team_link 
      ,teams_home_isWinner 
      ,teams_home_splitSquad 
      ,teams_home_seriesNumber 
      ,venue_id 
      ,venue_name 
      ,venue_link 
      ,content_link
      )
    SELECT 
       gamePk
      ,link 
      ,gameType
      ,season 
      ,gameDate
      ,officialDate
      ,isTie
      ,gameNumber
      ,publicFacing
      ,doubleHeader
      ,gamedayType
      ,tiebreaker
      ,calendarEventID
      ,seasonDisplay
      ,dayNight
      ,scheduledInnings
      ,reverseHomeAwayStatus
      ,CASE WHEN inningBreakLength = 'NaN' THEN 0 WHEN inningBreakLength IS NULL THEN 0 ELSE CAST(inningBreakLength AS DOUBLE PRECISION) END AS "inningBreakLength"      
      ,gamesInSeries
      ,seriesGameNumber
      ,seriesDescription
      ,recordSource
      ,ifNecessary
      ,ifNecessaryDescription
      ,status_abstractGameState
      ,status_codedGameState
      ,status_detailedState
      ,status_statusCode
      ,status_startTimeTBD
      ,status_abstractGameCode
      ,teams_away_leagueRecord_wins
      ,teams_away_leagueRecord_losses
      ,teams_away_leagueRecord_pct
      ,teams_away_score
      ,teams_away_team_id
      ,teams_away_team_name
      ,teams_away_team_link
      ,teams_away_isWinner
      ,teams_away_splitSquad
      ,teams_away_seriesNumber
      ,teams_home_leagueRecord_wins
      ,teams_home_leagueRecord_losses
      ,teams_home_leagueRecord_pct
      ,teams_home_score
      ,teams_home_team_id
      ,teams_home_team_name
      ,teams_home_team_link
      ,teams_home_isWinner
      ,teams_home_splitSquad
      ,teams_home_seriesNumber
      ,venue_id
      ,venue_name
      ,venue_link
      ,content_link
    FROM stage_mlbscores
    ON CONFLICT(gamePk, officialDate) DO
      UPDATE SET          
      link                           = EXCLUDED.link
      ,gameType = EXCLUDED.gameType
      ,season = EXCLUDED.season
      ,gameDate = EXCLUDED.gameDate      
      ,isTie = EXCLUDED.isTie
      ,gameNumber = EXCLUDED.gameNumber
      ,publicFacing = EXCLUDED.publicFacing
      ,DoubleHeader = EXCLUDED.DoubleHeader
      ,gameDayType = EXCLUDED.gameDayType
      ,tiebreaker = EXCLUDED.tiebreaker
      ,calendarEventID = EXCLUDED.calendarEventID
      ,seasonDisplay = EXCLUDED.seasonDisplay
      ,dayNight = EXCLUDED.dayNight
      ,scheduledInnings = EXCLUDED.scheduledInnings
      ,reverseHomeAwayStatus = EXCLUDED.reverseHomeAwayStatus        
      ,inningBreakLength = CAST(EXCLUDED.inningBreakLength AS DOUBLE PRECISION)
      ,gamesInSeries = EXCLUDED.gamesInSeries
      ,seriesGameNumber = EXCLUDED.seriesGameNumber
      ,seriesDescription = EXCLUDED.seriesDescription
      ,recordSource = EXCLUDED.recordSource
      ,ifNecessary = EXCLUDED.ifNecessary
      ,ifNecessaryDescription = EXCLUDED.ifNecessaryDescription
      ,status_abstractGameState = EXCLUDED.status_abstractGameState
      ,status_codedGameState = EXCLUDED.status_codedGameState
      ,status_detailedState = EXCLUDED.status_detailedState
      ,status_statusCode = EXCLUDED.status_statusCode
      ,status_startTimeTBD = EXCLUDED.status_startTimeTBD
      ,status_abstractGameCode = EXCLUDED.status_abstractGameCode
      ,teams_away_leagueRecord_wins = EXCLUDED.teams_away_leagueRecord_wins
      ,teams_away_leagueRecord_losses = EXCLUDED.teams_away_leagueRecord_losses
      ,teams_away_leagueRecord_pct = EXCLUDED.teams_away_leagueRecord_pct
      ,teams_away_score = EXCLUDED.teams_away_score
      ,teams_away_team_id = EXCLUDED.teams_away_team_id
      ,teams_away_team_name = EXCLUDED.teams_away_team_name
      ,teams_away_team_link = EXCLUDED.teams_away_team_link
      ,teams_away_isWinner = EXCLUDED.teams_away_isWinner
      ,teams_away_splitSquad = EXCLUDED.teams_away_splitSquad
      ,teams_away_seriesNumber = EXCLUDED.teams_away_seriesNumber
      ,teams_home_leagueRecord_wins = EXCLUDED.teams_home_leagueRecord_wins
      ,teams_home_leagueRecord_losses= EXCLUDED.teams_home_leagueRecord_losses
      ,teams_home_leagueRecord_pct = EXCLUDED.teams_home_leagueRecord_pct
      ,teams_home_score = EXCLUDED.teams_home_score
      ,teams_home_team_id = EXCLUDED.teams_home_team_id
      ,teams_home_team_name = EXCLUDED.teams_home_team_name
      ,teams_home_team_link = EXCLUDED.teams_home_team_link
      ,teams_home_isWinner = EXCLUDED.teams_home_isWinner
      ,teams_home_splitSquad = EXCLUDED.teams_home_splitSquad
      ,teams_home_seriesNumber = EXCLUDED.teams_home_seriesNumber
      ,venue_id = EXCLUDED.venue_id
      ,venue_name = EXCLUDED.venue_name
      ,venue_link = EXCLUDED.venue_link
      ,content_link = EXCLUDED.content_link;

  end;$$;