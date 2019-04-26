SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <08/03/2017>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Hilton_Total_Weight_Weekly_ALL] 

--exec [Hilton_Total_Weight_Weekly_ALL] 

AS
BEGIN

--TRUNCATE TABLE [FFG_DW].[dbo].[Hilton_Dispatch_Weight_ALL]

INSERT INTO [FFG_DW].[dbo].[Hilton_Dispatch_Weight_ALL] ([Date],[Site],[TotalWeight],[ProductType], [CustomerNo])

select GetDate()-1 as [date], 2 as [Site],isnull(Sum(Quantity),0) As TotalWeight,pt.description3 collate SQL_Latin1_General_CP1_CI_AS AS [Product Type], NV.[Sell-to Customer No_]
from [FFGSQL01].[FFG-Production].dbo.[FFG LIVE$Sales Shipment Header] NVH
left join [FFGSQL01].[FFG-Production].dbo.[FFG LIVE$Sales Shipment Line] NV on NVH.[Order No_] = NV.[Order No_]
left join [omasql01].[Innova].[dbo].[vw_matswithNoXML] pm (nolock) on NV.[no_] = pm.Code collate SQL_Latin1_General_CP1_CI_AS
left join [omasql01].[Innova].[dbo].[vw_mattypesWithNoXML] PT (nolock) on pm.materialtype = pt.materialtype 
where NV.[Sell-to Customer No_] IN ( '4057','2640','2125','2751','3593','3035' )and NV.[posting Group] <> 'PACKAGING'
and convert(nvarchar(30),NVH.[Delivery Date],102)= convert(nvarchar(30),DATEADD(day, -1, GETDATE()),102)
and NV.[Shortcut Dimension 1 Code] = 'FO' 
group by pt.description3, NV.[Sell-to Customer No_]

union

select GetDate()-1 as [date], 1 as [Site], isnull(Sum(Quantity),0) As TotalWeight,  pt.description3 collate SQL_Latin1_General_CP1_CI_AS  AS [Product Type],  NV.[Sell-to Customer No_]
from [FFGSQL01].[FFG-Production].dbo.[FFG LIVE$Sales Shipment Header] NVH
left join [FFGSQL01].[FFG-Production].dbo.[FFG LIVE$Sales Shipment Line] NV on  NVH.[Order No_] = NV.[Order No_]
left join [CAMSQL01].[Innova].[dbo].[vw_matswithNoXML] pm (nolock) on NV.[no_] = pm.Code collate SQL_Latin1_General_CP1_CI_AS
left join [CAMSQL01].[Innova].[dbo].[vw_mattypesWithNoXML] PT (nolock) on pm.materialtype = pt.materialtype
where NV.[Sell-to Customer No_] IN ('4057','2640','2125','2751','3593','3035' ) and NV.[posting Group] <> 'PACKAGING'
and convert(nvarchar(30),NVH.[Delivery Date],102)= convert(nvarchar(30),DATEADD(day, -1, GETDATE()),102)
and NV.[Shortcut Dimension 1 Code] = 'FC' 
group by pt.description3 , NV.[Sell-to Customer No_]

union

select GetDate()-1 as [date], 4 as [Site], isnull(Sum(Quantity),0) As TotalWeight, pt.description3 collate SQL_Latin1_General_CP1_CI_AS  AS [Product Type],  NV.[Sell-to Customer No_]
from [FFGSQL01].[FFG-Production].dbo.[FFG LIVE$Sales Shipment Header] NVH
left join [FFGSQL01].[FFG-Production].dbo.[FFG LIVE$Sales Shipment Line] NV on  NVH.[Order No_] = NV.[Order No_]
left join [DONSQL01].[Innova].[dbo].[vw_matswithNoXML] pm (nolock)on NV.[no_] = pm.Code collate SQL_Latin1_General_CP1_CI_AS
left join [DONSQL01].[Innova].[dbo].[vw_mattypesWithNoXML] PT (nolock) on pm.materialtype = pt.materialtype
where NV.[Sell-to Customer No_] IN ( '4057','2640','2125','2751','3593','3035' ) and NV.[posting Group] <> 'PACKAGING'
and convert(nvarchar(30),NVH.[Delivery Date],102)= convert(nvarchar(30),DATEADD(day, -1, GETDATE()),102)
and NV.[Shortcut Dimension 1 Code] = 'FD' 
group by pt.description3 , NV.[Sell-to Customer No_]

