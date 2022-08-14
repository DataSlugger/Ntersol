<#$assemblylist = "presentationframework",
"Microsoft.SqlServer.Management.Common",
"Microsoft.SqlServer.Smo",
"PresentationCore",
"WindowsBase",
"System.Windows.Forms",
"System.Windows.Controls"
foreach ($assembly in $assemblylist) {
    $assembly = [System.Reflection.Assembly]::LoadWithPartialName($assembly)
}#>

Add-Type -AssemblyName "presentationframework"
Add-Type -AssemblyName "PresentationCore"
Add-Type -AssemblyName "WindowsBase"

[xml]$xaml = @'
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:PSForms"        
        Title="ListViewForm" Height="350" Width="525">
    <Grid>
        <StackPanel HorizontalAlignment="Left" Height="100" Margin="109,118,0,0" VerticalAlignment="Top" Width="100">
            <ListView Name="combobox" Height="100" Width="200" Margin="10,20,0,0">                
                    <ListView.GroupStyle>
                        <GroupStyle>
                            <GroupStyle.HeaderTemplate>
                                <DataTemplate>
                                    <TextBlock Text="{Binding Name}" />
                                </DataTemplate>
                            </GroupStyle.HeaderTemplate>
                        </GroupStyle>
                    </ListView.GroupStyle>
                    <ListView.ItemTemplate>
                        <DataTemplate>
                            <StackPanel>
                            <TextBlock Text="{Binding Name}"/>
                            </StackPanel>
                        </DataTemplate>
                    </ListView.ItemTemplate>                
            </ListView>
        </StackPanel>
    </Grid>
</Window>
'@

$reader = (New-Object Xml.XmlNodeReader $xaml) 
$GUIWindow = [Windows.Markup.XamlReader]::Load( $reader ) 

$xaml.SelectNodes('//*[@Name]') | % {Set-Variable -Name ($_.Name) -Value $GUIWindow.FindName($_.Name)}

$data = @() 
$data += New-Object PSObject -prop @{Name = 'James'; Age = '31'; Sex = 'Male'}
$data += New-Object PSObject -prop @{Name = 'John'; Age ='24'; Sex = 'Male'}
$data += New-Object PSObject -prop @{Name = 'Gina'; Age = '32'; Sex = 'Male'}
$data += New-Object PSObject -prop @{Name = 'Tyler'; Age = '42'; Sex = 'Female'}

$lview = [System.Windows.Data.ListCollectionView]$data
$lview.GroupDescriptions.Add((new-object System.Windows.Data.PropertyGroupDescription 'Sex'))
$comboBox.ItemsSource = $lview


$GUIWindow.ShowDialog() | out-null