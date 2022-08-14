<#

.SYNOPSIS
	SCRIPT RESTORE SQL SERVER DATABASES
	NAME: AutoSync_Spk_and_SchemaCode.PS1	

.DESCRIPTION
    SCRIPT CREATES FOR RESTORE A SQL SERVER DATABASES, THIS SCRIPT IS NOT USEFUL FOR OTHER RDBMS
    THIS CODE IS PROVIDED "AS IS", WITH NO WARRANTIES.

.PARAMETER RestoreSqlDB    
    FUNCTION NAME THAT NEED TO BE CALLED FOR START THE RESTORATION PROCESS.

.PARAMETER ServerInstance
    REFERS TO SQL SERVER INSTANCE. YOU CAN SPECIFY USING INSTANCE NAME OR SERVER NAME PLUS PORT # (e.g. SERVERNAME\INSTANCENAME or SERVERNAME,PORT#)

.PARAMETER Authentication
    REFERS TO AUTHENTICATION METHOD USED TO ESTABLISHED CONNECTION TO SQL SERVER. THIS PARAMETER IS MANDATORY
    Authentication Allowed: "Windows Authentication" or "Sql Authentication"

.PARAMETER Login
    REFERS TO LOGIN ID TO CONNECT TO SQL SERVER USING SQL AUTHENTICATION METHOD, USER MUST BE PART OR HAVE PERMISSION TO RESTORE DBs OR MUST BE PART OF sysadmin.
    THIS PARAMETER IS NOR REQUIRED IF YOU ARE USING WINDOWS AUTHENTICATION METHOD

.PARAMETER Passwd
    REFERS TO USER PASSWORD USING SQL AUTHENTICATION METHOD.
    THIS PARAMETER IS NOR REQUIRED IF YOU ARE USING WINDOWS AUTHENTICATION METHOD

.PARAMETER Databasename
    REFERS TO DATABASE NAME THAT WANT TO RESTORE.
    THIS PARAMETER IS MANDATORY.

.PARAMETER Filespath
    REFERS TO WHERE THE DATABASE *.BAK or *.TRN FILES RESIDE ON SERVER PATHS OR NETWORK PATH AND THESE ARE ACCESSIBLE TO THE SQL SERVER.
    THIS PARAMETER IS MANDATORY
    (e.g. D:\SQL2012\backup\DEMO_peachux_trade)

.INPUTS


.OUTPUTS

	
.EXAMPLE
From Commandline Sql Authentication  
 Option #1  Ps c:\> .\SqlRestore-Database.PS1
            Ps c:\>  RestoreSqlDB -ServerInstance "SERVERNAME\INSTANCENAME" -Authentication "SQL Authentication" -Login "USERNAME" -Password "Password" -DatabaseName "DEMO_peachux_trade" -Filespath "D:\SQL2012\backup\DEMO_peachux_trade"

Option #2  PS c:\> Powershell -command "& {. K:\DBAWorkArea\JMontero\PowerShell\SqlRestore-Database.ps1; RestoreSqlDB -ServerInstance houdb60\sqlsvr11 -Authentication 'Sql Authentication' -Login 'USERNAME' -Passwd 'P@ssword' -Databasename 'DEV_riskmgr_trade_ss_WORK' -Filespath 'k:\NightlyBck\DEV_riskmgr_trade_ss' -verbose}"

.EXAMPLE
From Commandline Windows Authentication  
 Option #1  Ps c:\> .\SqlRestore-Database.PS1
            Ps c:\>  RestoreSqlDB -ServerInstance "SERVERNAME\INSTANCENAME" -Authentication 'Windows Authentication" -DatabaseName "DEMO_peachux_trade" -Filespath "D:\SQL2012\backup\DEMO_peachux_trade"

Option #2  PS c:\> Powershell -command "& {. K:\DBAWorkArea\JMontero\PowerShell\SqlRestore-Database.ps1; RestoreSqlDB -ServerInstance houdb60\sqlsvr11 -Authentication 'Windows Authentication' -Databasename 'DEV_riskmgr_trade_ss_WORK' -Filespath 'k:\NightlyBck\DEV_riskmgr_trade_ss' -verbose}"

