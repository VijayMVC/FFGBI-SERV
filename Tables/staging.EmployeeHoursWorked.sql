CREATE TABLE [staging].[EmployeeHoursWorked]
(
[id] [int] NOT NULL,
[Employee_Id] [int] NOT NULL,
[Clock In] [datetime] NULL,
[Clock Out] [datetime] NULL,
[hours_worked] AS (datediff(second,[clock in],[clock out])/(3600.0)),
[DateKey] AS (CONVERT([int],CONVERT([varchar],[Clock In],(112)),(0)))
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [z_ndx_ci_emp_hours_worked] ON [staging].[EmployeeHoursWorked] ([id]) ON [PRIMARY]
GO
