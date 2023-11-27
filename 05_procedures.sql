--Procedures

/* 1 */----------------------------------------------------------------------------------------------------------------------------
--this procedure fetched data from view [Books Info]
--drop procedure PhysicalBooks
create procedure sp_PhysicalBooks
as
BEGIN
 select * 
 from [Books Info]
END;

--exec sp_PhysicalBooks;

/* 2 */----------------------------------------------------------------------------------------------------------------------------
--this procedure fetched data from view [Available Books Info]
--drop procedure AvailableBooks

create procedure sp_AvailableBooks
as
BEGIN
 select * 
 from [Available Books Info];
END;

--exec sp_AvailableBooks;

/* 3 */----------------------------------------------------------------------------------------------------------------------------new
--this procedure fetched data from view [Available Books Info]
--drop procedure sp_AvailableBooksSearch

create procedure sp_AvailableBooksSearch
@value nvarchar(150)
as
BEGIN
 select Book_ID, Book_Title,edition, Author,Shelf,floor_number
 from [Available Books Info]
 where Book_Title like @value
END;

--exec sp_AvailableBooksSearch  'All the Bright places';

/* 4 */----------------------------------------------------------------------------------------------------------------------------
--this procedure fetched data from view [Books Info] with language condition that recieves value and stores it in @lang variable
--drop procedure BookByLanguage

CREATE PROCEDURE sp_BookByLanguage @lang nvarchar(20)
as
BEGIN
 select * 
 from [Books Info]
 WHERE lang = @lang;
END;

--exec sp_BookByLanguage 'English';
--exec sp_BookByLanguage 'Amharic';
/* 5 */----------------------------------------------------------------------------------------------------------------------------
--this procedure fetched data from view [Online Books info]
--drop procedure OnlineBooks

create procedure sp_OnlineBooks
as
BEGIN
 select * 
 from [Online Books info]
END;

--exec sp_OnlineBooks;

/* 6 */----------------------------------------------------------------------------------------------------------------------------
--this procedure fetched data from view [Online Books info]
--drop procedure UsersInfo
create procedure sp_UsersInfo
as
BEGIN
 select * 
 from [User Info]
END;

--exec sp_UsersInfo;

/* 7 */----------------------------------------------------------------------------------------------------------------------------
--this procedure fetched data from view [Online Books Access]
--drop procedure OB_Access
create procedure sp_ObAccess
as
BEGIN
 select * 
 from [Online Books Access]
END;

--exec sp_ObAccess;

/* 8 */----------------------------------------------------------------------------------------------------------------------------
--this procedure fetched data from view [Borrowed Info]
--drop procedure BorrowList
create procedure sp_BorrowList
as
BEGIN
 select * 
 from [Borrowed Info]
END;

--exec sp_BorrowList;

/* 9 */----------------------------------------------------------------------------------------------------------------------------

-- this procedure finds total number of books in the library by language
--drop procedure sp_TotalBooks

create procedure sp_TotalBooksByLang
@lang nvarchar(20)
as
BEGIN
SELECT COUNT(Copy_Id) as Number_Of_books
FROM [Books Info]
where lang = @lang
END;
--exec sp_TotalBooksByLang @lang ='Amharic';
--exec sp_TotalBooksByLang @lang ='English';

/* 10 */----------------------------------------------------------------------------------------------------------------------------
-- a procedure that finds total number of users who acess online books
--drop procedure TotalAcessUsers

CREATE PROCEDURE sp_TotalAccessUsers
AS
BEGIN
    SELECT COUNT([USER_ID]) as Number_Of_users
FROM [Online Books Access];
END;

--EXEC sp_TotalAccessUsers;

/* 11 */----------------------------------------------------------------------------------------------------------------------------
-- this procedure finds how many users accessed a single book
--drop procedure count_book_access

CREATE PROCEDURE sp_CountOBookAccess
AS
BEGIN
    SELECT  Title, COUNT(User_ID) AS UserCount
    FROM [Online Books Access]
    GROUP BY ROLLUP (Title);
END;

--exec sp_CountOBookAccess;