.EXAMPLE 
From SQL Server Management Studio
Option # 1 xp_cmdshell 'Powershell.exe -command "& {. K:\DBAWorkArea\JMontero\PowerShell\SqlRestore-Database.ps1; RestoreSqlDB -ServerInstance houdb60\sqlsvr11 -Authentication ''Sql Authentication'' -Login "USERNAME" -Passwd "PASSWORD" -Databasename "DEV_riskmgr_trade_ss_WORK" -Filespath "k:\NightlyBck\DEV_riskmgr_trade_ss" -verbose}"'

Option # 2 xp_cmdshell 'Powershell.exe -command "& {. K:\DBAWorkArea\JMontero\PowerShell\SqlRestore-Database.ps1; RestoreSqlDB -ServerInstance houdb60\sqlsvr11 -Authentication ''Windows Authentication'' -Databasename "DEV_riskmgr_trade_ss_WORK" -Filespath "k:\NightlyBck\DEV_riskmgr_trade_ss" -verbose}"'
"Windows Authentication User must have sysadmin permission or be part of db_owner role"

.NOTES
	Author        :	Javier Montero  - 11/10/2017
    Version       :	1.0	
	Compatibility :	PS 2.0 or Higher
	SQL Ver       :	SQL Server 2008R2 or Higher
	VS IDE        : Visual Studio Code   
	TO GET HELP OR ANY NOTE HERE TYPE GET-HELP .\AutoSync_Spk_and_SchemaCode.PS1 -FULL
	
#>

<#=============================================================================================
                DECLARING GLOBAL CONNECTION VARIABLES
=============================================================================================#>
$Script:SourceConnection = New-Object System.Object
$Script:SourceConnection | Add-Member -type NoteProperty -Name Instance -Value $null
$Script:SourceConnection | Add-Member -type NoteProperty -Name Authentication -Value $null
$Script:SourceConnection | Add-Member -type NoteProperty -Name LoginID -Value $null
$Script:SourceConnection | Add-Member -type NoteProperty -Name Password -Value $null

