-- Testing switch in partitions Prev years

USE [PRTWarehouse]
GO

DROP TABLE IF EXISTS [dbo].[TblTestQuarters]
GO

/****** Object:  Table [dbo].[TblCY]    Script Date: 10/24/2021 17:15:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TblTestQuarters](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DT_Date] [date] NOT NULL,
	[CustName] [varchar](50) NOT NULL,
	[CustPhone] [varchar](20) NULL,
	[CustAddress] [varchar](50) NULL,
	[DeltaDate] [datetime2](7) NULL,
	[Transfered] [tinyint] NOT NULL,
 CONSTRAINT [TblTestQuarters_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[DT_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
) ON [PrevYearFGQ02]
GO

--ALTER TABLE [dbo].[TblTestQuarters] ADD  DEFAULT (getdate()) FOR [DT_Date]
--GO

ALTER TABLE [dbo].[TblTestQuarters] ADD CONSTRAINT [CK_DT_DATE] CHECK ([DT_Date] >= '2020-07-01' AND [DT_Date] < '2020-10-01')

ALTER TABLE [dbo].[TblTestQuarters] ADD  DEFAULT ((0)) FOR [Transfered]
GO

truncate table TblTestQuarters

INSERT INTO TblTestQuarters
	(
		DT_Date
	  , CustName
	  , CustPhone
	  , CustAddress
	  , DeltaDate
	)
 VALUES
 /*('2020-07-31', 'Amed Montero'	,'8325109629','Hato de Enmedio'		,'2020-07-31'),
 ('2020-07-14', 'Javier Montero'	,'8325109629','Hato de Enmedio'		,'2020-07-15'),
 ('2020-07-14', 'Yovany Montero'	,'8325109629','Hato de Enmedio'		,'2020-07-15')
 */
 (
	 '2020-08-31', 'Javier O Montero', '8325109629', '23730 Springwolf Dr', '2021-10-19 03:55:20.4800000'
 )
, (
	 '2020-08-01', 'Josue Montero', '8325109629', '23730 Springwolf Dr', '2021-10-19 03:55:20.4800000'
 )
, (
	 '2020-09-30', 'Javier Montero', '8325109629', '23730 Springwolf Dr', '2021-10-19 03:55:20.4800000'
 )


SELECT
 *
FROM
dbo.TblTestQuarters;

SELECT
 *
FROM
TblPrevYear;

DROP TABLE IF EXISTS [dbo].[MOVEPARTITION];

CREATE TABLE [dbo].[MOVEPARTITION](
	[Id] [int]  NOT NULL,
	[DT_Date] [date] NOT NULL,
	[CustName] [varchar](50) NOT NULL,
	[CustPhone] [varchar](20) NULL,
	[CustAddress] [varchar](50) NULL,
	[DeltaDate] [datetime2](7) NULL,
	[Transfered] [tinyint] NOT NULL,
	CONSTRAINT CK_DTDATE check (DT_DATE >= '2020-07-01' AND DT_DATE < '2020-10-01')
	--CONSTRAINT CK_DTDATE2 check ([DeltaDate] >= '2020-07-01' AND [DeltaDate] < '2020-10-01')
	)
ON [PrevYearFGQ03];

INSERT INTO MOVEPARTITION
SELECT
 *
FROM
TblTestQuarters;

SELECT
 *
FROM
MOVEPARTITION

ALTER TABLE dbo.MOVEPARTITION
ADD  CONSTRAINT [MOVEPARTITION_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[DT_Date] ASC
)

ALTER TABLE dbo.MOVEPARTITION SWITCH TO [dbo].[TblPrevYear] PARTITION 2;