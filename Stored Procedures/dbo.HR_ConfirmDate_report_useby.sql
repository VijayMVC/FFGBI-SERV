SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 08/06/2015
-- Description:	added for use by
-- =============================================
--exec dbo.HR_ConfirmDate_report_useby 102077
CREATE PROCEDURE [dbo].[HR_ConfirmDate_report_useby] 
@OrderNo Int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	Select OA.OrderNo,OA.SubOrderNo,OA.ProductCode,
case when isNull(OA.InProductionStock,0) = 1 then ''
else OA.PalletNo end as PalletNo,
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
--count(OA.HR_BoxNo) as QTY,
OS.VIP,OS.Comments,
(select sum(cast(Ordered_Qty as int)) as TotalOrdered from HR_Order_Summary_Import where Group_Order_no = OA.OrderNo and (box_no is not null and round(Ordered_Qty,0) is not null)) as totalOrdered
,--PT.[Description3],
case when PT.[Description3] = '101 - PRIMAL' then '101 - PRIMAL'
when PM.StorageType ='2' then '103 - Frozen'
when PT.[Description3] = '102 - VL'  then '102 - VL'
when PT.[Description3] = '103 - OFFAL' then '101 - PRIMAL'
else '101 - PRIMAL' end as [Description3],
pr.name,
PRL.Code,
OS.Delivery_Date
Into #tmp
From HR_Order_Summary_Import OS (nolock)
left join dbo.HR_Order_Allocation OA (nolock) on OA.HR_BoxNo = OS.Box_No and OS.Group_Order_No = OA.OrderNo
left join  [FFGSQL06].[FFGProductionPlan].[dbo].[HR_Product_Subs] PS (nolock) on OS.Box_no = PS.Boxno 
left join  [FFG_DW].[dbo].[ProductTypes] PT (nolock) on PS.[ProductTypeId] = PT.[ProductTypeID]
left join [FFG_DW].[dbo].[Stock_Packs] PK (nolock) on OA.boxno = pk.sscc
left join [FFG_DW].[dbo].[Products] PM (nolock) on OA.Productcode = pm.productcode
left join [FFG_DW].[dbo].[Inventories] PR (nolock) on PR.[site] = pk.siteid and pk.inventoryid = pr.inventoryid
left join [FFG_DW].[dbo].[InventoryLocations] PRL (nolock) on pk.siteid = PRL.Siteid and pk.inventorylocationid = PRL.inventorylocationID
where (Os.box_no is not null and Os.Product_Name is not null) and OA.Orderno is not null
and os.Group_Order_No = @OrderNo and round(OS.Ordered_Qty ,0) > 0 and datepart(year,oA.OrderDate) = DATEPART(year, getdate())
group by OA.DNOB, OA.USEBY,OA.SiteID,PalletNo,OA.OrderNo,OA.SubOrderNo,OA.ProductCode,OA.InProductionStock,OA.HR_BoxNo,OA.PalletID,OS.VIP,OS.Comments,OS.Ordered_Qty,OS.Product_Name,PT.[Description3],pr.name,PRL.Code,StorageType,OS.Delivery_Date
order by VIP,PT.[Description3],HR_Boxno, OA.USEBY, OA.DNOB,pr.name


Select distinct 
TP.OrderNo,right(TP.ProductCode,3) as boxno,
(select Ordered_Qty from dbo.HR_Order_Summary_import where Group_Order_No =TP.OrderNo and Box_No = TP.HR_BoxNo) as Ordered_Qty ,
(select Product_Name from dbo.HR_Order_Summary_import where Box_No =right(TP.ProductCode,3) and Group_Order_No =TP.OrderNo) as ProductName,
(select Sum(QTY)as confiredQty from #tmp where Orderno = TP.OrderNo and ProductCode =TP.ProductCode and DNOB =TP.DNOB and UseBy= TP.UseBy and siteid =tp.siteid) as confiredQty,

TP.DNOB,TP.UseBy,
Siteid,
TP.HR_BoxNo
From #tmp TP
where  --TP.DNOB >= (TP.Delivery_Date + 0.5) --OR 
TP.UseBy <= (TP.Delivery_Date + 5)
Group By 
TP.DNOB,TP.UseBy,TP.OrderNo,TP.ProductCode,TP.ordered_qty,TP.[Description3],TP.QTY,Product_Name,TP.HR_BoxNo,Siteid
--Order By TP.[Description3]
--order by useby

Drop Table #tmp




END
GO
