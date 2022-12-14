/*
Deployment script for PRTWarehouse

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar PRTData "/var/opt/mssql/data/"
:setvar DatabaseName "PRTWarehouse"
:setvar DefaultFilePrefix "PRTWarehouse"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Creating database $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [CurrentYearFile10], FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_CurrentYearFile10.ndf'), 
    FILEGROUP [CurrentYearFG09](NAME = [CurrentYearFile09], FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_CurrentYearFile09.ndf'), 
    FILEGROUP [CurrentYearFG11](NAME = [CurrentYearFile11], FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_CurrentYearFile11.ndf'), 
    FILEGROUP [CurrentYearFG01](NAME = [CurrentYearFile01], FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile01.ndf'), 
    FILEGROUP [CurrentYearFG02](NAME = [CurrentYearFile02], FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_CurrentYearFile02.ndf'), 
    FILEGROUP [CurrentYearFG03](NAME = [CurrentYearFile03], FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile03.ndf'), 
    FILEGROUP [CurrentYearFG04](NAME = [CurrentYearFile04], FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile04.ndf'), 
    FILEGROUP [CurrentYearFG05](NAME = [CurrentYearFile05], FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile05.ndf'), 
    FILEGROUP [CurrentYearFG06](NAME = [CurrentYearFile06], FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile06.ndf'), 
    FILEGROUP [CurrentYearFG07](NAME = [CurrentYearFile07], FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile07.ndf'), 
    FILEGROUP [CurrentYearFG08](NAME = [CurrentYearFile08], FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile08.ndf'), 
    FILEGROUP [CurrentYearFG12](NAME = [CurrentYearFile12], FILENAME = '$(PRTData)$(DefaultFilePrefix)_CurrentYearFile12.ndf'), 
    FILEGROUP [PrevYearFGQ03](NAME = [PrevYearFileQ3], FILENAME = '$(PRTData)$(DefaultFilePrefix)_PrevYearFileQ3.ndf'), 
    FILEGROUP [PrevYearFGQ04](NAME = [PrevYearFileQ4], FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_PrevYearFileQ4.ndf'), 
    FILEGROUP [OldestYearsFG](NAME = [OldestYearsFile], FILENAME = '$(PRTData)$(DefaultFilePrefix)_OldestYearsFile.ndf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
PRINT N'Creating Filegroup [CurrentYearFG10]...';


GO
ALTER DATABASE [$(DatabaseName)]
    ADD FILEGROUP [CurrentYearFG10];


GO
ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [CurrentYearFG10_6B19FA39], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_CurrentYearFG10_6B19FA39.mdf') TO FILEGROUP [CurrentYearFG10];


GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF),
                MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF,
                DELAYED_DURABILITY = DISABLED 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_PLANS_PER_QUERY = 200, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE = OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET TEMPORAL_HISTORY_RETENTION ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Creating Partition Function [PF_CurrentYear]...';


GO
CREATE PARTITION FUNCTION [PF_CurrentYear](DATE)
    AS RANGE RIGHT
    FOR VALUES ('20210201', '20210301', '20210401', '20210501', '20210601', '20210701', '20210801', '20210901', '20211001', '20211101', '20211201');


GO
PRINT N'Creating Partition Function [PF_OldestYears]...';


GO
CREATE PARTITION FUNCTION [PF_OldestYears](DATE)
    AS RANGE
    FOR VALUES ('2019-12-31 23:59:59.99999');


GO
PRINT N'Creating Partition Function [PF_PrevYear]...';


GO
CREATE PARTITION FUNCTION [PF_PrevYear](DATE)
    AS RANGE RIGHT
    FOR VALUES ('20200701', '20201001');


GO
PRINT N'Creating Partition Scheme [PS_CurrentYear]...';


GO
CREATE PARTITION SCHEME [PS_CurrentYear]
    AS PARTITION [PF_CurrentYear]
    TO ([CurrentYearFG01], [CurrentYearFG02], [CurrentYearFG03], [CurrentYearFG04], [CurrentYearFG05], [CurrentYearFG06], [CurrentYearFG07], [CurrentYearFG08], [CurrentYearFG09], [CurrentYearFG10], [CurrentYearFG11], [CurrentYearFG12]);


GO
PRINT N'Creating Partition Scheme [PS_OldestYears]...';


GO
CREATE PARTITION SCHEME [PS_OldestYears]
    AS PARTITION [PF_OldestYears]
    TO ([OldestYearsFG], [OldestYearsFG]);


GO
PRINT N'Creating Partition Scheme [PS_PrevYear]...';


GO
CREATE PARTITION SCHEME [PS_PrevYear]
    AS PARTITION [PF_PrevYear]
    TO ([PrevYearFGQ03], [PrevYearFGQ04]);


GO
PRINT N'Creating Table [dbo].[TblCurrentMonth]...';


GO
CREATE TABLE [dbo].[TblCurrentMonth] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [DT_Date]     DATE          NOT NULL,
    [CustName]    VARCHAR (50)  NOT NULL,
    [CustPhone]   VARCHAR (20)  NULL,
    [CustAddress] VARCHAR (50)  NULL,
    [DeltaDate]   DATETIME2 (7) NULL,
    [Transfered]  TINYINT       NOT NULL
) ON [CurrentYearFG10];


GO
PRINT N'Creating Table [dbo].[TblCY]...';


GO
CREATE TABLE [dbo].[TblCY] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [DT_Date]     DATE          NOT NULL,
    [CustName]    VARCHAR (50)  NOT NULL,
    [CustPhone]   VARCHAR (20)  NULL,
    [CustAddress] VARCHAR (50)  NULL,
    [DeltaDate]   DATETIME2 (7) NULL,
    [Transfered]  TINYINT       NOT NULL,
    CONSTRAINT [TblCY_PK] PRIMARY KEY CLUSTERED ([Id] ASC, [DT_Date] ASC)
) ON [PS_CurrentYear] ([DT_Date]);


GO
PRINT N'Creating Table [dbo].[TblOldestYears]...';


GO
CREATE TABLE [dbo].[TblOldestYears] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [DT_Date]     DATE          NOT NULL,
    [CustName]    VARCHAR (50)  NOT NULL,
    [CustPhone]   VARCHAR (20)  NULL,
    [CustAddress] VARCHAR (50)  NULL,
    [DeltaDate]   DATETIME2 (7) NULL,
    [Transfered]  TINYINT       NOT NULL,
    CONSTRAINT [TblOldestYears_PK] PRIMARY KEY CLUSTERED ([Id] ASC, [DT_Date] ASC)
) ON [PS_OldestYears] ([DT_Date]);


GO
PRINT N'Creating Table [dbo].[TblPrevYear]...';


GO
CREATE TABLE [dbo].[TblPrevYear] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [DT_Date]     DATE          NOT NULL,
    [CustName]    VARCHAR (50)  NOT NULL,
    [CustPhone]   VARCHAR (20)  NULL,
    [CustAddress] VARCHAR (50)  NULL,
    [DeltaDate]   DATETIME2 (7) NULL,
    [Transfered]  TINYINT       NOT NULL,
    CONSTRAINT [TblPrevYear_PK] PRIMARY KEY CLUSTERED ([Id] ASC, [DT_Date] ASC)
) ON [PS_PrevYear] ([DT_Date]);


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[TblCurrentMonth]...';


GO
ALTER TABLE [dbo].[TblCurrentMonth]
    ADD DEFAULT GETDATE() FOR [DT_Date];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[TblCurrentMonth]...';


GO
ALTER TABLE [dbo].[TblCurrentMonth]
    ADD DEFAULT 0 FOR [Transfered];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[TblCY]...';


GO
ALTER TABLE [dbo].[TblCY]
    ADD DEFAULT GETDATE() FOR [DT_Date];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[TblCY]...';


GO
ALTER TABLE [dbo].[TblCY]
    ADD DEFAULT 0 FOR [Transfered];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[TblOldestYears]...';


GO
ALTER TABLE [dbo].[TblOldestYears]
    ADD DEFAULT GETDATE() FOR [DT_Date];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[TblOldestYears]...';


GO
ALTER TABLE [dbo].[TblOldestYears]
    ADD DEFAULT 0 FOR [Transfered];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[TblPrevYear]...';


GO
ALTER TABLE [dbo].[TblPrevYear]
    ADD DEFAULT GETDATE() FOR [DT_Date];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[TblPrevYear]...';


GO
ALTER TABLE [dbo].[TblPrevYear]
    ADD DEFAULT 0 FOR [Transfered];


GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Update complete.';


GO
