USE tempdb;

------Creación de las Tablas------
CREATE TABLE Facturas (Factura INT, Cliente INT, Fecha DATETIME, Total Money DEFAULT (0));
CREATE TABLE Facturas_Detalles (Factura INT, Detalle INT, Producto VARCHAR(10), Total Money);

------Creación del Trigger------
CREATE TRIGGER Detalles_Modificados
ON Facturas_Detalles
AFTER UPDATE, INSERT,DELETE
AS
BEGIN
	UPDATE 	Facturas
	SET 	Total = Total + Total_Detalles
	FROM 	(
			SELECT Factura AS Fct, SUM(Total) AS Total_Detalles  
			FROM	(
					SELECT Factura, Total  FROM Inserted
					UNION ALL
					SELECT Factura, -Total FROM Deleted
					) T
			GROUP BY Factura
			) A
	WHERE  Factura = Fct;
END;

-----------------------------

SELECT * from Facturas;
SELECT * from Facturas_Detalles;

------Creación de las Facturas------
INSERT INTO Facturas (Factura, Cliente, Fecha) 
VALUES	(1, 10, '20171005'),
		(2, 15, '20171005');

SELECT * from Facturas;

------Creación de 1 Detalle en 1 Factura------
INSERT INTO Facturas_Detalles (Factura, Detalle, Producto, Total) VALUES (1, 1, 'Bici-Roja', 100);

SELECT * from Facturas;
SELECT * from Facturas_Detalles;


------Creación de múltiples detalle en 1 Factura------
INSERT INTO Facturas_Detalles (Factura, Detalle, Producto, Total) 
	VALUES	(2, 1, 'Bici-Roja', 100),
			(2, 2, 'Gafas', 25),
			(2, 3, 'Guantes', 25);

SELECT * from Facturas;
SELECT * from Facturas_Detalles;

------Creación de Detalles en diferentes Facturas------
INSERT INTO Facturas_Detalles (Factura, Detalle, Producto, Total) 
	VALUES	(1, 2, 'Bici-Azul', 150),
			(1, 3, 'Gafas', 25),
			(2, 4, 'Revistas', 10);

SELECT * from Facturas;
SELECT * from Facturas_Detalles ORDER BY Factura, Detalle;

------Creación de Detalles en diferentes Facturas------
BEGIN TRANSACTION;
	INSERT INTO Facturas_Detalles (Factura, Detalle, Producto, Total) VALUES (2, 5, 'Rueda', 40)
	INSERT INTO Facturas_Detalles (Factura, Detalle, Producto, Total) VALUES (1, 4, 'Guantes', 25)
	INSERT INTO Facturas_Detalles (Factura, Detalle, Producto, Total) VALUES (2, 6, 'Bici-Verde', 100);
COMMIT;

SELECT * from Facturas;
SELECT * from Facturas_Detalles ORDER BY Factura, Detalle;

------Modificación de Detalles------
UPDATE	Facturas_Detalles 
SET		Total = 15
WHERE	Producto='Gafas'

SELECT * from Facturas;
SELECT * from Facturas_Detalles ORDER BY Factura, Detalle;

UPDATE	Facturas_Detalles 
SET		Total = Total * .9
WHERE	Factura = 1 AND Detalle = 2

SELECT * from Facturas;
SELECT * from Facturas_Detalles ORDER BY Factura, Detalle;

------Eliminación de Detalles------
DELETE	Facturas_Detalles 
WHERE	Producto='Bici-Verde'

SELECT * from Facturas;
SELECT * from Facturas_Detalles ORDER BY Factura, Detalle;


DELETE	Facturas_Detalles 
WHERE	Producto='Guantes'

SELECT * from Facturas;
SELECT * from Facturas_Detalles ORDER BY Factura, Detalle;



/*********************************
	IMPORTANCIA DEL	UNION ALL
*********************************/
ALTER TRIGGER Detalles_Modificados
ON Facturas_Detalles
AFTER UPDATE, INSERT,DELETE
AS
BEGIN

	UPDATE 	Facturas
	SET 		Total = Total + Total_Detalles
	FROM 	(
			SELECT Factura AS Fct, SUM(Total) AS Total_Detalles  
			FROM	(
					SELECT Factura, Total  FROM Inserted
					UNION  --Sin ALL
					SELECT Factura, -Total FROM Deleted
					) T
			GROUP BY Factura
			) A
	WHERE  Factura = Fct;
END;


-------Eliminamos TODOS LOS DATOS de las Tablas------
TRUNCATE TABLE Facturas;
TRUNCATE TABLE Facturas_Detalles;

SELECT * from Facturas;
SELECT * from Facturas_Detalles;

------Creación de las Facturas------
INSERT INTO Facturas (Factura, Cliente, Fecha) 
VALUES	(1, 10, '20171005'),
		(2, 15, '20171005');

SELECT * from Facturas;

------Creación de 1 Detalle en 1 Factura------
INSERT INTO Facturas_Detalles (Factura, Detalle, Producto, Total) VALUES (1, 1, 'Bici-Roja', 100);

SELECT * from Facturas;
SELECT * from Facturas_Detalles;


------Creación de Múltiles Detalles en 1 Factura------
INSERT INTO Facturas_Detalles (Factura, Detalle, Producto, Total) 
	VALUES	(2, 1, 'Bici-Roja', 100),
			(2, 2, 'Gafas', 25),
			(2, 3, 'Guantes', 25);

SELECT * from Facturas;
SELECT * from Facturas_Detalles;

-------Problema--------------
SELECT Factura, Total  FROM Inserted
UNION
SELECT Factura, -Total FROM Deleted

-----------Simulemos la Tabla Inserted------------
CREATE TABLE Insertados (Factura INT, Total Money)	
INSERT INTO Insertados (Factura, Total)	
	VALUES	(2, 100), --(2, 1, 'Bici-Roja', 100),
			(2, 25), --(2, 2, 'Gafas', 25),
			(2, 25); --(2, 3, 'Guantes', 25);

SELECT * FROM Insertados; -- SELECT * FROM Inserted

-----------Simulemos la Tabla Deleted------------
CREATE TABLE Eliminados (Factura INT, Total Money);
SELECT * FROM Eliminados; -- SELECT * FROM Deleted


-----------Diferencias------------
SELECT Factura, Total  FROM Insertados
UNION  -- Operación de Conjuntos
SELECT Factura, -Total FROM Eliminados;

SELECT Factura, Total  FROM Insertados
UNION  ALL --Todos, No importar que estén repetidos
SELECT Factura, -Total FROM Eliminados;





---------Hagamos Limpieza------------
DROP TABLE Facturas;
DROP TABLE Facturas_Detalles; -->DROP TRIGGER Detalles_Modificados;
DROP TABLE Insertados; 
DROP TABLE Eliminados;


/*
	Desveantages:

	Complex restrictions based on other tables
	Security
	Auditory
	Errors manage
	Reusing code
	encapsulating

*/