CREATE TABLE [dbo].[Granville_Stock_Temp]
(
[ID] [bigint] NOT NULL,
[SiteID] [int] NOT NULL,
[SSCC] [nvarchar] (18) COLLATE Latin1_General_CI_AS NULL,
[BatchNo] [int] NULL,
[LotID] [bigint] NULL,
[DeviceID] [bigint] NULL,
[PRDay] [smalldatetime] NULL,
[Useby] [smalldatetime] NULL,
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
[Regtime] [datetime] NULL,
[OrgSite] [int] NULL,
[rtype] [smallint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Granville_Stock_Temp] ADD CONSTRAINT [PK_Granville_Stock_Temp] PRIMARY KEY CLUSTERED  ([ID], [SiteID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
