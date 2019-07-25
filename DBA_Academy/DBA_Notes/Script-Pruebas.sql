---------------------------------
--    Usar la Base de Datos    --
---------------------------------
USE Academia;


/*-----------------------------------------
Tabla de Paises
	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Restricción de Unicidad
	-- Llave Primaria

CREATE TABLE Paises
(
  Cod_Pais char(2) PRIMARY KEY CHECK (LEN(Cod_Pais)=2),
  Nombre varchar(50) NOT NULL,
  Cod_ISO3 char(3) NOT NULL UNIQUE CHECK (LEN(Cod_ISO3)=3),
  Cod_Telefonico smallint
);

------------------------------------------*/
INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3, Cod_Telefonico)
		VALUES     ('AR', 'Argentina', 'ARG', NULL);



--Violación del Tipo de Datos Cod_Pais char(2)
INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3, Cod_Telefonico)
		VALUES     ('AUS',    'Australia', 'AUS', 36);



--Anulación de la Llave Primaria
INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3, Cod_Telefonico)
		VALUES     (Null,    'Australia', 'AUS', 36);



--Duplicación de la Llave Primaria
INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3, Cod_Telefonico)
		VALUES     ('AR',     'Australia', 'AUS', 36);



/*	Restricción de Longitud de la Llave Primaria

	Cod_Pais char(2) PRIMARY KEY CHECK (LEN(Cod_Pais)=2),
*/
INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3, Cod_Telefonico)
		VALUES     ('A',     'Australia', 'AUS', 36)


/* Duplicación del Campo Cod_ISO3

  Cod_ISO3 char(3) NOT NULL UNIQUE CHECK (LEN(Cod_ISO3)=3),
*/
INSERT INTO Paises (Cod_Pais, Nombre,  Cod_ISO3, Cod_Telefonico)
		VALUES     ('AU', 'Australia', 'ARG',    36);


--Registro Correcto
INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3, Cod_Telefonico)
		VALUES     ('AU', 'Australia', 'AUS', 36);


--Distinto orden en las columnas
INSERT INTO Paises (Nombre,    Cod_ISO3, Cod_Pais, Cod_Telefonico)
		VALUES     ('Austria', 'AUT',      'AT',        40);


--Varios registros a la vez
INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3, Cod_Telefonico)
		VALUES     ('BO', 'Bolivia', 'BOL', 68),
				   ('BR', 'Brasil', 'BRA', Null),
				   ('CA', 'Canada', 'CAN', Null),
				   ('CL', 'Chile', 'CHL', Null),
				   ('CH', 'China', 'CHN', 156);


--Otra forma de Inserción
INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3, Cod_Telefonico)
SELECT 'CO', 'Colombia', 'COL', NULL;


--Otra forma de Inserción (Falta un dato)
INSERT INTO Paises (Cod_Pais, Nombre,      Cod_ISO3, Cod_Telefonico)
SELECT                'CR',   'Costa Rica', 'CRI';


--Pero ese datos acepta nulos
INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3)
SELECT 'CR', 'Costa Rica', 'CRI';


--Sin especificar los campos (No es buena Práctica)
INSERT INTO Paises 
SELECT 'HR', 'Croacia', 'HRV', 191;


--Formato de las Instrucciones...
INSERT INTO Paises SELECT 'DO', 'República Dominicana', 'DOM', null;

INSERT 
     INTO Paises SELECT 
	 'EC', 'Ecuador', 'ECU'
	 , 218;

-- Veamos nuestros Datos...
SELECT * FROM Paises;
/*
	Aunque parezcan ordenados por algún campo (Típicamente la Llave primaria)
	SQL NO garantiza el orden en el que se regresan las filas ya que:
	Los conjuntos NO tienen ORDEN!
*/


-- Veamos nuestros Datos Ordenados
SELECT	* 
FROM	Paises
ORDER BY Nombre;


-- El Campo de Ordenación no tiene porqué estar entre los campos Seleccionados
SELECT	Cod_Pais, Nombre  --Cod_ISO3 no está
FROM	Paises
ORDER BY Cod_ISO3 DESC;


-- Ordenamiento de valores Nulos
SELECT	*
FROM	Paises
ORDER BY Cod_Telefonico;

-- 13 Paises hasta ahora


--Atomicidad de la Transacción
INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3)
		VALUES     ('SV', 'El Salvador', 'SLV'),
				   ('FI', 'Finlandia', 'FIN'),
				   ('FR', 'Francia', 'FRA'),
				   ('DE', 'Alemania', 'DEU'),
				   ('GT', 'Guatemala', 'GTM'),
				   ('HN', 'Honduras', 'HND'),
				   ('HN', 'Hungría', 'HUN'); --Esta llave Primaria está duplicada!



--Revisemos nuestros paises de nuevo
SELECT * FROM Paises;
-- Los mismos 13 Paises... La transacción falló y NINGUNA inserción se realizó



--Transacción con diferentes Instrucciones
BEGIN TRY
	BEGIN TRAN
		INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3) VALUES ('SV', 'El Salvador', 'SLV');
		INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3) VALUES ('FI', 'Finlandia', 'FIN');
		INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3) VALUES ('FR', 'Francia', 'FRA');
		INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3) VALUES ('DE', 'Alemania', 'DEU');
		INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3) VALUES ('GT', 'Guatemala', 'GTM');
		INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3) VALUES ('HN', 'Honduras', 'HND');
		INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3) VALUES ('HN', 'Hungría', 'HUN'); --Esta llave Primaria está duplicada!
	COMMIT;
	PRINT 'Transacción Exitosa';
END TRY
BEGIN CATCH
	ROLLBACK;
	PRINT 'Transacción Fallida';
END CATCH;


--Revisemos nuestros paises de nuevo
SELECT * FROM Paises;
-- Los mismos 13 Paises... La transacción falló y NINGUNA inserción se realizó



--Arreglemos el registro malo y volvamos a ejecutar la transacción
BEGIN TRY
	BEGIN TRAN
		INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3) VALUES ('SV', 'El Salvador', 'SLV');
		INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3) VALUES ('FI', 'Finlandia', 'FIN');
		INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3) VALUES ('FR', 'Francia', 'FRA');
		INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3) VALUES ('DE', 'Alemania', 'DEU');
		INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3) VALUES ('GT', 'Guatemala', 'GTM');
		INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3) VALUES ('HN', 'Honduras', 'HND');
		INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3) VALUES ('HU', 'Hungría', 'HUN'); 
	COMMIT;
	PRINT 'Transacción Exitosa';
END TRY
BEGIN CATCH
	ROLLBACK;
	PRINT 'Transacción Fallida';
END CATCH


SELECT * FROM Paises;
-- Ahora hay 20 Paises!








/*-----------------------------------------
Tabla de Estados
	-- Llave Foránea
	   -- Acciones sobre la Relación

CREATE TABLE Estados
(
  Cod_Estado char(2) PRIMARY KEY CHECK (LEN(Cod_Estado)=2),
  Cod_Pais char(2) FOREIGN KEY REFERENCES Paises (Cod_Pais)
                   ON UPDATE CASCADE
                   ON DELETE CASCADE,
  Nombre varchar(50) NOT NULL,
  Cod_Telefonico smallint
);
------------------------------------------*/
--Creemos algunos estados

-- Albert Einstein nació en Ulm, Alemania en el estado de "Baden-Württemberg"
INSERT INTO Estados (Cod_Estado, Cod_Pais, Nombre) VALUES  ('UL', 'DE', 'Baden-Württemberg');

/* Edgar Codd nació en la Isla de Portland, UK en la Región de South West England
   El Cod_Pais 'GB' no existe y falla la Inserción de la LLave Foránea */
INSERT INTO Estados (Cod_Estado, Cod_Pais, Nombre) VALUES  ('SW', 'GB', 'South West England');


-- Insertemos primero el Pais:
INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3, Cod_Telefonico) VALUES  ('GB', 'Gran Bretaña', 'GBR', 44);

-- Repitamos la Inserción del Estado
INSERT INTO Estados (Cod_Estado, Cod_Pais, Nombre) VALUES  ('SW', 'GB', 'South West England');

--Sigamos con otros estados
INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3, Cod_Telefonico) VALUES  ('US', 'Estados Unidos', 'USA', 1);
INSERT INTO Estados (Cod_Estado, Cod_Pais, Nombre) VALUES  ('WI', 'US', 'Wisconsin');
INSERT INTO Estados (Cod_Estado, Cod_Pais, Nombre) VALUES  ('CA', 'US', 'California');

--Sigamos con otro estado. El estado Carabobo en Venezuela
INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3, Cod_Telefonico) VALUES  ('VE', 'Venezuela', 'VEN', 58);
INSERT INTO Estados (Cod_Estado, Cod_Pais, Nombre) VALUES  ('Y', 'VE', 'Carabobo');

