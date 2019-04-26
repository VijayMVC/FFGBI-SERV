SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 24/04/2015
-- Description:	get open and closed orders
-- =============================================
CREATE PROCEDURE [dbo].[GetHROrderStatus] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
select distinct case when [Processed] = 'N' then 'Open'
	when [Processed] = 'Y' then 'Closed'
	else null end as [Status]
	from HR_Order_Summary_import

END
GO
