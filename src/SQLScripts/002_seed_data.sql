USE MoviesDB;
GO

-- Seed data for Movies table using MERGE
PRINT 'Seeding Movies table...'
MERGE INTO Movies AS target
USING (VALUES
    ('The Shawshank Redemption', 1994, 'Drama', 'Frank Darabont'),
    ('The Godfather', 1972, 'Crime', 'Francis Ford Coppola'),
    ('The Dark Knight', 2008, 'Action', 'Christopher Nolan'),
    ('12 Angry Men', 1957, 'Crime', 'Sidney Lumet'),
    ('Schindler''s List', 1993, 'Biography', 'Steven Spielberg')
) AS source (Title, ReleaseYear, Genre, Director)
ON target.Title = source.Title AND target.ReleaseYear = source.ReleaseYear
WHEN NOT MATCHED THEN
    INSERT (Title, ReleaseYear, Genre, Director)
    VALUES (source.Title, source.ReleaseYear, source.Genre, source.Director);
GO
PRINT 'Movies table seeded successfully.'

-- Seed data for Actors table using MERGE
PRINT 'Seeding Actors table...'
MERGE INTO Actors AS target
USING (VALUES
    ('Morgan Freeman', '1937-06-01'),
    ('Al Pacino', '1940-04-25'),
    ('Christian Bale', '1974-01-30'),
    ('Henry Fonda', '1905-05-16'),
    ('Liam Neeson', '1952-06-07')
) AS source (Name, BirthDate)
ON target.Name = source.Name
WHEN NOT MATCHED THEN
    INSERT (Name, BirthDate)
    VALUES (source.Name, source.BirthDate);
GO
PRINT 'Actors table seeded successfully.'

-- Seed data for MoviesActors table using MERGE
PRINT 'Seeding MoviesActors table...'
MERGE INTO MoviesActors AS target
USING (VALUES
    (1, 1), -- Morgan Freeman in The Shawshank Redemption
    (2, 2), -- Al Pacino in The Godfather
    (3, 3), -- Christian Bale in The Dark Knight
    (4, 4), -- Henry Fonda in 12 Angry Men
    (5, 5)  -- Liam Neeson in Schindler's List
) AS source (MovieID, ActorID)
ON target.MovieID = source.MovieID AND target.ActorID = source.ActorID
WHEN NOT MATCHED THEN
    INSERT (MovieID, ActorID)
    VALUES (source.MovieID, source.ActorID);
GO
PRINT 'MoviesActors table seeded successfully.'
