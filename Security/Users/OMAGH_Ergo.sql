IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'OMAGH\Ergo')
CREATE LOGIN [OMAGH\Ergo] FROM WINDOWS
GO
CREATE USER [OMAGH\Ergo] FOR LOGIN [OMAGH\Ergo]
GO
