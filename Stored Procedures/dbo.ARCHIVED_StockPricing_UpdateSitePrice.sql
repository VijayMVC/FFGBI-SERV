SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason Mcdevitt
-- Create date: 12.11.14
-- Description:	SP used to Update Prices on the Proc_materials table on each from the 
				-- from the prices updated for the group on the datawarehouse
-- =============================================
CREATE PROCEDURE [dbo].[ARCHIVED_StockPricing_UpdateSitePrice] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--Get Current Price List date
	Declare @CurrentPriceListdate datetime 
	set @CurrentPriceListdate = (select Max(ValueFrom) FROM [FFG_DW].[dbo].[Product_Price] where siteid = 7)
    
    ------------------------------------------------------------------------------------------
    --Update Foyle Campsie Value from STG Price
    ------------------------------------------------------------------------------------------
    --Server FM_SQL01
	BEGIN TRY
		delete from [192.168.3.62].innova.dbo.[UsrProduct_Price_Staging]
		RAISERROR('Delete from Foyle Campsie [UsrProduct_Price_Staging] Table sucessful : %i deleted',10,2,@@ROWCOUNT)
	END TRY
	BEGIN CATCH
		 RAISERROR('Delete from Foyle Campsie [UsrProduct_Price_Staging] Failed',10,2) 
	END CATCH
		
	--Update Foyle Campsie Staging Table
	BEGIN TRY
		insert into [192.168.3.62].innova.dbo.[UsrProduct_Price_Staging]
		([ProductCode],[Value])
		select PP.ProductCode, PP.Value  from 
		Product_Price PP inner join
		[192.168.3.62].innova.dbo.vw_matswithNoXML Mat
		on cast(PP.ProductCode as nvarchar) = Mat.code 
		where  
		PP.SiteID = 7 
		and PP.ValueFrom = @CurrentPriceListdate
		and isnumeric(Mat.[code]) = 1 
		order by PP.ProductCode
		RAISERROR('Insert Into  Foyle Campsie Price Staging Count: %i',10,2,@@ROWCOUNT) 
	END TRY
	BEGIN CATCH
		 RAISERROR('Insert Into  Foyle Campsie Price Staging Failed. Updated Count: %i',10,2,@@ROWCOUNT) 
	END CATCH
	
	--Execute Merge On Foyle Campsie server
	BEGIN TRY
		exec [192.168.3.62].innova.dbo.[usr_PriceMerge]
		RAISERROR('Merge Foyle Campsie Prices Completed',10,2) 
	END TRY
	BEGIN CATCH
		RAISERROR('Merge Foyle Campsie Prices Failed',10,2) 
	END CATCH
	------------------------------------------------------------------------------------------
	--End Campsie Update	
	------------------------------------------------------------------------------------------
    
    ------------------------------------------------------------------------------------------
    --Update Omagh Value from STG Price
    ------------------------------------------------------------------------------------------
    --Server FFG-SQL01
    BEGIN TRY
		delete from [192.168.3.62].innova.dbo.[UsrProduct_Price_Staging]
		RAISERROR('Delete from Foyle Omagh [UsrProduct_Price_Staging] Table sucessful : %i deleted',10,2,@@ROWCOUNT)
	END TRY
	BEGIN CATCH
		 RAISERROR('Delete from Foyle Omagh [UsrProduct_Price_Staging] Failed',10,2) 
	END CATCH
		
	--Update Foyle Omagh Staging Table
	BEGIN TRY
		insert into [192.168.3.62].innova.dbo.[UsrProduct_Price_Staging]
		([ProductCode],[Value])
		select PP.ProductCode, PP.Value  from 
		Product_Price PP inner join
		[192.168.3.62].innova.dbo.vw_matswithNoXML Mat
		on cast(PP.ProductCode as nvarchar) = Mat.code 
		where  
		PP.SiteID = 7 
		and PP.ValueFrom = @CurrentPriceListdate
		and isnumeric(Mat.[code]) = 1 
		order by PP.ProductCode
		RAISERROR('Insert Into  Foyle Omagh Price Staging Count: %i',10,2,@@ROWCOUNT) 
	END TRY
	BEGIN CATCH
		 RAISERROR('Insert Into  Foyle Omagh Price Staging Failed. Updated Count: %i',10,2,@@ROWCOUNT) 
	END CATCH
	
	--Execute Merge On Foyle Omagh server
	BEGIN TRY
		exec [192.168.3.62].innova.dbo.[usr_PriceMerge]
		RAISERROR('Merge Foyle Omagh Prices Completed',10,2) 
	END TRY
	BEGIN CATCH
		RAISERROR('Merge Foyle Omagh Prices Failed',10,2) 
	END CATCH
   ------------------------------------------------------------------------------------------
	--End Omagh Update	
	------------------------------------------------------------------------------------------
    
    ------------------------------------------------------------------------------------------
    --Update Cookstown Value from STG Price
    ------------------------------------------------------------------------------------------
    --Server HMCSQL1
    BEGIN TRY
		delete from [192.168.3.62].innova.dbo.[UsrProduct_Price_Staging]
		RAISERROR('Delete from Foyle Hilton [UsrProduct_Price_Staging] Table sucessful : %i deleted',10,2,@@ROWCOUNT)
	END TRY
	BEGIN CATCH
		 RAISERROR('Delete from Foyle Hilton [UsrProduct_Price_Staging] Failed',10,2) 
	END CATCH
		
	--Update Cookstown Staging Table
	BEGIN TRY
		insert into [192.168.3.62].innova.dbo.[UsrProduct_Price_Staging]
		([ProductCode],[Value])
		select PP.ProductCode, PP.Value  from 
		Product_Price PP inner join
		[192.168.3.62].innova.dbo.vw_matswithNoXML Mat
		on cast(PP.ProductCode as nvarchar) = Mat.code 
		where  
		PP.SiteID = 7 
		and PP.ValueFrom = @CurrentPriceListdate
		and isnumeric(Mat.[code]) = 1 
		order by PP.ProductCode
		RAISERROR('Insert Into  Foyle Hilton Price Staging Count: %i',10,2,@@ROWCOUNT) 
	END TRY
	BEGIN CATCH
		 RAISERROR('Insert Into  Foyle Hilton Price Staging Failed. Updated Count: %i',10,2,@@ROWCOUNT) 
	END CATCH
	
	--Execute Update On Coosktown server as Megr does not work on 2005
	BEGIN TRY
		exec [192.168.3.62].innova.dbo.[usr_PriceUpdate]
		RAISERROR('Update Foyle Hilton Prices Completed',10,2) 
	END TRY
	BEGIN CATCH
		RAISERROR('Update Foyle Hilton Prices Failed',10,2) 
	END CATCH
    
	------------------------------------------------------------------------------------------
	--End Cookstown Update	
	------------------------------------------------------------------------------------------
    	
    ------------------------------------------------------------------------------------------
    --Update Donegal Value from EURO Price
    ------------------------------------------------------------------------------------------
    --Server DMP-SQL02
    BEGIN TRY
		delete from [192.168.3.62].innova.dbo.[UsrProduct_Price_Staging]
		RAISERROR('Delete from Foyle Donegal [UsrProduct_Price_Staging] Table sucessful : %i deleted',10,2,@@ROWCOUNT)
	END TRY
	BEGIN CATCH
		 RAISERROR('Delete from Foyle Donegal [UsrProduct_Price_Staging] Failed',10,2) 
	END CATCH
		
	--Update Donegal Staging Table
	BEGIN TRY
		insert into [192.168.3.62].innova.dbo.[UsrProduct_Price_Staging]
		([ProductCode],[Value])
		--EUROVALUE FOR FD
		select PP.ProductCode, PP.EuroValue  from 
		Product_Price PP inner join
		[192.168.3.62].innova.dbo.vw_matswithNoXML Mat
		on cast(PP.ProductCode as nvarchar) = Mat.code 
		where  
		PP.SiteID = 7 
		and PP.ValueFrom = @CurrentPriceListdate
		and isnumeric(Mat.[code]) = 1 
		order by PP.ProductCode
		RAISERROR('Insert Into  Foyle Donegal Price Staging Count: %i',10,2,@@ROWCOUNT) 
	END TRY
	BEGIN CATCH
		 RAISERROR('Insert Into  Foyle Donegal Price Staging Failed. Updated Count: %i',10,2,@@ROWCOUNT) 
	END CATCH
	
	--Execute Merge On Donegal server 
	BEGIN TRY
		exec [192.168.3.62].innova.dbo.[usr_PriceMerge]
		RAISERROR('Merge Foyle Donegal Prices Completed',10,2) 
	END TRY
	BEGIN CATCH
		RAISERROR('Merge Foyle Donegal Prices Failed',10,2) 
	END CATCH
    
	------------------------------------------------------------------------------------------
	--End Foyle Donegal Update	
	------------------------------------------------------------------------------------------
  
    ------------------------------------------------------------------------------------------
    --Update Foyle Gloucester Value from STG Price
    ------------------------------------------------------------------------------------------
    --Server FG-SQL02
	BEGIN TRY
		delete from [192.168.3.62].innova.dbo.[UsrProduct_Price_Staging]
		RAISERROR('Delete from Foyle Gloucester [UsrProduct_Price_Staging] Table sucessful : %i deleted',10,2,@@ROWCOUNT)
	END TRY
	BEGIN CATCH
		 RAISERROR('Delete from Foyle Gloucester [UsrProduct_Price_Staging] Failed',10,2) 
	END CATCH
		
	--Update Foyle Gloucester Staging Table
	BEGIN TRY
		insert into [192.168.3.62].innova.dbo.[UsrProduct_Price_Staging]
		([ProductCode],[Value])
		select PP.ProductCode, PP.Value  from 
		Product_Price PP inner join
		[192.168.3.62].innova.dbo.vw_matswithNoXML Mat
		on cast(PP.ProductCode as nvarchar) = Mat.code 
		where  
		PP.SiteID = 7 
		and PP.ValueFrom = @CurrentPriceListdate
		and isnumeric(Mat.[code]) = 1 
		order by PP.ProductCode
		RAISERROR('Insert Into  Foyle Gloucester Price Staging Count: %i',10,2,@@ROWCOUNT) 
	END TRY
	BEGIN CATCH
		 RAISERROR('Insert Into  Foyle Gloucester Price Staging Failed. Updated Count: %i',10,2,@@ROWCOUNT) 
	END CATCH
	
	--Execute Merge On Foyle Gloucester server
	BEGIN TRY
		exec [192.168.3.62].innova.dbo.[usr_PriceMerge]
		RAISERROR('Merge Foyle Gloucester Prices Completed',10,2) 
	END TRY
	BEGIN CATCH
		RAISERROR('Merge Foyle Gloucester Prices Failed',10,2) 
	END CATCH
	------------------------------------------------------------------------------------------
	--End Gloucester Update	
	------------------------------------------------------------------------------------------

    
    ------------------------------------------------------------------------------------------
    --Update Foyle Melton Value from STG Price
    ------------------------------------------------------------------------------------------
    --Server FMM-SQL01
	BEGIN TRY
		delete from [192.168.3.62].innova.dbo.[UsrProduct_Price_Staging]
		RAISERROR('Delete from Foyle Melton [UsrProduct_Price_Staging] Table sucessful : %i deleted',10,2,@@ROWCOUNT)
	END TRY
	BEGIN CATCH
		 RAISERROR('Delete from Foyle Melton [UsrProduct_Price_Staging] Failed',10,2) 
	END CATCH
		
	--Update Foyle Melton Staging Table
	BEGIN TRY
		insert into [192.168.3.62].innova.dbo.[UsrProduct_Price_Staging]
		([ProductCode],[Value])
		select PP.ProductCode, PP.Value  from 
		Product_Price PP inner join
		[192.168.3.62].innova.dbo.vw_matswithNoXML Mat
		on cast(PP.ProductCode as nvarchar) = Mat.code 
		where  
		PP.SiteID = 7 
		and PP.ValueFrom = @CurrentPriceListdate
		and isnumeric(Mat.[code]) = 1 
		order by PP.ProductCode
		RAISERROR('Insert Into  Foyle Melton Price Staging Count: %i',10,2,@@ROWCOUNT) 
	END TRY
	BEGIN CATCH
		 RAISERROR('Insert Into  Foyle Melton Price Staging Failed. Updated Count: %i',10,2,@@ROWCOUNT) 
	END CATCH
	
	--Execute Merge On Foyle Melton server
	BEGIN TRY
		exec [192.168.3.62].innova.dbo.[usr_PriceMerge]
		RAISERROR('Merge Foyle Melton Prices Completed',10,2) 
	END TRY
	BEGIN CATCH
		RAISERROR('Merge Foyle Melton Prices Failed',10,2) 
	END CATCH
	------------------------------------------------------------------------------------------
	--End Melton Update	
	------------------------------------------------------------------------------------------
END
GO
