CREATE TABLE [dbo].[HR_BoxNo_Wgts]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[BoxNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AvgCaseWgt] [decimal] (18, 2) NULL,
[FFGSite] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HR_BoxNo_Wgts] ADD CONSTRAINT [PK_HR_BoxNo_Wgts] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BoxNoIndex] ON [dbo].[HR_BoxNo_Wgts] ([BoxNo]) ON [PRIMARY]
GO
