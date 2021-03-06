SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- ============================================= 
-- Author:    Jason McDevitt 
-- Create date: 16/04/2015 
-- Description:  Allocate Short Life STock to HR Order 
-- ============================================= 
--exec [dbo].[HR_AllocateShortLifeToOrder_Tester] '128843','1','901' 
create PROCEDURE [dbo].[HR_AllocateShortLifeToOrder_Tester] 
  -- Add the parameters for the stored procedure here 
  @OrderNo    BIGINT, 
  @OrderSubNo INT, 
  @BoxNo      NVARCHAR(20), 
  @Modified   INT 
AS 
  BEGIN 
      DECLARE @OrderAllocationTemp TABLE 
        ( 
           [orderno]     [BIGINT] NOT NULL, 
           [suborderno]  [INT] NOT NULL, 
           [productcode] [NVARCHAR](15) NOT NULL, 
           [palletno]    [BIGINT] NOT NULL, 
           [boxno]       NVARCHAR(20) NOT NULL, 
           [siteid]      [INT] NOT NULL, 
           [allocate]    BIT, 
           [palletid]    [BIGINT] NULL, 
           [dnob]        [DATETIME] NULL, 
           [useby]       [DATETIME] NULL, 
           [hr_boxno]    NVARCHAR(10), 
           orderdate     DATE, 
           palletqty     INT 
        ) 
      DECLARE @today AS DATETIME 

      SET @Today = (SELECT Dateadd(day, Datediff(day, 0, Getdate()), 0)) 

      ------------------------------------------------------------------------------------------- 
      --Allocate Substitute Products 
      ------------------------------------------------------------------------------------------- 
      INSERT INTO @OrderAllocationTemp 
      SELECT Hr.group_order_no                AS [OrderNo], 
             HR.sub_order_no                  AS [SubOrderNo], 
             pk.productcode, 
             Isnull(col.palletnumber, ' ')    AS Pallet, 
             pk.sscc, 
             pk.siteid, 
             CASE 
               WHEN ( Round(HR.[ordered_qty], 0) - (SELECT Count(*) 
                                                    FROM 
                      hr_order_allocation OA2 WITH (nolock) 
                                                    WHERE 
                      OA2.[hr_boxno] = HR.box_no 
                      AND [orderno] = @OrderNo 
                      AND suborderno = 
                          @OrderSubNo) ) >= 
                    Row_number() 
                      OVER 
                           ( 
                           partition BY HR.box_no 
                           ORDER BY HR.box_no, Datediff("d", @Today, pk.useby)) 
             THEN 1 
               ELSE 0 
             END                              AS Allocate, 
             Col.palletid                     AS PalletId, 
             pk.dnob                          AS DNOB, 
             pk.useby                         AS Useby, 
             HR.box_no, 
             Cast(HR.orderdate AS DATE)       AS OrderDate, 
             (SELECT Count(*) 
              FROM   stock_packs SP (nolock)
              WHERE  SP.palletid = pk.palletid 
                     AND SP.dnob = Pk.dnob 
                     AND SP.useby = pk.useby) AS qty 
      FROM   hr_order_summary_import AS HR 
             INNER JOIN [FFGSQL06].[FFGProductionPlan].[dbo].hr_product_subs AS 
                        HPS with (nolock)
                     ON HR.box_no = HPS.boxno 
             CROSS apply [dbo].[Split](HPS.substitues, ',') S 
             INNER JOIN stock_packs  AS pk WITH (nolock) 
                     ON Cast(pk.productcode AS NVARCHAR(15)) = S.item 
             INNER JOIN products AS mat1 WITH (nolock) 
                     ON pk.productcode = mat1.productcode 
             INNER JOIN inventories AS pr WITH (nolock) 
                     ON pr.inventoryid = pk.inventoryid 
                        AND pk.siteid = pr.site 
             INNER JOIN 
             --had to put isnull with 9999 to collect packs that are not on pallets.  
             pallets AS col WITH (nolock) 
                     ON Isnull(pk.palletid, 9999) = Isnull(col.palletid, 9999) 
                        AND pk.siteid = col.siteid 
             LEFT OUTER JOIN productspecs AS PS WITH (nolock) 
                          ON mat1.productcode = ps.productcode 
             LEFT OUTER JOIN customerspecs AS con WITH (nolock) 
                          ON ps.specid = con.specid 
      WHERE  HR.box_no = @BoxNo 
             AND pk.siteid <> 4 
			 AND pk.SiteID <> 7 -- added by KH to remove FI stock getting allocated 21/03/18
             AND HR.group_order_no = @OrderNo 
             AND Hr.sub_order_no = @OrderSubNo 
             AND NOT( pr.[site] = 1 
                      AND pr.[inventoryid] = '70' ) 
             AND NOT( pr.[site] = 3 
                      AND pr.[inventoryid] = '27' ) 
             AND mat1.storagetype = 1 
             AND NOT( pr.NAME LIKE '%Gran%' ) 
             AND pr.inventorytypeid = 1 
             AND ( pr.NAME <> 'Order Returns' 
                    OR pr.NAME <> 'Beef Returns' ) 
             AND pr.NAME <> 'Ready to Ship' 
             AND pr.NAME <> 'Stock on hold' 
             AND pr.NAME <> 'QC Stock' 
             AND pr.NAME <> 'Returns' 
             AND pr.NAME <> 'QC Hold' 
			 and pr.Name <> 'Sawyers Intransit' -- added by Kh to exclude on ROB's request 19/04/18
             AND NOT ( pr.NAME LIKE '%QC%' ) 
             AND pr.NAME <> 'Chill D Floor' 
             AND Isnull(con.NAME, 'N/A') LIKE '%HILTON%' 
             AND ( Datediff("d", HR.delivery_date, pk.useby) > = 2 ) 
             AND ( Datediff("d", @Today, pk.useby) < = 7 ) 
             AND Round(HR.[ordered_qty], 0) > 0 
             AND ( HR.box_no IS NOT NULL 
                   AND Hr.ordered_qty IS NOT NULL ) 
             AND pk.dnob <= ( HR.delivery_date + 1 ) 
             AND pk.useby >= ( HR.delivery_date + 2 ) 
             AND NOT( pk.siteid = 2 
                      AND pk.inventoryid = 17 ) 
             AND NOT EXISTS (SELECT * 
                             FROM   [FFG_DW].[dbo].[hr_order_allocation] oA3 with (nolock)
                             WHERE  oA3.boxno = pk.sscc 
                                    AND oA3.[siteid] = pk.siteid 
                                    AND oA3.orderdate = Cast( 
                                        HR.orderdate AS DATE) 
                            ) 
      ORDER  BY Datediff("d", @Today, pk.useby) ASC, 
                qty DESC, 
                HR.box_no, 
                pallet 

      ---------------------------------------------------------------------------------------------------------------------- 

      SELECT [orderno], 
             [suborderno], 
             [productcode], 
             [palletno], 
             [boxno], 
             [siteid], 
             palletid, 
             dnob, 
             useby, 
             [hr_boxno], 
             orderdate, 
             @Modified 
      FROM   @OrderAllocationTemp 
      WHERE  allocate = 1 
      ORDER  BY [boxno] 

      ------------------------------------------------------------------------------------------------------------------------- 
      ------------------------------------------------------------------------------------------------------------------------- 
      DELETE FROM @OrderAllocationTemp 

      ------------------------------------------------------------------------------------------- 
      ------------------------------------------------------------------------------------------- 
      --Allocate DownGrade Selected Products with atleast 2 days life left but no greater than 7 
      ------------------------------------------------------------------------------------------- 
      INSERT INTO @OrderAllocationTemp 
      SELECT --HR.OrderNO,  
      Hr.group_order_no                AS [OrderNo], 
      HR.sub_order_no                  AS [SubOrderNo], 
      pk.productcode, 
      Isnull(col.palletnumber, ' ')    AS Pallet, 
      pk.sscc, 
      pk.siteid, 
      CASE 
        WHEN ( Round(HR.[ordered_qty], 0) - (SELECT Count(*) 
                                             FROM   hr_order_allocation OA2 with (nolock)
                                             WHERE  OA2.[hr_boxno] = HR.box_no 
                                                    AND [orderno] = @OrderNo 
                                                    AND suborderno = @OrderSubNo 
                                            ) 
             ) >= 
             Row_number() 
               OVER 
                    ( 
                    partition BY HR.box_no 
                    ORDER BY HR.box_no, Datediff("d", @Today, pk.useby)) THEN 1 
        ELSE 0 
      END                              AS Allocate, 
      Col.palletid                     AS PalletId, 
      pk.dnob                          AS DNOB, 
      pk.useby                         AS Useby, 
      HR.box_no, 
      Cast(HR.orderdate AS DATE)       AS OrderDate, 
      (SELECT Count(*) 
       FROM   stock_packs SP (nolock)
       WHERE  SP.palletid = pk.palletid 
              AND SP.dnob = Pk.dnob 
              AND SP.useby = pk.useby) AS qty 
      FROM   hr_order_summary_import AS HR 
             INNER JOIN [FFGSQL06].[FFGProductionPlan].[dbo].hr_product_subs AS 
                        HPS  with (nolock)
                     ON HR.box_no = HPS.boxno 
             CROSS apply [dbo].[Split](HPS.downgrades, ',') S 
             INNER JOIN stock_packs AS pk WITH (nolock) 
                     ON Cast(pk.productcode AS NVARCHAR(15)) = S.item 
             INNER JOIN products AS mat1 WITH (nolock) 
                     ON pk.productcode = mat1.productcode 
             INNER JOIN inventories AS pr WITH (nolock) 
                     ON pr.inventoryid = pk.inventoryid 
                        AND pk.siteid = pr.site 
             INNER JOIN 
             --had to put isnull with 9999 to collect packs that are not on pallets.  
             pallets AS col WITH (nolock) 
                     ON Isnull(pk.palletid, 9999) = Isnull(col.palletid, 9999) 
                        AND pk.siteid = col.siteid 
             LEFT OUTER JOIN productspecs AS PS WITH (nolock) 
                          ON mat1.productcode = ps.productcode 
             LEFT OUTER JOIN customerspecs AS con WITH (nolock) 
                          ON ps.specid = con.specid 
      WHERE  HR.box_no = @BoxNo 
             AND pk.siteid <> 4 
			 AND pk.SiteID <> 7 -- added by KH to remove FI stock getting allocated 21/03/18
             AND HR.group_order_no = @OrderNo 
             AND HR.[sub_order_no] = @OrderSubNo 
             AND mat1.storagetype = 1 
             AND NOT( pr.[site] = 1 
                      AND pr.[inventoryid] = '70' ) 
             AND NOT( pr.[site] = 3 
                      AND pr.[inventoryid] = '27' ) 
             AND NOT( pr.NAME LIKE '%Gran%' ) 
             AND pr.inventorytypeid = 1 
             AND ( pr.NAME <> 'Order Returns' 
                    OR pr.NAME <> 'Beef Returns' ) 
             AND pr.NAME <> 'Ready to Ship' 
             AND pr.NAME <> 'Stock on hold' 
             AND NOT ( pr.NAME LIKE '%QC%' ) 
             AND pr.NAME <> 'QC Stock' 
             AND pr.NAME <> 'QC Hold' 
             AND pr.NAME <> 'Chill D Floor' 
             AND ( Datediff("d", HR.delivery_date, pk.useby) > = 2 ) 
             AND ( Datediff("d", @Today, pk.useby) < = 7 ) 
             AND pk.dnob <= ( HR.delivery_date + 1 ) 
             AND pk.useby >= ( HR.delivery_date + 2 ) 
             AND Isnull(con.NAME, 'N/A') LIKE '%HILTON%' 
             AND ( HR.box_no IS NOT NULL 
                   AND Hr.product_name IS NOT NULL ) 
             AND Round(HR.[ordered_qty], 0) > 0 
             AND NOT( pk.siteid = 2 
                      AND pk.inventoryid = 17 ) 
             AND NOT EXISTS (SELECT * 
                             FROM   [FFG_DW].[dbo].[hr_order_allocation] oA3 with (nolock)
                             WHERE  oA3.boxno = pk.sscc 
                                    AND oA3.[siteid] = pk.siteid 
                                    AND oA3.orderdate = Cast( 
                                        HR.orderdate AS DATE) 
                            ) 
      ORDER  BY Datediff("d", @Today, pk.useby) ASC, 
                qty DESC, 
                HR.box_no, 
                pallet 

      -------------------------------------------------------------------------------------------------------------------------------------------- 

      SELECT [orderno], 
             [suborderno], 
             [productcode], 
             [palletno], 
             [boxno], 
             [siteid], 
             palletid, 
             dnob, 
             useby, 
             [hr_boxno], 
             orderdate, 
             @Modified, 
             0 
      FROM   @OrderAllocationTemp 
      WHERE  allocate = 1 
  ------------------------------------------------------------------------------------------------------------------------------------------------ 
  END 
GO
