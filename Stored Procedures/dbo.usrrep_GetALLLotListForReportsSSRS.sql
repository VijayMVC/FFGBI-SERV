SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--exec [usrrep_GetALLLotListForReports] '1'
CREATE procedure [dbo].[usrrep_GetALLLotListForReportsSSRS]
@SiteID Int,
@BeginDate datetime,
@EndDate datetime

As

if(@SiteID = '1')
begin
	select distinct Code, Name from Lots with (nolock)
	where Dimension1 = '1' and len(Code) = 12 and SiteID = '1' 
end

if(@SiteID = '2')
Begin
	select distinct Code, Name from Lots with (nolock)
	where Dimension1 = '1' and len(Code) = 12 and [SiteID] = '2'
end

if(@SiteID = '3')
Begin
	select distinct Code, Name from Lots with (nolock)
	where Dimension1 = '1' and len(Code) = 12 and [SiteID] = '3'
end


if(@SiteID = '4')
Begin
	select distinct Code, Name from Lots with (nolock)
	where Dimension1 = '1' and len(Code) = 12 and [SiteID] = '4'
end


if(@SiteID = '5')
Begin
	select distinct Code, Name from Lots with (nolock)
	where Dimension1 = '1' and len(Code) = 12 and [SiteID] = '5'
end


if(@SiteID = '6')
Begin
	select distinct Code, Name from Lots with (nolock)
	where Dimension1 = '1' and len(Code) = 12 and [SiteID] = '6'
end

GO
