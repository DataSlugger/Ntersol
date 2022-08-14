begin{
    $null = [reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo")
        $null = [reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum")
        $null = [reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")        
}
process{
    function ExecScriptFile{
        Param(
            [Parameter(Position = 0, Mandatory = $true)]
            $DatabaseObj,
            [Parameter(Position = 1, Mandatory = $true)]
            $scripFile
        )
        try {
            $extype = [Microsoft.SqlServer.Management.Common.ExecutionTypes]::ContinueOnError
            $commandtxt = [System.IO.File]::ReadAllText($scripFile.FullName)
            Write-Host "Creating Database Object $scripFile.Name"
            $DatabaseObj.ExecuteNonQuery($commandtxt, $extype)
        }
        catch {
            $error_msg = $_.Exception.Message
            Write-Host $error_msg
        }
    }

    function SqlExecuteScriptFiles {
        param(
            [Parameter(Position = 0, Mandatory = $true)]
            [string]$srvinstance,
            [Parameter(Position = 1, Mandatory = $true)]
            [string]$dbuser,
            [Parameter(Position = 2, Mandatory = $true)]
            [string]$dbuspassw,
            [Parameter(Position = 3, Mandatory = $true)]
            [string]$dbname,
            [Parameter(Position = 4, Mandatory = $true)]
            $SqlScriptsPath
        )
        try {
            
            
            $srv = New-Object ("Microsoft.SqlServer.Management.Smo.Server") $srvinstance
            $srv.connectioncontext.LoginSecure = $false;
            $srv.ConnectionContext.set_login($dbuser)
            $srv.ConnectionContext.set_password($dbuspassw)
            $db = $srv.Databases[$dbname]
            $scripts_dataset = Get-ChildItem -Path $SqlScriptsPath -Filter "*.sql"
            $d = $scripts_dataset.count
            $time_str = (Get-Date).ToString("MM/dd/yyyy HH:mm:ss")
            Write-Host $time_str
            Write-Host "total files $d"
            foreach ($script in $scripts_dataset) {
                #$commandtxt = New-Object System.IO.StreamReader($script)
                #$sr = $commandtxt.ReadToEnd()                
                #SqlExecNonQuery -srvinstance "THEBEAST.icts.local\SQLSVR10" -dbuser "tc_admin" -dbuspassw "Tr8dDb@" -dbname "ITT_ineos_trade" -SqlCmdTxt $commandtxt
                ExecScriptFile -DatabaseObj $db -scripFile $script
            }
            $time_end = (Get-Date).ToString("MM/dd/yyyy HH:mm:ss")
            Write-Host $time_end
            #$db.ExecuteNonQuery($SqlCmdTxt, $extype)
            
        }
        catch {
            $error_msg = $_.Exception.Message
            Write-Host $error_msg
        }    
        
    }    
    SqlExecuteScriptFiles -srvinstance "THEBEAST.icts.local\SQLSVR10" -dbuser "tc_admin" -dbuspassw "Tr8dDb@" -dbname "ITT_ineos_trade" -SqlScriptsPath "C:\DBA\SQLDBAWorkShop2\Projects\Coordinators_Manager\Powershell\ConfirmMgr_DBCleanCreation\Ineos_Trade\Triggers"
}
#$commandtxt = Get-Content -Path "C:\DBA\SQLDBAWorkShop2\Projects\Coordinators_Manager\Powershell\ConfirmMgr_DBCleanCreation\Tables\dbo.ABCPortDatabase.sql" -raw

#$commandtxt = [System.IO.File]::ReadAllText("C:\DBA\SQLDBAWorkShop2\Projects\Coordinators_Manager\Powershell\ConfirmMgr_DBCleanCreation\Tables\dbo.ABCPortDatabase.sql")

