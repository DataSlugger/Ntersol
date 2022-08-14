from email.encoders import encode_noop
from xmlrpc.client import APPLICATION_ERROR
import requests
import json
import pandas as pd
from datetime import date, datetime, timedelta
from pathlib import Path
#from pandas.json_normalize import json_normalize

# Version 01

#ApiURL = "http://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard"

#response = requests.get(url = ApiURL)

#APIData = response.json()
# with open('ESPNAPIsMLBScoreBoard.json', 'w') as json_file:
#    json.dump(APIData, json_file)

# print(APIData)

# Version 02
# CurrentDate
NextDay_Date = date.today()
# Next Date
#NextDay_Date = date.today() - timedelta(days=1)

# DatetoProcess = (date.today() + date.)

strToday = str(NextDay_Date.strftime('%Y-%m-%d'))
# "https://statsapi.mlb.com/api/v1/schedule?sportId=1&date=2022-07-07"
ApiURL = "https://statsapi.mlb.com/api/v1/schedule?sportId=1&date="+strToday

response = requests.get(url=ApiURL)

APIData = response.json()
pd.json_normalize(APIData['dates'], sep="_")
track_resp = APIData.keys()
print(track_resp)
print(pd.json_normalize(APIData['dates'], record_path=['games'], sep="_"))

df = pd.json_normalize(APIData['dates'], record_path=['games'], sep="_")

file_path = 'C:\\Users\\jmont\\source\\repos\\Github\\PythonCode\\Results\\df_results_'+strToday+'.csv'
csv_file = Path(file_path)
csv_file.touch(exist_ok=True)

df.to_csv(csv_file, sep='\t', encoding='utf-8')

# with open('ESPNAPIsMLBScoreBoard.json', 'w') as json_file:
#    json.dump(APIData, json_file)

# print(APIData)
