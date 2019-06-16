USE Empresa
GO

--TBALE 1
CREATE TABLE Category(
	categoryId INT IDENTITY (1,1) PRIMARY KEY,
	categoryName VARCHAR(200) not null UNIQUE,
	descriptions VARCHAR(500)
)
GO

--TABLE 2

CREATE TABLE Products(

	--Table2's fields
	ProductId INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(40) NOT NULL,
	SupplierID INT NULL,
	CategoryID INT NULL,
	QuantityPerUnit NVARCHAR (20) NULL,
	UnitPrice MONEY NULL CONSTRAINT DF_Products_UnitPrice DEFAULT(0),
	UnitsInStock SMALLINT NULL CONSTRAINT DF_Products_UnitInStock DEFAULT(0),
	UnitsOnOrder SMALLINT NULL CONSTRAINT DF_Products_UnitsOnOrder DEFAULT(0),
	ReorderLevel SMALLINT NULL CONSTRAINT DF_Products_ReorderLevel DEFAULT(0),
	---Table2's CONSTRAINTS
	CONSTRAINT PK_Porducts PRIMARY KEY CLUSTERED (ProductId), --Table2's primary key
	CONSTRAINT FK_Products_Catgorires FOREIGN KEY (CategoryId) --Table2's Foregin key 
	---Table2 is referenced with Category table (Table 1) with Category's CategoryId
	REFERENCES dbo.Category(CategoryId) ON UPDATE  CASCADE ON DELETE CASCADE, 
	CONSTRAINT CK_Products_UnitPrice CHECK (UnitPrice >= 0),
	CONSTRAINT CK_ReorderLevel CHECK (ReorderLevel >= 0),
	CONSTRAINT CK_UnitsInStock CHECK (UnitsInStock >= 0),
	CONSTRAINT CK_UnitOnOrder CHECK (UnitsOnOrder >= 0)
)
GO

---OTHER FORM TO CREATE CONSTRAINT

ALTER TABLE Products
ADD CONSTRAINT DF_ProductName DEFAULT('*****') FOR ProductName
GO


---DESABLE A RESTRICTION TEMPORALY

ALTER TABLE Products
NOCHECK CONSTRAINT CK_ReorderLevel

---AVELABLE A RESTRICTION
ALTER TABLE Products
CHECK CONSTRAINT CK_ReorderLevel


