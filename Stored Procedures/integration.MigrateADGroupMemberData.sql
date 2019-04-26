SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [integration].[MigrateADGroupMemberData]
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRAN;
	
	MERGE
		dbo.AD_Group_Members AS TARGET
	USING
		(
			SELECT 
				[GroupID],
				[UserID]
			FROM
				[staging].[AD_Group_Members]
		) AS SOURCE
		
		ON(
			TARGET.[GroupId] = SOURCE.[Groupid] 
			AND TARGET.[UserID] = SOURCE.[UserID]
			)
			
	--		--update if matched
			--WHEN MATCHED THEN
			--UPDATE SET
			--	TARGET.[GroupId] = SOURCE.[Groupid], 
			--	TARGET.[UserID] = SOURCE.[UserID]


	--		--if no row in target then Insert
			WHEN NOT MATCHED BY TARGET THEN
			INSERT 
			(	
				[GroupID],
				[UserID]
			)
			VALUES
			(	
				[GroupID],
				[UserID]
				
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