--Error: 
--   Cod_Estado char(2) PRIMARY KEY CHECK (LEN(Cod_Estado)=2)
-- Eliminamos la Restricción
ALTER TABLE Estados
  DROP CONSTRAINT Len_Estado

-- Creamos la nueva Restricción
ALTER TABLE Estados
  ADD CONSTRAINT Len_Estado CHECK (LEN(Cod_Estado)>0)

--Insertamos de Nuevo
INSERT INTO Estados (Cod_Estado, Cod_Pais, Nombre) VALUES  ('Y', 'VE', 'Carabobo');

--Veamos el registro de Venezuela y el Estado Carabobo que acabamos de Crear
SELECT * FROM Paises WHERE Cod_Pais='VE';
SELECT * FROM Estados WHERE Cod_Pais='VE';


/*
	Probemos las Actualizaciones y Eliminaciones en Cascada
	Actualicemos el Código de Venezuela:
*/
UPDATE	Paises			--Modificar la Tabla Paises
SET		Cod_Pais = 'XX' --Poner el valor 'XX' el el Campo Cod_Pais
WHERE	Cod_Pais = 'VE';--En TODOS los registros que tengan Cod_Pais = 'VE'

--Verifiquemos el Cambio y la Actualización en Cascada
SELECT * FROM Paises WHERE Cod_Pais = 'XX';
SELECT * FROM Estados WHERE Cod_Estado='Y';


--Ahora la Eliminación en Cascada
DELETE Paises         --Borrar de la Tabla Paises
WHERE Cod_Pais = 'XX'; --TODOS los registros que tengan Cod_Pais = 'XX'


--Verifiquemos la Eliminación en Cascada
SELECT * FROM Estados;
--El estado Carabobo ya no está.







/*-----------------------------------------
Tabla de Academias
	-- Campos Auto-Generados

CREATE TABLE Academias
(
  Cod_Acad tinyint IDENTITY (1,1) PRIMARY KEY,
  Nombre varchar(50) NOT NULL,
  Fec_Fundacion Date NOT NULL,
  Numero varchar(10) NOT NULL,
  Calle varchar(30) NOT NULL,
  Ciudad varchar(30) NOT NULL,
  Estado char(2) FOREIGN KEY REFERENCES Estados (Cod_Estado)
                   ON UPDATE CASCADE
                   ON DELETE SET NULL,
  Cod_Postal varchar(10)
);

------------------------------------------*/

/*	El campo Cod_Acad es Manejado por el RDBMS... 
	No podemos asignarle un Valor Nosotros (Existen Excepciones) */
INSERT INTO Academias (Cod_Acad, Nombre, Fec_Fundacion, Numero, Calle, Ciudad, Estado, Cod_Postal)
VALUES                (1,        'Academia del Álgebra Relacional "Edgar F. Codd"', '20150301', '13528', 
					  'Avenida Datum', 'Relational City', 'WI', '12345');


INSERT INTO Academias (Nombre, Fec_Fundacion, Numero, Calle, Ciudad, Estado, Cod_Postal)
VALUES				  ('Academia del Álgebra Relacional "Edgar F. Codd"', '20150301', '13528', 
					   'Avenida Datum', 'Relational City', 'WI', '12345');


SELECT * FROM Academias


--El Estado 'CM' No existe
INSERT INTO Academias (Nombre, Fec_Fundacion, Numero, Calle, Ciudad, Estado, Cod_Postal)
VALUES ('Academia 3NF', '20160823', '5582', 'Calle Tupla con Avenida Unión', 'Ciudad de Méjico', 'CM', '54321')


SELECT * FROM Academias

--Insertemos otro Registro
INSERT INTO Academias (Nombre, Fec_Fundacion, Numero, Calle, Ciudad, Estado, Cod_Postal)
VALUES ('Einstein Academy', '20181217', '5582', 'Calle Relación', 'Ulm', 'UL', '00000')

--Veamos si fue exitosa:
SELECT * FROM Academias


/*--------------------------------------------------------------------------------------
Cod Acad = 3?   Porqué no 2 que es el valor siguiente?

	Para evitar posibles conflictos generados por la Concurrencia,
	El valor de los campos IDENTITY se incrementa ANTES de comenzar a hacer la Inserción
	y el valor obtenido NO puede volver a ser generado.
---------------------------------------------------------------------------------------*/

--Insertemos otro Registro pero pongamos Cod_Acad = 2

--Permita Insertar manualmente el valor del Campo IDENTITY de la Tabla Academias
SET IDENTITY_INSERT Academias ON; 

--Se debe nombrar EXPLICITAMENTE en campo en la Lista de Inserción
INSERT INTO Academias (Cod_Acad, Nombre, Fec_Fundacion, Numero, Calle, Ciudad, Estado, Cod_Postal)
			--Se debe suministrar el valor del campo
			VALUES	  (2	   , 'Academia 3NF', '20160823', '4623', 'Calle Tupla con Avenida Unión', 'Los Ángeles', 'CA', '99999');

--MUY IMPORTANTE regresar al Comportamiento normal
SET IDENTITY_INSERT Academias OFF; 

--Veamos si fue exitosa:
SELECT * FROM Academias;




-- Borremos una academia e insertemos de nuevo
DELETE	Academias
WHERE	Cod_Acad = 3;

INSERT INTO Academias (Nombre, Fec_Fundacion, Numero, Calle, Ciudad, Estado, Cod_Postal)
VALUES ('Einstein Academy', '20181217', '5582', 'Calle Relación', 'Ulm', 'UL', '00000');

--Veamos los Cambios:
SELECT * FROM Academias;

--Se mantiene el Comportamiento del Campo IDENTITY.







/*---------------------------------------------
Tabla de Departamentos

CREATE TABLE Departamentos
(
  Cod_Dpto Smallint IDENTITY (1,1) PRIMARY KEY,
  Academia tinyint NOT NULL 
			FOREIGN KEY REFERENCES Academias (Cod_Acad)
				ON UPDATE CASCADE
				ON DELETE CASCADE,
  Nombre varchar(30) NOT NULL,
  Director smallint  NOT NULL DEFAULT (-1)
			FOREIGN KEY REFERENCES Profesores (Cod_Prof)
				ON UPDATE NO ACTION
				ON DELETE NO ACTION,
  Fec_Inicio Date NOT NULL
);

---------------------------------------------*/

--No existe el Profesor -1
INSERT INTO Departamentos (Academia, Nombre, Director, Fec_Inicio)
				   VALUES (1, 'Base de Datos', -1, '20150301');

--Eliminemos la Restricción
ALTER TABLE Departamentos
	DROP FK__Departame__Direc__74AE54BC; --Buscar el Nombre de la Restricción

--Insertemos los Departamentos
INSERT INTO Departamentos (Academia, Nombre, Director, Fec_Inicio)
VALUES  (1, 'Base de Datos', -1, '20150301'),
		(1, 'Matemáticas', -1, '20150301'),
		(1, 'Ciencias', -1, '20150805'),
		(1, 'Modelado', -1, '20150715');

--Verifiquemos la Inserción
SELECT * FROM Departamentos;

--Creemos de Nuevo la Restricción
ALTER TABLE Departamentos
	ADD CONSTRAINT FK_Prof_Director --Le asignamos un Nombre si lo deseamos
		FOREIGN KEY (Director) 
		REFERENCES Profesores (Cod_Prof)
				ON UPDATE NO ACTION
				ON DELETE NO ACTION;

--Se chequea que los registros existentes cumplan con la Restricción


--Creemos de Nuevo la Restricción
ALTER TABLE Departamentos
	WITH NOCHECK   --- No chequear los Datos Existentes al crear esta Restricción
	ADD CONSTRAINT FK_Prof_Director 
		FOREIGN KEY (Director) 
		REFERENCES Profesores (Cod_Prof)
				ON UPDATE NO ACTION
				ON DELETE NO ACTION;






/*
	Antes de Continuar, vamos a necesitar nuevos paises y estados.

	--Necesidad típica del Sistema.

*/	













/************************************

	PROCEDIMIENTOS ALMACENADOS

************************************/
CREATE PROCEDURE Paises_Insertar
	@Cod_Pais char(2),
	@Nombre varchar(50),
	@Cod_ISO3 char(3),
	@Cod_Telefonico smallint = NULL
AS
BEGIN
	INSERT INTO Paises	( Cod_Pais,  Nombre,  Cod_ISO3,  Cod_Telefonico) 
				VALUES	(@Cod_Pais, @Nombre, @Cod_ISO3, @Cod_Telefonico);

END;


--INSERT INTO Paises (Cod_Pais, Nombre, Cod_ISO3) VALUES  ('TW', 'Taiwan', 'TWN');
EXEC Paises_Insertar
	@Cod_Pais ='', --'T'
	@Nombre = 'Taiwan',
	@Cod_ISO3 = 'TWN'

