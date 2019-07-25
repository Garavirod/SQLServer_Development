------------------
--USING DATABASE--
------------------
USE Academy

--INSERTING DATA IN COUNTRY--

INSERT INTO Countries(cod_country,nam,code_ISO3,node_tel)
			   VALUES('AR','Argentina','ARG',NULL)
			   GO

INSERT INTO Countries(cod_country,nam,code_ISO3,node_tel)
			   VALUES
			   ('AU','Australia','AUS',68),
			   ('BO','Bolivia','BOL',NULL),
			   ('BR','Brasil','BRA',NULL),
			   ('CA','Canada','CAN',NULL),
			   ('CL','Chile','CHL',NULL),
			   ('CH','China','CHN',156)
			   GO

INSERT INTO Countries (cod_country,nam,code_ISO3,node_tel)
SELECT 'CO','Colombia','COL',NULL
GO

--Violation of type of data cod_country 'CHAR(2)'
INSERT INTO Countries(cod_country,nam,code_ISO3,node_tel)
			   VALUES('ARG','Argentina','ARG',NULL)
			   GO

--Anulation of PRIMARY KEY'
INSERT INTO Countries(cod_country,nam,code_ISO3,node_tel)
			   VALUES(NULL,'Argentina','ARG',36)
			   GO

--Duplication of PRIMARY KEY'
INSERT INTO Countries(cod_country,nam,code_ISO3,node_tel)
			   VALUES('AR','Argentina','ARG',36)
			   GO

--Violation of checking restriction LEN()'
INSERT INTO Countries(cod_country,nam,code_ISO3,node_tel)
			   VALUES('A','Argentina','ARG',36)
			   GO

--Missing  a data in the instruction
INSERT INTO Countries(cod_country,nam,code_ISO3,node_tel)
			   VALUES('CR','Costa Rica','CRA')
			   GO

--But this TABLE acpts null data
INSERT INTO Countries(cod_country,nam,code_ISO3)
			   VALUES('CR','Costa Rica','CRA')
			   GO

--Countries oredered by name
SELECT * FROM Countries	ORDER BY nam DESC
GO

--The ordered field does not have to be between the selected fields
SELECT nam, code_ISO3 FROM Countries ORDER BY code_ISO3 DESC
GO

--Atomicity (all or notthng) with error
BEGIN TRY
	BEGIN TRAN
		INSERT INTO Countries (cod_country,nam,code_ISO3) VALUES('SV','El Salvador','SLV')
		INSERT INTO Countries (cod_country,nam,code_ISO3) VALUES('FI','Finlandia','FIN')
		INSERT INTO Countries (cod_country,nam,code_ISO3) VALUES('FR','Francia','FRA')
		INSERT INTO Countries (cod_country,nam,code_ISO3) VALUES('DE','Alemania','DEU')
		INSERT INTO Countries (cod_country,nam,code_ISO3) VALUES('GT','Guatemala','GTH')
		INSERT INTO Countries (cod_country,nam,code_ISO3) VALUES('HN','Honduras','HND')
		INSERT INTO Countries (cod_country,nam,code_ISO3) VALUES('HN','Hungria','HUN') --Duplicated Key
		COMMIT
		PRINT 'Successful transaction !!'
END TRY
BEGIN CATCH
	ROLLBACK --State of database returns back at its original state
	PRINT 'Faild transaction !!'
END CATCH
GO

-- Atomicity (all or notthng) without error
BEGIN TRY
	BEGIN TRAN
		INSERT INTO Countries (cod_country,nam,code_ISO3) VALUES('SV','El Salvador','SLV')
		INSERT INTO Countries (cod_country,nam,code_ISO3) VALUES('FI','Finlandia','FIN')
		INSERT INTO Countries (cod_country,nam,code_ISO3) VALUES('FR','Francia','FRA')
		INSERT INTO Countries (cod_country,nam,code_ISO3) VALUES('DE','Alemania','DEU')
		INSERT INTO Countries (cod_country,nam,code_ISO3) VALUES('GT','Guatemala','GTH')
		INSERT INTO Countries (cod_country,nam,code_ISO3) VALUES('HN','Honduras','HND')
		INSERT INTO Countries (cod_country,nam,code_ISO3) VALUES('HU','Hungria','HUN') --Duplicated Key
		COMMIT
		PRINT 'Successful transaction !!'
END TRY
BEGIN CATCH
	ROLLBACK --State of database returns back at its original state
	PRINT 'Faild transaction !!'
END CATCH
GO

--INSERTING DATA IN STATES--
INSERT INTO States (code_St,cod_country,nam) VALUES('UL','DE','Baden-Wötenberg')
GO

