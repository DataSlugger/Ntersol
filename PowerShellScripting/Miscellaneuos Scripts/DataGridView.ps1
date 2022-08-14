$user = 'tc_admin'
$password = 'Tr8dDb@'
$SourceServer = 'HOUCOM200-PC\SQLSVR14'
$SourceDB = 'DBATestDBSql2016' 
$TargetServer = 'HOUCOM200-PC\SQLSVR14'
$TargetDB = 'CompareDB'

function Get-DacList {
    try {
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
        #$TargetDacPac = 'C:\DBA\Test2\TargetDB.dacpac'
        #$te.Extract($DacLocation)
        $t = $te.Extract($DacLocation, $SourceDB, $SourceDB, $version)
        $dp = [Microsoft.SqlServer.Dac.DacPackage]::Load($DacLocation)
        #$tp = [Microsoft.SqlServer.Dac.DacPackage]::Load($TargetDacPac)
        [xml]$result = $te.GenerateDeployReport($dp, $TargetDB, $deployoptions)
        #$result
        $result | Out-File -FilePath "C:\DBA\Test2\Result.xml" -Force
        $d = @();
        $result.DeploymentReport.Operations.Operation | 
            ForEach-Object -Begin {$a = @(); } -process {$name = $_.name; $_.Item | ForEach-Object {$r = New-Object PSObject -Property @{Operation = $name; Value = $_.Value; Type = $_.Type}; $a += $r; } } -End {$d = $a}
       
        return $result
    }
    catch {
        $error_msg = $_.Exception.Message
        Write-Warning -Message $error_msg
    }
}

class DacPacGrid{
    [String]$Operation;
    [String]$ObjType;
    [String]$ObjName;

    DacPacGrid([String]$NewOperation,[String]$NewObjType,[String]$NewObjName){
        $this.Operation = $NewOperation;
        $this.ObjType = $NewObjType;
        $this.ObjName = $NewObjName;
    }
}
class GridMembers {
    [String]$Name;
    [String]$Age;
    [String]$Sex;
    [String]$City;

    GridMembers([String]$NewName, [String]$NewAge, [String]$NewSex, [String]$NewCity){
        $this.Name = $NewName;
        $this.Age = $NewAge;
        $this.Sex = $NewSex;
        $this.City = $NewCity;
    }
}
$assemblielist = "PresentationFramework",
                 "PresentationCore",
                 "WindowsBase"                 
foreach($assembly in $assemblielist){
    $assembly = Add-Type -AssemblyName $assembly
}

[XML]$xaml = @'
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:PSForms"        
        Title="DataGrid" Height="400.017" Width="500.873">
    <Grid>
        <DataGrid Name="DGView" HorizontalAlignment="Stretch" ColumnWidth="100" Height="186" Margin="28,21,0,0" VerticalAlignment="Top" Width="400" ItemsSource="{Binding lgview}" >
         <DataGrid.GroupStyle>
         <GroupStyle>
                    <GroupStyle.HeaderTemplate>
                        <DataTemplate>
                            <StackPanel>
                                <TextBlock Text="{Binding Path=Name}" />
                            </StackPanel>
                        </DataTemplate>
                    </GroupStyle.HeaderTemplate>
                     <GroupStyle.ContainerStyle>
                    <Style TargetType="{x:Type GroupItem}">
                        <Setter Property="Template">
                            <Setter.Value>
                               <ControlTemplate TargetType="{x:Type GroupItem}">
                                <Expander>
                                    <Expander.Header>
                                        <StackPanel Orientation="Horizontal">
                                            <TextBlock Text= "{Binding Path=Name}"/>                                           
                                        </StackPanel>
                                    </Expander.Header>
                                    <ItemsPresenter/>
                                </Expander>
                            </ControlTemplate>
                           </Setter.Value>
                        </Setter>
                    </Style>
                </GroupStyle.ContainerStyle>
                </GroupStyle>   
         <GroupStyle>
                <GroupStyle.HeaderTemplate>
                    <DataTemplate>
                        <StackPanel>
                            <TextBlock Text="{Binding Path=Name}" Margin="0,0,5,0" />
                        </StackPanel>
                    </DataTemplate>
                </GroupStyle.HeaderTemplate>
                <GroupStyle.ContainerStyle>
                    <Style TargetType="{x:Type GroupItem}">
                        <Setter Property="Template">
                            <Setter.Value>
                               <ControlTemplate TargetType="{x:Type GroupItem}">
                                <Expander>
                                    <Expander.Header>
                                        <StackPanel Orientation="Horizontal" Margin="0,0,5,0">
                                            <TextBlock Text= "{Binding Path=Name}"/>
                                            <TextBlock Text=":" Margin="0 0 5 0" />
                                            <TextBlock Text= "{Binding Path=ItemCount}" />
                                            <TextBlock Text=" Items"/>
                                        </StackPanel>
                                    </Expander.Header>
                                    <ItemsPresenter/>
                                </Expander>
                            </ControlTemplate>
                           </Setter.Value>
                        </Setter>
                    </Style>
                </GroupStyle.ContainerStyle>
            </GroupStyle>
        </DataGrid.GroupStyle>
         </DataGrid>
    </Grid>
