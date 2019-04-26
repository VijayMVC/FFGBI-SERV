SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 30/03/2015
-- Description:	Get Order Summary
-- =============================================
CREATE PROCEDURE [dbo].[GetHROrderSummary] 
	-- Add the parameters for the stored procedure here

	-- exec [dbo].[GetHROrderSummary] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

	select
		Group_Order_No as [OrderNo], 
		case when 
			[Processed] = 'N' then 'Open'
			when [Processed] = 'Y' then 'Closed'
			else null end as [Status],

		convert(nvarchar(10),Delivery_Date,103) as DeliveryDate,

		sum(round(isnull(Ordered_Qty,0) ,0))as TotalQty,
		
		--isnull(Sum(Confirmed_Qty ),0) as ConfirmedQty,
		(
			select 
				count(*) 
			from 
				dbo.HR_Order_Allocation OA (nolock)
			where 
				OrderNo = Group_Order_No
			) as ConfirmedQty,
		
		count(distinct Sub_Order_No) as SubOrderNo,
		
		siteid
	From 
		HR_Order_Summary_import   (nolock)
	
	where 
		(
			box_no is not null 
			and 
			round(Ordered_Qty,0) is not null
		)
		and 
		isnumeric(Ordered_Qty)= 1
		and 
		Delivery_Date >= Dateadd(ww, -2, getdate())

	group by 
		Group_Order_No, 
		[Processed],
		Delivery_Date,
		siteid
	order by 
		Delivery_Date desc



END
GO
