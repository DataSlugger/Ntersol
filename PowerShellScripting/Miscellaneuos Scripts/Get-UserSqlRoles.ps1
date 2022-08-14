begin{
    $assemblyList = "Microsoft.SqlServer.Smo",
    "Microsoft.SqlServer.SmoExtended",
    "Microsoft.SqlServer.ConnectionInfo",
    "Microsoft.SqlServer.Smo.Enum"
    
    foreach($assembly in $assemblyList){
        $assembly = [System.Reflection.Assembly]::LoadWitPartialName($assembly) | Out-Null
    }    
}
process{
    function Get-UserRoles {
        Param(
            [Parameter(Mandatory=$true, Position=0)]
            $ObjServer,
            [Parameter(Mandatory=$true, Position=1)]
            [String]$UserToValidate
        )
        try {
            $Connection = New-Object Microsoft.SqlServer.Management
        }
        catch {
            
        }
    }
}