/* 12 */----------------------------------------------------------------------------------------------------------------------------
--this procedure finds top most accessed book  and recieved an int as number of rows to display
--drop procedure sp_MostAccessedOnlineBook

CREATE PROCEDURE sp_MostAccessedOnlineBook @value INT
AS
BEGIN
    SELECT TOP (@value) Online_BookID, Title, UserCount
    FROM (
        SELECT Online_BookID,Title, COUNT(User_ID) AS UserCount
        FROM [Online Books Access]
        GROUP BY Online_BookID,Title
    ) AS BookAccessCounts
    ORDER BY UserCount DESC;
END;

--exec sp_MostAccessedOnlineBook 5;
/* 13 */----------------------------------------------------------------------------------------------------------------------------

-- this procedure finds book information by author name
--drop procedure sp_FindBookByAuthor

CREATE PROCEDURE sp_FindBookByAuthor @Author nvarchar(80)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [Books Info] WHERE Author LIKE @Author)
    BEGIN
        SELECT 'Error' AS Type, 'Author not found' AS Message;
        RETURN;
    END;

    SELECT Book_ID, Book_Title, Author, Genre_title, Copy_Number, published_year, Shelf, floor_number
    FROM [Books Info]
    WHERE Author LIKE @Author;
END;

--EXEC sp_FindBookByAuthor @Author = N'ዘነበ%';
--EXEC sp_FindBookByAuthor @Author = 'Thomas%';
-- error  EXEC sp_FindBookByAuthor 'J.K. Rowling';

/* 14 */----------------------------------------------------------------------------------------------------------------------------

-- this procedure finds book information by book title
--drop procedure Find_book_by_Title

create Procedure  sp_FindBookByTitle
@title nvarchar(80)
as
BEGIN
select Book_ID,Book_Title,Author,Genre_title,Copy_Number,published_year, Shelf, floor_number
from [Books Info]
where Book_Title like @title
END;

--EXEC sp_FindBookByTitle @title = 'rich dad poor dad%';
--EXEC sp_FindBookByTitle @title = N'ፍቅር እስከ%';

/* 15 */----------------------------------------------------------------------------------------------------------------------------
-- this procedure finds book information by Genre
--drop procedure Find_book_by_Genre
create Procedure sp_FindBookByGenre 
@Genre nvarchar(20)
as
BEGIN
select Book_ID,Book_Title,Author,Genre_title,Copy_Number,published_year, Shelf, floor_number
from [Books Info]
where Genre_title like @Genre
END;

--EXEC sp_FindBookByGenre @Genre = N'ልብወለድ';
--EXEC sp_FindBookByGenre @Genre = 'Education';

/* 16 */----------------------------------------------------------------------------------------------------------------------------
-- a procedure that finds Online Book By Keyword

--drop procedure sp_FindOnlineBookByKeyword
CREATE PROCEDURE sp_FindOnlineBookByKeyword @Keyword nvarchar(80)
AS
BEGIN
    SELECT Online_BookID as ID,Title, Edition, Published_Year, file_type, No_of_pages, Lang
    FROM [Online Books info]
    WHERE Keywords LIKE '%' + @Keyword + '%';
END;

--EXEC sp_FindOnlineBookByKeyword @Keyword = N'ዶክተር';
--EXEC sp_FindOnlineBookByKeyword @Keyword = asteroid;
/* 17 */----------------------------------------------------------------------------------------------------------------------------
-- this procedure finds a book information based on date differencs/range it recieves date one and stores it in @date 1 and the second date in date 2 and uses the condition between to find the date between.
--drop procedure Find_book_by_Published_year

create Procedure sp_FindBookByPublishedYear
@date1 date, 
@date2 date
as
BEGIN
select Book_ID,Book_Title,Author,Genre_title,Copy_Number,published_year, Shelf, floor_number
from [Books Info]
where published_year between @date1 and @date2
order by published_year
END;

--EXEC sp_FindBookByPublishedYear '2015-01-23', '2018-09-11';

/* 18 */----------------------------------------------------------------------------------------------------------------------------changed

