SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [integration].[PopulatePLComparisonTable] (@AllowPostingFrom DATE)
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE 
		@CUR_DATE DATE =getdate(),
		@FIS_YEAR VARCHAR(4)
	
	BEGIN TRY;
		--get the current fiscal year
		SELECT 
			@FIS_YEAR = DATES.fiscalyear 
		FROM 
			dbo.DimDate DATES
		WHERE 
			DATES.date = @CUR_DATE
		
		--delete from the PLComparison table for the current year
		DELETE FROM 
			Z_PL_COMPARISONS 
		WHERE 
			FiscalYear >= @FIS_YEAR 
	
		--insert into PLComparison table for the current year
		INSERT INTO 
			Z_PL_COMPARISONS 
		SELECT 
			DATES.FiscalMonth,
			DATES.FiscalYear,
			DATES.FiscalFirstDayOfMonth,
			GLA.[Site Code],
			GLA.[Site Name],
			GLA.[Period Group Name],
			GLA.[Period Account Name],
			GLA.[G_L Account Name],
			GLA.[G_L Account No_],
			GLA.[Header GL Account No_],
			GLA.[Document No_],
			GLA.[Posting Date],
			GLA.InterCompany,
			SUM(FACT_GL.amount)amount,
			SUM(FACT_GL.[Additional-Currency Amount]) [Additional-Currency Amount],
			GLA.[Buy-from Vendor Name]
			--MAX(EXR.[Period Adjustment Exch_ Rate Amount])[Period Adjustment Exch_ Rate Amount],
			--MAX(EXR.[Adjustment Exch_ Rate Amount])[Adjustment Exch_ Rate Amount],
			--ISNULL(SUM(	CASE 
			--				WHEN GLA.[Site Code] = 'FD' AND GLA.InterCompany = 'N' THEN FACT_GL.[Additional-Currency Amount] /NULLIF(EXR.[Period Adjustment Exch_ Rate Amount],0)  
			--				--WHEN GLA.[Site Code] = 'FD' AND GLA.InterCompany = 'Y' THEN FACT_GL.[Amount]
			--			ELSE FACT_GL.amount END) ,0) Calc_amount --intercompany for Donegal uses weekly rate 
		FROM 
			dbo.DimDate DATES
			LEFT JOIN dbo.DimExchangeRate EXR on DATES.DateKey = EXR.DateKey
			INNER JOIN [dbo].[FactGLAccount] FACT_GL on DATES.DateKey = FACT_GL.datekey
			INNER JOIN DimGlAccounts GLA on FACT_GL.entrykey = GLA.EntryKey
		WHERE
			GLA.[G_L Account No_] <=250000
			AND DATES.fiscalYear >= ISNULL(@FIS_YEAR,'0')
			AND DATES.Date < @AllowPostingFrom
		GROUP BY
			DATES.FiscalFirstDayOfMonth,
			DATES.FiscalMonth,
			DATES.FiscalYear,
			GLA.[Site Code],
			GLA.[Site Name],
			GLA.[Period Group Name],
			GLA.[Period Account Name],
			GLA.[G_L Account Name],
			GLA.[G_L Account No_],
			GLA.[Header GL Account No_],
			GLA.[Document No_],
			GLA.[Posting Date],
			GLA.InterCompany,
			GLA.[Buy-from Vendor Name]

	
       
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT N'Unable to populate dates for the current fiscal year';
       -- THROW;
        RETURN -1;
    END CATCH;

    RETURN 0;
END;

GO
