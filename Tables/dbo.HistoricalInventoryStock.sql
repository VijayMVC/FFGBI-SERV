CREATE TABLE [dbo].[HistoricalInventoryStock]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Date] [datetime] NULL,
[Site] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProductCode] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ProductName] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ConservationName] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[CustomerName] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[UseBy] [datetime] NULL,
[ProductionDay] [datetime] NULL,
[PostingGroup] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Packs] [int] NULL,
[DaysInStock] [int] NULL,
[AgeGroups] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Weight(KG)] [decimal] (18, 2) NULL,
[StockPrice] [decimal] (18, 10) NULL,
[InventoryLocation] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[CurrencyCode] [decimal] (18, 10) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HistoricalInventoryStock] ADD CONSTRAINT [PK_HistoricalInventoryStock] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