--Code_country there's not exist 'GB' and faild the inserting of foreign key
INSERT INTO States (code_St,cod_country,nam) VALUES('SW','GB','South West England')
GO

--So, first we have to insert the country
INSERT INTO Countries (cod_country,nam,code_ISO3,node_tel) VALUES('GB','Gran Bretaña','BRN',89)
GO

INSERT INTO States(code_St,cod_country,nam) VALUES('SW','GB','South West England')

--Other states 

INSERT INTO Countries (cod_country,nam,code_ISO3,node_tel) VALUES('US','United States','USA',1)
INSERT INTO Countries (cod_country,nam,code_ISO3,node_tel) VALUES('WI','Wisconsing','WIS',3)
INSERT INTO Countries (cod_country,nam,code_ISO3,node_tel) VALUES('CF','California','CAL',9)
GO

INSERT INTO States(code_St,cod_country,nam) VALUES('WI','US','Wisconsing')
INSERT INTO States(code_St,cod_country,nam) VALUES('CF','US','California')
GO

--Inserting another states Carabobo in Venezuela
INSERT INTO Countries (cod_country,nam,code_ISO3,node_tel) VALUES('VE','Venezuela','VEN',53)
INSERT INTO States (code_St,cod_country,nam) VALUES('V','VE','Carabobo')
GO

/*
	Error:
		cod_St char(2) PRIMARY KEY CHECK(LEN(cod_St)=2)
		Let's delete the restriction
*/
ALTER TABLE States DROP CONSTRAINT Len_State
GO

--let's create a new Restriction
ALTER TABLE States
ADD CONSTRAINT Len_State CHECK (LEN(code_St)>0)
GO


--Let's insert again
INSERT INTO States (code_St,cod_country,nam) VALUES('Y','VE','Carabobo')
GO

--Let's see the record Venezuela and Carabobo state that we've just created 
SELECT * FROM States WHERE cod_country = 'VE'
SELECT * FROM Countries WHERE cod_country = 'VE'
GO

--Let's testing delete cascade and update cascade

--Update Venezuela Code
UPDATE Countries --Modifying Countries Table
SET cod_country = 'XX' --Set 'XX' in cod_cpountry field
WHERE cod_country = 'VE'
GO

--Let's see the changes
SELECT * FROM Countries WHERE cod_country = 'XX'
SELECT * FROM States WHERE code_St = 'Y'
GO

--Le's deleteing cascade
DELETE Countries WHERE	cod_country = 'XX'
SELECT * FROM States
GO


/*Testing Academies */
--We can't asgin a value, there're esceptions
INSERT INTO Academies (code_Ac,Nam,Date_Func,Num,Street,City,Sta,Zip)
VALUES(
	1,
	'Relational Algebar Academy "Edgar F. Cod"',
	'20150301','13528',
	'Avenida Datum',
	'Relational City',
	'WI',
	'12345')
GO

INSERT INTO Academies (Nam,Date_Func,Num,Street,City,Sta,Zip)
VALUES(
	'Relational Algebar Academy "Edgar F. Cod"',
	'20150301',
	'13528',
	'Avenida Datum',
	'Relational City',
	'WI',
	'12345')
GO

SELECT * FROM Academies
GO

--Modifying a table's atribute
ALTER TABLE dbo.Academies ALTER COLUMN Nam VARCHAR(50) NOT NULL

INSERT INTO Academies (Nam,Date_Func,Num,Street,City,Sta,Zip)
VALUES(
	'Einstein Academy',
	'20181217',
	'5582',
	'Relation Street',
	'Ulm',
	'UL',
	'00000')
GO

/*
	To avoid posible generated conflicts for concurrency
	the value of fields IDENTITY it incresses itself before executing the insertition
	and got value  can't be used
*/

--It Allows inserting data manualy in the Field IDENTITY
SET IDENTITY_INSERT Academies ON
GO

--You must set explict in the Insertion list field
INSERT INTO Academies (code_Ac,Nam,Date_Func,Num,Street,City,Sta,Zip)
VALUES(
	2,
	'Academy 3FN',
	'20160301',
	'4675',
	'Tuple Avenue Union',
	'California',
	'CF',
	'12345')
GO


--It's very import return back normal behavor
SET IDENTITY_INSERT Academies OFF
GO

/*
	STORED PROCEDURES

	Group of one of more of SQL queries that are stred like an object
	in DBD's meta data.
	They are an object more of DBD
	SP allways returns an integer

	Sintaxis:

	CREATE PROCEDURE name_sp
		@param_name char(2)
	AS
	BEGIN
		SELECT * FROM States WHERE cd_countryi = @param_name;
	END
*/


