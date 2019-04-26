CREATE TABLE [dbo].[Hilton_Dispatch_Weight]
(
[Site] [int] NOT NULL,
[Date] [date] NOT NULL,
[TotalWeight] [real] NOT NULL,
[Weekno] [int] NULL,
[Period] [int] NULL,
[ProductType] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Hilton_Dispatch_Weight] ADD CONSTRAINT [PK_Hilton_Dispatch_Weight] PRIMARY KEY CLUSTERED  ([Site], [Date], [TotalWeight]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
