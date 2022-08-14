<#

.NAME
	NEW_COLUMN_EXISTS
.SYNOPSIS
	SCRIPT DEVELOPED TO CHECK IF A COLUMN EXISTS IN A TABLE 

.DESCRIPTION
	This script was created for check if a column exists on a table, this script get a table name then starts to look if a column exists on a table
	The column and table name are require.   
	
.PARAMETERS 
	$srvinstance  :  SQL Server Instance Name to work
	$dbusername   :  DatabaseUser with credentials to logon as sysadmin for Perform Actions
	$dbuspassw    :  Password of Database User
	$db_name      :  SQL Server Database Name
	$table_name   :  Table Name provided by the user, the table name require include the Schema Name
	$column_name  :  Column Name provided by the user or program. 
	
.INPUTS
	
.OUTPUTS
		0 - Column Not Exists
		1 - Column Exists
		2 - Error Encountred
	
.EXAMPLE
 Ps c:\> .\NEW_COLUMN_EXISTS.ps1 [Server_Instance] [UserName] [Password] [DB Name] [SCHEMA].[Table Name] [Colum Name]

.NOTES
	Author        :	Javier Montero  - 01/11/2016
	Company       : Amphora Inc.
	Tool          : Visual Studio 2013  Powershell Project
    Version       :	1.0	
	Compatibility :	PS 2.0 or Higher
	SQL Ver       :	SQL Server 2008R2 or Higher
	TO GET HELP OR ANY NOTE HERE TYPE GET-HELP .\NEW_COLUMN_EXISTS.ps1
	
#>
[cmdletBinding(DefaultParametersetName='SQLAuthentication')]
param(
	[Parameter(Position=0, Mandatory=$true)]
	[Parameter(Mandatory=$true, ParameterSetName='WindowsAuthentication')]
	[Parameter(Mandatory=$true, ParameterSetName='SQLAuthentication')]
	[ValidateNotNullorEmpty()]
	[System.string] $serverinstance,

	[Parameter(Position=1, Mandatory=$true, ParameterSetName='SQLAuthentication')]
	[ValidateNotNullorEmpty()]
	[System.string] $username,

	[Parameter(Position=2, Mandatory=$true, ParameterSetName='SQLAuthentication')]
	[ValidateNotNullorEmpty()]
	[System.string] $password,

	[Parameter(Position=3, Mandatory=$true)]
	[ValidateNotNullorEmpty()]
	[System.string] $database,

	[Parameter(Position=4, Mandatory=$true)]
	[ValidateNotNullorEmpty()]
	[System.string] $table_name,

	[Parameter(Position=5, Mandatory=$true)]
	[ValidateNotNullorEmpty()]
	[System.string] $column_name
)

#***********************************************************************
#Variable Initizalation
#***********************************************************************
$srvinstance             = $serverinstance
$dbuser                  = $username
$dbpass                  = $password
$dbname                  = $database
$tblname                 = $table_name
$clmname                 = $column_name
$TargetInstance          = $null
$TargetDatabase          = $null
$TargetDbExists          = $false
[int] $exists_col        = 0

#**********************************************************************
# ERROR VARIABLE & PATH
#**********************************************************************
$scriptspath    = Split-Path -Parent $MyInvocation.MyCommand.Definition
$errors = $scriptspath+"\error.log"

