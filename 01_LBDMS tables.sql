--create database LibraryManagement
--use LibraryManagement

--use master
 --drop database LibraryManagement
create table tblAuthor
(
Auth_ID varchar(7) primary key, 
Auth_FirstName nvarchar(40)    NOT NULL,
Auth_LastName nvarchar(40),

check(Auth_ID Not Like '%[^A_0-9]%'),
);

create table tblBook
(
Book_ID varchar(7) primary key, 
Auth_ID varchar(7) foreign key references tblAuthor(Auth_ID) not null, 
Book_Title nvarchar(80)     not null, 
Publisher nvarchar(70)     not null, 
published_year date not null, 
edition int not null, 
lang nvarchar(20) default 'English', 
no_of_pages int not null,

check(Book_ID Not Like '%[^B_0-9]%'),
check(Auth_ID Not Like '%[^A_0-9]%'),
check(lang not like'%[^A-Za-z]%')
);

create table tblGenre
(
Genre_ID varchar(7) primary key, 
Genre_title nvarchar(20) not null,

 
check(Genre_ID Not Like '%[^G_0-9]%')
);

create table tblBookHas
(
Book_ID varchar(7) foreign key references tblBook(Book_ID) not null, 
Genre_ID varchar(7) foreign key references tblGenre(Genre_ID) not null,

check(Book_ID Not Like '%[^B_0-9]%'),
check(Genre_ID Not Like '%[^G_0-9]%')
)

create table tblCopy
(
Copy_ID varchar(7) primary key, 
Book_ID varchar(7) foreign key references tblBook(Book_ID) not null, 
Copy_Number int not null,

check(Book_ID Not Like '%[^B_0-9]%'),
check(Copy_ID Not Like '%[^C_0-9]%')
);

create table tblOnlineBook
(
Online_BookID varchar(7) primary key, 
Author_ID varchar(7) foreign key references tblAuthor(Auth_ID) not null, 
Title nvarchar(80) not null, 
Edition varchar(80) not null, 
Published_Year date not null,
file_type varchar(10) not null, 
No_of_pages int not null, 
Lang nvarchar(20) default 'English',

check(Online_BookID Not Like '%[^OB_0-9]%'),
check(Author_ID Not Like '%[^A_0-9]%'),
check(file_type not like '%[^a-zA-Z]%'),
check(No_of_pages Not Like '%[^0-9]%'),
check(Lang Not Like '%[^A-Za-z]%'),
);

create table tblKeywords
(
Online_BookID varchar(7) foreign key references tblOnlineBook(Online_BookID),
Keywords nvarchar(80) not null,

check(Online_BookID Not Like '%[^OB_0-9]%')
);

create table tblLibraryUser 
(
[User_ID] varchar(7) primary key, 
LibUser_firstName nvarchar(60)  NOT NULL,
LibUser_lastName nvarchar(60)  NOT NULL, 
LibUser_gender  char(1)   NOT NULL, 
LibUser_age int not null,
LibUser_Subcity varchar(15) not null, 
LibUser_Woreda int not null,
LibUser_Kebele int not null,



check([User_ID] Not Like '%[^U_0-9]%'),
check(LibUser_firstName Not Like '%[^A-Za-z]%'),
check(LibUser_lastName Not Like '%[^A-Za-z]%'),
check(LibUser_age >16),
check(LibUser_gender in ('M', 'F')),
check(LibUser_Subcity not like '%[^a-z A-Z]%'),
);

create table tblUserPhone 
(
[User_ID] varchar(7) foreign key references tblLibraryUser([User_ID]), 
UserPhone varchar(30)  not null ,

check(UserPhone Not Like '%[^0-9+-]%'),
check([User_ID] Not Like '%[^U_0-9]%'),
);

create table tblUserEmail
(
[User_ID] varchar(7) foreign key references tblLibraryUser([User_ID]) not null, 
UserEmail varchar(30) not null,

check([User_ID] Not Like '%[^U_0-9]%'),
check(UserEmail  like '___%@___%.__%')
);

create table tblAccess
(
Online_BookID varchar(7) foreign key references tblOnlineBook(Online_BookID) not null,
[User_ID] varchar(7) foreign key references tblLibraryUser([User_ID]) not null,

check(Online_BookID Not Like '%[^OB_0-9]%'),
check([User_ID] Not Like '%[^U_0-9]%'),
);

create table tblOBgenre (
Online_BookID varchar(7) foreign key references tblOnlineBook(Online_BookID) not null,
Genre_ID varchar(7) foreign key references tblGenre(Genre_ID) not null,

check(Online_BookID Not Like '%[^OB_0-9]%'),
check(Genre_ID Not Like '%[^G_0-9]%')
)

create table tblBorrow
(
Borrow_ID varchar(7) primary key,
[User_ID] varchar(7) foreign key references tblLibraryUser([User_ID]) not null, 
Copy_ID varchar(7) foreign key references tblCopy(Copy_ID) not null, 
Borrow_date date not null, 
price smallmoney not null,

check(Borrow_ID Not Like '%[^BRW_0-9]%'),
check([User_ID] Not Like '%[^U_0-9]%'),
check(Copy_ID Not Like '%[^C_0-9]%'),
);

create table tblShelf
(
Shelf_ID varchar(7) primary key, 
floor_number int not null,

check(Shelf_ID Not Like '%[^S_0-9]%'),
);

create table tblIsPlacedOn
(
Copy_ID varchar(7) foreign key references tblCopy(Copy_ID) not null,
Shelf_ID varchar(7) foreign key references tblShelf(Shelf_ID) not null,

check(Copy_ID Not Like '%[^C_0-9]%'),
check(Shelf_ID Not Like '%[^S_0-9]%')
);



