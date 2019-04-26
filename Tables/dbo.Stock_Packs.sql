CREATE TABLE [dbo].[Stock_Packs]
(
[ID] [bigint] NOT NULL,
[SiteID] [int] NOT NULL,
[SSCC] [nvarchar] (18) COLLATE Latin1_General_CI_AS NOT NULL,
[BatchNo] [int] NULL,
[LotID] [bigint] NOT NULL,
[DeviceID] [bigint] NOT NULL,
[PRDay] [smalldatetime] NOT NULL,
[UseBy] [smalldatetime] NULL,
[KillDate] [smalldatetime] NULL,
[DNOB] [smalldatetime] NULL,
[InventoryID] [bigint] NOT NULL,
[InventoryLocationID] [bigint] NULL,
[PalletID] [bigint] NULL,
[ProductCode] [bigint] NOT NULL,
[PackagingTypeID] [bigint] NULL,
[Weight] [real] NOT NULL,
[GrossWeight] [real] NOT NULL,
[Tare] [real] NULL,
[Pieces] [int] NULL,
[Regtime] [datetime] NULL,
[OrgSite] [int] NOT NULL,
[rtype] [smallint] NOT NULL,
[Invtime] [smalldatetime] NULL,
[Productnum] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FixedCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Stock_Packs] ADD CONSTRAINT [PK_Stock_Packs] PRIMARY KEY CLUSTERED  ([ID], [SiteID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PackId] ON [dbo].[Stock_Packs] ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<Product_code_IX, sysname,>] ON [dbo].[Stock_Packs] ([ProductCode]) INCLUDE ([DeviceID], [DNOB], [InventoryID], [KillDate], [LotID], [OrgSite], [PalletID], [PRDay], [SiteID], [Tare], [UseBy], [Weight]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_StockPack_ProductCode_Jason] ON [dbo].[Stock_Packs] ([ProductCode]) INCLUDE ([Pieces]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Stock_Packs_SiteID] ON [dbo].[Stock_Packs] ([SiteID]) INCLUDE ([DeviceID], [ID], [InventoryID], [InventoryLocationID], [PalletID], [rtype], [Weight]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Stock_Packs_SiteID_2] ON [dbo].[Stock_Packs] ([SiteID]) INCLUDE ([BatchNo], [DeviceID], [DNOB], [GrossWeight], [ID], [InventoryID], [InventoryLocationID], [Invtime], [KillDate], [LotID], [OrgSite], [PackagingTypeID], [PalletID], [Pieces], [PRDay], [ProductCode], [Regtime], [rtype], [SSCC], [Tare], [UseBy], [Weight]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Stock_Packs_SiteIDNEW] ON [dbo].[Stock_Packs] ([SiteID]) INCLUDE ([BatchNo], [DeviceID], [DNOB], [GrossWeight], [ID], [InventoryID], [InventoryLocationID], [KillDate], [LotID], [OrgSite], [PackagingTypeID], [PalletID], [Pieces], [PRDay], [ProductCode], [Regtime], [rtype], [SSCC], [Tare], [UseBy], [Weight]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<Stock_packs_Siteid, Siteid,>] ON [dbo].[Stock_Packs] ([SiteID]) INCLUDE ([DNOB], [InventoryID], [PalletID], [ProductCode], [SSCC], [UseBy]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Stock_Packs_SiteID_InventoryID] ON [dbo].[Stock_Packs] ([SiteID], [InventoryID]) INCLUDE ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Stock_Packs_SiteID_InventoryID_2] ON [dbo].[Stock_Packs] ([SiteID], [InventoryID]) INCLUDE ([ProductCode], [Weight]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Stock_Packs_SiteID_Productnum_Weight] ON [dbo].[Stock_Packs] ([SiteID], [Productnum], [Weight]) INCLUDE ([DeviceID], [DNOB], [InventoryID], [InventoryLocationID], [KillDate], [LotID], [OrgSite], [PalletID], [PRDay], [ProductCode], [SSCC], [Tare], [UseBy]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Stock_Packs_SiteID_rtype] ON [dbo].[Stock_Packs] ([SiteID], [rtype]) INCLUDE ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [dbo].[Stock_Packs] ([SSCC]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<UsebyDNOB,PALLET, sysname,>] ON [dbo].[Stock_Packs] ([UseBy], [DNOB], [PalletID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Stock_Packs] ADD CONSTRAINT [FK_Stock_Packs_Sites] FOREIGN KEY ([SiteID]) REFERENCES [dbo].[Sites] ([SiteID])
GO
