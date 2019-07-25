USE NORTHWIND

/*
	1.    La organización necesita saber quién es su 
		  mejor cliente (El que más dinero ha generado en ventas), 
	      cree un script que devuelva esta información.

*/

select  Top 1 c.companyname, sum(od.quantity* od.unitprice)

from Customers as c inner join orders as o

on c.CustomerID=o.CustomerID

inner join [Order Details] as od

on o.OrderID=od.OrderID

group by c.CompanyName

order by sum(od.quantity* od.unitprice) desc