SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tomy \ Jason
-- Create date: 03/06/2014
-- Description:	Upload Proc_Materials from Site to group Stock Packs
-- =============================================
CREATE PROCEDURE [dbo].[ARCHIVED_UploadStock]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
   
   
   insert into Stock_Packs
--------------------Campsie--------------------------
	select 
	id,1,sscc,pp.batch,
	Case When pp.site = 1 then (select [code] from [FM-SQL01].innova.dbo.vw_LotswithNoXML PL where PL.lot = pp.lot)
		
			 When pp.site = 2 then (select FMPk.lot  from
									[FFG-SQL01].[INNOVA].dbo.[proc_packs] FMPK (nolock) 
									where  FMPK.site = 1 and FMPK.number = pp.number) 
			 When pp.site = 3 then (select HPK.lot from 
									[HMCSQL1].[INNOVA].dbo.[proc_packs] HPK (nolock) 
									where  HPK.site = 1 and HPK.number = pp.number) 
			When pp.site = 4 then (select DPK.lot  from 
									[DMP-SQL02].[INNOVA].dbo.[proc_packs] DPK (nolock)
									where  DPK.site = 1 and DPK.number = pp.number)	
			When pp.site = 5 then (select MMPK.lot  from 
									[FMM-SQL01].[INNOVA].dbo.[proc_packs] MMPK (nolock) 
									where  MMPK.site = 1 and MMPK.number = pp.number) 	
			When pp.site = 6 then (select FGPK.lot  from 
									[FG-SQL02].[INNOVA].dbo.[proc_packs] FGPK (nolock) 
									where  FGPK.site = 1 and FGPK.number = pp.number) 												
									else null
									end As Lot,		
isnull(Device,0) as Device,pp.prday,pp.expire1,pp.expire2,pp.expire3,inventory,invLocation,pallet,(select code from [FM-SQL01].innova.dbo.vw_matswithNoXML where material = pp.Material) as ProductCode,Packaging,weight,pp.gross,tare,pieces,regtime						
from [FM-SQL01].innova.dbo.proc_packs PP (nolock)
inner join [FM-SQL01].innova.dbo.vw_PrUnitsWithNoXML INV (nolock) on PP.inventory = INV.prunit
inner join [FM-SQL01].innova.dbo.vw_matswithNoXML mat (nolock) on PP.material = mat.material
where INV.Description2 = 'STOCK' and  pp.rtype <> 4 and LEN(mat.code) = 9




   
    insert into Stock_Packs
---------------------OMAGH---------------------------   
	select 
	id,2,sscc,pp.batch,
	Case When pp.site = 1 then (select [code] from [FFG-SQL01].innova.dbo.vw_LotswithNoXML PL where PL.lot = pp.lot)
		
			 When pp.site = 2 then (select FMPk.lot  from
									[FM-SQL01].[INNOVA].dbo.[proc_packs] FMPK (nolock) 
									where  FMPK.site = 1 and FMPK.number = pp.number) 
			 When pp.site = 3 then (select HPK.lot from 
									[HMCSQL1].[INNOVA].dbo.[proc_packs] HPK (nolock) 
									where  HPK.site = 1 and HPK.number = pp.number) 
			When pp.site = 4 then (select DPK.lot  from 
									[DMP-SQL02].[INNOVA].dbo.[proc_packs] DPK (nolock)
									where  DPK.site = 1 and DPK.number = pp.number)	
			When pp.site = 8 then (select MMPK.lot  from 
									[FMM-SQL01].[INNOVA].dbo.[proc_packs] MMPK (nolock) 
									where  MMPK.site = 1 and MMPK.number = pp.number) 	
			When pp.site = 10 then (select FGPK.lot  from 
									[FG-SQL02].[INNOVA].dbo.[proc_packs] FGPK (nolock) 
									where  FGPK.site = 1 and FGPK.number = pp.number) 												
									else null
									end As Lot,		
isnull(Device,0) as Device,pp.prday,pp.expire1,pp.expire2,pp.expire3,inventory,invLocation,pallet,(select code from [FFG-SQL01].innova.dbo.vw_matswithNoXML where material = pp.Material) as ProductCode,Packaging,weight,pp.gross,tare,pieces,regtime						
from [FFG-SQL01].innova.dbo.proc_packs PP (nolock)
inner join [FFG-SQL01].innova.dbo.vw_proc_prunitsWithNoXML INV (nolock) on PP.inventory = INV.prunit
inner join [FFG-SQL01].innova.dbo.vw_matswithNoXML mat (nolock) on PP.material = mat.material
where INV.Description2 = 'STOCK' and  pp.rtype <> 4 and LEN(mat.code) = 9 

 insert into Stock_Packs