union

select GetDate()-1 as [date], 3 as [Site], isnull(Sum(Quantity),0) As TotalWeight,  pt.description3 collate SQL_Latin1_General_CP1_CI_AS  AS [Product Type],  NV.[Sell-to Customer No_]
from [FFGSQL01].[FFG-Production].dbo.[FFG LIVE$Sales Shipment Header] NVH
left join [FFGSQL01].[FFG-Production].dbo.[FFG LIVE$Sales Shipment Line] NV on  NVH.[Order No_] = NV.[Order No_]
left join [CKTSQL01].[Innova].[dbo].[vw_matswithNoXML]  pm (nolock) on NV.[no_] = pm.Code collate SQL_Latin1_General_CP1_CI_AS
left join [CKTSQL01].[Innova].[dbo].[vw_mattypesWithNoXML] PT (nolock) on pm.materialtype = pt.materialtype
where NV.[Sell-to Customer No_] IN ( '4057','2640','2125','2751','3593','3035' ) and NV.[posting Group] <> 'PACKAGING'
and convert(nvarchar(30),NVH.[Delivery Date],102)= convert(nvarchar(30),DATEADD(day, -1, GETDATE()),102)
and NV.[Shortcut Dimension 1 Code] = 'FH' 
group by pt.description3 , NV.[Sell-to Customer No_]

union

select GetDate()-1 as [date], 5 as [Site], isnull(Sum(Quantity),0) As TotalWeight, pt.description3 collate SQL_Latin1_General_CP1_CI_AS  AS [Product Type],  NV.[Sell-to Customer No_]
from [FFGSQL01].[FFG-Production].dbo.[FFG LIVE$Sales Shipment Header] NVH
left join [FFGSQL01].[FFG-Production].dbo.[FFG LIVE$Sales Shipment Line] NV on  NVH.[Order No_] = NV.[Order No_]
left join [CKTSQL01].[Innova].[dbo].[vw_matswithNoXML] pm (nolock) on NV.[no_] = pm.Code collate SQL_Latin1_General_CP1_CI_AS
left join [CKTSQL01].[Innova].[dbo].[vw_mattypesWithNoXML] PT (nolock) on pm.materialtype = pt.materialtype
where NV.[Sell-to Customer No_] IN ( '4057','2640','2125','2751','3593','3035' ) and NV.[posting Group] <> 'PACKAGING'
and convert(nvarchar(30),NVH.[Delivery Date],102)= convert(nvarchar(30),DATEADD(day, -1, GETDATE()),102)
and NV.[Shortcut Dimension 1 Code] = 'FGL'
group by pt.description3 , NV.[Sell-to Customer No_]

UPDATE HD
SET hd.[Weekno] = (Select TOP 1 tc.WeekNo From [FFG_DW].[dbo].[Tesco_Reporting_Calander] tc Where hd.[date] between tc.[date] and tc.[dateto])
From [FFG_DW].[dbo].[Hilton_Dispatch_Weight_ALL] HD
Where hd.weekno is null

UPDATE HD
SET hd.[Period] = (Select TOP 1 tc.Period From [FFG_DW].[dbo].[Tesco_Reporting_Calander] tc Where hd.[date] between tc.[date] and tc.[dateto])
From [FFG_DW].[dbo].[Hilton_Dispatch_Weight_ALL] HD
Where hd.[Period] is null

END
GO
