SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 18/05/2015
-- Description:	compare what has been allocated to what has been scanned to order
-- =============================================

-- exec HR_Allocated_VS_ScannedToOrder 102223
CREATE PROCEDURE [dbo].[ARCHIVED_HR_Allocated_VS_ScannedToOrder] 
@OrderNo nvarchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

CREATE TABLE #TempInnovaOrder(
OrderNo nvarchar(100),
HR_BoxNo nvarchar(5),
ProductCode nvarchar(15),
Pallet bigint,
DNOB datetime,
Useby datetime,
[Site] int,
[Type] nvarchar(100),
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
insert into #TempOrder select ''''+[Order No_]+'''' from [FM_NAVSERV].[FM-Production].dbo.[FM - LIVE$Sales Shipment Header] where [External Document No_] like @NAVOrder
insert into #TempOrder select ''''+[Order No_]+'''' from [NAVSERV_OMA].[OMA-Production].dbo.[OMA - LIVE$Sales Shipment Header] where [External Document No_] like @NAVOrder
insert into #TempOrder select ''''+[Order No_]+'''' from [HMC_NAVSERV].[HMC-Production].dbo.[HMC - LIVE$Sales Shipment Header]where [External Document No_] like @NAVOrder
insert into #TempOrder select ''''+[Order No_]+'''' from [FG-NAVSERV].[FG Production].dbo.[gloucester - LIVE$Sales Shipment Header]where [External Document No_] like @NAVOrder

insert into #TempOrder select ''''+[No_]+'''' from [DMP_NAVSERV].[DMP-Production].dbo.[DMP - LIVE$Sales Header] where [External Document No_] like @NAVOrder 
insert into #TempOrder select ''''+[No_]+'''' from [FM_NAVSERV].[FM-Production].dbo.[FM - LIVE$Sales Header] where [External Document No_] like @NAVOrder
insert into #TempOrder select ''''+[No_]+'''' from [NAVSERV_OMA].[OMA-Production].dbo.[OMA - LIVE$Sales Header] where [External Document No_] like @NAVOrder
insert into #TempOrder select ''''+[No_]+'''' from [HMC_NAVSERV].[HMC-Production].dbo.[HMC - LIVE$Sales Header]where [External Document No_] like @NAVOrder
insert into #TempOrder select ''''+[No_]+'''' from [FG-NAVSERV].[FG Production].dbo.[gloucester - LIVE$Sales Header]where [External Document No_] like @NAVOrder


DECLARE @combinedString nvarchar(MAX)

SELECT @combinedString = COALESCE(@combinedString + ',', '') + Orderno 
 from #TempOrder 
 
-- select @combinedString
 
DECLARE @SQLFC NVARCHAR(Max), @SQLFO NVARCHAR(Max),@SQLFH NVARCHAR(Max),@SQLFG NVARCHAR(Max),@SQLFD NVARCHAR(Max)

--Campsie

set @SQLFC = 
'select PO.name,NULL,PM.Code,PC.Number,PK.expire3 as DNOB,PK.expire1 as useby,''1'' as siteid, ''Innova'',
Count(PM.Code) as Qty
from [FM-SQL01].[INNOVA].dbo.[proc_packs]  PK (nolock)
inner join [FM-SQL01].[INNOVA].dbo.[vw_OrderswithNoXML] PO (nolock)  on pk.[order] = PO.[order]
left join [FM-SQL01].[INNOVA].dbo.[vw_matswithNoXML] PM  (nolock) on PK.material = PM.Material
left join [FM-SQL01].[INNOVA].dbo.[proc_collections] PC (nolock)  on PK.Pallet = PC.ID
where PO.name in ('+@combinedString+') group by PO.name,PM.Code,PC.Number,PK.expire3,PK.expire1'

--Omagh
set @SQLFO = 
'select PO.name,NULL,PM.Code,PC.Number,PK.expire3 as DNOB,PK.expire1 as useby,''2'' as siteid, ''Innova'',
Count(PM.Code) as Qty
from [FFG-SQL01].[INNOVA].dbo.[proc_packs]  PK (nolock)
inner join [FFG-SQL01].[INNOVA].dbo.[vw_OrderswithNoXML] PO (nolock)  on pk.[order] = PO.[order]
left join [FFG-SQL01].[INNOVA].dbo.[vw_matswithNoXML] PM  (nolock) on PK.material = PM.Material
left join [FFG-SQL01].[INNOVA].dbo.[proc_collections] PC (nolock)  on PK.Pallet = PC.ID
where PO.name in ('+@combinedString+')group by PO.name,PM.Code,PC.Number,PK.expire3,PK.expire1'

