CREATE TABLE [dbo].[Currency Exchange]
(
[SiteID] [bigint] NOT NULL,
[StartingDate] [datetime] NOT NULL,
[CurrencyCode] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[ExchangeRateAmount] [decimal] (38, 20) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Currency Exchange] ADD CONSTRAINT [PK_Currency Exchange] PRIMARY KEY CLUSTERED  ([SiteID], [StartingDate], [CurrencyCode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
