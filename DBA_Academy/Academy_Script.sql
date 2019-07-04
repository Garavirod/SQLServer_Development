---------------------
--DATABASE CREATION--
---------------------
CREATE DATABASE Academy;
GO

--Using data base Academy
USE Academy;
GO

------------------
--COUNTRIES TABLE-
------------------

/*
	Restrictions:
	Restriction of null
	Restrictio of cheking values
	Rstriction of uniqueness
*/

CREATE TABLE Countries(
	cod_country CHAR(2) PRIMARY KEY CHECK (LEN(cod_country)=2),
	nam VARCHAR(30) NOT NULL,
	code_ISO3 CHAR(3) NOT NULL UNIQUE CHECK (LEN(code_ISO3)=3),
	node_tel SMALLINT	 
)
GO

-----------------
--STATES TABLE---
-----------------
CREATE TABLE States (
	code_St CHAR(2) PRIMARY KEY
	--Let's create a restricton like a separated object and give it name "Len_State"
	CONSTRAINT Len_State CHECK(LEN(code_St)=2),
	nam VARCHAR(50) NOT NULL,
	cod_country CHAR(2) FOREIGN KEY
		REFERENCES Countries (cod_country)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	code_Tel SMALLINT
)
GO
/*
  Beacsue table already exists we can check that existing records
  comply with the rules imposed by the relationship.
  If there's a record which doesn't cumply with this foreign key then this FK can't
  be created.
  ALTER TABLE States WITH CHECK ADD FOREIGN KEY (cod_country) 
	REFERENCES Countries (cod_country)
	ON UPDATE CASCADE 
	ON DELETE CASCADE;

  (WITH)
*/

-----------------
--ACADEMY TABLE--
-----------------

CREATE TABLE Academies (
	code_Ac tinyint IDENTITY (1,1) PRIMARY KEY, --Field autogenerated and autoincremental (IDENTITY)
	Nam VARCHAR(30) NOT NULL,
	Date_Func DATE NOT NULL,
	Num VARCHAR(10) NOT NULL,
	Street VARCHAR(30) NOT NULL,
	City VARCHAR(30) NOT NULL,
	Sta CHAR(2) NULL
	--Adding constraint to Sta atribute if we wish it
		CONSTRAINT FK_state 
		FOREIGN KEY 
		REFERENCES States (Code_St)
		ON UPDATE CASCADE
		ON DELETE SET NULL, --Put NULL when the record has been deleted
	Zip VARCHAR(10) 
)
GO

-------------------
--PROFESSOR TABLE--
-------------------
CREATE TABLE Professors(
	cod_Prof SMALLINT IDENTITY (1,1) PRIMARY KEY,
	ssn VARCHAR(11) UNIQUE CHECK (LEN(ssn)=11),
	nam VARCHAR(30) NOT NULL,
	surname VARCHAR(30) NOT NULL,
	num VARCHAR(10) NOT NULL,
	street VARCHAR(30) NOT NULL,
	city VARCHAR(30) NOT NULL,
	sta CHAR(2) FOREIGN KEY REFERENCES States (code_St)
		ON UPDATE CASCADE 
		ON DELETE SET NULL,
	zip VARCHAR(10) NOT NULL,
	telphone VARCHAR(15),
	income MONEY DEFAULT(0)
)
GO


-------------------
--APARTMENT TABLE--
-------------------

CREATE TABLE Apartments(
	cod_Ap SMALLINT IDENTITY (1,1) PRIMARY KEY,
	academy TINYINT NOT NULL
			FOREIGN KEY REFERENCES Academies (code_Ac)
			ON UPDATE CASCADE
			ON DELETE CASCADE,
	nam VARCHAR(30) NOT NULL,
	director SMALLINT NOT NULL DEFAULT (-1)
			 FOREIGN KEY REFERENCES Professors (cod_Prof)
			 ON UPDATE  NO ACTION --not taking any action when record had been deleted
			 ON DELETE  NO ACTION,
	date_start DATE NOT NULL
)
GO
--------------------------
--APART_PROFESSORS TABLE--
--------------------------

CREATE TABLE Aparts_Professors(
	cod_Apt SMALLINT NOT NULL FOREIGN KEY REFERENCES Apartments (cod_Ap),			
	cod_Prof SMALLINT NOT NULL FOREIGN KEY REFERENCES Professors(cod_Prof)
		ON UPDATE CASCADE
		ON DELETE CASCADE
)
GO

/*
	TRIGGERS - DML (Lenguage of manipulation of data)
	Objects in a Data base that are executed automatically 
	when it inserting, modifying or deleting data from a table or view.
*/

--------------------
--DELETING TRIGGER--
--------------------

CREATE TRIGGER Tgr_delete_Apt_Professors
	ON Apartments
	FOR DELETE --Deleting of apartments
AS BEGIN
	DELETE Aparts_Professors
	/*
		Select all cod_apt from DELETED TABLE and deleting from relation 
		Aparts_Professors.
	*/
	WHERE cod_Apt IN (
		SELECT cod_Apt FROM deleted
	);
END
GO
---------------------
--TRIGGER MODIFYING--
---------------------

--Modyfing of primary key from apartments Table
CREATE TRIGGER Tgr_modify_Apt_Professors
	ON Apartments
	FOR UPDATE --Apartments modyfing