--Problema 1:
	--Error 547 -->CHECK

EXEC Paises_Insertar
	@Cod_Pais = 'TWN', --Es muy largo... Cod_Pais CHAR(2)
	@Nombre = 'Taiwan',
	@Cod_ISO3 = 'TWN'
	
SELECT * FROM Paises WHERE Nombre = 'Taiwan';

/*
CREATE PROCEDURE Paises_Insertar
	@Cod_Pais char(2),
*/

EXEC Paises_Insertar
	@Cod_Pais = 'TW', --Ya existe
	@Nombre = 'Taiwan',
	@Cod_ISO3 = 'TWN'

--Problema 3:
	--Error 2627 --> PRIMARY KEY

EXEC Paises_Insertar
	@Cod_Pais = 'XX', 
	@Nombre = 'Taiwan',
	@Cod_ISO3 = 'TWN' --Ya existe

--Problema 4:
	--Error 2627 --> UNIQUE

ALTER PROCEDURE Paises_Insertar
	@Cod_Pais char(2),
	@Nombre varchar(50),
	@Cod_ISO3 char(3),
	@Cod_Telefonico smallint = NULL
AS
BEGIN
	DECLARE @Msg NVARCHAR (4000),
			@Err INT;
	BEGIN TRY
		INSERT INTO Paises	( Cod_Pais,  Nombre,  Cod_ISO3,  Cod_Telefonico) 
					VALUES	(@Cod_Pais, @Nombre, @Cod_ISO3, @Cod_Telefonico);
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR;

		IF @Err = 547
			SET @Msg  = 'Los datos Ingresados, son Incorrectos';

		ELSE IF @Err = 2627
				SET @Msg  = 'El País ya existe';

		ELSE 		 
			SET @Msg= ERROR_MESSAGE();

		--THROW 51000, @Msg, 1;
		PRINT @Msg;

		RETURN -1;
	END CATCH

	RETURN 0;
END;


/*********************************************************
     DISTINTAS FORMAS DE HACER LAS COSAS
*********************************************************/
CREATE PROCEDURE Estados_Insertar
	@Cod_Estado char(2),
	@Cod_Pais char(2),
	@Nombre varchar(50),
	@Cod_Telefonico smallint = NULL
AS
BEGIN
	INSERT INTO Estados ( Cod_Estado,  Cod_Pais,  Nombre,  Cod_Telefonico)
				VALUES  (@Cod_Estado, @Cod_Pais, @Nombre, @Cod_Telefonico);
END;



CREATE PROCEDURE Estados_Modificar
	@Cod_Estado char(2),
	@Cod_Pais char(2),
	@Nombre varchar(50),
	@Cod_Telefonico smallint = NULL
AS
BEGIN
	UPDATE	Estados 
	SET		Cod_Pais = @Cod_Pais, 
			Nombre = @Nombre, 
			Cod_Telefonico = @Cod_Telefonico
	WHERE	Cod_Estado = @Cod_Estado
END;




CREATE PROCEDURE Estados_Eliminar
	@Cod_Estado char(2)
AS
BEGIN
	DELETE	Estados
	WHERE	Cod_Estado = @Cod_Estado;
END;




CREATE PROCEDURE Estados_Consultar
	@Cod_Pais char(2) = NULL,
	@Cod_Estado char(2)= NULL
AS
BEGIN
	SELECT	P.Cod_Pais, P.Nombre as Pais,
			E.Cod_Estado, E.Nombre, E.Cod_Telefonico
	FROM	Estados E
			JOIN Paises P ON P.Cod_Pais = E.Cod_Pais
	WHERE	(@Cod_Pais IS NULL OR P.Cod_Pais = @Cod_Pais) AND
			(@Cod_Estado IS NULL OR E.Cod_Estado = @Cod_Estado);
END;





/**********************************************
  NO ES LO MAS ACONSEJABLE
***********************************************/
CREATE PROCEDURE Estados_CRUD --CREATE, READ, UPDATE, DELETE
	@Accion		char(1), --Create, Read, Update, Delete
	@Cod_Estado char(2) = NULL,
	@Cod_Pais	char(2) = NULL,
	@Nombre		varchar(50)=NULL,
	@Cod_Telefonico smallint = NULL
AS
BEGIN
	IF @Accion = 'C'
		INSERT INTO Estados (Cod_Estado, Cod_Pais, Nombre, Cod_Telefonico)
					VALUES  (@Cod_Estado, @Cod_Pais, @Nombre, @Cod_Telefonico);
	
	ELSE IF @Accion = 'R'
		SELECT	P.Cod_Pais, P.Nombre as Pais,
				E.Cod_Estado, E.Nombre, E.Cod_Telefonico
		FROM	Estados E
				JOIN Paises P ON P.Cod_Pais = E.Cod_Pais
		WHERE	(@Cod_Pais IS NULL OR P.Cod_Pais = @Cod_Pais) AND
				(@Cod_Estado IS NULL OR E.Cod_Estado = @Cod_Estado);

	ELSE IF @Accion = 'U'
		UPDATE	Estados 
		SET		Cod_Pais = @Cod_Pais, 
				Nombre = @Nombre, 
				Cod_Telefonico = @Cod_Telefonico
		WHERE	Cod_Estado = @Cod_Estado

	ELSE IF @Accion = 'D'
		DELETE	Estados
		WHERE	Cod_Estado = @Cod_Estado;

	ELSE
		PRINT 'Acción Inválida';
END;


EXEC Estados_Insertar 'BA', 'TW', 'Basin';

EXEC Estados_Consultar @Cod_Pais = 'TW';

EXEC Estados_Consultar @Cod_Estado = 'BA';

EXEC Estados_Consultar;

EXEC Estados_Eliminar 'BA';

EXEC Estados_CRUD 
	@Accion		='C', --Create
	@Cod_Estado = 'BA',
	@Cod_Pais	= 'TW',
	@Nombre		= 'Basin'


EXEC Estados_CRUD 
	@Accion		='X', --No existe
	@Cod_Estado = 'BA',
	@Cod_Pais	= 'TW',
	@Nombre		= 'Basin'



-----Agregar Paises y estados que necesitamos----------

INSERT INTO Paises (Cod_Pais, Cod_ISO3, Nombre, Cod_Telefonico)
VALUES	('ES','ESP','España',34),
		('PL','PLN','Polonia',48),
		('ME','MEX','México',52),
		('RU','RUS','Rusia',7),
		('IT','ITA','Italia',39);

INSERT INTO Estados(Cod_Estado, Cod_Pais, Nombre, Cod_Telefonico)
VALUES	('CT','ES','Cataluña',NULL),
		('MA','ES','Madrid',NULL),
		('SO','PL','Sochaczew',NULL),
		('WA','PL','Warsaw',NULL),
		('DU','ME','Durango',NULL),
		('UM','RU','Montes Urales',NULL),
		('BO','IT','Boloña',NULL),
		('AU', 'FR','Auvergne',NULL),
		('LI', 'GB','Lincolnshire',NULL),
		('ED', 'GB','Edinbugrh',NULL),
		('NY', 'US','Nueva York',NULL);


SELECT * from Paises;
SELECT * from Estados;


/*-----------------------------------------
Tabla de Profesores


CREATE TABLE Profesores
(
  Cod_Prof smallint IDENTITY (1,1) PRIMARY KEY,
  SSN varchar(11) UNIQUE CHECK (LEN(SSN)=11),
  Nombre varchar(30) NOT NULL,
  Apellido varchar(30) NOT NULL,
  Numero varchar(10) NOT NULL,
  Calle varchar(30) NOT NULL,
  Ciudad varchar(30) NOT NULL,
  Estado char(2) FOREIGN KEY REFERENCES Estados (Cod_Estado)
                   ON UPDATE CASCADE
                   ON DELETE SET NULL,
  Cod_Postal varchar(10) NOT NULL,
  Telefono varchar(15),
  Sueldo money DEFAULT (0)
);

------------------------------------------*/


INSERT INTO Profesores (SSN,			Nombre,	 Apellido, Numero, Calle,		   Ciudad,           Estado,  Cod_Postal, Telefono, Sueldo)
				VALUES ('12345678901', 'Blaise', 'Pascal', '1623', 'Rue Theorem', 'Clermont-Ferand', 'AU',    '55645',    NULL,     1623);


INSERT INTO Profesores (SSN,			Nombre,  Apellido, Numero,  Calle,           Ciudad,    Estado, Cod_Postal, Sueldo)
				VALUES ('10987654321', 'Raymond', 'Boyce', '1974', 'Relational Way', 'NewYork', 'NY',    '10001',   2500);


