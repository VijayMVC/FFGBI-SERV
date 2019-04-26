SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [integration].[GetLastETLCutoffTime]
@TableName sysname
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SELECT 
		TOP 1 [CutoffTime] 
	FROM
		(
			SELECT [Cutoff Time]AS CutoffTime ,0 ord_col 
			FROM Integration.[ETL Cutoff]
			WHERE [Table Name] = @TableName
			UNION ALL
			SELECT getdate(),1 AS CutoffTime
		)T1
		order by ord_col
    IF @@ROWCOUNT = 0
    BEGIN
     
	    PRINT N'Invalid ETL table name';
        --THROW 51000, N'Invalid ETL table name', 1;
        RETURN -1;
    END;

    RETURN 0;
END;
GO
