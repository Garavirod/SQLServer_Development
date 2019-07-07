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

--So

INSERT INTO Countries (cod_country,nam,code_ISO3,node_tel) VALUES('GB','Gran Bretaña','BRN',89)
GO