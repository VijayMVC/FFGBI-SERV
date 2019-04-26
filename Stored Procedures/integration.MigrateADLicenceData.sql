SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [integration].[MigrateADLicenceData]
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    --Licences
	BEGIN TRAN;
	
	MERGE
		dbo.AD_Licences AS TARGET
	USING
		(
			SELECT 
				[LicenceID],
      			[SkuPartNumber],
      			[CapabilityStatus],
      			[ConsumedUnits]
			FROM
				[staging].[AD_Licences]
		) AS SOURCE
		
		ON(
			TARGET.[LicenceId] = SOURCE.[Licenceid])
			
	--		--update if matched
			WHEN MATCHED THEN
			UPDATE SET
				TARGET.[LicenceID] =SOURCE.[LicenceID],
      			TARGET.[SkuPartNumber] =SOURCE.[SkuPartNumber],
      			TARGET.[CapabilityStatus] =SOURCE.[CapabilityStatus],
      			TARGET.[ConsumedUnits] =SOURCE.[ConsumedUnits]


	--		--if no row in target then Insert
			WHEN NOT MATCHED BY TARGET THEN
			INSERT 
			(	
				[LicenceID]
			  ,[SkuPartNumber]
			  ,[CapabilityStatus]
			  ,[ConsumedUnits]
			)
			VALUES
			(	
				[LicenceID]
			  ,[SkuPartNumber]
			  ,[CapabilityStatus]
			  ,[ConsumedUnits]				
			)
		
		--remove any rows in the Target that ddoesn't exist in the Source
			WHEN NOT MATCHED BY SOURCE THEN 
			DELETE;
			
			--OUTPUT $action, 
			--INSERTED.[UserID] [UserID];
			--SELECT @@ROWCOUNT;

    COMMIT;


	--User and licences
	BEGIN TRAN;
	
	MERGE
		dbo.AD_User_Licences AS TARGET
	USING
		(
			SELECT 
				[UserId],
				[LicenceID]
			FROM
				[staging].[AD_User_Licences]
		) AS SOURCE
		
		ON(
			TARGET.[UserId] = SOURCE.[Userid]
			AND TARGET.[LicenceId] = SOURCE.[Licenceid] )
			
	--		--update if matched
			WHEN MATCHED THEN
			UPDATE SET
				TARGET.[UserId] = SOURCE.[Userid],
				TARGET.[LicenceID] =SOURCE.[LicenceID]
      			


	--		--if no row in target then Insert
			WHEN NOT MATCHED BY TARGET THEN
			INSERT 
			(	
				[UserId],
				[LicenceID]
			)
			VALUES
			(	
				[UserId],
				[LicenceID]				
			)
		
		--remove any rows in the Target that ddoesn't exist in the Source
			WHEN NOT MATCHED BY SOURCE THEN 
			DELETE;
			
			--OUTPUT $action, 
			--INSERTED.[UserID] [UserID];
			--SELECT @@ROWCOUNT;

    COMMIT;

    RETURN 0;
END;

		
GO
