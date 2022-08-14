/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [CurrentYearFile09],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_CurrentYearFile09.ndf'
	)
	TO FileGroup CurrentYearFG09
GO
