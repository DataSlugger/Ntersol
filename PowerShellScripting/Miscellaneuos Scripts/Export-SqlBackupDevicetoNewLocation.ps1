<#
.SYNOPSIS
	Script creates to move a SQL DB backup Device to differente location or path
.DESCRIPTION
    This script does not refer to create or perform DB Backups actions on SQL Server Engine
	this script perform only actions to move or copy to new location
	
	If destination path does not exists the script creates the folder path.
.PARAMETER SourcePath
    Refer Source Files Path
.Parameter TargetPath
    Refer to Destination Files Path
.PARAMETER CreateDestFolders
    Specified if Folder Need to be Created
.PARAMETER MoveFilestoTarget
    Specified if Files Need to be Moved to Target and clean up from Source Path.
.EXAMPLE 1
	.\Export-SqlBackupDevicetoNewLocation.PS1; Export-FilestoNewLocation -SourcePath "C:\Temp\Test" -TargetPath "C:\Temp\Test" 
.EXAMPLE 2
	.\Export-SqlBackupDevicetoNewLocation.PS1; Export-FilestoNewLocation -SourcePath "C:\Temp\Test" -TargetPath "C:\Temp\Test" -CreateDestFolders
.EXAMPLE 3
    .\Export-SqlBackupDevicetoNewLocation.PS1; Export-FilestoNewLocation -SourcePath C:\Temp -TargetPath C:\Temp\Test -MoveFilestoTarget
.EXAMPLE 4
	.\Export-SqlBackupDevicetoNewLocation.PS1; Export-FilestoNewLocation -SourcePath "C:\Temp\Test" -TargetPath "C:\Temp\Test" -CreateDestFolders -MoveFilestoTarget
.NOTES
	Author        :	Javier Montero  - 13/03/2018
    Version       :	1.0	
	Compatibility :	PS 3.0 or Higher
	SQL Ver       :	SQL Server 2008R2 or Higher
	VS IDE        : Visual Studio Code   
	TO GET HELP OR ANY NOTE HERE TYPE GET-HELP .\Copy-SqlDBBackupDevice.PS1 -FULL
#>

function  Export-FilestoNewLocation {
    param(
        [Parameter(Mandatory = $true, HelpMessage = "Source Files Path")]
        [String]$SourcePath,
        [Parameter(Mandatory = $true, HelpMessage = "Destination Files Path")]
        [String]$TargetPath,
        [Parameter(Mandatory = $false, HelpMessage = "Specified if Folder Need to be Created")]
        [switch]$CreateDestFolders = $false,
        [Parameter(Mandatory = $false, HelpMessage = "Specified if Files Need to be Move to Target")]
        [switch]$MoveFilestoTarget = $false
    )
    try {
    
        [String]$getdate = $null
        [String]$newfolder = $null
        $psfile = $PSScriptRoot + ".\Copy-SqlDBBackupDevice.ps1"
        if ($CreateDestFolders) {
            if (!(Test-Path -Path $SourcePath -PathType Container)) { Write-Host "Source Path Does Not exists $SourcePath, Use a Validate Path and Try Again"; Return  }
            #if (!(Test-Path -Path $TargetPath -PathType Container)) { Write-Host "Target Path Does Not exists $TargetPath, Use a Validate Path and Try Again"; Return  }

            $splitPos = $SourcePath.LastIndexOf('\')
            $tempname = $SourcePath.Substring($splitPos + 1)
            $getdate = (Get-Date).ToString("yyyyMMdd_HHmmss")
            $newfolder = $TargetPath + "\$tempname" + "_" + $getdate            
            if (!(Test-Path -Path $newfolder -PathType Container)) { New-Item -Path $newfolder -ItemType Directory }
            if ($MoveFilestoTarget) {
                .$psfile; Copy-SqlBackupDevices -SourcePath $SourcePath -TargetPath $newfolder -MoveFiles
            }
            else {
                .$psfile; Copy-SqlBackupDevices -SourcePath $SourcePath -TargetPath $newfolder
            }
            
        }
        else {
            if (!(Test-Path -Path $SourcePath -PathType Container)) { Write-Host "Source Path Does Not exists $SourcePath, Use a Validate Path and Try Again"; Return  }
            if (!(Test-Path -Path $TargetPath -PathType Container)) { Write-Host "Target Path Does Not exists $TargetPath, Use a Validate Path and Try Again"; Return  }
            
            if ($MoveFilestoTarget) {
                .$psfile; Copy-SqlBackupDevices -SourcePath $SourcePath -TargetPath $TargetPath -MoveFiles
            }
            else {
                .$psfile; Copy-SqlBackupDevices -SourcePath $SourcePath -TargetPath $TargetPath
            }
        }
        
    }
    catch [System.IO.DirectoryNotFoundException] {
        $errormsg = $_.Exception.Message
        Write-Warning -Message $errormsg
    }
    catch [System.IO.IOException] {
        $errormsg = $_.Exception.Message
        Write-Warning -Message $errormsg
    }
    catch {
        $errormsg = $_.Exception.Message
        Write-Warning -Message $errormsg
    }
}