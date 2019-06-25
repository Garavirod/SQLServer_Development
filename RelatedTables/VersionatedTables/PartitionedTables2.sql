/*
	Reducing tables that already are partitioned or subdivide more data in tables that
	already are divided.
*/

USE MASTER
GO
CREATE DATABASE Corporation
ON PRIMARY (
	NAME = CorporationData,
	FILENAME = 'C:\Data\CorporationData.mdf', --HARD DISK 1 asociated to primary group
	SIZE=50MB,
	FILEGROWTH = 25%
) 

LOG ON (
	NAME = CorporationLog,
	FILENAME = 'C:\Data\CorporationLog.mdf', --HARD DISK 2 
	SIZE=25MB,
	FILEGROWTH = 25%
)
GO

--FILE GROUPS CREATION (Logical divisions that needs to have a file associated)

ALTER DATABASE Corporation
ADD FILEGROUP CorpoPart1
GO

ALTER DATABASE Corporation
ADD FILEGROUP CorpoPart2
GO

ALTER DATABASE Corporation
ADD FILEGROUP CorpoPart3
GO

--ADD FILES TO FILEGROUP

ALTER DATABASE Corporation
ADD FILE (
	NAME = Corporation1,
	FILENAME = 'C:\Data\Corporation1.ndf', --HARD DISK 1
	SIZE=50MB,
	FILEGROWTH = 25%
) TO FILEGROUP CorpoPart1
GO

ALTER DATABASE Corporation
ADD FILE (
	NAME = Corporation2,
	FILENAME = 'C:\Data\Corporation2.ndf', 
	SIZE=50MB,
	FILEGROWTH = 25%
) TO FILEGROUP CorpoPart2
GO

ALTER DATABASE Corporation
ADD FILE (
	NAME = Corporation3,
	FILENAME = 'C:\Data\Corporation3.ndf', 
	SIZE=50MB,
	FILEGROWTH = 25%
) TO FILEGROUP CorpoPart3
GO

/*
	Let's create a partitionated table and for that we need to create two elements first.

	* Partition function : It's for indicating the bunds of each partition (where it begeing and where ends)
	* Partition scheme: It's indicating the filegroup which file group has to go each partition. 
*/


--PARTITION FUNCTION
USE Corporation
CREATE PARTITION FUNCTION PARTITION_FUNCTION (BIGINT) --Type of data we're working
AS RANGE RIGHT FOR VALUES(500,1000) 
	

--SCHEMA PARTITION

CREATE PARTITION SCHEME SCHEME_PARTITION AS PARTITION PARTITION_FUNCTION
TO ( --Filegroups where it has to place each partition
	CorpoPart1,
	CorpoPart2,
	CorpoPart3
) 
GO

--Let's create the table
CREATE TABLE CLIENT (
	code BIGINT NOT NULL PRIMARY KEY,
	nam VARCHAR(50),
	surn VARCHAR(50),
) ON SCHEME_PARTITION (code) --column that is responsible to do division of schemes.
GO

--Verify if your partitioned table is working, for that insert data in it.

INSERT INTO CLIENT 
(
	code,
	nam,
	surn
)VALUES
(
	1,
	'Rodrigo',
	'García'
),
(
	2,
	'Manuel',
	'Gutierrez'
),
(
	501,
	'Jhon',
	'Wick'
),
(
	502,
	'Peter',
	'Parker'
),
(
	1001,
	'Matt',
	'Murdock'
),
(
	1002,
	'Arthur',
	'Doyle'
)
GO

--Verfify partition where are sotred these data.
SELECT code, nam, surn, $partition.PARTITION_FUNCTION(code) 
AS PART FROM CLIENT
GO
--Prtitioned index
CREATE NONCLUSTERED INDEX IDX_SURNAME --noncolustered index by surname.
ON CLIENT (surn)
ON SCHEME_PARTITION (code)	--Creating an index for each partition of hard disk
GO

INSERT INTO CLIENT 
(
	code,
	nam,
	surn
)VALUES
(
	2001,
	'Rodrigo',
	'García'
),
(
	2002,
	'Manuel',
	'Gutierrez'
),
(
	2501,
	'Jhon',
	'Wick'
),
(
	2502,
	'Peter',
	'Parker'
),
(
	3001,
	'Matt',
	'Murdock'
),
(
	3002,
	'Arthur',
	'Doyle'
)
GO

SELECT * FROM CLIENT
GO

/*
	Let's guess the data grew a lot and we need create another partition, 
	for example a 4th partition
*/

--NEW PARTITION 

ALTER DATABASE Corporation
ADD FILEGROUP CorpoPart4
GO

--ADD FILES TO FILEGROUP

ALTER DATABASE Corporation
ADD FILE (
	NAME = Corporation4,
	FILENAME = 'C:\Data\Corporation4.ndf', --HARD DISK 4
	SIZE=50MB,
	FILEGROWTH = 25%
) TO FILEGROUP CorpoPart4
GO

--MODIFY SCHEME AND THE FUNCTION
ALTER PARTITION  SCHEME SCHEME_PARTITION NEXT USED CorpoPart4 
GO
--New ubication of division for 4th partition 

ALTER PARTITION FUNCTION PARTITION_FUNCTION() SPLIT RANGE (2000) --From the code 2000 the data will go to the fourth partition.
--If we want marge some partitions

--Marge partition
ALTER PARTITION FUNCTION PARTITION_FUNCTION() MERGE RANGE (2000) --It delete the division from code 2000, 3 y 4 are joined 

--To create again  the division you have to modify the scheme and use the split function.
