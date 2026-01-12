.mode table 
.header on

--First Query
INSERT INTO borrower (borrName, borrAddress, borrPhone)
VALUES ('Group5 member', '911 Copper St, Arlington, TX 99099', '682-702-4792');

--Second Query
UPDATE borrower
SET borrPhone = '837-721-8965'
WHERE borrName = 'Group5 member';

--Third Query
UPDATE book_copies
SET no_of_copies = no_of_copies + 1
WHERE branch_id = (
    SELECT branchID
    FROM libraryBranch
    WHERE branchName = 'East Branch'
);

--Fourth Query (a)
INSERT INTO book (bookID, bookTitle, bookPub)
VALUES (22, 'Harry Potter and the Sorcerers Stone', 'Oxford Publishing');

INSERT INTO book_authors(book_id, author_name)
VALUES (22, 'J.K. Rowling');

--Fourth Query (b)
INSERT INTO libraryBranch (branchName, branchAddress)
VALUES ('North Branch', '456 NW, Irving, TX 76100'), 
       ('UTA Branch', '123 Cooper St, Arlington, TX 76101');

--Fifth Query
SELECT book.bookTitle, libraryBranch.branchName, (julianday(bookLoans.dueDate) - julianday(bookLoans.dateOut)) AS days_borrowed
FROM bookLoans
JOIN book ON bookLoans.bookID = book.bookID
JOIN libraryBranch  ON bookLoans.branchID = libraryBranch.branchID
WHERE bookLoans.dateOut BETWEEN '2022-03-05' AND '2022-03-23'; 

--Sixth Query
SELECT borrName
FROM borrower
JOIN bookLoans ON bookLoans.cardNo = borrower.cardNo
WHERE bookLoans.returnedDate IS NULL;

--Seventh Query 
SELECT branchName, COUNT(bookLoans.bookID) AS numBooksBorr, COUNT (julianday(returnedDate) <= julianday(dueDate)) AS booksReturned, SUM (julianday(returnedDate) IS NULL AND julianday(CURRENT_DATE)) AS stillBorrowed, COUNT (julianday(returnedDate) > julianday(dueDate)) AS lateReturn
FROM libraryBranch
JOIN bookLoans ON bookLoans.branchID = libraryBranch.branchID
JOIN book ON book.bookID = bookLoans.bookID
--JOIN book_copies ON book_copies.book_id = book.bookID
GROUP BY bookLoans.branchID, libraryBranch.branchName;

--Eighth Query 
SELECT bookTitle, MAX (julianday(dueDate) - julianday(dateOut)) AS numDaysBorr
FROM book
JOIN bookLoans ON bookLoans.bookID = book.bookID
GROUP BY book.bookTitle;

--Ninth Query
SELECT borrName, bookTitle, author_name, (julianday(dueDate) - julianday(dateOut)) AS numDaysBorr, (julianday(returnedDate) > julianday(dueDate)) AS lateReturn
FROM borrower
JOIN bookLoans ON bookLoans.cardNo = borrower.cardNo
JOIN book ON book.bookID = bookLoans.bookID
JOIN book_authors On book_authors.book_id = book.bookID
WHERE borrName = 'Ethan Martinez'
GROUP BY book.bookID;

--Tenth Query
SELECT borrName, borrAddress
FROM borrower
JOIN bookLoans ON bookLoans.cardNo = borrower.cardNo
JOIN libraryBranch ON libraryBranch.branchID = bookLoans.branchID
WHERE branchName = 'West Branch';
