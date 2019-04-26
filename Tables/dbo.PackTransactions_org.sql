CREATE TABLE [dbo].[PackTransactions_org]
(
[SiteID] [int] NOT NULL,
[TransactionID] [bigint] NOT NULL,
[PackID] [bigint] NOT NULL,
[Path] [bigint] NOT NULL,
[BatchNo] [bigint] NULL,
[Device] [bigint] NOT NULL,
[RegTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PackTransactions_org] ADD CONSTRAINT [PK_PackTransactions] PRIMARY KEY CLUSTERED  ([SiteID], [TransactionID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PackTransactions_org] ADD CONSTRAINT [FK_PackTransactions_Sites] FOREIGN KEY ([SiteID]) REFERENCES [dbo].[Sites] ([SiteID])
GO
