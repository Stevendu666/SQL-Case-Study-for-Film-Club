# Let Dara reserve all the films that Daniel has reserved.
USE film_club;
UPDATE Reserves
SET MemberID = (SELECT MemberID FROM Member WHERE Name = 'Dara')
WHERE MemberID = (SELECT MemberID FROM Member WHERE Name = 'Daniel');


# Delete the films with a purchase price above the average purchase price.
SET @avg_purchase_price = (SELECT AVG(PurchasePrice) FROM Film);
DELETE FROM Film
WHERE PurchasePrice > @avg_purchase_price;


SHOW CREATE TABLE performance;

ALTER TABLE performance
DROP FOREIGN KEY performance_ibfk_1;

ALTER TABLE performance
ADD CONSTRAINT performance_ibfk_1
  FOREIGN KEY (FilmID)
  REFERENCES Film(FilmID)
  ON DELETE CASCADE;

SHOW CREATE TABLE reserves;

ALTER TABLE reserves
DROP FOREIGN KEY reserves_ibfk_2;

ALTER TABLE reserves
ADD CONSTRAINT reserves_ibfk_2
  FOREIGN KEY (FilmID)
  REFERENCES Film(FilmID)
  ON DELETE CASCADE;


# Increase the purchase price of educational films by 10%.
UPDATE film
SET PurchasePrice = PurchasePrice * 1.1
WHERE kind = 'Educational';


# List the streets of Members who have reserved musical films.
SELECT DISTINCT m.street
FROM member m
JOIN reserves r ON m.MemberID = r.MemberID
JOIN film f ON r.FilmID = f.FilmID
WHERE f.Kind = 'Musical';


# Which foreign films name ends in “war”?
SELECT title
FROM film
WHERE kind = 'Foreign' AND title LIKE '%war';


# What is the highest purchase price of reserved films by kind?
SELECT Kind, MAX(PurchasePrice)
FROM Film f JOIN Reserves r ON f.FilmID = r.FilmID
GROUP BY Kind;


# List the Members’ name whose average purchase price for reserved films is greater than $400.
SELECT m.Name
FROM Member m
JOIN Reserves r ON m.MemberID = r.MemberID
JOIN Film f ON r.FilmID = f.FilmID
GROUP BY m.MemberID
HAVING AVG(f.PurchasePrice) > 400;



# How many members live in Dublin?
SELECT COUNT(*)FROM member
WHERE city = 'Dublin';


# Create a view to gather all members who live in Galway and reserved foreign film.
CREATE VIEW galway_foreign AS
SELECT m.Name, f.Title
FROM member m JOIN reserves r ON m.MemberID = r.MemberID
JOIN film f ON r.FilmID = f.FilmID
WHERE m.city = 'Galway' AND f.kind = 'Foreign';


# Using the view from the previous question to find out the member who lives in Galway and reserved expensive (purchase price > €400) foreign film.
SELECT Name
FROM galway_foreign
WHERE title IN (SELECT title FROM film WHERE kind='Foreign' AND PurchasePrice > 400);