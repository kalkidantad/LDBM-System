use LibraryManagement
go
CREATE LOGIN AdminLogin
WITH PASSWORD = 'AdminLogin@123456.' MUST_CHANGE,
DEFAULT_DATABASE = LibraryManagement,
DEFAULT_LANGUAGE = English,
CHECK_POLICY = on ,
CHECK_EXPIRATION = on;

CREATE LOGIN LibraryReceptionist
WITH PASSWORD = 'LibraryReceptionistLogin@123.' ,
DEFAULT_DATABASE = LibraryManagement,
DEFAULT_LANGUAGE = English,
CHECK_POLICY = ON 


/* it has privilages for select, insert, update, delete, alter and drop statements on all tables */
USE LibraryManagement;
GO
CREATE USER AdminUser FOR LOGIN AdminLogin

USE LibraryManagement;
GO
CREATE USER librarian_01 FOR LOGIN LibraryReceptionist
DENY ALL ON DATABASE::[LibraryManagement] TO [librarian_01]
GRANT SELECT, INSERT, DELETE ON dbo.tblBorrow to librarian_01
GRANT SELECT, INSERT ON dbo.tblBook to librarian_01
GRANT SELECT, INSERT ON dbo.tblBookHas to librarian_01
GRANT SELECT, INSERT ON dbo.tblCopy to librarian_01
GRANT SELECT, INSERT ON dbo.tblIsPlacedOn to librarian_01
GRANT SELECT ON dbo.tblAccess to librarian_01
GRANT SELECT, INSERT ON dbo.tblAuthor to librarian_01
GRANT SELECT, INSERT ON dbo.tblGenre to librarian_01
GRANT SELECT, INSERT ON dbo.tblShelf to librarian_01





SELECT name FROM sys.sysusers WHERE issqluser = 1;
-- drop SERVER audit library_audit
CREATE SERVER AUDIT library_audit
TO FILE (Filepath ='C:\LMS Audit');
ALTER SERVER AUDIT library_audit
WITH (STATE = on);  
GO  
USE LibraryManagement
-- drop DATABASE audit SPECIFICATION [New_DatabaseAuditSpecification]
CREATE DATABASE AUDIT SPECIFICATION [New_DatabaseAuditSpecification]
FOR SERVER AUDIT [library_audit]
ADD (DATABASE_OBJECT_ACCESS_GROUP),
ADD (DATABASE_OBJECT_CHANGE_GROUP),
ADD (DELETE ON DATABASE::[LibraryManagement] BY [dbo]),
ADD (INSERT ON DATABASE::[LibraryManagement] BY [dbo]),
ADD (SELECT ON DATABASE::[LibraryManagement] BY [dbo]),
ADD (UPDATE ON DATABASE::[LibraryManagement] BY [dbo])
WITH (STATE = OFF)
GO
USE LibraryManagement
ALTER DATABASE AUDIT SPECIFICATION   New_DatabaseAuditSpecification
FOR SERVER AUDIT [library_audit]
WITH (STATE = on);
GO
SELECT *
FROM sys.fn_get_audit_file('C:\LMS Audit\*.sqlaudit', default, default)



