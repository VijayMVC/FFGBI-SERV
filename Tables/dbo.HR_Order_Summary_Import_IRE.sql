CREATE TABLE [dbo].[HR_Order_Summary_Import_IRE]
(
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
[RowNo] [int] NOT NULL,
[AvgCaseWgt] [decimal] (18, 2) NULL,
[EstCases] [int] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HR_Order_Summary_Import_IRE_RowNo] ON [dbo].[HR_Order_Summary_Import_IRE] ([RowNo]) ON [PRIMARY]
GO
