SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec  [dbo].[GetHRSites] 'Site_Comments'
CREATE PROCEDURE [dbo].[GetHRSites]
	-- Add the parameters for the stored procedure here
	@Selection nvarchar(40)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Declare @Sql nvarchar(max)= ''

SELECT @Sql =
   CASE 
      WHEN @Selection = 'Site_Comments' THEN  'select * from lotsSites where id in (1,2,3,4,5,6)'
    --  WHEN @Selection = 'SubStitues' THEN 'select p.ProductCode,(CONVERT(varchar(9),p.ProductCode) + ''   –   '' + p.name) as Detail from [FFG_DW].[dbo].Products P   Inner Join [FFG_DW].[dbo].[ProductSpecs] DWPS on P.ProductCode = DWPS.productCode where DWPS.Specid in (306,307,308,309,310,311,312,321,324,346,347,359,367,371)  and P.dimension1 in(50,34,90)'
	  --WHEN @Selection = 'SubStituesP2' THEN 'select p.ProductCode,(CONVERT(varchar(9),p.ProductCode) + ''   –   '' + p.name) as Detail from [FFG_DW].[dbo].Products P   Inner Join [FFG_DW].[dbo].[ProductSpecs] DWPS on P.ProductCode = DWPS.productCode where DWPS.Specid in (306,307,308,309,310,311,312,321,324,346,347,359,367,371)  and P.dimension1 in(50,34,90)'
 
   END 


exec(@Sql)

END
GO
