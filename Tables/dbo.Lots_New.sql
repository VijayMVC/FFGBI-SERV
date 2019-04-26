CREATE TABLE [dbo].[Lots_New]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SlaughteredIn] [int] NOT NULL,
[CutIn] [int] NOT NULL,
[ProcessedIn] [int] NOT NULL,
[Age] [int] NOT NULL,
[Origin] [int] NOT NULL,
[Quality] [int] NOT NULL,
[ShowYeild] [int] NOT NULL,
[Processed] [varchar] (20) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lots_New] ADD CONSTRAINT [PK_Lots_New] PRIMARY KEY CLUSTERED  ([SlaughteredIn], [CutIn], [ProcessedIn], [Age], [Origin], [Quality]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
