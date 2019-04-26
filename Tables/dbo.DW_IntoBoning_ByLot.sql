CREATE TABLE [dbo].[DW_IntoBoning_ByLot]
(
[SiteID] [int] NOT NULL,
[BoningDate] [datetime] NOT NULL,
[BoningLot] [nvarchar] (15) COLLATE Latin1_General_CI_AS NOT NULL,
[Code] [nvarchar] (15) COLLATE Latin1_General_CI_AS NOT NULL,
[Name] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[QtrType] [nvarchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Qty] [int] NULL,
[Weight] [decimal] (18, 3) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DW_IntoBoning_ByLot] ADD CONSTRAINT [PK_DW_IntoBoning_ByLot] PRIMARY KEY CLUSTERED  ([SiteID], [BoningDate], [BoningLot], [Code], [QtrType]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
