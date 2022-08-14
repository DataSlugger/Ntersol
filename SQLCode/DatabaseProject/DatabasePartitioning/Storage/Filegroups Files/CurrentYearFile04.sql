/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [CurrentYearFile04],
		FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile04.ndf'
	)
	TO FILEGROUP CurrentYearFG04;
	GO
	
