-- Create the MoviesDB database
PRINT 'Creating database...'
CREATE DATABASE MoviesDB;
GO
PRINT 'Database created successfully'

USE MoviesDB;
GO

-- Create the Movies table. Genre and Director should not be implemented this way in non-demo code
PRINT 'Creating Movies table...'
CREATE TABLE Movies (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(100),
    ReleaseYear INT,
    Genre NVARCHAR(50),
    Director NVARCHAR(100)
);
GO
PRINT 'Movies table created successfully'

-- Create the Actors table
PRINT 'Creating Actors table...'
CREATE TABLE Actors (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    BirthDate DATE
);
GO
PRINT 'Actors table created successfully'

-- Create the MoviesActors junction table for the many to many relationship possible between Movies and Actors
PRINT 'Creating MoviesActors table...'
CREATE TABLE MoviesActors (
    MovieID INT,
    ActorID INT,
    FOREIGN KEY (MovieID) REFERENCES Movies(ID) ON DELETE CASCADE,
    FOREIGN KEY (ActorID) REFERENCES Actors(ID) ON DELETE CASCADE
);
GO
PRINT 'MoviesActors table created successfully'