---------------------Cookstown---------------------------   
select 
	id,3,sscc,pp.batch,
	Case When pp.site = 1 then (select [code] from [HMCSQL1].innova.dbo.vw_LotswithNoXML PL where PL.lot = pp.lot)
			 When pp.site = 2 then (select FMPk.lot  from
									[FFG-SQL01].[INNOVA].dbo.[proc_packs] FMPK (nolock) 
									where  FMPK.site = 1 and FMPK.number = pp.number) 
			 When pp.site = 3 then (select HPK.lot from 
									[FM-SQL01].[INNOVA].dbo.[proc_packs] HPK (nolock) 
									where  HPK.site = 1 and HPK.number = pp.number) 
			When pp.site = 4 then (select DPK.lot  from 
									[DMP-SQL02].[INNOVA].dbo.[proc_packs] DPK (nolock)
									where  DPK.site = 1 and DPK.number = pp.number)	
			When pp.site = 5 then (select MMPK.lot  from 
									[FMM-SQL01].[INNOVA].dbo.[proc_packs] MMPK (nolock) 
									where  MMPK.site = 1 and MMPK.number = pp.number) 	
			When pp.site = 6 then (select FGPK.lot  from 
									[FG-SQL02].[INNOVA].dbo.[proc_packs] FGPK (nolock) 
									where  FGPK.site = 1 and FGPK.number = pp.number) 												
									else null
									end As Lot,		
isnull(Device,0) as Device,pp.prday,pp.expire1,pp.expire2,pp.expire3,inventory,invLocation,pallet,(select code from [HMCSQL1].innova.dbo.vw_matswithNoXML where material = pp.Material) as ProductCode,Packaging,weight,pp.gross,tare,pieces,regtime						
from [HMCSQL1].innova.dbo.proc_packs PP (nolock)
inner join [HMCSQL1].innova.dbo.vw_proc_prunitsWithNoXML INV (nolock) on PP.inventory = INV.prunit
inner join [HMCSQL1].innova.dbo.vw_matswithNoXML mat (nolock) on PP.material = mat.material
where INV.Description2 = 'STOCK' and  pp.rtype <> 4 and LEN(mat.code) = 9  


 insert into Stock_Packs
---------------------Donegal---------------------------   
select 
	id,4,sscc,pp.batch,
	Case When pp.site = 1 then (select [code] from [DMP-SQL02].innova.dbo.vw_LotswithNoXML PL where PL.lot = pp.lot)
			 When pp.site = 2 then (select FMPk.lot  from
									[FM-SQL01].[INNOVA].dbo.[proc_packs] FMPK (nolock) 
									where  FMPK.site = 1 and FMPK.number = pp.number) 
			 When pp.site = 3 then (select HPK.lot from 
									[FFG-SQL01].[INNOVA].dbo.[proc_packs] HPK (nolock) 
									where  HPK.site = 1 and HPK.number = pp.number) 
			When pp.site = 4 then (select DPK.lot  from 
									[HMCSQL1].[INNOVA].dbo.[proc_packs] DPK (nolock)
									where  DPK.site = 1 and DPK.number = pp.number)	
			When pp.site = 5 then (select MMPK.lot  from 
									[FMM-SQL01].[INNOVA].dbo.[proc_packs] MMPK (nolock) 
									where  MMPK.site = 1 and MMPK.number = pp.number) 	
			When pp.site = 6 then (select FGPK.lot  from 
									[FG-SQL02].[INNOVA].dbo.[proc_packs] FGPK (nolock) 
									where  FGPK.site = 1 and FGPK.number = pp.number) 												
									else null
									end As Lot,		
isnull(Device,0) as Device,pp.prday,pp.expire1,pp.expire2,pp.expire3,inventory,invLocation,pallet,(select code from [DMP-SQL02].innova.dbo.vw_matswithNoXML where material = pp.Material) as ProductCode,Packaging,weight,pp.gross,tare,pieces,regtime						
from [DMP-SQL02].innova.dbo.proc_packs PP (nolock)
inner join [DMP-SQL02].innova.dbo.vw_proc_prunitsWithNoXML INV (nolock) on PP.inventory = INV.prunit
inner join [DMP-SQL02].innova.dbo.vw_matswithNoXML mat (nolock) on PP.material = mat.material
where INV.Description2 = 'STOCK' and  pp.rtype <> 4 and LEN(mat.code) = 9  

 insert into Stock_Packs
