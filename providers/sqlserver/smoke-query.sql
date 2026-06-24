USE MoviesDB;
GO

SET NOCOUNT ON;

SELECT
    (SELECT COUNT(*) FROM Movies) AS MovieCount,
    (SELECT COUNT(*) FROM Actors) AS ActorCount,
    (SELECT COUNT(*) FROM MoviesActors) AS CastingCount;
GO
