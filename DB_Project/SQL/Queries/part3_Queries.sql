.mode table 
.header on

--First Query
ALTER TABLE bookLoans
ADD Late INT;

UPDATE bookLoans
SET Late = 
CASE WHEN julianday(returnedDate) <= julianday(dueDate) THEN 0
WHEN julianday(returnedDate) > julianday(dueDate) OR returnedDate IS NULL THEN 1 
END;

SELECT * FROM bookLoans;

--Second Query
ALTER TABLE libraryBranch
ADD LateFee INT;

UPDATE libraryBranch
SET LateFee = 
CASE WHEN branchId = 1 THEN 4
WHEN branchId = 2 THEN 5
WHEN branchId = 3 THEN 6
END; 

SELECT * FROM libraryBranch;

--Third Query
CREATE VIEW vBookLoanInfo (
    Card_No,
    Borrower_Name,
    Date_Out,
    Due_Date,
    Returned_date,
    TotalDays,
    Book_Title,
    returned_late, 
    Branch_ID,
    LateFeeBalance
) AS 
    SELECT bl.cardNo, b.borrName, bl.dateOut, bl.dueDate, bl.returnedDate, CASE WHEN julianday(returnedDate) - julianday(dateOut) <= 0 THEN 0 WHEN julianday(returnedDate) - julianday(dateOut) IS NULL THEN 0 ELSE julianday(returnedDate) - julianday(dateOut) END, 
    bk.bookTitle, CASE WHEN julianday(returnedDate) - julianday(dueDate) <= 0 THEN 0 WHEN julianday(returnedDate) - julianday(dueDate) IS NULL THEN 0 ELSE julianday(returnedDate) - julianday(dueDate) END AS returnedLate, 
    lb.branchId, C.LateFeeBalance
    FROM bookLoans bl
    JOIN BORROWER b ON b.cardNo = bl.cardNo
    JOIN libraryBranch lb ON lb.branchId = bl.branchId
    JOIN book bk ON bk.bookId = bl.bookId JOIN (
        SELECT julianday(bl.returnedDate) - julianday(bl.dueDate), lb.LateFee, (julianday(bl.returnedDate) - julianday(bl.dueDate) * lb.LateFee) AS LateFeeBalance  
        FROM libraryBranch
    ) AS C;

