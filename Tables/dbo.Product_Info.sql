CREATE TABLE [dbo].[Product_Info]
(
[ProductCode] [bigint] NOT NULL,
[SalesTeamId] [bigint] NULL,
[UpdateNav] [bit] NULL,
[PricedCurrency] [nvarchar] (10) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Product_Info] ADD CONSTRAINT [PK_Product_Info] PRIMARY KEY CLUSTERED  ([ProductCode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
