/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [PrevYearFileQ3],
		FILENAME = '$(PRTData)$(DefaultFilePrefix)_PrevYearFileQ3.ndf'
	)
	TO FILEGROUP PrevYearFGQ03;
GO
	
