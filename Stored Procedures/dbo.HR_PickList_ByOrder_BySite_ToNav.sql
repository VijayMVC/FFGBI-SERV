SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Kevin Hargan
-- Create date: 21/12/2016
-- Description:	HR picklist for each site
-- =============================================


-- exec [dbo].[HR_PickList_ByOrder_BySite_NEW] 118423,1,0,0


CREATE PROCEDURE [dbo].[HR_PickList_ByOrder_BySite_ToNav] 
@OrderNo Int,
@SiteID int,
@Addon int,
@Sawyers int

AS



BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	

	Select	
			OA.OrderNo,
			OA.SubOrderNo AS OASuborderNo,
			OA.Modified AS OAModified,
			OS.Modified AS OSModified,
			OS.Sub_Order_No AS OSSuborderNo,
			OA.OrderDate AS OAOrderDate,

			OA.ProductCode,

			case when isNull(OA.InProductionStock,0) = 1 then ''
			else pal.palletnumber end as PalletNo,
	
			OS.Product_Name,
	
			case when OA.SiteID = 1 then 'FC'
				 when OA.SiteID = 2 then 'FO'
				 when OA.SiteID = 3 then 'FH'
				 when OA.SiteID = 4 then 'FD'
				 when OA.SiteID = 5 then 'FGl'
				 when OA.SiteID = 6 then 'FMM'
				 else '' end as Siteid,

			OA.DNOB,

			OA.UseBy,
			case when isNull(OA.InProductionStock,0) = 1 then 'Production Stock'
				 else '' end as ProductionStock,
			OA.HR_BoxNo,
			cast(OS.Ordered_Qty as int) as ordered_qty, 

			case when isNull(OA.InProductionStock,0) = 1 then sum(OA.InProductionStock)
				 else count(OA.BoxNo) end as QTY,

			OS.VIP,
			OS.Comments,
	
			(
				select sum(cast(Ordered_Qty as int)) as TotalOrdered 
				from HR_Order_Summary_Import 
				where Group_Order_no = OA.OrderNo and (box_no is not null and round(Ordered_Qty,0) is not null)
			) as totalOrdered,

			case 
				when PT.[Description3] = '101 - PRIMAL' and PM.StorageType ='1' then '101 - PRIMAL'
				when PM.StorageType ='2' then '103 - Frozen'
				when PT.[Description3] = '102 - VL'  then '102 - VL'
				when PT.[Description3] = '103 - OFFAL' then '101 - PRIMAL'
				else '101 - PRIMAL' end as [Description3],

			pr.name,
			pr.inventoryid,
			CASE  when isNull(OA.InProductionStock,0) = 1 then '' ELSE INV.[Name] end AS [Pallet Inventory], --added by KH
			CASE  when isNull(OA.InProductionStock,0) = 1 then '' ELSE INVL.Code end AS [Pallet Location], --added by KH
			PRL.Code,
			os.Site_Comments
			,INV.description3 AS PRDescription3, PK.PRDay
			

	Into	#tmp

	From	HR_Order_Summary_Import OS (nolock)

	left join dbo.HR_Order_Allocation OA (nolock) on OA.HR_BoxNo = OS.Box_No and OS.Group_Order_No = OA.OrderNo
	left join  [FFGSQL06].[FFGProductionPlan].[dbo].[HR_Product_Subs] PS (nolock) on OS.Box_no = PS.Boxno 
	left join  [FFG_DW].[dbo].[ProductTypes] PT (nolock) on PS.[ProductTypeId] = PT.[ProductTypeID]
	left join [FFG_DW].[dbo].[Stock_Packs] PK (nolock) on OA.boxno = pk.sscc
	left join [FFG_DW].[dbo].[Products] PM (nolock) on OA.Productcode = pm.productcode
	left join [FFG_DW].[dbo].[Inventories] PR (nolock) on PR.[site] = pk.siteid and pk.inventoryid = pr.inventoryid
	left join [FFG_DW].[dbo].[InventoryLocations] PRL (nolock) on pk.siteid = PRL.Siteid and pk.inventorylocationid = PRL.inventorylocationID
	left join  [FFG_DW].[dbo].[Pallets] as PAL with (nolock) on PAL.PalletID = pk.PalletID	and oa.siteid = PAL.SiteID	
	--left join  [FFG_DW].[dbo].[Pallets] as PAL with (nolock) on PAL.PalletNumber = OA.PalletNo	and oa.siteid = PAL.SiteID		
	--left join [FFG_DW].[dbo].[Inventories] PR2 (nolock) on PR2.InventoryID = PAL.InventoryID 			---added by Kevin Hargan 16/12/16
	left join  [FFG_DW].[dbo].[InventoryLocations] as INVL with (nolock) on INVL.InventoryLocationID = PAL.[Invlocation] and INVL.siteid = PAL.SiteID	  ---added by Kevin Hargan 16/12/16
	left join  [FFG_DW].[dbo].[Inventories]  as INV with (nolock) on INV.InventoryID = PAL.InventoryID	and INV.[Site] = PAL.SiteID						---added by Kevin Hargan 16/12/16

	where	
		(
			Os.box_no is not null 
			and 
			Os.Product_Name is not null
		) 
		and 
			OA.Orderno is not null
		and 
			os.Group_Order_No = @OrderNo 
		and 
			round(OS.Ordered_Qty ,0) > 0
		and 
			oa.siteid = @SiteID
		
	
	group by pal.palletnumber, PK.PRDay, OA.DNOB, OA.USEBY,OA.SiteID,PalletNo,OA.OrderNo,OA.SubOrderNo,OA.Modified,OS.Modified,OS.Sub_Order_no,OA.OrderDate, OA.ProductCode,OA.InProductionStock,OA.HR_BoxNo,OA.PalletID,
			 OS.VIP,OS.Comments,OS.Ordered_Qty,OS.Product_Name,PT.[Description3],pr.[Name],PRL.Code,StorageType,pr.inventoryid,os.Site_Comments, 
			 INV.[Name], INVL.Code, INV.description3--,INV.description2
	
	order by VIP,PT.[Description3],HR_Boxno, OA.USEBY, OA.DNOB,pr.[Name]



	IF @Addon = 0 and @Sawyers = 0-- Main Picklist report below

	Select 
			OrderNo, 
			OASuborderNo,
			OAModified,
			OSModified,
			OSSuborderNo,
			OAOrderDate,
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
			[Name],
			inventoryid,
			Code,
			Site_Comments, 
			[Pallet Inventory],
			[Pallet Location],
			PRDay
			--,PRDescription3,
			--PRDescription2
			
	From	#tmp

	where	not(siteid = 'FH' and isnull(inventoryid,0) =23) 
			and not(siteid = 'FG' and isnull(inventoryid,0) =75) 
			and not(siteid = 'FO' and isnull(inventoryid,0) =105)
			and (OSSuborderNo = 1) --main picklist criteria
			and NOT OASuborderNo >= 2
			and OAModified <>1  --main picklist criteria
			


	Group By OrderNo, OASuborderNo,OAModified,OSModified,OSSuborderNo,OAOrderDate,ProductCode,PalletNo,Product_Name,Siteid,PRDAY,DNOB,UseBy,ProductionStock,HR_BoxNo,
			 ordered_qty,VIP,Comments,totalOrdered,Description3,[Name],Code,inventoryid,Site_Comments, [Pallet Inventory], [Pallet Location]
			 --,PRDescription3,PRDescription2

	Order By VIP,Description3,HR_Boxno,ProductCode, USEBY, DNOB,[name]

	END

	IF @Addon = 1 and @Sawyers = 0 -- ADD On Picklist report below

	BEGIN
	
	Select 
			OrderNo, 
			OASuborderNo,
			OAModified,
			OSModified,
			OSSuborderNo,
			OAOrderDate,
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
			[Name],
			inventoryid,
			Code,
			Site_Comments, 
			[Pallet Inventory],
			[Pallet Location]
			--,PRDescription3 

	From 
			#tmp

	Where  
		
		OAOrderDate = cast(getdate() as date)
		
		and (
			(OAModified = 1 and OSModified  =1)  --Add on Picklist
			or 
			(OASuborderNo > 1)
			)
		and
			OASuborderNo = OSSuborderNo
		
		--and ISNULL(PRDescription3, '') <> 'SAWYERS' 

		-- exec [dbo].[HR_PickList_ByOrder_BySite_NEW] 116383,3,1,0
		

	Group By 
			OrderNo, OASuborderNo,OAModified,OSModified,OSSuborderNo,OAOrderDate,ProductCode,PalletNo,Product_Name,Siteid,DNOB,UseBy,ProductionStock,HR_BoxNo,
			 ordered_qty,VIP,Comments,totalOrdered,Description3,[Name],Code,inventoryid,Site_Comments, [Pallet Inventory], [Pallet Location], PRDescription3

	Order By
			VIP,
			Description3,
			HR_Boxno, 
			USEBY, 
			DNOB,
			[name]


	END

		IF @Addon = 0 And @Sawyers = 1 -- Sawyers Main Picklist

	Begin

	Select 
			OrderNo, 
			OASuborderNo,
			OAModified,
			OSModified,
			OSSuborderNo,
			OAOrderDate,
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
			[Name],
			inventoryid,
			Code,
			Site_Comments, 
			[Pallet Inventory],
			[Pallet Location],
			PRDescription3

	From	#tmp

	where	OSSuborderNo = 1 --main picklist criteria
			and OAModified <>1  --main picklist criteria
			and PRDescription3 = 'SAWYERS' 

	Group By OrderNo, OASuborderNo,OAModified,OSModified,OSSuborderNo,OAOrderDate,ProductCode,PalletNo,Product_Name,Siteid,DNOB,UseBy,ProductionStock,HR_BoxNo,
			 ordered_qty,VIP,Comments,totalOrdered,Description3,[Name],Code,inventoryid,Site_Comments, [Pallet Inventory], [Pallet Location]
			 , PRDescription3

	Order By VIP,Description3,HR_Boxno, USEBY, DNOB,[name]

	END

	IF @Addon = 1 And @Sawyers = 1 -- Sawyers Add On Picklist

		Begin

		--exec [dbo].[HR_PickList_ByOrder_BySite_NEW] 116383,3,1,0
		
		Select 
				OrderNo, 
				OASuborderNo,
				OAModified,
				OSModified,
				OSSuborderNo,
				OAOrderDate,
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
				[Name],
				inventoryid,
				Code,
				Site_Comments, 
				[Pallet Inventory],
				[Pallet Location]--,
				PRDescription3

		From	#tmp

		Where  OAOrderDate = cast(getdate() as date)
			   and (
					(OAModified = 1 and OSModified  =1)  --Add on Picklist
					or 
						(OASuborderNo > 1)
					)
				and
					OASuborderNo = OSSuborderNo
				and PRDescription3 = 'SAWYERS' 


		Group By OrderNo, OASuborderNo,OAModified,OSModified,OSSuborderNo,OAOrderDate,ProductCode,PalletNo,Product_Name,Siteid,DNOB,UseBy,ProductionStock,HR_BoxNo,
				 ordered_qty,VIP,Comments,totalOrdered,Description3,[Name],Code,inventoryid,Site_Comments, [Pallet Inventory], [Pallet Location]
				 , PRDescription3

		Order By VIP,Description3,HR_Boxno, USEBY, DNOB,[name]

	END

GO
