USE [AdventureWorksLT2019]
GO
/****** Object:  StoredProcedure [dbo].[spAddressSCD2]    Script Date: 12/23/2020 12:50:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Juan Carlos Rivera Cuadros
-- Create date: 14/12/2020
-- Description:	SCD2 for Table Address
-- =============================================
-- Quelle:
--https://www.youtube.com/watch?v=Qro2hXpwCcc&t=912s
--https://www.youtube.com/watch?v=RHRjLd0bEaQ
--https://www.youtube.com/watch?v=Sggdhot-MoM
-- =============================================

CREATE PROCEDURE [dbo].[spAddressSCD2] AS
	SET NOCOUNT ON;

BEGIN
	DECLARE	@AddressID int,
			@AddressLine1 nvarchar(60),
			@AddressLine2 nvarchar(60),
			@City nvarchar(30),
			@StateProvince nvarchar(50),
			@CountryRegion nvarchar(50),
			@PostalCode nvarchar(15),
			@HashKey_BK int,
			@HashKey_Data int,
			@Source nvarchar(60),
			@ModifiedDate datetime,
			@rowguid uniqueidentifier

	DECLARE scd2 CURSOR FOR
		SELECT	[AddressID]
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
				,[rowguid]
		FROM	[AdventureWorksLT2019].[CLEANSE].[Address]

	OPEN scd2 
		FETCH NEXT FROM scd2 
			into	@AddressID,
					@AddressLine1,
					@AddressLine2,
					@City,
					@StateProvince,
					@CountryRegion,
					@PostalCode,
					@HashKey_BK,
					@HashKey_Data,
					@Source,
					@ModifiedDate,
					@rowguid


		WHILE @@FETCH_STATUS = 0
			BEGIN

				DECLARE	@ADDR_AddressLine1 nvarchar(60),
						@ADDR_AddressLine2 nvarchar(60),
						@ADDR_City nvarchar(30),
						@ADDR_StateProvince nvarchar(50),
						@ADDR_CountryRegion nvarchar(50),
						@ADDR_PostalCode nvarchar(15),
						@ADDR_HashKey_Data int,
						@ADDR_rowguid uniqueidentifier

				SELECT	@ADDR_AddressLine1 = ADDR_AddressLine1,
						@ADDR_AddressLine2 = ADDR_AddressLine2,
						@ADDR_City = ADDR_City,
						@ADDR_StateProvince = ADDR_StateProvince,
						@ADDR_CountryRegion = ADDR_CountryRegion,
						@ADDR_PostalCode = ADDR_PostalCode,
						@ADDR_HashKey_Data = ADDR_Hashkey_Data,
						@ADDR_rowguid = ADDR_rowguid
				FROM	CORE.DIM_Address	
				WHERE	ADDR_HashKey_BK = @HashKey_BK

				print 'Current record set is :' + cast(@HashKey_BK as varchar(20)) + ',' + cast(@HashKey_Data as varchar(20))

				IF(@HashKey_BK in (SELECT ADDR_HashKey_BK FROM CORE.DIM_Address) and (@ADDR_HashKey_Data <> @HashKey_Data)) --and @HashKey_BK is notnull
					BEGIN
						PRINT 'update the CORE.DIM_Address table for the record, for this HashKey Bussines Key : ' + cast(@HashKey_BK as varchar(20))

						UPDATE CORE.DIM_Address 
						SET	ADDR_Valid_To = GETDATE(), 
							ADDR_Current_Flag = 'N', 
							ADDR_DML_Strat = 'HIST_UPD', 
							ADDR_ModifiedDate = GETDATE() 
						WHERE ADDR_HashKey_BK = @HashKey_BK
						
						PRINT 'inserting in the CORE.DIM_Address table for the old record, for this HashKey Bussines Key : ' + cast(@HashKey_BK as varchar(20))

						INSERT INTO CORE.DIM_Address 
							(ADDR_AddressID
							,ADDR_AddressLine1
							,ADDR_AddressLine2
							,ADDR_City
							,ADDR_StateProvince
							,ADDR_CountryRegion
							,ADDR_PostalCode
							,ADDR_HashKey_BK
							,ADDR_Hashkey_Data
							,ADDR_Valid_From
							,ADDR_Valid_To
							,ADDR_Current_Flag
							,ADDR_DML_Strat
							,ADDR_Source
							,ADDR_ModifiedDate
							,ADDR_rowguid)
						VALUES 
							(@AddressID,
							@AddressLine1,
							@AddressLine2,
							@City,
							@StateProvince,
							@CountryRegion,
							@PostalCode,
							@HashKey_BK,
							@HashKey_Data,
							GETDATE(),
							CONVERT(datetime,'99991231',112),
							'Y',
							'HIST_INS',
							'CLEANSE.Address',
							GETDATE(),
							@rowguid)
						END

				--Print'Inserting New Rows'
				ELSE IF(@HashKey_BK not in (SELECT DISTINCT ISNULL(ADDR_HashKey_BK,0) FROM CORE.DIM_Address))
				BEGIN
					INSERT INTO CORE.DIM_Address 
							(ADDR_AddressID
							,ADDR_AddressLine1
							,ADDR_AddressLine2
							,ADDR_City
							,ADDR_StateProvince
							,ADDR_CountryRegion
							,ADDR_PostalCode
							,ADDR_HashKey_BK
							,ADDR_Hashkey_Data
							,ADDR_Valid_From
							,ADDR_Valid_To
							,ADDR_Current_Flag
							,ADDR_DML_Strat
							,ADDR_Source
							,ADDR_ModifiedDate
							,ADDR_rowguid)
						VALUES 
							(@AddressID,
							@AddressLine1,
							@AddressLine2,
							@City,
							@StateProvince,
							@CountryRegion,
							@PostalCode,
							@HashKey_BK,
							@HashKey_Data,
							GETDATE(),
							CONVERT(datetime,'99991231',112),
							'Y',
							'INS',
							'CLEANSE.Address',
							GETDATE(),
							@rowguid)
						PRINT 'Row update for Name in CORE.DIM_Address at HashKey Bussines Key : ' + cast(@HashKey_BK as varchar(20))
						PRINT 'Looping Through, Will Fetsch Next ID Now'
				END

				ELSE
				BEGIN
					PRINT 'Data Need Not be inserted or Updated for this ID = ' + cast(@HashKey_BK as varchar(20))
					PRINT 'Looping Through, Will Fetsch Next ID Now'

				END
				FETCH NEXT FROM scd2 
					into	@AddressID,
							@AddressLine1,
							@AddressLine2,
							@City,
							@StateProvince,
							@CountryRegion,
							@PostalCode,
							@HashKey_BK,
							@Hashkey_Data,
							@Source,
							@ModifiedDate,
							@rowguid

			END

	CLOSE scd2
	DEALLOCATE scd2
	
	PRINT 'loop Ended!'

END
