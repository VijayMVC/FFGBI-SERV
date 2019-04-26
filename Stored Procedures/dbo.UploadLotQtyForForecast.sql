SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason McDevitt
-- Create date: 23.03.15
-- Description:	Get Lots Input and Output by Product Type
-- for Cattle Forcastses for production Planner
-- =============================================
CREATE PROCEDURE [dbo].[UploadLotQtyForForecast]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @StartDate Datetime = Getdate()- 30
	Declare @EndDate Datetime = Getdate()-1
	
	delete from DW_IntoBoning_ByLot
	
   insert into DW_IntoBoning_ByLot
   exec [CAMSQL01].[Innova].[dbo].[usrrep_IntoBoning_Report_LotAvgs] @StartDate, @EndDate
   
   delete from DW_BoningProductType_ByLot
   insert into DW_BoningProductType_ByLot
    exec [CAMSQL01].[Innova].[dbo].[usrrep_Boning_Yield_LotAvgs] @StartDate, @EndDate
END
GO
