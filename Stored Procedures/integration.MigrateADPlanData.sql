SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [integration].[MigrateADPlanData]
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    --Plans
	BEGIN TRAN;
	
	MERGE
		dbo.AD_Service_Plans AS TARGET
	USING
		(
			SELECT 
				[ServicePlanId],
				[LicenceID],
				[AppliesTo],
				[ServicePlanName],
				[ProvisioningStatus]
			FROM
				[staging].[AD_Service_Plans]
		) AS SOURCE
		
		ON(
			TARGET.[ServicePlanId] = SOURCE.[ServicePlanId]
			AND TARGET.[LicenceId] = SOURCE.[Licenceid])
			
	--		--update if matched
			WHEN MATCHED THEN
			UPDATE SET
				TARGET.[AppliesTo] = SOURCE.AppliesTo,
				TARGET.[ServicePlanName] = SOURCE.[ServicePlanName],
				TARGET.[ProvisioningStatus] = SOURCE.[ProvisioningStatus]


	--		--if no row in target then Insert
			WHEN NOT MATCHED BY TARGET THEN
			INSERT 
			(	
				[ServicePlanId],
				[LicenceID],
				[AppliesTo],
				[ServicePlanName],
				[ProvisioningStatus]
			)
			VALUES
			(	
				[ServicePlanId],
				[LicenceID],
				[AppliesTo],
				[ServicePlanName],
				[ProvisioningStatus]			
			)
		
		--remove any rows in the Target that ddoesn't exist in the Source
			WHEN NOT MATCHED BY SOURCE THEN 
			DELETE;
			
			--OUTPUT $action, 
			--INSERTED.[UserID] [UserID];
			--SELECT @@ROWCOUNT;

    COMMIT;


	--User and Plans
	BEGIN TRAN;
	
	MERGE
		dbo.AD_User_Plans AS TARGET
	USING
		(
			SELECT 
				[UserId],
				[PlanID]
			FROM
				[staging].[AD_User_Plans]
		) AS SOURCE
		
		ON(
			TARGET.[UserId] = SOURCE.[Userid]
			AND TARGET.[PlanId] = SOURCE.[Planid] )
			
	--		--update if matched
			WHEN MATCHED THEN
			UPDATE SET
				TARGET.[UserId] = SOURCE.[Userid],
				TARGET.[PlanID] =SOURCE.[PlanID]
      			


	--		--if no row in target then Insert
			WHEN NOT MATCHED BY TARGET THEN
			INSERT 
			(	
				[UserId],
				[PlanID]
			)
			VALUES
			(	
				[UserId],
				[PlanID]				
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
