use Northwind
go

/*
  Este objeto se esta creando dentro del esquema inormatica
  el cual tiene acceso el login y el user "userInormatica"
  es decir este script se hizo logueado como "userInormatica" desde otra sesión.
*/

create Table Cliente_demo1(
	codigo int  not null primary key,
	nombre varchar(50),
	apellido varchar(20)
)
go