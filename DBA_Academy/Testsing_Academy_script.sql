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