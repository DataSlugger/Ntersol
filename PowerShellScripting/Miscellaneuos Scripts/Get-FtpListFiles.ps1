function Get-FtpFileList{
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [String]$FTPUrl,
        [Parameter(Mandatory = $true, Position = 1)]
        [String]$FTPUser,
        [Parameter(Mandatory = $true, Position = 2)]
        [String]$FTPPass,
        [Parameter(Mandatory = $false, Position = 3)]
        [String]$FilterbyExtension,
        [Parameter(Mandatory = $false, Position = 4)]
        [switch]$AllFiles
    )
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.Credentials = New-Object System.Net.NetworkCredential($FTPUser, $FTPPass)
        $request = [Net.FtpWebRequest]::Create($FTPUrl)
        $request.Credentials = $webClient.Credentials
        $request.Method = [System.Net.WebRequestMethods+FTP]::ListDirectory
        #$directoryInfo = $request.GetResponse().GetResponseStream()
        #(New-Object IO.StreamReader $request.GetResponse().GetResponseStream()).ReadToEnd() -split "`r`n"       

        $FTPResponse = $request.GetResponse()
        $ResponseStream = $FTPResponse.GetResponseStream()
        $StreamReader = New-Object System.IO.StreamReader $ResponseStream
        $files = New-Object System.Collections.ArrayList
        
        if($FTPUrl[-1] -notmatch '/'){
            $FTPUrl+='/'
        }
        if ($AllFiles) {
            While ($file = $StreamReader.ReadLine()) {
                #Where-Object {$file -like '*.BAK'}
                    [void] $files.Add("$FTPUrl$file")                
                #Write-Host $FTPUrl$file | Where-Object {$file -like '*.BAK'}
            }    
        }
        else {
            While ($file = $StreamReader.ReadLine()) {
                #Where-Object {$file -like '*.BAK'}
                if ($file -like $FilterbyExtension) {
                    [void] $files.Add("$FTPUrl$file")
                }
                #Write-Host $FTPUrl$file | Where-Object {$file -like '*.BAK'}
            }
        }
    }
    catch {
        $error = $_.Exception.Message
        Write-host $error
    }
    return $files
}
Get-FtpFileList -FTPUrl "ftp://ftp.smarterasp.net/wansoftobi/" -FTPUser "jmontero19-001" -FTPPass 'Provider$2015' -FilterbyExtension '*.bak'
#Get-FtpFileList -FTPUrl "ftp://ftp.smarterasp.net/wansoftobi" -FTPUser "jmontero19-001" -FTPPass 'Provider$2015' -AllFiles
