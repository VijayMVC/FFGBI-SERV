CREATE TABLE [dbo].[Stock_Packs_staging]
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
[FixedCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Stock_Packs_staging] ADD CONSTRAINT [PK_Stock_Packs_staging] PRIMARY KEY CLUSTERED  ([ID], [SiteID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Stock_Packs_staging] ADD CONSTRAINT [FK_Stock_Packs_Staging_Sites] FOREIGN KEY ([SiteID]) REFERENCES [dbo].[Sites] ([SiteID])
GO
