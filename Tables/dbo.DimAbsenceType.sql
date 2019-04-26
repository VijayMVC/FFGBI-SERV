CREATE TABLE [dbo].[DimAbsenceType]
(
[AbsenceTypeKey] [int] NOT NULL,
[Absence Type] [varchar] (60) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimAbsenceType] ADD CONSTRAINT [PK_DimAbsenceType] PRIMARY KEY CLUSTERED  ([AbsenceTypeKey]) ON [PRIMARY]
GO
