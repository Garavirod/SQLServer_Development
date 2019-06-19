---TEMPORARY PARTITIONS OF DATA AND TABLES---

/*
	Table that divides its information into several hard drives.
	The Idea is distribute the work for a table that has many data, 
	for example when we need distribute data under a date range in several hard drives.

	To do this we need to create file groups and Send a portion of the table to each specific group.
*/

---PARTITIONED TABLE

---File groups

USE Empresa
GO

ALTER DATABASE Empresa
ADD FILEGROUP GroupPart1 
GO

ALTER DATABASE Empresa
ADD FILEGROUP GroupPart2 
GO

ALTER DATABASE Empresa
ADD FILEGROUP GroupPart3 
GO

---let's associate files to the groups

ALTER DATABASE Empresa
ADD FILE (NAME=empresaV1, FILENAME='C:\Data\empresaV1.ndf',size=15mb, filegrowth=25%) TO FILEGROUP GroupPart1	
Go

ALTER DATABASE Empresa
ADD FILE (NAME=empresaV2, FILENAME='C:\Data\empresaV2.ndf',size=15mb, filegrowth=25%) TO FILEGROUP GroupPart3	
Go

ALTER DATABASE Empresa
ADD FILE (NAME=empresaV3, FILENAME='C:\Data\empresaV3.ndf',size=15mb, filegrowth=25%) TO FILEGROUP GroupPart3	
Go

---Let's make a function that assigns the partition of the data.

CREATE PARTITION FUNCTION partitionFunction (varchar(150))
AS RANGE RIGHT
FOR VALUES ('I','P')
GO


---Let's create the schema, it's which assigns the data in the gruop files

CREATE PARTITION  scheme  schemaPArtition AS PARTITION partitionFunction
TO (GroupPart1,GroupPart2,GroupPart3)


---Let's create a partitioned table

CREATE TABLE Person(
	numOrder varchar(10),
	numRegister bigint,
	name1 varchar(150),
	surnname1 varchar(150),
)
ON  schemaPArtition(surnname1) ---Columna por la cual se quiere hacer la división de datos
GO


---Let's insert data through a query
INSERT INTO Person(
	numOrder,
	numRegister,
	name1,
	surnname1
)
VALUES(
	'rga123',
	2,
	'Rodrigo',
	'García'
)
---SELECT CustomerID, CustomerID,ContactName,City FROM Northwind.dbo.Customers


---Check what partition is the data.

SELECT surnname1, $partition.partitionFunction(surnname1) as partition
FROM Person
GO


---TEMPORARY TABLES (TABLA VERSIONADA)
/*
	It allows registrer a historic of data changes

*/
CREATE TABLE Individuos(
	registredNumber bigint identity(1,1) primary key,
	nanme1 varchar(150),
	nanme2 varchar(150),
	lastname1 varchar(150),
	lastname2 varchar(150),
	---Date filed of type "datetime2" sirve para regirtar el tiempo de cambio en our data
	SysStartTime datetime2 GENERATED ALWAYS AS  ROW  START NOT NULL,
	SysEndTime datetime2 GENERATED  ALWAYS  AS ROW  END  NOT NULL,
	PERIOD FOR  SYSTEM_TIME (SysStartTime, SysEndTime)
)
WITH (SYSTEM_VERSIONING=ON)


INSERT INTO Individuos(
	nanme1,
	nanme2,
	lastname1,
	lastname2
)VALUES(
	'Rodrigo',
	'Manuel',
	'Gutierrez',
	'García'
)

/*Check historic table */
select * from [dbo].[MSSQL_TemporalHistoryFor_354100302]

/*La tabla se ve afectada al detectar cambios solomente*/
	---Cambiar por javier todos los nombres que sean Miguel
Update Individuos SET nanme1='Javier' WHERE nanme1='Miguel'