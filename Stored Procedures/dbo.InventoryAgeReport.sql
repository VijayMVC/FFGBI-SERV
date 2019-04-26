SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kelsey Brennan>
-- Create date: <10/12/2018>
-- Description:	<Inventory Age Report, request on Power BI by Oliver mc Allister>
-- =============================================
CREATE PROCEDURE [dbo].[InventoryAgeReport]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT 

cast(GETDATE() as date) as [Date]
,case when s.SiteID=7 then 'Foyle Ingredients'
else s.Name end as [Site]
,Cast([PRDay] as date) as [PR Day]
,cast([UseBy] as date) as [Use By]
,i.description1 as [Inventory Name]
,i.Name as [Inventory Location]
,sp.[ProductCode]
,p.Name as [Product Name]
,ia.[Group] as [Time In Stock]
,ias.[group] as [Time until Expiry]

,case when StorageType<>2 and i.description1 not like '%frozen%' and PT.ProductTypeID <> 140 
then 'Fresh'
when StorageType=2 and i.description1 like '%frozen%' 
then 'Frozen'
when  StorageType = 2 and i.description1 not like '%FROZEN%'and i.name not like 'Ready To%'
then 'Frozen Product Fresh Inventory'
when  
StorageType = 1 and PT.ProductTypeID <> 140 
then 'Fresh in Frozen Inv'
when  StorageType = 2 and i.description1 not like '%FROZEN%' and i.name like 'Ready To%'
then 'Ready to Ship'
when StorageType<>2 and i.description1 not like '%frozen%' and PT.ProductTypeID = 140 
then 'Waste'
end as [Fresh/Frozen]

,case when StorageType<>2 and i.description1 not like '%frozen%' and PT.ProductTypeID <> 140 
then cs.name
when StorageType=2 and i.description1 like '%frozen%' 
then p.Conservation_Name
when StorageType = 2 and i.description1 not like '%FROZEN%' and i.name not like 'Ready To%'
then p.Conservation_Name
when  StorageType = 1 and PT.ProductTypeID <> 140 
then p.Conservation_Name
end as  [Stock Group Name]
,[Weight]

,(select top 1 [value] from Product_Price pp where p.ProductCode=pp.ProductCode and sp.SiteID=pp.SiteID order by valuefrom desc )as [Value]

,(SELECT TOP 1 [ExchangeRateAmount] FROM [FFG_DW].[dbo].[Currency Exchange] where CurrencyCode='eur' order by StartingDate desc) as [Currency fac]



FROM [FFG_DW].[dbo].[Stock_Packs] sp
inner join Sites s on s.SiteID=sp.SiteID
inner join [FFG_DW].[dbo].[Products] p on sp.ProductCode=p.ProductCode
inner join [FFG_DW].[dbo].[Inventories] i on sp.InventoryID=i.InventoryID and sp.SiteID=i.Site
left join [FFG_DW].[dbo].[ProductSpecs] ps on p.ProductCode=ps.ProductCode
left join [FFG_DW].[dbo].[CustomerSpecs] cs on ps.SpecID=cs.SpecID
INNER JOIN ProductTypes PT ON p.materialtype = pt.ProductTypeID 
left join [FFG_DW].[dbo].[Inventory_Age_Group_BI] ia on DATEDIFF(dd,PRDay,cast(getdate()as date)) between ia.[min] and ia.[max] and ia.Storage=p.StorageType and ia.id not in (12,13)
left join [FFG_DW].[dbo].[Inventory_Age_Group_BI] ias on DATEDIFF(dd,cast(getdate()as date),UseBy) between ias.[min] and ias.[max] and ias.Storage=p.StorageType


 where 

sp.weight > 0.1 
and i.InventoryTypeID = 1 --Only Shows Items in a Stock inventory 
and p.productcode <> 999999999 -- Removes Scale Checks
and sp.Productnum is null -- 'Joe McGuire "removes underwoods" KB'
END
GO
