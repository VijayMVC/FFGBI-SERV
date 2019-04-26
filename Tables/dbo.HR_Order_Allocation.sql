CREATE TABLE [dbo].[HR_Order_Allocation]
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
ALTER TABLE [dbo].[HR_Order_Allocation] ADD CONSTRAINT [PK_HR_Order_Allocation] PRIMARY KEY CLUSTERED  ([OrderNo], [SubOrderNo], [ProductCode], [PalletNo], [BoxNo], [SiteID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<boxnoSiteOrderdate, sysname,>] ON [dbo].[HR_Order_Allocation] ([BoxNo], [SiteID], [OrderDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HR_Order_Allocation_InProductionStock] ON [dbo].[HR_Order_Allocation] ([InProductionStock]) INCLUDE ([PalletNo]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HR_Order_Allocation_OrderDate] ON [dbo].[HR_Order_Allocation] ([OrderDate]) INCLUDE ([BoxNo], [DNOB], [HR_BoxNo], [InProductionStock], [Modified], [OrderNo], [PalletID], [PalletNo], [ProductCode], [SiteID], [SubOrderNo], [UseBy], [VIP]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HR_Order_Allocation_OrderNo_SiteID_HR_BoxNo] ON [dbo].[HR_Order_Allocation] ([OrderNo], [SiteID], [HR_BoxNo]) INCLUDE ([BoxNo], [DNOB], [InProductionStock], [PalletID], [PalletNo], [ProductCode], [SubOrderNo], [UseBy]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HR_Order_Allocation_PalletID] ON [dbo].[HR_Order_Allocation] ([PalletID]) INCLUDE ([BoxNo], [DNOB], [HR_BoxNo], [InProductionStock], [Modified], [OrderDate], [OrderNo], [PalletNo], [ProductCode], [SiteID], [SubOrderNo], [UseBy], [VIP]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HR_Order_Allocation_PalletNo] ON [dbo].[HR_Order_Allocation] ([PalletNo]) INCLUDE ([BoxNo], [DNOB], [HR_BoxNo], [InProductionStock], [Modified], [OrderDate], [OrderNo], [PalletID], [ProductCode], [SiteID], [SubOrderNo], [UseBy], [VIP]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HR_Order_Allocation_PalletNo_SiteID] ON [dbo].[HR_Order_Allocation] ([PalletNo], [SiteID]) INCLUDE ([BoxNo], [DNOB], [HR_BoxNo], [InProductionStock], [Modified], [OrderDate], [OrderNo], [PalletID], [ProductCode], [SubOrderNo], [UseBy], [VIP]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HR_Order_Allocation_SiteID_PalletID] ON [dbo].[HR_Order_Allocation] ([SiteID], [PalletID]) INCLUDE ([BoxNo], [DNOB], [HR_BoxNo], [InProductionStock], [Modified], [OrderDate], [OrderNo], [PalletNo], [ProductCode], [SubOrderNo], [UseBy], [VIP]) ON [PRIMARY]
GO
