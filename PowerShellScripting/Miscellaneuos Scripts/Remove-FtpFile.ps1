function Remove-FTPFiles {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [String]$FTPFileUrl,
        [Parameter(Mandatory = $true, Position = 1)]
        [String]$FTPUser,
        [Parameter(Mandatory = $true, Position = 2)]
        [String]$FTPUserPass,
        [Parameter(Mandatory = $false, Position = 3)]
        [int]$RetentionDays,
        [Parameter(Mandatory = $false, Position = 4)]
        [Switch]$AllFiles
    )
    try {
        if ($AllFiles) {
            
        }
        else {
            if ($RetentionDays) {
                $date = Get-FileLastWriteDate -FTPFileUrl $FTPFileUrl -FTPUser $FTPUser -FTPUserPass $FTPUserPass
                if ($date -lt [DateTime]::Now.AddDays(-$RetentionDays)) {
                    Write-host "True"            
                }                     
            }
            else {
                    Write-Host "RetentionDays value is required to make date comparison, please provide it and try again."
                }           
        }
        
    }
    catch {
        
    }
}
function Get-FileLastWriteDate{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [String]$FTPFileUrl,
        [Parameter(Mandatory = $true, Position = 1)]
        [String]$FTPUser,
        [Parameter(Mandatory = $true, Position = 2)]
        [String]$FTPUserPass        
    )
    try {
        $FTPRequest = [System.Net.WebRequest]::Create($FTPFileUrl)
        $FTPRequest.Credentials = New-Object System.Net.NetworkCredential($FTPUser, $FTPUserPass)
        $FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::GetDateTimestamp
        $response = $FTPRequest.GetResponse()
        $temp = $response.StatusDescription
        $temp = $temp.Substring($temp.LastIndexOf(" ")+1)
        $FileCreationDateTime = $temp.Substring(0,4) + "-" + $temp.Substring(4,2) + "-" + $temp.Substring(6,2)
        [Datetime]$FileDate = "1900-01-01"
        if ($FileCreationDateTime -ne " ") {
            $FileDate = $FileCreationDateTime
        }
        return $FileDate
    }
    catch {
        
    }
}

Remove-FTPFiles -FTPFileUrl 'ftp://ftp.smarterasp.net/wansoftobi/DEV_peach_trade_BACKUP_20180406_192702_0.BAK' -FTPUser 'jmontero19-001' -FTPUserPass 'Provider$2015' -RetentionDays 5