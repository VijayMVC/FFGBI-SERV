SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 09/02/2015
-- Description:	hilton shipment report for uk
-- =============================================
CREATE PROCEDURE [dbo].[Hilton_Shipment_report_uk] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
select * from hilton_shipment where site <> 'Foyle Donegal'

END
GO
