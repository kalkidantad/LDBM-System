--DROP TRIGGER tblBorrowAudit
--DROP TABLE tblBorrowAudit
--Audit trigger on tblBorrow 
CREATE TABLE tblBorrowAudit
(
    Audit_ID INT IDENTITY(1,1) PRIMARY KEY,
    Audit_Action VARCHAR(10) NOT NULL,
    Audit_Timestamp DATETIME NOT NULL,
    Borrow_ID VARCHAR(7),
    User_ID VARCHAR(7),
    Copy_ID VARCHAR(7),
    Borrow_date DATE,
    price SMALLMONEY,
	Changed_By nvarchar(25)
);
drop trigger tr_tblBorrow_Audit

CREATE TRIGGER tr_tblBorrow_Audit
ON tblBorrow
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
   
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO tblBorrowAudit (Audit_Action, Audit_Timestamp, Borrow_ID, User_ID, Copy_ID, Borrow_date, price, Changed_By)
        SELECT 'INSERT', GETDATE(), Borrow_ID, User_ID, Copy_ID, Borrow_date, price, SUSER_SNAME() FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO tblBorrowAudit (Audit_Action, Audit_Timestamp, Borrow_ID, User_ID, Copy_ID, Borrow_date, price, Changed_By)
        SELECT 'DELETE', GETDATE(), Borrow_ID, User_ID, Copy_ID, Borrow_date, price, SUSER_SNAME() FROM deleted;
    END

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO tblBorrowAudit (Audit_Action, Audit_Timestamp, Borrow_ID, User_ID, Copy_ID, Borrow_date, price, Changed_By)
        SELECT 'UPDATE', GETDATE(), Borrow_ID, User_ID, Copy_ID, Borrow_date, price,SUSER_SNAME() FROM inserted;
    END
END;


	select * from tblBorrow
	select * from tblBorrowAudit
	Delete tblBorrow
	where Borrow_ID='BRW_30';
	Update tblBorrow
	set Copy_ID = 'C_2';
	where Borrow_ID='BRW_10';

--Audit trigger on tblLibraryUser

--DROP TRIGGER tblLibraryUserAudit
--DROP TABLE tblLibraryUserAudit
CREATE TABLE tblLibraryUserAudit
(
    AuditID INT IDENTITY(1,1),
    AuditDate DATETIME NOT NULL,
    AuditAction CHAR(1) NOT NULL,
    User_ID VARCHAR(7),
    LibUser_firstName NVARCHAR(60),
    LibUser_lastName NVARCHAR(60),
    LibUser_gender CHAR(1),
    LibUser_age INT,
    LibUser_Subcity VARCHAR(15),
    LibUser_Woreda INT,
    LibUser_Kebele INT,
	Changed_By nvarchar(25)
);
CREATE TRIGGER trg_tblLibraryUser_audit
ON tblLibraryUser
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert audit record for inserted rows
    INSERT INTO tblLibraryUser_audit (User_ID, LibUser_firstName, LibUser_lastName, LibUser_gender, LibUser_age, LibUser_Subcity, LibUser_Woreda, LibUser_Kebele, audit_action, audit_timestamp, Changed_By)
    SELECT User_ID, LibUser_firstName, LibUser_lastName, LibUser_gender, LibUser_age, LibUser_Subcity, LibUser_Woreda, LibUser_Kebele, 'INSERT', GETDATE(), SUSER_SNAME()
    FROM inserted;

    -- Insert audit record for updated rows
    INSERT INTO tblLibraryUser_audit (User_ID, LibUser_firstName, LibUser_lastName, LibUser_gender, LibUser_age, LibUser_Subcity, LibUser_Woreda, LibUser_Kebele, audit_action, audit_timestamp, Changed_By)
    SELECT User_ID, LibUser_firstName, LibUser_lastName, LibUser_gender, LibUser_age, LibUser_Subcity, LibUser_Woreda, LibUser_Kebele,'UPDATE', GETDATE(), SUSER_SNAME()
    FROM inserted;

    -- Insert audit record for deleted rows
    INSERT INTO tblLibraryUser_audit (User_ID ,LibUser_firstName ,LibUser_lastName ,LibUser_gender ,LibUser_age ,LibUser_Subcity ,LibUser_Woreda ,LibUser_Kebele ,audit_action ,audit_timestamp ,Changed_By)
    SELECT User_ID ,LibUser_firstName ,LibUser_lastName ,LibUser_gender ,LibUser_age ,LibUser_Subcity ,LibUser_Woreda ,LibUser_Kebele ,'DELETE' ,GETDATE() ,SUSER_SNAME()
    FROM deleted;
END;




