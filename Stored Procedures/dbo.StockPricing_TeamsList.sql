SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason mcDevitt
-- Create date: 11.06.2014
-- Description:	Get product List for Price changes and Admin
-- =============================================
Create PROCEDURE [dbo].[StockPricing_TeamsList]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Select Id,TeamName from SalesTeam
END
GO
