SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 09.06.2015
-- Description:	Created for update button on allocation portal. so it only changes the modified
-- =============================================
--exec [dbo].[HR_AllocateStockToOrderProcess_Modified] '101657','1','IRE'
CREATE PROCEDURE [dbo].[HR_AllocateStockToOrderProcess_Modified]
	-- Add the parameters for the stored procedure here
	@OrderNo Bigint,
	@OrderSubNo int,
	@SiteID Nvarchar(20)

AS
BEGIN


-- in-memory employee table to hold distinct employee_id
	DECLARE @i int
	DECLARE @Modified int
	DECLARE @numrows bigint
	DECLARE @BoxNo nvarchar(20)
	
	DECLARE 
		@Order_table TABLE 
		(
			idx smallint Primary Key IDENTITY(1,1),
			BoxNo nvarchar(20)
		)

	SET @Modified =1

	if (@SiteID = 'UK')
		begin

		-- populate employee table
		INSERT 
			@Order_table
		SELECT  
			Box_No 
		FROM 
			HR_Order_Summary_import SI with (nolock)
			left join  
				[FFGSQL06].[FFGProductionPlan].dbo.[HR_Product_Subs] PS (nolock) on SI.box_no = PS.boxno 
		where 
			Group_Order_No = @OrderNo 
			and 
			Sub_Order_no =@OrderSubNo 
			and 
			round(Ordered_Qty ,0) > 0
			and Not 
			Box_No is null 
			and not 
			Ordered_Qty is null
			and 
			[Modified] = 1
		
		order by PS.[Priority]
	

		--select * from @Order_table
		-- enumerate the table
		SET 
			@i = 1
		SET 
			@numrows = (SELECT COUNT(*) FROM @Order_table)
		IF 
			@numrows > 0
				
				WHILE (@i <= (SELECT MAX(idx) FROM @Order_table))
					BEGIN

						--Execute the Allocate to Stock Order for Each Box Number with a Qty
						SET @BoxNo = (SELECT BoxNo FROM @Order_table WHERE idx = @i)
						select @BoxNo
						exec [dbo].[HR_AllocateShortLifeToOrder] @OrderNo,@OrderSubNo,@BoxNo,@Modified
						select @BoxNo
						exec [dbo].[HR_AllocateStockToOrder] @OrderNo,@OrderSubNo,@BoxNo,@Modified

						-- increment counter for next employee
						SET @i = @i + 1
		        
					END
		End

		else if (@SiteID = 'IRE')
			begin

			-- populate employee table
			INSERT 
				@Order_table
			SELECT  
				Box_No 
			FROM 
				HR_Order_Summary_import SI with (nolock)
				left join  
					[FFGSQL06].[FFGProductionPlan].dbo.[HR_Product_Subs] PS (nolock) on SI.box_no = PS.boxno 
		
		where 
			Group_Order_No = @OrderNo 
			and 
			Sub_Order_no =@OrderSubNo 
			and 
			round(Ordered_Qty ,0) > 0
			and Not 
			Box_No is null 
			and not 
			Ordered_Qty is null
			and 
			[Modified] = 1
		
		order by PS.[Priority]

		--select * from @Order_table
		-- enumerate the table
		
		SET @i = 1
		SET @numrows = (SELECT COUNT(*) FROM @Order_table)
		IF @numrows > 0
			WHILE (@i <= (SELECT MAX(idx) FROM @Order_table))
			BEGIN

				--Execute the Allocate to Stock Order for Each Box Number with a Qty
				SET @BoxNo = (SELECT BoxNo FROM @Order_table WHERE idx = @i)
				select @BoxNo
				exec [dbo].[HR_AllocateShortLifeToOrder_IRE] @OrderNo,@OrderSubNo,@BoxNo,@Modified
				exec [dbo].[HR_AllocateStockToOrder_IRE] @OrderNo,@OrderSubNo,@BoxNo,@Modified

				-- increment counter for next employee
				SET @i = @i + 1
		        
			END

		End

end
GO
