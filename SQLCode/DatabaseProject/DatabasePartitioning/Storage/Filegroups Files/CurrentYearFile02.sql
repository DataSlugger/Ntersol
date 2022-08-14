/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [CurrentYearFile02],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_CurrentYearFile02.ndf'
	)
	TO FILEGROUP CurrentYearFG02