#*****************************************************************************************************************************
# Load SMO assembly, and if we're running SQL 2008 DLLs or higher load the SMOExtended and SQLWMIManagement libraries
# SMO Major Versions / Powershell 2.0 or Higher
# 9	:	SQL 2005
# 10:	SQL 2008 & 2008 R2 
# 11:	SQL 2012
# 12:   SQL 2014
#******************************************************************************************************************************
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | ForEach-Object {
	$SmoMajorVersion = $_.GetName().Version.Major
	if ($SmoMajorVersion -ge 10) {
		[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMOExtended') | Out-Null
		[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SQLWMIManagement') | Out-Null
	}
}

#********************************************************************************************************************************
# CONSTANTS
# SQL Versions
# See http://social.technet.microsoft.com/wiki/contents/articles/783.sql-server-versions.aspx for version timeline
# Also see http://support.microsoft.com/kb/321185
# Also see http://sqlserverbuilds.blogspot.com/
#********************************************************************************************************************************
New-Object -TypeName System.Version -ArgumentList '9.0.0.0' | New-Variable -Name SQL2005 -Scope Script -Option Constant
New-Object -TypeName System.Version -ArgumentList '10.0.0.0' | New-Variable -Name SQL2008 -Scope Script -Option Constant
New-Object -TypeName System.Version -ArgumentList '10.50.0.0' | New-Variable -Name SQL2008R2 -Scope Script -Option Constant
New-Object -TypeName System.Version -ArgumentList '11.0.0.0' | New-Variable -Name SQL2012 -Scope Script -Option Constant
New-Object -TypeName System.Version -ArgumentList '12.0.0.0' | New-Variable -Name SQL2014 -Scope Script -Option Constant




function Get_SqlConnection(){
	#***********************************************************************	
	#Function for validate Login Credentials and build connection string
	#***********************************************************************
		<# DEBUG
		 # All paramaters have ValidateNotNullorEmpty validation 
         # Write-Host "Server Instance   :" $serverinstance
         # Write-Host "User Name         :" $Username
         # Write-Host "Password          :" $Password
		 
		#>

	[CmdletBinding()]
	[OutputType([System.Data.SqlClient.SqlConnection])]
	param(
		[Parameter(Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$Instance = $serverinstance
		,
		[Parameter(Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$Database = $database
		,
		[Parameter(Mandatory=$true, ParameterSetName = 'SQLAuthentication')]
		[ValidateNotNull()]
		[System.String]
		$Username = $dbuser
		,
		[Parameter(Mandatory=$true, ParameterSetName = 'SQLAuthentication')]
		[ValidateNotNull()]
		[System.String]
		$Password = $dbpass
		,
		[Parameter(Mandatory=$true, ParameterSetName = 'WindowsAuthentication')]
		[ValidateNotNull()]
		[alias('WindowsAuth','IntegratedAuth')]
		[switch]
		$WindowsAuthentication
		,
		[Parameter(Mandatory=$false)]
		[System.String]
		$ApplicationName = 'Windows PowerShell' # $MyInvocation.ScriptName	
	)
	try {
		
		$SQLConnection = New-Object -TypeName System.Data.SqlClient.SqlConnection
		$SQLConnectionBuilder = New-Object -TypeName system.Data.SqlClient.SqlConnectionStringBuilder

		$SQLConnectionBuilder.psBase.DataSource = $Instance
		$SQLConnectionBuilder.psBase.InitialCatalog = "master"

		if ($PSCmdlet.ParameterSetName -eq 'SQLAuthentication') {
			$SQLConnectionBuilder.psBase.IntegratedSecurity = $false
			$SQLConnectionBuilder.psBase.UserID = $Username
			$SQLConnectionBuilder.psBase.Password = $Password
		} else {
			$SQLConnectionBuilder.psBase.IntegratedSecurity = $true
		}

		$SQLConnectionBuilder.psBase.FailoverPartner = $FailoverPartner
		$SQLConnectionBuilder.psBase.ApplicationName = $ApplicationName

		$SQLConnection.ConnectionString = $SQLConnectionBuilder.ConnectionString

		Write-Output $SQLConnection

	}
	catch {
		Write-Output "Usage: .\NEW_COLUMN_EXISTS.ps1 [Server_Instance] [UserName] [Password] [DB Name] [Schema].[Table Name] [Colum Name]"
		$exists_col = 2
		Throw
	}
}

function Split_TableName($fullname)
{
    #*********************************************************************************
	#This function return the schema and table name splited schema and table name
	#*********************************************************************************
		<# DEBUG
		 # Write-Host "Database Name     :" $fullname
		#>


	try{
		if($fullname -ne $null){
		$splittable = $fullname.split(".")
			if($splittable -ne $null){
				$splittable
				Return 
			}
			else{
				Write-Host "Spliting Null"
			}
			
		
		}
	}
	catch{
		$exists_col = 2
		Throw
	}
	
}

function get_Column_Exists(){
	#***********************************************************************	
	#Function for validate if Column Exist on Table 
	#***********************************************************************
	<# DEBUG
	# Write-Host "Server Instance   :" $TargetServer
	# Write-Host "Database Name     :" $dbname
	# Write-Host "Table Name        :" $tblname
	# Write-Host "Column Name       :" $clmname
	#>

	try{
			
			#Getting Database Objects
			$Mydb = $TargetServer.Databases[$dbname]
			
			if(($Mydb)){
			
			<# Calling split schema and table name function #>
			$splits_tblname = Split_TableName($tblname)
			[string]$schema_name = $splits_tblname[0]
			[string]$split_tablename = $splits_tblname[1]
			
			if($splits_tblname -ne $null){
				
				$table = $Mydb.Tables.Item($splits_tblname[1], $splits_tblname[0]) <# Looking Table on Database Objects #>
				if(($table)){					
					$COL = $table.Columns[$clmname] <# Looking Column on Table #>
					if(($COL)){
						Write-Host "Column $COL Exists On Table $table_name"
						$exists_col = 1
					      }
					else{
						Write-Host "Column $clmname Not Exists On Table $table_name"
						$exists_col = 0
					}
					
				}
				else{
					Write-Host "Table $table_name Not Exists on Database: $Mydb.  Do you Need Provide SCHEMA.TABLE_NAME or Validate if Table Name is Correct"
					$exists_col = 2							
				}
			}
			else{
					Write-Host "You Provide a Wrong Table Name, Do you Need Provide SCHEMA.TABLE_NAME"
					$exists_col = 2							
		     	}
				Return $exists_col
		   }
		}
	catch{
		$exists_col = 2
		Throw	
		
	}

	
}

function get_MS_SQLServer_Version(){
	
	try{
		[bool] $retval = $false
		$ret =  $TargetServer.Version.Major
	
		if($ret -ge 8){
			$retval = $true		
		}
		return $retval
	}
	catch{
		$exists_tbl = 2
		Throw
	}
	
	
}

function get_Default_Database(){
	#***********************************************************************	
	#Function for validate if Database Exists 
	#***********************************************************************
	<# DEBUG
	# Write-Host "Database Name     :" $dbname
	# Write-Host "Server Instance   :" $TargetServer
	#>
	
	try{
		[boolean] $result = $false
		$TargetServer.Databases | Where-Object { $_.Name -ieq $dbname } | ForEach-Object {
		$result = $true	}
		return $result
	}
	catch{
		$exists_col = 2
		Throw
	}
}



#*****************
# MAIN PROGRAM
#*****************
try{

		# Creating connection string and Open a connection to the target server 
	if ($PSCmdlet.ParameterSetName -eq 'SQLAuthentication') {
		$TargetConnection = Get_SqlConnection -Instance $srvinstance -Username $Username -Password $Password
	} else {
		$TargetConnection = Get_SqlConnection -Instance $srvinstance -WindowsAuthentication
	}
			
			try{
				<# Connecting with SQL Server #>
				$TargetServer = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $TargetConnection
				$TargetServer.ConnectionContext.Connect()
			} catch{
				$exists_tbl = 2
				"______________________________"   | Out-File $errors -Append;
				"ERROR SCRIPTING"                  | Out-File $errors -Append;
				Get-Date                           | Out-File $errors -Append;
				"Error: " + $_                     | Out-File $errors -Append;
				"Message: " + $_.Exception.Message | Out-File $errors -Append;
				Write-Host "SQL Server Connection Failed!!!!: Please Check Errors Log File at $errors"
				Write-Host "Usage: .\NEW_COLUMN_EXISTS.ps1 [Server_Instance] [UserName] [Password] [DB Name] [Schema].[Table Name] [ColumnName]"
			}
		
	<# Validating the SQL Server Database Exists #>
	$TargetDbExists = get_Default_Database
	$version_bool = get_MS_SQLServer_Version

	if(($version_bool)){
		if(($TargetDbExists)){		
			get_Column_Exists #Calling Function for Validate If Column Exists
		} else{
			Write-Host "Database $dbname Not Exists or Check the Name and Try Againg"
			$exists_col = 2
			return $exists_col	}
	} else {
			Write-Host "SQL Database Version Not Supported or Not Exists or Check the Name and Try Againg"
		    $exists_tbl = 2
		    return $exists_tbl
	}

	
	
}
catch{
	#DEBUG: 
	#$table_name
	# $database 
		$exists_col = 2	   
		return $exists_col
	    "_________________________________"| Out-File $errors -Append;
		"ERROR SCRIPTING"                  | Out-File $errors -Append;
		Get-Date                           | Out-File $errors -Append;
		"Error: " + $_                     | Out-File $errors -Append;
		"Message: " + $_.Exception.Message | Out-File $errors -Append;
		Throw "Error!!!!: Please Check Errors Log File at $errors"
		Write-Host "Usage: .\NEW_COLUMN_EXISTS.ps1 [Server_Instance] [UserName] [Password] [DB Name] [Schema].[Table Name] [ColumnName]"
}



