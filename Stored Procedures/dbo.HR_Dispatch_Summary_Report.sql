SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 23/11/2015
-- Description:	
-- =============================================
--exec HR_Dispatch_Summary_Report 106623
CREATE PROCEDURE [dbo].[HR_Dispatch_Summary_Report] 
@OrderNo int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @NAVOrder nvarchar(15)
set @NAVOrder = ('%' + cast(@OrderNo as nvarchar(15))  + '%')

	select 'FO' as site,count(pk.id) as QTY  ,pm.description1 collate SQL_Latin1_General_CP1_CI_AS as [Product Name] , pl.description1 collate SQL_Latin1_General_CP1_CI_AS as [Supplier ID],SH.[Shipment Date] 
	From [OMASQL01].[INNOVA].dbo.[proc_packs] pk
	left join [OMASQL01].[INNOVA].[dbo].[vw_OrderswithNoXML] po (nolock) on pk.[order]= po.[order]
	left join [OMASQL01].[INNOVA].[dbo].[vw_matswithNoXML] pm (nolock) on pk.material = pm.material
	left join [OMASQL01].[INNOVA].[dbo].[vw_LotswithNoXML] pl (nolock) on pk.lot = pl.lot
	inner join [FFGCLS01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] sh (nolock) on sh.[Order No_] collate SQL_Latin1_General_CP1_CI_AS = po.[name] collate SQL_Latin1_General_CP1_CI_AS
	where exists (select * from [FFGCLS01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] where [External Document No_] collate SQL_Latin1_General_CP1_CI_AS like @NAVOrder)
	and sh.[External Document No_] like @NAVOrder and pm.code in('501910272','501910232','501910274','501910754','501910708','501910740','501910736','501910228','501910229','501910230','501910389','501910292','501910075','501910233','501910293','501910291','501910571','901910919','901910993','901910330')
	group by pm.description1, pl.description1,SH.[Shipment Date]
	

	union
		select 'FC',count(pk.id),pm.description1 collate SQL_Latin1_General_CP1_CI_AS , pl.description1 collate SQL_Latin1_General_CP1_CI_AS ,SH.[Shipment Date]
	From [CAMSQL01].[INNOVA].dbo.[proc_packs] pk
	left join [CAMSQL01].[INNOVA].[dbo].[vw_OrderswithNoXML] po (nolock) on pk.[order]= po.[order]
	left join [CAMSQL01].[INNOVA].[dbo].[vw_matswithNoXML] pm (nolock) on pk.material = pm.material
	left join [CAMSQL01].[INNOVA].[dbo].[vw_LotswithNoXML] pl (nolock) on pk.lot = pl.lot
	inner join [FFGCLS01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] sh (nolock) on sh.[Order No_] collate SQL_Latin1_General_CP1_CI_AS = po.[name] collate SQL_Latin1_General_CP1_CI_AS
	where exists (select * from [FFGCLS01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] where [External Document No_] collate SQL_Latin1_General_CP1_CI_AS like @NAVOrder)
	and sh.[External Document No_] like @NAVOrder and pm.code in('501910272','501910232','501910274','501910754','501910708','501910740','501910736','501910228','501910229','501910230','501910389','501910292','501910075','501910233','501910293','501910291','501910571','901910919','901910993','901910330')
	group by pm.description1, pl.description1 ,SH.[Shipment Date]

	union
			select 'FG',count(pk.id),pm.description1 collate SQL_Latin1_General_CP1_CI_AS , pl.description1 collate SQL_Latin1_General_CP1_CI_AS ,SH.[Shipment Date]
	From [GLOSQL01].[INNOVA].dbo.[proc_packs] pk
	left join [GLOSQL01].[INNOVA].[dbo].[vw_OrderswithNoXML] po (nolock) on pk.[order]= po.[order]
	left join [GLOSQL01].[INNOVA].[dbo].[vw_matswithNoXML] pm (nolock) on pk.material = pm.material
	left join [GLOSQL01].[INNOVA].[dbo].[vw_LotswithNoXML] pl (nolock) on pk.lot = pl.lot
	inner join [FFGCLS01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] sh (nolock) on sh.[Order No_] collate SQL_Latin1_General_CP1_CI_AS = po.[name] collate SQL_Latin1_General_CP1_CI_AS
	where exists (select * from [FFGCLS01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] where [External Document No_] collate SQL_Latin1_General_CP1_CI_AS like @NAVOrder)
	and sh.[External Document No_] like @NAVOrder and pm.code in('501910272','501910232','501910274','501910754','501910708','501910740','501910736','501910228','501910229','501910230','501910389','501910292','501910075','501910233','501910293','501910291','501910571','901910919','901910993','901910330')
	group by pm.description1, pl.description1 ,SH.[Shipment Date]

		union
			select 'FMM',count(pk.id),pm.description1 collate SQL_Latin1_General_CP1_CI_AS , pl.description1 collate SQL_Latin1_General_CP1_CI_AS ,SH.[Shipment Date]
	From [MELSQL01].[INNOVA].dbo.[proc_packs] pk
	left join [MELSQL01].[INNOVA].[dbo].[vw_OrderswithNoXML] po (nolock) on pk.[order]= po.[order]
	left join [MELSQL01].[INNOVA].[dbo].[vw_matswithNoXML] pm (nolock) on pk.material = pm.material
	left join [MELSQL01].[INNOVA].[dbo].[vw_LotswithNoXML] pl (nolock) on pk.lot = pl.lot
	inner join [FFGCLS01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] sh (nolock) on sh.[Order No_] collate SQL_Latin1_General_CP1_CI_AS = po.[name] collate SQL_Latin1_General_CP1_CI_AS
	where exists (select * from [FFGCLS01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] where [External Document No_] collate SQL_Latin1_General_CP1_CI_AS like @NAVOrder)
	and sh.[External Document No_] like @NAVOrder and pm.code in('501910272','501910232','501910274','501910754','501910708','501910740','501910736','501910228','501910229','501910230','501910389','501910292','501910075','501910233','501910293','501910291','501910571','901910919','901910993','901910330')
	group by pm.description1, pl.description1 ,SH.[Shipment Date]

		union
			select 'FH',count(pk.id),pm.description1 collate SQL_Latin1_General_CP1_CI_AS , pl.description1 collate SQL_Latin1_General_CP1_CI_AS ,SH.[Shipment Date]
	From [CKTSQL01].[INNOVA].dbo.[proc_packs] pk
	left join [CKTSQL01].[INNOVA].[dbo].[vw_OrderswithNoXML] po (nolock) on pk.[order]= po.[order]
	left join [CKTSQL01].[INNOVA].[dbo].[vw_matswithNoXML] pm (nolock) on pk.material = pm.material
	left join [CKTSQL01].[INNOVA].[dbo].[vw_LotswithNoXML] pl (nolock) on pk.lot = pl.lot
	inner join [FFGCLS01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] sh (nolock) on sh.[Order No_] collate SQL_Latin1_General_CP1_CI_AS = po.[name] collate SQL_Latin1_General_CP1_CI_AS
	where exists (select * from [FFGCLS01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] where [External Document No_] collate SQL_Latin1_General_CP1_CI_AS like @NAVOrder)
	and sh.[External Document No_] like @NAVOrder and pm.code in('501910272','501910232','501910274','501910754','501910708','501910740','501910736','501910228','501910229','501910230','501910389','501910292','501910075','501910233','501910293','501910291','501910571','901910919','901910993','901910330')
	group by pm.description1, pl.description1 ,SH.[Shipment Date]

		union
			select 'FD',count(pk.id),pm.description1 collate SQL_Latin1_General_CP1_CI_AS , pl.description1 collate SQL_Latin1_General_CP1_CI_AS ,SH.[Shipment Date]
	From [DONSQL01].[INNOVA].dbo.[proc_packs] pk
	left join [DONSQL01].[INNOVA].[dbo].[vw_OrderswithNoXML] po (nolock) on pk.[order]= po.[order]
	left join [DONSQL01].[INNOVA].[dbo].[vw_matswithNoXML] pm (nolock) on pk.material = pm.material
	left join [DONSQL01].[INNOVA].[dbo].[vw_LotswithNoXML] pl (nolock) on pk.lot = pl.lot
	inner join [FFGCLS01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] sh (nolock) on sh.[Order No_] collate SQL_Latin1_General_CP1_CI_AS = po.[name] collate SQL_Latin1_General_CP1_CI_AS
	where exists (select * from [FFGCLS01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] where [External Document No_] collate SQL_Latin1_General_CP1_CI_AS like @NAVOrder)
	and sh.[External Document No_] like @NAVOrder and pm.code in('501910272','501910232','501910274','501910754','501910708','501910740','501910736','501910228','501910229','501910230','501910389','501910292','501910075','501910233','501910293','501910291','501910571','901910919','901910993','901910330')
	group by pm.description1, pl.description1 ,SH.[Shipment Date]

	END
GO
