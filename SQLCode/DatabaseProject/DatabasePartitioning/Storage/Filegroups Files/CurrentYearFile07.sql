/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [CurrentYearFile07],
		FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile07.ndf'
	)
	TO FILEGROUP CurrentYearFG07;
GO 
	
