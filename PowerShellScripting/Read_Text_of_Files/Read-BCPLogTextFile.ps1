<#
.SYNOPSIS
	This script read all lines in a BCP Log File trying to identified table name, rows to copy and rows copied
.DESCRIPTION
    This script read all lines in a BCP Log File trying to identified table name, rows to copy and rows copied
.PARAMETER FilePath
	BCP Files Source Path e.g: 'D:\SQL2012\backup\Log\BCPIN_LOG.txt'
.EXAMPLE 1
    . .\Read-BCPLogTextFile.PS1; Read-LogContent -FilePath "C:\DBA\PowerShell_Test\BCPIN_LOG.txt"
.EXAMPLE 2
    . .\Read-BCPLogTextFile.PS1; Read-LogContent -FilePath "C:\DBA\PowerShell_Test\BCPIN_LOG.log"    
.EXAMPLE 3
    . .\Read-BCPLogTextFile.PS1 -FilePath "C:\DBA\PowerShell_Test\BCPIN_LOG.log"    
.EXAMPLE 4
    . .\Read-BCPLogTextFile.PS1 -FilePath "BCPIN_LOG.log"    
.NOTES
	Author        :	Javier Montero  - 07/27/2018
    Version       :	1.0	
	Compatibility :	PS 3.0 or Higher
	SQL Ver       :	N/A
	VS IDE        : Visual Studio Code   
	TO GET HELP OR ANY NOTE HERE TYPE GET-HELP .\Read-BCPLogTextFile.PS1 -FULL
#>
param(
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Provide a BCP Log File Path")]
    [String]$BCPFilePath
)

