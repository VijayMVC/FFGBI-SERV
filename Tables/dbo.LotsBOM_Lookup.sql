CREATE TABLE [dbo].[LotsBOM_Lookup]
(
[Code] [bigint] NOT NULL,
[Name] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Age] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[Origin] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[Quality/Breed] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
GO
