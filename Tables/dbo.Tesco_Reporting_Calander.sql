CREATE TABLE [dbo].[Tesco_Reporting_Calander]
(
[Date] [date] NOT NULL,
[DateTo] [date] NOT NULL,
[WeekNo] [int] NOT NULL,
[Period] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Tesco_Reporting_Calander] ADD CONSTRAINT [PK_Tesco Reporting Calander] PRIMARY KEY CLUSTERED  ([Date], [DateTo], [WeekNo], [Period]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
