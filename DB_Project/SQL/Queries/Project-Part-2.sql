CREATE TABLE publisher(
    pubName VARCHAR(20),
    pubPhone INT,
    pubAddress VARCHAR(50),

    PRIMARY KEY (pubName) 
);

CREATE TABLE libraryBranch(
    branchID INT,
    branchName VARCHAR(20),
    branchAddress VARCHAR(50),

    PRIMARY KEY (branchID)
);

CREATE TABLE borrower(
    cardNo INT PRIMARY KEY,
    borrName VARCHAR(20),
    borrAddress VARCHAR(50),
    borrPhone INT 
);

CREATE TABLE book(
    bookID INT PRIMARY KEY,
    bookTitle VARCHAR(30),
    bookPub VARCHAR(20),

    FOREIGN KEY (bookPub) REFERENCES publisher(pubName)
);

CREATE TABLE bookLoans(
    bookID INT,
    branchID INT,
    cardNo INT,
    dateOut DATE,
    dueDate DATE,
    returnedDate DATE,

    FOREIGN KEY (bookID) REFERENCES book(bookID) ON UPDATE CASCADE,
    FOREIGN KEY (branchID) REFERENCES libraryBranch(branchID) ON UPDATE CASCADE,
    FOREIGN KEY (cardNo) REFERENCES borrower(cardNo) ON UPDATE CASCADE
);

CREATE TABLE book_copies (
    book_id INT,
    branch_id INT,
    no_of_copies INT,

    FOREIGN KEY (book_id) REFERENCES book(bookID) ON UPDATE CASCADE,
    FOREIGN KEY (branch_id) REFERENCES libraryBranch(branchID) ON UPDATE CASCADE
);

CREATE TABLE book_authors (
    book_id INT,
    author_name VARCHAR(100),

    FOREIGN KEY (book_id) REFERENCES book(bookID) ON UPDATE CASCADE
);

