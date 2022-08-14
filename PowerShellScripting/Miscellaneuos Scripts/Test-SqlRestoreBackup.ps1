<#$srv = new-object Microsoft.SqlServer.Management.Smo.Server("(local)")
$res = new-object Microsoft.SqlServer.Management.Smo.Restore
$backup = new-object Microsoft.SqlServer.Management.Smo.Backup

$backup.Devices.AddDevice("C:\AdventureWorks2012Backup.bak", [Microsoft.SqlServer.Management.Smo.DeviceType]::File)
$backup.Database = "AdventureWorks2012"
$backup.Action = [Microsoft.SqlServer.Management.Smo.BackupActionType]::Database
$backup.Initialize = $TRUE
$backup.SqlBackup($srv)

$res.Devices.AddDevice("C:\AdventureWorks2012Backup.bak", [Microsoft.SqlServer.Management.Smo.DeviceType]::File)
$dt = $res.ReadBackupHeader($srv)

foreach ($r in $dt.Rows) {
    foreach ($c in $dt.Columns) {
        Write-Host $c "=" $r[$c]
    }
}#>
begin{
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null
}
process{
    function Get-SqlBackupStatusReport {
        param(
            [String]$ServerInstance
        )
        $srv = new-object Microsoft.SqlServer.Management.Smo.Server($ServerInstance)
        #$res = new-object Microsoft.SqlServer.Management.Smo.Restore
        #$backup = new-object Microsoft.SqlServer.Management.Smo.Backup
        $dbs = @()
        $databases = $srv.Databases

        foreach ($database in $databases |Where-Object {$_.Name -notin "master", "model", "tempdb", "msdb"}) {  
            $lastbackup
            $lastdifferential
            $DayswithoutBackup
            if ($database.LastBackupDate -eq "01/01/0001 00:00:00") {
                $lastbackup = "N/A"
            }
            else {
                $lastbackup = $database.LastBackupDate.ToString("MM/dd/yyyy HH:mm:ss")
            }
            if ($database.LastDifferentialBackupDate -eq "01/01/0001 00:00:00") {
                $lastdifferential = "N/A"
            }
            else {
                $lastdifferential = $database.LastDifferentialBackupDate.ToString("MM/dd/yyyy HH:mm:ss")
            }
            if ($database.LastBackupDate -eq "01/01/0001 00:00:00") {
                $DayswithoutBackup = "Never Backuped Up"
            }
            elseif ($database.LastDifferentialBackupDate -gt $database.LastBackupDate) {
                $DayswithoutBackup = ((Get-Date) - $database.LastDifferentialBackupDate).Days
            }
            else {
                $DayswithoutBackup = ((Get-Date) - $database.LastBackupDate).Days
            }

            #New-Object -TypeName PSObject -Property
            $db = [PSCustomObject] @{
        
                DBName               = $database.Name
                LastFull             = $lastbackup
                LastDifferential     = $lastdifferential
                DaysLastSyncedBackup = $DayswithoutBackup
            }
            $dbs += $db
        }
        $dbs.ForEach( {[PSCustomObject]$_}) | Format-Table -AutoSize
        #$dbs.ForEach( {[PSCustomObject]$_}) | ConvertTo-Html -Fragment -As Table
        $name = $srv.Name
        $htmloutput = $dbs.ForEach( {[PSCustomObject]$_}) | ConvertTo-Html -Title "Database Backup Status Report" -CssUri "C:\DBA\Table.css" -Body "<h1>Database Backup Status Report</h1>`n<h2> Instance Name: $name </h2>`n<h5>Updated: on $(Get-Date)</h5>"
        $htmloutput | Out-File "C:\DBA\testinghtml.html"
        $body = Get-Content C:\DBA\testinghtml.html -Raw
        #$recipients = "javier.montero@amphorainc.com","plo@amphorainc.com", "hyd_dba@amphorainc.com"
        $recipients = "javier.montero@amphorainc.com"
        Send-MailMessage -to $recipients -From "SymphonyServiceMonitor@amphorainc.com" -Subject "Database Backup Report $name" -Body $body -BodyAsHtml -SmtpServer "housp00" -Port 587
    }
    
   
        Get-SqlBackupStatusReport -ServerInstance "THEBEAST.icts.local\SQLSVR11"
        Get-SqlBackupStatusReport -ServerInstance "GODFATHER.icts.local\SQLSVR11"
   
    
}



