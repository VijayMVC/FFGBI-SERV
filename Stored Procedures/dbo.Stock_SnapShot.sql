SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 20/06/2014
-- Description:	Snap shot of stock
-- =============================================
CREATE PROCEDURE [dbo].[Stock_SnapShot] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
insert into dbo.global_Stock_Snapshot

Select 
ID,
SiteID,
GETDATE(),
LotID,
InventoryID,
InventoryLocationID,
PalletID,
ProductCode,
Weight
from Stock_Packs
 
END
GO
