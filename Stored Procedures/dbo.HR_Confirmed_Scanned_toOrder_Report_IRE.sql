SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 09/06/2015
-- Description:	report created for confirming to retail what has been confirmed as scanned
-- =============================================

--exec dbo.HR_Confirmed_Scanned_toOrder_Report_IRE 102047
CREATE PROCEDURE [dbo].[HR_Confirmed_Scanned_toOrder_Report_IRE] 
@OrderNo bigint--,
--@site int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

CREATE TABLE #TempInnovaOrder(
OrderNo nvarchar(max),
HR_BoxNo nvarchar(5),
ProductCode nvarchar(15),
Pallet bigint,
DNOB datetime,
Useby datetime,
[Site] int,
[Type] nvarchar(max),
Qty int

)

--insert into #TempInnovaOrder
--select OA.OrderNo,OA.HR_BoxNo,OA.ProductCode,OA.PalletNo,
--OA.DNOB,OA.UseBy,OA.siteid, 'Allocation', Count(OA.productcode) as Qty
--from dbo.HR_Order_Allocation OA
--where OrderNo = @OrderNo 
--and isnull(InProductionStock,0) <> 1
--Group by OrderNo,HR_BoxNo,OA.ProductCode,PalletNo,DNOB,UseBy,siteid

CREATE TABLE #TempOrder(
OrderNo nvarchar(max)
)

declare @NAVOrder nvarchar(15)
set @NAVOrder = ('%' + cast(@OrderNo as nvarchar(15))  + '%')

--insert into #TempOrder select ''''+[No_]+'''' from [DMP_NAVSERV].[DMP-Production].dbo.[DMP - LIVE$Sales Header] where [External Document No_] like @NAVOrder 

insert into #TempOrder select ''''+[No_]+'''' from [FFGSQL01].[FFG-Production].dbo.[FFG LIVE$Sales Header] where [External Document No_] like @NAVOrder and [Shortcut Dimension 1 Code] = 'FD'

--insert into #TempOrder select ''''+[Order No_]+'''' from [FM_NAVSERV].[FM-Production].dbo.[FM - LIVE$Sales Shipment Header] where [External Document No_] like @NAVOrder
--insert into #TempOrder select ''''+[Order No_]+'''' from [NAVSERV_OMA].[OMA-Production].dbo.[OMA - LIVE$Sales Shipment Header] where [External Document No_] like @NAVOrder
--insert into #TempOrder select ''''+[Order No_]+'''' from [HMC_NAVSERV].[HMC-Production].dbo.[HMC - LIVE$Sales Shipment Header]where [External Document No_] like @NAVOrder
--insert into #TempOrder select ''''+[Order No_]+'''' from [FG-NAVSERV].[FG Production].dbo.[gloucester - LIVE$Sales Shipment Header]where [External Document No_] like @NAVOrder

DECLARE @combinedString nvarchar(MAX)

SELECT @combinedString = COALESCE(@combinedString + ',', '') + Orderno 
 from #TempOrder 
 
 --select @combinedString
 
DECLARE --@SQLFC NVARCHAR(Max), @SQLFO NVARCHAR(Max),@SQLFH NVARCHAR(Max),@SQLFG NVARCHAR(Max),
@SQLFD NVARCHAR(Max)

--Campsie

--set @SQLFC = 
--'select PO.name,NULL,PM.Code,PC.Number,PK.expire3 as DNOB,PK.expire1 as useby,''1'' as siteid, ''Innova'',
--Count(PM.Code) as Qty
--from [CAMSQL01].[INNOVA].dbo.[proc_packs]  PK (nolock)
--inner join [CAMSQL01].[INNOVA].dbo.[vw_OrderswithNoXML] PO (nolock)  on pk.[order] = PO.[order]
--left join [CAMSQL01].[INNOVA].dbo.[vw_matswithNoXML] PM  (nolock) on PK.material = PM.Material
--left join [CAMSQL01].[INNOVA].dbo.[proc_collections] PC (nolock)  on PK.Pallet = PC.ID
--where PO.name in ('+@combinedString+') group by PO.name,PM.Code,PC.Number,PK.expire3,PK.expire1'

--Omagh
--set @SQLFO = 
--'select PO.name,NULL,PM.Code,PC.Number,PK.expire3 as DNOB,PK.expire1 as useby,''2'' as siteid, ''Innova'',
--Count(PM.Code) as Qty
--from [OMASQL01].[INNOVA].dbo.[proc_packs]  PK (nolock)
--inner join [OMASQL01].[INNOVA].dbo.[vw_OrderswithNoXML] PO (nolock)  on pk.[order] = PO.[order]
--left join [OMASQL01].[INNOVA].dbo.[vw_matswithNoXML] PM  (nolock) on PK.material = PM.Material
--left join [OMASQL01].[INNOVA].dbo.[proc_collections] PC (nolock)  on PK.Pallet = PC.ID
--where PO.name in ('+@combinedString+')group by PO.name,PM.Code,PC.Number,PK.expire3,PK.expire1'

