   --Scalar-Valued Functions--

-- Creating a Function for tblAuthor
CREATE FUNCTION dbo.GetAuthorName(@Auth_ID varchar(7))
RETURNS nvarchar(80)
AS
BEGIN
    DECLARE @AuthorName nvarchar(80);
    
    SELECT @AuthorName = ISNULL(Auth_FirstName, '') + ' ' + ISNULL(Auth_LastName, '')
    FROM tblAuthor
    WHERE Auth_ID = @Auth_ID;

    RETURN @AuthorName;
END;

--Creating a Function for tblBook
CREATE FUNCTION dbo.GetBookTitle(@Book_ID varchar(7))
RETURNS nvarchar(80)
AS
BEGIN
    DECLARE @BookTitle nvarchar(80);
    
    SELECT @BookTitle = Book_Title
    FROM tblBook
    WHERE Book_ID = @Book_ID;

    RETURN @BookTitle;
END;

--Creating a Function for tblGenre
CREATE FUNCTION dbo.GetGenreTitle(@Genre_ID varchar(7))
RETURNS nvarchar(20)
AS
BEGIN
    DECLARE @GenreTitle nvarchar(20);
    
    SELECT @GenreTitle = Genre_title
    FROM tblGenre
    WHERE Genre_ID = @Genre_ID;

    RETURN @GenreTitle;
END;

--Creating a Function for tblCopy
CREATE FUNCTION dbo.GetCopyNumber(@Copy_ID varchar(7))
RETURNS int
AS
BEGIN
    DECLARE @CopyNumber int;
    
    SELECT @CopyNumber = Copy_Number
    FROM tblCopy
    WHERE Copy_ID = @Copy_ID;

    RETURN @CopyNumber;
END;

--retrieve data
SELECT dbo.GetAuthorName('A_10');
SELECT dbo.GetBookTitle('B_1');
SELECT dbo.GetGenreTitle('G_1');
SELECT dbo.GetCopyNumber('C_1');