function Confirm-File {
    param(
        [Parameter(Mandatory = $true, HelpMessage = "Folder or File Path Parameter is Required.")]
        [string]$FilePath
    )
    [boolean]$isfile = $false
    try {
        $response = [System.IO.File]::Exists($FilePath)
        if ($response) {            
            $isfile = $true
        }
        return $isfile
    }
    catch {
        Write-Host "Error Validating File Path. Message: " + $_.Exception.Message
        return $false
    }
}
function Read-LogContent {
    param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Provide a BCP Log File Path")]
        [String]$FilePath
    )
    if ($PSVersionTable.PSVersion.Major -lt 3) {
        [System.Windows.Forms.MessageBox]::Show("This Script Cannot be used in this system, PowerShell V3.0 or higher is required", "Amphora Inc. - Error", 0);
        Exit;
    }
    try {
        <#Local Variables#>
        $hashes = @()
        $tname
        $rows
        $rows_copied
        $result
        $comments

        $ScriptPath = $PSScriptRoot
        Write-Host $FilePath
        Write-Host $ScriptPath
        Write-Host "Validating If File Path Exists"
        Set-Location $ScriptPath
        $validate_file = Confirm-File -FilePath $FilePath
        if (!($validate_file)) {
            if (-not(Test-Path -path $FilePath -PathType Container)) {
                $temp_filepath = "$ScriptPath\$FilePath"
                if (Test-Path -Path $temp_filepath -PathType Leaf) {
                    $FilePath = $temp_filepath
                }
                else {
                    Write-Warning -Message "File or Folder Provided Does Not Exists or It is Wrong. Please Provide a Full File Path or File Name e.i. C:\MyFolder\MyBCPLogFile.log"
                    Write-Warning -Message "Process Aborted"
                    Write-Warning -Message "BCP Log Files Does Not Exists."
                    Write-Host "Script Table Results Saved on $ScriptPath\Results.txt"
                    "File Processed: " + "$FilePath\([System.IO.Path]::GetFileName($FilePath))" | Out-File "$ScriptPath\Results.txt" -Force
                    "File Processed at " + (Get-Date).ToString()                                | Out-File "$ScriptPath\Results.txt" -Append
                    "BCP Log Files Does Not Exists, No Rows Processed."                         | Out-File "$ScriptPath\Results.txt" -Append
                    Exit
                }
            }
        }
        if (Test-Path -Path $FilePath -PathType Leaf -Include "*.txt", "*.log" ) {
            
            #Get-Content -Path $FilePath
            $log_text = [System.IO.File]::ReadLines($FilePath) 
            if ($log_text.Length -gt 0) {
                
                foreach ($text_line in $log_text) {
                    $text = $text_line.ToUpper()
                    if ($text -like "BCPING DATA INTO THE*") {

                        <# ----Extraction Rows Amount to BCPing---- #>                        
                        $staridx = ($text_line.LastIndexOf("the") + 3)
                        $endidx = $text_line.LastIndexOf("table")
                        $lenght = $endidx - $staridx
                        $tname = ($text_line.Substring($staridx, $lenght)).Trim()

                        <# ----Extraction Rows Amount to BCPing---- #>
                        $sline = $text_line.Substring($text_line.LastIndexOf("=") + 1)
                        $starindex = $sline.LastIndexOf(")")
                        $remove_spaces = $sline.Substring(0, $starindex)
                        $rows = $remove_spaces.Trim()                        
                    }
                    if ($text -like "BCP COPY IN FAILED") {
                        $result = "FAILED"
                        $rows_copied = 0
                        $comments = 'FAILED'
                        $htable = [PSCustomObject]@{
                            TableName       = $tname
                            Est_RowCount    = $rows
                            Actual_RowCount = $rows_copied
                            Result          = $result
                            Comment         = $comments
                        }
                        <# ----Filling Up Hash Table to Final Result---- #>
                        $hashes += $htable
                    }
                    if ($text -like "*ROWS COPIED.") {
                        $nrows = $text.Substring(0, ($text_line.LastIndexOf("rows")))
                        $rows_copied = $nrows.Trim()
                        if ($rows_copied -eq $rows) {
                            $result = "Matched" 
                            $comments = ""
                        }                        
                        else {
                            $result = "FAILED"
                            $comments = "FAILED"
                        }
                        $htable = [PSCustomObject]@{
                            TableName       = $tname
                            Est_RowCount    = $rows
                            Actual_RowCount = $rows_copied
                            Result          = $result
                            Comment         = $comments
                        }
                        <# ----Filling Up Hash Table to Final Result---- #>
                        $hashes += $htable
                    }
                }
                $hashes | Format-Table -AutoSize                
                Write-Host "Script Table Results Saved on $ScriptPath\Results.txt"
                "File Processed: " + "$FilePath"                                            | Out-File "$ScriptPath\Results.txt" -Force
                "File Processed at " + (Get-Date).ToString()                                | Out-File "$ScriptPath\Results.txt" -Append
                $hashes | Format-Table -AutoSize                                            | Out-File "$ScriptPath\Results.txt" -Append
                
            }
            else {
                Write-Warning -Message "BCP Log Files is Empty."
                Write-Host "Script Table Results Saved on $ScriptPath\Results.txt"
                "File Processed: " + "$FilePath\([System.IO.Path]::GetFileName($FilePath))" | Out-File "$ScriptPath\Results.txt" -Force
                "File Processed at " + (Get-Date).ToString()                                | Out-File "$ScriptPath\Results.txt" -Append
                "BCP Log Files is Empty, No Rows Processed."                                | Out-File "$ScriptPath\Results.txt" -Append
            }
        }
        else {
            Write-Warning -Message "BCP Log Files Does Not Exists or It is was not provided."
            Write-Warning -Message "Please Provide a BCP Log File *.txt or *.log and Try Again."
        }
    }
    catch [System.IO.IOException] {
        Write-Host "IO File Exception"
        $error_msg = $_.Exception.Message
        Write-Warning -Message "Message: $error_msg"
    }
    catch {
        $error_msg = $_.Exception.Message
        Write-Warning -Message $error_msg
    }
}

#Invoking Read-Logcontent Function
Read-LogContent -FilePath $BCPFilePath