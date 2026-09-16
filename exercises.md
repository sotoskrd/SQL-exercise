# Εξάσκηση SQL — Μια Ολόκληρη Μέρα με τη βάση Chinook 🎵

Βάση: `chinook.db` (SQLite) — ένα ψηφιακό μαγαζί μουσικής.

## Σχήμα βάσης (πίνακες & στήλες)

- **Artist**(ArtistId, Name)
- **Album**(AlbumId, Title, ArtistId)
- **Track**(TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
- **Genre**(GenreId, Name)
- **MediaType**(MediaTypeId, Name)
- **Playlist**(PlaylistId, Name)
- **PlaylistTrack**(PlaylistId, TrackId)
- **Invoice**(InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total)
- **InvoiceLine**(InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity)
- **Customer**(CustomerId, FirstName, LastName, Company, Address, City, State, Country, PostalCode, Phone, Fax, Email, SupportRepId)
- **Employee**(EmployeeId, LastName, FirstName, Title, ReportsTo, BirthDate, HireDate, Address, City, State, Country, PostalCode, Phone, Fax, Email)

**Βασικές σχέσεις:** Artist 1—N Album 1—N Track. Track N—1 Genre, N—1 MediaType. Track N—N Playlist (μέσω PlaylistTrack). Customer 1—N Invoice 1—N InvoiceLine N—1 Track. Customer N—1 Employee (SupportRepId). Employee 1—N Employee (ReportsTo, self-join).

Πρόγραμμα ενδεικτικό για μια μέρα εξάσκησης — μπορείς να το προσαρμόσεις στον ρυθμό σου. Δυσκολία: ⭐ εύκολο, ⭐⭐ μέτριο, ⭐⭐⭐ δύσκολο.

---

## Ενότητα 1 — Βασικά SELECT / WHERE / ORDER BY (⏱ ~1.5 ώρα)

1. ⭐ Επίλεξε όλα τα ονόματα καλλιτεχνών, ταξινομημένα αλφαβητικά.
2. ⭐ Βρες όλα τα tracks με διάρκεια πάνω από 5 λεπτά (Milliseconds > 300000).
3. ⭐ Βρες όλους τους πελάτες από τη χώρα `'Brazil'`.
4. ⭐ Βρες τα tracks των οποίων το όνομα περιέχει τη λέξη `"Love"`.
5. ⭐ Βρες τα 10 πιο ακριβά tracks (κατά UnitPrice φθίνουσα).
6. ⭐ Πόσα διαφορετικά (DISTINCT) genres υπάρχουν στη βάση;
7. ⭐⭐ Βρες τους πελάτες που ΔΕΝ έχουν καταχωρημένο Fax.
8. ⭐ Βρες όλα τα albums του καλλιτέχνη με ArtistId = 1.
9. ⭐⭐ Βρες tracks που ανήκουν στο genre `'Rock'` ΚΑΙ έχουν UnitPrice > 0.99.
10. ⭐⭐ Βρες τα invoices με Total ανάμεσα σε 5 και 10 (BETWEEN).

## Ενότητα 2 — Aggregate Functions & GROUP BY / HAVING (⏱ ~1.5 ώρα)

11. ⭐ Μέτρησε πόσα tracks υπάρχουν ανά genre.
12. ⭐⭐ Βρες τον μέσο όρο UnitPrice ανά MediaType.
13. ⭐⭐ Βρες το συνολικό άθροισμα πωλήσεων (SUM Total) ανά χώρα πελάτη (BillingCountry), φθίνουσα σειρά.
14. ⭐⭐ Βρες τα genres που έχουν πάνω από 100 tracks (HAVING).
15. ⭐⭐ Βρες τον αριθμό albums ανά καλλιτέχνη, ταξινομημένα φθίνουσα, μόνο για όσους έχουν ≥ 2 albums.
16. ⭐⭐ Ποιος πελάτης έχει το μεγαλύτερο συνολικό άθροισμα αγορών (SUM Total);
17. ⭐ Βρες την ελάχιστη και μέγιστη διάρκεια track ανά genre.
18. ⭐⭐ Μέτρησε τους μοναδικούς πελάτες (COUNT DISTINCT) ανά χώρα.

## Ενότητα 3 — JOINs (⏱ ~2 ώρες)

19. ⭐ INNER JOIN Track–Album–Artist: εμφάνισε τίτλο track, τίτλο album, όνομα καλλιτέχνη.
20. ⭐⭐ LEFT JOIN Customer–Invoice: βρες πελάτες που δεν έχουν κάνει ΚΑΜΙΑ αγορά.
21. ⭐⭐ JOIN Invoice–InvoiceLine–Track: βρες τα 10 tracks που πουλήθηκαν τις περισσότερες φορές (SUM Quantity).
22. ⭐⭐⭐ Self-JOIN στον πίνακα Employee: εμφάνισε κάθε υπάλληλο μαζί με το όνομα του manager του (ReportsTo).
23. ⭐⭐ JOIN Customer–Employee: εμφάνισε κάθε πελάτη με το όνομα του support rep του.
24. ⭐⭐⭐ JOIN 4 πινάκων (Genre–Track–InvoiceLine–Invoice): υπολόγισε τα συνολικά έσοδα ανά genre.
25. ⭐⭐ JOIN Playlist–PlaylistTrack–Track: εμφάνισε όλα τα tracks μιας συγκεκριμένης playlist (π.χ. `'Music'`).
26. ⭐⭐⭐ Βρες τα albums που δεν έχουν ΚΑΝΕΝΑ track (LEFT JOIN + IS NULL — edge case, μάλλον άδειο αποτέλεσμα, εξήγησε γιατί).
27. ⭐⭐⭐ Βρες το Top 5 artists με τα περισσότερα συνολικά έσοδα (πολλαπλό JOIN + GROUP BY + ORDER BY + LIMIT).

## Ενότητα 4 — Subqueries & Set Operations (⏱ ~1.5 ώρα)

28. ⭐⭐ Βρες tracks με UnitPrice πάνω από τον μέσο όρο όλων των tracks (subquery στο WHERE).
29. ⭐⭐ Βρες πελάτες που έχουν κάνει τουλάχιστον ένα invoice με Total > 10 (χρησιμοποίησε EXISTS).
30. ⭐⭐⭐ Χρησιμοποίησε subquery στο FROM: βρες το genre με τα περισσότερα tracks.
31. ⭐⭐⭐ Correlated subquery: για κάθε artist, βρες το ακριβότερο track του (μέσω των albums του).
32. ⭐⭐ Χρησιμοποίησε NOT IN: βρες artists που δεν έχουν κανένα album.
33. ⭐⭐ UNION: φτιάξε μία λίστα με ονόματα πελατών ΚΑΙ ονόματα υπαλλήλων σε μία στήλη `FullName`.

## Ενότητα 5 — CTEs, Window Functions, CASE, Ημερομηνίες (⏱ ~2 ώρες)

34. ⭐⭐ Χρησιμοποίησε `WITH` (CTE) για να υπολογίσεις τα συνολικά έσοδα ανά μήνα.
35. ⭐⭐⭐ `ROW_NUMBER()`: κατάταξε τα tracks μέσα σε κάθε genre κατά αριθμό πωλήσεων (φθίνουσα).
36. ⭐⭐⭐ `RANK()` ή `DENSE_RANK()`: κατάταξε τους πελάτες βάσει συνολικών αγορών τους.
37. ⭐⭐⭐ Running total: με `SUM() OVER (ORDER BY ...)` υπολόγισε το αθροιστικό έσοδο ανά μήνα.
38. ⭐⭐ `CASE WHEN`: κατηγοριοποίησε κάθε track σε `'Short'` (<2 λεπτά), `'Medium'` (2-5 λεπτά) ή `'Long'` (>5 λεπτά).
39. ⭐⭐ Ημερομηνίες: εξήγαγε το έτος από το InvoiceDate και βρες τα συνολικά έσοδα ανά έτος.
40. ⭐⭐⭐ `LAG()`: σύγκρινε τα έσοδα κάθε μήνα με τον προηγούμενο μήνα (διαφορά και ποσοστιαία μεταβολή).

## 🏆 Bonus / Challenge — Integrative (⏱ όσο αντέξεις)

41. ⭐⭐⭐ Βρες το Top-3 genre (βάσει εσόδων) για κάθε χώρα πελάτη ξεχωριστά (window function `RANK()` + φιλτράρισμα).
42. ⭐⭐⭐ Για κάθε πελάτη, βρες το "αγαπημένο" του genre (αυτό στο οποίο έχει ξοδέψει τα περισσότερα χρήματα).
43. ⭐⭐⭐ Βρες ποιος υπάλληλος (support rep) έφερε τα περισσότερα συνολικά έσοδα μέσα από τους πελάτες που εξυπηρετεί.
44. ⭐⭐⭐ Δημιούργησε ένα `VIEW` που να δείχνει, για κάθε invoice, το πλήθος tracks και το συνολικό ποσό — μετά κάνε ένα SELECT πάνω σε αυτό το view.

---

💡 **Συμβουλή:** Μην κοιτάξεις τις λύσεις πριν προσπαθήσεις μόνος/η σου τουλάχιστον 5-10 λεπτά σε κάθε ερώτημα. Αν κολλήσεις, ξεκίνα γράφοντας το SELECT και το FROM, μετά πρόσθεσε σταδιακά JOIN/WHERE/GROUP BY.

Οι λύσεις βρίσκονται στο `solutions.sql`. Το `python_connect.py` δείχνει πώς να τρέξεις αυτά τα queries μέσα από Python.
