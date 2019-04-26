SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 19/05/2015
-- Description:	Allocated vs what is scanned to order for IRE
-- =============================================
--exec HR_Allocated_VS_ScannedToOrder_Ireland 101447
CREATE PROCEDURE [dbo].[ARCHIVED_HR_Allocated_VS_ScannedToOrder_Ireland] 
@OrderNo bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

CREATE TABLE #TempInnovaOrder(
OrderNo nvarchar(max),
HR_BoxNo int,
ProductCode nvarchar(15),
Pallet bigint,
DNOB datetime,
Useby datetime,
[Site] int,
[Type] nvarchar(max),
Qty int
)

insert into #TempInnovaOrder
select OrderNo,HR_BoxNo,ProductCode,PalletNo,
DNOB,UseBy,siteid, 'Allocation', Count(productcode) as Qty
from dbo.HR_Order_Allocation
where OrderNo = @OrderNo 
and isnull(InProductionStock,0) <> 1
Group by OrderNo,HR_BoxNo,ProductCode,PalletNo,DNOB,UseBy,siteid

CREATE TABLE #TempOrder(
OrderNo nvarchar(max)
)
declare @NAVOrder nvarchar(15)
set @NAVOrder = ('%' + cast(@OrderNo as nvarchar(15))  + '%')

insert into #TempOrder select ''''+[Order No_]+'''' from [DMP_NAVSERV].[DMP-Production].dbo.[DMP - LIVE$Sales Shipment Header] where [External Document No_] like @NAVOrder 
--insert into #TempOrder select ''''+[Order No_]+'''' from [NAVSERV_OMA].[OMA-Production].dbo.[OMA - LIVE$Sales Shipment Header] where [External Document No_] =cast(@OrderNo as nvarchar(15)) 
--insert into #TempOrder select ''''+[Order No_]+'''' from [HMC_NAVSERV].[HMC-Production].dbo.[HMC - LIVE$Sales Shipment Header]where [External Document No_] =cast(@OrderNo as nvarchar(15)) 
--insert into #TempOrder select ''''+[Order No_]+'''' from [FG-NAVSERV].[FG Production].dbo.[gloucester - LIVE$Sales Shipment Header]where [External Document No_] =cast(@OrderNo as nvarchar(15)) 

DECLARE @combinedString nvarchar(MAX)

SELECT @combinedString = COALESCE(@combinedString + ',', '') + Orderno 
 from #TempOrder 
 
 --select @combinedString
 
DECLARE @SQLFD NVARCHAR(Max)

--Donegal

set @SQLFD = 
'select PO.name,NULL,PM.Code,PC.Number,PK.expire3 as DNOB,PK.expire1 as useby,''1'' as siteid, ''Innova'',
Count(PM.Code) as Qty
from [DMP-SQL02].[INNOVA].dbo.[proc_packs]  PK (nolock)
inner join [DMP-SQL02].[INNOVA].dbo.[vw_OrderswithNoXML] PO (nolock)  on pk.[order] = PO.[order]
left join [DMP-SQL02].[INNOVA].dbo.[vw_matswithNoXML] PM  (nolock) on PK.material = PM.Material
left join [DMP-SQL02].[INNOVA].dbo.[proc_collections] PC (nolock)  on PK.Pallet = PC.ID
where PO.name in ('+@combinedString+') group by PO.name,PM.Code,PC.Number,PK.expire3,PK.expire1'



Begin 

insert into #TempInnovaOrder exec sp_executesql @SQLFD  

end

--select orderno,ProductCode, Pallet, DNOB, Useby, [Site],[Type], 
--Count(productcode) as Qty
--from #TempInnovaOrder
--group by  orderno,ProductCode, Pallet, DNOB, Useby, [Site],[Type]


select TP.orderno,TP.ProductCode,TP.HR_BoxNo,
--TP.pallet as InnovaPallet,
TP.DNOB as InnovaDNOB,
TP.Useby as InnovaUseby,
TP.[Site] as InnovaSite,
TP.QTY,
TP.[Type],
--case when TP.DNOB =(select DNOB from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and [site] = tp.[site] and DNOB = TP.DNOB and useby = TP.useby )then--and qty =TP.qty)then 
(select cast(DNOB as date) from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and cast(DNOB as date) = cast(TP.DNOB as date) and cast(useby as date) = cast(TP.useby as date) and qty =TP.qty),
--else 0 end as DNOBAllocation,
--case when TP.Useby =(select Useby from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and [site] = tp.[site] and DNOB = TP.DNOB and useby = TP.useby  and qty =TP.qty)then 
(select cast(Useby as date)  from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and cast(DNOB as date) = cast(TP.DNOB as date) and cast(useby as date) = cast(TP.useby as date) and qty =TP.qty ),
--else 0 end as UsebyAllocation,
--case when TP.[Site] =(select [Site] from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and [site] = tp.[site] and DNOB = TP.DNOB and useby = TP.useby  and qty =TP.qty)then 

(select [Site] from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and [site] = tp.[site]  and cast(DNOB as date) = cast(TP.DNOB as date) and cast(useby  as date) = cast(TP.useby as date) and qty =TP.qty),

--else 0 end as SiteAllocation,
--case when TP.Qty =(select Qty from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and [site] = tp.[site] and DNOB = TP.DNOB and useby = TP.useby  and qty =TP.qty)then 

(select Qty from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and [site] = tp.[site]  and cast(DNOB  as date) = cast(TP.DNOB as date) and cast(useby  as date) = cast(TP.useby as date)  and qty =TP.qty)

--else 0 end as QtyAllocation
--case when TP.DNOB =(select DNOB from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and Orderno =TP.orderno and [site] = tp.[site])then 
--(select pallet from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and Orderno =TP.orderno and [site] = tp.[site])
--else 0 end as DNOBAllocation,
--case when TP.Useby =(select Useby from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and Orderno =TP.orderno and [site] = tp.[site])then 
--(select pallet from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and Orderno =TP.orderno and [site] = tp.[site])
--else 0 end as UsebyAllocation,
--case when TP.Useby =(select Useby from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and Orderno =TP.orderno and [site] = tp.[site])then 
--(select pallet from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and Orderno =TP.orderno and [site] = tp.[site])
--else 0 end as UsebyAllocation,

--(select DNOB from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and Orderno =TP.orderno and Pallet = TP.Pallet) as DNOBAllocation,
--(select Useby from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and Orderno =TP.orderno and Pallet = TP.Pallet) as UsebyAllocation,
--(select [Site] from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and Orderno =TP.orderno and Pallet = TP.Pallet) as SiteAllocation,
--(select Count(productcode) as Qty from #TempInnovaOrder where productcode = TP.productcode and [Type] = 'Allocation' and Orderno =TP.orderno and Pallet = TP.Pallet) as QtyAllocation
from #TempInnovaOrder TP
where TP.[type] = 'Innova' 
group by  TP.orderno,TP.HR_BoxNo,TP.ProductCode, TP.DNOB, TP.Useby, TP.[Site],QTY,[Type],TP.pallet
--Order by  Dnoballocation, usebyallocation, siteallocation, qtyallocation
END
GO
