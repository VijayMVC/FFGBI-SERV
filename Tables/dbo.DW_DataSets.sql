CREATE TABLE [dbo].[DW_DataSets]
(
[DatasetID] [bigint] NOT NULL,
[SP_Name] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DW_DataSets] ADD CONSTRAINT [PK_DataSets] PRIMARY KEY CLUSTERED  ([DatasetID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
