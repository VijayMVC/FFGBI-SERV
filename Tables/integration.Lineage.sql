CREATE TABLE [integration].[Lineage]
(
[Lineage Key] [int] NOT NULL IDENTITY(1, 1),
[Data Load Started] [datetime2] NOT NULL,
[Table Name] [sys].[sysname] NOT NULL,
[Data Load Completed] [datetime2] NULL,
[Was Successful] [bit] NOT NULL,
[Source System Cutoff Time] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [integration].[Lineage] ADD CONSTRAINT [PK_Integration_Lineage] PRIMARY KEY CLUSTERED  ([Lineage Key]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Description', N'Details of data load attempts', 'SCHEMA', N'integration', 'TABLE', N'Lineage', NULL, NULL
GO
EXEC sp_addextendedproperty N'Description', N'Time when the data load attempt completed (successfully or not)', 'SCHEMA', N'integration', 'TABLE', N'Lineage', 'COLUMN', N'Data Load Completed'
GO
EXEC sp_addextendedproperty N'Description', N'Time when the data load attempt began', 'SCHEMA', N'integration', 'TABLE', N'Lineage', 'COLUMN', N'Data Load Started'
GO
EXEC sp_addextendedproperty N'Description', N'DW key for lineage data', 'SCHEMA', N'integration', 'TABLE', N'Lineage', 'COLUMN', N'Lineage Key'
GO
EXEC sp_addextendedproperty N'Description', N'Time that rows from the source system were loaded up until', 'SCHEMA', N'integration', 'TABLE', N'Lineage', 'COLUMN', N'Source System Cutoff Time'
GO
EXEC sp_addextendedproperty N'Description', N'Name of the table for this data load event', 'SCHEMA', N'integration', 'TABLE', N'Lineage', 'COLUMN', N'Table Name'
GO
EXEC sp_addextendedproperty N'Description', N'Was the attempt successful?', 'SCHEMA', N'integration', 'TABLE', N'Lineage', 'COLUMN', N'Was Successful'
GO
