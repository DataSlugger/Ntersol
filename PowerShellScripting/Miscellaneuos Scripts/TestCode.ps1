$sqlpackagedac = 'C:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe'

$user = 'tc_admin'
$password = 'Tr8dDb@'
$SourceServer = 'HOUCOM200-PC\SQLSVR14'
$SourceDB = 'DBATestDBSql2016' 
$TargetServer = 'HOUCOM200-PC\SQLSVR14'
$TargetDB = 'CompareDB'

    $output = & "$sqlpackagedac" /of:true /a:Extract /SourceConnectionString:"Data Source=$SourceServer;User ID=jmontero; Password=jmontero; Initial Catalog=$SourceDB" /tf:'C:\DBA\Test2\SourceDB.dacpac'

    $output1 = & "$sqlpackagedac" /a:Extract /SourceConnectionString:"Data Source=$TargetServer;User ID=jmontero; Password=jmontero; Initial Catalog=$TargetDB" /tf:'C:\DBA\Test2\TargetDB.dacpac'

    write-host $output
    Write-Host $output1

    $out = & "$sqlpackagedac" /a:Script /sf:'C:\DBA\Test2\SourceDB.dacpac' /tf:'C:\DBA\Test2\TargetDB.dacpac' /tdn:$TargetDB /op:'C:\DBA\Test2\outputfile.sql'

# add path for SQLPackage.exe
#IF (-not ($env:Path).Contains( "C:\program files\microsoft sql server\130\DAC\bin"))
#{ $env:path = $env:path + ";C:\program files\microsoft sql server\130\DAC\bin;" }

# sqlpackage /a:extract /of:true /scs:"server=.\sql2016;database=db_source;trusted_connection=true" /tf:"C:\test\db_source.dacpac";

# sqlpackage.exe /a:deployreport /op:"c:\test\report.xml" /of:True /sf:"C:\test\db_source.dacpac" /tcs:"server=.\sql2016; database=db_target;trusted_connection=True" 
Write-Host "Display Report"
#& "$sqlpackagedac" /a:deployreport /op:"C:\DBA\Test2\report.xml" /of:True /sf:"C:\DBA\Test2\SourceDB.dacpac" /tcs:"Data Source=$TargetServer;User ID=jmontero; Password=jmontero; Initial Catalog=$TargetDB" 
& "$sqlpackagedac" /a:deployreport /op:"C:\DBA\Test2\report.xml" /of:True /sf:"C:\DBA\Test2\SourceDB.dacpac" /tf:'C:\DBA\Test2\TargetDB.dacpac' /tdn:$TargetDB /p:DropObjectsNotInSource=True
[xml]$x = gc -Path "C:\DBA\Test2\report.xml";
$x.DeploymentReport.Operations.Operation |
    ForEach-Object -Begin {$a = @();} -process {$name = $_.name; $_.Item | ForEach-Object {$r = New-Object PSObject -Property @{Operation = $name; Value = $_.Value; Type = $_.Type};$a += $r; } } -End {$a}

    
        #Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
        Add-Type -AssemblyName "Microsoft.SqlServer.SMO, Version=13.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
        $serverName = New-Object Microsoft.SqlServer.Management.Smo.Server $SourceServer
    $dacpath = "$env:ProgramFiles\Microsoft SQL Server\140\DAC\Bin\Microsoft.SqlServer.Dac.dll"
    #[Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.Management.Dac')
    Add-Type -Path $dacpath
    [System.version]$version = "1.0.0.0"
    #$applicationName = "MyApplication"
    $connstring = "Data Source=$TargetServer;User ID=jmontero; Password=jmontero; Initial Catalog=$TargetDB"
    $te = New-Object Microsoft.SqlServer.Dac.DacServices $connstring
    $deployoptions = New-Object Microsoft.SqlServer.Dac.DacDeployOptions
    $deployoptions.DropObjectsNotInSource = $true
    $deployoptions.IgnorePermissions = $true

    #$te = New-Object Microsoft.SqlServer.Management.Dac.DacExtractionUnit($serverName)
     
    #$te.Description = "This is a DAC Test"
    $DacLocation = "C:\DBA\Test2\SourceDBTest.dacpac"
    $TargetDacPac = 'C:\DBA\Test2\TargetDB.dacpac'
    #$te.Extract($DacLocation)
    $te.Extract($DacLocation, $SourceDB, $SourceDB, $version)
    $dp = [Microsoft.SqlServer.Dac.DacPackage]::Load($DacLocation)
    $tp = [Microsoft.SqlServer.Dac.DacPackage]::Load($TargetDacPac)
    [xml]$result = $te.GenerateDeployReport($dp, $TargetDB, $deployoptions)
    $result
    $result | Out-File -FilePath "C:\DBA\Test2\Result.xml" -Force
    $d = @();
     $result.DeploymentReport.Operations.Operation | 
        ForEach-Object -Begin {$a = @();} -process {$name = $_.name; $_.Item | ForEach-Object {$r = New-Object PSObject -Property @{Operation = $name; Value = $_.Value; Type = $_.Type};$a += $r; } } -End {$d = $a}
    $d

   

class dacpacx{
    [string] $Name;
    [string] $NewTech;

    dacpacx([String] $newname, [string] $NNewTech){
        $this.Name = $newname;
        $this.NewTech = $NNewTech;
    }

}

$NewSith = ([dacpacx]::new('Tiderius', 'Master'))
$NewSith
