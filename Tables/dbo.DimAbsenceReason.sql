CREATE TABLE [dbo].[DimAbsenceReason]
(
[AbsenceReasonKey] [int] NOT NULL,
[Absence_Ref_Id] [int] NOT NULL,
[Absence Reason] [varchar] (60) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimAbsenceReason] ADD CONSTRAINT [PK_DimAbsenceReason] PRIMARY KEY CLUSTERED  ([AbsenceReasonKey]) ON [PRIMARY]
GO
