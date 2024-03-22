USE MoviesDB;
GO

-- Insert sample data into the Movies table
PRINT 'Seed data for Movies table...'
INSERT INTO Movies (Title, ReleaseYear, Genre, Director) VALUES
('The Shawshank Redemption', 1994, 'Drama', 'Frank Darabont'),
('The Godfather', 1972, 'Crime', 'Francis Ford Coppola'),
('The Dark Knight', 2008, 'Action', 'Christopher Nolan'),
('12 Angry Men', 1957, 'Crime', 'Sidney Lumet'),
('Schindler''s List', 1993, 'Biography', 'Steven Spielberg');
GO
PRINT 'Seed data for Movies table inserted successfully'

-- Insert sample data into the Actors table
PRINT 'Seed data for Actors table...'
INSERT INTO Actors (Name, BirthDate) VALUES
('Morgan Freeman', '1937-06-01'),
('Al Pacino', '1940-04-25'),
('Christian Bale', '1974-01-30'),
('Henry Fonda', '1905-05-16'),
('Liam Neeson', '1952-06-07');
GO
PRINT 'Seed data for Actors table inserted successfully'

-- Insert relationships into the MoviesActors table
PRINT 'Seed data for MoviesActors table...'
INSERT INTO MoviesActors (MovieID, ActorID) VALUES
(1, 1), -- Morgan Freeman in The Shawshank Redemption
(2, 2), -- Al Pacino in The Godfather
(3, 3), -- Christian Bale in The Dark Knight
(4, 4), -- Henry Fonda in 12 Angry Men
(5, 5); -- Liam Neeson in Schindler's List
GO
PRINT 'Seed data for MoviesActors table inserted successfully'


