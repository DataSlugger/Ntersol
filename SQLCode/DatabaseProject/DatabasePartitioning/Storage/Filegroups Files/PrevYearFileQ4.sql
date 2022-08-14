/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [PrevYearFileQ4],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_PrevYearFileQ4.ndf'
	) TO FILEGROUP PrevYearFGQ04
GO
	
