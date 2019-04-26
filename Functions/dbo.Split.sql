SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE FUNCTION [dbo].[Split] 
(   
    @s VARCHAR(max),
    @split CHAR(1)
)
RETURNS @temptable TABLE ([Item] VARCHAR(MAX))    
AS
BEGIN
    DECLARE @x XML

    SELECT @x = CONVERT(xml,'<root><s>' + REPLACE(@s,@split,'</s><s>') + '</s></root>');

    INSERT INTO @temptable          
    SELECT [Value] = T.c.value('.','varchar(20)')
    FROM @X.nodes('/root/s') T(c);
RETURN
END;
GO
