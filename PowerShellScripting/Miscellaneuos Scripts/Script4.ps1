#
# Script4.ps1
# Author:		Javier Montero
# Company:		Amphora Inc.
# Version:		1.0 - 10/07/2015 16:53
# Modified: 
# Description:	Script to create a User Login on the DB from Powershell
# PS Version:	3.0 or Higher
# SQL Version:	2008 / 2012 or Higher
# 
#


Import-Module sqlps -DisableNameChecking

$instanceName = Read-Host "Provide Instance Name"
Write-Host "Login Credentials"
$userName = Read-Host "Please Provide User"
$password = Read-Host "Please Provide Password" -AsSecureString
$user_type = Read-Host "Please Provide Which Kind of Account do you want to Create (0) SQL Login, (1) Windows Account"


function add_Winlogins()
{
	try
	{
		$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName
	$server.ConnectionContext.LoginSecure = $false
	$server.ConnectionContext.set_Login($userName)
	$server.ConnectionContext.set_Password($password)
	$loginName = Read-Host "Please enter the UserID"
	#Drop the user is exist
	if ($server.Logins.Contains($loginName))
	{
		(Throw $server.Logins[$loginName].Drop())
	}
	
	$login = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $server, $loginName 
	$login.LoginType = [Microsoft.SqlServer.Management.Smo.LoginType]::WindowsUser
	$login.PasswordExpirationEnabled = $false
	(Throw $login.Create())
	Write-Host "Account " $loginName "Created Successfully"
	Pop-Location
	}
	catch
	{
		$errorMessage = $_.Exception.Message
		Write-Host = "Personal Error, Process Aborted" $errorMessage
		
	}
	
	
}

function add-Sqllogins()
{	try{
	$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName
	$server.ConnectionContext.LoginSecure = $false
	$server.ConnectionContext.set_Login($userName)
	$server.ConnectionContext.set_Password($password)
	$loginName = Read-Host "Please enter the UserID"
	#Drop the user is exist
if ($server.Logins.Contains($loginName))
	{
		$server.Logins[$loginName].Drop()
	}

	$login = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $server, $loginName
	$login.LoginType = [Microsoft.SqlServer.Management.Smo.LoginType]::SqlLogin
	$login.PasswordExpirationEnabled = $false
	$login.PasswordPolicyEnforced = $false

	$passw = Read-Host "Please enter the Password for the user" -AsSecureString
	$login.Create($passw)
	Write-Host "Account " $loginName "Created Successfully"
	Pop-Location
	}
	catch
	{
		$errorMessage = $_.Exception.Message
		Write-Host = "Personal Error, Process Aborted" $errorMessage
	}


}


Switch($user_type)
{
	0{add-Sqllogins}
	1{add_Winlogins}
	
}

