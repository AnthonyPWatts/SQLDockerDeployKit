SELECT 'Seeding Movies demo data' AS status;

INSERT INTO movies (title, release_year, genre, director)
VALUES
    ('The Shawshank Redemption', 1994, 'Drama', 'Frank Darabont'),
    ('The Godfather', 1972, 'Crime', 'Francis Ford Coppola'),
    ('The Dark Knight', 2008, 'Action', 'Christopher Nolan'),
    ('12 Angry Men', 1957, 'Crime', 'Sidney Lumet'),
    ('Schindler''s List', 1993, 'Biography', 'Steven Spielberg')
ON CONFLICT (title, release_year) DO NOTHING;

INSERT INTO actors (name, birth_date)
VALUES
    ('Morgan Freeman', '1937-06-01'),
    ('Al Pacino', '1940-04-25'),
    ('Christian Bale', '1974-01-30'),
    ('Henry Fonda', '1905-05-16'),
    ('Liam Neeson', '1952-06-07')
ON CONFLICT (name) DO NOTHING;

INSERT INTO movie_actors (movie_id, actor_id)
SELECT movies.id, actors.id
FROM (
    VALUES
        ('The Shawshank Redemption', 1994, 'Morgan Freeman'),
        ('The Godfather', 1972, 'Al Pacino'),
        ('The Dark Knight', 2008, 'Christian Bale'),
        ('12 Angry Men', 1957, 'Henry Fonda'),
        ('Schindler''s List', 1993, 'Liam Neeson')
) AS source(title, release_year, actor_name)
JOIN movies ON movies.title = source.title AND movies.release_year = source.release_year
JOIN actors ON actors.name = source.actor_name
ON CONFLICT DO NOTHING;

SELECT 'Movies demo data seeded' AS status;
