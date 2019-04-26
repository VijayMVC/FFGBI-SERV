SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DashBoard_Credits]
	@SiteID int = 1,
	@Week int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select RE.[Description] as Reason , Cast(SUM([Quantity]) as DECIMAL(10,2)) AS Qty
FROM [FM_Navserv].[FM-Production].[dbo].[FM - LIVE$Sales Cr_Memo Line] CR
inner Join [FM_Navserv].[FM-Production].[dbo].[FM - LIVE$Return Reason] RE on CR.[Return Reason Code] = RE.[Code]
where DatePart(wk,[Posting Date]) = DatePart(wk,getdate())
group By RE.[Description]
Having SUM([Quantity]) > 0
END
GO
