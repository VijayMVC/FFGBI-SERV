SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Jason Mcdevitt
-- Create date: 21/04/11
-- Description:	Procedure to return Animals for Filtre in dataVet 
-- =============================================
-- [Get_ReportList] '6B8A5943-DFD1-4351-9657-74721AD07EE0'
CREATE PROCEDURE [dbo].[Get_ReportList] 
@UserID uniqueidentifier
AS

select R.ReportName, 
--RG.[GroupName] 
'ALL'
 ,R.Folder, R.ReportID, R.ReportSource, R.DB ,R.SubFolder, R.DefaultParameters, R.ParentFolder
from DW_Report R 
--inner join tblReportGroup_Reports RGR on R.reportID = RGR.ReportID
--inner join tblReportGroup RG on RGR.groupID = RG.Groupid
--inner join tblReportGroup_Users RGU on RGR.GroupID = RGU.groupID 
--where RGU.UserID = @UserID
order By ReportNo,R.Folder,R.SubFolder, R.[Order]

GO
