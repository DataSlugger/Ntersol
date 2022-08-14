﻿/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [CurrentYearFile00],
		FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile00.ndf'
	)
	TO FILEGROUP CurrentYearFG00;
GO
	