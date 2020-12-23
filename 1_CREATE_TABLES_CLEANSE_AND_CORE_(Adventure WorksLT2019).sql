-- =============================================
-- Author:		Juan Carlos Rivera Cuadros
-- Create date: 22/12/2020
-- Description:	Example of CLEANSE AND CORE with SCD2 (Adventure WorksLT2019)
-- =============================================
--
--
--QuelleSD2:
--https://www.youtube.com/watch?v=Qro2hXpwCcc&t=912s
--https://www.youtube.com/watch?v=RHRjLd0bEaQ
--https://www.youtube.com/watch?v=Sggdhot-MoM
-- =============================================
--Create Schemas

USE [AdventureWorksLT2019]
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.schemas
                WHERE   name = N'CLEANSE')
    EXEC('CREATE SCHEMA CLEANSE');
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.schemas
                WHERE   name = N'CORE')
    EXEC('CREATE SCHEMA CORE');
GO

--Create Table 
IF NOT (EXISTS (SELECT * FROM sys.tables WHERE name = N'C_Address'))
EXEC(
'CREATE TABLE [CLEANSE].[C_Address](
	[AddressID] [int] NOT NULL,
	[AddressLine1] [nvarchar](60) NOT NULL,
	[AddressLine2] [nvarchar](60) NULL,
	[City] [nvarchar](30) NOT NULL,
	[StateProvince] [dbo].[Name] NOT NULL,
	[CountryRegion] [dbo].[Name] NOT NULL,
	[PostalCode] [nvarchar](15) NOT NULL,
	[HashKey_BK] [int] PRIMARY KEY CLUSTERED NOT NULL,
	[Hashkey_Data] [int] NOT NULL,
	[Source] [nvarchar](60) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL)')
GO

IF (NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'DIM_Address') )
EXEC(
'CREATE TABLE [CORE].[DIM_Address](
	[ADDR_DIM_Address_SK] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ADDR_AddressID] [int] NOT NULL,
	[ADDR_AddressLine1] [nvarchar](60) NOT NULL,
	[ADDR_AddressLine2] [nvarchar](60) NULL,
	[ADDR_City] [nvarchar](30) NOT NULL,
	[ADDR_StateProvince] [dbo].[Name] NOT NULL,
	[ADDR_CountryRegion] [dbo].[Name] NOT NULL,
	[ADDR_PostalCode] [nvarchar](15) NOT NULL,
	[ADDR_HashKey_BK] [int] NOT NULL,
	[ADDR_Hashkey_Data] [int] NOT NULL,
	[ADDR_Valid_From] [datetime] NOT NULL,
	[ADDR_Valid_To] [datetime] NOT NULL,
	[ADDR_Current_Flag] [nvarchar] NOT NULL,
	[ADDR_DML_Strat] [nvarchar] (30) NOT NULL,
	[ADDR_Source] [nvarchar](60) NOT NULL,
	[ADDR_ModifiedDate] [datetime] NOT NULL,
	[ADDR_rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ADDR_DIM_Address_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]')
GO

--Dummy Table

IF NOT EXISTS (SELECT TOP(1) * FROM [AdventureWorksLT2019].[CORE].[DIM_Address])
EXEC(
'INSERT INTO [AdventureWorksLT2019].[CORE].[DIM_Address]
           ([ADDR_AddressID]
		   ,[ADDR_AddressLine1]
           ,[ADDR_AddressLine2]
           ,[ADDR_City]
           ,[ADDR_StateProvince]
           ,[ADDR_CountryRegion]
           ,[ADDR_PostalCode]
           ,[ADDR_HashKey_BK]
           ,[ADDR_Hashkey_Data]
           ,[ADDR_Valid_From]
           ,[ADDR_Valid_To]
           ,[ADDR_Current_Flag]
           ,[ADDR_DML_Strat]
           ,[ADDR_Source]
           ,[ADDR_ModifiedDate]
		   ,[ADDR_rowguid])
     VALUES
           (0
		   ,''Dummy''
           ,''Dummy''
           ,''Dummy''
           ,''Dummy''
           ,''Dummy''
           ,''Dummy''
           ,0
           ,0
           ,convert(datetime,''20130822'',112) 
           ,convert(datetime,''20130822'',112)
           ,''x''
		   ,''x''
           ,''Dummy''
           ,convert(datetime,''20130822'',112)
		   ,''6F9619FF-8B86-D011-B42D-00C04FC964FF'')
		   ')


