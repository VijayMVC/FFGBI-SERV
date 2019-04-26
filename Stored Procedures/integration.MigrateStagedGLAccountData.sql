SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [integration].[MigrateStagedGLAccountData]
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE 
		@EndOfTime datetime2(7) =  '99991231 23:59:59.9999999',
		@TABLE_NAME VARCHAR(100) =  N'GL Accounts',
		@MAX_ENTRY_KEY INT;

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
		--get the max entry key
		SELECT 
			@MAX_ENTRY_KEY = MAX(entryKey)
		FROM
			dbo.DimGlAccounts
		
		--get the period names that are grouped
		SELECT 
			GLA.start_no_,
			GLA.end_no_,
			GLA.no_,
			PAN.[New Name] [Period Account Name] ,
			PAN.[Group Name] [Period Group Name]
		INTO
			#TMP_PERIOD_ACCOUNTS
		FROM 
			[staging].[G_L Account] GLA 
			INNER JOIN [staging].[PeriodAccountNames] PAN on GLA.No_ = PAN.[G_L Account No_]
		WHERE
			GLA.[account type] = 4
			AND GLA.start_no_ <>100
		
		----Insert into DimExchangeRate
		INSERT INTO 
			DimGlAccounts
		SELECT 
			GLE.[Entry No_],
			GLE.[G_L Account No_],
			GLE.[Posting Date],
			GLE.[Document Type],
			GLE.[Document No_],
			GLE.[Description],
			GLE.[Global Dimension 1 Code],
			SITES.Description,
			GLE.[User ID] ,
			GLE.[Source Code] ,
			GLE.[Journal Batch Name],
			GLE.[Transaction No_],
			GLE.[Document Date],
			GLE.[External Document No_],
			--CASE WHEN GLE.[Gen_ Bus_ Posting Group] = 'INTERCOMP' THEN 'Y' ELSE 'N' END [InterCompany],
			CASE WHEN ICD.[Document No_] IS NOT NULL THEN 'Y' ELSE 'N' END [InterCompany],
			GLA.Name[G_L Account Name],
			PAN.[New Name] [Period Account Name] ,
			PAN.[Group Name] [Period Group Name],
			GLE.[G_L Account No_] [Header GL Account No_],
			PUR_HEAD.[Buy-from Vendor Name]
		FROM 
			staging.[FFG LIVE_G_L_Entry] GLE
			LEFT JOIN [staging].[G_L Account] GLA on GLE.[G_L Account No_] = GLA.No_
			LEFT JOIN [staging].[PeriodAccountNames] PAN on GLA.No_ = PAN.[G_L Account No_]
			LEFT JOIN [staging].[Original Site] SITES on GLE.[Global Dimension 1 Code] = SITES.code
			LEFT JOIN [staging].[InterCompanyDocumentNo] ICD on GLE.[Document No_] = ICD.[Document No_]
			LEFT JOIN [staging].[FFG LIVE$Purch_ Inv_ Header] PUR_HEAD on GLE.[Document No_] = PUR_HEAD.[No_]
		WHERE
			NOT EXISTS (
						SELECT 
							1
						FROM
							DimGlAccounts DIM_GLA
						WHERE
							DIM_GLA.[Entry No_] = GLE.[Entry No_]
						)

		--update the Period account names for any values not set 
		UPDATE 
			DIM_GLA
		SET
			DIM_GLA.[Header GL Account No_] = PA.No_,
			DIM_GLA.[Period Group Name] = PA.[Period Group Name],
			DIM_GLA.[Period Account Name] = PA.[Period Account Name]
		FROM
			DimGlAccounts DIM_GLA	
			INNER JOIN #TMP_PERIOD_ACCOUNTS PA on DIM_GLA.[G_L Account No_] BETWEEN PA.start_no_ AND PA.end_no_
		WHERE
			DIM_GLA.[Period Account Name] IS NULL
			--AND DIM_GLA.[G_L Account No_] > @MAX_ENTRY_KEY
	
		------update -> 2018 Intercompany
		SELECT 
			[Document No_],
			[Sell-to Customer No_]
			into #tmp_inter_pre_2018
		FROM 
			FFGSQL02.[FFG-Production].[dbo].[FFG LIVE$Sales Analysis History]
		WHERE 
			[Sell-to Customer No_]  
		in (
			'2069','2070','2090','2091','2124','2201','2202','2203','2376','3439','3674','4284','4375','4446','4533','4864',
			'11225','21798','21799','21800','21801','21802','21804','22995','23037','23038','23040','23041','23042','23044',
			'23045','23046','23047','33033','41837','FB','FC','FD','FFG_LTD','FGL','FH','FI','FMM','FO','FP',
			'FFG_LTD','2069','2070','2088','2090','2091','2124','2201','2202','2203','2376','2809','3327','3439','3674','3674','3929','4284','4375','4446','4533','4864'
			)
		GROUP BY
			[Document No_],
			[Sell-to Customer No_]

		--Update intercompany
		UPDATE	
			GLA
		SET
			GLA.InterCompany = CASE WHEN ICD.[Document No_] IS NOT NULL THEN 'Y' ELSE 'N' END
		FROM 
			DimGlAccounts GLA
			INNER JOIN dimdate DATES on GLA.[Posting Date] = DATES.Date
			LEFT JOIN #tmp_inter_pre_2018 ICD on GLA.[Document No_] = ICD.[Document No_] collate database_default
		WHERE
			DATES.FiscalYear < 2018
			AND GLA.InterCompany <> CASE WHEN ICD.[Document No_] IS NOT NULL THEN 'Y' ELSE 'N' END
		------END update -> 2018 Intercompany
		


		---->=2018 InterCompany

				SELECT 
					[Document No_],
					[Sell-to Customer No_]
				into 
					#tmp_inter
				FROM 
					FFGSQL02.[FFG-Production].[dbo].[FFG LIVE$Sales Analysis History]
				WHERE 
					[Sell-to Customer No_]  
				in (
					'2069','2070','2090','2091','2124','2201','2202','2203','2376','3439','3674','4284','4375','4446','4533','4864',
					'11225','21798','21799','21800','21801','21802','21804','22995','23037','23038','23040','23041','23042','23044','23045','23046','23047','33033','41837',
					'FB','FC','FD','FFG_LTD','FGL','FH','FI','FMM','FO','FP'
					)
				GROUP BY
					[Document No_],
					[Sell-to Customer No_]

			--Update intercompany
			UPDATE	
				GLA
			SET
				GLA.InterCompany = CASE WHEN ICD.[Document No_] IS NOT NULL THEN 'Y' ELSE 'N' END
			FROM 
				DimGlAccounts GLA
				INNER JOIN dimdate DATES on GLA.[Posting Date] = DATES.Date
				LEFT JOIN #tmp_inter ICD on GLA.[Document No_] = ICD.[Document No_] collate database_default
			WHERE
				DATES.FiscalYear >=2018
				AND GLA.InterCompany <> CASE WHEN ICD.[Document No_] IS NOT NULL THEN 'Y' ELSE 'N' END

		---End update >=2018 Intercompany----------------------------
		
		
		---drop temp tables
		IF OBJECT_ID('tempdb.dbo.#TMP_PERIOD_ACCOUNTS', 'U') IS NOT NULL	
			DROP TABLE #TMP_PERIOD_ACCOUNTS
		
		IF OBJECT_ID('tempdb.dbo.#tmp_inter_pre_2018', 'U') IS NOT NULL	
			DROP TABLE #tmp_inter_pre_2018


		IF OBJECT_ID('tempdb.dbo.#tmp_inter', 'U') IS NOT NULL	
			DROP TABLE #tmp_inter
		
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
