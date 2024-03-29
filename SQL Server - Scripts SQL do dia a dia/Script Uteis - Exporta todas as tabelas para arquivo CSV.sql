DECLARE @TABLE_NAME nvarchar(50)
DECLARE @TABLE_SCHEMA nvarchar(50)
DECLARE @TABLE_CATALOG nvarchar(50)
DECLARE db_for CURSOR FOR

	select top 3 TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME from INFORMATION_SCHEMA.TABLES
	where TABLE_TYPE = 'BASE TABLE'

OPEN db_for 
FETCH NEXT FROM db_for INTO @TABLE_CATALOG, @TABLE_SCHEMA,@TABLE_NAME

WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE @OutputFilePath nvarchar(max); 
DECLARE @ExportSQL nvarchar(max); 


SET @OutputFilePath = 'C:\temp'

SET @ExportSQL = N'EXEC master.dbo.xp_cmdshell ''bcp "SELECT * FROM '+@TABLE_CATALOG+'.'+@TABLE_SCHEMA+'.'+@TABLE_NAME+'" queryout "'+ @OutputFilePath + '\'+@TABLE_CATALOG+'_'+@TABLE_SCHEMA+'_'+@TABLE_NAME+'.csv" -T -c -t -S LOCALHOST'''

print @ExportSQL

EXEC(@ExportSQL)

	FETCH NEXT FROM db_for INTO  @TABLE_CATALOG, @TABLE_SCHEMA,@TABLE_NAME

END

CLOSE db_for
DEALLOCATE db_for

/*
-- this turns on advanced options and is needed to configure xp_cmdshell
EXEC sp_configure 'show advanced options', '1'
RECONFIGURE
-- this enables xp_cmdshell
EXEC sp_configure 'xp_cmdshell', '1' 
RECONFIGURE
*/