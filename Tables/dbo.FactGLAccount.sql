CREATE TABLE [dbo].[FactGLAccount]
(
[GLAccountKey] [bigint] NOT NULL IDENTITY(1, 1),
[DateKey] [int] NOT NULL,
[EntryKey] [int] NOT NULL,
[Amount] [decimal] (38, 20) NOT NULL,
[Debit Amount] [decimal] (38, 20) NOT NULL,
[Credit Amount] [decimal] (38, 20) NOT NULL,
[VAT Amount] [decimal] (38, 20) NOT NULL,
[Additional-Currency Amount] [decimal] (38, 20) NOT NULL,
[Lineage Key] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactGLAccount] ADD CONSTRAINT [PK_Fact_GLAccount] PRIMARY KEY CLUSTERED  ([GLAccountKey], [DateKey], [EntryKey]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactGLAccount] ADD CONSTRAINT [FK_FactGLAccount_DateKey_DimDate] FOREIGN KEY ([DateKey]) REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactGLAccount] ADD CONSTRAINT [FK_FactGLAccount_EntryKey_DimGlAccounts] FOREIGN KEY ([EntryKey]) REFERENCES [dbo].[DimGlAccounts] ([EntryKey])
GO