/***********************************************
  No sabemos el Cod_Prof después de Insertar
***********************************************/
CREATE PROCEDURE Profesores_Insertar
	@SSN varchar(11),
	@Nombre varchar(30),
	@Apellido varchar(30),
	@Numero varchar(10),
	@Calle varchar(30),
	@Ciudad varchar(30),
	@Estado char(2),
	@Cod_Postal varchar(10),
	@Telefono varchar(15) = NULL,
	@Sueldo money = 0
AS
BEGIN
	DECLARE @Cod_Prof smallint;

	INSERT INTO Profesores 
		( SSN,  Nombre,  Apellido,  Numero,  Calle,  Ciudad,  Estado,  Cod_Postal, Telefono, Sueldo)
	VALUES 
		(@SSN, @Nombre, @Apellido, @Numero, @Calle, @Ciudad, @Estado, @Cod_Postal, @Telefono, @Sueldo);

	SET @Cod_Prof = SCOPE_IDENTITY(); --último valor generado para una columna IDENTITY dentro del ámbito donde se invocó la función 

									-- @@IDENTITY --último valor generado para una columna IDENTITY (Pero no se limita al ámbito actual)
												  --Si la Instrucción de Inserción dispara un Trigger que a su vez genera un valor para
												  --una columna IDENTITY, se retornará el valor creado en el Trigger.
	
	SELECT @Cod_Prof as Codigo;
	
END;

EXEC Profesores_Insertar
	@SSN		= '54328979011', 
	@Nombre		= 'Isaac', 
	@Apellido	= 'Newton', 
	@Numero		= '84', 
	@Calle		= 'Gravitational Way', 
	@Ciudad		= 'Woolsthorpe', 
	@Estado		= 'LI', 
	@Cod_Postal = 'A6K-9U6',
	@Sueldo		=  2000;


/***********************************************
  Retornar como Resultado del SP
***********************************************/
ALTER PROCEDURE Profesores_Insertar
	@SSN varchar(11),
	@Nombre varchar(30),
	@Apellido varchar(30),
	@Numero varchar(10),
	@Calle varchar(30),
	@Ciudad varchar(30),
	@Estado char(2),
	@Cod_Postal varchar(10),
	@Telefono varchar(15) = NULL,
	@Sueldo money = 0
AS
BEGIN
	DECLARE @Cod_Prof smallint = -1;

	INSERT INTO Profesores 
		( SSN,  Nombre,  Apellido,  Numero,  Calle,  Ciudad,  Estado,  Cod_Postal, Telefono, Sueldo)
	VALUES 
		(@SSN, @Nombre, @Apellido, @Numero, @Calle, @Ciudad, @Estado, @Cod_Postal, @Telefono, @Sueldo);

	SET @Cod_Prof = SCOPE_IDENTITY(); --último valor generado para una columna IDENTITY dentro del ámbito donde se invocó la función 

									-- @@IDENTITY --último valor generado para una columna IDENTITY (Pero no se limita al ámbito actual)
												  --Si la Instrucción de Inserción dispara un Trigger que a su vez genera un valor para
												  --una columna IDENTITY, se retornará el valor creado en el Trigger.

	RETURN @Cod_Prof;
	
END;



DECLARE @Resultado INT;

EXEC @Resultado = Profesores_Insertar
					@SSN		= '11223344556', 
					@Nombre		= 'James', 
					@Apellido	= 'Maxwell', 
					@Numero		= '1897', 
					@Calle		= 'Magnetism St', 
					@Ciudad		= 'Edinburgh', 
					@Estado		= 'ED', 
					@Cod_Postal = '8Y8-021',
					@Sueldo		=  1536.1234;

PRINT @Resultado;



/***********************************************
  Retornar en un Parámetro de Salida.
***********************************************/
ALTER PROCEDURE Profesores_Insertar
	@SSN varchar(11),
	@Nombre varchar(30),
	@Apellido varchar(30),
	@Numero varchar(10),
	@Calle varchar(30),
	@Ciudad varchar(30),
	@Estado char(2),
	@Cod_Postal varchar(10),
	@Telefono varchar(15) = NULL,
	@Sueldo money = 0,
	@Cod_Prof smallint OUTPUT -->Parámetro de Salida.
AS
BEGIN
	SET NOCOUNT ON; --it desn't show how many rows were affected

	INSERT INTO Profesores 
		( SSN,  Nombre,  Apellido,  Numero,  Calle,  Ciudad,  Estado,  Cod_Postal, Telefono, Sueldo)
	VALUES 
		(@SSN, @Nombre, @Apellido, @Numero, @Calle, @Ciudad, @Estado, @Cod_Postal, @Telefono, @Sueldo);

	SET @Cod_Prof = SCOPE_IDENTITY(); --último valor generado para una columna IDENTITY dentro del ámbito donde se invocó la Instrucción. 

									-- @@IDENTITY --último valor generado para una columna IDENTITY (Pero no se limita al ámbito actual)
												  --Si la Instrucción de Inserción dispara un Trigger que a su vez genera un valor para
												  --una columna IDENTITY, se retornará el valor creado en el Trigger.
END;

--How to get the output parameter?
DECLARE @Resultado INT;

EXEC Profesores_Insertar
		@SSN		= '65654545789', 
		@Nombre		= 'Peter', 
		@Apellido	= 'Chen', 
		@Numero		= 'H87', 
		@Calle		= 'Diagram ER Ln', 
		@Ciudad		= 'Taichung', 
		@Estado		= 'BA', 
		@Cod_Postal = '55-A3',
		@Cod_Prof	= @Resultado OUTPUT;

PRINT @Resultado;



--Veamos nuestros Profesores
SELECT * FROM Profesores;


--Asignemos algunos directores de Departamento
UPDATE	Departamentos
SET		Director = 1 --Pascal
WHERE	Cod_Dpto = 3; --Matemáticas

--y si intentamos violar la LLave Foránea?
UPDATE	Departamentos
SET		Director = 8 --??
WHERE	Cod_Dpto = 5;

SELECT * FROM Departamentos;



/*---------------------------------------------------
Tabla de Relación entre Departamentos y Profesores
   --Falla en la Creación de la Llave Foránea 
     con Departamentos

CREATE TABLE Dptos_Profesores
(
  Cod_Dpto Smallint NOT NULL
	FOREIGN KEY REFERENCES Departamentos (Cod_Dpto)
	    ON UPDATE CASCADE
		ON DELETE CASCADE,
  Cod_Prof smallint NOT NULL
	FOREIGN KEY REFERENCES Profesores (Cod_Prof)
	    ON UPDATE CASCADE
		ON DELETE CASCADE
);

---------------------------------------------------*/

SELECT * FROM Departamentos
SELECT * FROM Profesores

INSERT INTO Dptos_Profesores (Cod_Dpto, Cod_Prof)
					VALUES	(   2,         2), --Base de Datos --> Boyce
							(   3,         1), --Matemáticas --> Pascal
							(   3,         3), --Matemáticas --> Newton
							(   4,         4)  --Ciencias --> Maxwell
		
--Just when the tables are small
CREATE PROCEDURE Departamentos_Asignar_Profesores
	@Departamento smallint,
	@Profesor smallint

	/*
	Valores retorno:
	 0=Ok
	-1=Departamento no Existe
	-2=Profesor No Existe.
	*/

AS
BEGIN
	DECLARE @Retorno INT = 0;
	IF NOT EXISTS (SELECT * FROM Departamentos WHERE Cod_Dpto = @Departamento)
		SET @Retorno = -1;
	
	ELSE IF NOT EXISTS (SELECT * FROM Profesores WHERE Cod_Prof = @Profesor)
		SET @Retorno = -2;
	
	ELSE
		INSERT INTO Dptos_Profesores VALUES (@Departamento, @Profesor);

	RETURN @Retorno;

END


DECLARE @Retorno INT;

EXEC @Retorno = Departamentos_Asignar_Profesores 
		@Departamento = 5, --Modelado 
		@Profesor	  = 5;  --Chen

PRINT @Retorno;


DECLARE @Retorno INT;

EXEC @Retorno = Departamentos_Asignar_Profesores 
		@Departamento = 10, --No existe el Departamento
		@Profesor	  = 5;  --Chen

PRINT @Retorno;


DECLARE @Retorno INT;

EXEC @Retorno = Departamentos_Asignar_Profesores 
		@Departamento = 2, --Bases de Datos
		@Profesor	  = 15; --No existe el Profesor

PRINT @Retorno;


SELECT * FROM Dptos_Profesores;


/*---------------------------------------------------
Tabla de Materias
  
CREATE TABLE Materias
(
  Cod_Materia Smallint IDENTITY (1,1) PRIMARY KEY,
  Nombre varchar(30) NOT NULL,
  Electiva bit NOT NULL DEFAULT (0),
  Peso tinyint NOT NULL DEFAULT (1) CHECK (Peso > 0)
);
/*---------------------------------------------------
  Creamos la Restricción, pero a nivel de la Tabla
---------------------------------------------------*/
ALTER TABLE Materias
 ADD CONSTRAINT CheckPesoMateria
	CHECK ( Peso <= (CASE Electiva WHEN 0 THEN 6 ELSE 2 END));
