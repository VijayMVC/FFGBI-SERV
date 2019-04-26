SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--exec [usrrep_GetLotListForReports] '02/02/15', '02/02/15', 0
CREATE procedure [dbo].[usrrep_GetLotListForReports]
@BeginDate datetime,
@EndDate datetime,
@LotsTypes int
As

select distinct Code, Name from Lots
where Dimension1 = '1' and len(Code) = 12
GO