--Cookstown
set @SQLFH  = 
'select PO.name,NULL,PM.Code,PC.Number,PK.expire3 as DNOB,PK.expire1 as useby,''3'' as siteid, ''Innova'',
Count(PM.Code) as Qty
from [HMCSQL1].[INNOVA].dbo.[proc_packs]  PK (nolock)
inner join [HMCSQL1].[INNOVA].dbo.[vw_OrderswithNoXML] PO (nolock)  on pk.[order] = PO.[order]
left join [HMCSQL1].[INNOVA].dbo.[vw_matswithNoXML] PM  (nolock) on PK.material = PM.Material
left join [HMCSQL1].[INNOVA].dbo.[proc_collections] PC (nolock)  on PK.Pallet = PC.ID
where PO.name in ('+@combinedString+')group by PO.name,PM.Code,PC.Number,PK.expire3,PK.expire1'

--Gloucester
set @SQLFG = 
'select PO.name, NULL,PM.Code,PC.Number,PK.expire3 as DNOB,PK.expire1 as useby,''5'' as siteid, ''Innova'',
Count(PM.Code) as Qty
from [FG-SQL02].[INNOVA].dbo.[proc_packs]  PK (nolock)
inner join [FG-SQL02].[INNOVA].dbo.[vw_OrderswithNoXML] PO (nolock)  on pk.[order] = PO.[order]
left join [FG-SQL02].[INNOVA].dbo.[vw_matswithNoXML] PM  (nolock) on PK.material = PM.Material
left join [FG-SQL02].[INNOVA].dbo.[proc_collections] PC (nolock)  on PK.Pallet = PC.ID
where PO.name in ('+@combinedString+')group by PO.name,PM.Code,PC.Number,PK.expire3,PK.expire1'


set @SQLFD = 
'select PO.name,NULL,PM.Code,PC.Number,PK.expire3 as DNOB,PK.expire1 as useby,''1'' as siteid, ''Innova'',
Count(PM.Code) as Qty
from [DMP-SQL02].[INNOVA].dbo.[proc_packs]  PK (nolock)
inner join [DMP-SQL02].[INNOVA].dbo.[vw_OrderswithNoXML] PO (nolock)  on pk.[order] = PO.[order]
left join [DMP-SQL02].[INNOVA].dbo.[vw_matswithNoXML] PM  (nolock) on PK.material = PM.Material
left join [DMP-SQL02].[INNOVA].dbo.[proc_collections] PC (nolock)  on PK.Pallet = PC.ID
where PO.name in ('+@combinedString+') group by PO.name,PM.Code,PC.Number,PK.expire3,PK.expire1'



Begin 

insert into #TempInnovaOrder exec sp_executesql @SQLFC   
insert into #TempInnovaOrder exec sp_executesql @SQLFO
insert into #TempInnovaOrder exec sp_executesql @SQLFH 
insert into #TempInnovaOrder exec sp_executesql @SQLFG
insert into #TempInnovaOrder exec sp_executesql @SQLFD  
end

-- used for allocation info
select TP.orderno,TP.ProductCode, TP.DNOB, TP.Useby, TP.[Site], Sum(qty) as Qty,[type],PS.[Priority]
into #TMP
from #TempInnovaOrder TP
left join FFGProductionPlan.dbo.HR_Product_Subs PS on right(TP.productcode,3) = cast(PS.Boxno as bigint)
group by TP.orderno,TP.ProductCode, TP.DNOB, TP.Useby, TP.[Site],[type],PS.[Priority]

