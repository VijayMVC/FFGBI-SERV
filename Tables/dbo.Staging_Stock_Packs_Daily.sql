CREATE TABLE [dbo].[Staging_Stock_Packs_Daily]
(
[ID] [bigint] NOT NULL,
[SiteID] [bigint] NOT NULL,
[SSCC] [nvarchar] (18) COLLATE Latin1_General_CI_AS NULL,
[BatchNo] [int] NULL,
[LotID] [bigint] NULL,
[DeviceID] [bigint] NULL,
[PRDay] [smalldatetime] NULL,
[UseBy] [smalldatetime] NULL,
[KillDate] [smalldatetime] NULL,
[DNOB] [smalldatetime] NULL,
[InventoryID] [bigint] NULL,
[InventoryLocationID] [bigint] NULL,
[PalletID] [bigint] NULL,
[ProductCode] [bigint] NULL,
[PackagingTypeID] [bigint] NULL,
[Weight] [real] NULL,
[GrossWeight] [real] NULL,
[Tare] [real] NULL,
[Pieces] [int] NULL,
[Regtime] [date] NULL,
[OrgSite] [int] NULL,
[Stock] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[RType] [smallint] NULL,
[Invtime] [smalldatetime] NULL,
[Productnum] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Staging_Stock_Packs_Daily] ADD CONSTRAINT [PK_Staging_Stock_Packs_daily] PRIMARY KEY CLUSTERED  ([ID], [SiteID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
