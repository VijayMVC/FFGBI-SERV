SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [integration].[MigrateADUserData]
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRAN;
	
	MERGE
		dbo.AD_Users AS TARGET
	USING
		(
			SELECT 
				[UserID],
				[FullName],
				[GivenName],
				[Surname],
				[Department],
				[JobTitle],
				[UserName],
				[AccountEnabled],
				[ObjectType],
				[UserType]
			FROM
				[staging].[AD_Users]
		) AS SOURCE
		
		ON(
			TARGET.[UserId] = SOURCE.[Userid])
			
	--		--update if matched
			WHEN MATCHED THEN
			UPDATE SET
				TARGET.[FullName] = SOURCE.[FullName],
				TARGET.[GivenName] = SOURCE.[GivenName],
				TARGET.[Surname] = SOURCE.[Surname],
				TARGET.[Department] = SOURCE.[Department],
				TARGET.[JobTitle] = SOURCE.[JobTitle],
				TARGET.[UserName] = SOURCE.[UserName],
				TARGET.[AccountEnabled] = SOURCE.[AccountEnabled],
				TARGET.[ObjectType] = SOURCE.[ObjectType],
				TARGET.[UserType] = SOURCE.[UserType]


	--		--if no row in target then Insert
			WHEN NOT MATCHED BY TARGET THEN
			INSERT 
			(	
				[UserID],
				[FullName],
				[GivenName],
				[Surname],
				[Department],
				[JobTitle],
				[UserName],
				[AccountEnabled],
				[ObjectType],
				[UserType]
			)
			VALUES
			(	
				[UserID],
				[FullName],
				[GivenName],
				[Surname],
				[Department],
				[JobTitle],
				[UserName],
				[AccountEnabled],
				[ObjectType],
				[UserType]
				
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
