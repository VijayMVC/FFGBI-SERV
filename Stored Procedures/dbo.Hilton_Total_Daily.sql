SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy
-- Create date: 10/02/2015
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Hilton_Total_Daily] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
select NV.[Site]
      ,P.[Description1]
      ,NV.[Order No_]
      ,NV.[Ordered Qty_]
      ,NV.[weight]
      ,NV.[Product Code]
      ,NV.[Box Number]
      ,NV.[ProductType]
      ,NV.[Shipment Date]
      ,NV.[Delivered Date]
      ,NV.[PO]
      from [FFG_DW].[dbo].[Hilton_shipment] NV
      left join products P (nolock) on NV.[Product Code] = P.ProductCode
      

END
GO
