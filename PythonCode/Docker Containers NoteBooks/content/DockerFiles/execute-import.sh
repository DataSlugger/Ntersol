#Waiting for SQL Server Startup
sleep 30s
#Running Setup Script 
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "C0nta!ners2021" -i /usr/sqlwork/setup.sql