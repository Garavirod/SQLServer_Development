/*
	TABLAS TEMPORLAES

	Se componen en dos tablas

	1.- Datos actuales
	2.- Datos históricos

	Sceneries

		Consulta de datos a partir de un punto determiando en el tiempo
		Proporcianr normativas de auditoría.
		Implementacion y deeterminacion de dimensiones que cambian lentamente
		Reveritr una tabla al último estado bueno conocido
*/
---AL VREAR UNA TABLA NUEVA
USE Ciudadano
GO
CREATE TABLE dbo.Customer(
	CustomerID INT NOT NULL PRIMARY KEY CLUSTERED,
	PersonID INT NULL,
	StoreID INT NULL,
	TerritoryId INT NULL,
	AccountNumber nvarchar(25),
	---Period Columns 
	/*Uso exlusivo para el sistema para verificar el periodo de validez de cada fila cada vex que esta se modifica*/
	SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime)
)WITH (SYSTEM_VERSIONING = ON) ---Activamos la caracteristica SYSTEM_VERSIONING