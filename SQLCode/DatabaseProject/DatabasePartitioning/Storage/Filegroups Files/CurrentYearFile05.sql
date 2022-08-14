/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [CurrentYearFile05],
		FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile05.ndf'
	)
	TO FILEGROUP CurrentYearFG05;
	GO
	
