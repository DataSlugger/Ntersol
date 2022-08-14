/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [CurrentYearFile13],
		FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile13.ndf'
	)
	TO FILEGROUP CurrentYearFG13;
GO

	
