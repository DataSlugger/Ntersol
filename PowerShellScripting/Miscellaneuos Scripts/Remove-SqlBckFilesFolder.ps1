<#
.SYNOPSIS
	Script creates to clean up [PERMANENT DELETE] a SQL DB backup Device Folder and Files
.DESCRIPTION

.PARAMETER FolderPath
    Refer Source Files Path
.Parameter RetentionDays
    Refer to File Creation to Keep Saved on Folder Path, if RetentionDays is 0 the script delete all files and folder present
    By Default is 0
.EXAMPLE 1
	.\Remove-SqlBckFilesFolder.PS1; Remove-SqlBckFilesFolder -FolderPath "c:\temp" -RetentionDays 6
.EXAMPLE 2
	.\Remove-SqlBckFilesFolder.PS1; Remove-SqlBckFilesFolder -FolderPath "c:\temp" -RetentionDays 1
.EXAMPLE 3
    .\Remove-SqlBckFilesFolder.PS1; Remove-SqlBckFilesFolder -FolderPath "c:\temp"
    If RetentionDays is not specified the script use default value 0 and remove all files and folder present in FolderPath    
.NOTES
	Author        :	Javier Montero  - 13/03/2018
    Version       :	1.0	
	Compatibility :	PS 3.0 or Higher
	SQL Ver       :	SQL Server 2008R2 or Higher
	VS IDE        : Visual Studio Code   
	TO GET HELP OR ANY NOTE HERE TYPE GET-HELP .\Remove-SqlBckFilesFolder.PS1 -FULL
#>

function Remove-SqlBckFilesFolder{
    Param(
        [Parameter(Mandatory=$true)]
        [String]$FolderPath,
        [Parameter(Mandatory=$false, HelpMessage="Retention Days")]
        [int]$RetentionDays = 0
    )
    try {
        if (Test-Path -Path $FolderPath -PathType Container) {
            if ($RetentionDays -gt 0) {
                $dateCutOff = (Get-Date).AddDays(-$RetentionDays)
                $folderListArray = Get-ChildItem -Path $FolderPath -Directory | Where-Object{$_.CreationTime -lt $dateCutOff}
                foreach($folder in $folderListArray){
                    Write-Host $folder.FullName
                }
            }
            else {
                $folderListArray = Get-ChildItem -Path $FolderPath -Directory
                foreach ($folder in $folderListArray) {
                    Write-Host $folder.PSChildName
                }
            }
        }
    }
    catch [System.IO.DirectoryNotFoundException]{
        $errormsg = $_.Exception.Message
        Write-Warning -Message $errormsg
    }
    catch [System.IO.IOException]{
        $errormsg = $_.Exception.Message
        Write-Warning -Message $errormsg
    }
    catch{
        $errormsg = $_.Exception.Message
        Write-Warning -Message $errormsg
    }
}