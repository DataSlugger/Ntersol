from email.encoders import encode_noop
from xmlrpc.client import APPLICATION_ERROR
import requests
import json
import pandas as pd
import numpy as np
import sqlalchemy as db
import psycopg2
import psycopg2.extras as extras
from datetime import date, datetime, timedelta
from pathlib import Path
import os
import time
from dotenv import load_dotenv
#from pandas.json_normalize import json_normalize

os.environ['TZ'] = 'America/Chicago'
if os.name != 'nt':
    time.tzset()

load_dotenv()

POST_DATABASENAME = os.environ.get('POSTGRESQL_DATABASE')
POST_SERVERURL = os.environ.get('POSTGRESQL_SERVER')
POST_DBUSER = os.environ.get('POSTGRESQL_USER')
POST_DBPASS = os.environ.get('POSTGRESQL_SECRET')
POST_SERVERPORT = os.environ.get('POSTGRESQL_SERVER_PORT')


def create_db_engine(connString):

    db_engine = db.create_engine(connString)
    conn = db_engine.connect()

    return conn


def create_stage_table(dbEngine, tblName, gameReschedules=False):
    print("Creating Stage Table " + tblName)
    sql_drop_stmt = "DROP TABLE IF EXISTS " + tblName
    try:
        cursor = dbEngine.cursor()
        cursor.execute(sql_drop_stmt)
        # dbEngine.execute(sql_drop_stmt)
        dbEngine.commit()

        if gameReschedules == True:
            sql_createtbl_stamt = "CREATE TABLE " + tblName + "(" + "gamePk INT, link VARCHAR,  gameType VARCHAR, season INT,   gameDate TIMESTAMP,  officialDate DATE, \
                isTie VARCHAR, gameNumber INTEGER, publicFacing VARCHAR, DoubleHeader VARCHAR, gameDayType VARCHAR, tiebreaker VARCHAR, calendarEventID VARCHAR, seasonDisplay VARCHAR, \
                dayNight VARCHAR, scheduledInnings VARCHAR, reverseHomeAwayStatus VARCHAR, inningBreakLength VARCHAR, gamesInSeries VARCHAR, seriesGameNumber INTEGER, \
                seriesDescription VARCHAR, recordSource VARCHAR, ifNecessary VARCHAR, ifNecessaryDescription VARCHAR, status_abstractGameState VARCHAR, status_codedGameState VARCHAR, \
                status_detailedState VARCHAR, status_statusCode VARCHAR, status_startTimeTBD VARCHAR, status_abstractGameCode VARCHAR,  teams_away_leagueRecord_wins VARCHAR, \
                teams_away_leagueRecord_losses VARCHAR, teams_away_leagueRecord_pct VARCHAR, teams_away_score VARCHAR, teams_away_team_id VARCHAR, teams_away_team_name VARCHAR, \
                teams_away_team_link VARCHAR, teams_away_isWinner VARCHAR, teams_away_splitSquad VARCHAR, teams_away_seriesNumber VARCHAR, teams_home_leagueRecord_wins VARCHAR, \
                teams_home_leagueRecord_losses VARCHAR, teams_home_leagueRecord_pct VARCHAR, teams_home_score VARCHAR, teams_home_team_id VARCHAR, teams_home_team_name VARCHAR, \
                teams_home_team_link VARCHAR, teams_home_isWinner VARCHAR, teams_home_splitSquad VARCHAR, teams_home_seriesNumber VARCHAR, venue_id VARCHAR, venue_name VARCHAR, \
                venue_link VARCHAR, content_link VARCHAR, rescheduledFrom VARCHAR, rescheduledFromDate VARCHAR, description VARCHAR)"
        else:
            sql_createtbl_stamt = "CREATE TABLE " + tblName + "(" + "gamePk INT, link VARCHAR,  gameType VARCHAR, season INT,   gameDate TIMESTAMP,  officialDate DATE, \
                isTie VARCHAR, gameNumber INTEGER, publicFacing VARCHAR, DoubleHeader VARCHAR, gameDayType VARCHAR, tiebreaker VARCHAR, calendarEventID VARCHAR, \
                description VARCHAR,  seasonDisplay VARCHAR, \
                dayNight VARCHAR, scheduledInnings VARCHAR, reverseHomeAwayStatus VARCHAR, inningBreakLength VARCHAR, gamesInSeries VARCHAR, seriesGameNumber INTEGER, \
                seriesDescription VARCHAR, recordSource VARCHAR, ifNecessary VARCHAR, ifNecessaryDescription VARCHAR, status_abstractGameState VARCHAR, status_codedGameState VARCHAR, \
                status_detailedState VARCHAR, status_statusCode VARCHAR, status_startTimeTBD VARCHAR, status_abstractGameCode VARCHAR,  teams_away_leagueRecord_wins VARCHAR, \
                teams_away_leagueRecord_losses VARCHAR, teams_away_leagueRecord_pct VARCHAR, teams_away_score VARCHAR, teams_away_team_id VARCHAR, teams_away_team_name VARCHAR, \
                teams_away_team_link VARCHAR, teams_away_isWinner VARCHAR, teams_away_splitSquad VARCHAR, teams_away_seriesNumber VARCHAR, teams_home_leagueRecord_wins VARCHAR, \
                teams_home_leagueRecord_losses VARCHAR, teams_home_leagueRecord_pct VARCHAR, teams_home_score VARCHAR, teams_home_team_id VARCHAR, teams_home_team_name VARCHAR, \
                teams_home_team_link VARCHAR, teams_home_isWinner VARCHAR, teams_home_splitSquad VARCHAR, teams_home_seriesNumber VARCHAR, venue_id VARCHAR, venue_name VARCHAR, \
                venue_link VARCHAR, content_link VARCHAR, rescheduleDate VARCHAR, rescheduleGameDate VARCHAR, status_reason VARCHAR)"

        # dbEngine.execute(sql_createtbl_stamt)
        cursor.execute(sql_createtbl_stamt)
        dbEngine.commit()
        cursor.close()
    except(Exception, psycopg2.DatabaseError) as error:
        print("Error: %s" % error)


