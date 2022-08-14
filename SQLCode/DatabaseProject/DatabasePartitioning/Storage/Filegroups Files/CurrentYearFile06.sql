/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [CurrentYearFile06],
		FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile06.ndf'
	)
	TO FILEGROUP CurrentYearFG06;
	GO
	
