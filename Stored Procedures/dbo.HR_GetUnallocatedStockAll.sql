SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 20/04/2015
-- Description:	get unalocated stock
-- =============================================
-- exec dbo.[HR_GetUnallocatedStockAll] 2, 111893 ,1,'198'
CREATE PROCEDURE [dbo].[HR_GetUnallocatedStockAll] 
	-- Add the parameters for the stored procedure here
	@SiteID int,
	@OrderNo Bigint,
	@OrderSubNo int,
	@BoxNo nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @today as datetime

	SET @Today = (SELECT DATEADD(day, DATEDIFF(day, 0, getdate()), 0))	

-------------------------------------------------------------------------------------------
--Allocate 1St Choice Products with atleast 2 days life left but no greater than 7
-------------------------------------------------------------------------------------------	



-------------------------------------------------------------------------------------------
--Allocate Substitute Products
-------------------------------------------------------------------------------------------
--union 

	SELECT     
		Hr.Group_Order_No as [OrderNo],
		HR.Sub_Order_No as [SubOrderNo],
		pk.ProductCode, 
		HR.Product_Name,
		ISNULL(col.PalletNumber, ' ') AS PalletNo,  
		--pk.SSCC,
		pk.SiteID,
		Col.PalletId as  PalletId,
		pk.DNOB as DNOB,
		pk.UseBy as Useby,
		HR.Box_No,
		count(*) as PalletQty,
		(
			select sum(cast(isnull([Ordered_Qty],0) as Int)) 
			from [FFG_DW].[dbo].[HR_Order_Summary_Import] AS OI with (nolock)
			where  isnumeric(OI.[Box_No])=1 and cast(OI.[Box_No] as int) = @BoxNo 
				and OI.[Group_Order_No] = @OrderNo 
				and OI.[Sub_Order_No] = @OrderSubNo 
		) 
		-
		(
			select count(*) from HR_Order_Allocation AS OA with (nolock) 
			where OA.HR_BoxNo= @BoxNo 
			and OA.[OrderNo] = @OrderNo 
			and OA.[SubOrderNo] = @OrderSubNo
		)
		as QtyRequired,

		(
			select count(*) 
			from HR_Order_Allocation AS OA with (nolock)
			where OA.HR_BoxNo= @BoxNo 
				and OA.[OrderNo] = @OrderNo 
				and OA.[SubOrderNo] = @OrderSubNo
		) TotalAllocated,
	
		pr.name as stockLoc

	FROM	
		HR_Order_Summary_import AS HR with (nolock)  INNER JOIN
		[FFGSQL06].[FFGProductionPlan].[dbo].HR_Product_Subs AS HPS with (nolock)
		ON HR.Box_No = HPS.BoxNo 
		cross apply [dbo].[Split](HPS.Substitues,',') S  
		INNER JOIN
			Stock_Packs AS pk WITH (nolock) ON cast(pk.ProductCode as Nvarchar(15))  = S.Item 
		Inner Join
			Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode 
		Inner Join
			Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site 
		INNER JOIN
			Pallets AS col WITH (nolock) ON isnull(pk.PalletID,9999) = isnull(col.PalletID,9999) and pk.siteid = col.siteid 
		LEFT OUTER JOIN
			ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode 
		LEFT OUTER JOIN
			CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID 
		
	WHERE  
		HR.Box_No = @BoxNo 
		and 
		pk.siteid = @siteid 
		and 
		HR.Group_Order_no = @OrderNo 
		and 
		Hr.Sub_Order_no =  @OrderSubNo 
		and
		--mat1.storageType = 1 and 
		pr.InventoryTypeID = 1 
		and 
		(ISNULL(con.name, 'N/A') like '%HILTON%' OR ISNULL(con.name, 'N/A') like '%DROGHEDA%' )
		and 
		round(HR.[Ordered_Qty],0) > 0
		and 
		(
			pr.Name <> 'Order Returns'
			or 
			pr.Name <> 'Beef Returns'
		) 
		and  
		pr.Name <> 'Ready to Ship'
		and 
		pr.name <> 'Stock on hold'
		and 
		pr.name <> 'QC Stock'
		and 
		pr.name <> 'QC Hold'
		and NOT 
		(pr.name like '%QC%')
		and 
		pr.name <> 'Chill D Floor' 
		and pr.Name <> 'Returns' -- added by KH 13/11/18 on Ryan Maybin Request
		and  
		(datediff("d", HR.Delivery_Date,pk.UseBy) > = 1) 
		and
		(HR.box_no is not null and Hr.Ordered_Qty is not null)
		--and pk.DNOB >= (HR.Delivery_Date - 1) and pk.UseBy >= (HR.Delivery_Date + 3)
		and NOT EXISTS 
		(
			select * 
			FROM [FFG_DW].[dbo].[HR_Order_Allocation] oA3 with (nolock) 
			where oA3.BoxNo  = pk.SSCC 
				and oA3.[SiteID] = pk.SiteID 
				and oA3.OrderDate = cast(HR.OrderDate as date)
		)
	Group By 
		pk.ProductCode,  
		ISNULL(col.PalletNumber, ' '), 
		HR.Product_Name, 
		Col.PalletId,
		pk.SiteID,
		pk.DNOB,
		pk.UseBy,
		Hr.Group_Order_No,
		HR.Sub_Order_No,
		HR.Box_No,pr.name
	
	
