CREATE PROCEDURE sp_AlterTableColumn
    @tableName NVARCHAR(128),
    @columnName NVARCHAR(128),
    @dataType NVARCHAR(128)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'ALTER TABLE ' + QUOTENAME(@tableName) + 
               N' ALTER COLUMN ' + QUOTENAME(@columnName) + 
               N' ' + @dataType + ' COLLATE  Latin1_General_100_CI_AI';
    EXEC sp_executesql @sql;
END;
--drop procedure sp_AlterTableColumn

--for tblauthor
EXEC sp_AlterTableColumn 'tblAuthor', 'Auth_FirstName', 'NVARCHAR(40)';
EXEC sp_AlterTableColumn 'tblAuthor', 'Auth_LastName', 'NVARCHAR(40)';

--for tblBook
EXEC sp_AlterTableColumn 'tblBook', 'Book_Title', 'nvarchar(80)';
EXEC sp_AlterTableColumn 'tblBook', 'Publisher', 'nvarchar(70)';

--for tblGenre
EXEC sp_AlterTableColumn 'tblGenre', 'Genre_title', 'NVARCHAR(20)';

--for tblOnlineBook
EXEC sp_AlterTableColumn 'tblOnlineBook', 'Title', 'NVARCHAR(80)';

--for tblKeywords
EXEC sp_AlterTableColumn 'tblKeywords', 'Keywords', 'NVARCHAR(80)';
------------------------------------------------------------------------------------------------------------------
