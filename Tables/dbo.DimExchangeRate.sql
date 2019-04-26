CREATE TABLE [dbo].[DimExchangeRate]
(
[DateKey] [int] NOT NULL,
[Currency Code] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Starting Date] [datetime] NOT NULL,
[Exchange Rate Amount] [decimal] (38, 20) NOT NULL,
[Adjustment Exch_ Rate Amount] [decimal] (38, 20) NOT NULL,
[Period Adjustment Exch_ Rate Amount] [decimal] (38, 20) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimExchangeRate] ADD CONSTRAINT [PK_DimExchangeRate] PRIMARY KEY CLUSTERED  ([DateKey]) ON [PRIMARY]
GO
