---Crear una base de datos
Create database Empresa
on Primary
---Información para el pirmer archivo asociado al grupo primary
(name=EmpresaPrimary,filename="C:\Data\Empresa.mdf",
	size=50MB,filegrowth=25%) ---Tamaño inicial de la BD y su maximo creimiento (cuando el archivo se llene que tanto va a crecer

---Creamos el log de transacciones y le asocio un archivo

log on 
(name=EmpresaLog,filename="C:\Data\EmpresaLog.ldf",
	size=25MB,filegrowth=25%)

GO
---FILEGROUPS ADICIONALES
/*Son utiles para distriburir la carga en varios discos duros, para el ejemplo todo se deja en el folder "Data"  
porque se cuenta solo con un disco duro, el local, un servidor real debería usar discos duros separados.

REGLA.
El log de transacciones y los archivos de base de datos estén en discos diferentes.

*/

---Agregar gruos adicionales logico, en este caaso se llamará "Producción".
Alter database Empresa
add filegroup Produccion
go

---Para que el grupo Produccion sea logico debe asociarse un archivo
Alter Database Empresa 
add file (name=EmpresaProduccion,filename="C:\Data\EmpresaProduccion.ndf",
	size=25MB,filegrowth=25%) to filegroup Produccion ---Lo asociamos al grupo Produccion
go

---Cambiamos el filegroup predeterminado
/*
	Cualquier tabla que se cree se creará en el file gruop que se estableció 
	como predeterminado en este caso "Producción", es decir que las tablas creadoas se guqrda´ran el en el archivo 
	Empresa Produccion, sin embargo esto no siginifica que el archivo de primary se quedará vacio, 
	en él se guradaran la tablas del sistema
*/
Alter database Empresa
modify filegroup [Produccion] default
go

---CREACION DE TABLAS EN LA BASE DE DATOS  EMPRESA

/*
	Una tabla es la representación de un conjunto de entidades que tiene atributos,	
*/
Use Empresa
go

Create table cliente(
	---It'll be an identifier and will increment one by one, and not allows null,
	idCliente int identity (1,1) not null primary key, 
	nombre varchar(150),
	direccion varchar(300),
	telefono varchar(20) default('0000-0000'), --valor predeterminado
	email varchar(40),
	edad int,
	constraint ck_eddad check (edad>=18) ---Solo se permiten insercion de edades iagal o mayor a 18
)
go

--AGREGAR COLUMNAS A UNA TABLA
Alter table cliente
add categoria int not null
go

select * from cliente

--BORRAR TABLA 

DROP TABLE cliente
GO


---INSERTAR DATOS EN TABLA

INSERT INTO  cliente (nombre, direccion, email, edad)  VALUES
('Rodrigo García','Mi dirección','rgagmail@gmail.com',19)

INSERT INTO  cliente (nombre, direccion, email, edad)  VALUES
('Manuel gutierrez','Mi dirección2','rgagmail@gmail.com',29)