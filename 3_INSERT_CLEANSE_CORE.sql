USE [AdventureWorksLT2019]
GO

INSERT INTO [CLEANSE].[C_Address]
           (AddressID
		   ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[StateProvince]
           ,[CountryRegion]
           ,[PostalCode]
		   ,[HashKey_BK]
		   ,[Hashkey_Data]
           ,[Source]
           ,[ModifiedDate]
		   ,[rowguid])
     SELECT AddressID
		   ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[StateProvince]
           ,[CountryRegion]
           ,[PostalCode]
		   ,HASHBYTES('MD5',CONVERT( VARCHAR(max),AddressID)) AS [HashKey_BK]
		   ,HASHBYTES('MD5',CONVERT(VARCHAR(max), CONCAT_WS('_', AddressLine1, AddressLine2, City, StateProvince, CountryRegion, PostalCode))) AS  [Hashkey_Data]
           ,'cleanse_address' AS Source
           ,CURRENT_TIMESTAMP AS [ModifiedDate]
		   ,[rowguid]
	 FROM [SalesLT].[Address]
GO

EXEC dbo.spAddressSCD2
