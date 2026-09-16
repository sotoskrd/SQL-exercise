-- =========================================================
-- ΛΥΣΕΙΣ — Εξάσκηση SQL πάνω στη βάση Chinook
-- Μην κοιτάξεις πριν προσπαθήσεις μόνος/η σου!
-- =========================================================

-- ===== ΕΝΟΤΗΤΑ 1: SELECT / WHERE / ORDER BY =====

-- 1
SELECT Name FROM Artist ORDER BY Name;

-- 2
SELECT Name, Milliseconds FROM Track WHERE Milliseconds > 300000;

-- 3
SELECT * FROM Customer WHERE Country = 'Brazil';

-- 4
SELECT Name FROM Track WHERE Name LIKE '%Love%';

-- 5
SELECT Name, UnitPrice FROM Track ORDER BY UnitPrice DESC LIMIT 10;

-- 6
SELECT COUNT(DISTINCT GenreId) AS distinct_genres FROM Track;

-- 7
SELECT * FROM Customer WHERE Fax IS NULL;

-- 8
SELECT * FROM Album WHERE ArtistId = 1;

-- 9
SELECT t.Name, t.UnitPrice
FROM Track t
JOIN Genre g ON t.GenreId = g.GenreId
WHERE g.Name = 'Rock' AND t.UnitPrice > 0.99;

-- 10
SELECT * FROM Invoice WHERE Total BETWEEN 5 AND 10;

-- ===== ΕΝΟΤΗΤΑ 2: Aggregate / GROUP BY / HAVING =====

-- 11
SELECT g.Name AS Genre, COUNT(*) AS TrackCount
FROM Track t JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY TrackCount DESC;

-- 12
SELECT mt.Name AS MediaType, AVG(t.UnitPrice) AS AvgPrice
FROM Track t JOIN MediaType mt ON t.MediaTypeId = mt.MediaTypeId
GROUP BY mt.Name;

-- 13
SELECT BillingCountry, SUM(Total) AS TotalSales
FROM Invoice
GROUP BY BillingCountry
ORDER BY TotalSales DESC;

-- 14
SELECT g.Name AS Genre, COUNT(*) AS TrackCount
FROM Track t JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.Name
HAVING COUNT(*) > 100
ORDER BY TrackCount DESC;

-- 15
SELECT ar.Name AS Artist, COUNT(*) AS AlbumCount
FROM Album al JOIN Artist ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.Name
HAVING COUNT(*) >= 2
ORDER BY AlbumCount DESC;

-- 16
SELECT c.CustomerId, c.FirstName, c.LastName, SUM(i.Total) AS TotalSpent
FROM Customer c JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY TotalSpent DESC
LIMIT 1;

-- 17
SELECT g.Name AS Genre, MIN(t.Milliseconds) AS MinMs, MAX(t.Milliseconds) AS MaxMs
FROM Track t JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.Name;

-- 18
SELECT Country, COUNT(DISTINCT CustomerId) AS UniqueCustomers
FROM Customer
GROUP BY Country
ORDER BY UniqueCustomers DESC;

-- ===== ΕΝΟΤΗΤΑ 3: JOINs =====

-- 19
SELECT t.Name AS Track, al.Title AS Album, ar.Name AS Artist
FROM Track t
JOIN Album al ON t.AlbumId = al.AlbumId
JOIN Artist ar ON al.ArtistId = ar.ArtistId;

-- 20
SELECT c.CustomerId, c.FirstName, c.LastName
FROM Customer c
LEFT JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceId IS NULL;

-- 21
SELECT t.Name AS Track, SUM(il.Quantity) AS TotalSold
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
GROUP BY t.TrackId
ORDER BY TotalSold DESC
LIMIT 10;

-- 22 (self-join)
SELECT e.FirstName || ' ' || e.LastName AS Employee,
       m.FirstName || ' ' || m.LastName AS Manager
FROM Employee e
LEFT JOIN Employee m ON e.ReportsTo = m.EmployeeId;

-- 23
SELECT c.FirstName || ' ' || c.LastName AS Customer,
       e.FirstName || ' ' || e.LastName AS SupportRep
FROM Customer c
JOIN Employee e ON c.SupportRepId = e.EmployeeId;

-- 24
SELECT g.Name AS Genre, SUM(il.UnitPrice * il.Quantity) AS Revenue
FROM Genre g
JOIN Track t ON g.GenreId = t.GenreId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
GROUP BY g.Name
ORDER BY Revenue DESC;

-- 25
SELECT p.Name AS Playlist, t.Name AS Track
FROM Playlist p
JOIN PlaylistTrack pt ON p.PlaylistId = pt.PlaylistId
JOIN Track t ON pt.TrackId = t.TrackId
WHERE p.Name = 'Music';

-- 26 (edge case — expect 0 rows in Chinook, every album has tracks)
SELECT al.AlbumId, al.Title
FROM Album al
LEFT JOIN Track t ON al.AlbumId = t.AlbumId
WHERE t.TrackId IS NULL;

-- 27
SELECT ar.Name AS Artist, SUM(il.UnitPrice * il.Quantity) AS Revenue
FROM Artist ar
JOIN Album al ON ar.ArtistId = al.ArtistId
JOIN Track t ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY ar.Name
ORDER BY Revenue DESC
LIMIT 5;

-- ===== ΕΝΟΤΗΤΑ 4: Subqueries & Set Operations =====

-- 28
SELECT Name, UnitPrice
FROM Track
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Track);

-- 29
SELECT c.CustomerId, c.FirstName, c.LastName
FROM Customer c
WHERE EXISTS (
    SELECT 1 FROM Invoice i WHERE i.CustomerId = c.CustomerId AND i.Total > 10
);

