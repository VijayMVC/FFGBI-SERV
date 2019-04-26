SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 22/05/2015
-- Description:	Show total shipment summary
-- =============================================
--exec [NAV_Group_Shipment_Frozen_Total]
CREATE PROCEDURE [dbo].[NAV_Group_Shipment_Frozen_Total]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	create table #TempShipmentFrozen
	(
	[Site] nvarchar(50),
	[No_] nvarchar(20),
	[Description]nvarchar(MAx),
	[Custoemr] int ,
	[Name] nvarchar(MAx) ,
	KG float,
	salesvalue float, 
	stockvalue float, 
	[type] nvarchar(MAX) 
	)
	
	
	insert into #TempShipmentFrozen exec [dbo].[NAV_Group_Shipment_Frozen_Report_total] 
	
	
insert into dbo.NAV_Frozen_Production_total	
select case when [site] = 'Foyle Campsie' then 'FC'
when [site] = 'Foyle Omagh' then 'FO'
when [site] = 'Foyle Hilton' then 'FH'
when [site] = 'Foyle Donegal' then 'FD'
when [site] = 'Foyle Gloucester' then 'FG'
when [site] = 'Foyle Melton' then 'FMM' else null end as [Site],
'offal shipment' as [type],
Sum(StockValue) as Total,
cast(getdate()-1 as date)as [date]
from #TempShipmentFrozen 
where [Type] like 'offal'
group by [site] 


insert into dbo.NAV_Frozen_Production_total	
select case when [site] = 'Foyle Campsie' then 'FC'
when [site] = 'Foyle Omagh' then 'FO'
when [site] = 'Foyle Hilton' then 'FH'
when [site] = 'Foyle Donegal' then 'FD'
when [site] = 'Foyle Gloucester' then 'FG'
when [site] = 'Foyle Melton' then 'FMM' else null end as [Site],
'Beef shipment' as [type],
Sum(StockValue) as Total,
cast(getdate()-1 as date)  as [date]
from #TempShipmentFrozen 
where not([Type] like 'offal')
group by [site] 


declare @BeginDate date,@EndDate date

set @BeginDate = (select cast(getdate()-1 as date))
set @EndDate = (select cast(getdate()-1 as date))

create table #Temp_NAV_Frozen_Production_Total
(
[Site]nvarchar(50),
[Type]nvarchar(50),
[date]date,
Customer nvarchar(100),
ProductCode nvarchar(15),
Name nvarchar(100),
[Weight] float,
Value float
)

--Foyle Omagh Ingredients
insert into #Temp_NAV_Frozen_Production_Total exec [OMASQL01].[Innova].DBO.[usrrep_Rework_Yeild_Report_Frzn_FIngredients]@BeginDate,@EndDate


insert into dbo.NAV_Frozen_Production_total	
select 'FO',
'Foyle Ingredients Shipment' AS type,
sum([Weight]*Value) as total,
cast(getdate()-1 as date)  as [date]
from #Temp_NAV_Frozen_Production_Total 




--select 'Foyle Omagh' collate SQL_Latin1_General_CP1_CI_AS as [Site],
--ProductCode collate SQL_Latin1_General_CP1_CI_AS as [No_] , 
--Name collate SQL_Latin1_General_CP1_CI_AS  as [Description],
--0 as [Sell-to Customer No_],
--Customer collate SQL_Latin1_General_CP1_CI_AS as Name ,
--count(*) as KG ,
--NULL as SalesValue  , 
--sum(([Weight]*Value)) as StockValue,
--[Type]collate SQL_Latin1_General_CP1_CI_AS as [Type]
--from #Temp_NAV_Frozen_Production_Total 
--group by ProductCode collate SQL_Latin1_General_CP1_CI_AS,Name,Customer collate SQL_Latin1_General_CP1_CI_AS,[Type] collate SQL_Latin1_General_CP1_CI_AS
drop table #Temp_NAV_Frozen_Production_Total

END
GO