--Cookstown
--set @SQLFH  = 
--'select PO.name,NULL,PM.Code,PC.Number,PK.expire3 as DNOB,PK.expire1 as useby,''3'' as siteid, ''Innova'',
--Count(PM.Code) as Qty
--from [CKTSQL01].[INNOVA].dbo.[proc_packs]  PK (nolock)
--inner join [CKTSQL01].[INNOVA].dbo.[vw_OrderswithNoXML] PO (nolock)  on pk.[order] = PO.[order]
--left join [CKTSQL01].[INNOVA].dbo.[vw_matswithNoXML] PM  (nolock) on PK.material = PM.Material
--left join [CKTSQL01].[INNOVA].dbo.[proc_collections] PC (nolock)  on PK.Pallet = PC.ID
--where PO.name in ('+@combinedString+')group by PO.name,PM.Code,PC.Number,PK.expire3,PK.expire1'

--Gloucester
--set @SQLFG = 
--'select PO.name, NULL,PM.Code,PC.Number,PK.expire3 as DNOB,PK.expire1 as useby,''5'' as siteid, ''Innova'',
--Count(PM.Code) as Qty
--from [GLOSQL01].[INNOVA].dbo.[proc_packs]  PK (nolock)
--inner join [GLOSQL01].[INNOVA].dbo.[vw_OrderswithNoXML] PO (nolock)  on pk.[order] = PO.[order]
--left join [GLOSQL01].[INNOVA].dbo.[vw_matswithNoXML] PM  (nolock) on PK.material = PM.Material
--left join [GLOSQL01].[INNOVA].dbo.[proc_collections] PC (nolock)  on PK.Pallet = PC.ID
--where PO.name in ('+@combinedString+')group by PO.name,PM.Code,PC.Number,PK.expire3,PK.expire1'

--Donegal

set @SQLFD = 
'select PO.name,NULL,PM.Code,PC.Number,PK.expire3 as DNOB,PK.expire1 as useby,''4'' as siteid, ''Innova'',
Count(PM.Code) as Qty
from [DONSQL01].[INNOVA].dbo.[proc_packs]  PK (nolock)
inner join [DONSQL01].[INNOVA].dbo.[vw_OrderswithNoXML] PO (nolock)  on pk.[order] = PO.[order]
left join [DONSQL01].[INNOVA].dbo.[vw_matswithNoXML] PM  (nolock) on PK.material = PM.Material
left join [DONSQL01].[INNOVA].dbo.[proc_collections] PC (nolock)  on PK.Pallet = PC.ID
where PO.name in ('+@combinedString+') group by PO.name,PM.Code,PC.Number,PK.expire3,PK.expire1'



Begin 

--insert into #TempInnovaOrder exec sp_executesql @SQLFC   
--insert into #TempInnovaOrder exec sp_executesql @SQLFO
--insert into #TempInnovaOrder exec sp_executesql @SQLFH 
--insert into #TempInnovaOrder exec sp_executesql @SQLFG
insert into #TempInnovaOrder exec sp_executesql @SQLFD  
end



--select ProductCode, 
--sum(Qty) as Qty
--from #TempInnovaOrder
--group by  ProductCode

select isnull(OS.Box_no,'')as BoxNo, isnull(OS.Product_Name,'')as ProductName,
isnull(OS.Ordered_Qty,'')OrderedQTY,
--isnull(isnull(cast(( select Sum(case when OA.siteid in(1,2,3,4,5,6) then 1 else 0 end) as confirmedQTY 
--from dbo.HR_Order_Allocation OA 
--where --OA.HR_BoxNO =OS.Box_no 
--right(OA.productcode,3) = OS.Box_no 
--and OA.OrderNo = OS.Group_Order_NO)as nvarchar(max)),OS.Confirmed_Qty),'') as confirmedQTY
isnull(isnull(cast((select sum(Qty) as Qty from #TempInnovaOrder where OS.Box_no = right(#TempInnovaOrder.productcode,3))as nvarchar(max)),OS.Confirmed_Qty),'') as confirmedQTY
From dbo.HR_Order_Summary_import OS
where Group_Order_No = @OrderNo
order by OS.rowno 


END
GO
