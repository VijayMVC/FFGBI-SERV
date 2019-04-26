SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 10/11/2014
-- Description:	Fresh single product script
-- =============================================
CREATE PROCEDURE [dbo].[Group_Fresh_Single_Product] 

@Product nvarchar(10)
as
declare @today as datetime
declare @CampsieDate as datetime, @OmaghDate as datetime, @HiltonDate as datetime, @DonegalDate datetime, 
@GloucesterDate datetime, @MeltonDate datetime,@Maxdate as datetime
declare @MaxValueto as datetime
set @MaxValueto = (select max([ValueTo]) from Product_Price)
set @Today = (SELECT DATEADD(day, DATEDIFF(day, 0, getdate()), 0))
set @Campsiedate = (select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 1  )
set @OmaghDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 2 )
set @HiltonDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 3 )
set @DonegalDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 4 )
set @GloucesterDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 5  )
set @MeltonDate = (select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 6  )

select  pk.id ,pk.SiteID,
		--pk.inventoryid as Inventory,
		pr.[name] as Stock,

		cast(pk.Productcode as varchar (9)) as Product,
		mat1.[name] as ProductName,
		pk.prday	as PackDate,
		datediff (d,pk.prday,@Today) as Age,
		pk.KillDate as Killdate,
		isnull(col.[Palletnumber],' ') as Pallet,
		PP.[value] as PricePerKg,
		pk.useby as Useby,
		pk.DNOB,
		isnull(con.[name],'N/A') as Category,
		count(pk.id) as [Qty],
		sum(convert(decimal(10,2),isnull(pk.weight,0))) as Weight,
		lts.name
from
		Stock_packs pk (nolock)
		INNER JOIN products  mat1 (nolock) ON pk.productcode=mat1.productcode 
		--INNER JOIN products mat2 (nolock) ON mat1.productcode = mat2.productcode
		left JOIN inventories pr (nolock) ON pr.Inventoryid=pk.inventoryid and pk.siteid = pr.site
		LEFT OUTER JOIN pallets col(nolock) ON pk.palletid = col.palletid and pk.siteid = col.siteid
		LEFT OUTER JOIN ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode 
		left outer join CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID
		LEFT JOIN Product_Price as PP with (nolock) on mat1.ProductCode = PP.productcode and pk.siteid = pp.siteid and @MaxValueto between valuefrom and valueto
		left JOIN Lots lts (nolock) ON lts.code=pk.LotID and lts.siteid = pk.siteid
where	
		--pk.inventory in(4,8,14,56,12,68,69,70,71) 
		 pr.description2 = 'STOCK' and
		 
		pk.rtype <> 4 --and isnull(mat2.dimension4,0)=0
AND mat1.productcode=@Product
--And  Not (pk.Device in(75,76,77,78,329,330,331))
group by  pk.id,
 pk.[productcode],mat1.[name], pk.prday,datediff (d,pk.prday,@Today),pk.inventoryid, 
 pr.[name],
 pk.KillDate, col.[Palletnumber],
 PP.[value],
 pk.Useby,con.[name],
  pk.palletid,pk.DNOB,pk.Siteid,lts.name
	
--order  by
--	 mat1.productcode,mat1.[name], pk.prday,datediff (d,pk.prday,@Today),
--pk.inventoryid, pr.[name], pk.KillDate, col.[Palletnumber],PP.[value],pk.Useby,con.[name], pk.DNOB,pk.Siteid,lts.name
GO