-------------------------------------------------------------------------------------------
--Allocate P2 Substitute Products
-------------------------------------------------------------------------------------------
UNION
	SELECT     
		Hr.Group_Order_No as [OrderNo],
		HR.Sub_Order_No as [SubOrderNo],
		pk.ProductCode, 
		HR.Product_Name,
		ISNULL(col.PalletNumber, ' ') AS PalletNo,  
		--pk.SSCC,
		pk.SiteID,
		Col.PalletId as  PalletId,
		pk.DNOB as DNOB,
		pk.UseBy as Useby,
		HR.Box_No,
		count(*) as PalletQty,
		(
			select sum(cast(isnull([Ordered_Qty],0) as Int)) 
			from [FFG_DW].[dbo].[HR_Order_Summary_Import] AS OI with (nolock)
			where  isnumeric(OI.[Box_No])=1 
				and cast(OI.[Box_No] as int) = @BoxNo 
				and OI.[Group_Order_No] = @OrderNo 
				and OI.[Sub_Order_No] = @OrderSubNo 
			)-( 
			select count(*) from HR_Order_Allocation AS OA  with (nolock)
			where OA.HR_BoxNo= @BoxNo 
				and OA.[OrderNo] = @OrderNo 
				and OA.[SubOrderNo] = @OrderSubNo
		)as QtyRequired,

		(
			select count(*) from HR_Order_Allocation AS OA  with (nolock)
			where OA.HR_BoxNo= @BoxNo 
				and OA.[OrderNo] = @OrderNo 
				and OA.[SubOrderNo] = @OrderSubNo
		) TotalAllocated,
		
		pr.name as stockLoc
	
	FROM	
		HR_Order_Summary_import AS HR  
		INNER JOIN
			[FFGSQL06].[FFGProductionPlan].[dbo].HR_Product_Subs AS HPS with (nolock) ON HR.Box_No = HPS.BoxNo 
			Cross Apply
				[dbo].[Split](HPS.SubstituesP2,',') S  
			INNER JOIN 
				Stock_Packs AS pk WITH (nolock) ON cast(pk.ProductCode as Nvarchar(15))  = S.Item 
			Inner Join
				Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode 
			Inner Join
				Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site 
			INNER JOIN
				Pallets AS col WITH (nolock) ON isnull(pk.PalletID,9999) = isnull(col.PalletID,9999) and pk.siteid = col.siteid 
			LEFT OUTER JOIN
				ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode 
			left outer join
				CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID 
		
		WHERE  
			HR.Box_No = @BoxNo 
			and pk.siteid = @siteid 
			and HR.Group_Order_no = @OrderNo 
			and Hr.Sub_Order_no =  @OrderSubNo 
			and pr.InventoryTypeID = 1 
			AND  (ISNULL(con.name, 'N/A') like '%HILTON%' OR ISNULL(con.name, 'N/A') like '%DROGHEDA%' )
			and round(HR.[Ordered_Qty],0) > 0
			and 
			(
				pr.Name <> 'Order Returns'
				or 
				pr.Name <> 'Beef Returns'
			) 
			and  pr.Name <> 'Ready to Ship'
			and pr.name <> 'Stock on hold'
			and pr.name <> 'Chill D' 
			and NOT (pr.name like '%QC%')
			and pr.name <> 'QC Stock'
			and pr.name <> 'Chill D Floor' 
			and pr.Name <> 'Returns' -- added by KH 13/11/18 on Ryan Maybin Request
			and (datediff("d", HR.Delivery_Date,pk.UseBy) > = 1) 
			and(HR.box_no is not null and Hr.Ordered_Qty is not null)
			and NOT EXISTS 
			(
				select * 
				FROM [FFG_DW].[dbo].[HR_Order_Allocation] oA3  with (nolock)
				where 
					oA3.BoxNo  = pk.SSCC 
					and oA3.[SiteID] = pk.SiteID 
					and oA3.OrderDate = cast(HR.OrderDate as date)
			)
			Group By 
				pk.ProductCode,  
				ISNULL(col.PalletNumber, ' '), 
				HR.Product_Name, 
				Col.PalletId,
				pk.SiteID,
				pk.DNOB,
				pk.UseBy,
				Hr.Group_Order_No,
				HR.Sub_Order_No,
				HR.Box_No,
				pr.name

