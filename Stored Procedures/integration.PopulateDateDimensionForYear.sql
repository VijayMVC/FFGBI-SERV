SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [integration].[PopulateDateDimensionForYear] --@YearNumber int
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE 
		@MAX_DIM_DATE DATE,
		@CUR_DATE DATE =getdate(),
		@StartDate DATETIME,
		@EndDate DATETIME
			

    BEGIN TRY;
		--check the latest date in the DimDate table
		SELECT 
			@MAX_DIM_DATE= MAX([DATE]) 
		FROM 
			dbo.DimDAte--[FFGSQL02].[FFG-Production].dbo.[FFG LIVE$Accounting Period GB]
		WHERE
			1=1
	
        --if the current date is greater than the latest year end date setup for fiscal years in NAV then create new periods
		IF	(@CUR_DATE > @MAX_DIM_DATE )
        BEGIN
           
               SELECT 
					@EndDate = MAX([Period End])+1
				FROM
					[FFGSQL02].[FFG-Production].dbo.[FFG LIVE$Accounting Period GB]
				WHERE
					[Period Type] = 4--years
					AND @CUR_DATE BETWEEN [Period Start] AND [Period END]
				select @EndDate 
				--DROP TABLE [dbo].[DimDate]
				EXEC [Integration].[CreateDateDimTable] --@EndDate	
        END;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT N'Unable to populate dates for the year';
       -- THROW;
        RETURN -1;
    END CATCH;

    RETURN 0;
END;

GO
