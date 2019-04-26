SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [integration].[MigrateStagedAbsenseReasonData]
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE 
		@EndOfTime datetime2(7) =  '99991231 23:59:59.9999999',
		@TABLE_NAME VARCHAR(100) =  N'DimAbsenceReason',
		@MAX_AbsReasonKey int;

    BEGIN TRAN;
		DECLARE @LineageKey int = (	SELECT 
										TOP(1) [Lineage Key]
									FROM 
										Integration.Lineage
									WHERE 
										[Table Name] = @TABLE_NAME
										AND [Data Load Completed] IS NULL
									ORDER BY 
										[Lineage Key] DESC);
	
	SELECT @MAX_AbsReasonKey = MAX(AbsenceReasonKey) from DimAbsenceReason
	--Insert into DimAbsenceReason
	MERGE
		dbo.DimAbsenceReason AS TARGET
	USING
		(
			SELECT 
				
				ROW_NUMBER() OVER(ORDER BY ABS_REAS.absence_ref_id) +CASE WHEN DIM_ABS_REAS.absence_ref_id IS NULL THEN 0 ELSE @MAX_AbsReasonKey  END  AbsenceReasonkey,
				ABS_REAS.absence_ref_id,
				ABS_REAS.[absence_reason]
			FROM 
				staging.AbsenceReason ABS_REAS
				LEFT JOIN dbo.DimAbsenceReason DIM_ABS_REAS on ABS_REAS.absence_ref_id = DIM_ABS_REAS.absence_ref_id
			WHERE 
				1=1
		) AS SOURCE
		
		ON(
			TARGET.[absence_ref_id] = SOURCE.[absence_ref_id])
			
	--		--update if matched
			WHEN MATCHED THEN
			UPDATE SET
				TARGET.[absence reason] = SOURCE.[absence_reason]
			

	--		--if no row in target then Insert
			WHEN NOT MATCHED BY TARGET THEN
			INSERT 
			(	
				"AbsenceReasonkey",
				"absence_ref_id",
				"absence reason"
			)
			VALUES
			(	
				"AbsenceReasonkey",
				"absence_ref_id",
				"absence_reason"
			)
		
	--		--remove any rows in the Target that ddoesn't exist in the Source
	--		WHEN NOT MATCHED BY SOURCE THEN 
	--		DELETE;
			
			OUTPUT $action, 
			INSERTED.[AbsenceReasonkey] [AbsenceReasonkey];
			SELECT @@ROWCOUNT;;
	
	
	
	
	--Update the lineage table 
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