UNION

-------------------------------------------------------------------------------------------
--Allocate Substitute Products with atleast 2 days life left but no greater than 7
-------------------------------------------------------------------------------------------


	SELECT     
		Hr.Group_Order_No as [OrderNo],
		HR.Sub_Order_No as [SubOrderNo],
		pk.ProductCode, 
		HR.Product_Name,
		ISNULL(col.PalletNumber, ' ') AS PalletNo,  
		--pk.SSCC,
		pk.SiteID,
		Col.PalletId as  PalletId,
		pk.DNOB as DNOB,
		pk.UseBy as Useby,
		HR.Box_No,
		count(*) as PalletQty,
		(
			select sum(cast(isnull([Ordered_Qty],0) as Int)) 
			from [FFG_DW].[dbo].[HR_Order_Summary_Import] AS OI with (nolock)
			where  
				isnumeric(OI.[Box_No])=1 
				and cast(OI.[Box_No] as int) = @BoxNo 
				and OI.[Group_Order_No] = @OrderNo 
				and OI.[Sub_Order_No] = @OrderSubNo 
		) - (
			select count(*) 
			from HR_Order_Allocation AS OA 
			where 
				OA.HR_BoxNo= @BoxNo 
				and OA.[OrderNo] = @OrderNo 
				and OA.[SubOrderNo] = @OrderSubNo
		) as QtyRequired,
		(
			select count(*) 
			from HR_Order_Allocation AS OA  with (nolock)
			where 
				OA.HR_BoxNo= @BoxNo 
				and OA.[OrderNo] = @OrderNo 
				and OA.[SubOrderNo] = @OrderSubNo
		) TotalAllocated,
		pr.name as stockLoc
		FROM	
			HR_Order_Summary_import AS HR   with (nolock) 
			INNER JOIN [FFGSQL06].[FFGProductionPlan].[dbo].HR_Product_Subs AS HPS  with (nolock) ON HR.Box_No = HPS.BoxNo 
			cross apply
				[dbo].[Split](HPS.Substitues,',') S  
			INNER JOIN
				Stock_Packs AS pk WITH (nolock) ON cast(pk.ProductCode as Nvarchar(15))  = S.Item 
			Inner Join
				Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode 
			Inner Join
				Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site 
			INNER JOIN
				Pallets AS col WITH (nolock) ON isnull(pk.PalletID,9999) = isnull(col.PalletID,9999) and pk.siteid = col.siteid 
			LEFT OUTER JOIN
				ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode 
			left outer join
				CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID 
		
		WHERE  
			HR.Box_No = @BoxNo 
			and pk.siteid = @siteid 
			and HR.Group_Order_no = @OrderNo 
			and Hr.Sub_Order_no =  @OrderSubNo 
			and pr.InventoryTypeID = 1 
			AND  (ISNULL(con.name, 'N/A') like '%HILTON%' OR ISNULL(con.name, 'N/A') like '%DROGHEDA%' )
			and round(HR.[Ordered_Qty],0) > 0
			and 
				(
					pr.Name <> 'Order Returns'
					or 
					pr.Name <> 'Beef Returns'
				) 
			and pr.Name <> 'Ready to Ship'
			and pr.name <> 'Chill D' 
			and NOT (pr.name like '%QC%')
			and pr.name <> 'QC Stock'
			and pr.name <> 'Chill D Floor' 
			and pr.Name <> 'Returns' -- added by KH 13/11/18 on Ryan Maybin Request
			and(HR.box_no is not null and Hr.Ordered_Qty is not null)
			and (datediff("d", HR.Delivery_Date,pk.UseBy) > = 1)
			and NOT EXISTS (
				select * FROM [FFG_DW].[dbo].[HR_Order_Allocation] oA3  with (nolock)
				where 
					oA3.BoxNo = pk.SSCC 
					and 
					oA3.[SiteID] = pk.SiteID 
					and 
					oA3.OrderDate = cast(HR.OrderDate as date)
			)
		
		Group By 
			pk.ProductCode,  
			ISNULL(col.PalletNumber, ' '), 
			HR.Product_Name, 
			Col.PalletId,
			pk.SiteID,
			pk.DNOB,
			pk.UseBy,
			Hr.Group_Order_No,
			HR.Sub_Order_No,
			HR.Box_No,
			pr.name

