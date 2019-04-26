CREATE TABLE [dbo].[Orders]
(
[order] [int] NULL,
[code] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[name] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[shname] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[description1] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[description2] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[active] [bit] NULL,
[customer] [int] NULL,
[transferstatus] [smallint] NULL,
[orderstatus] [smallint] NULL,
[begtime] [datetime] NULL,
[endtime] [datetime] NULL,
[dispatchtime] [datetime] NULL
) ON [PRIMARY]
GO
