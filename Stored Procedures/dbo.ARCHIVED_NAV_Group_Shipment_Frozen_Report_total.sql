SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec NAV_Group_Shipment_Frozen_Report 
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 28/04/2015
-- Description:	Group shipment report for previous day by frozen
-- =============================================
--exec [dbo].[NAV_Group_Shipment_Frozen_Report_total]
CREATE PROCEDURE [dbo].[ARCHIVED_NAV_Group_Shipment_Frozen_Report_total] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

--Omagh NAV	
--select 'Foyle Omagh' as [Site], SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],
--(select sum([Quantity]) as KG from [NAVSERV_OMA].[OMA-Production].dbo.[OMA - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])as KG,
--case when SH.[Currency Code] ='' then ((select sum([Quantity]) as KG from [NAVSERV_OMA].[OMA-Production].dbo.[OMA - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])
--*SL.[Unit Price])
--when SH.[Currency Code] ='EUR' then ((select sum([Quantity]) as KG from [NAVSERV_OMA].[OMA-Production].dbo.[OMA - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]))
--*(SL.[Unit Price] / [Currency Factor])
--else 0 end as SalesValue,
--((select sum([Quantity]) as KG from [NAVSERV_OMA].[OMA-Production].dbo.[OMA - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])
--*PM.Value) as StockValue,pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type]
--from [NAVSERV_OMA].[OMA-Production].dbo.[OMA - LIVE$Sales Shipment Line] SL (nolock)
--left join [NAVSERV_OMA].[OMA-Production].[dbo].[OMA - LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_]
--inner join [NAVSERV_OMA].[OMA-Production].[dbo].[OMA - LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_]
--left join [FFG-SQL01].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
--where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
--and PM.Fabcode3 ='FROZEN'
--and (SL.[Gen_ Bus_ Posting Group] <> 'INTERCOMP' or SL.[Sell-to Customer No_] = '3439' or SL.[Sell-to Customer No_] = '2070')
--and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
--and (select sum([Quantity]) as KG from [NAVSERV_OMA].[OMA-Production].dbo.[OMA - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
--group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1
select 'Foyle Omagh' as [Site], SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],
(select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FO')as KG ,
case when SH.[Currency Code] ='' then ((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FO')
*SL.[Unit Price])
when SH.[Currency Code] ='EUR' then ((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FO'))
*(SL.[Unit Price] / [Currency Factor])
else 0 end as SalesValue,
((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FO')
*PM.Value) as StockValue,pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type]
from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] SL (nolock)
left join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_] and SL.[Shortcut Dimension 1 Code] = 'FO'
inner join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_] and SL.[Shortcut Dimension 1 Code] = 'FO'
left join [FFG-SQL01].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
and PM.Fabcode3 ='FROZEN'
and (SL.[Gen_ Bus_ Posting Group] <> 'INTERCOMP' or SL.[Sell-to Customer No_] = '4057' or SL.[Sell-to Customer No_] = '2070')
and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
and (select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
and SL.[Shortcut Dimension 1 Code] = 'FO'
group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1,SL.[Shortcut Dimension 1 Code] 

union
--Campsie NAV	
--select  'Foyle Campsie' as [Site],  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],
--(select sum([Quantity]) as KG from [FM_NAVSERV].[FM-Production].dbo.[FM - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])as KG,
--case when SH.[Currency Code] ='' then ((select sum([Quantity]) as KG from [FM_NAVSERV].[FM-Production].dbo.[FM - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])
--*SL.[Unit Price])
--when SH.[Currency Code] ='EUR' then ((select sum([Quantity]) as KG from [FM_NAVSERV].[FM-Production].dbo.[FM - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]))
--*(SL.[Unit Price] / [Currency Factor])
--else 0 end as SalesValue,
--((select sum([Quantity]) as KG from [FM_NAVSERV].[FM-Production].dbo.[FM - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])
--*PM.Value) as StockValue,pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type]
--from [FM_NAVSERV].[FM-Production].dbo.[FM - LIVE$Sales Shipment Line] SL (nolock)
--left join [FM_NAVSERV].[FM-Production].[dbo].[FM - LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_]
--inner join [FM_NAVSERV].[FM-Production].[dbo].[FM - LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_]
--left join [FM-SQL01].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
--where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
--and PM.Fabcode3 ='FROZEN'
--and (SL.[Gen_ Bus_ Posting Group] <> 'INTERCOMP' or SL.[Sell-to Customer No_] = '3439' or SL.[Sell-to Customer No_] = '2070')
--and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
--and (select sum([Quantity]) as KG from [FM_NAVSERV].[FM-Production].dbo.[FM - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
--group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1
select  'Foyle Campsie' as [Site],  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],
(select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FC')as KG,
case when SH.[Currency Code] ='' then ((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FC')
*SL.[Unit Price])
when SH.[Currency Code] ='EUR' then ((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FC'))
*(SL.[Unit Price] / [Currency Factor])
else 0 end as SalesValue,
((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FC')
*PM.Value) as StockValue,pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type]
from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] SL (nolock)
left join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_] and SL.[Shortcut Dimension 1 Code] = 'FC'
inner join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_] and SL.[Shortcut Dimension 1 Code] = 'FC'
left join [FFG-SQL01].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
and PM.Fabcode3 ='FROZEN'
and (SL.[Gen_ Bus_ Posting Group] <> 'INTERCOMP' or SL.[Sell-to Customer No_] = '4057' or SL.[Sell-to Customer No_] = '2070')
and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
and (select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
and SL.[Shortcut Dimension 1 Code] = 'FC'
group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1,SL.[Shortcut Dimension 1 Code] 

union 
--Cookstown NAV	
--select  'Foyle Hilton' as [Site],  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],
--(select sum([Quantity]) as KG from [HMC_NAVSERV].[HMC-Production].dbo.[HMC - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])as KG,
--case when SH.[Currency Code] ='' then ((select sum([Quantity]) as KG from [HMC_NAVSERV].[HMC-Production].dbo.[HMC - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])
--*SL.[Unit Price])
--when SH.[Currency Code] ='EUR' then ((select sum([Quantity]) as KG from [HMC_NAVSERV].[HMC-Production].dbo.[HMC - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]))
--*(SL.[Unit Price] / [Currency Factor])
--else 0 end as SalesValue,
--((select sum([Quantity]) as KG from [HMC_NAVSERV].[HMC-Production].dbo.[HMC - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])
--*PM.Value) as StockValue,pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type]
--from [HMC_NAVSERV].[HMC-Production].dbo.[HMC - LIVE$Sales Shipment Line] SL (nolock)
--left join [HMC_NAVSERV].[HMC-Production].[dbo].[HMC - LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_]
--inner join [HMC_NAVSERV].[HMC-Production].[dbo].[HMC - LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_]
--left join [HMCSQL1].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
--where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
--and PM.Fabcode3 ='FROZEN'
--and (SL.[Gen_ Bus_ Posting Group] <> 'INTERCOMP' or SL.[Sell-to Customer No_] = '3439' or SL.[Sell-to Customer No_] = '2070')
--and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
--and (select sum([Quantity]) as KG from [HMC_NAVSERV].[HMC-Production].dbo.[HMC - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
--group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1
select  'Foyle Hilton' as [Site],  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],
(select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FH')as KG,
case when SH.[Currency Code] ='' then ((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FH')
*SL.[Unit Price])
when SH.[Currency Code] ='EUR' then ((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FH'))
*(SL.[Unit Price] / [Currency Factor])
else 0 end as SalesValue,
((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FH')
*PM.Value) as StockValue,pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type]
from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] SL (nolock)
left join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_] and SL.[Shortcut Dimension 1 Code] = 'FH'
inner join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_] and SL.[Shortcut Dimension 1 Code] = 'FH'
left join [FFG-SQL01].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
and PM.Fabcode3 ='FROZEN'
and (SL.[Gen_ Bus_ Posting Group] <> 'INTERCOMP' or SL.[Sell-to Customer No_] = '4057' or SL.[Sell-to Customer No_] = '2070')
and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
and (select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
and SL.[Shortcut Dimension 1 Code] = 'FH'
group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1,SL.[Shortcut Dimension 1 Code] 

union
--Gloucester NAV	
--select  'Foyle Gloucester' as [Site],  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],
--(select sum([Quantity]) as KG from [FG-NAVSERV].[FG Production].dbo.[Gloucester - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])as KG,
--case when SH.[Currency Code] ='' then ((select sum([Quantity]) as KG from [FG-NAVSERV].[FG Production].dbo.[Gloucester - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])
--*SL.[Unit Price])
--when SH.[Currency Code] ='EUR' then ((select sum([Quantity]) as KG from [FG-NAVSERV].[FG Production].dbo.[Gloucester - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]))
--*(SL.[Unit Price] / [Currency Factor])
--else 0 end as SalesValue,
--((select sum([Quantity]) as KG from [FG-NAVSERV].[FG Production].dbo.[Gloucester - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])
--*PM.Value) as StockValue,pm.fabcode1
--from [FG-NAVSERV].[FG Production].dbo.[Gloucester - LIVE$Sales Shipment Line] SL (nolock)
--left join [FG-NAVSERV].[FG Production].[dbo].[Gloucester - LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_]
--inner join [FG-NAVSERV].[FG Production].[dbo].[Gloucester - LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_]
--left join [FG-SQL02].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
--where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
--and PM.Fabcode3 ='FROZEN'
--and (SL.[Gen_ Bus_ Posting Group] <> 'INTERCOMP'  or SL.[Sell-to Customer No_] = '3439' or SL.[Sell-to Customer No_] = '2070')
--and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
--and (select sum([Quantity]) as KG from [FG-NAVSERV].[FG Production].dbo.[Gloucester - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
--group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1
select  'Foyle Gloucester' as [Site],  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],
(select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FGL')as KG,
case when SH.[Currency Code] ='' then ((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FGL')
*SL.[Unit Price])
when SH.[Currency Code] ='EUR' then ((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FGL'))
*(SL.[Unit Price] / [Currency Factor])
else 0 end as SalesValue,
((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FGL')
*PM.Value) as StockValue,pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type]
from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] SL (nolock)
left join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_] and SL.[Shortcut Dimension 1 Code] = 'FGL'
inner join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_] and SL.[Shortcut Dimension 1 Code] = 'FGL'
left join [FFG-SQL01].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
and PM.Fabcode3 ='FROZEN'
and (SL.[Gen_ Bus_ Posting Group] <> 'INTERCOMP' or SL.[Sell-to Customer No_] = '4057' or SL.[Sell-to Customer No_] = '2070')
and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
and (select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
and SL.[Shortcut Dimension 1 Code] = 'FGL'
group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1,SL.[Shortcut Dimension 1 Code] 

union

--Melton NAV	
select 'Foyle Melton' as [Site], SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],
(select sum([Quantity]) as KG from [FMM-NAVSERV].[FMM Production].dbo.[Melton - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])as KG ,
case when SH.[Currency Code] ='' then ((select sum([Quantity]) as KG from [FMM-NAVSERV].[FMM Production].dbo.[Melton - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])
*SL.[Unit Price])
when SH.[Currency Code] ='EUR' then ((select sum([Quantity]) as KG from [FMM-NAVSERV].[FMM Production].dbo.[Melton - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]))
*(SL.[Unit Price] / [Currency Factor])
else 0 end as SalesValue,
((select sum([Quantity]) as KG from [FMM-NAVSERV].[FMM Production].dbo.[Melton - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])
*PM.Value) as StockValue,pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type]
from [FMM-NAVSERV].[FMM Production].dbo.[Melton - LIVE$Sales Shipment Line] SL (nolock)
left join [FMM-NAVSERV].[FMM Production].[dbo].[Melton - LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_]
inner join [FMM-NAVSERV].[FMM Production].[dbo].[Melton - LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_]
left join [FMM-SQL01].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
and PM.Fabcode3 ='FROZEN'
and SL.[Gen_ Bus_ Posting Group] <> 'INTERCOMP' 
and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
and (select sum([Quantity]) as KG from [FMM-NAVSERV].[FMM Production].dbo.[Melton - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,[Currency Factor],pm.fabcode1


union

--Donegal NAV	
--select 'Foyle Donegal' as [Site], SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],
--(select sum([Quantity]) as KG from [DMP_NAVSERV].[DMP-Production].dbo.[DMP - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])as KG ,
--case when SH.[Currency Code] ='' then ((select sum([Quantity]) as KG from [DMP_NAVSERV].[DMP-Production].dbo.[DMP - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]))
--*(SL.[Unit Price] / (select top 1 [Relational Exch_ Rate Amount] from  [DMP_NAVSERV].[DMP-Production].dbo.[DMP - Live$Currency Exchange Rate] order by [starting date] desc))
--when SH.[Currency Code] ='GBP' then (((select sum([Quantity]) as KG from [DMP_NAVSERV].[DMP-Production].dbo.[DMP - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]))
--*(SL.[Unit Price]))
--else 0 end as SalesValue,
--((select sum([Quantity]) as KG from [DMP_NAVSERV].[DMP-Production].dbo.[DMP - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_])
--*(PM.Value / (select top 1 [Relational Exch_ Rate Amount] from  [DMP_NAVSERV].[DMP-Production].dbo.[DMP - Live$Currency Exchange Rate] order by [starting date] desc))) as StockValue,pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type]
--from [DMP_NAVSERV].[DMP-Production].dbo.[DMP - LIVE$Sales Shipment Line] SL (nolock)
--left join [DMP_NAVSERV].[DMP-Production].[dbo].[DMP - LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_]
--inner join [DMP_NAVSERV].[DMP-Production].[dbo].[DMP - LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_]
--left join [DMP-SQL02].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
--where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
--and PM.Fabcode3 ='FROZEN'
----and SH.[Currency Code] = 'EUR' 
----order by SL.[Shipment Date]  desc
--and (SL.[Gen_ Bus_ Posting Group] <> 'INTERCOMP'  or SL.[Sell-to Customer No_] = '3439')
--and SL.[Sell-to Customer No_] <> '2125'
--and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
--and (select sum([Quantity]) as KG from [DMP_NAVSERV].[DMP-Production].dbo.[DMP - LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
--group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,pm.fabcode1


--Donegal NAV	
select 'Foyle Donegal' as [Site], SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],
(select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FD')as KG ,
case when SH.[Currency Code] ='' then ((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FD'))
*(SL.[Unit Price] / (select top 1 [Relational Exch_ Rate Amount] from  [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Currency Exchange Rate] order by [starting date] desc))
when SH.[Currency Code] ='GBP' then (((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FD'))
*(SL.[Unit Price]))
else 0 end as SalesValue,
((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FD')
*(PM.Value / (select top 1 [Relational Exch_ Rate Amount] from  [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Currency Exchange Rate] order by [starting date] desc))) as StockValue,pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type]
from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] SL (nolock)
left join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] SH (nolock) on SL.[Document No_] = SH.[No_] and SL.[Shortcut Dimension 1 Code] = 'FD'
inner join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_] and SL.[Shortcut Dimension 1 Code] = 'FD'
left join [DMP-SQL02].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
where len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
and PM.Fabcode3 ='FROZEN'
--and SH.[Currency Code] = 'EUR' 
--order by SL.[Shipment Date]  desc
and (SL.[Gen_ Bus_ Posting Group] <> 'INTERCOMP'  or SL.[Sell-to Customer No_] = '4057' or SL.[Sell-to Customer No_] = '2125' )
--and SL.[Sell-to Customer No_] <>  '2125'
and SL.[Shipment Date] =  CAST(GETDATE()-1 AS DATE)
and (select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
and SL.[Shortcut Dimension 1 Code] = 'FD'
group by  SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],SL.[Document No_],SH.[Currency Code],SL.[Unit Price],PM.Value,pm.fabcode1,SL.[Shortcut Dimension 1 Code]


union


select 'Foyle Donegal' as [Site], SL.[No_],SL.[Description],SL.[Sell-to Customer No_],C.[Name],
(select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Invoice Line]  where [No_] = SL.[No_] and [Document No_] = SH.[No_] and SL.[Shortcut Dimension 1 Code] = 'FD')as KG ,
case when SH.[Currency Code] ='' then ((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Invoice Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FD'))
*(SL.[Unit Price] / (select top 1 [Relational Exch_ Rate Amount] from  [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Currency Exchange Rate] order by [starting date] desc))
when SH.[Currency Code] ='GBP' then (((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Invoice Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FD'))
*(SL.[Unit Price]))
else 0 end as SalesValue,
((select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Invoice Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_] and SL.[Shortcut Dimension 1 Code] = 'FD')
*(PM.Value / (select top 1 [Relational Exch_ Rate Amount] from  [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Currency Exchange Rate] order by [starting date] desc))) as StockValue,pm.fabcode1 collate SQL_Latin1_General_CP1_CI_AS as [type]
from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Invoice Line] SL 
left join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Invoice Header]  SH (nolock) on SL.[Document No_] = SH.[No_] and SL.[Shortcut Dimension 1 Code] = 'FD'
left join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Customer] C (nolock) on SL.[Sell-to Customer No_] = C.[No_] and SL.[Shortcut Dimension 1 Code] = 'FD'
left join [DMP-SQL02].[INNOVA].DBO.[vw_matswithNoXML] PM (nolock) on SL.[No_] = PM.Code collate SQL_Latin1_General_CP1_CI_AS
where  SH.[Document Date] =  CAST(GETDATE()-1 AS DATE)
and len(SL.[No_]) = 9 and isnumeric(SL.[No_]) =1
and SH.[Sell-to Customer No_] = '2125'
and PM.Fabcode3 ='FROZEN'
and (select sum([Quantity]) as KG from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Invoice Line] where [No_] = SL.[No_] and [Document No_] = SL.[Document No_]) >0
and SL.[Shortcut Dimension 1 Code] = 'FD'




END
GO
