CREATE TABLE [dbo].[Hilton_Dispatch_Weight_ALL]
(
[Site] [int] NOT NULL,
[Date] [date] NOT NULL,
[TotalWeight] [real] NOT NULL,
[Weekno] [int] NULL,
[Period] [int] NULL,
[ProductType] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[CustomerNo] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Hilton_Dispatch_Weight_ALL] ADD CONSTRAINT [PK_Hilton_Dispatch_Weight_ALL] PRIMARY KEY CLUSTERED  ([Site], [Date], [TotalWeight]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
