CREATE TABLE [dbo].[Product_Price]
(
[ProductCode] [bigint] NOT NULL,
[SiteID] [bigint] NOT NULL,
[Value] [real] NULL,
[ValueFrom] [date] NOT NULL,
[ValueTo] [date] NOT NULL,
[EuroValue] [real] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Product_Price] ADD CONSTRAINT [PK_Product_Price_1] PRIMARY KEY CLUSTERED  ([ProductCode], [SiteID], [ValueFrom], [ValueTo]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Product_Price_ProductCode_ValueTo] ON [dbo].[Product_Price] ([ProductCode], [ValueTo]) INCLUDE ([Value]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_FrozenStockBySite_jason] ON [dbo].[Product_Price] ([SiteID], [ValueFrom], [ValueTo]) INCLUDE ([ProductCode], [Value]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
