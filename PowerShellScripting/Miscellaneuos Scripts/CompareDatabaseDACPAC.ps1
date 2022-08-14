<# 
.SYNOPSIS
 Compare 2 databases using SSDT (sqlpackage.exe)

.DESCRIPTION
 Invoke an SSDT dewployment using sqlpackage.exe. This will generate a DACPAC for the source
 and then create a T-SQL Script and a DeployReport against a target database.

.PARAMETER SourceServer 
 Source database server. This is where the "gold copy" lives.

.PARAMETER SourceDatabase 
 Source database or the "gold copy" database. 

.PARAMETER TargetServer 
 Target database server. 

.PARAMETER TargetDatabase 
 Target database. This is the database that is being compared to the gold copy.

.PARAMETER ArtifactPath 
 Working directory for the scripts to be placed in

.PARAMETER SqlPackagePath 
 Path to sqlpackage.exe

.EXAMPLE
 Compare-DatabasesSSDT

#>
function Compare-DatabasesSSDT
{
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true)][string]$SourceServer, 
        [parameter(Mandatory=$true)][string]$SourceDatabase, 
        [parameter(Mandatory=$true)][string]$TargetServer, 
        [parameter(Mandatory=$true)][string]$TargetDatabase,
        [parameter(Mandatory=$true)][string]$ArtifactPath = 'c:\temp\', # A wowrking directory. Defaults to c:\temp
        [parameter(Mandatory=$false)][string]$SqlPackagePath = 'C:\Program Files\Microsoft SQL Server\120\DAC\bin\sqlpackage.exe' # Path to sqlpackage.exe
    )

    # Create artifact file if one does not exist.
    if (!(Test-Path -Path $($ArtifactPath)))
    {
        New-Item -ItemType Directory -Force -Path "$($ArtifactPath)" | Out-Null
    }

    try {
        $SourceDACPAC = "$($ArtifactPath)\$($SourceDatabase).dacpac"
        $TargetScript = "$($ArtifactPath)\$($TargetDatabase)_Script.sql"
        $TargetDriftReport = "$($ArtifactPath)\$($TargetDatabase)_DeployReport.xml"

        # sqlpackage export the source DACPAC
        &"$SqlPackagePath" /a:Extract /ssn:$SourceServer /sdn:$SourceDatabase /tf:$SourceDACPAC /p:IgnorePermissions=True 2>&1

        #&"C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin\SqlPackage.exe" /a:Script /sf:"C:\Temp\PROD_PMI_trade_aug02.dacpac" /tsn:'HYDDB07,1450' /tdn:'QA_PMI_trade_33' /op:C:\TEMP\QA_PMI_TRADE_33.sql /p:IgnorePermissions=True /p:IgnoreComments=True /p:TreatVerificationErrorsAsWarnings=True /p:IgnoreRoleMembership=True /p:IgnoreUserSettingsObjects=True 2>&1
        #"C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin\SqlPackage.exe" / a:Script /sf:"C:\Temp\PROD_PMI_trade_aug02.dacpac" /tsn:"HYDDB07,1450" /tdn:"QA_PMI_trade_33" /op:C:\TEMP\QA_PMI_TRADE_33.sql /p:IgnorePermissions=True /p:IgnoreComments=True /p:TreatVerificationErrorsAsWarnings=True /p:IgnoreRoleMembership=True /p:IgnoreUserSettingsObjects=True 2>&1

        # sqlpackage script
        &"$SqlPackagePath" /a:Script /sf:$SourceDACPAC /tsn:$TargetServer /tdn:$TargetDatabase /op:$TargetScript `
            /p:IgnorePermissions=True /p:IgnoreRoleMembership=True /p:IgnoreUserSettingsObjects=True 2>&1

        # sqlpackage driftreport
        &"$SqlPackagePath" /a:DeployReport /sf:$SourceDACPAC /tsn:$TargetServer /tdn:$TargetDatabase /op:$TargetDriftReport `
            /p:IgnorePermissions=True /p:IgnoreRoleMembership=True /p:IgnoreUserSettingsObjects=True 2>&1

    }
    catch {
        throw $_
    }
}

# Unit testing commands
$ErrorActionPreference = "Stop"
$error.clear()

$params = @{
    'SourceServer' = 'HYDDB05,1450' ;
    'SourceDatabase' = 'PROD_PMI_trade_aug02' ;
    'TargetServer' = 'HYDDB07,1450' ;
    'TargetDatabase' = 'QA_PMI_trade_33' ;
    'ArtifactPath' = 'c:\temp' ;
    'SqlPackagePath' = 'C:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe'
}

Get-Date
Compare-DatabasesSSDT @params -Verbose 
Get-Date
#>