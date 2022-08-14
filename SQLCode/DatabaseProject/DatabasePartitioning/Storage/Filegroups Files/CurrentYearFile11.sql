/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [CurrentYearFile11],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_CurrentYearFile11.ndf'
	)
	TO FILEGROUP CurrentYearFG11
GO
