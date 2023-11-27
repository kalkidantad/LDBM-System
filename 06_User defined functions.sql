CREATE FUNCTION calculate_fee(@borrow_id VARCHAR(7))
RETURNS TABLE
AS
RETURN 
(
    SELECT User_ID, (DATEDIFF(DAY, Borrow_date, GETDATE()))as NumOfDays,
    CASE 
        WHEN DATEDIFF(DAY, Borrow_date, GETDATE()) < 8 THEN 0.00
        WHEN DATEDIFF(DAY, Borrow_date, GETDATE()) = 8 THEN price
        ELSE price + (DATEDIFF(DAY, Borrow_date, GETDATE()) - 8) * 2
    END AS Fee
    FROM tblBorrow
    WHERE Borrow_ID = @borrow_id
);
-- SELECT * FROM dbo.calculate_fee('BRW_30');
-- SELECT * FROM dbo.calculate_fee('BRW_31');
-- SELECT * FROM dbo.calculate_fee('BRW_40');

-- select * from tblBorrow
-- drop function calculate_fee