AS BEGIN
	UPDATE Aparts_Professors
	SET cod_Apt = A.new_code --Updating of the new code IN Aparts_Professors Table
	FROM (
		SELECT D.cod_Ap AS before_code,
			   I.cod_Ap AS new_code
		FROM DELETED AS D --Data before of modify
			 JOIN
			 INSERTED AS I --Data after of modify
			 ON
			 D.cod_Ap = I.cod_Ap --Same apartment
		WHERE D.cod_Ap <> I.cod_Ap --cod_Ap is modificated
	)A
	WHERE cod_Apt = A.before_code --rows which has the before code of each apartment
END
GO

--------------------
--TABLE SUBJECT V1--
--------------------
CREATE TABLE Subjects(
	cod_subject SMALLINT IDENTITY (1,1) PRIMARY KEY,
	nam VARCHAR(30) NOT NULL,
	elective BIT NOT NULL DEFAULT (0),
	weigh TINYINT CHECK (weigh > 0 AND 
						 weigh <= ( 
							 CASE elective
								WHEN 0 THEN 6
								ELSE 2
							 END
						 )
	)
	-- Using the field of same register in the restriction of other field is not allowed
)
GO

--------------------
--TABLE SUBJECT V2--
--------------------
CREATE TABLE Subjects(
	cod_subject SMALLINT IDENTITY (1,1) PRIMARY KEY,
	nam VARCHAR(30) NOT NULL,
	elective BIT NOT NULL DEFAULT (0),
	weigh TINYINT NOT NULL DEFAULT(1) CHECK(weigh>0)
)

/*
	We are going to create a restriction, but at the table level not in the weight field
*/

--Now we can use all field of record
ALTER TABLE Subjects
	  ADD CONSTRAINT Check_weight_subject
	  CHECK ( weigh <= (CASE elective WHEN 0 THEN 6 ELSE 2 END))



-----------------
--COURSES TABLE--
-----------------

CREATE TABLE Courses(
	cod_course INT IDENTITY (1,1) PRIMARY KEY,
	cod_prof SMALLINT
	FOREIGN KEY REFERENCES Professors (cod_Prof)
	ON DELETE SET NULL,
	cod_sub SMALLINT 
	FOREIGN KEY REFERENCES Subjects (cod_subject)
	ON DELETE CASCADE,
	classroom INT NOT NULL,
	hour_start TIME NOT NULL,
	hour_end TIME NOT NULL,
	--It just stores the metadata and the operation going to happens when be necessary
	diration_mins AS (DATEDIFF(MINUTE,hour_start,hour_end)) --Type of data it isn't necessary
)
GO

--Createing a restriction  to level of table 
ALTER TABLE Courses
ADD CONSTRAINT CheckHours CHECK(hour_start < hour_end);

--Adding new field to table 
ALTER TABLE Courses 
ADD isActive BIT NOT NULL DEFAULT(1);

-------------
--FUNCTIONS--
-------------
/*
	Data of record what we are trying to insert
	@ID INT,
	@classroom INT,
	@start TIME, 
	@end TIME

*/
CREATE FUNCTION isClassRoomOccupied(@ID INT,@classroom INT,@start TIME, @end TIME)

RETURNS BIT --Type of function's return
AS BEGIN 
	DECLARE @isOccupied BIT = 0;
	IF EXISTS (
		SELECT * FROM Courses --Courses which meet following conditions
		WHERE 
		cod_course <> @ID AND  --It is not the course we're trying of insert
		classroom = @classroom AND --The course is in the same clasroom
		isActive = 1 AND --It is an active course
		(
			@start BETWEEN hour_start AND hour_end OR --A course takes place at the same moment while this course is starting
			@end BETWEEN hour_start AND hour_end OR --A course take place at the same mometn while this course is enindg
			(@start <= hour_start AND @end >= hour_end) --A course takes place at the same moment while this course is taking place
		)	
	)
	SET @isOccupied = 1 --If all those conditions are met then the classroom is occupied
	RETURN @isOccupied
END
GO

/*Only it can create courses if the clasroom is aveliable*/
ALTER TABLE Courses
ADD CONSTRAINT checkIsOccupied
CHECK (dbo.isClassRoomOccupied(cod_course,classroom,hour_start,hour_end)=0)
GO
----------------
--BOOKS TABLES--
----------------
CREATE TABLE  Books(
	cod_book INT IDENTITY (1,1) PRIMARY KEY,
	isbn CHAR(13) NOT NULL UNIQUE CHECK (LEN(isbn)=13 AND ISNUMERIC(isbn)=1),
	title VARCHAR(100) NOT NULL,
	author VARCHAR(10) NOT NULL,
	_year SMALLINT,
	edition CHAR(3),
	editorial VARCHAR(100),
	pages SMALLINT
)
GO
-----------------------
--COURSES_BOOKS TABLE--
-----------------------
CREATE TABLE Courses_Books (
	cod_course INT NOT NULL
	FOREIGN KEY REFERENCES Courses (cod_course)
	ON DELETE CASCADE 
	ON UPDATE CASCADE,
	cod_book INT NOT NULL
	FOREIGN KEY REFERENCES Books (cod_book)
	ON DELETE CASCADE 
	ON UPDATE CASCADE
)
GO
