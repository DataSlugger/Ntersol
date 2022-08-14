/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [CurrentYearFile01],
		FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile01.ndf'
	) TO FILEGROUP CurrentYearFG01

GO