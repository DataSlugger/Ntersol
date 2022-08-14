CREATE TABLE [dbo].[TblPrevYear]
(
	[Id] INT NOT NULL IDENTITY(1,1), 
    [DT_Date] DATE NOT NULL DEFAULT GETDATE(), 
    [CustName] VARCHAR(50) NOT NULL, 
    [CustPhone] VARCHAR(20) NULL, 
    [CustAddress] VARCHAR(50) NULL,
    [DeltaDate] DATETIME2 NULL, 
    [Transfered] TINYINT NOT NULL DEFAULT 0,
    CONSTRAINT [TblPrevYear_PK] PRIMARY KEY CLUSTERED ([Id], [DT_Date])
   
) ON PS_PrevYear(DT_Date)
GO

