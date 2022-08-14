/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [CurrentYearFile08],
		FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile08.ndf'
	)
	TO FILEGROUP CurrentYearFG08;
	GO
	
