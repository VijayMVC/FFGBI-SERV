SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 09/02/2015
-- Description:	Hilton shipment report for ireland
-- =============================================
CREATE PROCEDURE [dbo].[Hilton_shipment_repport_IRE] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
select * from hilton_shipment where site = 'Foyle Donegal'

END
GO
