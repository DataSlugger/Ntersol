/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [OldestYearsFile],
		FILENAME = '$(PRTData)$(DefaultFilePrefix)_OldestYearsFile.ndf'
	)
	TO FILEGROUP OldestYearsFG;
GO
	
