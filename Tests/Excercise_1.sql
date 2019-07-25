USE NORTHWIND

/*
	1.    La organizaci�n necesita saber qui�n es su 
		  mejor cliente (El que m�s dinero ha generado en ventas), 
	      cree un script que devuelva esta informaci�n.

*/

select  Top 1 c.companyname, sum(od.quantity* od.unitprice)

from Customers as c inner join orders as o

on c.CustomerID=o.CustomerID

inner join [Order Details] as od

on o.OrderID=od.OrderID

group by c.CompanyName

order by sum(od.quantity* od.unitprice) desc