---------------------------------------------------*/

INSERT INTO Materias (Nombre,Electiva, Peso) 
VALUES	('Modelo de Datos', 0, 5),
		('Teoría de Conjuntos', 1, 2),
		('Matemática I', 0, 5),
		('Matemática II', 0, 6),
		('Física I', 0, 4),
		('Física II', 0, 3),
		('Diseño de Bases de Datos', 0, 6),
		('Normalización', 0, 6);

--Tratemos de violar le Restricción de la Tabla:
--Una Materia Electiva debe tener un Peso <=2
INSERT INTO Materias (Nombre        ,Electiva, Peso) 
			VALUES	 ('Diagramación', 1      , 3);





/*---------------------------------------------------
Tabla de Cursos
	--Campo Calculado
	--Restricción Aula Ocupada: Función
---------------------------------------------------*/

---Pascal, Matemática I, aula 100
INSERT INTO Cursos 
		(Cod_Prof, Cod_Materia, Aula, Hora_Inicio, Hora_Fin)
VALUES	(1		 , 3		  , 100 , '9:00'     , '10:45')


--Veamos nuestro Campo Calculado
SELECT * FROM Cursos


--Tratemos de Violar las Restricciones
---Boyce, Diseño de Bases de Datos, aula 100
INSERT INTO Cursos 
		(Cod_Prof, Cod_Materia, Aula, Hora_Inicio, Hora_Fin)
VALUES	(2		 , 7		  , 100 , '11:00'     , '9:45'); --Hora_Inicio > Hora_Fin


--El Aula 100 está Ocupada de 9:00 a 10:45.  Veamos los 3 casos que tomamos en cuenta


--1) @Inicio BETWEEN Hora_Inicio AND Hora_Fin OR
INSERT INTO Cursos	(Cod_Prof, Cod_Materia, Aula, Hora_Inicio, Hora_Fin)
VALUES				(2		 , 7		  , 100 , '10:00'     , '11:45'); 

-- 2) @Fin BETWEEN Hora_Inicio AND Hora_Fin OR
INSERT INTO Cursos	(Cod_Prof, Cod_Materia, Aula, Hora_Inicio, Hora_Fin)
VALUES				(2		 , 7		  , 100 , '08:45'     , '10:15'); 

--3 ) (@Inicio <= Hora_Inicio AND @Fin >= Hora_Fin)
INSERT INTO Cursos	(Cod_Prof, Cod_Materia, Aula, Hora_Inicio, Hora_Fin)
VALUES				(2		 , 7		  , 100 , '08:45'     , '11:00'); 

--Insertemos en otra Aula
INSERT INTO Cursos	(Cod_Prof, Cod_Materia, Aula, Hora_Inicio, Hora_Fin)
VALUES				(2		 , 7		  , 200 , '10:00'     , '11:45'); 


SELECT * FROM Cursos

--Inactivemos el Curso y probemos la restricción de nuevo
UPDATE	Cursos
SET		Activo = 0
WHERE	Cod_Curso = 1

SELECT * FROM Cursos

--Newton, Matemática 2, Aula 100 que ahora ya está disponible.
INSERT INTO Cursos	(Cod_Prof, Cod_Materia, Aula, Hora_Inicio, Hora_Fin)
VALUES				(3		 , 4		  , 100 , '10:00'     , '11:45'); 

SELECT * FROM Cursos WHERE Aula='100'


--Y si activamos de nuevo el Curso??
UPDATE	Cursos
SET		Activo = 1
WHERE	Cod_Curso = 1

--No hubo problemas!! Pero el aula estaba ocupada.  No debió permitirse esa modificación.

SELECT * FROM Cursos WHERE Aula='100'

-- Volvamos a Inactivarlo y veamos cómo resolver ese problema...
UPDATE	Cursos
SET		Activo = 0
WHERE	Cod_Curso = 1

---Hagamos un Trigger
CREATE TRIGGER trg_AulaOcupada
ON Cursos
FOR UPDATE
AS
BEGIN
	IF EXISTS	(   --Si existe algún registro Entre
					SELECT	* 
					FROM	Inserted 
							-- Todos los registros Insertados a los que se modificó el campo Activo = 1
					WHERE	UPDATE (Activo) AND Activo = 1 AND  
							--y que el aula esté ocupada
							dbo.fn_Aula_Ocupada (Cod_Curso, Aula, Hora_Inicio, Hora_Fin)=1
				)
		ROLLBACK; --Abortar la Transacción
END;

---Probemos tratando de activarlo de nuevo
UPDATE	Cursos
SET		Activo = 1
WHERE	Cod_Curso = 1;

SELECT * FROM Cursos WHERE Aula='100';

---Cambiemos el horario a ver...
UPDATE	Cursos
SET		Activo = 1,
		Hora_Inicio = '8:30', 
		Hora_Fin = '9:55'
WHERE	Cod_Curso = 1;

--Nuestras Restricciones funcionan!
SELECT * FROM Cursos WHERE Aula='100';



/*---------------------------------------------------
Tabla de Libros


CREATE TABLE Libros
(
  Cod_Libro int IDENTITY (1,1) PRIMARY KEY,
  ISBN char(13) NOT NULL UNIQUE CHECK (LEN(ISBN)=13 AND ISNUMERIC(ISBN)=1),
  Titulo varchar(100) NOT NULL,
  Autor varchar(100) NOT NULL,
  Año smallint,
  Edicion char(3),
  Editorial varchar(100),
  Paginas smallint
);

---------------------------------------------------*/
--   Tratemos de Insertar un ISBN que no es numérico:
INSERT INTO Libros (ISBN, Titulo, Autor, Año, Edicion, Editorial, Paginas)
VALUES ('ISBN567890123','ISBN no numérico','Autor', 1111,'I','Editorial',0);

--Insertemos Libros....
INSERT INTO Libros (ISBN, Titulo, Autor, Año, Edicion, Editorial, Paginas)
VALUES 
('7740058756488','Aritmética Básica','Baldor', 1890,'I','Datum',154),
('3557541254987','Binarios. El futuro.','Hikes', 1978,'I','Poseidon',233),
('3121565587168','Codd y el Modelo Relacional','Stevens',1988,'II','Datum',254),
('9872551564836','Del dato a la Base de Datos','Rommel',2005,'V','Relational',105),
('2568556548901','Dogmas Informáticos','Astudillo',2011,'I','Poseidon',55),
('1128993256487','Filas y Columnas','Bachman',2003,'I','Datum',203),
('1864124456897','Generando tuplas','King',1984,'IV','Relational', 168),
('5568668457956','Grandes Bancos de Datos','Codd',1971,'III','Relational', 334),
('3251895578981','Hilos transaccionales','Ruiz',2001,'II','Datum', 158),
('4545146548210','Joins. La enciclopedia','Boyce',1973,'II','Poseidon',221),
('2231811112345','Límites Relacionales','Chen',1975,'V','Relational', 402),
('5566112356748','Lo más preciado. El Dato','Fergusson',2004,'I','Datum', 355),
('2250189875478','Manejadores Inteligentes','Martínez',1996,'III','Datum',172),
('5561126547891','Operadores Relacionales','Plank',1965,'IV','Relational', 380),
('6394741654852','Uniones Naturales','Raymond',2002,'I','Datum',98),
('1298457568423','Vistas Indexadas','Rochelier',2015,'II','Poseidon',163);


SELECT * FROM Libros;


/*---------------------------------------------------
Tabla de Relación Cursos y Libros

CREATE TABLE Cursos_Libros
(
  Cod_Curso int NOT NULL
		FOREIGN KEY REFERENCES Cursos (Cod_Curso)
		    ON UPDATE CASCADE
			ON DELETE CASCADE,
  Cod_Libro int NOT NULL
		FOREIGN KEY REFERENCES Libros (Cod_Libro)
		    ON UPDATE CASCADE
			ON DELETE CASCADE
);

---------------------------------------------------*/

--Veamos las Materias de los Cursos
SELECT	* 
FROM	Cursos C
		JOIN Materias M ON M.Cod_Materia = C.Cod_Materia

SELECT * from Libros


----NO ES LA FORMA RECOMENDADA DE HACERLO--------------
--
-- INSERT INTO Cursos_Libros (Cod_Curso, Cod_Libro)

INSERT INTO Cursos_Libros
VALUES	(1,2),  --Curso 1: Matemática I					Aritmética Básica
		(6,5),  --Curso 6: Diseño de Bases de Datos		Del dato a la Base de Datos
		(6,7),  --Curso 6: Diseño de Bases de Datos		Filas y Columnas
		(6,9),  --Curso 6: Diseño de Bases de Datos		Grandes Bancos de Datos
		(7,12); --Curso 7: Matemática II				Límites Relacionales

