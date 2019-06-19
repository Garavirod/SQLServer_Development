USE Northwind

---AGREGAR TABLAS VERSIONADAS A TABLAS EXIXTENTES
ALTER TABLE dbo.customers
ADD SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL DEFAULT GETUTCDATE(),
	SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL DEFAULT CAST('9999-12-31 23:59:59.9999999' AS DATETIME2),
	PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime)
GO

---Creamos un vinculo para la tabla dbo.customers y la que será su tabla de historial
ALTER TABLE dbo.customers
SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE=dbo.CustomerHistory))
GO


---Realizar cambios sobre la tabla costumers
UPDATE dbo.Customers SET  Country = 'USA' WHERE Country = 'Estados Unidos' 
UPDATE dbo.Customers SET  Country = 'Brazil' WHERE Country = 'Brasil' 

