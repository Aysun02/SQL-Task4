USE MoviesApp

CREATE TABLE Directors(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(50) NOT NULL,
	Surname nvarchar(50) NOT NULL
)

CREATE TABLE Languages(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(50) NOT NULL UNIQUE
)

CREATE TABLE Movies(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(50) NOT NULL,
	Description nvarchar(255) NOT NULL,
	CoverPhoto nvarchar(255) NOT NULL,
	LanguageId int FOREIGN KEY REFERENCES Languages(Id),
	DirectorId int FOREIGN KEY REFERENCES Directors(Id)
)

CREATE TABLE Actors(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(50),
	Surname nvarchar(50) 
)

CREATE TABLE Genres(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(50) NOT NULL UNIQUE
	
)

CREATE TABLE MoviesAndActors(
	Id int PRIMARY KEY IDENTITY,
	ActorId int FOREIGN KEY REFERENCES Actors(Id),
	MovieId int FOREIGN KEY REFERENCES Movies(Id)
)

CREATE TABLE MoviesAndGenres(
	Id int PRIMARY KEY IDENTITY,
	GenreId int FOREIGN KEY REFERENCES Genres(Id),
	MovieId int FOREIGN KEY REFERENCES Movies(Id)
)

INSERT INTO Directors
VALUES('Aysun','Huseynli'),
('Konul','Huseynli'),
('Emilya','Andamova'),
('Firengiz','Rustaova')
SELECT * FROM Directors

INSERT INTO Languages
VALUES('AZE'),('TURK'),('ENG'),('RUS')
SELECT * FROM Languages

INSERT INTO Movies
VALUES('Alya','Turkiye-Koreya muharibesinde balaca Koreyali qiz ve Turk esgerin hekayesi','AlyaFilmAfish',2,4),
('Xoca','Xocali Faciesinde bas veren hadielerin paralel sekilde Baki ve Xocalida olmaqla hadiseler tesvir edilir','XocaFilmAfish',1,1),
('Vangeliya','Baba Vanga-Vangeliyanin heyati haqqinda','VangeliyaFilmafish',4,3)
INSERT INTO Movies
VALUES('Pirates of The Carribbean','Karib Denizinin quldurlarinin basina gelen maceralar','AfishofFilm',3,2)
SELECT * FROM Movies

INSERT INTO Actors
VALUES('Ismayil','Hacioglu'),
('Nigar','Bahadirqizi'),
('Irina','Rakhmanova'),
('Johnny','Deep')
SELECT * FROM Actors

INSERT INTO Genres
VALUES('Action'),('Comedy'),('Fantasy'),('Adventure'),('Drama'),('War'),('History')
SELECT * FROM Genres

INSERT INTO MoviesAndActors
VALUES(1,1),(2,2),(3,3),(4,4)
SELECT * FROM MoviesAndActors

INSERT INTO MoviesAndGenres
VALUES(5,3),(6,1),(7,1),(5,1),(1,2),(5,2),(7,2),(6,2),(1,4),(2,4),(3,4),(4,4)
SELECT * FROM MoviesAndGenres

CREATE OR ALTER PROCEDURE usp_GetFilmsAndLanguages @directorId int
AS
SELECT film.Id,film.Name,lang.Name FROM Movies AS film
INNER JOIN Languages AS lang ON film.LanguageId= lang.Id
WHERE film.DirectorId=@directorId
EXEC usp_GetFilmsAndLanguageS @directorId=3
EXEC usp_GetFilmsAndLanguageS @directorId=2
EXEC usp_GetFilmsAndLanguageS @directorId=1
EXEC usp_GetFilmsAndLanguageS @directorId=4

 
CREATE FUNCTION GetMoviesCountByLanguages (@languageId int)
RETURNS int
AS
BEGIN
     DECLARE @CountMovie int
	 SELECT @CountMovie=COUNT(*) FROM Movies WHERE Movies.LanguageId=@languageId
	 RETURN @CountMovie
END
SELECT  dbo.GetMoviesCountByLanguages(1)
SELECT  dbo.GetMoviesCountByLanguages(2)
SELECT  dbo.GetMoviesCountByLanguages(3)
SELECT  dbo.GetMoviesCountByLanguages(4)


CREATE OR ALTER PROCEDURE usp_GenreofFilmsAndDirector @genreId int
AS
SELECT film.Name,direct.Name FROM MoviesAndGenres AS filmgenre
INNER JOIN Movies AS film ON filmgenre.MovieId=film.Id
INNER JOIN Directors AS direct ON film.DirectorId=direct.Id
WHERE filmgenre.GenreId=@genreId
EXEC usp_GenreofFilmsAndDirector @genreId=1
EXEC usp_GenreofFilmsAndDirector @genreId=4
EXEC usp_GenreofFilmsAndDirector @genreId=2
EXEC usp_GenreofFilmsAndDirector @genreId=5
EXEC usp_GenreofFilmsAndDirector @genreId=3
EXEC usp_GenreofFilmsAndDirector @genreId=7
EXEC usp_GenreofFilmsAndDirector @genreId=6


CREATE OR ALTER FUNCTION MoreOfThreeFilm (@actorId int)
RETURNS bit
AS
BEGIN
	DECLARE @CHECKING bit = 0
	DECLARE @FILMSCOUNT int
	SELECT @FILMSCOUNT= COUNT(*) FROM  MoviesAndActors WHERE MoviesAndActors.ActorId=@actorId
	IF @FILMSCOUNT>3 SELECT @CHECKING=1
	RETURN @CHECKING
END
SELECT  dbo.MoreOfThreeFilm(1)
SELECT  dbo.MoreOfThreeFilm(2)
SELECT  dbo.MoreOfThreeFilm(3)
SELECT  dbo.MoreOfThreeFilm(4)


CREATE TRIGGER GetFilmsWhenAddedNew ON Movies
AFTER INSERT
AS
BEGIN
	SELECT film.Name,film.Description,direct.Name,direct.Surname,lang.Name FROM Movies AS film
	INNER JOIN Directors AS direct ON film.DirectorId=direct.Id
	INNER JOIN Languages AS lang ON film.LanguageId=lang.Id
END

INSERT INTO Movies
VALUES('Anabelle','Lenetli kukla ve kuklanin sahibi olan qizin ailesinin basina gelenler','AnabellePoster',2,4)