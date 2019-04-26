SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [integration].[MigrateADGroupData]
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRAN;
	
	MERGE
		dbo.AD_Groups AS TARGET
	USING
		(
			SELECT 
				[GroupID],
				[GroupName],
				[Description],
				[ObjectType]
			FROM
				[staging].[AD_Groups]
		) AS SOURCE
		
		ON(
			TARGET.[GroupId] = SOURCE.[Groupid])
			
	--		--update if matched
			WHEN MATCHED THEN
			UPDATE SET
				TARGET.[GroupName] = SOURCE.[GroupName],
				TARGET.[Description] = SOURCE.[Description],
				TARGET.[ObjectType] = SOURCE.[ObjectType]


	--		--if no row in target then Insert
			WHEN NOT MATCHED BY TARGET THEN
			INSERT 
			(	
				[GroupID],
				[GroupName],
				[Description],
				[ObjectType]
			)
			VALUES
			(	
				[GroupID],
				[GroupName],
				[Description],
				[ObjectType]
				
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
