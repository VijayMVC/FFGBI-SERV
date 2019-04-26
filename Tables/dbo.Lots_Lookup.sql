CREATE TABLE [dbo].[Lots_Lookup]
(
[SlaughteredIn] [nvarchar] (80) COLLATE Latin1_General_CI_AS NOT NULL,
[CutIn] [nvarchar] (80) COLLATE Latin1_General_CI_AS NOT NULL,
[ProcessedIn] [nvarchar] (80) COLLATE Latin1_General_CI_AS NOT NULL,
[Origin] [nvarchar] (80) COLLATE Latin1_General_CI_AS NOT NULL,
[Description1] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Description7] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Description8] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
