<#
.NOTE
    Created by  : Javier Montero
    Version     : 01/03/2017
    Description : Script created to copy DEMO DEPOT backup files to THEBEAST server then refresh DEMO Staging env    
#>
Write-Host "Copy DEMO DEPOT PASS backup files..."
Copy-Item -Path D:\SQL2012\Backup\DEMO_amphora_pass -Destination \\thebeast.icts.local\d$\DBREFRESHAUTOMATE\ -Recurse -Filter *.bak -Force -Verbose 