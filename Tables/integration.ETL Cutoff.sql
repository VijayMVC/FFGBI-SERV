CREATE TABLE [integration].[ETL Cutoff]
(
[Table Name] [sys].[sysname] NOT NULL,
[Cutoff Time] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [integration].[ETL Cutoff] ADD CONSTRAINT [PK_Integration_ETL_Cutoff] PRIMARY KEY CLUSTERED  ([Table Name]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Description', N'ETL Cutoff Times', 'SCHEMA', N'integration', 'TABLE', N'ETL Cutoff', NULL, NULL
GO
EXEC sp_addextendedproperty N'Description', N'Time up to which data has been loaded', 'SCHEMA', N'integration', 'TABLE', N'ETL Cutoff', 'COLUMN', N'Cutoff Time'
GO
EXEC sp_addextendedproperty N'Description', N'Table name', 'SCHEMA', N'integration', 'TABLE', N'ETL Cutoff', 'COLUMN', N'Table Name'
GO
