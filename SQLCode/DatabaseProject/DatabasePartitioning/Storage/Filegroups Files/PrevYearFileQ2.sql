/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [PrevYearFileQ2],
		FILENAME = '$(PRTData)$(DefaultFilePrefix)_PrevYearFileQ2.ndf'
	)
	TO FILEGROUP PrevYearFGQ02;
GO
	
