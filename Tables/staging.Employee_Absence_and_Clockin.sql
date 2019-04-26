CREATE TABLE [staging].[Employee_Absence_and_Clockin]
(
[Employee_Id] [int] NOT NULL,
[Assignment_date] [date] NOT NULL,
[Clock In] [datetime] NULL,
[Clock Out] [datetime] NULL,
[absence_reason] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[staff_employed] [bit] NULL,
[staff_present] [bit] NULL,
[absence_type] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[worked_minutes] [int] NULL,
[overtime_minutes] [int] NULL
) ON [PRIMARY]
GO