SELECT * FROM Cursos_Libros

--Falta Llave Primaria!!!
--Insertar tupla Repetida:
INSERT INTO Cursos_Libros VALUES	(1,2)  

---Modelo Relacional: Una Relación no puede tener tuplas Repetidas
SELECT * FROM Cursos_Libros ORDER BY Cod_Curso


--Creemos la Llave Primaria
ALTER TABLE Cursos_Libros 
	ADD PRIMARY KEY (Cod_Curso, Cod_Libro);

---Borremos una de las repeticiones del Registro
DELETE	TOP(1) Cursos_Libros 
WHERE	Cod_Curso = 1 AND 
		Cod_Libro = 2


--Creemos la Llave Primaria de Nuevo
ALTER TABLE Cursos_Libros 
	ADD PRIMARY KEY (Cod_Curso, Cod_Libro);




/*---------------------------------------------------
Tabla de Alumnos

CREATE TABLE Alumnos
(
  Cod_Alumno int IDENTITY (1,1) PRIMARY KEY,
  SSN varchar(11) UNIQUE CHECK (LEN(SSN)=11),
  Nombre varchar(30) NOT NULL,
  Apellido varchar(30) NOT NULL, IF YOU USE unicode the GBD WILL CAST THE VALUE TO VARCHAR
  Numero varchar(10) NOT NULL,
  Calle varchar(30) NOT NULL,
  Ciudad varchar(30) NOT NULL,
  Estado char(2) FOREIGN KEY REFERENCES Estados (Cod_Estado)
                   ON UPDATE CASCADE
                   ON DELETE SET NULL,
  Cod_Postal varchar(10) NOT NULL,
  Telefono varchar(15),
  Fecha_Nac Date,
  Lugar_Nac varchar(50)
);
---------------------------------------------------*/
INSERT INTO Alumnos (SSN,			Nombre,		Apellido,	Numero, Calle,				Ciudad,				Estado, Cod_Postal, Telefono, Fecha_Nac,   Lugar_Nac)
			VALUES	('00000000000', 'Salvador',	'Dalí'	,	'000', 'San Fernando',		'Figueres',			'CT',	'00000',	'000000', '19040511', 'Figueres'),
					('11111111111', 'Frédéric',	'Chopin',	'111', 'Gmina',				'Żelazowa Wola',	'SO',	'11111',	'111111', '18100301', 'Duchy Warsaw'),
					('22222222222', 'Miguel',	'Cervantes','222', 'El Quijote',		'Madrid',			'MA',	'22222',	'222222', '15470929', 'Alcalá de Henares'),
					('33333333333', 'Albert',	'Einstein', '333', 'Strughist Rd',		'Ulm',				'UL',	'33333',	'333333', '18790314', 'Württemberg'),
					('44444444444', 'Pancho',	'Villa'	,	'444', 'Centauro del Norte','San Juan del Río',	'DU',	'44444',	'444444', '19230720', 'La Coyotada'),
					('55555555555', 'Marie',	'Curie'	,	'555', 'Lubin',				'Radium',			'WA',	'55555',	'555555', '18671107', 'Kingdom'),
					('66666666666', 'Anatoli',	'Kárpov',	'666', 'Fide',				'Zlatoust',			'UM',	'66666',	'666666', '19510523', 'Chelyabinsk Oblast'),
					('77777777777', 'Guillermo','Marconi',	'777', 'Radio St',			'Boloña',			'BO',	'77777',	'777777', '18740425', 'Palazzo Marescalchi'),
					('88888888888', 'Orson',	'Welles',	'888', 'The War of Worlds',	'Kenosha',			'WI',	'88888',	'888888', '19150506', 'Kenosha'),
					('99999999999', 'Edgar',	'Codd',		'999', 'Relational Way',	'Fortuneswell',		'SW',	'99999',	'999999', '19230819', 'Isle of Portland');


--Veamos Nuestros Alumnos
SELECT * FROM Alumnos;


--Veamos un dato en especial:
SELECT	Ciudad 
FROM	Alumnos
WHERE	SSN = '11111111111';

--y Comparemos ese dato con el dato Original: 'Żelazowa Wola',  Zelazowa Wola
--
--Ż, es un caracter unicode.
--
-- Veamos por Ejemplo:
SELECT	'Żelazowa Wola' AS Normal, N'Żelazowa Wola' AS EnUnicode --Avisamos que el datos es unicode anteponiendo N'

IF 'Żelazowa Wola' = N'Żelazowa Wola'
	Print 'Iguales'
ELSE
	Print 'Diferentes';
--How many characteres LEN
SELECT LEN('Żelazowa Wola') AS Normal, LEN(N'Żelazowa Wola')  AS EnUnicode
--How many bytes DATALENGTH
SELECT DATALENGTH('Żelazowa Wola') AS Normal, DATALENGTH(N'Żelazowa Wola')  AS EnUnicode

		

/*---------------------------------------------------
Tabla de Relación Cursos y Alumnos
	--Llave Primaria Compuesta

CREATE TABLE Cursos_Alumnos
(
  Cod_Alumno int
	FOREIGN KEY REFERENCES Alumnos (Cod_Alumno)
                   ON UPDATE CASCADE
                   ON DELETE CASCADE,  
  Cod_Curso int
	FOREIGN KEY REFERENCES Cursos (Cod_Curso)
                   ON UPDATE CASCADE
                   ON DELETE CASCADE,  
  PRIMARY KEY (Cod_Alumno, Cod_Curso),
  Calificacion tinyint,
  Fecha_Insc Date,
  Ausencias tinyint
);

---------------------------------------------------*/

---Inscribamos a todos los alumnos en todos los cursos
INSERT INTO Cursos_Alumnos (Cod_Alumno, Cod_Curso, Calificacion, Fecha_Insc, Ausencias)
SELECT	A.Cod_Alumno,	--De la Tabla Alumnos
		C.Cod_Curso,	--De la Tabla Cursos
		0,
		GetDate(),		--Fecha Actual
		0
FROM	Alumnos A 
		CROSS JOIN --Producto Cartesiano 
		Cursos C; 
		
SELECT * FROM Cursos_Alumnos;

--Eliminemos Algunos
--Precedencia de los Operadores AND se evalua antes que OR
DELETE	Cursos_Alumnos
WHERE	Cod_Alumno = 2 AND Cod_Curso = 1 OR 
		Cod_Alumno = 3 AND Cod_Curso = 7 OR
		Cod_Alumno = 6 AND Cod_Curso = 6 OR
		Cod_Alumno = 7 AND Cod_Curso = 1 OR
		Cod_Alumno = 8 AND Cod_Curso = 1 OR
		Cod_Alumno = 9 AND Cod_Curso = 6;


DELETE	Cursos_Alumnos
WHERE	(Cod_Alumno = 2 AND Cod_Curso = 1) OR 
		(Cod_Alumno = 3 AND Cod_Curso = 7) OR
		(Cod_Alumno = 6 AND Cod_Curso = 6) OR
		(Cod_Alumno = 7 AND Cod_Curso = 1) OR
		(Cod_Alumno = 8 AND Cod_Curso = 1) OR
		(Cod_Alumno = 9 AND Cod_Curso = 6);


--Hagamos algunas preguntas


---------Operaciones con Conjuntos-----------------
SELECT	Estado FROM	Profesores
UNION 
SELECT	Estado FROM	Alumnos;

SELECT	Estado FROM	Profesores
UNION ALL -->No eliminar los Repetidos
SELECT	Estado FROM	Alumnos;

SELECT	Cod_Estado FROM	Estados
INTERSECT
SELECT	Estado FROM	Profesores;

SELECT	* FROM	Alumnos where Apellido LIKE 'C%';
SELECT	* FROM	Alumnos where Apellido NOT LIKE 'C%';

SELECT	* FROM	Alumnos
EXCEPT
SELECT	* FROM	Alumnos where Apellido LIKE 'C%';


SELECT	* FROM	Alumnos where Nombre LIKE '_a%';

SELECT	* FROM	Alumnos where Nombre LIKE '%O';



/**************************************************
		        Ordenamientos
**************************************************/
SELECT	Editorial, Autor, Titulo, Año, Paginas
FROM	Libros
ORDER BY Editorial DESC, Autor; ---Más de una Columna

SELECT	Cod_Libro, ISBN, Titulo, Autor, Año, Edicion, Editorial, Paginas
FROM	Libros
ORDER BY 3; -- Columna que ocupa el 3er lugar entre las Columnas Seleccionadas
			-- No es la 3ra columna de la Tabla!
			-- (NO ES BUENA PRACTICA)

