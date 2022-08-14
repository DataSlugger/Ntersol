function Delete-FtpFile{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [System.String]$FtpURL,
        [Parameter(Mandatory = $true, Position = 1)]
        [System.String]$FtpUser,
        [Parameter(Mandatory = $true, Position = 2)]
        [System.String]$FtpUserPassword
    )
    try {
       
    }
    catch {
        
    }
}
function Move-FilestoFTP{
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [System.String]$FtpURL,
        [Parameter(Mandatory = $true, Position = 1)]
        [System.String]$FtpUser,
        [Parameter(Mandatory = $true, Position = 2)]
        [System.String]$FtpUserPassword,
        [Parameter(Mandatory = $true, Position = 3)]
        [System.String]$FilesPath,
        [Parameter(Position = 4)]
        [Switch]$DownloadFile
    )
    try {
        $webclient = New-Object System.Net.WebClient
        $webclient.Credentials = New-Object System.Net.NetworkCredential($FtpUser, $FtpUserPassword)

        if(Test-Path -Path $FilesPath -PathType Container){
            $file = Get-ChildItem -Path $FilesPath -Filter '*.bak'
            $url = "ftp://$FtpURL/$($file.Name)"
            $uri = New-Object System.Uri($url)
            if ($DownloadFile) {
                
            }
            else {
                $webclient.UploadFile($uri, $file.FullName)
                $recipients = "javier.montero@amphorainc.com"
                Send-MailMessage -to $recipients -From "SymphonyServiceMonitor@amphorainc.com" -Subject "Ftp Copy Database [DEV_peach_trade] Backup Report" -Body "Automacally FTP Copy Database Backup Task was completed successfully to $FtpURL " -BodyAsHtml -SmtpServer "housp00" -Port 587
                
            }
        }
        
    }
    catch {
        $msg_error = $_.Exception.Message
        Write-Warning -Message $msg_error
    }
}

Move-FilestoFTP -FtpURL "ftp.smarterasp.net/wansoftobi/" -FtpUser "jmontero19-001" -FtpUserPassword 'Provider$2015' -FilesPath 'C:\Temp\ftp'