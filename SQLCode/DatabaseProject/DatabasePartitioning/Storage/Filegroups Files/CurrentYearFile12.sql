/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [CurrentYearFile12],
		FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile12.ndf'
	)
	TO FILEGROUP CurrentYearFG12;
GO 
	