CREATE PROCEDURE InserCountries
	@cod_country char(2),
	@Nam varchar(50),
	@cod_ISO3 char(3),
	@cod_tel smallint  = NULL --If it is not inserted a data, the value will be NULL
AS
BEGIN
	INSERT INTO Countries(cod_country,nam,code_ISO3,node_tel)
	VALUES(@cod_country,@Nam,@cod_ISO3,@cod_tel);
END
GO

--Executing an stored procedure
EXEC InserCountries
	@cod_country = 'TWN', --Implict convertion
	@Nam = 'Taiwan',
	@cod_ISO3 = 'TWN'

--ERROR  2627 --> PRIMARY KEY, UNIQUE


/*ALTER PROCEDURE */

ALTER PROCEDURE InserCountries
	@cod_country char(2),
	@Nam varchar(50),
	@cod_ISO3 char(3),
	@cod_tel smallint  = NULL --If it is not inserted a data, the value will be NULL
AS
BEGIN
	DECLARE @Msg NVARCHAR(4000), @Err INT
	BEGIN TRY
		INSERT INTO Countries(cod_country,nam,code_ISO3,node_tel)
		VALUES(@cod_country,@Nam,@cod_ISO3,@cod_tel);
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR
		IF @Err = 547
			SET @Msg = 'DATA INSERTED IS WRONG'
		ELSE IF @Err = 2627
			SET @Msg = 'COUNTRY ALREADY EXIST'
		ELSE
			SET @Msg = ERROR_MESSAGE()

		--THROW 51000, @MSG, 1
		PRINT @Msg
		RETURN -1
	END CATCH
	RETURN 0 --When the SP is sccesfully executed
END
GO

/*ANOTHER FORM TO DO THE THINGS*/

CREATE PROCEDURE InsertStates
	@cod_sta char(2),
	@cod_cont char(2),
	@name varchar(50),
	@cod_tel smallint = NULL
AS
BEGIN
	INSERT INTO States (code_St,cod_country,nam,code_Tel)
	VALUES (@cod_sta,@cod_cont,@name,@cod_tel)
END
GO
/*DELETE A PROCEDURE*/
DROP PROCEDURE ModifyStates
GO

/*STORED PROCEDURE FOR MODIFYING AN STATE*/
CREATE PROCEDURE ModifyStates
	@cod_sta char(2),
	@cod_cont char(2),
	@name varchar(50),
	@cod_tel smallint = NULL
AS
BEGIN
	UPDATE States
		   SET cod_country = @cod_cont,		   
		   nam = @name,
		   code_Tel = @cod_tel
	WHERE code_St = @cod_sta
END
GO

/*STROEE PROCEDURE FOR DELETING STATES*/
CREATE PROCEDURE Delete_States
	@cod_state char(2)
AS
BEGIN 
	DELETE States
	WHERE code_St = @cod_state
END
GO

/*STORED PROCEDURE FOR QUERYING STATES*/
CREATE PROCEDURE Query_States
	@cod_country char(2) = NULL,
	@cod_sta char(2) = NULL
AS
BEGIN
	SELECT P.cod_country, P.nam AS COUNTRY,
		   E.code_St,E.nam,E.code_Tel
	FROM States AS E
		JOIN Countries AS P ON P.cod_country = E.cod_country
	WHERE (@cod_country IS NULL OR P.cod_country = @cod_sta) AND
		  (@cod_sta IS NULL OR E.code_St = @cod_sta)
END
GO


/*EXECUTIONG THE STROED PROCEDURES*/
EXEC InsertStates 'BA','TW','BASIN'
EXEC Query_States @cod_country = 'TW'
EXEC Query_States @cod_sta = 'BA'
EXEC Query_States
EXEC Delete_States 'BA'


--Adding more countries
INSERT INTO Countries (cod_country,code_ISO3,nam,node_tel)
VALUES
('ES','ESP','ESPAÑA',34),
('PL','PLN','POLINIA',48),
('ME','MEX','MEXICO',52),
('RU','RUS','RUSIA',7),
('IT','ITA','ITAILA',39)
GO

--Adding more states

INSERT INTO States (code_St,cod_country,nam,code_Tel)
VALUES
('CT','ES','CATALUÑA',NULL),
('MA','ES','MADRID',NULL),
('SO','PL','SCHOCZEW',NULL),
('WA','PL','WARSAW',NULL),
('DU','ME','DURANGO',NULL),
('UM','RU','MONTES URIELS',NULL),
('BD','IT','BOLOÑAN',NULL),
('AU','FR','AVAGUANE',NULL)
GO