SELECT	Cod_Libro, ISBN, Año, Titulo, Autor, Edicion, Editorial, Paginas
FROM	Libros
ORDER BY 3; -- Columna que ocupa el 3er lugar entre las Columnas Seleccionadas

---Primero los libros con más de 200 páginas
SELECT	Titulo, Autor, Editorial, Paginas
FROM	Libros
ORDER BY CASE 
			WHEN Paginas>200 THEN 1 
			ELSE 2 
		END,
		Paginas




/**************************************************
		Funciones de Agregación
**************************************************/
SELECT * FROM Paises
SELECT COUNT(*) FROM Paises

SELECT COUNT(Cod_Pais) FROM Paises
SELECT COUNT(Cod_Telefonico) FROM Paises


--Alumnos inscritos en cada curso 
SELECT	Cod_Curso, 
		COUNT(*) AS Alumnos  --> Contar los registros de cada Grupo 
FROM	Cursos_Alumnos
GROUP BY Cod_Curso;	--> Crear un Grupo por cada cambio de la Columna Cod_Curso


--La columna de Agrupación no tiene porqué estar en la Lista
SELECT	COUNT(*) AS Alumnos  --> Contar los registros de cada Grupo 
FROM	Cursos_Alumnos
GROUP BY Cod_Curso;	--> Crear un Grupo por cada cambio de la Columna Cod_Curso



--Pero TODAS las columnas de la lista deben ser Columnas de Agrupación y funciones de Agregación
SELECT	MAX(Fecha_Insc),
		COUNT(*) AS Alumnos  
FROM	Cursos_Alumnos
GROUP BY Cod_Curso;	--> Crear un Grupo por cada cambio de la Columna Cod_Curso



--Promedio de Páginas por Libro
SELECT	AVG(Paginas) AS Paginas 
FROM	Libros;

--Máximo y Mínimo de Páginas por Editorial
SELECT	Editorial, MIN(Paginas) AS Mínimo, MAX(Paginas) AS Máximo
FROM	Libros
GROUP BY Editorial;



------Creemos otro Curso, pero veamos Primero si el aula está ocupada------
IF (dbo.fn_Aula_Ocupada(-1,200,'11:00', '13:15'))=0
	PRINT 'DISPONIBLE'
ELSE
	PRINT 'OCUPADA';

---Hasta qué hora está ocupada?
SELECT	MAX(Hora_Fin)
FROM	Cursos
WHERE	Aula=200 AND Activo=1


--Insertemos nuestro nuevo curso 5 minutos después y tendrá una Duración de 90 Minutos:
DECLARE @Hora_Inicio TIME, @Hora_Fin TIME;

SELECT	@Hora_Inicio = DATEADD(MINUTE,5,MAX(Hora_Fin))
FROM	Cursos
WHERE	Aula=200 AND Activo=1;

SET @Hora_Fin = DATEADD(MINUTE,90,@Hora_Inicio);

INSERT INTO Cursos	(Cod_Prof, Cod_Materia, Aula, Hora_Inicio,  Hora_Fin)
			VALUES	(5,		   1,			200,  @Hora_Inicio, @Hora_Fin);

SELECT * from Cursos;


---Hagamos lo mismo de otra Forma:
INSERT INTO Cursos	(Cod_Prof, Cod_Materia, Aula, Hora_Inicio,  Hora_Fin)
SELECT	4, --Cod_Prof
		5, --Cod_Materia
		100, --Aula
		DATEADD(MI,5,MAX(Hora_Fin)), --Hora_Inicio
		DATEADD(MI,95,MAX(Hora_Fin)) --Hora_Fin
FROM	Cursos
WHERE	Aula=100 AND Activo=1;

SELECT * from Cursos;



/**************************************************
		       Joins-Unión Natural
**************************************************/

--Qué Materia tiene más alumnos Inscritos?
SELECT	TOP 1 --Retornar sólo el primer Registro
		M.Nombre, Count(*) Alumnos
FROM	Materias M
		JOIN Cursos C ON C.Cod_Materia = M.Cod_Materia	--Dada una Materia, busquemos qué cursos tiene
		JOIN Cursos_Alumnos CA ON CA.Cod_Curso = C.Cod_Curso --Por cada Curso, veamos cuántos alumnos hay
GROUP BY M.Nombre --> Crear un Grupo por cada Materia
ORDER BY Count(*) DESC; --> Ordenar de forma Descendente por la Cantidad de Registros de Cada Grupo


--Veamos las Materias y los Libros de los Cursos
SELECT	C.Cod_Curso,
		M.Cod_Materia, 
		M.Nombre AS Materia, --Alias para Columna
		L.Cod_Libro, 
		L.Titulo AS 'Título Libro', --Alias con Caracteres no Permitidos
		L.ISBN, 
		L.Editorial,
		L.Paginas AS [Núm. Págs.] --Alias con Caracteres no Permitidos
FROM	Cursos C
		JOIN Materias M ON M.Cod_Materia = C.Cod_Materia
		JOIN Cursos_Libros CL ON CL.Cod_Curso = C.Cod_Curso
		JOIN Libros L ON L.Cod_Libro = CL.Cod_Libro
ORDER BY M.Nombre;


--Profesor y Libros de Cada Curso
SELECT	Cursos.Cod_Curso,
		CONCAT (Profesores.Nombre, ', ', Profesores.Apellido) AS Profesor,
		CONCAT (Libros.Titulo, ' (Editorial ', Libros.Editorial, ')') AS Libro
FROM	Cursos 
		JOIN Profesores		ON Profesores.Cod_Prof = Cursos.Cod_Prof
		JOIN Cursos_Libros	ON Cursos_Libros.Cod_Curso = Cursos.Cod_Curso
		JOIN Libros			ON Libros.Cod_Libro = Cursos_Libros.Cod_Libro;



---Insertemos alumnos a estos Cursos----
INSERT INTO Cursos_Alumnos (Cod_Alumno, Cod_Curso, Calificacion, Fecha_Insc, Ausencias)
SELECT	Cod_Alumno,
		CASE 
			WHEN Fecha_Nac<'19000101' THEN 8
			ELSE 9
		END,
		0,
		GetDate(),
		0
FROM	Alumnos;


SELECT * FROM Cursos_Alumnos;

----------------------Una consulta que va a ser muy común-------------
SELECT  C.Cod_Curso, M.Cod_Materia, M.Nombre as Materia,
		C.Aula, C.Hora_Inicio, C.Hora_Fin,
		P.Cod_Prof, CONCAT(P.Nombre,', ', P.Apellido) AS Profesor,
		A.Cod_Alumno, CONCAT(A.Nombre,', ', A.Apellido) AS Alumno,
		CA.Fecha_Insc, CA.Ausencias, CA.Calificacion
FROM	Cursos_Alumnos CA
		JOIN Alumnos A ON A.Cod_Alumno = CA.Cod_Alumno
		JOIN Cursos C ON C.Cod_Curso = CA.Cod_Curso
		JOIN Profesores P ON P.Cod_Prof = C.Cod_Prof
		JOIN Materias M ON M.Cod_Materia = C.Cod_Materia
WHERE	C.Activo = 1;


----------------------------------------
CREATE FUNCTION Cursos_Datos
(	
	@Activo int,
	@Profesor smallint,
	@Aula int,
	@Materia smallint
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT  C.Cod_Curso, M.Cod_Materia, M.Nombre as Materia,
			C.Aula, C.Hora_Inicio, C.Hora_Fin,
			P.Cod_Prof, CONCAT(P.Nombre,', ', P.Apellido) AS Profesor,
			A.Cod_Alumno, CONCAT(A.Nombre,', ', A.Apellido) AS Alumno,
			CA.Fecha_Insc, CA.Ausencias, CA.Calificacion
	FROM	Cursos_Alumnos CA
			JOIN Alumnos A ON A.Cod_Alumno = CA.Cod_Alumno
			JOIN Cursos C ON C.Cod_Curso = CA.Cod_Curso
			JOIN Profesores P ON P.Cod_Prof = C.Cod_Prof
			JOIN Materias M ON M.Cod_Materia = C.Cod_Materia
	WHERE	C.Activo = @Activo AND
			(@Profesor IS NULL OR P.Cod_Prof = @Profesor) AND
			(@Aula IS NULL OR C.Aula = @Aula) AND
			(@Materia IS NULL OR M.Cod_Materia = @Materia) 
);

SELECT	*
FROM	dbo.Cursos_Datos(1,NULL,NULL,NULL);

SELECT	*
FROM	dbo.Cursos_Datos(1,5,NULL,NULL); --Activos, Prof:Chen

SELECT	*
FROM	dbo.Cursos_Datos(1,NULL,'100',NULL); --Activos, Aula 100

SELECT	*
FROM	dbo.Cursos_Datos(1,3,'100',NULL); --Activos, Prof:Newton, Aula 100