-- used for innova info
--select TP.orderno,TP.ProductCode,
--(select Product_Name from dbo.HR_Order_Summary_import where Box_No =right(TP.ProductCode,3) and Group_Order_No  =TP.OrderNo) as ProductName,
--cast(TP.DNOB as date) as InnovaDNOB,
--cast(TP.Useby as date)  as InnovaUseby,
--TP.[Site] as InnovaSite,
--QTY as InnovaQTY,
--(select cast(DNOB as date) from #TMP  where productcode = TP.productcode and [Type] = 'Allocation' and useby = TP.useby and DNOB = TP.DNOB and qty =sum(TP.qty) and [site] = TP.[site]) as DNOBAllocation,
--(select cast(Useby as date) from #TMP  where productcode = TP.productcode and [Type] = 'Allocation' and useby = TP.useby and DNOB = TP.DNOB  and qty =sum(TP.qty)and [site] = TP.[site])as UsebyAllocation,
--(select sum(Qty) from #TMP  where productcode = TP.productcode and [Type] = 'Allocation' and DNOB = TP.DNOB and useby = TP.useby and qty =sum(TP.qty)and [site] = TP.[site])as QtyAllocation,
--Tp.[type],
--TP.[Priority]
--into #TMP2
--From #TMP TP
--where 
--TP.[type] = 'Innova'  
--group by TP.orderno,TP.ProductCode, TP.DNOB, TP.Useby, TP.[Site],qty,Tp.[type],TP.[Priority]



select TP.orderno,TP.ProductCode,null as productname,
--(select Product_Name from dbo.HR_Order_Summary_import where Box_No =right(TP.ProductCode,3) and Group_Order_No =TP.OrderNo) as ProductName,
cast(TP.DNOB as date) as InnovaDNOB,
cast(TP.Useby as date)  as InnovaUseby,
TP.[Site] as InnovaSite,
QTY as InnovaQTY,
--(select Ordered_Qty from dbo.HR_Order_Summary_import where Group_Order_No = TP.orderno and Box_No = TP.HR_BoxNo) as OrderedQty,
(select cast(DNOB as date) from #TMP  where productcode = TP.productcode and [Type] = 'Allocation' and useby = TP.useby and DNOB = TP.DNOB and qty =sum(TP.qty) and [site] = TP.[site])as AllocationDNOB,

(select cast(Useby as date) from #TMP  where productcode = TP.productcode and [Type] = 'Allocation' and useby = TP.useby and DNOB = TP.DNOB  and qty =sum(TP.qty)and [site] = TP.[site])as allocationUseby,

(select sum(Qty) from #TMP  where productcode = TP.productcode and [Type] = 'Allocation' and DNOB = TP.DNOB and useby = TP.useby and qty =sum(TP.qty)and [site] = TP.[site])as allocationQTY,
Tp.[type],
TP.[Priority]
into #TMP2
from #TMP TP
where TP.[type] = 'Innova' 
group by TP.orderno,TP.ProductCode, TP.DNOB, TP.Useby, TP.[Site],qty,Tp.[type],TP.[Priority]



--select * from #TmP



select TP.orderno,TP.ProductCode,
--(select Product_Name from dbo.HR_Order_Summary_import where Box_No =right(TP.ProductCode,3) and Group_Order_No =TP.OrderNo) as ProductName,
--(select Name from dbo.Products where Productcode =TP.ProductCode) as ProductName,
P1.description1 as productname,
cast(TP.DNOB as date) as AllocationDNOB,
cast(TP.Useby as date)  as AllocationUseby,
TP.[Site] as AllocationSite,
QTY as allocationQTY,
--(select Ordered_Qty from dbo.HR_Order_Summary_import where Group_Order_No = TP.orderno and Box_No = TP.HR_BoxNo) as OrderedQty,
(select cast(DNOB as date) from #TMP T where T.productcode = TP.productcode and [Type] = 'Innova' and useby = TP.useby and DNOB = TP.DNOB and qty =sum(TP.qty) and [site] = TP.[site])as InnovaDNOB,

(select cast(Useby as date) from #TMP T where T.productcode = TP.productcode and [Type] = 'Innova' and useby = TP.useby and DNOB = TP.DNOB  and qty =sum(TP.qty)and [site] = TP.[site])as InnovaUseby,

(select sum(Qty) from #TMP T  where T.productcode = TP.productcode and [Type] = 'Innova' and DNOB = TP.DNOB and useby = TP.useby and qty =sum(TP.qty)and [site] = TP.[site])as InnovaQTY,
Tp.[type],
TP.[Priority]
into #TMP3
from #TMP TP
left join products P1 (nolock) on TP.productcode = P1.Productcode
where TP.[type] = 'Allocation' 
and P1.storagetype =1
group by TP.orderno,TP.ProductCode, TP.DNOB, TP.Useby, TP.[Site],qty,Tp.[type],TP.[Priority],p1.description1



select orderno,TP.ProductCode,
--(select Name from dbo.Products where Productcode =TP.ProductCode) as ProductName,
P1.description1 as productname,
AllocationDNOB,AllocationUseby,AllocationSite,allocationQTY,
 InnovaDNOB,InnovaUseby,InnovaQTY,'ALLOCATED'as[type]
 ,[Priority]
from #TMP3 TP
left join products P1(nolock) on TP.productcode = P1.Productcode
where InnovaDNOB is null and InnovaUseby is null and InnovaQTY is null
and P1.storagetype =1


union
select orderno,TP.ProductCode,
--(select Name from dbo.Products where Productcode =TP.ProductCode) as ProductName,
P1.description1 as productname,
InnovaDNOB,InnovaUseby,InnovaSite,InnovaQty,
 AllocationDNOB,allocationUseby,AllocationQty,'INNOVA SCANNED'as[type]
 ,[Priority]
from #TMP2 TP
left join products P1(nolock) on TP.productcode = P1.Productcode
where AllocationDNOB is null and allocationUseby is null and AllocationQty is null
and P1.storagetype =1







END
GO
