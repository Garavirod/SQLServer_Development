USE Northwind
GO
-- TEXT FUNCTIONS
--Takes letters from 'left' of word
SELECT CustomerId, LEFT(CompanyName,3) AS FirstLetter, ContactName, Country FROM Customers

--Takes letters from 'a' of word to 'b'
SELECT CustomerId, SUBSTRING(CompanyName,1,3) AS FirstLetter, ContactName, Country FROM Customers

--Takes letters from 'right' of word
SELECT CustomerId, RIGHT(CompanyName,3) AS FirstLetter, ContactName, Country FROM Customers

--LEN
SELECT CustomerId, RIGHT(CompanyName,3) AS FirstLetter, LEN(ContactName) AS numChar, Country FROM Customers

--CAST

SELECT 'List Price ' +  CAST(UnitPrice AS varchar(15)) AS LISTprice FROM Products

--CONVERT

SELECT 'List Price ' +  CONVERT(varchar(15),UnitPrice) AS LISTprice FROM Products

SELECT GETDATE() AS DATE_TODAY, CONVERT(nvarchar(30),GETDATE(),126) AS ISO