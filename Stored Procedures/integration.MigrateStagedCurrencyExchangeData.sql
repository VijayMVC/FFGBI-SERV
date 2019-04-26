SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [integration].[MigrateStagedCurrencyExchangeData]
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE 
		@EndOfTime datetime2(7) =  '99991231 23:59:59.9999999',
		@TABLE_NAME VARCHAR(100) =  N'Currency Exchange Rate';

    BEGIN TRAN;
		TRUNCATE TABLE DimExchangeRate
		DECLARE @LineageKey int = (	SELECT 
										TOP(1) [Lineage Key]
									FROM 
										Integration.Lineage
									WHERE 
										[Table Name] = @TABLE_NAME
										AND [Data Load Completed] IS NULL
									ORDER BY 
										[Lineage Key] DESC);
		--Insert into DimExchangeRate
		INSERT INTO 
			DimExchangeRate
		SELECT 
			DATES.datekey,
			CER.[Currency Code],
			CER.[starting date],
			CER.[Exchange Rate Amount],
			CER.[Adjustment Exch_ Rate Amount],
			PERIOD_EX.[Period Adjustment Exch_ Rate Amount]
		FROM 
			[staging].[Currency Exchange Rate] CER
			INNER JOIN dbo.DIMDate DATES on DATES.Date BETWEEN CER.[starting date] AND dateadd(dy,6,CER.[starting date])
			LEFT JOIN (
						SELECT 
							DT.[starting date],
							DT.[Period Adjustment Exch_ Rate Amount],
							DT.fiscalfirstdayofmonth
						FROM
							(
							SELECT 
								CER.[starting date],
								DATES.year,
								DATES.fiscalmonth,
								DATES.fiscalfirstdayofmonth,
								ROW_NUMBER() OVER (Partition by DATES.fiscalfirstdayofmonth ORDER BY CER.[starting date] desc)max_date,
								CER.[Adjustment Exch_ Rate Amount] [Period Adjustment Exch_ Rate Amount]

							FROM 
								[staging].[Currency Exchange Rate] CER
								INNER JOIN dbo.DIMDate DATES on DATES.Date =  CER.[starting date]
							--ORDER BY 1-- DATES.year,DATES.fiscalmonth, CER.[starting date] desc
							)DT
						WHERE
							DT.max_date = 1
						)PERIOD_EX on PERIOD_EX.[fiscalfirstdayofmonth] = DATES.FiscalFirstDayOfMonth 

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
