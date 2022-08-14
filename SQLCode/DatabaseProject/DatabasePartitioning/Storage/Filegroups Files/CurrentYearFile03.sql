/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [CurrentYearFile03],
		FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile03.ndf'
	)
	TO FILEGROUP CurrentYearFG03;
GO
	
