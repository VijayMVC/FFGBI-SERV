SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason mcDevitt
-- Create date: 11.06.2014
-- Description:	Get product List for Price changes and Admin
-- =============================================
--exec [StockPricing_ProductsPriceList] '10/20/2014'
CREATE PROCEDURE [dbo].[StockPricing_ProductsPriceList]
@StartDate Datetime		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Select P.ProductCode,P.Name,P.FabCode1 as MeatType,P.FabCode2 as ProductType, PP.Value, PP.[ValueFrom], PP.[ValueTo], CS.[Name] as Customer,
	case when [StorageType] = 1 then 'FRESH' else 'FROZEN' end as Storage , PP.EuroValue
		,isnull(T.ID,'') as [Team]
		,isnull(PRI.UpdateNav,0) as UpdateNav
	from Products P
	inner join Product_Price PP on P.ProductCode = PP.ProductCode --and (select max([ValueFrom]) from Product_Price where ProductCode = PP.ProductCode) between valuefrom and valueto
	inner join ProductSpecs PS on P.ProductCode = PS.ProductCode
	inner join CustomerSpecs CS On PS.SpecID  = CS.SpecID
	left join Product_Info PRI on PRI.ProductCode = PP.ProductCode
	left join [SalesTeam] T on T.ID = PRI.SalesTeamId
	where pp.siteid = 7 
	--and PP.Valuefrom = (select Max(ValueFrom) from Product_Price where siteid = 7)
	and pp.Valuefrom = @StartDate
	Order By P.ProductCode
END
GO