def write_data_to_database(dbEngine, dtFrame, dfIndexFlag, tblName, existsFlag):
    print("Starting to Insert Data")
    dtFrame.to_sql(name=tblName, con=dbEngine,
                   if_exists=existsFlag, index=dfIndexFlag)
    dbEngine.close()


def save_to_database(dbEngine, dtFrame, dfIndexFlag, tblName, existsFlag):
    print("Inserting Data")
    cursor = dbEngine.cursor()
    insert_cmd = "INSERT INTO " + tblName + " (gamePk, link,  gameType, season,   gameDate,  officeDate, isTie, gameNumber, publicFacing, DoubleHeader, gameDayType, tieBraker, \
    CalendayEventID, seasonDisplay, dayNight, scheduleInnings, reverseHomeAwayStatus, inningBreakLenght, gameinSeries, seriesGameNumber, seriesDescription, RecordsSource, \
    ifNecessary, ifNecessaryDescription, status_abstractGameState, status_codeGameState, status_detailedState, status_statusCode, status_startTimeTBD, status_abstractGameCode, \
    teams_away_leagueRecord_wins, teams_away_leagueRecord_losses, teams_away_leagueRecord_pct, teams_away_score, teams_away_team_id, teams_away_team_name, \
    teams_away_team_link, teams_away_isWinner, teams_away_splitSquad, teams_away_seriesNumber, teams_home_leagueRecord_wins, teams_home_leagueRecord_losses, teams_home_leagueRecord_pct, teams_home_score,\
    teams_home_team_id, teams_home_team_name, teams_home_team_link, teams_home_isWinner, teams_home_splitSquad, teams_home_seriesNumber, venue_id, venue_name, venue_link, content_link) \
    VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "

    for index, row in dtFrame.iterrows():
        cursor.execute(insert_cmd)
    dbEngine.commit()
    cursor.close()


def save_tuple_to_database(dbEnginePD, dtFrame, tblName, columns_list):
    print("Inserting DataFrame Data")

    tuple_values = [tuple(x) for x in dtFrame.to_numpy()]
    cursor = dbEnginePD.cursor()
    insert_query = "INSERT INTO %s(%s) VALUES %%s" % (tblName, columns_list)
    try:
        extras.execute_values(cursor, insert_query, tuple_values)
        dbEnginePD.commit()
    except(Exception, psycopg2.DatabaseError) as error:
        print("Error: %s" % error)
        dbEnginePD.rollback()
        cursor.close()
        return 1
    print("The DataFrame is inserted")
    cursor.close()


def merge_mlbscores(conn):
    print("Merging MLB Scores")

    try:
        cursor = conn.cursor()
        cursor.execute("CALL etl_merge_mlbscores();")
        conn.commit()
    except(Exception, psycopg2.DatabaseError) as error:
        print("Error: %s" % error)
        conn.rollback()
        cursor.close()
        return 1
    print("MLB Scores Merged")
    cursor.close()


if __name__ == "__main__":
    #conn_string = 'postgresql://root:pass@mlbstats.chsp0fqkdhek.us-east-2.rds.amazonaws.com:5432/leaguescores'
    tbl_name = 'stage_mlbscores'
    record_onconflict = 'fail'
    
    psy_conn = psycopg2.connect(database=POST_DATABASENAME, user=POST_DBUSER,
                                password=POST_DBPASS, host=POST_SERVERURL, port=POST_SERVERPORT)

    # Getting Dates to Work
    TodayDay_Date = date.today()
    PreviousDay_date = (date.today() - timedelta(days=1))
    DatesRange = ([PreviousDay_date, TodayDay_Date])
    # Next Date
    #NextDay_Date = date.today() + timedelta(days=1)
    for NextDay_Date in DatesRange:
        # Building DB Connection
        #dbEngineConn = create_db_engine(conn_string)

        strToday = str(NextDay_Date.strftime('%Y-%m-%d'))
        # "https://statsapi.mlb.com/api/v1/schedule?sportId=1&date=2022-07-07"
        ApiURL = "https://statsapi.mlb.com/api/v1/schedule?sportId=1&date="+strToday

        response = requests.get(url=ApiURL)

        APIData = response.json()
        pd.json_normalize(APIData['dates'], sep="_")
        track_resp = APIData.keys()
        # print(track_resp)
        # print(pd.json_normalize(APIData['dates'],record_path=['games'],sep="_"))

        df = pd.json_normalize(
            APIData['dates'], record_path=['games'], sep="_")
        cols = ','.join(list(df.columns))

        if cols == '':
            continue

        # checking if Reschule games exist into the Dataset
        gamesRescheduleFlag = False
        # dbEngineConn
        if 'rescheduledFromDate' in df.columns:
            gamesRescheduleFlag = True
            create_stage_table(psy_conn, tbl_name, gamesRescheduleFlag)
        else:
            create_stage_table(psy_conn, tbl_name)

        # print(df.values.tolist())
        save_tuple_to_database(psy_conn, df, tbl_name, cols)
        merge_mlbscores(psy_conn)
