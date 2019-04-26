SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 16/07/2015
-- Description:	this collects all the stock sent to donegal for veldbour
-- =============================================
--exec NAV_Group_shipment_UkToDonegal_Stock_4_Veldbour 

CREATE PROCEDURE [dbo].[NAV_Group_shipment_UkToDonegal_Stock_4_Veldbour] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--Omagh NAV	
--select 'FD' as [Site], 
--pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type],
--SL.[Shipment Date],
--'Hilton Zandaam - From UK Sites',
--SL.[No_],
--SL.[Description],
--(select sum([Quantity]) as KG from [NAVSERV_OMA].[OMA-Production].dbo.[OMA - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])as KG,
--pm.value
--from [NAVSERV_OMA].[OMA-Production].dbo.[OMA - LIVE$Sales Shipment Line] SL (nolock)
--left join [NAVSERV_OMA].[OMA-Production].[dbo].[OMA - LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_]
--inner join [NAVSERV_OMA].[OMA-Production].[dbo].[OMA - LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_]
--left join [OMASQL01].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
--where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
--and PM.Fabcode3 ='FROZEN'
--and  SL.[Sell-to Customer No_] = '2070'
--and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
--and (select sum([Quantity]) as KG from [NAVSERV_OMA].[OMA-Production].dbo.[OMA - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
select 'FO' as [Site], 
pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type],
SL.[Shipment Date],
'Hilton Zandaam - From UK Sites',
SL.[No_],
SL.[Description],
(select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FO')as KG,
pm.value
from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] SL (nolock)
left join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_] and SL.[Shortcut Dimension 1 Code] = 'FO'
inner join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_] and SL.[Shortcut Dimension 1 Code] = 'FO'
left join [OMASQL01].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS 
where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
and PM.Fabcode3 ='FROZEN'
and  SL.[Sell-to Customer No_] = '2070'
and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
and (select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
and SL.[Shortcut Dimension 1 Code] = 'FO'
group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1,SL.[Shipment Date],SL.[Shortcut Dimension 1 Code]


union
--Campsie NAV	
--select 'FD' as [Site], 
--pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type],
--SL.[Shipment Date],
--'Hilton Zandaam - From UK Sites',
--SL.[No_],
--SL.[Description],
--(select sum([Quantity]) as KG from [FM_NAVSERV].[FM-Production].dbo.[FM - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])as KG,
--pm.value
--from [FM_NAVSERV].[FM-Production].dbo.[FM - LIVE$Sales Shipment Line] SL (nolock)
--left join [FM_NAVSERV].[FM-Production].[dbo].[FM - LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_]
--inner join [FM_NAVSERV].[FM-Production].[dbo].[FM - LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_]
--left join [CAMSQL01].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
--where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
--and PM.Fabcode3 ='FROZEN'
--and SL.[Sell-to Customer No_] = '2070'
--and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
--and (select sum([Quantity]) as KG from [FM_NAVSERV].[FM-Production].dbo.[FM - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
--group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1,SL.[Shipment Date]
select 'FC' as [Site], 
pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type],
SL.[Shipment Date],
'Hilton Zandaam - From UK Sites',
SL.[No_],
SL.[Description],
(select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FC')as KG,
pm.value
from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] SL (nolock)
left join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_] and SL.[Shortcut Dimension 1 Code] = 'FC'
inner join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_] and SL.[Shortcut Dimension 1 Code] = 'FC'
left join [CAMSQL01].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
and PM.Fabcode3 ='FROZEN'
and SL.[Sell-to Customer No_] = '2070'
and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
and (select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
and SL.[Shortcut Dimension 1 Code] = 'FC'
group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1,SL.[Shipment Date],SL.[Shortcut Dimension 1 Code]

union 
--Cookstown NAV	
--select 'FD' as [Site], 
--pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type],
--SL.[Shipment Date],
--'Hilton Zandaam - From UK Sites',
--SL.[No_],
--SL.[Description],
--(select sum([Quantity]) as KG from [HMC_NAVSERV].[HMC-Production].dbo.[HMC - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])as KG,
--pm.value
--from [HMC_NAVSERV].[HMC-Production].dbo.[HMC - LIVE$Sales Shipment Line] SL (nolock)
--left join [HMC_NAVSERV].[HMC-Production].[dbo].[HMC - LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_]
--inner join [HMC_NAVSERV].[HMC-Production].[dbo].[HMC - LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_]
--left join [CKTSQL01].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
--where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
--and PM.Fabcode3 ='FROZEN'
--and  SL.[Sell-to Customer No_] = '2070'
--and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
--and (select sum([Quantity]) as KG from [HMC_NAVSERV].[HMC-Production].dbo.[HMC - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
--group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1,SL.[Shipment Date]
select 'FH' as [Site], 
pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type],
SL.[Shipment Date],
'Hilton Zandaam - From UK Sites',
SL.[No_],
SL.[Description],
(select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FH')as KG,
pm.value
from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] SL (nolock)
left join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_] and SL.[Shortcut Dimension 1 Code] = 'FH'
inner join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_] and SL.[Shortcut Dimension 1 Code] = 'FH'
left join [CKTSQL01].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
and PM.Fabcode3 ='FROZEN'
and  SL.[Sell-to Customer No_] = '2070'
and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
and (select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
and SL.[Shortcut Dimension 1 Code] = 'FH'
group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1,SL.[Shipment Date],SL.[Shortcut Dimension 1 Code]


union
--Gloucester NAV	
--select 'FD' as [Site], 
--pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type],
--SL.[Shipment Date],
--'Hilton Zandaam - From UK Sites',
--SL.[No_],
--SL.[Description],
--(select sum([Quantity]) as KG from [FG-NAVSERV].[FG Production].dbo.[Gloucester - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])as KG,
--pm.value
--from [FG-NAVSERV].[FG Production].dbo.[Gloucester - LIVE$Sales Shipment Line] SL (nolock)
--left join [FG-NAVSERV].[FG Production].[dbo].[Gloucester - LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_]
--inner join [FG-NAVSERV].[FG Production].[dbo].[Gloucester - LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_]
--left join [GLOSQL01].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
--where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
--and PM.Fabcode3 ='FROZEN'
--and  SL.[Sell-to Customer No_] = '2070'
--and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
--and (select sum([Quantity]) as KG from [FG-NAVSERV].[FG Production].dbo.[Gloucester - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
--group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1,SL.[Shipment Date]
select 'FG' as [Site], 
pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type],
SL.[Shipment Date],
'Hilton Zandaam - From UK Sites',
SL.[No_],
SL.[Description],
(select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FG')as KG,
pm.value
from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] SL (nolock)
left join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_] and SL.[Shortcut Dimension 1 Code] = 'FG'
inner join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_] and SL.[Shortcut Dimension 1 Code] = 'FG'
left join [GLOSQL01].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
and PM.Fabcode3 ='FROZEN'
and  SL.[Sell-to Customer No_] = '2070'
and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
and (select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
and SL.[Shortcut Dimension 1 Code] = 'FG'
group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1,SL.[Shipment Date],SL.[Shortcut Dimension 1 Code]



END
GO
