<#
.SYNOPSIS
	Script creates to copy or move a SQL DB backup Device to differente location or path
.DESCRIPTION
    This script does not refer to create or perform DB Backups actions on SQL Server Engine
	this script perform only actions to move or copy *.bak or *.trn files 	
	If destination path does not exists the script creates the folder path files will move or copy
.PARAMETER SourcePath
	Backup Files Source Path e.g: 'D:\SQL2012\backup\Staging_conc_trade_mar01'
.PARAMETER TargetPath
	Backup Destination Files Path e.g: 'D:\SQL2012\backup\Staging_conc_trade_mar01' or 'D:\SQL2012\backup\Staging'
.PARAMETER MoveFiles
	Specified if NEED TO BE move to Destination Path. By default FALSE
.EXAMPLE 1
	.\Copy-SqlDBBackupDevice.PS1; Copy-SqlBackupDevices -SourcePath C:\Temp -TargetPath C:\Temp\Test
.EXAMPLE 2
	.\Copy-SqlDBBackupDevice.PS1; Copy-SqlBackupDevices -SourcePath C:\Temp -TargetPath C:\Temp\Test -MoveFiles
.NOTES
	Author        :	Javier Montero  - 13/03/2018
    Version       :	1.0	
	Compatibility :	PS 3.0 or Higher
	SQL Ver       :	SQL Server 2008R2 or Higher
	VS IDE        : Visual Studio Code   
	TO GET HELP OR ANY NOTE HERE TYPE GET-HELP .\Copy-SqlDBBackupDevice.PS1 -FULL
#>
function Copy-SqlBackupDevices {
	Param(
		# Parameter help description
		[Parameter(Mandatory=$true, HelpMessage="Backup Files Source Path")]
		[String]$SourcePath,
        [Parameter(Mandatory = $true, HelpMessage="Backup Destination Files Path")]
        [String]$TargetPath,		
		[Parameter(Mandatory=$false, HelpMessage="Specified if files should move to Destination Path")]
		[switch]$MoveFiles = $false
	)
	$SourceFiles
	try {
		if ($TargetPath -eq $null -and $SourcePath -eq $null) { 
			Write-Host "Target Path Parameter need to be provided"
			 Exit
			}
			else {
				if(Test-Path -Path $SourcePath -PathType Container){
					$SourceFiles = Get-ChildItem -Path $SourcePath | Where-Object{$_.Extension -eq ".bak" -or $_.Extension -eq ".trn"}
					if ($SourceFiles.Count -gt 0) {
						if(Test-Path -Path $TargetPath -PathType Container){
							if($MoveFiles){
                            ForEach ($file in $SourceFiles) {
                                Move-Item $file.FullName -Destination $TargetPath -Force
                            }								
                            Write-Host "Backup files from $SourcePath to $TargetPath were Moved Successfully. " -BackgroundColor Green -ForegroundColor Yellow
							}
							else {
								ForEach($file in $SourceFiles){
                                Copy-Item $file.FullName -Destination $TargetPath -Force
								}								
                            Write-Host "Backup files from $SourcePath to $TargetPath were Copied Successfully. " -BackgroundColor Green -ForegroundColor Yellow
							}
						}
					} 
					else {
						Write-Host "Backup files Does not Exists on $SourcePath Path Please Validate if Path contains Backup Files and Try Again." -BackgroundColor Red -ForegroundColor White		
					}
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