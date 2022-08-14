<#

.NAME
	CHECK_TABLE_EXISTS
.SYNOPSIS
	SCRIPT DEVELOPED TO CHECK IF A TABLE EXISTS IN THE DATABASE

.DESCRIPTION
	This script was created for check if a table exists on the Database, this script get a table name then start to look this table into the Database
	The table name require include the Schema  
	
.PARAMETERS 
	$srvinstance  :  SQL Server Instance Name to work
	$dbusername   :  DatabaseUser with credentials to logon as sysadmin for Perform Actions
	$dbuspassw    :  Password of Database User
	$db_name      :  SQL Server Database Name
	$table_name   :  Table Name provided by the user, the table name requiere it include the Schema Name
	
.INPUTS
	
.OUTPUTS
		0 - Table Not Exists
		1 - Table Exists
	
.EXAMPLE
 Ps c:\> .\CHECK_TABLE_EXISTS.ps1

.NOTES
	Author        :	Javier Montero  - 01/08/2016
	Company       : Amphora Inc.
	Tool          : Visual Studio 2013  Powershell Project
    Version       :	1.0	
	Compatibility :	PS 2.0 or Higher
	SQL Ver       :	SQL Server 2008R2 or Higher
	TO GET HELP OR ANY NOTE HERE TYPE GET-HELP .\CHECK_TABLE_EXISTS.ps1
	
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
	[System.string] $table_name
)

#***********************************************************************
#Variable Initizalation
#***********************************************************************
$srvinstance         = $serverinstance
$dbuser              = $username
$dbpass              = $password
$dbname              = $database
$tblname             = $table_name
$TargetInstance      = $null
$TargetDatabase      = $null
$TargetDbExists      = $false
[int] $exists_tbl    = 0

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

#***********************************************************************	
#Function Login Credentials
#***********************************************************************
function Get_SqlConnection(){
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
		$ApplicationName = 'Windows PowerShell' + $MyInvocation.ScriptName	
	)
	try {
		<# DEBUG
         # Write-Host "Server Instance   :" $serverinstance
         # Write-Host "User Name         :" $Username
         # Write-Host "Password          :" $Password
		 # Write-Host "Database Name     :" $database
		#>

		$SQLConnection = New-Object -TypeName System.Data.SqlClient.SqlConnection
		$SQLConnectionBuilder = New-Object -TypeName system.Data.SqlClient.SqlConnectionStringBuilder

		$SQLConnectionBuilder.psBase.DataSource = $Instance
		$SQLConnectionBuilder.psBase.InitialCatalog = $Database

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
		Write-Output "Usage: .\NEW_COLUMN_EXISTS.ps1 [Server_Instance] [UserName] [Password] [DB Name] [Table Name] [Colum Name]"
		Throw
	}
}

function get_MS_SQLServer_Version(){
	
	try{
		[bool] $retval = $false
		$ret =  $TargetServer.Version.Major
	
		if($ret -ge 9){
			$retval = $true		
		}
		return $retval
	}
	catch{
		Throw
	}
	
	
}

function split_tablename([string]$fullname)
{
    #This function return the schema and table name splited
    
	if($fullname -ne $null)
	{
		$splittable = $fullname.split(".")
		$splittable
		Return 
	}
}


function get_table_exists(){

	<# DEBUG
	# Write-Host "Database Name     :" $dbname
	# Write-Host "Server Instance   :" $TargetServer
	# Write-Host "Table Name        :" $tblname
	# Write-Host "Column Name       :" $clmname
	#>

	try{
				
			#Checking IF Database exists
			$Mydb = $TargetServer.Databases[$dbname]
			#Write-Host "DB: $Mydb "
			if(($Mydb)){
			
			<# Calling split schema and table name function #>
			$splits_tblname = Split_TableName($tblname)
			[string]$schema_name = $splits_tblname[0]
			[string]$split_tablename = $splits_tblname[1]
			
			if($splits_tblname -ne $null){
				$table = $Mydb.Tables.Item($splits_tblname[1], $splits_tblname[0])
				if(($table)){
							$exists_tbl = 1
					      }
                	else{
						$exists_tbl = 0								
				    }								
				}	
			
			else{
					#You Provide a Wrong Table Name, Do you Need Provide SCHEMA.TABLE_NAME
					$exists_col = 0								
		     	}
				Return $exists_tbl
		   }
		}
	catch{

		Throw
	}

	
}


#######################
# Main Program
#######################
try{

    <# DEBUG
	# Write-Host "Database Name     :" $TargetDatabase
	# Write-Host "Server Instance   :" $srvinstance
	# Write-Host "User Name         :" $Username
	# Write-Host "Password          :" $Password
	#>   

    # Opening a connection to the target server and check if the target database already exists
	if ($PSCmdlet.ParameterSetName -eq 'SQLAuthentication') {
		$TargetConnection = Get_SqlConnection -Instance $srvinstance -Username $Username -Password $Password
	} else {
		$TargetConnection = Get_SqlConnection -Instance $srvinstance -WindowsAuthentication
	}
	
    $TargetServer = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $TargetConnection
	#Validating If the connection with the SQL Server was stablished
	try{
        $TargetServer.ConnectionContext.Connect()
        }
    catch{
        
		"______________________________"   | Out-File $errors -Append;
		"ERROR SCRIPTING"                  | Out-File $errors -Append;
		Get-Date                           | Out-File $errors -Append;
		"Error: " + $_                     | Out-File $errors -Append;
		"Message: " + $_.Exception.Message | Out-File $errors -Append;
		Throw "SQL Server Connection Failed!!!!: Please Check Errors Log File at $errors"
       }
		
	    $TargetServer.Databases | Where-Object { $_.Name -ieq $TargetDatabase } | ForEach-Object {
		$TargetDbExists = $true
	        }
		$version_bool = get_MS_SQLServer_Version
		if(!($version_bool)){
			#Checking IF Database exists then look the Table
           if(!($TargetDbExists)){
			  get_table_exists  
		     }
           else{
              Write-Host "Database Not Exists"
            }
		  }
		
		

    
}
catch{
	
	    "______________________________"   | Out-File $errors -Append;
		"ERROR SCRIPTING"                  | Out-File $errors -Append;
		Get-Date                           | Out-File $errors -Append;
		"Error: " + $_                     | Out-File $errors -Append;
		"Message: " + $_.Exception.Message | Out-File $errors -Append;
		Throw "Error!!!!: Please Check Errors Log File at $errors"
}

