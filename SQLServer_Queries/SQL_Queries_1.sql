---USAR UNA BASE DE DATOS
USE Northwind

---INPRIMRI SELECCIONES
SELECT 'HOLA MUNDO'
SELECT GETDATE()

---CREAR VARIABLES
DECLARE @variable varchar(100)
SET @variable = 'SQLServer'
SELECT @variable

--CONSULTAR UNA TABLA CON TODOS SU DATOS
SELECT * FROM Customers


--VARIABLES DEL SISTEMA
SELECT @@ERROR


--OPERACIONES BASICAS
SELECT ProductName, UnitPrice,UnitsInStock, UnitPrice*UnitsInStock AS HM FROM Products
SELECT * FROM customers WHERE country = 'France' OR Country ='Canada'
ORDER BY Country

SELECT COUNTRY  FROM  CUSTOMERS ORDER BY COUNTRY

--ALIAS A NIVEL DE TABLA
SELECT P.PRODUCTNAME, P.UNITPRICE, P.UNITSINSTOCK, 
P.UNITPRICE*P.UNITSINSTOCK AS TOTAL 
FROM  PRODUCTS  AS P

--FUNCION CASE
SELECT PRODUCTNAME, UNITPRICE, 
CASE CATEGORYID
	WHEN 1 THEN 'PASTAS'
	WHEN 2 THEN 'DRINKS'
	WHEN 3 THEN 'FOOD'
	ELSE 'OTHERS'
END AS CATEGORY_NAME
FROM PRODUCTS

--JOINS DE VARIAS TABLAS
	
	SELECT * FROM ORDERS ---A
	SELECT * FROM CUSTOMERS ---B

	---JOINS INTERNOS
	--ANSI SQL-89
	SELECT Customers.CompanyName, Customers.Country,
	Orders.OrderID, Orders.OrderDate
	FROM Customers, Orders
	WHERE Customers.CustomerID=Orders.CustomerID

	--ANSI SQL-92
	SELECT Customers.CompanyName, Customers.Country,
	Orders.OrderID, Orders.OrderDate --Traer todos esos campos
	FROM Customers INNER JOIN  Orders --De la tabla Customers que se conecta con Orders
	ON Customers.CustomerID=Orders.CustomerID --Campos en comnun de la tablas

	--JOINS EXTERNOS

	-- Todos los elementos de A con los que se intersecta con B de A * B
	SELECT Customers.CompanyName, Customers.Country,
	Orders.OrderID, Orders.OrderDate
	FROM Customers LEFT OUTER JOIN Orders
	ON Customers.CustomerID=Orders.CustomerID
	-- Todos los elementos de B con los que se intersecta con A de A * B
	SELECT A.CompanyName, A.Country,
	B.OrderID, B.OrderDate
	FROM Customers AS A RIGHT OUTER JOIN Orders AS B
	ON A.CustomerID=B.CustomerID

	--UNIR MAS DE DOS TABLAS
		--Union de las intersecciones de A con B B con C C con D
	SELECT 
	A.CompanyName, A.Country,
	B.OrderID, B.OrderDate, 
	C.UnitPrice, C.Quantity, 
	D.ProductName,
	C.Quantity * C.UnitPrice AS TOTAL -- Col que muestra el precio totoal de C.Quantity * C.UnitPrice
	FROM Customers AS A INNER JOIN Orders AS B
	ON A.CustomerID=B.CustomerID
	INNER JOIN [Order Details] AS C --Interseccion de B con C
	ON B.OrderID = C.OrderID --Campos en compun de B con C
	INNER JOIN [Products] AS D --Intersección de C con D
	ON D.ProductID=C.ProductID --Campos en compun de C on D
	WHERE D.ProductName = 'Queso Cabrales'


	--CROSS JOINS 
		--Productos cartesianos

		--ANSI SQL-89
	SELECT Customers.CompanyName, Customers.Country,
	Orders.OrderID, Orders.OrderDate
	FROM Customers, Orders

		--ANSI SQL-92
	SELECT Customers.CompanyName, Customers.Country,
	Orders.OrderID, Orders.OrderDate
	FROM Customers CROSS JOIN Orders

	
	--SELF JOINS
		--Hacer un join de una tabla con ella misma, se debe  de meniconar una alias
	SELECT boss.FirstName + ' ' + boss.LastName AS jefe,
	employ.FirstName + ' ' + employ.LastName AS subordinado
	FROM Employees AS employ INNER JOIN Employees AS boss
	ON boss.EmployeeID = employ.ReportsTo