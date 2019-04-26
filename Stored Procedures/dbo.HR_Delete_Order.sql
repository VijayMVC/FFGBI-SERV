SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <22/03/2017>
-- Description:	<Delete Order from Hilton Retail System>
-- =============================================

-- exec [dbo].[HR_Delete_Order] 118103, UK

CREATE PROCEDURE [dbo].[HR_Delete_Order] 

@OrderNo int,
@Country NVARCHAR (3)

AS
	 
BEGIN
	 
			IF (@Country = 'UK') 
				Begin
					Delete 
					from [dbo].[HR_Order_Summary_Import_UK] 
					where Group_Order_No = @OrderNo 
				END
			ELSE
				BEGIN
					Delete 
					from [dbo].[HR_Order_Summary_Import_IRE] 
					where Group_Order_No = @OrderNo
				END

			Delete
			from [dbo].[HR_Order_Summary_Import]
			where Group_Order_No = @OrderNo

			Delete
			from [dbo].[HR_Order_Allocation] 
			where OrderNo = @OrderNo
			
END	
	



				
	


	

GO
