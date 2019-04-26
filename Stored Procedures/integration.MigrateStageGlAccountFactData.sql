SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [integration].[MigrateStageGlAccountFactData] (@MAX_E_NO INT)
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;

    DECLARE @TABLE_NAME VARCHAR(100) =  N'FactGlAccounts'
	DECLARE	@MAX_ENTRY_NO INT = @MAX_E_NO
	DECLARE	@LineageKey int = (	SELECT 
										TOP(1) [Lineage Key]
									FROM 
										Integration.Lineage
									WHERE 
										[Table Name] = @TABLE_NAME
										AND [Data Load Completed] IS NULL
									ORDER BY 
										[Lineage Key] DESC
								);

			INSERT INTO		
				[dbo].[FactGLAccount]
			SELECT 
				DATES.DateKey,
				GLA.[EntryKey],
				GLE.amount,
				GLE.[debit amount],
				GLE.[credit amount],
				GLE.[vat amount],
				GLE.[Additional-Currency Amount],
				ISNULL(@LineageKey,999)
			FROM 
				staging.[FFG LIVE_G_L_Entry] GLE
				INNER JOIN dbo.DimGlAccounts GLA on GLE.[Entry No_] = GLA.[Entry No_]
				INNER JOIN dbo.DimDate DATES on cast(GLE.[Posting Date]as date) = DATES.Date
			WHERE
				1=1--GLA.[Entry No_] > ISNULL(@MAX_ENTRY_NO,0)
				--NOT EXISTS (
				--			SELECT 
				--				1
				--			FROM
				--				[dbo].[FactGLAccount] FGLA
				--			WHERE
				--				GLA.[EntryKey] =FGLA.[EntryKey]
				--				AND DATES.DateKey = FGLA.[DateKey]
				--			)
			
			UPDATE 
				Integration.Lineage
			SET 
				[Data Load Completed] = SYSDATETIME(),
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
				[Table Name] = @TABLE_NAME;

    COMMIT;

    RETURN 0;
END;
GO
