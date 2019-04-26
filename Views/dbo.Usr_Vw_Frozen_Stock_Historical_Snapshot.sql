SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[Usr_Vw_Frozen_Stock_Historical_Snapshot]
AS


SELECT  

 ds.[Date]
      ,DATEPART(wk,[Date]) AS 'Week'
	  ,DATEPART(YYYY,[Date]) AS'Year'
	  , CASE WHEN DATENAME(DW,[date])='Monday'
	  THEN '1-Monday'
	  WHEN DATENAME(DW,[date])='Tuesday'
	  THEN '2-Tuesday'
	  WHEN DATENAME(DW,[date])='Wednesday'
	  THEN '3-Wednesday'
	  WHEN DATENAME(DW,[date])='Thursday'
	  THEN '4-Thursday'
	  WHEN DATENAME(DW,[date])='Friday'
	  THEN '5-Friday'
	  WHEN DATENAME(DW,[date])='Saturday'
	  THEN '6-Saturday'
	  WHEN DATENAME(DW,[date])='Sunday'
	  THEN '7-Sunday'
	  END AS [Day]
	

	  ,CASE WHEN  s.[name]='FFG Group Site for Pricing'
	  THEN'Foyle Ingredients'
	  ELSE s.[name]
	  END AS [name]
	
	  
	-- ,case when DATEPART(wk,[Date])=DATEPART(wk,GETDATE()-14) 
	--and DATENAME(DW,[date])='Friday'  
	-- and DATEPART(YYYY,[Date])=DATEPART(yyyy,GETDATE()) 
	
	--  then  round(Sum([CovertedTotalValue]),2)
	--  end as [Previous Week £]

	--  ,case when DATEPART(wk,[Date])=DATEPART(wk,GETDATE()-14) 
	--and DATENAME(DW,[date])='Friday'  
	-- and DATEPART(YYYY,[Date])=DATEPART(yyyy,GETDATE()) 
	
	--  then  Sum([Total])
	--  end as [Previous Week KG]

	   ,CASE WHEN  DATEPART(dd,[Date])=DATEPART(dd,GETDATE()-2) AND DATEPART(YYYY,[Date])=DATEPART(yyyy,GETDATE()) AND DATEPART(M,[Date])=DATEPART(M,GETDATE())
	  THEN  ROUND(SUM([CovertedTotalValue]),2)
	  END AS [Previous Day £]

	  ,CASE WHEN  DATEPART(dd,[Date])=DATEPART(dd,GETDATE()-2)   AND DATEPART(YYYY,[Date])=DATEPART(yyyy,GETDATE()) AND DATEPART(M,[Date])=DATEPART(M,GETDATE())
	  THEN  SUM([Total])
	  END AS [Previous Day KG]



	 -- ,case when DATEPART(wk,[Date])=DATEPART(wk,GETDATE()-7) and DATENAME(DW,[date])='Friday'  and DATEPART(YYYY,[Date])=DATEPART(yyyy,GETDATE()) and DATEPART(M,[Date])=DATEPART(M,GETDATE())
	 -- then  round(Sum([CovertedTotalValue]),2)
	 --end as [Current Week £]


	 -- ,case when DATEPART(wk,[Date])=DATEPART(wk,GETDATE()-7) and DATENAME(DW,[date])='Friday'  and DATEPART(YYYY,[Date])=DATEPART(yyyy,GETDATE()) and DATEPART(M,[Date])=DATEPART(M,GETDATE())
	 -- then  Sum([Total])
	 -- end as [Current Week KG]

	   ,CASE WHEN DATEPART(dd,[Date])=DATEPART(dd,GETDATE()-1)  AND DATEPART(YYYY,[Date])=DATEPART(yyyy,GETDATE()) AND DATEPART(M,[Date])=DATEPART(M,GETDATE())
	  THEN  ROUND(SUM([CovertedTotalValue]),2)
	 END AS [Current Day £]


	  ,CASE WHEN DATEPART(dd,[Date])=DATEPART(dd,GETDATE()-1)  AND DATEPART(YYYY,[Date])=DATEPART(yyyy,GETDATE()) AND DATEPART(M,[Date])=DATEPART(M,GETDATE())
	  THEN  SUM([Total])
	  END AS [Current Day KG]

--------------------------------------------------------------------------------------------------------------------
	  ,CASE WHEN DATEDIFF(DAY,date,GETDATE()) BETWEEN 8 AND 14 AND DATENAME(DW,[date])='Sunday'
	  THEN  ROUND(SUM([CovertedTotalValue]),2)
	  END AS [Previous Week £]

	  ,CASE WHEN DATEDIFF(DAY,date,GETDATE()) BETWEEN 8 AND 14 AND DATENAME(DW,[date])='Sunday'
	  THEN  SUM([Total])
	  END AS [Previous Week KG]

	  ,CASE WHEN DATEDIFF(DAY,date,GETDATE()) BETWEEN 0 AND 7 AND DATENAME(DW,[date])='Sunday'
	  THEN  ROUND(SUM([CovertedTotalValue]),2)
	 END AS [Current Week £]

	 , CASE WHEN DATEDIFF(DAY,date,GETDATE()) BETWEEN 0 AND 7 AND DATENAME(DW,[date])='Sunday'
	  THEN  SUM([Total])
	  END AS [Current Week KG]

	,DATEDIFF(d,date,GETDATE()) AS Days

	
	  


	  ,ds.ProductCode
      ,SUM([Total]) AS 'Total Weight'
	  ,MAX([Regtime]) 'Time'
      ,ROUND(SUM([CovertedTotalValue]),2)AS'Total Value GBP'
	
	  ,p.[Conservation_Name]
	  ,p.Name AS [Product Name]
	
	,GETDATE() AS [Max Date]
	  
  FROM [FFG_DW].[dbo].[Group_Frozen_Stock_Snapshot_daily] ds
  LEFT OUTER JOIN [FFG_DW].[dbo].[Products] p ON ds.ProductCode=p.ProductCode
  LEFT OUTER JOIN [FFG_DW].[dbo].[Sites] s ON ds.[siteid] =s.[siteid]
  WHERE p.[Conservation_Name] IS  NOT NULL
  AND DATEPART(YYYY,[Date])>=2016
  GROUP BY 
   p.[Conservation_Name]
   ,ds.[Date]
 ,s.[name]
  ,ds.ProductCode
  ,p.Name





GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ds"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 136
               Right = 497
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'Usr_Vw_Frozen_Stock_Historical_Snapshot', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Usr_Vw_Frozen_Stock_Historical_Snapshot', NULL, NULL
GO
