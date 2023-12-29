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

-- Insert sample data into the Movies table
INSERT INTO Movies (Title, ReleaseYear, Genre, Director) VALUES
('The Shawshank Redemption', 1994, 'Drama', 'Frank Darabont'),
('The Godfather', 1972, 'Crime', 'Francis Ford Coppola'),
('The Dark Knight', 2008, 'Action', 'Christopher Nolan'),
('12 Angry Men', 1957, 'Crime', 'Sidney Lumet'),
('Schindler''s List', 1993, 'Biography', 'Steven Spielberg');
GO

-- Insert sample data into the Actors table
INSERT INTO Actors (Name, BirthDate) VALUES
('Morgan Freeman', '1937-06-01'),
('Al Pacino', '1940-04-25'),
('Christian Bale', '1974-01-30'),
('Henry Fonda', '1905-05-16'),
('Liam Neeson', '1952-06-07');
GO

-- Insert relationships into the MoviesActors table
INSERT INTO MoviesActors (MovieID, ActorID) VALUES
(1, 1), -- Morgan Freeman in The Shawshank Redemption
(2, 2), -- Al Pacino in The Godfather
(3, 3), -- Christian Bale in The Dark Knight
(4, 4), -- Henry Fonda in 12 Angry Men
(5, 5); -- Liam Neeson in Schindler's List
GO
