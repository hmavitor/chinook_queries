/* query #1: the five artists with more songs. */
SELECT
  a.Name Artist,
  COUNT(*) SongsQuantity
FROM Artist a
JOIN Album ab
  ON ab.ArtistId = a.ArtistId
JOIN Track t
  ON t.AlbumId = ab.AlbumId
JOIN Genre g
  ON t.GenreId = g.GenreId
WHERE g.Name = 'Rock'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

/* query #2: the average song duration per genre. */
SELECT
  g.Name Genre,
  ROUND(AVG(t.Milliseconds) * 1.66667E-5, 2) Minutes
FROM Track t
JOIN Genre g
  ON g.GenreId = t.GenreId
JOIN MediaType m
  ON t.MediaTypeId = m.MediaTypeId
WHERE m.Name != 'Protected MPEG-4 video file'
GROUP BY 1
ORDER BY 2;

/* query #3: the amount spend by best customers per country */
SELECT
  Country,
  FirstName,
  LastName,
  MAX(TotalSpent) TotalSpent
FROM (SELECT
  c.CustomerId,
  c.FirstName,
  c.LastName,
  i.BillingCountry Country,
  SUM(i.Total) TotalSpent
FROM Customer c
JOIN Invoice i
  ON c.CustomerId = i.CustomerId
GROUP BY 1) sub
GROUP BY 1
ORDER BY 4 DESC;

/* query #3: the most popular genre per country */
SELECT
  sub.Country,
  sub.Name,
  MAX(Purchase) Purchases
FROM (SELECT
  i.BillingCountry Country,
  g.Name,
  COUNT(*) Purchase
FROM Customer c
JOIN Invoice i
  ON i.CustomerId = c.CustomerId
JOIN InvoiceLine il
  ON il.InvoiceId = i.InvoiceId
JOIN Track t
  ON t.TrackId = il.TrackId
JOIN Genre g
  ON g.GenreId = t.GenreId
GROUP BY 1,
         2) sub
GROUP BY 1
ORDER BY 1;