--  a procedure that inserts data into table users
--staff
--drop procedure sp_InsertLibraryUser
CREATE PROCEDURE sp_InsertLibraryUser 
    @User_ID varchar(7), 
    @LibUser_firstName nvarchar(60),
    @LibUser_lastName nvarchar(60),
    @LibUser_gender char(1),
    @LibUser_age int,
    @LibUser_Subcity varchar(15),
    @LibUser_Woreda int,
    @LibUser_Kebele int,
    @UserPhone varchar(30),
    @UserEmail varchar(30)
AS
BEGIN
    BEGIN TRY
        -- Check if the values entered are accurate
        IF (@User_ID LIKE '%[^U_0-9]%')
            THROW 50000, 'Invalid User_ID format', 1;
        IF (@LibUser_firstName LIKE '%[^A-Za-z]%')
            THROW 50000, 'Invalid LibUser_firstName format', 1;
        IF (@LibUser_lastName  LIKE '%[^A-Za-z]%')
            THROW 50000, 'Invalid LibUser_lastName format', 1;
        IF (@LibUser_age <= 16)
            THROW 50000, 'Invalid LibUser_age value', 1;
        IF (@LibUser_gender NOT IN ('M', 'F'))
            THROW 50000, 'Invalid LibUser_gender value', 1;
        IF (@LibUser_Subcity  LIKE '%[^a-z A-Z]%')
            THROW 50000, 'Invalid LibUser_Subcity format', 1;
        IF (@UserPhone  LIKE '%[^0-9+-]%')
            THROW 50000, 'Invalid UserPhone format', 1;
        IF (@UserEmail NOT LIKE '___%@___%.__%')
            THROW 50000, 'Invalid UserEmail format', 1;

        -- Insert into tblLibraryUser
        INSERT INTO tblLibraryUser 
            ([User_ID], LibUser_firstName, LibUser_lastName, LibUser_gender, LibUser_age, LibUser_Subcity, LibUser_Woreda, LibUser_Kebele)
        VALUES 
            (@User_ID, @LibUser_firstName, @LibUser_lastName, @LibUser_gender, @LibUser_age, @LibUser_Subcity, @LibUser_Woreda, @LibUser_Kebele);

        -- Insert into tblUserPhone
        INSERT INTO tblUserPhone 
            ([User_ID], UserPhone)
        VALUES 
            (@User_ID, @UserPhone);

        -- Insert into tblUserEmail
        INSERT INTO tblUserEmail 
            ([User_ID], UserEmail)
        VALUES 
            (@User_ID, @UserEmail);
    END TRY
    BEGIN CATCH
        SELECT 'Error' AS Type, ERROR_MESSAGE() AS Message;
    END CATCH;
END;
--user insertion
/*
EXEC sp_InsertLibraryUser 
    @User_ID = '10', 
    @LibUser_firstName = 'Abebe',
    @LibUser_lastName = 'Mola',
    @LibUser_gender = 'M',
    @LibUser_age = 25,
    @LibUser_Subcity = 'Addis Ababa',
    @LibUser_Woreda = 10,
    @LibUser_Kebele = 20,
    @UserPhone = '+251911223344',
    @UserEmail = 'ejetyjjk';
	*/

/* 19 */----------------------------------------------------------------------------------------------------------------------------changed
-- a procedure that updates info of user table
--drop procedure sp_UpdateLibraryUser
--drop procedure sp_UpdateLibraryUserInfo
CREATE PROCEDURE sp_UpdateLibraryUserInfo
    @User_ID varchar(7),
    @LibUser_firstName nvarchar(60),
    @LibUser_lastName nvarchar(60),
    @LibUser_gender char(1),
    @LibUser_age int,
    @LibUser_Subcity varchar(15),
    @LibUser_Woreda int,
    @LibUser_Kebele int,
    @UserPhone varchar(30),
    @UserEmail varchar(30)
