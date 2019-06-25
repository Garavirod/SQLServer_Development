/*
	Compression of tables.

	It allows save space, a BDD can use less space in a recient version
	than an older version

	REDUCES THE SPACE USED BY A TABLE gaining more performance beacuse
	the reading needle will read in less space more quantity of data.

	Why do it?

	It Improves the performance of workloads that requires a big activity of E/S of disk
	Queries that access to zip data recover less pages.

	It can add to following objects:

	1.- Stored tables like heaps.
	2.- Stored tables like grouped indexes
	3.- Ungrouped indexes
	4.- Indexed views
	5.- Individual partitions
	6.- Special indexes


	PAGE COMPRESSION

	It adds a infromation structure of compression (CI) bellow page's header in each zip page
	It takes advantage of redundancy of data to claim space
		-Row compression
		-Prefix compression
		-Dictionary compression

	UNICODE COMPRESSION
	Based in Standard unicod alogorthm

	Considerations:

	- Compress tables with many columns with fixed data with big quantity of redundancy data
	- Compression increases CPU utilization
*/

USE Northwind
GO

--Check if a table is worth
EXECUTE sp_estimate_data_compression_savings
'dbo', --Schema
'Order Details',
NULL, --Index
NULL, --Specific partition
'PAGE'; --Type of compression ROW/PAGE
GO

sp_helpindex [Order Details]
GO

--Make row/page compression under a table to look how to change values.
ALTER TABLE dbo.[Order Details] REBUILD PARTITION= ALL
WITH (DATA_COMPRESSION = PAGE) --PAGE/ROW
GO