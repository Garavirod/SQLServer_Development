---ESQUEMA 

/*
	SCHEMA

	Divisiones l�gicas dentro de una base de datos.

	Es un subconjunto de datos que se crea dentro de la base de datos.
	representa la configuraci�n l�gica de todo o parte de una base de datos relacional.
	Puede existir de dos formas: como representaci�n visual y como un conjunto de f�rmulas
	conocidas como restricciones de integridad que controlan una base de datos. 
	Estas f�rmulas se expresan en un lenguaje de definici�n de datos, tal como SQL. 
	Como parte de un diccionario de datos, un esquema de base de datos indica c�mo las entidades 
	que conforman la base de datos se relacionan entre s�, incluidas las tablas, las vistas, 
	los procedimientos almacenados y mucho m�s.

	El esquema predeterminado de la base de datos el DBO.
	Un usuario debe estar asociado a un esquema.
	El esquema debe ter un login que le perimite acceder al servidor.


	LOGGIN Y USERS

	SQL SERVER tiene una doble comporbaci�n de autenticidad.
	Para logearme a un servidor necesito de un LOGIN.
	Para loguearme a una BD necesito un USER. login>new_login>mapping

	Autenticidad por WINDOWS
	Al usuario del sistema oprativo le fue creado un login al sql server.
*/

---CREAR LOGGIN---
use master 
go
create login userInormatica with password = 's3cret147852'

---CREAR USER PARA LOGIN---

use Northwind
create user userInormatica for login userInormatica
with default_schema = Informatica --Si no se pone el determinado sera el DBO
go

---CREAR EL SCHEMA ASOCIADO A USER---
use Northwind go
create schema curso authorization userInormatica
go

---CREAR EL SCHEMA ASOCIADO A USER---
create schema Informatica authorization userInormatica
go

---DAR PERMISOS DE CREACION DE TABLA AL USER---
grant create table to userInormatica
go


---VISUALIZAR EL USARIO CON EL QUE ESTOY LOGUEADO---
SELECT USER


---CAMBIAR DE SESI�N COMO OTRO USUARIO---
execute as user =  'userInormatica'



---CREACION DE UNA TABLA---

create Table Empleado(
	codigo int  not null primary key,
	nombre varchar(50)
)
go


---REGRESAR AL USARIO DBO ---
revert
go

/*
 Los usario creados con el usario userInormatica
 quedr�n bajo el schema Informatica e "INformatica se vuelve el propietario del objeto, 
 de tal manera que aunque destruya el login y el user que lo cre� el schema quedar� vigente.
 y por lo tanto el ser� el propietario de los objetos.
 
 */