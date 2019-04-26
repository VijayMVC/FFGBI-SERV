SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 20/06/2014
-- Description:	Pallet information
-- =============================================
CREATE PROCEDURE [dbo].[Sales_Pallet_Enquiry_Report] 
@PalletNo int--,
--@Site int
as

------ LOG STORED PROC // RUNTIME & PARAMETERS ¬
--INSERT INTO				usr_SP_Log ([SPName], [StartDate], [EndDate], [FromLot], [ToLot], [FromBatch], [ToBatch], [FromOrder], [ToOrder], [Inventory], [Misc], [Timestamp])
--SELECT					OBJECT_NAME(@@PROCID), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, @PalletNo, GetDate()
	
select 
	pc1.palletid as [Id],
	pc1.[Palletnumber] as PalletNo,
	pr.[name] as Department,
	mat1.productcode as Product,
	mat1.[name] as Description,
	pk.[Palletid] as BoxNo,
	pk.weight as	BoxWeight,
	pk.tare	as		BoxTare,
	--pc1.begTime as Created,
	--pc1.endTime as Updated,
	isnull(mat1.description4,'000') as ArtNo,
	isnull(mat1.Description5,'0000') as ArticleNo,
	--isnull(pk.expire1,'000000') as ExpiryDate,
	pk.useby as ExpiryDate,
	--isnull(left(mat2.shname,1),'0') as	CrateType, 
	pk.killdate as KillDate,
	pk.prday as Packdate,
	pk.DNOB as DNOB,
	PL.name AS [Lot Desc]
	
	
from 
	pallets pc1 (nolock) 
	inner join stock_packs pk (nolock) on pc1.palletid = pk.palletid
	inner join  products mat1 (nolock) on Pk.productcode = mat1.productcode
	inner join inventories pr (nolock) on  pc1.inventoryid=pr.inventoryid
	--inner join products mat2 (nolock)on isnull(mat1.pkpackaging,6207) = mat2.material
	inner join Lots PL WITH (NOLOCK) on pk.lotid = PL.Lotid
	where 
pc1.[PalletNumber]like @PalletNo 
--and pc1.[siteid] = @site


-- exec usrrep_Sales_pallet_enquiry 3386
GO
