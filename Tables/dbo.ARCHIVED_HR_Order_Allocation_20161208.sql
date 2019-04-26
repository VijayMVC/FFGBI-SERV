CREATE TABLE [dbo].[ARCHIVED_HR_Order_Allocation_20161208]
(
[OrderNo] [bigint] NOT NULL,
[SubOrderNo] [int] NOT NULL,
[ProductCode] [nvarchar] (15) COLLATE Latin1_General_CI_AS NOT NULL,
[PalletNo] [bigint] NOT NULL,
[BoxNo] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[SiteID] [int] NOT NULL,
[PalletID] [bigint] NULL,
[DNOB] [datetime] NULL,
[UseBy] [datetime] NULL,
[InProductionStock] [int] NULL,
[HR_BoxNo] [nvarchar] (10) COLLATE Latin1_General_CI_AS NULL,
[OrderDate] [date] NULL,
[Modified] [int] NULL,
[VIP] [int] NULL
) ON [PRIMARY]
GO
