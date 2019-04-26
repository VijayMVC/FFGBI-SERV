CREATE TABLE [dbo].[Reports_Log]
(
[reportLogID] [uniqueidentifier] NOT NULL,
[reportID] [uniqueidentifier] NOT NULL,
[Username] [nvarchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[Runtime] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reports_Log] ADD CONSTRAINT [PK_ReportLog] PRIMARY KEY CLUSTERED  ([reportLogID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
