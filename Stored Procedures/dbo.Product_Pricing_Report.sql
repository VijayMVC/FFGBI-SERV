SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 06/06/2014
-- Description:	Product Pricing report
-- =============================================
CREATE PROCEDURE [dbo].[Product_Pricing_Report] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	Select PM.ProductCode, PM.Name,PT.Name as ProducType, DatePart(week, PP.[ValueFrom]) AS WEEKNO, pp.[ValueFrom], pp.[ValueTo], pp.SiteId, pp.Value, ST.Name as SiteName
	From Product_Price PP WITH (nolock)
	inner join Products PM WITH (nolock) on PP.Productcode = PM.ProductCode
	Inner join ProductTypes PT with (nolock) on PM.MaterialType = PT.ProductTypeID
	Inner join Sites ST with (nolock) on PP.SiteID = ST.siteID
	where Value > 0.0
	 


END
GO
