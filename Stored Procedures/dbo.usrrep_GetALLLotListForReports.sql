SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--exec [usrrep_GetALLLotListForReports] -1
CREATE procedure [dbo].[usrrep_GetALLLotListForReports]
 @SiteID Int = -1
As

if(@SiteID = -1)
begin
	select distinct Code, Name from Lots with (nolock)
	where Dimension1 = '1' and len(Code) = 12
end
else
Begin
	select distinct Code, Name from Lots with (nolock)
	where Dimension1 = '1' and len(Code) = 12 and [SiteID] = @SiteID
end
GO
