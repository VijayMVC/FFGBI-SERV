SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 27/04/2015
-- Description:	HR picklist for each site
-- =============================================
--exec [dbo].[HR_PickList_ByOrder_BySite] 116163,2

--exec [dbo].[HR_PickList_ByOrder_BySite] 115823,1


CREATE PROCEDURE [dbo].[HR_PickList_ByOrder_BySite_ARCHIVED] 
	@OrderNo Int,
	@SiteID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;




	Select 
		OA.OrderNo,
		
		OA.SubOrderNo,
		--OS.Sub_Order_No as 'SubOrderNo',
		
		OA.ProductCode,

		case 
			when isNull(OA.InProductionStock,0) = 1 then ''
			else OA.PalletNo end as PalletNo,
	
		OS.Product_Name,
	
		case 
			when OA.SiteID = 1 then 'FC'
			when OA.SiteID = 2 then 'FO'
			when OA.SiteID = 3 then 'FH'
			when OA.SiteID = 4 then 'FD'
			when OA.SiteID = 5 then 'FGl'
			when OA.SiteID = 6 then 'FMM'
			else '' end 
			as Siteid,

		OA.DNOB,

		OA.UseBy,
	
		case 
			when isNull(OA.InProductionStock,0) = 1 then 'Production Stock'
			else '' end 
			as ProductionStock,
	
		OA.HR_BoxNo,
	
		cast(OS.Ordered_Qty as int) as ordered_qty, 
	
		case 
			when isNull(OA.InProductionStock,0) = 1 then sum(OA.InProductionStock)
			else count(OA.BoxNo) end 
			as QTY,

		--count(OA.HR_BoxNo) as QTY,
		OS.VIP,
		OS.Comments,

		(
			select sum(cast(Ordered_Qty as int)) as TotalOrdered 
			from HR_Order_Summary_Import 
			where 
				Group_Order_no = OA.OrderNo 
				and 
				(box_no is not null and round(Ordered_Qty,0) is not null)
		) as totalOrdered,

	--PT.[Description3],

		case 
			when PT.[Description3] = '101 - PRIMAL' and PM.StorageType ='1' then '101 - PRIMAL'
			when PM.StorageType ='2' then '103 - Frozen'
			when PT.[Description3] = '102 - VL'  then '102 - VL'
			when PT.[Description3] = '103 - OFFAL' then '101 - PRIMAL'
			else '101 - PRIMAL' end 
			as [Description3],
		
		pr.name,
		pr.inventoryid,
		PRL.Code,
		os.Site_Comments
	
	Into 
		#tmp
	From 
		HR_Order_Summary_Import OS (nolock)
		
		left join dbo.HR_Order_Allocation OA (nolock) 
			on OA.HR_BoxNo = OS.Box_No and OS.Group_Order_No = OA.OrderNo  and OS.Sub_Order_no = OA.SubOrderNo
		
		left join [FFGSQL06].[FFGProductionPlan].[dbo].[HR_Product_Subs] PS (nolock) 
			on OS.Box_no = PS.Boxno 
		
		left join [FFG_DW].[dbo].[ProductTypes] PT (nolock) 
			on PS.[ProductTypeId] = PT.[ProductTypeID]

		left join [FFG_DW].[dbo].[Stock_Packs] PK (nolock) 
			on OA.boxno = pk.sscc

		left join [FFG_DW].[dbo].[Products] PM (nolock) 
			on OA.Productcode = pm.productcode
		
		left join [FFG_DW].[dbo].[Inventories] PR (nolock) 
			on PR.[site] = pk.siteid and pk.inventoryid = pr.inventoryid
		
		left join [FFG_DW].[dbo].[InventoryLocations] PRL (nolock) 
			on pk.siteid = PRL.Siteid and pk.inventorylocationid = PRL.inventorylocationID

--left join  [FFG_DW].[dbo].[Pallets] as PAL with (nolock) on PAL.PalletNumber = OA.PalletNo								---added by Kevin Hargan 16/12/16
--left join  [FFG_DW].[dbo].[InventoryLocations] as INVL with (nolock) on INVL.InventoryLocationID = PAL.[Invlocation]  ---added by Kevin Hargan 16/12/16
--left join  [FFG_DW].[dbo].[Inventories]  as INV with (nolock) on INV.InventoryID = PAL.InventoryID						---added by Kevin Hargan 16/12/16

where 
	(
		OS.box_no is not null 
		and 
		Os.Product_Name is not null
	) 
	and 
		OA.Orderno is not null
	and 
		os.Group_Order_No = @OrderNo and round(OS.Ordered_Qty ,0) > 0
	and 
		oa.siteid = @SiteID 
	and 
		os.Sub_Order_No = 1 
	and 
		OA.[Modified] <>1 
	--and 
		--datepart(year,oA.OrderDate) = DATEPART(year, getdate()) -- This caused an issue when Main order placed in 2016 and sub order placed on 2017

group by 
	OA.DNOB, 
	OA.USEBY,
	OA.SiteID,
	PalletNo,
	OA.OrderNo,
	
	
	 OA.SubOrderNo,
	--OS.Sub_Order_No,


	OA.ProductCode,
	OA.InProductionStock,
	OA.HR_BoxNo,
	OA.PalletID,
	OS.VIP,
	OS.Comments,
	OS.Ordered_Qty,
	OS.Product_Name,
	PT.[Description3],
	pr.name,
	PRL.Code,
	StorageType,
	pr.inventoryid,
	os.Site_Comments

order by 
	VIP,
	PT.[Description3],
	HR_Boxno, 
	OA.USEBY, 
	OA.DNOB,
	pr.name


--select * from #tmp

Select 
	OrderNo, 
	SubOrderNo,
	ProductCode,
	PalletNo,
	Product_Name,
	Siteid,
	DNOB,
	UseBy,
	ProductionStock,
	HR_BoxNo,
	ordered_qty,
	Sum(QTY) As Qty,
	VIP,
	Comments,
	totalOrdered,
	Description3,
	Name,
	inventoryid,
	Code,
	Site_Comments


From 
	#tmp


where 
	not(
		siteid = 'FH' 
		and isnull(inventoryid,0) =23
	) 
	and not(
		siteid = 'FG' 
		and 
		isnull(inventoryid,0) =75
	) 
	and not(
		siteid = 'FO' 
		and 
		isnull(inventoryid,0) =105
	)

Group By 
	OrderNo, 
	SubOrderNo,
	ProductCode,
	PalletNo,
	Product_Name,
	Siteid,
	DNOB,
	UseBy,
	ProductionStock,
	HR_BoxNo,
	ordered_qty,
	VIP,
	Comments,
	totalOrdered,
	Description3,
	Name,
	Code,
	inventoryid,
	Site_Comments


Order By
	VIP,
	Description3,
	HR_Boxno, 
	USEBY, 
	DNOB,
	name

Drop Table #tmp

END
GO
