SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [integration].[MigrateStagedSiteData]
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE 
		@EndOfTime datetime2(7) =  '99991231 23:59:59.9999999',
		@TABLE_NAME VARCHAR(100) =  N'DimSite',
		@MAX_SITEKey int;

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
	
	
	SELECT @MAX_SITEKey = MAX(SiteKey) from DimSite
	--Insert into DimSite
	MERGE
		dbo.DimSite AS TARGET
	USING
		(
			SELECT 
				ROW_NUMBER() OVER(partition by DIM_SITE.[site id] ORDER BY SITES.siteId) + CASE WHEN DIM_SITE.[site id] IS NULL THEN ISNULL(@MAX_SITEKey,0) ELSE 0 END  Sitekey,
				SITES.siteId,
				SITES.code site_code,
				SITES.Description Site_name
			FROM 
				staging.Site SITES
				LEFT JOIN DimSite DIM_SITE on SITES.siteid = DIM_SITE.[site id]
			WHERE 
				1=1
			UNION 
			SELECT 
				-1 SiteKey,
				-1 SiteId, 
				'UN' site_code,
				'Unknown' Site_name
		) AS SOURCE
		
		ON(
			TARGET.[Site ID] = SOURCE.[SiteID])
			
	--		--update if matched
			WHEN MATCHED THEN
			UPDATE SET
				TARGET.[Site Code] = SOURCE.site_code,
				TARGET.[Site name] = SOURCE.site_name

	--		--if no row in target then Insert
			WHEN NOT MATCHED BY TARGET THEN
			INSERT 
			(	
				"SiteKey",
				"Site ID",
				"Site Name",
				"Site Code"
			)
			VALUES
			(	
				SiteKey,
				SiteId,
				Site_name,
				Site_Code
				
			)
		
	--		--remove any rows in the Target that ddoesn't exist in the Source
	--		WHEN NOT MATCHED BY SOURCE THEN 
	--		DELETE;
			
			OUTPUT $action, 
			INSERTED.[SiteKey] [SiteKey];
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