AS
BEGIN
    BEGIN TRY
        -- Check if the User_ID exists in tblLibraryUser
        IF NOT EXISTS (SELECT 1 FROM tblLibraryUser WHERE [User_ID] = @User_ID)
            THROW 50000, 'The User_ID does not exist in tblLibraryUser', 1;

        -- Update tblLibraryUser
        UPDATE tblLibraryUser
        SET LibUser_firstName = @LibUser_firstName,
            LibUser_lastName = @LibUser_lastName,
            LibUser_gender = @LibUser_gender,
            LibUser_age = @LibUser_age,
            LibUser_Subcity = @LibUser_Subcity,
            LibUser_Woreda = @LibUser_Woreda,
            LibUser_Kebele = @LibUser_Kebele
        WHERE [User_ID] = @User_ID;

        -- Update tblUserPhone
        UPDATE tblUserPhone
        SET UserPhone = @UserPhone
        WHERE [User_ID] = @User_ID;

        -- Update tblUserEmail
        UPDATE tblUserEmail
        SET UserEmail = @UserEmail
        WHERE [User_ID] = @User_ID;
    END TRY
    BEGIN CATCH
        -- Handle error by printing the error message
        PRINT ERROR_MESSAGE();
    END CATCH;
END;


/*
EXEC sp_UpdateLibraryUserInfo 
    @User_ID = '12345', 
    @LibUser_firstName = 'abedu',
    @LibUser_lastName = 'debebe',
    @LibUser_gender = 'M',
    @LibUser_age = 25,
    @LibUser_Subcity = 'Addis Ababa',
    @LibUser_Woreda = 10,
    @LibUser_Kebele = 20,
    @UserPhone = '+251911223356',
    @UserEmail = 'abeduDebebe@example.com'
	*/
/* 20 */----------------------------------------------------------------------------------------------------------------------------changed
--  a procedure that inserts data into table borrow
--drop procedure sp_InsertIntoTblBorrow

CREATE PROCEDURE sp_InsertIntoTblBorrow
    @Borrow_ID varchar(7),
    @User_ID varchar(7),
    @Copy_ID varchar(7),
    @Borrow_date date,
    @price smallmoney
AS
BEGIN
    BEGIN TRY
        -- Check if the User_ID exists in tblLibraryUser
        IF NOT EXISTS (SELECT 1 FROM tblLibraryUser WHERE [User_ID] = @User_ID)
            THROW 50000, 'The User_ID does not exist in tblLibraryUser', 1;

        -- Check if the Copy_ID exists in tblCopy
        IF NOT EXISTS (SELECT 1 FROM tblCopy WHERE Copy_ID = @Copy_ID)
            THROW 50000, 'The Copy_ID does not exist in tblCopy', 1;

        -- Insert into tblBorrow
        INSERT INTO tblBorrow (Borrow_ID, [User_ID], Copy_ID, Borrow_date, price)
        VALUES (@Borrow_ID, @User_ID, @Copy_ID, @Borrow_date, @price);
    END TRY
    BEGIN CATCH
        -- Handle error by printing the error message
        PRINT ERROR_MESSAGE();
    END CATCH;
END;


--EXEC sp_InsertIntoTblBorrow 'BRW_31', 'U_1000', 'C_81', '2023-01-01', 10;

/* 21 */----------------------------------------------------------------------------------------------------------------------------changed
--a procedure that deletes user record after they return a book they borrowed
--drop procedure sp_DeleteRowFromTblBorrow

CREATE PROCEDURE sp_DeleteRowFromTblBorrow @Borrow_ID VARCHAR(7)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM tblBorrow WHERE Borrow_ID = @Borrow_ID)
    BEGIN
        SELECT 'Error: Invalid Borrow_ID Or Does Not Exist.' AS ErrorMessage;
        RETURN;
    END;

    DELETE FROM tblBorrow
    WHERE Borrow_ID = @Borrow_ID;
END;
--EXEC sp_DeleteRowFromTblBorrow @Borrow_ID = 'BRW_31';
/* 22 */----------------------------------------------------------------------------------------------------------------------------changed
--  a procedure that inserts data into table related with physical book in one go!
--drop procedure sp_InsertDataIntoAllTablesPhysicalBooks