function LoadAssemblies{

if ([Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") -eq $null )
{ throw "Quitting: SMO Required. You can download it from http://goo.gl/R4yA6u" }
 
if ([Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMOExtended") -eq $null )
{ throw "Quitting: Extended SMO Required. You can download it from http://goo.gl/R4yA6u" }
    <#$sqlpsreg = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell"
    if (Get-ChildItem $sqlpsreg -ErrorAction "SilentlyContinue") {
        throw "SQL Server Provider for Windows Powershell is not installed"
    }
    else {
        $item = Get-ItemProperty $sqlpsreg
        #$sqlpsPath = [System.IO.Path]::GetDirectoryName($item.path)
    }#>

    $assemblylist =   
    "Microsoft.SqlServer.Management.Common",  
    "Microsoft.SqlServer.Smo",  
    "Microsoft.SqlServer.Dmf ",  
    "Microsoft.SqlServer.Instapi ",  
    "Microsoft.SqlServer.SqlWmiManagement ",  
    "Microsoft.SqlServer.ConnectionInfo ",  
    "Microsoft.SqlServer.SmoExtended ",  
    "Microsoft.SqlServer.SqlTDiagM ",  
    "Microsoft.SqlServer.SString ",  
    "Microsoft.SqlServer.Management.RegisteredServers ",  
    "Microsoft.SqlServer.Management.Sdk.Sfc ",  
    "Microsoft.SqlServer.SqlEnum ",  
    "Microsoft.SqlServer.RegSvrEnum ",  
    "Microsoft.SqlServer.WmiEnum ",  
    "Microsoft.SqlServer.ServiceBrokerEnum ",  
    "Microsoft.SqlServer.ConnectionInfoExtended ",  
    "Microsoft.SqlServer.Management.Collector ",  
    "Microsoft.SqlServer.Management.CollectorEnum",  
    "Microsoft.SqlServer.Management.Dac",  
    "Microsoft.SqlServer.Management.DacEnum",  
    "Microsoft.SqlServer.Management.Utility"

    foreach($asm in $assemblylist){
        $asm = [Reflection.Assembly]::LoadWithPartialName($asm)
    }
    $true
}
function Connect-SqlInstance{
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [System.Object]$Connection,
        [Parameter(Mandatory=$true, Position=1)]
        [String]$Databasename                
    )
    try {
        $conn = New-Object -TypeName Microsoft.SqlServer.Management.Common.ServerConnection        
        if($Connection.Authentication -eq "Windows Authentication"){
            $conn.ServerInstance = $Connection.Instance
            $conn.DatabaseName = "master"
            $conn.ApplicationName = "SqlRestore-Database"    
            $conn.StatementTimeout = 0
            #$conn.connect()            
        }
        else{
            $conn.ServerInstance = $Connection.Instance            
            $conn.LoginSecure = $false
            $conn.DatabaseName = "master"
            $conn.Login = $Connection.LoginID
            #$conn.SecurePassword = ConvertFrom-SecureString($Connection.Password)
            $conn.Password = $Connection.Password
            #$conn.connect()            
        }
        <#if($conn.IsOpen -eq $false){
            Throw "Could not established connection to server $($Connection.Instance)"
        }#>
        $Server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server($conn)
        $Server.ConnectionContext.Connect()
        Write-Host "Connection to Server " $Connection.Instance "... OK"
        $Server
    }
    catch {
        $Connection = $Connection.Instance
        $message = $_.Exception.InnerException.InnerException
        $message = $message.ToString()
        $message = ($message -split '-->')[0]
        $message = ($message -split 'at System.Data.SqlClient')[0]
        $message = ($message -split 'at System.Data.ProviderBase')[0]
        throw "Can't connect to $Connection`: $message "
    }
}

function AlterDBAccess{
    param(
        [Parameter(Mandatory=$true, Position=0)]
        $Server,
        [Parameter(Mandatory=$true, Position=1)]
        [System.String]$DBName,
        [Parameter(Mandatory=$true, Position=2)]
        [System.String]$AccessMode
    )
    try {
        $reponse = $false
        $DBObject = $Server.Databases[$DBName]
        if($DBName -eq $DBObject.Name){
            Write-Host "Establishing Database Access Mode to $AccessMode on $DBName" -ForegroundColor Yellow
            $DBObject.DatabaseOptions.UserAccess = [Microsoft.SqlServer.Management.Smo.DatabaseUserAccess]::$AccessMode
            $DBObject.Alter()
            $reponse = $true
        }
        #return $reponse
    }
    catch {
        Write-Host "Altering Database $DBName User AccessMode.... Aborted" -ForegroundColor Red
        $operation_error = $_.Exception.InnerException.Operation
        $message = $_.Exception.InnerException
        $error_msg += ("`r`nServer: " + $Server.Name).ToString()
        $error_msg += ("`r`nSource: " + $message.Source).ToString()
        $error_msg += ("`r`nMessage: " + $message.Message).ToString()
        Write-Warning "$operation_error` Operation Fails --> $error_msg "
        Break
    }
}

function RestoreDatabase{
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [Object]$Files,
        [Parameter(Mandatory=$true, Position=1)]
        [String]$DBName,
        [Parameter(Mandatory=$true, Position=2)]
        [System.Object]$SrcConnection
    )
    try {
        if(LoadAssemblies){
            $SmoServer = Connect-SqlInstance -Connection $SrcConnection -Databasename $DBName
            if($SmoServer){
                AlterDBAccess -Server $SmoServer -DBName $DBName -AccessMode "RESTRICTED"
                $Restore = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Restore
                $Restore.Action = 'Database'
                $Restore.Database = $DBName
                $Restore.ReplaceDatabase = $true
                $devicetype = [Microsoft.SqlServer.Management.Smo.DeviceType]::File
                foreach($bakfile in $files){
                    $backupname = $bakfile.FullName
                    $bakdevice = New-Object -TypeName Microsoft.SqlServer.Management.Smo.BackupDeviceItem($backupname, $devicetype)
                    $Restore.Devices.Add($bakdevice)
                }
                $percent = [Microsoft.SqlServer.Management.Smo.PercentCompleteEventHandler]{
                    Write-Progress -id 1 -Activity "Restoring Database $DBName" -PercentComplete $_.Percent -Status([System.String]::Format("Progress: {0} %",$_.Percent))
                }
                $Restore.Add_PercentComplete($percent)
                $Restore.Add_Complete($complete)
                Write-Progress -id 1 -Activity "Restoring Database $DBName" -PercentComplete 0 -Status([System.String]::Format("Progress: {0} %",0))
                Write-Host "Restoring Database $DBName.... In Progress" -ForegroundColor Yellow
                $Restore.SqlRestore($SmoServer)
                Write-Progress -id 1 -Activity "Restoring Database $DBName" -Status "Complete" -Completed
                Write-Host "Restoring Database $DBName.... Completed" -ForegroundColor Green
                AlterDBAccess -Server $SmoServer -DBName $DBName -AccessMode "MULTIPLE"
            }
        }

    }
    catch {
        Write-Host "Restoring Database $DBName.... Aborted" -ForegroundColor Red
        $operation_error = $_.Exception.InnerException.Operation
        $message = $_.Exception.InnerException.InnerException
        #$message = $message.ToString()
        #$message = ($message -split '--->')[0]
        #$message = ($message -split 'at Microsoft.SqlServer.Management.Common.ConnectionManager.ExecuteTsql')[0]
        #$message = ($message -split 'at System.Data.ProviderBase')[0]
        $error_msg += ("`r`nServer: " + $SrcConnection.Instance).ToString()
        $error_msg += ("`r`nSource: " + $message.Source).ToString()
        $error_msg += ("`r`nMessage: " + $message.Message).ToString()
        throw "$operation_error` Operation Fails --> $error_msg "
    }
}
function RestoreSqlDB {
    Param(        
        [Parameter(Mandatory=$true, Position=0)]
        $ServerInstance,    
        [Parameter(Mandatory=$true, Position=1)]
        [String]$Authentication,
        [Parameter(Mandatory=$false,Position=2)]
        [string]$Login,
        [Parameter(Mandatory=$false,Position=3)]
        [String]$Passwd, 
        [Parameter(Mandatory=$true, Position=4)]
        [String] $Databasename,
        [Parameter(Mandatory=$true, Position=5)]
        [String]$Filespath       
    )
        try {
            
            if($ServerInstance -eq " "){
                continue
            }
            if($Authentication -ne ""){
                if($Authentication -eq "Windows Authentication"){
                    $Script:SourceConnection.Instance = $ServerInstance 
                    $Script:SourceConnection.Authentication = $Authentication
                }
                if($Authentication -eq "Sql Authentication"){
                    if($Login -eq ""){continue}
                    if($Passwd -eq ""){continue}
                    $Script:SourceConnection.Instance = $ServerInstance
                    $Script:SourceConnection.Authentication = $Authentication
                    $Script:SourceConnection.LoginID = $Login
                    $Script:SourceConnection.Password = $Passwd
                }
            }
            $bakfiles = Get-ChildItem -Path $Filespath -Filter "*.bak" -ErrorAction SilentlyContinue -Force 
            if($bakfiles.Length -ge 1){
                <#$lastindex = $bakfiles.Length - 1
                for($i = 0; $i -lt $bakfiles.Length; $i++){
                    if($lastindex -eq $bakfiles.IndexOf($bakfiles[$i])){
                        $baklist += $bakfiles[$i].FullName
                    } 
                    else {
                        $baklist += $bakfiles[$i].FullName
                    }                    
                }#>
                RestoreDatabase -Files $bakfiles -DBName $Databasename -SrcConnection $Script:SourceConnection
            }
            else {
                Write-Warning "Backup files Path Provided $Filespath does not contains *.bak or *.trn file "
                Write-Warning "Please Validate Path File and Try Again. "
            }
           
        }
        catch {
            Write-Warning -Message $_.Exception.Message
        }        
    
}
#houdb01.database.windows.net
#RestoreSqlDB -Databasename "DEV_riskmgr_trade_ss_WORK" -Filespath "\\houdb60\k$\NightlyBck\DEV_riskmgr_trade_ss" -ServerInstance "houdb60\sqlsvr11" -Authentication "Sql Authentication" -Login "tc_admin" -Passwd 'Tr8dDb@'
#RestoreSqlDB -ServerInstance 'houdb60\sqlsvr11' -Authentication 'Windows Authentication' -Databasename "DEV_riskmgr_trade_ss_WORK" -Filespath "\\houdb60\k$\NightlyBck\DEV_riskmgr_trade_ss" -verbose