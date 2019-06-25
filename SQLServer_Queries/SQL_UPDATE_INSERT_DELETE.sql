USE Northwind
GO

--BASIC INSERT
insert into customers (CustomerID, CompanyName,ContactName,ContactTitle,Country)
values
(
	'VHCV1',
	'VISOAL',
	'García Rodrigo',
	'Ing',
	'México'
),
(
	'OAER',
	'Olvera',
	'Arely',
	'Ing',
	'Canada'
)
GO

--CREAR OBJ A PARTIR DE DATOS DE UNA TABLA

select * into customerDEMO from Customers
GO
select * from customerDEMO
GO
sp_help customerDEMO --Info del obj

--ERASE DATA FROM A TABLE
delete from customerDEMO

--UPDATE
update customers set city='garavirodland'
from customers where country = 'Guatemala'

--Actualizar datos de una tabla con respecto a otra.

--Basarse en el join
select c.customerid, c.companyname, c.country, o.orderid, o.OrderDate
from customers as c inner join orders as o 
on c.customerid = o.customerid
where c.Country='Brazil'
--Todas las fechas de los clientes de brazon actualicen su feacha la dia de hoy
update o set OrderDate =getdate()
from customers as c inner join orders as o 
on c.customerid = o.customerid
where c.Country='Brazil'