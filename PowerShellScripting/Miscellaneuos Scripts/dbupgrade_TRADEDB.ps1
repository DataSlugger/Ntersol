<#

.NAME
	dbupgrade_TRADEDB.PS1	
.SYNOPSIS
	SCRIPT DEVELOPED TO UPGRADE SYMPHONY DATABASES

.DESCRIPTION
	

.PARAMETERS 
	$srvinstance    :  SQL Server Instance to work	
	$username       :  DatabaseUser with credentials to logon as sysadmin
	$userPassword   :  Password of Database User
	$dbName         :  SQL Server Database Name to Script

.VARIABLES
	Local Variables
	$script:ServerInstance    : Refer and receive a Instance name value
	$script:TargetServer      : Refer and receive a Server Connection value 
    $script:TargetConnection  : Refer and receive a SQL Server value
	$script:DBUser            : Refer and receive a DB User name value
    $script:DBPass            : Refer and receive a DB User Password value
	$db                       : Refer and receive a Database name value
	$sqlconn                  : Local variable to receive SQL Connection values
	$script:sqlmessages       : Used for print SQL Server Messages like PRINT or DB Errors
	
.INPUTS
	
.OUTPUTS
	Log Results error.log
	Log Error if is necessary

.REQUIREMENTS
	Powershell Ver 2.0 or newer
	
.EXAMPLE
 Ps c:\> .\dbupgrade_TRADE.PS1	[SERVER INSTANCE] [DB USER] [USER PASSWORD] [DATABASE NAME]

.NOTES
	Author        :	Javier Montero  - 08/17/2016
    Version       :	1.0	
	Compatibility :	PS 2.0 or Higher
	SQL Ver       :	SQL Server 2008R2 or Higher
	VS IDE        : Visual Studio 2015   
	TO GET HELP OR ANY NOTE HERE TYPE GET-HELP .\dbupgrade_TRADEDB.PS1

	

	
#>

	param(
		[Parameter(Mandatory=$true)]
		[ValidateNotNullorEmpty()]
		[System.string]
		$srvInstance,
		[Parameter(Mandatory=$true)]
		[ValidateNotNullorEmpty()]
		[System.string]
		$userName,
		[Parameter(Mandatory=$true)]
		[ValidateNotNullorEmpty()]
		[System.string]
		$userPassword,
		[Parameter(Mandatory=$true)]
		[ValidateNotNullorEmpty()]
		[System.string]
		$dbName
	)

$folderpath    = Split-Path -Parent $MyInvocation.MyCommand.Definition;
$logerrorpath;

function set_ErrorLogFolder(){
	try{
		If(Test-Path -Path $folderpath\"Logs" -PathType Container){
			$logerrorpath = "$folderpath\Logs";
			Write-Host "Clean Up Old Log Files";
			Remove-Item $logerrorpath -Include *.log;
		}
		else{
			Write-Host "Creating Error Log Files Folder";
			New-Item $folderpath -Name .\logs -ItemType Directory;
			$logerrorpath = "$folderpath\logs";
		}
	}
	catch{
		$logerrorpath = "$folderpath\Logs";
		"____________________________________ " | Out-File "$logerrorpath\MainError.log" -Append;
		Get-Date                                | Out-File "$logerrorpath\MainError.log" -Append;
		"Error ID:" + $_.Exception.ID           | Out-File "$logerrorpath\MainError.log" -Append;
		"Error Line:" + $_.Exception.Line       | Out-File "$logerrorpath\MainError.log" -Append;
		"Message :" + $_.Exception.Message      | Out-File "$logerrorpath\MainError.log" -Append;
	}
}

function execute_ScriptFiles($dbufile){
	try{
		$myArg = $null;
		Write-Host "Executing Database Upgrade Process";
		$var = $dbufile 
		$param = "$srvInstance","$userName","$userPassword","$dbName"
		Write-Host $param;
		#$exe = & $var $param
		#set-location "C:\Users\jmontero\Documents\Visual Studio 2015\Projects\DB_UPGRADE_SCRIPTS\DB_UPGRADE_SCRIPTS\ADSO-1900\SQL"
		$param = "/k "+"$dbufile $srvInstance";
		set-location $dbufile.Directory;
		Get-Location;
		Start-Process -FilePath cmd.exe -ArgumentList "/k $dbufile $srvInstance $userName $userPassword $dbName" -WindowStyle Hidden;
		#Invoke-Command {PARAM($myArg) &$dbufile $myArg} -ArgumentList "$srvInstance" -Verbose;
		#Start-Process -FilePath "$var","$srvInstance","$userName","$userPassword","$dbName"
		Set-Location $folderpath -Verbose;
		Get-Location;

	}
	catch{
		Write-Host "Usage .\dbupgrade_TRADEDB.ps1 ServerInstance UserName Password Database"
		throw new exception($_.Exception.Message)
	}
}

function get_ScriptsFiles(){

	try{
		If(Test-Path -Path $folderpath -PathType Container){
			Set-Location $folderpath;
			$get_items = Get-ChildItem $folderpath -Filter *ADSO* -Directory -ErrorVariable $errorv -ErrorAction SilentlyContinue
			ForEach($item in $get_items){
				Write-Host "Looking dbupgrade file on $item";
				if(Test-Path -Path "$item\SQL" -PathType Container){
					$dbupgrade_file = Get-ChildItem "$item\SQL" -Verbose -Filter *dbupgrade*.bat;
					if($dbupgrade_file -eq $null){ Write-Host "Command Batch Files Not Exists on "$item.FullName }
					ForEach($dbfile in $dbupgrade_file){
						execute_ScriptFiles($dbfile);				
					}
				}
				else{
					Write-Host "SQL Folder Path Not Exists on "$item.FullName;
				}
				
			}
		}
		
		else{
			Write-Host "Folder Path Not Exists";
		}
	}
	catch{
		$logerrorpath = "$folderpath\Logs";
		"______________________________________"       | Out-File "$logerrorpath\Error.log" -Append;
		Get-Date                                       | Out-File "$logerrorpath\Error.log" -Append;
		"Error ID: " + $_.Exception.ErroId             | Out-File "$logerrorpath\Error.log" -Append;
		"Error Line: " + $_.Exception.Line             | Out-File "$logerrorpath\Error.log" -Append;
		"Error Message: " + $_.Exception.Message       | Out-File "$logerrorpath\Error.log" -Append;
		
	}
}

try{
set_ErrorLogFolder;
	get_ScriptsFiles;
}
catch{

}
