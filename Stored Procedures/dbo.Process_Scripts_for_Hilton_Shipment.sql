SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 10/2/2015
-- Description:	Run scripts for Hilton Shipment
-- =============================================
CREATE PROCEDURE [dbo].[Process_Scripts_for_Hilton_Shipment] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
delete From dbo.Hilton_shipment
--Omagh	
exec [OMASQL01].[INNOVA].DBO.[ussrep_HiltonOrders_For_Group_Reporting]
--Campsie
exec [CAMSQL01].[INNOVA].DBO.[ussrep_HiltonOrders_For_Group_Reporting]
--Hilton
exec [CKTSQL01].[INNOVA].DBO.[ussrep_HiltonOrders_For_Group_Reporting]
--Donegal
exec [DONSQL01].[INNOVA].DBO.[ussrep_HiltonOrders_For_Group_Reporting]
--Gloucester
exec [GLOSQL01].[INNOVA].DBO.[ussrep_HiltonOrders_For_Group_Reporting]


END
GO
