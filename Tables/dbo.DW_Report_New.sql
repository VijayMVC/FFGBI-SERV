CREATE TABLE [dbo].[DW_Report_New]
(
[reportID] [uniqueidentifier] NOT NULL,
[reportNo] [bigint] NULL,
[ReportName] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ReportSource] [nvarchar] (200) COLLATE Latin1_General_CI_AS NULL,
[Folder] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[db] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Server] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL,
[Order] [int] NULL,
[Category] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Topic] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ReportType] [nvarchar] (10) COLLATE Latin1_General_CI_AS NULL,
[SubFolder] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[DefaultParameters] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ParentFolder] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DW_Report_New] ADD CONSTRAINT [PK_DW_Report_New] PRIMARY KEY CLUSTERED  ([reportID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
