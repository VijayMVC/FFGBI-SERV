SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <06/03/18>
-- Description:	<Out of date stock>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_OutOfDateStock_Fresh]

--exec [dbo].[usrrep_OutOfDateStock_Fresh]

	
AS
BEGIN

declare @MaxValueto as datetime
set @MaxValueto = (select max([ValueTo]) from Product_Price where siteid <>7)

select

				Case when pk.siteid = 1 then 'FC'
when pk.siteid = 2 then 'FO'
when pk.siteid = 3 then 'FH'
when pk.siteid = 4 then 'FD'
when pk.siteid = 5 then 'FG'
when pk.siteid = 6 then 'FMM'
when pk.siteid = 7 then 'FI'
else null end as [Site],pk.ProductCode,mat1.[Name] as Product,pk.PRDay,pk.KillDate,pk.UseBy, pr.[Name],COUNT(pk.SSCC) as QTY, Cast(SUM(pk.[Weight]) as decimal (18,2)) as totalweight,

isnull(PP.value,(select top 1 value from Product_Price where ProductCode = mat1.ProductCode and pk.siteid = pp.siteid and [ValueTo] = (select max([ValueTo]) from Product_Price where ProductCode = mat1.ProductCode and pk.siteid = pp.siteid)))   AS PricePerKg,
isnull(PP.value,(select top 1 value from Product_Price where ProductCode = mat1.ProductCode and pk.siteid = pp.siteid and [ValueTo] = (select max([ValueTo]) from Product_Price where ProductCode = mat1.ProductCode and pk.siteid = pp.siteid)))*Cast(SUM(pk.[Weight]) as decimal (18,2))  as TotValue

FROM        Stock_Packs AS pk WITH (nolock) 
			INNER JOIN Sites S WITH (nolock) on pk.SiteID = S.SiteID  
			INNER JOIN Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.[site] 
			INNER JOIN  Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode 
			LEFT JOIN Product_Price as PP with (nolock) on mat1.ProductCode = PP.productcode and pk.siteid = pp.siteid and @MaxValueto between valuefrom and valueto

where pk.UseBy <= GETDATE()  and  pr.InventoryTypeID = 1 and (mat1.StorageType <> 2) and not(pr.description1 like '%FROZEN%') 
and pk.[weight] > 0.1 and pk.ProductCode <> '999999999'

group by pk.SiteID, pk.ProductCode, pk.PRDay, pk.KillDate, pk.UseBy, pr.[Name], mat1.[Name], PP.[Value], mat1.ProductCode, PP.SiteID

order by 1,2 desc
END
GO
