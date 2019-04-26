CREATE TABLE [dbo].[Z_Usr_NetCost]
(
[Site Dimension] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[factory] [int] NULL,
[Sex] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[Cold Weight (KG)] [numeric] (38, 20) NULL,
[Net Cost] [numeric] (38, 6) NULL,
[Order] [varchar] (12) COLLATE Latin1_General_CI_AS NULL,
[Totally Condemed] [tinyint] NULL,
[Own Kill] [tinyint] NULL,
[Posting Date] [datetime] NULL
) ON [PRIMARY]
GO
