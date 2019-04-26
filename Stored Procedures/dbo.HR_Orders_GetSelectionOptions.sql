SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 23/03/2015
-- Description:	Selection for hilton retail orders
-- =============================================

--exec [dbo].[HR_Orders_GetSelectionOptions]
CREATE PROCEDURE [dbo].[HR_Orders_GetSelectionOptions]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET FMTONLY OFF

	select 
		p.ProductCode,
		(CONVERT(varchar(9),p.ProductCode) + '  –   ' + p.name) as Detail 
	from 
		[FFG_DW].[dbo].Products P with (nolock)  
		Inner Join [FFG_DW].[dbo].[ProductSpecs] DWPS with (nolock)
			on P.ProductCode = DWPS.productCode 
			
	where 
		DWPS.Specid in (306,307,308,309,310,311,312,321,324,346,347,359,367,371)  
		and 
		P.dimension1 in(50,34,90,65)


   
END


GO
