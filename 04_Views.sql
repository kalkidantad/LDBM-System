use LibraryManagement
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--physical book info --views

create view [Books Info]
as 
select tblBook.Book_ID, tblBook.Book_Title,tblBook.edition,concat(tblAuthor.Auth_FirstName,' ',tblAuthor.Auth_LastName) as Author, tblBook.lang, tblBook.no_of_pages,tblBook.Publisher,tblBook.published_year,tblGenre.Genre_title,tblCopy.Copy_ID,tblCopy.Copy_Number,tblIsPlacedOn.Shelf_ID as Shelf,tblShelf.floor_number
from tblBook inner join tblAuthor on tblBook.Auth_ID = tblAuthor.Auth_ID left join tblBookHas on tblBookHas.Book_ID = tblBook.Book_ID left join tblCopy on tblBook.Book_ID = tblCopy.Book_ID join tblGenre on tblGenre.Genre_ID=tblBookHas.Genre_ID  left join tblIsPlacedOn on tblCopy.Copy_ID = tblIsPlacedOn.Copy_ID left join tblShelf on tblIsPlacedOn.Shelf_ID=tblShelf.Shelf_ID;
--drop view [Books_Info];
--select * from [Books Info]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--online book info --views
create view [Online Books info]
as
select tblOnlineBook.Online_BookID,tblOnlineBook.Title,tblOnlineBook.Published_Year,tblOnlineBook.No_of_pages,tblOnlineBook.Lang,tblOnlineBook.file_type,tblOnlineBook.Edition,concat(tblAuthor.Auth_FirstName,' ',tblAuthor.Auth_LastName)as Author, tblKeywords.Keywords,tblGenre.Genre_title
from tblOnlineBook inner join tblAuthor on tblOnlineBook.Author_ID = tblAuthor.Auth_ID left join tblKeywords on tblOnlineBook.Online_BookID = tblKeywords.Online_BookID left join tblOBgenre on tblOnlineBook.Online_BookID =tblOBgenre.Online_BookID join  tblGenre on tblGenre.Genre_ID=tblOBgenre.Genre_ID;
--select * from [Online Books info]
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--user info --view
create view [User Info]
as 
SELECT tblLibraryUser.[User_ID],
       CONCAT(LibUser_firstName, ' ', tblLibraryUser.LibUser_lastName) AS [User_name],
       tblLibraryUser.LibUser_gender,
       tblLibraryUser.LibUser_age,
       tblLibraryUser.LibUser_Subcity,
       tblLibraryUser.LibUser_Woreda,
       tblLibraryUser.LibUser_Kebele,
       STUFF((SELECT ', ' + tblUserPhone.UserPhone
              FROM tblUserPhone
              WHERE tblLibraryUser.[User_ID] = tblUserPhone.[User_ID]
              FOR XML PATH('')), 1, 1, '') AS UserPhones,
       STUFF((SELECT ', ' + tblUserEmail.UserEmail
              FROM tblUserEmail
              WHERE tblLibraryUser.[User_ID] = tblUserEmail.[User_ID]
              FOR XML PATH('')), 1, 1, '') AS UserEmails		  
FROM tblLibraryUser;

--select * from [User Info]
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--user acess full info --view

create view [Online Books Access]
as
select  tblLibraryUser.[User_ID],
concat(tblLibraryUser.LibUser_firstName,' ',tblLibraryUser.LibUser_lastName)as [user_name],
tblOnlineBook.Online_BookID,tblOnlineBook.Title,
tblOnlineBook.file_type,
tblOnlineBook.Lang,
STUFF((SELECT ', ' + tblUserEmail.UserEmail
              FROM tblUserEmail
              WHERE tblLibraryUser.[User_ID] = tblUserEmail.[User_ID]
              FOR XML PATH('')), 1, 1, '') AS UserEmails	
from tblOnlineBook inner join tblAccess on tblOnlineBook.Online_BookID=tblAccess.Online_BookID  
join tblLibraryUser on tblAccess.[User_ID]=tblLibraryUser.[User_ID]  
--select * from [Online Books Access]
--drop view [Online Books Access]
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--full borrow info --view

create view [Borrowed Info]
as
select tblBorrow.Borrow_ID, tblCopy.Copy_ID,tblBook.Book_Title,tblBook.edition,tblCopy.Copy_Number ,tblBorrow.[User_ID],concat(tblLibraryUser.LibUser_firstName,' ',tblLibraryUser.LibUser_lastName)as [user_name],tblBorrow.price -- REMOVED INITIAL PRICE DROP THE view
from tblBook  join tblCopy on tblBook.Book_ID = tblCopy.Book_ID join tblBorrow  on tblCopy.Copy_ID = tblBorrow.Copy_ID
 inner join tblLibraryUser on tblBorrow.[User_ID]=tblLibraryUser.[User_ID]

 --select * from [Borrowed Info]
--drop view [Borrowed Info]
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE VIEW [Available Books Info]
    AS
    SELECT *
    FROM [Books Info]
    WHERE Copy_ID NOT IN (SELECT Copy_ID FROM [Borrowed Info]);

--select * from [Available Books Info]