CREATE PROCEDURE sp_InsertDataIntoAllTablesPhysicalBooks 
    @Auth_ID VARCHAR(7),
    @Auth_FirstName NVARCHAR(40),
    @Auth_LastName NVARCHAR(40),
    @Book_ID VARCHAR(7),
    @Book_Title NVARCHAR(80),
    @Publisher NVARCHAR(70),
    @published_year DATE,
    @edition INT,
    @lang NVARCHAR(20),
    @no_of_pages INT,
    @Genre_ID VARCHAR(7),
    @Genre_title NVARCHAR(20),
    @Copy_ID VARCHAR(7),
    @Copy_Number INT,
    @Shelf_ID VARCHAR(7),
    @floor_number INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO tblAuthor (Auth_ID, Auth_FirstName, Auth_LastName)
        VALUES (@Auth_ID, @Auth_FirstName, @Auth_LastName);

        IF NOT EXISTS (SELECT 1 FROM tblAuthor WHERE Auth_ID = @Auth_ID)
        BEGIN
            SELECT 'Error: Invalid Auth_ID' AS ErrorMessage;
            RETURN;
        END;

        INSERT INTO tblBook (Book_ID, Auth_ID, Book_Title, Publisher, published_year, edition, lang, no_of_pages)
        VALUES (@Book_ID, @Auth_ID, @Book_Title, @Publisher, @published_year, @edition, @lang, @no_of_pages);

        INSERT INTO tblGenre (Genre_ID, Genre_title)
        VALUES (@Genre_ID, @Genre_title);

        IF NOT EXISTS (SELECT 1 FROM tblBook WHERE Book_ID = @Book_ID)
        BEGIN
            SELECT 'Error: Invalid Book_ID' AS ErrorMessage;
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM tblGenre WHERE Genre_ID = @Genre_ID)
        BEGIN
            SELECT 'Error: Invalid Genre_ID' AS ErrorMessage;
            RETURN;
        END;

        INSERT INTO tblBookHas (Book_ID, Genre_ID)
        VALUES (@Book_ID, @Genre_ID);

        INSERT INTO tblCopy (Copy_ID, Book_ID, Copy_Number)
        VALUES (@Copy_ID, @Book_ID, @Copy_Number);

        INSERT INTO tblShelf (Shelf_ID, floor_number)
        VALUES (@Shelf_ID, @floor_number);

        IF NOT EXISTS (SELECT 1 FROM tblCopy WHERE Copy_ID = @Copy_ID)
        BEGIN
            SELECT 'Error: Invalid Copy_ID' AS ErrorMessage;
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM tblShelf WHERE Shelf_ID = @Shelf_ID)
        BEGIN
            SELECT 'Error: Invalid Shelf_ID' AS ErrorMessage;
            RETURN;
        END;

        INSERT INTO tblIsPlacedOn (Copy_ID, Shelf_ID)
        VALUES (@Copy_ID, @Shelf_ID);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;


/* 23 */----------------------------------------------------------------------------------------------------------------------------changed

--  a procedure that inserts data into table related with online book in one go!
--drop procedure sp_InsertDataIntoAllTablesOB

CREATE PROCEDURE sp_InsertDataIntoAllTablesOB 
    @Auth_ID VARCHAR(7),
    @Auth_FirstName NVARCHAR(40),
    @Auth_LastName NVARCHAR(40),
    @Genre_ID VARCHAR(7),
    @Genre_title NVARCHAR(20),
    @Online_BookID VARCHAR(7),
    @Title NVARCHAR(80),
    @Edition VARCHAR(80),
    @Published_Year DATE,
    @file_type VARCHAR(10),
    @No_of_pages INT,
    @Lang NVARCHAR(20),
    @Keywords NVARCHAR(80)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO tblAuthor (Auth_ID, Auth_FirstName, Auth_LastName)
        VALUES (@Auth_ID, @Auth_FirstName, @Auth_LastName);

        INSERT INTO tblGenre (Genre_ID, Genre_title)
        VALUES (@Genre_ID, @Genre_title);

        IF NOT EXISTS (SELECT 1 FROM tblAuthor WHERE Auth_ID = @Auth_ID)
        BEGIN
            SELECT 'Error: Invalid Auth_ID' AS ErrorMessage;
            RETURN;
        END;

        INSERT INTO tblOnlineBook (Online_BookID, Author_ID, Title, Edition, Published_Year, file_type, No_of_pages, Lang)
        VALUES (@Online_BookID, @Auth_ID, @Title, @Edition, @Published_Year, @file_type, @No_of_pages, @Lang);

        INSERT INTO tblKeywords (Online_BookID, Keywords)
        VALUES (@Online_BookID, @Keywords);

        IF NOT EXISTS (SELECT 1 FROM tblGenre WHERE Genre_ID = @Genre_ID)
        BEGIN
            SELECT 'Error: Invalid Genre_ID' AS ErrorMessage;
            RETURN;
        END;

        INSERT INTO tblOBgenre (Online_BookID, Genre_ID)
        VALUES (@Online_BookID, @Genre_ID);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;

