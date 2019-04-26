SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		tommy Thomson
-- Create date: 22/05/2015
-- Description:	putting total into nav total table
-- =============================================

--exec [dbo].[NAV_Group_Shipment_Frozen_InProduction_total_insert]
CREATE PROCEDURE [dbo].[NAV_Group_Shipment_Frozen_InProduction_total_insert]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @BeginDate date,@EndDate date,@FromBatch int,@ToBatch int

set @BeginDate = (select cast(getdate()-1 as date))
set @EndDate = (select cast(getdate()-1 as date))
set @FromBatch = 0
set @ToBatch = 99999



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


--Foyle Campsie total
Insert into #Temp_NAV_Frozen_Production_Total exec [CAMSQL01].[Innova].DBO.[usrrep_Boning_Yelid_Frozen_MultiLots]  @BeginDate,@EndDate,@FromBatch,@ToBatch
Insert into #Temp_NAV_Frozen_Production_Total exec [CAMSQL01].[Innova].DBO.[usrrep_Offal_ReportByFrozenTotal] @BeginDate,@EndDate
--Foyle Omagh total

Insert into #Temp_NAV_Frozen_Production_Total exec [OMASQL01].[Innova].DBO.[usrrep_Boning_Yelid_Frozen_MultiLots]  @BeginDate,@EndDate,@FromBatch,@ToBatch

Insert into #Temp_NAV_Frozen_Production_Total exec [OMASQL01].[Innova].DBO.[usrrep_Offal_ReportByFrozenTotal] @BeginDate,@EndDate
--insert into #Temp_NAV_Frozen_Production_Total exec [OMASQL01].[Innova].DBO.[usrrep_Rework_Yeild_Report_Frzn_FIngredients]@BeginDate,@EndDate

--Foyle Hilton total

Insert into #Temp_NAV_Frozen_Production_Total exec [CKTSQL01].[Innova].DBO.[usrrep_Boning_Yelid_Frozen_MultiLots] 

--Foyle Gloucester total

Insert into #Temp_NAV_Frozen_Production_Total exec [GLOSQL01].[Innova].DBO.[usrrep_Boning_Yelid_Frozen_MultiLots]  @BeginDate,@EndDate,@FromBatch,@ToBatch
Insert into #Temp_NAV_Frozen_Production_Total exec [GLOSQL01].[Innova].DBO.[usrrep_Offal_ReportByFrozenTotal] @BeginDate,@EndDate

----Foyle Donegal total

Insert into #Temp_NAV_Frozen_Production_Total  exec [DONSQL01].[Innova].DBO.[usrrep_Boning_Yelid_Frozen_MultiLots]  @BeginDate,@EndDate,@FromBatch,@ToBatch
Insert into #Temp_NAV_Frozen_Production_Total  exec [DONSQL01].[Innova].DBO.[usrrep_Offal_ReportByFrozenTotal] @BeginDate,@EndDate
insert into #Temp_NAV_Frozen_Production_Total exec [FFGBI-SERV].[FFG_DW].DBO.[NAV_Group_shipment_UkToDonegal_Stock_4_Veldbour]

--select *  from NAV_Frozen_Production_total where date =  '2015-05-20'

insert into NAV_Frozen_Production_Total
select [Site],[Type],
Sum([Weight] * Value) as Total,
[date]
from #Temp_NAV_Frozen_Production_Total
group by [Type],[date],[site]

END
GO
