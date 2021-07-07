/* 
 * 1. What are the last names and emails of all customer who made purchased in the store?
 */
SELECT LastName, Email
FROM customers JOIN invoices ON customers.CustomerId = invoices.CustomerId;
/*
 * 2. What are the names of each albums and the artist who created it? 
 */
SELECT DISTINCT albums.Title, artists.Name
FROM albums, artists
WHERE albums.ArtistId = artists.ArtistId AND artists.Name IS NOT NULL;
/*
 * 3. What are the total number of unique customers for each state, ordered alphabetically by state? 
 */
SELECT COUNT(DISTINCT customers.CustomerId)
FROM customers JOIN invoices ON customers.CustomerId = invoices.CustomerId
GROUP BY State
ORDER BY State;
/*
 * 3) -> if not include null state
 */
SELECT COUNT(DISTINCT customers.CustomerId)
FROM customers JOIN invoices ON customers.CustomerId = invoices.CustomerId
WHERE State IS NOT NULL
GROUP BY State
ORDER BY State;
/*
 * 4. Which states have more than 10 unique customers?
 */
SELECT State
FROM customers JOIN invoices ON customers.CustomerId = invoices.CustomerId
GROUP BY State
HAVING COUNT(DISTINCT customers.CustomerId) > 10;
/*
 * 4) -> if not include null state
 */
SELECT State
FROM customers JOIN invoices ON customers.CustomerId = invoices.CustomerId
WHERE State IS NOT NULL
GROUP BY State
HAVING COUNT(customers.CustomerId) > 10;
/*
 * 5. What are the names of the artists who made an album containing the substring "symphony" in the album title?
 */
SELECT Name
FROM artists JOIN albums ON artists.ArtistId = albums.ArtistId AND albums.Title LIKE '%symphony%';
/*
 * 6. What are the names of all artists who performed MPEG (video or audio) tracks in either the "Brazilian Music" or the "Grunge" playlists?
 */
SELECT Name
FROM artists
WHERE ArtistId IN (SELECT ArtistId
FROM albums
WHERE AlbumId IN (SELECT AlbumId
FROM tracks
WHERE MediaTypeId IN (SELECT MediaTypeId
    FROM media_types
    WHERE Name LIKE '%MPEG%') AND TrackId IN (SELECT TrackId
    FROM playlist_track
    WHERE PlaylistId IN (SELECT PlaylistId
    FROM playlists
    WHERE Name = 'Brazilian Music' OR Name = 'Grunge'))));
/*
 * 7. How many artists published at least 10 MPEG tracks?
 */
SELECT COUNT(artists.ArtistId)
FROM artists
WHERE artists.ArtistId IN (SELECT albums.ArtistId
FROM albums
WHERE albums.AlbumId IN (SELECT tracks.AlbumId
FROM tracks
WHERE tracks.MediaTypeId IN (SELECT media_types.MediaTypeId
FROM media_types
    INNER JOIN tracks ON tracks.MediaTypeId = media_types.MediaTypeId
    INNER JOIN albums ON albums.AlbumId = tracks.AlbumId
    INNER JOIN artists ON artists.ArtistId = albums.ArtistId
GROUP BY (artists.ArtistId)
HAVING COUNT(media_types.MediaTypeId) >= 10 AND media_types.Name LIKE '%MPEG%')));

/*
 * 8. What is the total length of each playlist in hours? 
 * List the playlist id and name of only those playlists that are longer than 2 hours, 
 * along with the length in hours rounded to two decimals.
 */
SELECT playlists.PlaylistId, playlists.Name, ROUND(SUM(Milliseconds) / 3600000, 2)
FROM playlists
    INNER JOIN playlist_track ON playlist_track.PlaylistId = playlists.PlaylistId
    INNER JOIN tracks ON tracks.TrackId = playlist_track.TrackId
GROUP BY (playlists.PlaylistId)
HAVING (ROUND(SUM(Milliseconds) / 3600000, 2)) > 2;
