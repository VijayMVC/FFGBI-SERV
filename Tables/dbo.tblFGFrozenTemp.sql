CREATE TABLE [dbo].[tblFGFrozenTemp]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ProductCode] [bigint] NULL,
[FFGSite] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Cases] [int] NULL,
[Wgt] [decimal] (18, 2) NULL,
[Val] [decimal] (18, 2) NULL,
[LocationID] [int] NULL,
[Status] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Notes] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblFGFrozenTemp] ADD CONSTRAINT [PK_tblFGFrozenTemp_1] PRIMARY KEY CLUSTERED  ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblFGFrozenTemp] ADD CONSTRAINT [FK_tblFGFrozenTemp_Products] FOREIGN KEY ([ProductCode]) REFERENCES [dbo].[Products] ([ProductCode])
GO
ALTER TABLE [dbo].[tblFGFrozenTemp] ADD CONSTRAINT [FK_tblFGFrozenTemp_tblColdstore] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[tblColdstore] ([LocationID])
GO
