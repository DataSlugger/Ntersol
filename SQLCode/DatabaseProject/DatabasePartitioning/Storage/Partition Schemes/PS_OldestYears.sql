CREATE PARTITION SCHEME [PS_OldestYears]
	AS PARTITION [PF_OldestYears]
	TO (
		[OldestYearsFG],
		[OldestYearsFG]
	);
GO
