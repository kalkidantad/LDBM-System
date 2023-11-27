-- declare
declare bookscursor cursor
for select * from [Books Info]
--use
/*
open bookscursor

fetch next from bookscursor

while @@FETCH_STATUS=0 
fetch next from bookscursor

close bookscursor
*/
------------------------------------------------------------------------------------------------------------------
-- declare
declare Availablebookscursor cursor scroll
for select * from [Available Books Info]
--use
/*
open Availablebookscursor
fetch prior from Availablebookscursor
fetch absolute 30 from Availablebookscursor
fetch absolute 31 from Availablebookscursor

fetch relative 1 from Availablebookscursor

while @@FETCH_STATUS=0 
fetch next from Availablebookscursor

close  Availablebookscursor

*/
------------------------------------------------------------------------------------------------------------------
DECLARE @Auth_FirstName nvarchar(40)
DECLARE @Auth_LastName nvarchar(40)
DECLARE @Book_Title nvarchar(80)

DECLARE book_cursor CURSOR FOR
SELECT Auth_FirstName,ISNULL(Auth_LastName, 'UNKNOWN'), Book_Title 
FROM tblAuthor
INNER JOIN tblBook ON tblAuthor.Auth_ID=tblBook.Auth_ID
ORDER BY tblAuthor.Auth_FirstName

OPEN book_cursor

FETCH NEXT FROM book_cursor
INTO @Auth_FirstName,@Auth_LastName, @Book_Title

PRINT 'Author First Name' + CHAR(9) + 'Author Last Name' + CHAR(9) + 'Book Title'
PRINT '-----------------' + CHAR(9) + '----------------' + CHAR(9) + '----------'

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @Auth_FirstName + CHAR(9) + @Auth_LastName + CHAR(9) + @Book_Title

    FETCH NEXT FROM book_cursor
    INTO  @Auth_FirstName,@Auth_LastName, @Book_Title
END

CLOSE book_cursor
DEALLOCATE book_cursor

-----------------------------------------------------------------------------------------