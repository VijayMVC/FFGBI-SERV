SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create PROCEDURE [dbo].[MergeOperationsData]
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
  
    BEGIN TRAN;
	MERGE
		dbo.operationsweekly AS TARGET
	USING
		(
			SELECT  [Year]
      ,[Week]
      ,[Period End]
      ,[Site Dimension]
      ,[Cattle Cost LCY]
      ,[Kill Cost LCY]
      ,[Offal Credit £]
      ,[Sales Price £]
      ,[Boning Cost £]
      ,[Quarters Boned]
      ,[KG Boned]
  FROM [FFG_DW].[staging].[OperationsWeekly]
				
		) AS SOURCE
		
		ON(
			TARGET.[Site Dimension] = SOURCE.[Site Dimension] and target.[Period End]=source.[Period End])
			
	--		--update if matched
			WHEN MATCHED THEN
			UPDATE SET
	target.[Cattle Cost LCY]=source.[Cattle Cost LCY],
      target.[Kill Cost LCY]=source.[Kill Cost LCY],
      target.[Offal Credit £]=source.[Offal Credit £],
      target.[Sales Price £]=source.[Sales Price £],
      target.[Boning Cost £]=source.[Boning Cost £],
      target.[Quarters Boned]=source.[Quarters Boned],
      target.[KG Boned]=source.[KG Boned]

		
	--		--if no row in target then Insert
			WHEN NOT MATCHED BY TARGET THEN
			INSERT 
			(	
				[Year]
      ,[Week]
      ,[Period End]
      ,[Site Dimension]
      ,[Cattle Cost LCY]
      ,[Kill Cost LCY]
      ,[Offal Credit £]
      ,[Sales Price £]
      ,[Boning Cost £]
      ,[Quarters Boned]
      ,[KG Boned]
			)
			VALUES
			(	
				[Year]
      ,[Week]
      ,[Period End]
      ,[Site Dimension]
      ,[Cattle Cost LCY]
      ,[Kill Cost LCY]
      ,[Offal Credit £]
      ,[Sales Price £]
      ,[Boning Cost £]
      ,[Quarters Boned]
      ,[KG Boned]
			)
		
	--		--remove any rows in the Target that ddoesn't exist in the Source
	--		WHEN NOT MATCHED BY SOURCE THEN 
	--		DELETE;
			
			OUTPUT $action, 
			INSERTED.[id] [id];
			SELECT @@ROWCOUNT;;
	
	
	
	
	

    COMMIT;

    RETURN 0;
END;

		
GO
