-- Create a non-clustered index on  tblAuthor table
CREATE NONCLUSTERED INDEX IX_tblAuthor
ON tblAuthor (Auth_FirstName ASC,Auth_LastName ASC);

-- drop index tblAuthor.IX_tblAuthor_Auth_LastName
-- Create a non-clustered index on tblBook table
CREATE NONCLUSTERED INDEX IX_tblBook
ON tblBook (Book_Title ASC,Publisher);

drop index tblBook.IX_tblBook_Book_Title
-- Create a non-clustered index on the published_year column of the tblBook table
CREATE NONCLUSTERED INDEX IX_tblBook_published_year
ON tblBook (published_year DESC);

-- Create a non-clustered index on the Genre_title column of the tblGenre table
CREATE NONCLUSTERED INDEX IX_tblGenre_Genre_title
ON tblGenre (Genre_title ASC);

-- Create a non-clustered index on the LibUser_lastName column of the tblLibraryUser table
CREATE NONCLUSTERED INDEX IX_tblLibraryUser
ON tblLibraryUser (LibUser_firstName ASC,LibUser_lastName);

--drop index tblLibraryUser.IX_tblLibraryUser_LibUser_lastName

-- Create a non-clustered index on  tblonlinebook table
CREATE NONCLUSTERED INDEX IX_tblonlinebook
ON tblonlinebook (Title ASC,Published_Year);