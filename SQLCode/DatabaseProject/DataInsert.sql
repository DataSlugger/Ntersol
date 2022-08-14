USE [PRTWarehouse]
GO

INSERT INTO [dbo].[TblCY]
	(
		[DT_Date]
	  , [CustName]
	  , [CustPhone]
	  , [CustAddress]
	  , [DeltaDate]
	  , [Transfered]
	)
 VALUES
 (
	 '20210930', 'Javier Montero', '8325109629', '23730 Springwolf Dr', GETDATE(), 0
 )
, (
	 '20210831', 'Javier O Montero', '8325109629', '23730 Springwolf Dr', GETDATE(), 0
 )
, (
	 '20210801', 'Josue Montero', '8325109629', '23730 Springwolf Dr', GETDATE(), 0
 )
, (
	 '20210714', 'Javier Montero', '8325109629', 'Hato de Enmedio', '20210715', 0
 )
, (
	 '20210714', 'Yovany Montero', '8325109629', 'Hato de Enmedio', '20210715', 0
 )
, (
	 '20210131', 'Amed Montero', '8325109629', 'Hato de Enmedio', '20210131', 0
 )
GO


