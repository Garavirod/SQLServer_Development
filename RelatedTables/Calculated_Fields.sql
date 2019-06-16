USE Northwind
GO

/*
	Calculated column
	Virtual column that isn´t phisical sotored in the table
	unles we created we set the recerved word "percisted"
*/

CREATE TABLE OrdenDetalle
(
	orderDetail_id int  not null primary key,
	order_id int not null,
	product_id int not null,
	price decimal (7,2),
	quantity int,
	-- Virtual calcule  it isn't stored inside of table just if we write "PERSISTED" like that
	parcial as price * quantity PERSISTED --This allows that column stay in table
)
GO

--- Created the object, let's insert a data.
INSERT INTO OrdenDetalle(
	orderDetail_id,
	order_id,
	product_id,
	price,
	quantity
) VALUES (

	1,
	22,
	7,
	56.70,
	7
)
GO

---Let's visualizate the row affected

SELECT * FROM OrdenDetalle
GO
--- Let's take "Order Details" from Northwid to create inside of it a calculated field
SELECT * FROM [Order Details]
GO

ALTER TABLE [Order Details] 
ADD PARTIAL AS UnitPrice * Quantity ---It is a virtual column because we omited the recerved word "PERSISTED"

