CREATE TABLE [dbo].[Packxacts]
(
[ID] [int] NOT NULL,
[pack] [int] NOT NULL,
[xacttype] [smallint] NOT NULL,
[regtime] [datetime] NOT NULL,
[subjectid] [int] NULL,
[prday] [datetime] NULL
) ON [PRIMARY]
GO
