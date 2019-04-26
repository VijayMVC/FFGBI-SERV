SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		David Bogues
-- Create date: 22nd Aug 2016
-- Description:	This is based on Daniel's SP_FreshBase SP for Group Stock report. 
--					It is used for the Hilton Stock Page on the New Protal
-- =============================================

--exec  [usr_Portal_FreshStock] 'HILTON RETAIL'


CREATE procedure [dbo].[usr_Portal_FreshStock]
	-- Add the parameters for the function here
	@CustomerName nvarchar(50)
AS
BEGIN

DECLARE 
	@today as datetime

DECLARE 
	@CampsieDate as datetime, 
	@OmaghDate as datetime, 
	@HiltonDate as datetime, 
	@DonegalDate datetime, 
	@GloucesterDate datetime, 
	@MeltonDate datetime,
	@Maxdate as datetime

DECLARE 
	@MaxValueto as datetime

SET
	@MaxValueto = (select max([ValueTo]) from Product_Price where siteid <>7)
SET 
	@Today = (SELECT DATEADD(day, DATEDIFF(day, 0, getdate()), 0))
SET 
	@Campsiedate = (select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 1 and CurrencyCode= 'EUR' )
SET 
	@OmaghDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 2 and CurrencyCode= 'EUR' )
SET 
	@HiltonDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 3 and CurrencyCode= 'EUR' )
SET 
	@DonegalDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 4 and CurrencyCode= 'GBP' )
SET 
	@GloucesterDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 5 and CurrencyCode= 'EUR' )
SET 
	@MeltonDate = (select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 6 and CurrencyCode= 'EUR'  )



SELECT DISTINCT  

	pk.OrgSite	as SiteId
	,os.orgsitename as SiteName
	,SUBSTRING(mat1.description5, len(mat1.description5)- 2, 3)   AS PLU
	,pk.Productcode as Code
	,mat1.name as [Description]
	,pk.KillDate AS Killdate
	,pk.prday AS PackDate
	,pk.DNOB AS DNOB
	,pk.UseBy AS Useby
	,count(pk.id) as Quantity
	,sum(pk.[weight]) as [Weight]


FROM         
	Stock_Packs AS pk WITH (nolock) 
	
	INNER JOIN Sites S WITH (nolock) 
		on pk.SiteID = S.SiteID  
	
	left join Orginal_site_lookup OS with (nolock) 
		on pk.siteid = os.siteid 
		and pk.orgsite = orgsiteid 

	INNER JOIN  Products AS mat1 WITH (nolock) 
		ON pk.ProductCode = mat1.ProductCode 

	LEFT JOIN Product_Price as PP with (nolock) 
		on mat1.ProductCode = PP.productcode 
		and pk.siteid = pp.siteid 
		and @MaxValueto between valuefrom and valueto

	left join [Currency Exchange] CE with (nolock) 
		on pk.siteid = CE.siteid 
		and  CE.startingdate = 
			(select max([StartingDate]) 
				from [Currency Exchange] 
				where CE.siteid = pk.siteid 
					and [CurrencyCode] = 'EURO' 
					or [CurrencyCode] ='GBP' 
			)

	Inner JOIN Inventories AS pr WITH (nolock) 
		ON pr.InventoryID = pk.InventoryID 
		and pk.siteid = pr.site 
	
	left join [InventoryLocations] INVL (nolock) 
		on  pk.siteid = INVL.siteid 
		and pk.InventoryID = INVL.InventoryID 
		and pk.InventoryLocationID = INVL.[InventoryLocationID]
	
	INNER JOIN ProductTypes PT 
		ON mat1.materialtype = pt.ProductTypeID 

	LEFT OUTER JOIN Pallets AS col WITH (nolock) 
		ON pk.PalletID = col.PalletID 
		and pk.siteid = col.siteid
	
	LEFT OUTER JOIN ProductSpecs as PS with (nolock) 
		on mat1.ProductCode = ps.ProductCode 

	left outer join CustomerSpecs AS con WITH (nolock) 
		ON ps.SpecID = con.SpecID

	left JOIN Lots lts (nolock) 
		ON cast(
			(
				case when isnumeric(lts.code) = 1 
				then  cast(lts.code as bigint) 
				else -1 end) as bigint) = pk.LotID 
			and lts.siteid = pk.siteid
	
WHERE  
	pr.InventoryTypeID = 1 and (mat1.StorageType <> 2) and not(pr.description1 like '%FROZEN%') 
	and pk.weight > 0.1 
	and PT.ProductTypeID <> 140 
	and mat1.productcode <> 999999999
	and pr.description2 = 'STOCK'

	-- DBogues 2016-12-13 : removed ready tio ship at request of gavin based on feed back from tesco team
	and pr.Name != 'Ready to Ship'

	and con.name = @CustomerName

	--KHargan 03/05/17 : removed pack from these inventories as requested by HR Team, given the go ahead by Heather Mackey (Ticket 6508)
	and NOT ISNULL(pr.description3,'') = 'QC HOLD'

	and NOT ISNULL(pr.[name],'') like '%QC%'   --added for temp fix 12/02/18 as CKT had QC Stock inventory created

	and NOT ISNULL(pr.description3,'') =  'RETURNS'

	-- Khargan 29/11/17 removed packs in inventory Stock on hold, requuested by Rory O Brien 
	and NOT ISNULL(pr.[Name],'') = 'Stock on hold'

	--Khargan 21/03/18 removed packs from FI requested by Rory O Brien
	and pk.SiteID <> 7


	


GROUP BY 
	pk.OrgSite,
	mat1.description5
	,pk.Productcode
	,os.orgsitename
	,mat1.name 
	,pk.KillDate
	,pk.prday
	,pk.DNOB  
	,pk.UseBy 


-- exec  [usr_Portal_FreshStock] 'HILTON RETAIL'

END
GO
