CREATE TABLE [dbo].[DW_BoningProductType_ByLot]
(
[SiteID] [int] NOT NULL,
[PrDay] [datetime] NOT NULL,
[LotCode] [nvarchar] (15) COLLATE Latin1_General_CI_AS NOT NULL,
[MaterialTypeID] [bigint] NULL,
[MaterialType] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Qty] [bigint] NULL,
[Weight] [decimal] (18, 3) NULL,
[Pieces] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DW_BoningProductType_ByLot] ADD CONSTRAINT [PK_DW_BoningProductType_ByLot] PRIMARY KEY CLUSTERED  ([SiteID], [PrDay], [LotCode], [MaterialType]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