/*
exec sp_InsertDataIntoAllTablesOB  
    @Auth_ID ='A_1000',
    @Auth_FirstName ='beke',
    @Auth_LastName ='mola',
    @Genre_ID ='beo',
    @Genre_title ='bleeds',
	@Online_BookID ='OB_1000',
	@Title ='bleeking blooks',
	@Edition ='2',
	@Published_Year ='1990/02/13',
    @file_type ='.pdf',
	@No_of_pages = 500,
	@Lang ='English',
	@Keywords ='blood';
	*/
/* 24 */----------------------------------------------------------------------------------------------------------------------------changed
--  a procedure that inserts data into table Online book access in one go!
-- drop procedure sp_InsertDataIntoOBAccess

CREATE PROCEDURE sp_InsertDataIntoOBAccess
    @Online_BookID VARCHAR(7),
    @User_ID VARCHAR(7)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM tblOnlineBook WHERE Online_BookID = @Online_BookID)
    BEGIN
        SELECT 'Error: Invalid Online_BookID' AS ErrorMessage , 'Must be in the form: OB_1-9'as hint;
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM tblLibraryUser WHERE [User_ID] = @User_ID)
    BEGIN
        SELECT 'Error: Invalid User_ID' AS ErrorMessage , 'Must be in the form: U_1-9'as hint;
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO tblAccess (Online_BookID, [User_ID])
        VALUES (@Online_BookID, @User_ID);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;

-- exec sp_InsertDataIntoOBAccess 'OB_19', 'U_92';
-- error exec sp_InsertDataIntoOBAccess '1', '1';
/* 25 */----------------------------------------------------------------------------------------------------------------------------

-- this procedure counts how many books a genre has
--drop procedure CountBooksByGenre
CREATE PROCEDURE sp_CountBooksByGenre
AS
BEGIN
    SELECT g.Genre_title, COUNT(ob.Online_BookID) as BookCount
    FROM tblOBgenre ob
     JOIN tblGenre g ON ob.Genre_ID = g.Genre_ID
    GROUP BY ROLLUP (g.Genre_title);
END;

--EXEC sp_CountBooksByGenre;

/* 26 */----------------------------------------------------------------------------------------------------------------------------

-- this procedure counts how many books an author has
--drop procedure CountBooksByAuthor
CREATE PROCEDURE sp_CountBooksByAuthor
AS
BEGIN
    SELECT concat(a.Auth_FirstName,' ',a.Auth_LastName)as Author , COUNT(b.Book_ID) as BookCount
    FROM tblAuthor a join tblBook b ON a.Auth_ID = b.Auth_ID
    GROUP BY ROLLUP (concat(a.Auth_FirstName,' ',a.Auth_LastName));
END;

--EXEC sp_CountBooksByAuthor;

/* 27 */----------------------------------------------------------------------------------------------------------------------------
-- this procedure counts how many copys a book has and groups it by book_title
--drop procedure CountCopiesByBook

CREATE PROCEDURE sp_CountCopiesByBook
AS
BEGIN
    SELECT Book_Title, COUNT(Copy_ID) as CopyCount
    FROM [Books Info]
    GROUP BY ROLLUP (Book_Title);
END;

--EXEC sp_CountCopiesByBook;

/* 28 */----------------------------------------------------------------------------------------------------------------------------
-- this procedure finds random books from available books in the library
CREATE PROCEDURE SelectRandomBook
AS
BEGIN
    SELECT TOP 1 *
    FROM [Available Books Info]
    ORDER BY NEWID();
END;

-- exec SelectRandomBook;
/* 29 */----------------------------------------------------------------------------------------------------------------------------
