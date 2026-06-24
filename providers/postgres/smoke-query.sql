SELECT
    (SELECT COUNT(*) FROM movies) AS movie_count,
    (SELECT COUNT(*) FROM actors) AS actor_count,
    (SELECT COUNT(*) FROM movie_actors) AS casting_count;
