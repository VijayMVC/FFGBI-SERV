SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--  exec [Group_Frozen_Weekly_Snapshot_Daily_Failover]

CREATE PROCEDURE [dbo].[Group_Frozen_Weekly_Snapshot_Daily_Failover]
	-- Add the parameters for the stored procedure here

AS
declare @count int

set @count = (select count(g.Date) as [count]
from Group_Frozen_Stock_Snapshot_daily g
where cast(g.Date as date) = cast(getdate() as date))

--select @count
if @count =0
 exec [Group_Frozen_Weekly_Snapshot_Daily];


GO
