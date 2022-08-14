CREATE PARTITION SCHEME [PS_CurrentYear]
	AS PARTITION [PF_CurrentYear]
	TO (
	[CurrentYearFG00],
	[CurrentYearFG01],
	[CurrentYearFG02],
	[CurrentYearFG03],
	[CurrentYearFG04],
	[CurrentYearFG05],
	[CurrentYearFG06],
	[CurrentYearFG07],
	[CurrentYearFG08],
	[CurrentYearFG09],
	[CurrentYearFG10],
	[CurrentYearFG11],
	[CurrentYearFG12],
	[CurrentYearFG13]
	);
GO
