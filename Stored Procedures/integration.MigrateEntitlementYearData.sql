SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [integration].[MigrateEntitlementYearData]
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE 
		@EndOfTime datetime2(7) =  '99991231 23:59:59.9999999',
		@TABLE_NAME VARCHAR(100) =  N'DimEntitlementYear',
		@MAX_EntitlemmentYearKey int;

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
	
	
	SELECT 
		*
	INTO 
		#tmp_years
	FROM
	(
		SELECT 
			2016 Years, 1 YearKey
		UNION ALL
		SELECT 
			2017 Years, 2 YearKey
		 UNION ALL
		SELECT 
			2018 Years, 3 YearKey
		UNION ALL
		SELECT 
			2019 Years, 4 YearKey
		UNION ALL
		SELECT 
			2020 Years, 5 YearKey
		UNION ALL
		SELECT 
			2021 Years, 6 YearKey
	)Years
	
	
	--Insert into DimEntitlementYear
	MERGE
		dbo.DimEntitlementYear AS TARGET
	USING
		(
			SELECT 
				TMP_YEARS.yearkey EntitlementYearKey,
				TMP_YEARS.years
			FROM 
				#tmp_years TMP_YEARS
				LEFT JOIN DimEntitlementYear DIM_EY on DIM_EY.[Entitlement Year] = TMP_YEARS.Years
			WHERE 
				1=1
		) AS SOURCE
		
		ON(
			TARGET.[Entitlement Year] = SOURCE.[Years])
			
	--		--update if matched
			WHEN MATCHED THEN
			UPDATE SET
				TARGET.[Entitlement Year] = SOURCE.Years

	--		--if no row in target then Insert
			WHEN NOT MATCHED BY TARGET THEN
			INSERT 
			(	
				"EntitlementYearKey",
				"Entitlement Year"
			)
			VALUES
			(	
				EntitlementYearKey,
				Years
				
			)
		
			--remove any rows in the Target that ddoesn't exist in the Source
			--WHEN NOT MATCHED BY SOURCE THEN 
			--DELETE;
			
			--OUTPUT $action, 
			--INSERTED.[EntitlementYearKey] [EntitlementYearKey];
			--SELECT @@ROWCOUNT;
			;
	
	
	
	
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

		DROP TABLE #tmp_years
    COMMIT;

    RETURN 0;
END;

		
GO
