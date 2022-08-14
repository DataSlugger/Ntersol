CREATE PARTITION SCHEME [PS_PrevYear]
	AS PARTITION [PF_PrevYear]
	TO (
	[PrevYearFGQ02],
	[PrevYearFGQ03],
	[PrevYearFGQ04]
	);
GO