-- 30
SELECT Genre, TrackCount FROM (
    SELECT g.Name AS Genre, COUNT(*) AS TrackCount
    FROM Track t JOIN Genre g ON t.GenreId = g.GenreId
    GROUP BY g.Name
) sub
ORDER BY TrackCount DESC
LIMIT 1;

-- 31 (correlated subquery)
SELECT ar.Name AS Artist,
       (SELECT t.Name
        FROM Track t
        JOIN Album al2 ON t.AlbumId = al2.AlbumId
        WHERE al2.ArtistId = ar.ArtistId
        ORDER BY t.UnitPrice DESC
        LIMIT 1) AS MostExpensiveTrack
FROM Artist ar;

-- 32
SELECT Name FROM Artist
WHERE ArtistId NOT IN (SELECT DISTINCT ArtistId FROM Album WHERE ArtistId IS NOT NULL);

-- 33
SELECT FirstName || ' ' || LastName AS FullName FROM Customer
UNION
SELECT FirstName || ' ' || LastName AS FullName FROM Employee;

-- ===== ΕΝΟΤΗΤΑ 5: CTEs, Window Functions, CASE, Dates =====

-- 34
WITH MonthlyRevenue AS (
    SELECT strftime('%Y-%m', InvoiceDate) AS YearMonth, SUM(Total) AS Revenue
    FROM Invoice
    GROUP BY YearMonth
)
SELECT * FROM MonthlyRevenue ORDER BY YearMonth;

-- 35
SELECT Genre, TrackName, SalesCount,
       ROW_NUMBER() OVER (PARTITION BY Genre ORDER BY SalesCount DESC) AS Rank
FROM (
    SELECT g.Name AS Genre, t.Name AS TrackName, SUM(il.Quantity) AS SalesCount
    FROM Track t
    JOIN Genre g ON t.GenreId = g.GenreId
    JOIN InvoiceLine il ON t.TrackId = il.TrackId
    GROUP BY t.TrackId
) sub;

-- 36
SELECT c.CustomerId, c.FirstName, c.LastName, SUM(i.Total) AS TotalSpent,
       RANK() OVER (ORDER BY SUM(i.Total) DESC) AS SpendRank
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId;

-- 37
WITH MonthlyRevenue AS (
    SELECT strftime('%Y-%m', InvoiceDate) AS YearMonth, SUM(Total) AS Revenue
    FROM Invoice
    GROUP BY YearMonth
)
SELECT YearMonth, Revenue,
       SUM(Revenue) OVER (ORDER BY YearMonth) AS RunningTotal
FROM MonthlyRevenue;

-- 38
SELECT Name, Milliseconds,
    CASE
        WHEN Milliseconds < 120000 THEN 'Short'
        WHEN Milliseconds BETWEEN 120000 AND 300000 THEN 'Medium'
        ELSE 'Long'
    END AS LengthCategory
FROM Track;

-- 39
SELECT strftime('%Y', InvoiceDate) AS Year, SUM(Total) AS TotalRevenue
FROM Invoice
GROUP BY Year
ORDER BY Year;

-- 40
WITH MonthlyRevenue AS (
    SELECT strftime('%Y-%m', InvoiceDate) AS YearMonth, SUM(Total) AS Revenue
    FROM Invoice
    GROUP BY YearMonth
)
SELECT YearMonth, Revenue,
       LAG(Revenue) OVER (ORDER BY YearMonth) AS PrevMonthRevenue,
       Revenue - LAG(Revenue) OVER (ORDER BY YearMonth) AS Diff
FROM MonthlyRevenue;

-- ===== BONUS / CHALLENGE =====

-- 41
WITH GenreRevenueByCountry AS (
    SELECT i.BillingCountry AS Country, g.Name AS Genre,
           SUM(il.UnitPrice * il.Quantity) AS Revenue,
           RANK() OVER (PARTITION BY i.BillingCountry ORDER BY SUM(il.UnitPrice * il.Quantity) DESC) AS rnk
    FROM Invoice i
    JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Genre g ON t.GenreId = g.GenreId
    GROUP BY i.BillingCountry, g.Name
)
SELECT Country, Genre, Revenue FROM GenreRevenueByCountry WHERE rnk <= 3
ORDER BY Country, rnk;

-- 42
WITH CustomerGenreSpend AS (
    SELECT c.CustomerId, c.FirstName, c.LastName, g.Name AS Genre,
           SUM(il.UnitPrice * il.Quantity) AS Spend,
           RANK() OVER (PARTITION BY c.CustomerId ORDER BY SUM(il.UnitPrice * il.Quantity) DESC) AS rnk
    FROM Customer c
    JOIN Invoice i ON c.CustomerId = i.CustomerId
    JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Genre g ON t.GenreId = g.GenreId
    GROUP BY c.CustomerId, g.Name
)
SELECT CustomerId, FirstName, LastName, Genre AS FavoriteGenre, Spend
FROM CustomerGenreSpend WHERE rnk = 1;

-- 43
SELECT e.EmployeeId, e.FirstName, e.LastName, SUM(i.Total) AS RevenueGenerated
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId
ORDER BY RevenueGenerated DESC;

-- 44
CREATE VIEW IF NOT EXISTS InvoiceSummary AS
SELECT i.InvoiceId, i.CustomerId, i.InvoiceDate, i.Total,
       COUNT(il.InvoiceLineId) AS NumTracks
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY i.InvoiceId;

SELECT * FROM InvoiceSummary ORDER BY Total DESC LIMIT 10;
