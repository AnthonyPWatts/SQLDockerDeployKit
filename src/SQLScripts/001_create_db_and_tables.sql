-- Create the MoviesDB database
CREATE DATABASE MoviesDB;
GO

USE MoviesDB;
GO

-- Create the Movies table. Genre and Director should not be implemented this way in non-demo code
CREATE TABLE Movies (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(100),
    ReleaseYear INT,
    Genre NVARCHAR(50),
    Director NVARCHAR(100)
);
GO

-- Create the Actors table
CREATE TABLE Actors (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    BirthDate DATE
);
GO

-- Create the MoviesActors junction table for the many to many relationship possible between Movies and Actors
CREATE TABLE MoviesActors (
    MovieID INT,
    ActorID INT,
    FOREIGN KEY (MovieID) REFERENCES Movies(ID),
    FOREIGN KEY (ActorID) REFERENCES Actors(ID)
);
GO