---------------------Gloucester---------------------------   
select 
	id,5,sscc,pp.batch,
	Case When pp.site = 1 then (select [code] from [FG-SQL02].innova.dbo.vw_LotswithNoXML PL where PL.lot = pp.lot)
			 When pp.site = 2 then (select FMPk.lot  from
									[FFG-SQL01].[INNOVA].dbo.[proc_packs] FMPK (nolock) 
									where  FMPK.site = 1 and FMPK.number = pp.number) 
			 When pp.site = 3 then (select HPK.lot from 
									[FM-SQL01].[INNOVA].dbo.[proc_packs] HPK (nolock) 
									where  HPK.site = 1 and HPK.number = pp.number) 
			When pp.site = 4 then (select DPK.lot  from 
									[DMP-SQL02].[INNOVA].dbo.[proc_packs] DPK (nolock)
									where  DPK.site = 1 and DPK.number = pp.number)	
			When pp.site = 5 then (select MMPK.lot  from 
									[HMCSQL1].[INNOVA].dbo.[proc_packs] MMPK (nolock) 
									where  MMPK.site = 1 and MMPK.number = pp.number) 	
			When pp.site = 6 then (select FGPK.lot  from 
									[FMM-SQL01].[INNOVA].dbo.[proc_packs] FGPK (nolock) 
									where  FGPK.site = 1 and FGPK.number = pp.number) 												
									else null
									end As Lot,		
isnull(Device,0) as Device,pp.prday,pp.expire1,pp.expire2,pp.expire3,inventory,invLocation,pallet,(select code from [FG-SQL02].innova.dbo.vw_matswithNoXML where material = pp.Material) as ProductCode,Packaging,weight,pp.gross,tare,pieces,regtime						
from [FG-SQL02].innova.dbo.proc_packs PP (nolock)
inner join [FG-SQL02].innova.dbo.vw_proc_prunitsWithNoXML INV (nolock) on PP.inventory = INV.prunit
inner join [FG-SQL02].innova.dbo.vw_matswithNoXML mat (nolock) on PP.material = mat.material
where INV.Description2 = 'STOCK' and  pp.rtype <> 4 and LEN(mat.code) = 9 and pp.expire2 is not null 


 insert into Stock_Packs
---------------------Melton---------------------------   
select 
	id,6,sscc,pp.batch,
	Case When pp.site = 1 then (select [code] from [FMM-SQL01].innova.dbo.vw_LotswithNoXML PL where PL.lot = pp.lot)
			 When pp.site = 2 then (select FMPk.lot  from
									[FFG-SQL01].[INNOVA].dbo.[proc_packs] FMPK (nolock) 
									where  FMPK.site = 1 and FMPK.number = pp.number) 
			 When pp.site = 3 then (select HPK.lot from 
									[FM-SQL01].[INNOVA].dbo.[proc_packs] HPK (nolock) 
									where  HPK.site = 1 and HPK.number = pp.number) 
			When pp.site = 4 then (select DPK.lot  from 
									[DMP-SQL02].[INNOVA].dbo.[proc_packs] DPK (nolock)
									where  DPK.site = 1 and DPK.number = pp.number)	
			When pp.site = 5 then (select MMPK.lot  from 
									[HMCSQL1].[INNOVA].dbo.[proc_packs] MMPK (nolock) 
									where  MMPK.site = 1 and MMPK.number = pp.number) 	
			When pp.site = 6 then (select FGPK.lot  from 
									[Fg-SQL02].[INNOVA].dbo.[proc_packs] FGPK (nolock) 
									where  FGPK.site = 1 and FGPK.number = pp.number) 												
									else null
									end As Lot,		
isnull(Device,0) as Device,pp.prday,pp.expire1,pp.expire2,pp.expire3,inventory,invLocation,pallet,(select code from [FMM-SQL01].innova.dbo.vw_matswithNoXML where material = pp.Material) as ProductCode,Packaging,weight,pp.gross,tare,pieces,regtime						
from [FMM-SQL01].innova.dbo.proc_packs PP (nolock)
inner join [FMM-SQL01].innova.dbo.vw_proc_prunitsWithNoXML INV (nolock) on PP.inventory = INV.prunit
inner join [FMM-SQL01].innova.dbo.vw_matswithNoXML mat (nolock) on PP.material = mat.material
where INV.Description2 = 'STOCK' and  pp.rtype <> 4 and LEN(mat.code) = 9  
	
	
END

GO
