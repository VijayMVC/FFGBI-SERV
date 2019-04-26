CREATE TABLE [dbo].[HR_Order_Summary_Import]
(
[RowNo] [int] NOT NULL,
[OrderDate] [datetime] NULL,
[Group_Order_No] [bigint] NULL,
[Delivery_Date] [datetime] NULL,
[Sub_Order_no] [int] NULL,
[Box_No] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Product_Name] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Ordered_Qty] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Confirmed_Qty] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Siteid] [nvarchar] (10) COLLATE Latin1_General_CI_AS NULL,
[Processed] [nvarchar] (2) COLLATE Latin1_General_CI_AS NULL,
[VIP] [int] NULL,
[Comments] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Modified] [int] NULL,
[Org_Ordered_Qty] [int] NULL,
[FO_Comments] [bit] NULL,
[FC_Comments] [bit] NULL,
[FD_Comments] [bit] NULL,
[FG_Comments] [bit] NULL,
[FH_Comments] [bit] NULL,
[FMM_Comments] [bit] NULL,
[Site_Comments] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Group_order_no, sysname,>] ON [dbo].[HR_Order_Summary_Import] ([Group_Order_No]) INCLUDE ([Box_No], [Product_Name]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HR_Order_Summary_Import_Group_Order_No_2] ON [dbo].[HR_Order_Summary_Import] ([Group_Order_No]) INCLUDE ([Box_No], [Confirmed_Qty], [Delivery_Date], [Modified], [OrderDate], [Ordered_Qty], [Org_Ordered_Qty], [Processed], [Product_Name], [RowNo], [Siteid], [Sub_Order_no], [VIP]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HR_Order_Summary_Import_Group_Order_No] ON [dbo].[HR_Order_Summary_Import] ([Group_Order_No]) INCLUDE ([Sub_Order_no]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HR_Order_Summary_Import_Group_Order_No_Sub_Order_no_2] ON [dbo].[HR_Order_Summary_Import] ([Group_Order_No], [Sub_Order_no]) INCLUDE ([Box_No], [Ordered_Qty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HR_Order_Summary_Import_Group_Order_No_Sub_Order_no] ON [dbo].[HR_Order_Summary_Import] ([Group_Order_No], [Sub_Order_no]) INCLUDE ([Box_No], [Product_Name]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HR_Order_Summary_Import_OrderDate_Siteid] ON [dbo].[HR_Order_Summary_Import] ([OrderDate], [Siteid]) ON [PRIMARY]
GO
