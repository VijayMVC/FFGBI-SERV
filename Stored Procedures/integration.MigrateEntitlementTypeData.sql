SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [integration].[MigrateEntitlementTypeData]
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE 
		@EndOfTime datetime2(7) =  '99991231 23:59:59.9999999',
		@TABLE_NAME VARCHAR(100) =  N'DimEntitlementType',
		@MAX_EntitlemmentTypeKey int;

    BEGIN TRAN;
		
		SELECT 
			@MAX_EntitlemmentTypeKey = MAX(EntitlementTypeKey) 
		FROM 
			DimEntitlementType

		DECLARE @LineageKey int = (	SELECT 
										TOP(1) [Lineage Key]
									FROM 
										Integration.Lineage
									WHERE 
										[Table Name] = @TABLE_NAME
										AND [Data Load Completed] IS NULL
									ORDER BY 
										[Lineage Key] DESC);
	
	--Insert into DimEntitlementType
	MERGE
		dbo.DimEntitlementType AS TARGET
	USING
		(
			SELECT 
				ROW_NUMBER() OVER(partition by DIM_ET.EntitlementId ORDER BY ABS_ENT.absence_entitlement_id) + CASE WHEN DIM_ET.EntitlementId IS NULL THEN ISNULL(@MAX_EntitlemmentTypeKey,0) ELSE 0 END EntitlementTypeKey,
				ABS_ENT.absence_entitlement_id,
				ABS_ENT.entitlement_type,
				ABS_ENT.entitlement_group
			FROM 
				staging.tabsence_entitlement ABS_ENT
				LEFT JOIN DimEntitlementType  DIM_ET on ABS_ENT.absence_entitlement_id = DIM_ET.EntitlementId
			UNION 
			SELECT 
				-1 e_Key,
				-1 Id, 
				'Unknown' e_type,
				'Unknown' e_group
		) AS SOURCE
		
		ON(
			TARGET.[EntitlementId] = SOURCE.[absence_entitlement_id])
			
	--		--update if matched
			WHEN MATCHED THEN
			UPDATE SET
				TARGET.[entitlement type] = SOURCE.entitlement_type,
				TARGET.[entitlement group] = SOURCE.entitlement_group

	--		--if no row in target then Insert
			WHEN NOT MATCHED BY TARGET THEN
			INSERT 
			(	
				"EntitlementTypeKey",
				"EntitlementId",
				"Entitlement type",
				"Entitlement group"
			)
			VALUES
			(	
				EntitlementTypeKey,
				absence_entitlement_id,
				Entitlement_type,
				Entitlement_group
				
			)
		
	--		--remove any rows in the Target that ddoesn't exist in the Source
	--		--WHEN NOT MATCHED BY SOURCE THEN 
	--		--DELETE;
			
	--		--OUTPUT $action, 
	--		--INSERTED.[EntitlementYearKey] [EntitlementYearKey];
	--		--SELECT @@ROWCOUNT;
		;
	
	
	
	
	----Update the lineage table 
		UPDATE 
			Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
		WHERE 
			[Lineage Key] = @LineageKey;

		UPDATE 
			Integration.[ETL Cutoff]
        SET
			[Cutoff Time] = (SELECT [Source System Cutoff Time]
                             FROM Integration.Lineage
                             WHERE [Lineage Key] = @LineageKey)
		FROM 
			Integration.[ETL Cutoff]
		WHERE 
			[Table Name] =@TABLE_NAME

    COMMIT;

    RETURN 0;
END;

		
GO
