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
ON  schemaPArtition(surnname1)
GO


INSERT INTO Person(
	numOrder,
	numRegister,
	name1,
	surnname1
)VALUES (
			
)