-------------------------------------------------------------------------------------------
--Allocate 1St Choice Products with atleast 2 days life left but no greater than 7
-------------------------------------------------------------------------------------------



union
-------------------------------------------------------------------------------------------
--Allocate DownGrade Selected Products with atleast 2 days life left but no greater than 7
-------------------------------------------------------------------------------------------
	SELECT    --HR.OrderNO, 
		Hr.Group_Order_No as [OrderNo],
		HR.Sub_Order_No as [SubOrderNo],
		pk.ProductCode, 
		HR.Product_Name,
		ISNULL(col.PalletNumber, ' ') AS PalletNo,  
		--pk.SSCC,
		pk.SiteID,
		Col.PalletId as  PalletId,
		pk.DNOB as DNOB,
		pk.UseBy as Useby,
		HR.Box_No,
		count(*) as PalletQty,
		(
			select sum(cast(isnull([Ordered_Qty],0) as Int)) 
			from [FFG_DW].[dbo].[HR_Order_Summary_Import] AS OI  with (nolock) 
			where 
				isnumeric(OI.[Box_No])=1 and cast(OI.[Box_No] as int) = @BoxNo 
				and OI.[Group_Order_No] = @OrderNo 
				and OI.[Sub_Order_No] = @OrderSubNo 
		) -( 
			select count(*) 
			from HR_Order_Allocation AS OA with (nolock) 
			where 
				OA.HR_BoxNo= @BoxNo 
				and OA.[OrderNo] = @OrderNo 
				and OA.[SubOrderNo] = @OrderSubNo)
		as QtyRequired,
		
		(
			select count(*) 
			from HR_Order_Allocation AS OA  with (nolock)
			where 
				OA.HR_BoxNo= @BoxNo 
				and OA.[OrderNo] = @OrderNo 
				and OA.[SubOrderNo] = @OrderSubNo
		) TotalAllocated,
		pr.name as stockLoc
	FROM	
		HR_Order_Summary_import AS HR   with (nolock)
		INNER JOIN
			[FFGSQL06].[FFGProductionPlan].[dbo].HR_Product_Subs AS HPS  with (nolock) ON HR.Box_No = HPS.BoxNo 
		Cross Apply
			[dbo].[Split](HPS.DownGrades,',') S  
		INNER JOIN
			Stock_Packs AS pk WITH (nolock) ON cast(pk.ProductCode as nvarchar(15)) = S.Item 
		Inner Join
			Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode 
		Inner Join
			Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site 
		INNER JOIN
			Pallets AS col WITH (nolock) ON isnull(pk.PalletID,9999) = isnull(col.PalletID,9999) 
				and pk.siteid = col.siteid 
		LEFT OUTER JOIN
			ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode 
		left outer join
			CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID 
		
	WHERE  
		HR.Box_No = @BoxNo 
		and pk.siteid = @siteid 
		and HR.Group_Order_NO = @OrderNo 
		and  HR.[Sub_Order_No] = @OrderSubNo 
		and pr.InventoryTypeID = 1 
		and (datediff("d", HR.Delivery_Date,pk.UseBy) > = 2) 
		AND  (ISNULL(con.name, 'N/A') like '%HILTON%' OR ISNULL(con.name, 'N/A') like '%DROGHEDA%' )
		and (pr.Name <> 'Order Returns'
		or pr.Name <> 'Beef Returns' ) 
		and  pr.Name <> 'Ready to Ship'
		and pr.name <> 'Chill D' 
		and NOT (pr.name like '%QC%')
		and pr.name <> 'QC Stock'
		and pr.name <> 'Chill D Floor' 
		and pr.Name <> 'Returns' -- added by KH 13/11/18 on Ryan Maybin Request
		and(HR.box_no is not null and Hr.product_name is not null)
		and round(HR.[Ordered_Qty],0) > 0
		and NOT EXISTS 
		(
			select * 
			FROM [FFG_DW].[dbo].[HR_Order_Allocation] oA3  with (nolock)
			where 
				oA3.BoxNo  = pk.SSCC 
				and oA3.[SiteID] = pk.SiteID 
				and oA3.OrderDate = cast(HR.OrderDate as date)
		)
		
	Group By 
		pk.ProductCode,  
		ISNULL(col.PalletNumber, ' '), 
		HR.Product_Name, 
		Col.PalletId,
		pk.SiteID,
		pk.DNOB,
		pk.UseBy,
		Hr.Group_Order_No,
		HR.Sub_Order_No,
		HR.Box_No,pr.name

	order by 
		pk.useby

END

GO
