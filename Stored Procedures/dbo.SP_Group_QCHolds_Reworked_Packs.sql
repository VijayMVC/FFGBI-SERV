SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevzy>
-- Create date: <24/02/2017>
-- Description:	<Report requested by Nyree, QCHold & Reworked Packs In Stock acros group>
-- =============================================

-- exec [dbo].[SP_Group_QCHolds_Reworked_Packs]

CREATE PROCEDURE [dbo].[SP_Group_QCHolds_Reworked_Packs] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select Case when SP.SiteID = '1' then 'Foyle Campsie'
				when SP.SiteID = '2' then 'Foyle Omagh'							
				when SP.SiteID = '3' then 'Foyle Cookstown'
				when SP.SiteID = '4' then 'Foyle Donegal'
				when SP.SiteID = '5' then 'Foyle Gloucester'
				when SP.SiteID = '6' then 'Foyle Melton Mowbray'
				else '' end AS [Site],
	
	SP.ProductCode, PRO.Description1, COUNT(SP.ProductCode) AS QTY, ROUND(SUM(SP.Weight),2) as [Weight], INV.[Name], SP.KillDate as [Kill Date], SP.DNOB as DNOB, 
	SP.PRDay as [Production Day], SP.UseBy as [Use By Date], SP.Invtime

from [FFG_DW].[dbo].[Stock_Packs] AS SP (nolock)

inner join Products AS PRO with (nolock) on PRO.ProductCode = SP.ProductCode
inner join Inventories AS INV with (nolock) on INV.InventoryID = SP.InventoryID and INV.[Site] = SP.SiteID

where	(INV.description3 ='QC HOLD') OR
		(INV.description3 LIKE '%Return%') 
		

group by SP.SiteID, SP.ProductCode,Pro.Description1,INV.[Name],SP.KillDate, SP.DNOB , SP.PRDay , SP.UseBy, SP.Invtime


order by [Site] desc

END
GO
