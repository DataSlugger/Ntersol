param([String]$ServerName)

$ServerName = 'THEGODFATHER.ICTS.LOCAL'
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement") | Out-Null
 
#Create a new Managed computer object for the instance
$mc = new-object Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer $ServerName
 
$sqlagnt = $mc.Services['MSSQL$SQLSVR11']
 
Write-Host "Stopping SQL Server Agent"
 
#$sqlagnt.Stop()
start-sleep -s 10
#$sqlagnt.Start()
 
Write-Host "Started SQL Server Agent"



param([String]$ServerName)
$ServerName = 'THEGODFATHER.ICTS.LOCAL'
Get-Service -computer $ServerName 'MSSQL$SQLSVR11' | Restart-Service

#============================================================================
# ANOTHER VERSION
#============================================================================


Get-Service 'MSSQL$SQLSVR11'  | Where-object {$_.Status -eq "Running"}

param([String]$ServerName)

$ServerName = 'THEGODFATHER.ICTS.LOCAL'
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement") | Out-Null
 
#Create a new Managed computer object for the instance
$mc = new-object Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer $ServerName
 
$sqlagnt = $mc.Services['SQLSERVERAGENT']
 
Write-Host "Stopping SQL Server Agent"
 
$sqlagnt.Stop()
start-sleep -s 10
$sqlagnt.Start()
 
Write-Host "Started SQL Server Agent"

