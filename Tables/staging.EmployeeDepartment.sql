CREATE TABLE [staging].[EmployeeDepartment]
(
[department_id] [int] NOT NULL,
[department_code] [nvarchar] (8) COLLATE Latin1_General_CI_AS NOT NULL,
[department_name] [nvarchar] (60) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
GO
