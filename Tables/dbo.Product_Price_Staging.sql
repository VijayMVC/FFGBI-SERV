CREATE TABLE [dbo].[Product_Price_Staging]
(
[ProductCode] [bigint] NOT NULL,
[SiteID] [bigint] NOT NULL,
[Value] [real] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Product_Price_Staging] ADD CONSTRAINT [PK_Product_Price_Staging] PRIMARY KEY CLUSTERED  ([ProductCode], [SiteID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