SELECT	*
FROM	dbo.Cursos_Datos(1,NULL,NULL,7); --Activos, Prof:Newton, Materia: 7















/************************************

	        VISTAS

************************************/
CREATE VIEW Cursos_Activos
AS
(
	SELECT  C.Cod_Curso, M.Cod_Materia, M.Nombre as Materia,
			C.Aula, C.Hora_Inicio, C.Hora_Fin,
			P.Cod_Prof, CONCAT(P.Nombre,', ', P.Apellido) AS Profesor,
			A.Cod_Alumno, CONCAT(A.Nombre,', ', A.Apellido) AS Alumno,
			CA.Fecha_Insc, CA.Ausencias, CA.Calificacion
	FROM	Cursos_Alumnos CA
			JOIN Alumnos A ON A.Cod_Alumno = CA.Cod_Alumno
			JOIN Cursos C ON C.Cod_Curso = CA.Cod_Curso
			JOIN Profesores P ON P.Cod_Prof = C.Cod_Prof
			JOIN Materias M ON M.Cod_Materia = C.Cod_Materia
	WHERE	Activo = 1
);


SELECT	*
FROM	Cursos_Activos;


SELECT	*
FROM	Cursos_Activos
WHERE	Cod_Materia = 7;


SELECT	*
FROM	Cursos_Activos
WHERE	Cod_Alumno = 4;


UPDATE	Cursos_Activos
SET		Ausencias = 1,
		Calificacion = 7
WHERE	Cod_Alumno = 4 AND
		Cod_Materia= 3;



-----------------------------------------
CREATE VIEW Profesores_Datos
AS
(
	SELECT	Cod_Prof, Nombre, Apellido,
			CONCAT('*******',RIGHT(SSN,4)) AS SSN,
			Numero, Calle, Ciudad, Estado, Cod_Postal, Telefono
			--[Sueldo]
	FROM	Profesores
);

SELECT * FROM Profesores_Datos;

CREATE TRIGGER Profesores_Datos_Manipular
ON Profesores_Datos
INSTEAD OF INSERT
AS
BEGIN
	
	PRINT 'No puede Crear nuevos Profesores.';
	PRINT '';
	PRINT 'Por favor diríjase al Departamento de Administración.'
END;

INSERT INTO Profesores_Datos 
	(Nombre, Apellido, SSN, Numero, Calle, Ciudad, Estado, Cod_Postal)
VALUES
	('Enzo', 'D''Amario', '111223344', '22', 'Calle Datos', 'Miami', 'FL', '33333');


ALTER TRIGGER Profesores_Datos_Manipular
ON Profesores_Datos
INSTEAD OF INSERT, DELETE
AS
BEGIN
	PRINT REPLICATE('*',60);
	PRINT '*                     A T E N C I O N                      *'
	PRINT '*                                                          *';
	      
	IF EXISTS (SELECT * FROM INSERTED)
		PRINT '*                No puede Crear nuevos Profesores.         *';
	ELSE
		PRINT '*                  No puede Eliminar Profesores.           *';
	PRINT '*                                                          *';
	PRINT '*  Por favor diríjase al Departamento de Administración.   *';
	PRINT REPLICATE('*',60);
END;


INSERT INTO Profesores_Datos 
	(Nombre, Apellido, SSN, Numero, Calle, Ciudad, Estado, Cod_Postal)
VALUES
	('Enzo', 'D''Amario', '111223344', '22', 'Calle Datos', 'Miami', 'FL', '33333');


DELETE Profesores_Datos;




ALTER TRIGGER Profesores_Datos_Manipular
ON Profesores_Datos
INSTEAD OF INSERT, DELETE, UPDATE
AS
BEGIN
	DECLARE @Msg VARCHAR(60)=''

	IF EXISTS (SELECT * FROM INSERTED) AND EXISTS (SELECT * FROM DELETED) --Es una modificación
	BEGIN
		IF UPDATE(SSN)
			SET @Msg = '*    No puede Modificar el Seguro Social de un Profesor.   *';
		ELSE
			UPDATE	Profesores 
			SET		Profesores.Nombre		= Inserted.Nombre, 
					Profesores.Apellido		= Inserted.Apellido, 
					Profesores.Numero		= Inserted.Numero, 
					Profesores.Calle		= Inserted.Calle, 
					Profesores.Ciudad		= Inserted.Ciudad, 
					Profesores.Estado		= Inserted.Estado, 
					Profesores.Cod_Postal	= Inserted.Cod_Postal,
					Profesores.Telefono		= Inserted.Telefono
			FROM	Inserted 
			WHERE	Profesores.Cod_Prof		= Inserted.Cod_Prof
	END

	ELSE IF EXISTS (SELECT * FROM INSERTED) --Es una Inserción 
		SET @Msg = '*                No puede Crear nuevos Profesores.         *';
	
	ELSE --Es una Eliminación
		SET @Msg = '*                  No puede Eliminar Profesores.           *';

	IF @Msg <> ''
	BEGIN
		PRINT REPLICATE('*',60);
		PRINT '*                     A T E N C I O N                      *'
		PRINT '*                                                          *';
	    PRINT @Msg;      
		PRINT '*                                                          *';
		PRINT '*  Por favor diríjase al Departamento de Administración.   *';
		PRINT REPLICATE('*',60);
	END

END;



INSERT INTO Profesores_Datos 
	(Nombre, Apellido, SSN, Numero, Calle, Ciudad, Estado, Cod_Postal)
VALUES
	('Enzo', 'D''Amario', '111223344', '22', 'Calle Datos', 'Miami', 'FL', '33333');

DELETE Profesores_Datos;


SELECT * FROM Profesores_Datos;

UPDATE	Profesores_Datos 
SET		SSN = '12345678901'
WHERE	Cod_Prof = 5;


UPDATE	Profesores_Datos 
SET		Telefono = '555-555-55-55',
		Calle = 'Entidad Relación'
WHERE	Cod_Prof = 5;

SELECT * FROM Profesores_Datos;








CREATE VIEW Alumnos_Telefonos
AS
	SELECT Cod_Alumno, Nombre, Apellido, Telefono
	FROM	Alumnos
	WHERE	Telefono IS NOT NULL;



SELECT * FROM Alumnos_Telefonos;

UPDATE Alumnos_Telefonos
SET Telefono = 'xxxxxx'
WHERE Cod_alumno = 1;

SELECT * FROM Alumnos_Telefonos;

UPDATE Alumnos_Telefonos
SET Telefono = NULL
WHERE Cod_alumno = 1;

ALTER VIEW Alumnos_Telefonos
AS
	SELECT Cod_Alumno, Nombre, Apellido, Telefono
	FROM	Alumnos
	WHERE	Telefono IS NOT NULL
WITH CHECK OPTION;

SELECT * FROM Alumnos_Telefonos;

UPDATE Alumnos_Telefonos
SET Telefono = NULL
WHERE Cod_alumno = 2;


ALTER VIEW Alumnos_Telefonos
WITH SCHEMABINDING
AS
	SELECT	Cod_Alumno, Nombre, Apellido, Telefono
	FROM	dbo.Alumnos
	WHERE	Telefono IS NOT NULL
WITH CHECK OPTION;


ALTER TABLE Alumnos
	ALTER COLUMN Telefono VARCHAR(20) NOT NULL;

ALTER TABLE Alumnos
	ALTER COLUMN Nombre VARCHAR(50) NOT NULL;

ALTER TABLE Alumnos
	ALTER COLUMN Calle VARCHAR(50) NOT NULL;




















/*************************************************
				IDENTIFICADORES

				 MULTI-PARTE
**************************************************/

SELECT * FROM Academias

SELECT * FROM dbo.Academias

CREATE SCHEMA RRHH;

CREATE TABLE RRHH.CuentasBancarias
(
	ID tinyint IDENTITY (1,1) PRIMARY KEY,
	Cuenta VARCHAR(10) NOT NULL,
	Saldo Money DEFAULT(0)
);

CREATE TABLE RRHH.PagosNomina
(
	CuentaOrigen tinyint NOT NULL,
	Profesor smallint NOT NULL,
	Fecha date NOT NULL,
	Monto Money NOT NULL
);

SELECT * FROM CuentasBancarias;
SELECT * FROM RRHH.CuentasBancarias;

----Vista de la Base de Datos master---
SELECT * FROM [sys].[all_objects]

USE master;

SELECT * FROM Academias;
SELECT * FROM RRHH.CuentasBancarias;

SELECT * FROM Alumnos_Telefonos;
SELECT * FROM dbo.Alumnos_Telefonos;


SELECT * FROM Academia.Academias;
SELECT * FROM Academia.dbo.Academias;
SELECT * FROM Academia..Academias;
SELECT * FROM Academia.RRHH.CuentasBancarias;

USE Academia;

[Servidor.[Base_de_Datos.[Esquema].|Esquema.]Objeto  