</Window>
'@
$reader = (New-Object Xml.XmlNodeReader $xaml) 
$GUIWindow = [Windows.Markup.XamlReader]::Load( $reader ) 

$xaml.SelectNodes('//*[@Name]') | ForEach-Object {Set-Variable -Name ($_.Name) -Value $GUIWindow.FindName($_.Name)}
$DGView = $GUIWindow.FindName('DGView')
$data = @() 
<#$data += New-Object PSObject -prop @{Name = 'James'; Age = '31'; Sex = 'Male'; City = 'Houston'}
$data += New-Object PSObject -prop @{Name = 'Sam'; Age = '31'; Sex = 'Male'; City = 'Houston'}
$data += New-Object PSObject -prop @{Name = 'John'; Age = '24'; Sex = 'Male'; City = 'Dallas'}
$data += New-Object PSObject -prop @{Name = 'Gina'; Age = '32'; Sex = 'Female'; City = 'Houston'}
$data += New-Object PSObject -prop @{Name = 'Tyler'; Age = '42'; Sex = 'Male'; City = 'Dallas'}#>

$data += ([GridMembers]::new('James','31','Male','Houston'))
$data += ([GridMembers]::new('Sam', '31', 'Male', 'Houston'))
$data += ([GridMembers]::new('John', '24', 'Male', 'Dallas'))
$data += ([GridMembers]::new('Gina', '32', 'Female', 'Houston'))
$data += ([GridMembers]::new('Tyler', '42', 'Male', 'Dallas'))
#ForEach-Object {$name = $_.name; $_.Item | ForEach-Object { $items1 = ([DacPacGrid]::new($name, $_.Type, $_.Value)); $items += $items1;}} -End {}
#ForEach-Object { $items += ([DacPacGrid]::new($_.name, $_.Item.Type, $_.Item.Value)) }
$x = Get-DacList
$items = @();
foreach($operation in $x.DeploymentReport.Operations.Operation){
    $a = $operation.Name
    foreach($item in $operation.Item){
        $value = $item.Value;
        $obj   = $item.Type;
        $items += ([DacPacGrid]::New($a, $obj, $value))
    }
}
<#foreach($element in $x){
    $a = $operation.Name
    $value = $item.Value;
        $obj   = $item.Type
}#>

$items


#$lview = [System.Windows.Data.ListCollectionView]$data
$lview = [System.Windows.Data.ListCollectionView]$items
$lview.GroupDescriptions.Add((new-object System.Windows.Data.PropertyGroupDescription 'Operation'))
$lview.GroupDescriptions.Add((new-object System.Windows.Data.PropertyGroupDescription 'ObjType'))
$DGView.ItemsSource = $lview


$GUIWindow.ShowDialog() | out-null

