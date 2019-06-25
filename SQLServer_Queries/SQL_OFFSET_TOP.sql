/*
	TOP, TOP WITH TIES, OFFSET AND FETCH-FETCH
*/

USE Northwind

--USING ORDER BY
SELECT customerID, companyName, ContactName, Country FROM Customers
ORDER BY  4 DESC

SELECT customerID, companyName, ContactName, Country FROM Customers
ORDER BY  4 DESC,3 ASC

--USING TOP

SELECT TOP 5 ProductName, UnitPrice FROM Products --Shows the first 5, don't use when oyu uses ORDER BY
ORDER BY UnitPrice DESC

SELECT TOP 12 WITH TIES ProductName,UnitPrice FROM Products --WITH TIES show the duplicated elements
ORDER BY UnitPrice

SELECT TOP 20 PERCENT ProductName,UnitPrice FROM Products --it show the 20 % of data
ORDER BY UnitPrice

--USING OFFSET

SELECT ProductName,UnitPrice FROM Products 
ORDER BY UnitPrice OFFSET 5 ROWS --Brinca 5 filas y muestra a patir de la 6ta
FETCH NEXT 5 ROWS ONLY --SOLO TOMA 5 FILAS
--Generalizando brinca 5 filas y toma de todas las demas las 5 primeras

SELECT CustomerID, CompanyName, ContactName, Country, fax FROM Customers
WHERE Fax IS NULL

--Los valores nulos no se cuentan
SELECT COUNT(Fax) FROM Customers
SELECT COUNT(CustomerID) FROM Customers