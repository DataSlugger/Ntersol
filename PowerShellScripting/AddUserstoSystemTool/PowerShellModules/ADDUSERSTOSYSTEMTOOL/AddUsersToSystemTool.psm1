Get-ChildItem -Path $env:USERPROFILE\Documents\WindowsPowerShell\Modules\ADDUSERTOSYSTEMTOOL\*.ps1 -Exclude *test.ps1 | 
ForEach-Object {
	. $_.FullName
}