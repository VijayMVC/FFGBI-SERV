SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,10/01/2018>
-- Description:	<Description,,FI Production Order Stock>
-- =============================================
--[Usrrep_FI_ProductionOrderStock] '13'
CREATE PROCEDURE [dbo].[Usrrep_FI_ProductionOrderStock]
@Cust nvarchar(30)

AS
DECLARE @ProductionStock table(
Pallet nvarchar(20),
ProductCode nvarchar(20),
Product nvarchar(50),
KillDate date,
QTY int, 
Wgt Decimal(12,2),
OrgSite nvarchar(3),
SiteID nvarchar(3),
InventoryName nvarchar(50),
InvLoc nvarchar(10)
--Cust nvarchar(10)
)
BEGIN

Select PC.PalletNumber, cast(SP.ProductCode as nvarchar)as ProductCode,P.[Name] as [Description],cast(SP.KillDate as date) as KillDate,count(SP.ID)AS Qty,cast(SUM(SP.[Weight])as decimal(12,2)) as WGT, 

case when SP.OrgSite = 1 then 'FC'
	 when SP.OrgSite = 2 then 'FO'
	 when SP.OrgSite = 3 then 'FH'
	 when SP.OrgSite = 4 then 'FD'
	 when SP.OrgSite = 5 then 'FG'
	 when SP.OrgSite = 6 then 'FMM'
	 end as OrgSite,

case when SP.SiteID = 1 then 'FC'
	 when SP.SiteID = 2 then 'FO'
	 when SP.SiteID = 3 then 'FH'
	 when SP.SiteID = 4 then 'FD'
	 when SP.SiteID = 5 then 'FG'
	 when SP.SiteID = 6 then 'FMM'
	 end as SiteID, I.[Name] as Inventory,IL.Code
	-- substring(convert(nvarchar(10),SP.ProductCode),1,2)as Cust

into #TmpPacksGreencore
from Stock_Packs SP (nolock)
Inner join Pallets PC with(nolock) on SP.PalletID = PC.PalletID
Left join Products P with(nolock) on SP.ProductCode = P.ProductCode
Left join Inventories I with(nolock) on SP.InventoryID = I.InventoryID and SP.SiteID = I.[Site]
Left join InventoryLocations IL with(nolock) on I.InventoryID = IL.InventoryID
Where (substring(convert(nvarchar(30),SP.ProductCode),1,2) in ('13')) and I.description2 = 'STOCK' and SP.SiteID <> 7 and (substring(convert(nvarchar(10),SP.ProductCode),1,2)) in (@Cust)
group by SP.KillDate,PC.PalletNumber, SP.ProductCode,P.[Name],SP.OrgSite,SP.SiteID ,I.[Name], IL.Code



--85
Select PC.PalletNumber, cast(SP.ProductCode as nvarchar)as ProductCode,P.[Name] as [Description],cast(SP.KillDate as date) as KillDate,count(SP.ID)AS Qty,cast(SUM(SP.[Weight])as decimal(12,2)) as WGT, 

case when SP.OrgSite = 1 then 'FC'
	 when SP.OrgSite = 2 then 'FO'
	 when SP.OrgSite = 3 then 'FH'
	 when SP.OrgSite = 4 then 'FD'
	 when SP.OrgSite = 5 then 'FG'
	 when SP.OrgSite = 6 then 'FMM'
	 end as OrgSite,

case when SP.SiteID = 1 then 'FC'
	 when SP.SiteID = 2 then 'FO'
	 when SP.SiteID = 3 then 'FH'
	 when SP.SiteID = 4 then 'FD'
	 when SP.SiteID = 5 then 'FG'
	 when SP.SiteID = 6 then 'FMM'
	 end as SiteID, 


I.[Name] as Inventory,IL.Code
--,
--substring(convert(nvarchar(10),SP.ProductCode),1,2)as Cust

into #TmpPacksLidl
from Stock_Packs SP (nolock)
Inner join Pallets PC with(nolock) on SP.PalletID = PC.PalletID
Left join Products P with(nolock) on SP.ProductCode = P.ProductCode
Left join Inventories I with(nolock) on SP.InventoryID = I.InventoryID and SP.SiteID = I.[Site]
Left join InventoryLocations IL with(nolock) on I.InventoryID = IL.InventoryID
Where (substring(convert(nvarchar(30),SP.ProductCode),1,2) in ('85')) and I.description2 = 'STOCK' and SP.SiteID <> 7 and (substring(convert(nvarchar(10),SP.ProductCode),1,2)) in (@Cust)
group by SP.KillDate,PC.PalletNumber, SP.ProductCode,P.[Name],SP.OrgSite,SP.SiteID ,I.[Name], IL.Code

--85
Select PC.PalletNumber, cast(SP.ProductCode as nvarchar)as ProductCode,P.[Name] as [Description],cast(SP.KillDate as date) as KillDate,count(SP.ID)AS Qty,cast(SUM(SP.[Weight])as decimal(12,2)) as WGT, 

case when SP.OrgSite = 1 then 'FC'
	 when SP.OrgSite = 2 then 'FO'
	 when SP.OrgSite = 3 then 'FH'
	 when SP.OrgSite = 4 then 'FD'
	 when SP.OrgSite = 5 then 'FG'
	 when SP.OrgSite = 6 then 'FMM'
	 end as OrgSite,

case when SP.SiteID = 1 then 'FC'
	 when SP.SiteID = 2 then 'FO'
	 when SP.SiteID = 3 then 'FH'
	 when SP.SiteID = 4 then 'FD'
	 when SP.SiteID = 5 then 'FG'
	 when SP.SiteID = 6 then 'FMM'
	 end as SiteID, 


I.[Name] as Inventory,IL.Code
--,
--substring(convert(nvarchar(10),SP.ProductCode),1,2)as Cust

into #TmpPacksFFG
from Stock_Packs SP (nolock)
Inner join Pallets PC with(nolock) on SP.PalletID = PC.PalletID
Left join Products P with(nolock) on SP.ProductCode = P.ProductCode
Left join Inventories I with(nolock) on SP.InventoryID = I.InventoryID and SP.SiteID = I.[Site]
Left join InventoryLocations IL with(nolock) on I.InventoryID = IL.InventoryID
Where (substring(convert(nvarchar(30),SP.ProductCode),1,2) in ('83')) and I.description2 = 'STOCK' and SP.SiteID <> 7 and (substring(convert(nvarchar(10),SP.ProductCode),1,2)) in (@Cust)
group by SP.KillDate,PC.PalletNumber, SP.ProductCode,P.[Name],SP.OrgSite,SP.SiteID ,I.[Name], IL.Code

insert into @ProductionStock
Select * from #TmpPacksGreencore

insert into @ProductionStock
Select * from #TmpPacksLidl

insert into @ProductionStock
Select * from #TmpPacksFFG



SELECT * FROM @ProductionStock Where (substring(convert(nvarchar(10),ProductCode),1,2)) in (@Cust) Order by ProductCode

Drop table #TmpPacksGreencore,#TmpPacksLidl,#TmpPacksFFG


END
GO
