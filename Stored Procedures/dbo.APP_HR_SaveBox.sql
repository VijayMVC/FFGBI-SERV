SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		David Bogues
-- Create date: 2018-01-08	(First SP of 2018!!! Happy New Year!!!!)
-- Description:	Logic to Save Hilton Retail Box. This SP also exists on PP Db. The whole Hilton Logic needs a proper review - but that can wait until we have centralized stock and new DB
-- =============================================
CREATE PROCEDURE [dbo].[APP_HR_SaveBox] 
	-- Add the parameters for the stored procedure here
	@BoxNo nvarchar(5),
	@ProductCode nvarchar(30), 
	@ProductTypeId int,  
	@DownGrades nvarchar(MAX), 
	@Substitues nvarchar(MAX), 
	@SubstituesP2 nvarchar(MAX) -- for some reason this isnt in the FFGBIDW Table, But it is in PP Db
AS
	BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		-- Check if Box Exists and if it does update it
		IF (NOT EXISTS(
			SELECT * 
			FROM [HR_Product_Subs] with (nolock)
			WHERE BoxNo = @BoxNo))
		BEGIN 
			INSERT INTO [HR_Product_Subs]
			(ProductCode, ProductTypeId, BoxNo,	DownGrades,	Substitues)
			VALUES
			(@ProductCode, @ProductTypeId, @BoxNo,	@DownGrades, @Substitues)
		END 
		ELSE 
		BEGIN 
			-- Otherwise create it
			UPDATE 
				[HR_Product_Subs] 
			SET
				ProductCode = @ProductCode, 
				ProductTypeId = @ProductTypeId, 	
				DownGrades = @DownGrades,	
				Substitues = @Substitues
			WHERE 
				BoxNo = @BoxNo
		END 
	

		-- Select Updated / Created Box
		Select 
			BoxNo,
			ProductCode,
			ProductTypeId,
			DownGrades,
			Substitues
		FROM
			[HR_Product_Subs] with (nolock)
		WHERE 
			BoxNo = @BoxNo
END
GO
