CREATE PARTITION FUNCTION [PF_OldestYears]
	(
		DATE
	)
	AS RANGE LEFT
	FOR VALUES (
		'2019-12-31 23:59:59.99999'
	);
GO
